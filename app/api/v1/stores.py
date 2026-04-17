from fastapi import APIRouter, Depends, HTTPException, status, BackgroundTasks, Query
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime
from app.schemas.store import StoreCreate, StoreResponse
from app.models.store import Store
from app.models.user import User
from app.db.database import get_db
from app.crawler.spiders.shopify import ShopifyCrawler
from app.core.logging_config import logger
from app.api.v1.auth import get_current_user

router = APIRouter()


@router.post("/", response_model=StoreResponse, status_code=status.HTTP_201_CREATED, summary="创建店铺", description="添加新的独立站店铺到系统")
async def create_store(
    store: StoreCreate, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    ## 创建新店铺
    
    添加一个新的独立站店铺到数据库。
    
    **参数说明：**
    - **name**: 店铺名称（必填）
    - **url**: 店铺网址（必填，唯一）
    - **platform**: 平台类型（默认 shopify）
    - **country**: 国家（可选）
    
    **返回：** 新创建的店铺完整信息
    """
    # 检查 URL 是否已存在
    existing_store = db.query(Store).filter(Store.url == store.url).first()
    if existing_store:
        raise HTTPException(status_code=400, detail="店铺 URL 已存在")
    
    # 创建新店铺
    new_store = Store(**store.model_dump())
    db.add(new_store)
    db.commit()
    db.refresh(new_store)
    
    logger.info(f"创建新店铺: {new_store.name} ({new_store.url})")
    return new_store


@router.get("/", response_model=List[StoreResponse], summary="获取店铺列表", description="查询所有店铺，支持分页")
async def get_stores(
    skip: int = 0, 
    limit: int = 100, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    ## 获取店铺列表
    
    查询所有店铺信息，支持分页。
    
    **参数说明：**
    - **skip**: 跳过多少条记录（默认 0）
    - **limit**: 最多返回多少条（默认 100）
    
    **返回：** 店铺列表
    """
    stores = db.query(Store).offset(skip).limit(limit).all()
    return stores


@router.get("/search", response_model=List[StoreResponse], summary="搜索店铺", description="根据关键词搜索店铺")
async def search_stores(
    keyword: str = Query(..., description="搜索关键词", min_length=1),
    skip: int = Query(0, description="跳过多少条记录"),
    limit: int = Query(100, description="最多返回多少条"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    ## 搜索店铺
    
    根据关键词搜索店铺名称或 URL，支持模糊匹配。
    
    **参数说明：**
    - **keyword**: 搜索关键词（必填，至少 1 个字符）
    - **skip**: 跳过多少条记录（默认 0）
    - **limit**: 最多返回多少条（默认 100）
    
    **返回：** 匹配的店铺列表
    """
    # 模糊搜索店铺名称或 URL
    stores = db.query(Store).filter(
        (Store.name.ilike(f"%{keyword}%")) | (Store.url.ilike(f"%{keyword}%"))
    ).offset(skip).limit(limit).all()
    
    return stores


@router.get("/{store_id}", response_model=StoreResponse, summary="获取店铺详情", description="根据 ID 查询单个店铺的详细信息")
async def get_store(
    store_id: int, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    ## 获取单个店铺详情
    
    根据店铺 ID 查询详细信息。
    
    **参数说明：**
    - **store_id**: 店铺 ID（必填）
    
    **返回：** 店铺详细信息
    """
    store = db.query(Store).filter(Store.id == store_id).first()
    if not store:
        raise HTTPException(status_code=404, detail="店铺不存在")
    return store


@router.post("/{store_id}/crawl", summary="触发爬取", description="开始爬取指定店铺的商品数据")
async def crawl_store(
    store_id: int, 
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    ## 触发店铺爬取
    
    开始爬取指定店铺的商品数据（后台任务）。
    
    **爬取策略：**
    1. 优先尝试 JSON API（速度快）
    2. 如果失败，使用 Playwright 抓取 HTML
    
    **状态更新：**
    - 爬取中：`is_crawling = True`
    - 完成后：`is_crawling = False`，更新 `last_crawl_at`
    
    **超时控制：** 60 秒
    
    **参数说明：**
    - **store_id**: 店铺 ID（必填）
    
    **返回：** 任务启动确认信息
    """
    # 获取店铺信息
    store = db.query(Store).filter(Store.id == store_id).first()
    if not store:
        raise HTTPException(status_code=404, detail="店铺不存在")
    
    # 检查是否正在爬取
    if store.is_crawling:
        raise HTTPException(status_code=400, detail="该店铺正在爬取中，请稍后再试")
    
    # 更新状态为爬取中
    store.is_crawling = True
    db.commit()
    
    logger.info(f"开始爬取店铺: {store.name} (ID: {store_id})")
    
    # 在后台任务中执行爬取（不传递 db，任务内部会创建新的 Session）
    background_tasks.add_task(
        _crawl_task,
        store_id=store_id,
        store_url=store.url
    )
    
    return {
        "message": "爬取任务已启动",
        "store_id": store_id,
        "status": "crawling"
    }


@router.delete("/{store_id}", summary="删除店铺", description="删除指定店铺及其关联的所有商品数据")
async def delete_store(
    store_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    ## 删除店铺
    
    删除指定店铺及其关联的所有商品数据。
    
    **注意：** 此操作会级联删除该店铺下的所有商品数据，不可恢复！
    
    **参数说明：**
    - **store_id**: 店铺 ID（必填）
    
    **返回：** 删除确认信息
    """
    from app.models.product import Product
    
    # 获取店铺信息
    store = db.query(Store).filter(Store.id == store_id).first()
    if not store:
        raise HTTPException(status_code=404, detail="店铺不存在")
    
    # 检查是否正在爬取
    if store.is_crawling:
        raise HTTPException(status_code=400, detail="店铺正在爬取中，无法删除")
    
    # 统计关联商品数量
    product_count = db.query(Product).filter(Product.store_id == store_id).count()
    
    # 删除关联的商品
    db.query(Product).filter(Product.store_id == store_id).delete()
    
    # 删除店铺
    store_name = store.name
    db.delete(store)
    db.commit()
    
    logger.info(f"删除店铺: {store_name} (ID: {store_id})，同时删除 {product_count} 个商品")
    
    return {
        "message": "店铺删除成功",
        "store_id": store_id,
        "store_name": store_name,
        "deleted_products": product_count
    }


def _crawl_task(store_id: int, store_url: str):
    """
    后台爬取任务（同步函数，内部运行异步代码）
    
    超时控制：设置爬虫超时时间（如 60 秒）
    """
    import asyncio
    from app.db.database import SessionLocal
    
    logger.info(f"🚀 后台任务启动 - 店铺 ID: {store_id}, URL: {store_url}")
    
    # 创建新的数据库会话（后台任务需要独立的 Session）
    db = SessionLocal()
    
    try:
        store = db.query(Store).filter(Store.id == store_id).first()
        
        if not store:
            logger.error(f"❌ 店铺 {store_id} 不存在")
            return
        
        logger.info(f"📍 找到店铺: {store.name}")
        
        try:
            # 创建爬虫实例
            logger.info(f"🔧 创建爬虫实例...")
            crawler = ShopifyCrawler(db)
            
            # 在同步函数中运行异步代码
            logger.info(f"⏳ 开始爬取（超时 60 秒）...")
            result = asyncio.run(
                asyncio.wait_for(
                    crawler.crawl_store(store_url),
                    timeout=60.0
                )
            )
            
            logger.info(f"✅ 爬取完成，处理结果...")
            
            # 保存商品数据
            products = result.get("data", {}).get("products", [])
            logger.info(f"📦 获取到 {len(products)} 个商品，开始保存...")
            crawler._save_products(products, store_id)
            
            # 更新店铺状态
            store.is_crawling = False
            store.last_crawl_at = datetime.utcnow()
            store.status = "active"
            db.commit()
            
            logger.info(f"✅ 店铺 {store_id} 爬取成功，共获取 {len(products)} 个商品")
            
        except asyncio.TimeoutError:
            # 超时处理
            store.is_crawling = False
            store.status = "error"
            db.commit()
            logger.error(f"⏰ 店铺 {store_id} 爬取超时")
            
        except Exception as e:
            # 异常处理：若爬虫失败（如被反爬拦截），捕获异常并记录日志
            store.is_crawling = False
            store.status = "error"
            db.commit()
            logger.error(f"❌ 店铺 {store_id} 爬取失败: {str(e)}")
            import traceback
            logger.error(f"详细错误:\n{traceback.format_exc()}")
            
    except Exception as e:
        logger.error(f"❌ 后台任务异常: {str(e)}")
        import traceback
        logger.error(f"详细错误:\n{traceback.format_exc()}")
    finally:
        # 关闭数据库会话
        logger.info(f"🔒 关闭数据库连接")
        db.close()
