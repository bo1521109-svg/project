"""
数据库迁移脚本 006: 修复 NULL 值并添加约束
创建时间: 2026-05-15
角色: 数据库工程师
任务: 修复 store 表中的 NULL 值，并添加 NOT NULL 约束，防止将来出现类似问题

问题背景:
- store 表中有些记录的 status 和 is_crawling 字段为 NULL
- 导致 API 响应验证失败（500 错误）
- 需要修复现有数据并添加约束

解决方案:
1. 修复现有 NULL 值
2. 添加 NOT NULL 约束
3. 设置默认值
"""
import sys
sys.path.insert(0, '/app')

from sqlalchemy import text
from app.db.database import engine


def upgrade():
    """执行迁移：修复 NULL 值并添加约束"""
    print("=" * 60)
    print("开始执行迁移: 006_fix_null_values_and_add_constraints")
    print("=" * 60)
    
    with engine.connect() as conn:
        # 1. 检查现有数据
        print("\n1. 检查现有数据...")
        result = conn.execute(text("""
            SELECT 
                COUNT(*) as total,
                COUNT(CASE WHEN status IS NULL THEN 1 END) as null_status,
                COUNT(CASE WHEN is_crawling IS NULL THEN 1 END) as null_is_crawling
            FROM store
        """))
        
        row = result.fetchone()
        print(f"   总记录数: {row[0]}")
        print(f"   status 为 NULL: {row[1]}")
        print(f"   is_crawling 为 NULL: {row[2]}")
        
        # 2. 修复 NULL 值
        if row[1] > 0 or row[2] > 0:
            print("\n2. 修复 NULL 值...")
            conn.execute(text("""
                UPDATE store
                SET 
                    status = COALESCE(status, 'active'),
                    is_crawling = COALESCE(is_crawling, false)
                WHERE status IS NULL OR is_crawling IS NULL
            """))
            print(f"   ✓ 已修复 {max(row[1], row[2])} 条记录")
        else:
            print("\n2. 无需修复（没有 NULL 值）")
        
        # 3. 添加 NOT NULL 约束
        print("\n3. 添加 NOT NULL 约束...")
        
        # 先设置默认值，再添加 NOT NULL 约束
        conn.execute(text("""
            ALTER TABLE store
            ALTER COLUMN status SET DEFAULT 'active',
            ALTER COLUMN is_crawling SET DEFAULT false
        """))
        
        # 添加 NOT NULL 约束
        conn.execute(text("""
            ALTER TABLE store
            ALTER COLUMN status SET NOT NULL,
            ALTER COLUMN is_crawling SET NOT NULL
        """))
        
        conn.commit()
        print("   ✓ 已添加 NOT NULL 约束")
        
        # 4. 验证结果
        print("\n4. 验证结果...")
        result = conn.execute(text("""
            SELECT 
                column_name,
                is_nullable,
                column_default
            FROM information_schema.columns
            WHERE table_name = 'store'
            AND column_name IN ('status', 'is_crawling')
            ORDER BY column_name
        """))
        
        print("   " + "-" * 80)
        print(f"   {'字段名':20} | {'可为空':10} | {'默认值':30}")
        print("   " + "-" * 80)
        for row in result.fetchall():
            print(f"   {row[0]:20} | {row[1]:10} | {row[2] or 'NULL':30}")
    
    print("\n=" * 60)
    print("迁移 006 执行完成！")
    print("=" * 60)
    print("\n修复内容:")
    print("  ✅ 修复了 status 和 is_crawling 字段的 NULL 值")
    print("  ✅ 添加了 NOT NULL 约束")
    print("  ✅ 设置了默认值（status='active', is_crawling=false）")
    print("\n影响:")
    print("  ✅ 解决了 API 响应验证失败的问题（500 错误）")
    print("  ✅ 防止将来插入 NULL 值")


def downgrade():
    """回滚迁移：移除 NOT NULL 约束"""
    print("=" * 60)
    print("开始回滚迁移: 006_fix_null_values_and_add_constraints")
    print("=" * 60)
    
    with engine.connect() as conn:
        print("\n移除 NOT NULL 约束...")
        
        conn.execute(text("""
            ALTER TABLE store
            ALTER COLUMN status DROP NOT NULL,
            ALTER COLUMN is_crawling DROP NOT NULL
        """))
        
        conn.commit()
    
    print("✓ 已移除 NOT NULL 约束")
    print("\n=" * 60)
    print("迁移 006 回滚完成！")
    print("=" * 60)


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == "downgrade":
        downgrade()
    else:
        upgrade()
