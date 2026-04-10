#!/usr/bin/env python3
"""测试店铺 6 的爬虫"""
import asyncio
import sys
sys.path.insert(0, '/app')

from app.db.database import SessionLocal
from app.crawler.spiders.shopify import ShopifyCrawler
from app.models.store import Store

async def test():
    db = SessionLocal()
    
    try:
        store = db.query(Store).filter(Store.id == 6).first()
        
        print(f"🏪 店铺: {store.name}")
        print(f"🔗 URL: {store.url}")
        print("-" * 60)
        
        crawler = ShopifyCrawler(db)
        
        print("🚀 开始爬取...")
        result = await asyncio.wait_for(
            crawler.crawl_store(store.url),
            timeout=60.0
        )
        
        print(f"\n✅ 爬取完成")
        print(f"📊 成功: {result.get('success')}")
        print(f"🔧 方法: {result.get('method')}")
        
        products = result.get("data", {}).get("products", [])
        print(f"📦 商品数量: {len(products)}")
        
        if products:
            print(f"\n前 5 个商品:")
            for i, p in enumerate(products[:5], 1):
                print(f"  {i}. {p.get('title')[:50]} - ${p.get('price')} - {p.get('category', 'N/A')}")
        else:
            print("\n⚠️ 没有获取到商品数据")
            print(f"完整结果: {result}")
        
    except asyncio.TimeoutError:
        print("❌ 超时")
    except Exception as e:
        print(f"❌ 错误: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    asyncio.run(test())
