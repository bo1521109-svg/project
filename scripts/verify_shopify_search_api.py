"""
验证 Shopify 搜索 API 功能
"""
import sys
sys.path.insert(0, '/app')

from sqlalchemy import text
from app.db.database import engine


def verify_api():
    """验证 API 功能"""
    print("=" * 60)
    print("验证 Shopify 搜索 API 功能")
    print("=" * 60)
    
    with engine.connect() as conn:
        # 1. 检查数据是否存在
        print("\n1. 检查数据...")
        
        # 检查店铺数据
        result = conn.execute(text("""
            SELECT 
                COUNT(*) as total,
                COUNT(country_code) as with_country,
                COUNT(CASE WHEN sales_7d > 0 THEN 1 END) as with_sales_7d,
                COUNT(CASE WHEN sales_total > 0 THEN 1 END) as with_sales_total
            FROM store
        """))
        
        store_stats = result.fetchone()
        print(f"   店铺数据:")
        print(f"      - 总数: {store_stats[0]}")
        print(f"      - 有国家代码: {store_stats[1]} ({store_stats[1]/max(store_stats[0],1)*100:.1f}%)")
        print(f"      - 有近7天销量: {store_stats[2]} ({store_stats[2]/max(store_stats[0],1)*100:.1f}%)")
        print(f"      - 有总销量: {store_stats[3]} ({store_stats[3]/max(store_stats[0],1)*100:.1f}%)")
        
        # 检查商品数据
        result = conn.execute(text("""
            SELECT 
                COUNT(*) as total,
                COUNT(category_code) as with_category,
                COUNT(CASE WHEN sales_7d > 0 THEN 1 END) as with_sales_7d,
                COUNT(CASE WHEN sales_total > 0 THEN 1 END) as with_sales_total
            FROM product
        """))
        
        product_stats = result.fetchone()
        print(f"   商品数据:")
        print(f"      - 总数: {product_stats[0]}")
        print(f"      - 有类目代码: {product_stats[1]} ({product_stats[1]/max(product_stats[0],1)*100:.1f}%)")
        print(f"      - 有近7天销量: {product_stats[2]} ({product_stats[2]/max(product_stats[0],1)*100:.1f}%)")
        print(f"      - 有总销量: {product_stats[3]} ({product_stats[3]/max(product_stats[0],1)*100:.1f}%)")
        
        # 2. 测试筛选条件
        print("\n2. 测试筛选条件...")
        
        # 测试国家筛选
        result = conn.execute(text("""
            SELECT country_code, COUNT(*) as count
            FROM store
            WHERE country_code IS NOT NULL
            GROUP BY country_code
            ORDER BY count DESC
            LIMIT 5
        """))
        
        print(f"   店铺国家分布（Top 5）:")
        for row in result.fetchall():
            print(f"      - {row[0]}: {row[1]} 个店铺")
        
        # 测试类目筛选
        result = conn.execute(text("""
            SELECT category_code, COUNT(*) as count
            FROM product
            WHERE category_code IS NOT NULL
            GROUP BY category_code
            ORDER BY count DESC
            LIMIT 5
        """))
        
        print(f"   商品类目分布（Top 5）:")
        for row in result.fetchall():
            print(f"      - {row[0]}: {row[1]} 个商品")
        
        # 3. 测试排序
        print("\n3. 测试排序...")
        
        # 测试销量排序
        result = conn.execute(text("""
            SELECT name, sales_7d, sales_total
            FROM store
            WHERE sales_7d > 0 OR sales_total > 0
            ORDER BY sales_7d DESC
            LIMIT 5
        """))
        
        print(f"   店铺销量排序（Top 5 by sales_7d）:")
        for row in result.fetchall():
            print(f"      - {row[0][:30]:30} | 7天: {row[1]:6} | 总: {row[2]:6}")
        
        # 4. 验收标准检查
        print("\n4. 验收标准检查...")
        
        # 检查是否有可筛选的数据
        result = conn.execute(text("""
            SELECT COUNT(*) FROM store WHERE country_code IS NOT NULL
        """))
        stores_with_country = result.fetchone()[0]
        
        result = conn.execute(text("""
            SELECT COUNT(*) FROM product WHERE category_code IS NOT NULL
        """))
        products_with_category = result.fetchone()[0]
        
        print(f"   ✓ 可按国家筛选的店铺: {stores_with_country} 个")
        print(f"   ✓ 可按类目筛选的商品: {products_with_category} 个")
        
        if stores_with_country > 0 and products_with_category > 0:
            print(f"   ✅ 数据准备就绪，可以测试筛选功能")
        else:
            print(f"   ⚠️ 数据不足，建议先执行爬虫任务或配置任务维度")
    
    print("\n=" * 60)
    print("验证完成！")
    print("=" * 60)
    print("\n下一步:")
    print("  1. 启动后端服务: docker compose up -d")
    print("  2. 访问 Swagger 文档: http://localhost:8000/docs")
    print("  3. 测试店铺搜索: GET /api/v1/shopify/stores/search")
    print("  4. 测试商品搜索: GET /api/v1/shopify/products/search")
    print("\n测试示例:")
    print("  - 国家筛选: ?country_code=US")
    print("  - 类目筛选: ?category_code=beauty")
    print("  - 销量筛选: ?sales_total_min=10000")
    print("  - 排序: ?sort_by=sales_total&sort_order=desc")
    print("  - 未支持参数: ?rating=4.5 (应被忽略，不报错)")


if __name__ == "__main__":
    verify_api()
