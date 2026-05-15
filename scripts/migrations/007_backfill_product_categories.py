"""
数据库迁移脚本 007: 为现有商品补充类目标签
创建时间: 2026-05-15
角色: 数据库工程师
任务: 为没有类目标签的商品，根据其所属店铺的任务配置，补充类目标签

问题背景:
- 数据库中有 1146 个商品，只有 553 个有类目标签（48%）
- 还有 593 个商品（52%）没有类目标签
- 这些商品是在任务配置功能上线前爬取的

解决方案:
1. 查找所有没有 category_code 的商品
2. 根据商品所属店铺的 target_category_code，补充类目标签
3. 更新 data_source 为 'backfill'
"""
import sys
sys.path.insert(0, '/app')

from sqlalchemy import text
from app.db.database import engine


def upgrade():
    """执行迁移：为现有商品补充类目标签"""
    print("=" * 60)
    print("开始执行迁移: 007_backfill_product_categories")
    print("=" * 60)
    
    with engine.connect() as conn:
        # 1. 检查现有数据
        print("\n1. 检查现有数据...")
        result = conn.execute(text("""
            SELECT 
                COUNT(*) as total,
                COUNT(CASE WHEN category_code IS NOT NULL THEN 1 END) as has_category,
                COUNT(CASE WHEN category_code IS NULL THEN 1 END) as no_category
            FROM product
        """))
        
        row = result.fetchone()
        print(f"   总商品数: {row[0]}")
        print(f"   有类目标签: {row[1]} ({row[1]*100//row[0] if row[0] > 0 else 0}%)")
        print(f"   无类目标签: {row[2]} ({row[2]*100//row[0] if row[0] > 0 else 0}%)")
        
        # 2. 检查可以补充的商品数量
        print("\n2. 检查可以补充的商品数量...")
        result = conn.execute(text("""
            SELECT COUNT(*) as can_backfill
            FROM product p
            JOIN store s ON p.store_id = s.id
            WHERE p.category_code IS NULL
            AND s.target_category_code IS NOT NULL
        """))
        
        can_backfill = result.fetchone()[0]
        print(f"   可以补充类目的商品: {can_backfill}")
        
        if can_backfill == 0:
            print("\n   ⚠️ 没有可以补充的商品（店铺未配置 target_category_code）")
            print("   建议：为店铺配置 target_category_code 后重新运行此脚本")
            return
        
        # 3. 补充类目标签
        print("\n3. 补充类目标签...")
        result = conn.execute(text("""
            UPDATE product p
            SET 
                category_code = s.target_category_code,
                data_source = 'backfill',
                updated_at = NOW()
            FROM store s
            WHERE p.store_id = s.id
            AND p.category_code IS NULL
            AND s.target_category_code IS NOT NULL
        """))
        
        conn.commit()
        print(f"   ✓ 已补充 {result.rowcount} 个商品的类目标签")
        
        # 4. 验证结果
        print("\n4. 验证结果...")
        result = conn.execute(text("""
            SELECT 
                COUNT(*) as total,
                COUNT(CASE WHEN category_code IS NOT NULL THEN 1 END) as has_category,
                COUNT(CASE WHEN category_code IS NULL THEN 1 END) as no_category
            FROM product
        """))
        
        row = result.fetchone()
        print(f"   总商品数: {row[0]}")
        print(f"   有类目标签: {row[1]} ({row[1]*100//row[0] if row[0] > 0 else 0}%)")
        print(f"   无类目标签: {row[2]} ({row[2]*100//row[0] if row[0] > 0 else 0}%)")
        
        # 5. 按类目统计
        print("\n5. 按类目统计...")
        result = conn.execute(text("""
            SELECT 
                category_code,
                COUNT(*) as count,
                data_source
            FROM product
            WHERE category_code IS NOT NULL
            GROUP BY category_code, data_source
            ORDER BY count DESC
            LIMIT 20
        """))
        
        print("   " + "-" * 80)
        print(f"   {'类目代码':30} | {'数量':10} | {'数据来源':20}")
        print("   " + "-" * 80)
        for row in result.fetchall():
            print(f"   {row[0]:30} | {row[1]:10} | {row[2] or 'NULL':20}")
    
    print("\n=" * 60)
    print("迁移 007 执行完成！")
    print("=" * 60)
    print("\n修复内容:")
    print("  ✅ 为现有商品补充了类目标签")
    print("  ✅ 标记数据来源为 'backfill'")
    print("\n注意:")
    print("  ⚠️ 如果还有商品没有类目标签，说明其所属店铺未配置 target_category_code")
    print("  ⚠️ 建议：在爬虫任务管理中为店铺配置目标类目，然后重新爬取")


def downgrade():
    """回滚迁移：清除补充的类目标签"""
    print("=" * 60)
    print("开始回滚迁移: 007_backfill_product_categories")
    print("=" * 60)
    
    with engine.connect() as conn:
        print("\n清除补充的类目标签...")
        
        result = conn.execute(text("""
            UPDATE product
            SET 
                category_code = NULL,
                data_source = NULL,
                updated_at = NOW()
            WHERE data_source = 'backfill'
        """))
        
        conn.commit()
        print(f"✓ 已清除 {result.rowcount} 个商品的类目标签")
    
    print("\n=" * 60)
    print("迁移 007 回滚完成！")
    print("=" * 60)


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == "downgrade":
        downgrade()
    else:
        upgrade()
