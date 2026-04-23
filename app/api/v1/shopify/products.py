from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session, joinedload
from typing import List, Optional
from app.schemas.product import ProductResponse
from app.models.product import Product
from app.models.user import User
from app.db.database import get_db
from app.api.v1.auth import get_current_user

router = APIRouter()


@router.get("/", response_model=List[ProductResponse], summary="获取商品列表", description="查询所有商品，支持按店铺筛选")
async def get_products(
    store_id: Optional[int] = None,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    ## 获取商品列表
    
    查询所有商品信息，支持按店铺筛选和分页。
    
    **参数说明：**
    - **store_id**: 店铺 ID（可选，用于筛选）
    - **skip**: 跳过多少条记录（默认 0）
    - **limit**: 最多返回多少条（默认 100）
    
    **返回：** 商品列表（按抓取时间降序排列，最新爬取的在前，包含店铺名称）
    """
    # 使用 joinedload 预加载 store 关系，避免 N+1 查询问题
    query = db.query(Product).options(joinedload(Product.store))
    
    # 如果指定了 store_id，进行筛选
    if store_id:
        query = query.filter(Product.store_id == store_id)
    
    # 按抓取时间降序排列（最新爬取的在前，NULL 值排在最后）
    products = query.order_by(Product.captured_at.desc().nullslast()).offset(skip).limit(limit).all()
    
    # 手动添加 store_name 到每个商品
    result = []
    for product in products:
        product_dict = {
            "id": product.id,
            "store_id": product.store_id,
            "title": product.title,
            "url": product.url,
            "price": product.price,
            "currency": product.currency,
            "image_url": product.image_url,
            "category": product.category,
            "is_available": product.is_available,
            "last_available": product.last_available,
            "status_change_at": product.status_change_at,
            "last_stock": product.last_stock,
            "sales_estimate": product.sales_estimate,
            "captured_at": product.captured_at,
            "created_at": product.created_at,
            "updated_at": product.updated_at,
            "store_name": product.store.name if product.store else None
        }
        result.append(ProductResponse(**product_dict))
    
    return result


@router.get("/search", response_model=List[ProductResponse], summary="搜索商品", description="根据关键词搜索商品")
async def search_products(
    keyword: str = Query(..., description="搜索关键词", min_length=1),
    store_id: Optional[int] = Query(None, description="店铺 ID（可选）"),
    skip: int = Query(0, description="跳过多少条记录"),
    limit: int = Query(100, description="最多返回多少条"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    ## 搜索商品
    
    根据关键词搜索商品标题，支持模糊匹配。
    
    **参数说明：**
    - **keyword**: 搜索关键词（必填，至少 1 个字符）
    - **store_id**: 店铺 ID（可选，用于筛选）
    - **skip**: 跳过多少条记录（默认 0）
    - **limit**: 最多返回多少条（默认 100）
    
    **返回：** 匹配的商品列表（按相关度排序）
    """
    # 使用 joinedload 预加载 store 关系
    query = db.query(Product).options(joinedload(Product.store))
    
    # 模糊搜索商品标题
    query = query.filter(Product.title.ilike(f"%{keyword}%"))
    
    # 如果指定了 store_id，进行筛选
    if store_id:
        query = query.filter(Product.store_id == store_id)
    
    # 按抓取时间降序排列
    products = query.order_by(Product.captured_at.desc().nullslast()).offset(skip).limit(limit).all()
    
    # 手动添加 store_name 到每个商品
    result = []
    for product in products:
        product_dict = {
            "id": product.id,
            "store_id": product.store_id,
            "title": product.title,
            "url": product.url,
            "price": product.price,
            "currency": product.currency,
            "image_url": product.image_url,
            "category": product.category,
            "is_available": product.is_available,
            "last_available": product.last_available,
            "status_change_at": product.status_change_at,
            "last_stock": product.last_stock,
            "sales_estimate": product.sales_estimate,
            "captured_at": product.captured_at,
            "created_at": product.created_at,
            "updated_at": product.updated_at,
            "store_name": product.store.name if product.store else None
        }
        result.append(ProductResponse(**product_dict))
    
    return result


@router.get("/{product_id}", response_model=ProductResponse, summary="获取商品详情", description="根据 ID 查询单个商品的详细信息")
async def get_product(
    product_id: int, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    ## 获取单个商品详情
    
    根据商品 ID 查询详细信息。
    
    **参数说明：**
    - **product_id**: 商品 ID（必填）
    
    **返回：** 商品详细信息
    """
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="商品不存在")
    return product
