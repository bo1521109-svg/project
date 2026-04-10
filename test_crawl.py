#!/usr/bin/env python3
"""测试爬虫功能"""
import asyncio
import sys
sys.path.insert(0, '/app')

from app.db.database import SessionLocal
from app.crawler.spiders.shopify import ShopifyCrawler
from app.models.store import Store

async def test_crawl():
    db = SessionLocal()
    
    try:
        # 获取第一个店铺
        store = db.query(Store).first()
        if not store:
            print("❌ 数据库中没有店铺")
            return
        
        print(f"📍 测试店铺: {store.name}")
        print(f"🔗 URL: {store.url}")
        print(f"🆔 ID: {store.id}")
        print("-" * 50)
        
        # 创建爬虫
        crawler = ShopifyCrawler(db)
        
        # 执行爬取
        print("🚀 开始爬取...")
        result = await crawler.crawl_store(store.url)
        
        print(f"✅ 爬取完成")
        print(f"📊 结果: {result.get('success')}")
        print(f"🔧 方法: {result.get('method')}")
        
        products = result.get("data", {}).get("products", [])
        print(f"📦 商品数量: {len(products)}")
        
        if products:
            print("\n前3个商品:")
            for i, p in enumerate(products[:3], 1):
                print(f"  {i}. {p.get('title')} - ${p.get('price')} - {p.get('category', 'N/A')}")
        
    except Exception as e:
        print(f"❌ 错误: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    asyncio.run(test_crawl())
