"""
测试库存状态监控功能
验证 available 字段的提取和状态变化追踪
"""
import asyncio
from sqlalchemy.orm import Session
from app.db.database import SessionLocal
from app.crawler.spiders.shopify import ShopifyCrawler
from app.core.logging_config import logger


async def test_availability_tracking():
    """测试库存状态监控"""
    db: Session = SessionLocal()
    
    try:
        # 测试店铺 6 (coconutbowls)
        store_id = 6
        store_url = "https://coconutbowls.com"
        
        logger.info(f"开始测试店铺 {store_id}: {store_url}")
        
        # 创建爬虫实例
        crawler = ShopifyCrawler(db)
        
        # 执行爬取
        result = await crawler.crawl_store(store_url)
        
        if result.get("success"):
            products = result.get("data", {}).get("products", [])
            logger.info(f"✓ 爬取成功，获取 {len(products)} 个商品")
            
            # 显示前 5 个商品的 available 状态
            logger.info("\n前 5 个商品的库存状态：")
            for i, product in enumerate(products[:5], 1):
                title = product.get("title", "")
                is_available = product.get("is_available")
                status_text = "有货" if is_available is True else "无货" if is_available is False else "未知"
                logger.info(f"  {i}. {title}: {status_text}")
            
            # 保存到数据库
            crawler._save_products(products, store_id)
            
            # 查询数据库验证
            from app.models.product import Product
            saved_products = db.query(Product).filter(Product.store_id == store_id).limit(5).all()
            
            logger.info("\n数据库中的商品状态：")
            for product in saved_products:
                status_text = "有货" if product.is_available is True else "无货" if product.is_available is False else "未知"
                logger.info(f"  - {product.title}: {status_text}")
                logger.info(f"    last_available: {product.last_available}")
                logger.info(f"    status_change_at: {product.status_change_at}")
        else:
            logger.error(f"✗ 爬取失败: {result.get('error')}")
            
    except Exception as e:
        logger.error(f"测试失败: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()


if __name__ == "__main__":
    asyncio.run(test_availability_tracking())
