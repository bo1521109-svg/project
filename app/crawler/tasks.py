"""
爬虫后台任务模块
"""
import asyncio
from datetime import datetime
from urllib.parse import urlparse, urlunparse
from app.core.logging_config import logger


async def crawl_task_async(store_id: int, store_url: str):
    """
    后台爬取任务（异步版本）
    
    超时控制：设置爬虫超时时间（如 60 秒）
    """
    from app.db.database import SessionLocal
    from app.models.store import Store
    from app.crawler.spiders.shopify import ShopifyCrawler
    
    # 清理URL
    def clean_url(url):
        try:
            parsed = urlparse(url)
            return urlunparse((parsed.scheme, parsed.netloc, parsed.path.rstrip('/'), '', '', ''))
        except:
            return url
    
    clean_store_url = clean_url(store_url)
    
    logger.info(f"🚀 后台任务启动 - 店铺 ID: {store_id}, URL: {clean_store_url}")
    if clean_store_url != store_url:
        logger.info(f"URL已清理，原始: {store_url}")
    
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
            
            # 直接调用异步方法（不需要 asyncio.run）
            logger.info(f"⏳ 开始爬取（超时 60 秒）...")
            result = await asyncio.wait_for(
                crawler.crawl_store(clean_store_url),
                timeout=60.0
            )
            
            logger.info(f"✅ 爬取完成，处理结果...")
            
            # 保存商品数据
            products = result.get("data", {}).get("products", [])
            logger.info(f"📦 获取到 {len(products)} 个商品，开始保存...")
            
            if len(products) > 0:
                crawler._save_products(products, store_id)
                logger.info(f"✓ 保存成功: 新增/更新了商品数据")
            else:
                logger.warning(f"⚠️ 未获取到商品，可能原因：")
                logger.warning(f"  1. 该网站不是Shopify平台")
                logger.warning(f"  2. 网站有反爬虫保护")
                logger.warning(f"  3. URL不正确或需要特殊处理")
            
            # 更新店铺状态
            store.is_crawling = False
            store.last_crawl_at = datetime.utcnow()
            store.status = "active"
            # 更新为清理后的URL
            if clean_store_url != store_url:
                store.url = clean_store_url
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
        # 关闭数据库连接
        logger.info(f"🔒 关闭数据库连接")
        db.close()
