#!/usr/bin/env python3
"""
数据库迁移脚本：添加 last_stock 字段到 product 表

执行方式：
docker compose exec web python /app/add_last_stock_field.py
"""
import sys
sys.path.insert(0, '/app')

from app.db.database import SessionLocal, engine
from sqlalchemy import text

def add_last_stock_field():
    """添加 last_stock 字段"""
    db = SessionLocal()
    
    try:
        print("=" * 60)
        print("开始数据库迁移：添加 last_stock 字段")
        print("=" * 60)
        
        # 检查字段是否已存在
        check_sql = text("""
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_name='product' AND column_name='last_stock'
        """)
        
        result = db.execute(check_sql).fetchone()
        
        if result:
            print("✓ last_stock 字段已存在，无需添加")
            return
        
        # 添加 last_stock 字段
        alter_sql = text("""
            ALTER TABLE product 
            ADD COLUMN last_stock INTEGER NULL
        """)
        
        db.execute(alter_sql)
        
        # 添加字段注释（PostgreSQL 语法）
        comment_sql = text("""
            COMMENT ON COLUMN product.last_stock IS '上次库存数（用于计算销量）'
        """)
        
        db.execute(comment_sql)
        db.commit()
        
        print("✓ 成功添加 last_stock 字段")
        print("\n字段说明：")
        print("  - last_stock: 上次爬取时的库存数")
        print("  - sales_estimate: 预估销量 = last_stock - 当前库存")
        print("  - 第一次爬取时 last_stock 为当前库存，sales_estimate 为 0")
        print("  - 后续爬取时计算销量差值")
        print("=" * 60)
        
    except Exception as e:
        db.rollback()
        print(f"❌ 迁移失败: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    add_last_stock_field()
