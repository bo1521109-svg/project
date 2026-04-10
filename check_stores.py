#!/usr/bin/env python3
"""查看店铺信息"""
import sys
sys.path.insert(0, '/app')

from app.db.database import SessionLocal
from app.models.store import Store
from app.models.product import Product

db = SessionLocal()

try:
    print("=" * 60)
    print("店铺列表:")
    print("=" * 60)
    
    stores = db.query(Store).all()
    for store in stores:
        product_count = db.query(Product).filter(Product.store_id == store.id).count()
        print(f"\n🏪 店铺 ID: {store.id}")
        print(f"   名称: {store.name}")
        print(f"   URL: {store.url}")
        print(f"   状态: {store.status}")
        print(f"   正在爬取: {store.is_crawling}")
        print(f"   最后爬取: {store.last_crawl_at}")
        print(f"   商品数量: {product_count}")
    
    print("\n" + "=" * 60)
    
finally:
    db.close()
