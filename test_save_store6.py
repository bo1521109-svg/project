#!/usr/bin/env python3
"""测试店铺 6 的爬虫并保存"""
import asyncio
import sys
sys.path.insert(0, '/app')

from app.db.database import SessionLocal
from app.crawler.spiders.shopify import ShopifyCrawler
from app.models.store import Store
from app.models.product import Product

async def test():
    db = SessionLocal()
    
    try:
        store = db.query(Store).filter(Store.id == 6).first()
        
        print(f"🏪 店铺: {store.name}")
        print(f"🔗 URL: {store.url}")
        print("-" * 60)
        
        # 先查看现有商品数
        existing_count = db.query(Product).filter(Product.store_id == 6).count()
        print(f"📊 数据库中现有商品数: {existing_count}")
        
        crawler = ShopifyCrawler(db)
        
        print("\n🚀 开始爬取...")
        result = await asyncio.wait_for(
            crawler.crawl_store(store.url),
            timeout=60.0
        )
        
        print(f"\n✅ 爬取完成")
        products = result.get("data", {}).get("products", [])
        print(f"📦 爬取到商品数量: {len(products)}")
        
        if products:
            print(f"\n💾 开始保存商品...")
            crawler._save_products(products, store.id)
            print(f"✅ 保存完成")
            
            # 再次查看商品数
            new_count = db.query(Product).filter(Product.store_id == 6).count()
            print(f"📊 保存后商品数: {new_count}")
            
            # 显示前 5 个商品
            saved_products = db.query(Product).filter(Product.store_id == 6).limit(5).all()
            print(f"\n前 5 个已保存商品:")
            for i, p in enumerate(saved_products, 1):
                print(f"  {i}. {p.title[:50]} - ${p.price} - {p.category}")
        
    except Exception as e:
        print(f"❌ 错误: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    asyncio.run(test())
