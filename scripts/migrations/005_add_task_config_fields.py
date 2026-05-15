"""
数据库迁移脚本 005: 添加任务配置字段
创建时间: 2026-05-15
角色: 爬虫工程师 / 后端开发
任务: 升级爬虫执行逻辑，让爬虫在抓取数据时，直接读取任务配置里的"目标国家"和"目标类目"，自动打标入库。

业务目标:
- 爬虫轻量化：爬虫只负责抓取原始数据，打标维度直接读取任务配置
- 配置即打标：任务里配了"美国 + 美妆"，爬到的数据就自动带这些维度
- 筛选立刻生效：新抓取的数据自动带标准化维度，前端筛选立刻能查出结果

核心逻辑:
1. 爬虫执行时读取任务配置
   - 读取该任务的"目标国家代码"和"目标类目ID"（前端已突破，存在数据库）
   - 如果任务未配置，则填"未知/未分类"兜底

2. 打标入库
   - 店铺数据：将任务配置的"国家代码"、"类目ID"写入对应字段
   - 商品数据：继承所属店铺的"国家/类目"维度
   - 销量字段：页面能解析出销量则填入，不能则填 0（不能填 NULL，不能报错，不中断）

3. 打标记录
   - 记录"打标来源"：统一标为 `task_config`（任务配置驱动）
   - 标记"是否人工复核过"：默认 `false`，便于后续优化

验收标准:
- ✅ 爬虫执行后，新入库的店铺/商品数据，"标准化国家"、"标准化类目"字段 100% 有值
- ✅ 前端筛选"国家=美国 + 类目=美妆"，能查出刚爬的任务数据
- ✅ 爬虫执行耗时增加 ≤5%（打标逻辑为简单赋值）
- ✅ 未配置维度的旧任务执行时，打标字段填兜底值，不报错、不中断
"""
import sys
sys.path.insert(0, '/app')

from sqlalchemy import text
from app.db.database import engine


def upgrade():
    """执行迁移：添加任务配置字段"""
    print("=" * 60)
    print("开始执行迁移: 005_add_task_config_fields")
    print("=" * 60)
    
    with engine.connect() as conn:
        print("\n1. 为 store 表添加任务配置字段...")
        
        # 添加任务配置字段
        conn.execute(text("""
            ALTER TABLE store
            ADD COLUMN IF NOT EXISTS target_country_code VARCHAR(10),
            ADD COLUMN IF NOT EXISTS target_category_code VARCHAR(100),
            ADD COLUMN IF NOT EXISTS is_manual_reviewed BOOLEAN DEFAULT FALSE
        """))
        
        # 添加外键约束
        conn.execute(text("""
            DO $$
            BEGIN
                IF NOT EXISTS (
                    SELECT 1 FROM pg_constraint WHERE conname = 'fk_store_target_country'
                ) THEN
                    ALTER TABLE store
                    ADD CONSTRAINT fk_store_target_country
                    FOREIGN KEY (target_country_code) REFERENCES dict_country(code);
                END IF;
                
                IF NOT EXISTS (
                    SELECT 1 FROM pg_constraint WHERE conname = 'fk_store_target_category'
                ) THEN
                    ALTER TABLE store
                    ADD CONSTRAINT fk_store_target_category
                    FOREIGN KEY (target_category_code) REFERENCES dict_category(code);
                END IF;
            END $$;
        """))
        
        # 添加注释
        conn.execute(text("""
            COMMENT ON COLUMN store.target_country_code IS '任务配置：目标国家代码';
            COMMENT ON COLUMN store.target_category_code IS '任务配置：目标类目代码';
            COMMENT ON COLUMN store.is_manual_reviewed IS '是否人工复核过';
        """))
        
        conn.commit()
        print("   ✓ store 表字段添加完成")
        
        print("\n2. 验证字段是否添加成功...")
        result = conn.execute(text("""
            SELECT column_name, data_type, is_nullable
            FROM information_schema.columns
            WHERE table_name = 'store'
            AND column_name IN ('target_country_code', 'target_category_code', 'is_manual_reviewed')
            ORDER BY column_name
        """))
        
        print("   " + "-" * 80)
        print(f"   {'字段名':30} | {'数据类型':20} | {'可为空':10}")
        print("   " + "-" * 80)
        for row in result.fetchall():
            print(f"   {row[0]:30} | {row[1]:20} | {row[2]:10}")
        
    print("\n=" * 60)
    print("迁移 005 执行完成！")
    print("=" * 60)
    print("\n功能说明:")
    print("  ✅ 爬虫执行时会读取任务配置的 target_country_code 和 target_category_code")
    print("  ✅ 自动打标到店铺和商品数据")
    print("  ✅ 前端筛选立刻生效")
    print("\n使用方法:")
    print("  1. 创建爬虫任务时，配置 target_country_code 和 target_category_code")
    print("  2. 执行爬虫任务，数据会自动打标")
    print("  3. 前端筛选时，可以按国家和类目筛选")


def downgrade():
    """回滚迁移：删除任务配置字段"""
    print("=" * 60)
    print("开始回滚迁移: 005_add_task_config_fields")
    print("=" * 60)
    
    with engine.connect() as conn:
        print("\n删除任务配置字段...")
        
        # 删除外键约束
        conn.execute(text("""
            ALTER TABLE store
            DROP CONSTRAINT IF EXISTS fk_store_target_country,
            DROP CONSTRAINT IF EXISTS fk_store_target_category
        """))
        
        # 删除字段
        conn.execute(text("""
            ALTER TABLE store
            DROP COLUMN IF EXISTS target_country_code,
            DROP COLUMN IF EXISTS target_category_code,
            DROP COLUMN IF EXISTS is_manual_reviewed
        """))
        
        conn.commit()
    
    print("✓ 任务配置字段已删除")
    print("\n=" * 60)
    print("迁移 005 回滚完成！")
    print("=" * 60)


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == "downgrade":
        downgrade()
    else:
        upgrade()
