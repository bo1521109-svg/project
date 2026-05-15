"""
数据库迁移脚本 008: 为店铺自动分配类目代码
创建时间: 2026-05-15
角色: 数据库工程师
任务: 根据店铺名称的关键词，自动为店铺分配 target_category_code

问题背景:
- 很多店铺没有配置 target_category_code
- 导致其商品无法被类目筛选
- 需要根据店铺名称自动推断类目

解决方案:
1. 定义关键词到类目的映射规则
2. 根据店铺名称匹配关键词
3. 自动分配 target_category_code
"""
import sys
sys.path.insert(0, '/app')

from sqlalchemy import text
from app.db.database import engine


# 关键词到类目的映射规则（只使用字典表中存在的类目代码）
CATEGORY_KEYWORDS = {
    # 美妆个护
    'beauty': ['美妆', '化妆', '护肤', '个护', 'beauty', 'skincare', 'makeup', '头发', '洗发', '护发', 'hair', '指甲', '美甲', 'nail'],
    
    # 保健
    'health': ['保健', '健康', 'health', 'wellness', '医疗', '医药', 'medical'],
    
    # 运动户外
    'sports': ['运动', '户外', 'sport', 'outdoor', 'fitness', '鞋', 'shoe'],
    
    # 文化（包含服装、配件等）
    'culture': ['女装', '女士', 'women', 'lady', '男装', '男士', 'men', '童装', '儿童', 'kids', 'children', 
                '饰品', '首饰', 'jewelry', 'accessory', '手表', 'watch', '包', 'bag',
                '居家', '家居', '日用', 'home', '厨房', 'kitchen',
                '食品', '饮料', 'food', 'drink', 'beverage',
                '汽车', '摩托', 'auto', 'car', 'motorcycle',
                '玩具', 'toy', '宠物', 'pet', '母婴', '婴儿', 'baby', 'maternity',
                '家具', 'furniture', '工具', 'tool', '办公', 'office',
                '数码', '电子', '手机', 'electronic', 'phone', 'digital'],
    
    # 虚拟商品
    'virtual': ['虚拟', 'virtual', '电信', 'telecom'],
}


def upgrade():
    """执行迁移：为店铺自动分配类目代码"""
    print("=" * 60)
    print("开始执行迁移: 008_auto_assign_store_categories")
    print("=" * 60)
    
    with engine.connect() as conn:
        # 1. 检查现有数据
        print("\n1. 检查现有数据...")
        result = conn.execute(text("""
            SELECT 
                COUNT(*) as total,
                COUNT(CASE WHEN target_category_code IS NOT NULL THEN 1 END) as has_category,
                COUNT(CASE WHEN target_category_code IS NULL THEN 1 END) as no_category
            FROM store
        """))
        
        row = result.fetchone()
        print(f"   总店铺数: {row[0]}")
        print(f"   已配置类目: {row[1]} ({row[1]*100//row[0] if row[0] > 0 else 0}%)")
        print(f"   未配置类目: {row[2]} ({row[2]*100//row[0] if row[0] > 0 else 0}%)")
        
        if row[2] == 0:
            print("\n   ✓ 所有店铺都已配置类目")
            return
        
        # 2. 获取所有未配置类目的店铺
        print("\n2. 获取未配置类目的店铺...")
        result = conn.execute(text("""
            SELECT id, name
            FROM store
            WHERE target_category_code IS NULL
            ORDER BY id
        """))
        
        stores = result.fetchall()
        print(f"   找到 {len(stores)} 个未配置类目的店铺")
        
        # 3. 根据关键词匹配类目
        print("\n3. 根据关键词匹配类目...")
        matched_count = 0
        unmatched_stores = []
        
        for store_id, store_name in stores:
            matched_category = None
            
            # 遍历所有类目的关键词
            for category_code, keywords in CATEGORY_KEYWORDS.items():
                for keyword in keywords:
                    if keyword.lower() in store_name.lower():
                        matched_category = category_code
                        break
                if matched_category:
                    break
            
            if matched_category:
                # 更新店铺的类目代码
                conn.execute(text("""
                    UPDATE store
                    SET target_category_code = :category_code
                    WHERE id = :store_id
                """), {"category_code": matched_category, "store_id": store_id})
                
                matched_count += 1
                print(f"   ✓ 店铺 {store_id} ({store_name}) -> {matched_category}")
            else:
                unmatched_stores.append((store_id, store_name))
        
        conn.commit()
        
        print(f"\n   匹配成功: {matched_count} 个店铺")
        print(f"   未匹配: {len(unmatched_stores)} 个店铺")
        
        if unmatched_stores:
            print("\n   未匹配的店铺（需要手动配置）:")
            for store_id, store_name in unmatched_stores[:10]:
                print(f"     - {store_id}: {store_name}")
            if len(unmatched_stores) > 10:
                print(f"     ... 还有 {len(unmatched_stores) - 10} 个")
        
        # 4. 验证结果
        print("\n4. 验证结果...")
        result = conn.execute(text("""
            SELECT 
                COUNT(*) as total,
                COUNT(CASE WHEN target_category_code IS NOT NULL THEN 1 END) as has_category,
                COUNT(CASE WHEN target_category_code IS NULL THEN 1 END) as no_category
            FROM store
        """))
        
        row = result.fetchone()
        print(f"   总店铺数: {row[0]}")
        print(f"   已配置类目: {row[1]} ({row[1]*100//row[0] if row[0] > 0 else 0}%)")
        print(f"   未配置类目: {row[2]} ({row[2]*100//row[0] if row[0] > 0 else 0}%)")
        
        # 5. 按类目统计
        print("\n5. 按类目统计...")
        result = conn.execute(text("""
            SELECT 
                target_category_code,
                COUNT(*) as count
            FROM store
            WHERE target_category_code IS NOT NULL
            GROUP BY target_category_code
            ORDER BY count DESC
            LIMIT 20
        """))
        
        print("   " + "-" * 60)
        print(f"   {'类目代码':30} | {'店铺数量':10}")
        print("   " + "-" * 60)
        for row in result.fetchall():
            print(f"   {row[0]:30} | {row[1]:10}")
    
    print("\n=" * 60)
    print("迁移 008 执行完成！")
    print("=" * 60)
    print("\n修复内容:")
    print(f"  ✅ 为 {matched_count} 个店铺自动分配了类目代码")
    print("\n后续步骤:")
    print("  1. 运行迁移 007，为商品补充类目标签")
    print("  2. 对于未匹配的店铺，手动在爬虫任务管理中配置类目")


def downgrade():
    """回滚迁移：清除自动分配的类目代码"""
    print("=" * 60)
    print("开始回滚迁移: 008_auto_assign_store_categories")
    print("=" * 60)
    
    print("\n⚠️ 警告：此操作将清除所有店铺的 target_category_code")
    print("⚠️ 包括手动配置的类目代码")
    print("\n如果只想清除自动分配的，请手动执行 SQL")
    
    # 不自动回滚，避免误操作
    print("\n已取消回滚")


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == "downgrade":
        downgrade()
    else:
        upgrade()
