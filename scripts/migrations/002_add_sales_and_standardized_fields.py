"""
数据库迁移脚本 002: 为店铺表和商品表添加销量和标准化字段
创建时间: 2026-05-14
目的: 
1. 添加销量字段（近7天销量、总销量）
2. 添加标准化字段（platform_code, country_code, category_code）
3. 添加数据来源标记字段
4. 创建复合索引优化查询性能
"""
import sys
sys.path.insert(0, '/app')

from sqlalchemy import text
from app.db.database import engine


def upgrade():
    """执行升级迁移"""
    print("=" * 60)
    print("开始执行迁移: 002_add_sales_and_standardized_fields")
    print("=" * 60)
    
    with engine.connect() as conn:
        # 1. 为 store 表添加新字段
        print("\n1. 为 store 表添加新字段...")
        
        # 添加销量字段
        conn.execute(text("""
            ALTER TABLE store 
            ADD COLUMN IF NOT EXISTS sales_7d INTEGER DEFAULT 0,
            ADD COLUMN IF NOT EXISTS sales_total INTEGER DEFAULT 0
        """))
        print("  ✓ 添加销量字段")
        
        # 添加标准化字段
        conn.execute(text("""
            ALTER TABLE store 
            ADD COLUMN IF NOT EXISTS platform_code VARCHAR(50),
            ADD COLUMN IF NOT EXISTS country_code VARCHAR(10)
        """))
        print("  ✓ 添加标准化字段")
        
        # 添加数据来源标记
        conn.execute(text("""
            ALTER TABLE store 
            ADD COLUMN IF NOT EXISTS data_source VARCHAR(50)
        """))
        print("  ✓ 添加数据来源标记")
        
        # 2. 为 product 表添加新字段
        print("\n2. 为 product 表添加新字段...")
        
        # 添加销量字段
        conn.execute(text("""
            ALTER TABLE product 
            ADD COLUMN IF NOT EXISTS sales_7d INTEGER DEFAULT 0,
            ADD COLUMN IF NOT EXISTS sales_total INTEGER DEFAULT 0
        """))
        print("  ✓ 添加销量字段")
        
        # 添加标准化字段
        conn.execute(text("""
            ALTER TABLE product 
            ADD COLUMN IF NOT EXISTS category_code VARCHAR(100),
            ADD COLUMN IF NOT EXISTS platform_code VARCHAR(50)
        """))
        print("  ✓ 添加标准化字段")
        
        # 添加数据来源标记
        conn.execute(text("""
            ALTER TABLE product 
            ADD COLUMN IF NOT EXISTS data_source VARCHAR(50)
        """))
        print("  ✓ 添加数据来源标记")
        
        # 3. 添加外键约束
        print("\n3. 添加外键约束...")
        
        # store 表外键
        conn.execute(text("""
            ALTER TABLE store 
            ADD CONSTRAINT fk_store_platform 
            FOREIGN KEY (platform_code) REFERENCES dict_platform(code)
            ON DELETE SET NULL
        """))
        print("  ✓ store.platform_code → dict_platform.code")
        
        conn.execute(text("""
            ALTER TABLE store 
            ADD CONSTRAINT fk_store_country 
            FOREIGN KEY (country_code) REFERENCES dict_country(code)
            ON DELETE SET NULL
        """))
        print("  ✓ store.country_code → dict_country.code")
        
        # product 表外键
        conn.execute(text("""
            ALTER TABLE product 
            ADD CONSTRAINT fk_product_platform 
            FOREIGN KEY (platform_code) REFERENCES dict_platform(code)
            ON DELETE SET NULL
        """))
        print("  ✓ product.platform_code → dict_platform.code")
        
        conn.execute(text("""
            ALTER TABLE product 
            ADD CONSTRAINT fk_product_category 
            FOREIGN KEY (category_code) REFERENCES dict_category(code)
            ON DELETE SET NULL
        """))
        print("  ✓ product.category_code → dict_category.code")
        
        # 4. 创建复合索引
        print("\n4. 创建复合索引...")
        
        # store 表索引
        conn.execute(text("""
            CREATE INDEX IF NOT EXISTS idx_store_platform_country_sales 
            ON store(platform_code, country_code, sales_7d)
        """))
        print("  ✓ idx_store_platform_country_sales")
        
        conn.execute(text("""
            CREATE INDEX IF NOT EXISTS idx_store_sales_7d_desc 
            ON store(sales_7d DESC)
        """))
        print("  ✓ idx_store_sales_7d_desc")
        
        conn.execute(text("""
            CREATE INDEX IF NOT EXISTS idx_store_sales_total_desc 
            ON store(sales_total DESC)
        """))
        print("  ✓ idx_store_sales_total_desc")
        
        # product 表索引
        conn.execute(text("""
            CREATE INDEX IF NOT EXISTS idx_product_platform_category_sales 
            ON product(platform_code, category_code, sales_7d)
        """))
        print("  ✓ idx_product_platform_category_sales")
        
        conn.execute(text("""
            CREATE INDEX IF NOT EXISTS idx_product_store_available 
            ON product(store_id, is_available)
        """))
        print("  ✓ idx_product_store_available")
        
        conn.execute(text("""
            CREATE INDEX IF NOT EXISTS idx_product_sales_7d_desc 
            ON product(sales_7d DESC)
        """))
        print("  ✓ idx_product_sales_7d_desc")
        
        conn.execute(text("""
            CREATE INDEX IF NOT EXISTS idx_product_sales_total_desc 
            ON product(sales_total DESC)
        """))
        print("  ✓ idx_product_sales_total_desc")
        
        # 5. 迁移现有数据（将旧字段值复制到新字段）
        print("\n5. 迁移现有数据...")
        
        # 将 store.platform 映射到 platform_code
        conn.execute(text("""
            UPDATE store 
            SET platform_code = CASE 
                WHEN platform = 'shopify' THEN 'shopify'
                WHEN platform = 'tiktok' THEN 'tiktok'
                ELSE NULL 
            END
            WHERE platform_code IS NULL
        """))
        print("  ✓ 迁移 store.platform → platform_code")
        
        # 将 store.country 映射到 country_code（尽力而为）
        conn.execute(text("""
            UPDATE store 
            SET country_code = CASE 
                WHEN country IN ('US', 'ID', 'GB', 'VN', 'TH', 'MY', 'PH', 'ES', 'MX', 'DE', 'FR', 'IT', 'BR', 'JP', 'SG') THEN country
                WHEN country = '美国' THEN 'US'
                WHEN country = '印度尼西亚' THEN 'ID'
                WHEN country = '英国' THEN 'GB'
                WHEN country = '越南' THEN 'VN'
                WHEN country = '泰国' THEN 'TH'
                WHEN country = '马来西亚' THEN 'MY'
                WHEN country = '菲律宾' THEN 'PH'
                WHEN country = '西班牙' THEN 'ES'
                WHEN country = '墨西哥' THEN 'MX'
                WHEN country = '德国' THEN 'DE'
                WHEN country = '法国' THEN 'FR'
                WHEN country = '意大利' THEN 'IT'
                WHEN country = '巴西' THEN 'BR'
                WHEN country = '日本' THEN 'JP'
                WHEN country = '新加坡' THEN 'SG'
                ELSE NULL 
            END
            WHERE country_code IS NULL AND country IS NOT NULL
        """))
        print("  ✓ 迁移 store.country → country_code")
        
        conn.commit()
    
    print("\n=" * 60)
    print("迁移 002 执行完成！")
    print("=" * 60)
    print("\n重要提示:")
    print("1. 旧字段（platform, country, category）已保留，不影响现有查询")
    print("2. 新字段（platform_code, country_code, category_code）已添加外键约束")
    print("3. 销量字段（sales_7d, sales_total）默认值为 0")
    print("4. 已创建复合索引优化查询性能")
    print("5. 建议后续使用新字段进行查询和筛选")


def downgrade():
    """执行降级迁移（回滚）"""
    print("=" * 60)
    print("开始回滚迁移: 002_add_sales_and_standardized_fields")
    print("=" * 60)
    
    with engine.connect() as conn:
        print("\n1. 删除索引...")
        conn.execute(text("DROP INDEX IF EXISTS idx_store_platform_country_sales"))
        conn.execute(text("DROP INDEX IF EXISTS idx_store_sales_7d_desc"))
        conn.execute(text("DROP INDEX IF EXISTS idx_store_sales_total_desc"))
        conn.execute(text("DROP INDEX IF EXISTS idx_product_platform_category_sales"))
        conn.execute(text("DROP INDEX IF EXISTS idx_product_store_available"))
        conn.execute(text("DROP INDEX IF EXISTS idx_product_sales_7d_desc"))
        conn.execute(text("DROP INDEX IF EXISTS idx_product_sales_total_desc"))
        print("  ✓ 索引已删除")
        
        print("\n2. 删除外键约束...")
        conn.execute(text("ALTER TABLE store DROP CONSTRAINT IF EXISTS fk_store_platform"))
        conn.execute(text("ALTER TABLE store DROP CONSTRAINT IF EXISTS fk_store_country"))
        conn.execute(text("ALTER TABLE product DROP CONSTRAINT IF EXISTS fk_product_platform"))
        conn.execute(text("ALTER TABLE product DROP CONSTRAINT IF EXISTS fk_product_category"))
        print("  ✓ 外键约束已删除")
        
        print("\n3. 删除新增字段...")
        conn.execute(text("""
            ALTER TABLE store 
            DROP COLUMN IF EXISTS sales_7d,
            DROP COLUMN IF EXISTS sales_total,
            DROP COLUMN IF EXISTS platform_code,
            DROP COLUMN IF EXISTS country_code,
            DROP COLUMN IF EXISTS data_source
        """))
        print("  ✓ store 表字段已删除")
        
        conn.execute(text("""
            ALTER TABLE product 
            DROP COLUMN IF EXISTS sales_7d,
            DROP COLUMN IF EXISTS sales_total,
            DROP COLUMN IF EXISTS category_code,
            DROP COLUMN IF EXISTS platform_code,
            DROP COLUMN IF EXISTS data_source
        """))
        print("  ✓ product 表字段已删除")
        
        conn.commit()
    
    print("\n=" * 60)
    print("迁移 002 回滚完成！")
    print("=" * 60)


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == "downgrade":
        downgrade()
    else:
        upgrade()
