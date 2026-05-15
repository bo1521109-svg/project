"""
数据库迁移脚本 001: 添加字典表
创建时间: 2026-05-14
目的: 添加平台、国家、类目字典表，用于标准化枚举值管理
"""
import sys
sys.path.insert(0, '/app')

from sqlalchemy import text
from app.db.database import engine
from app.models.dictionary import Platform, Country, Category
from app.db.base import Base


def upgrade():
    """执行升级迁移"""
    print("=" * 60)
    print("开始执行迁移: 001_add_dictionary_tables")
    print("=" * 60)
    
    # 创建字典表
    print("\n1. 创建字典表...")
    Base.metadata.create_all(bind=engine, tables=[
        Platform.__table__,
        Country.__table__,
        Category.__table__
    ])
    print("✓ 字典表创建完成")
    
    # 初始化平台数据
    print("\n2. 初始化平台数据...")
    with engine.connect() as conn:
        platforms = [
            {'code': 'shopify', 'name_zh': 'Shopify独立站', 'name_en': 'Shopify', 'is_active': True, 'sort_order': 1},
            {'code': 'tiktok', 'name_zh': 'TikTok电商', 'name_en': 'TikTok', 'is_active': True, 'sort_order': 2},
            {'code': 'content', 'name_zh': '内容创作', 'name_en': 'Content Creation', 'is_active': True, 'sort_order': 3},
        ]
        
        for platform in platforms:
            conn.execute(text("""
                INSERT INTO dict_platform (code, name_zh, name_en, is_active, sort_order)
                VALUES (:code, :name_zh, :name_en, :is_active, :sort_order)
                ON CONFLICT (code) DO NOTHING
            """), platform)
        conn.commit()
    print("✓ 平台数据初始化完成")
    
    # 初始化国家数据
    print("\n3. 初始化国家数据...")
    with engine.connect() as conn:
        countries = [
            {'code': 'US', 'name_zh': '美国', 'name_en': 'United States', 'region': '北美', 'sort_order': 1},
            {'code': 'ID', 'name_zh': '印度尼西亚', 'name_en': 'Indonesia', 'region': '东南亚', 'sort_order': 2},
            {'code': 'GB', 'name_zh': '英国', 'name_en': 'United Kingdom', 'region': '欧洲', 'sort_order': 3},
            {'code': 'VN', 'name_zh': '越南', 'name_en': 'Vietnam', 'region': '东南亚', 'sort_order': 4},
            {'code': 'TH', 'name_zh': '泰国', 'name_en': 'Thailand', 'region': '东南亚', 'sort_order': 5},
            {'code': 'MY', 'name_zh': '马来西亚', 'name_en': 'Malaysia', 'region': '东南亚', 'sort_order': 6},
            {'code': 'PH', 'name_zh': '菲律宾', 'name_en': 'Philippines', 'region': '东南亚', 'sort_order': 7},
            {'code': 'ES', 'name_zh': '西班牙', 'name_en': 'Spain', 'region': '欧洲', 'sort_order': 8},
            {'code': 'MX', 'name_zh': '墨西哥', 'name_en': 'Mexico', 'region': '拉美', 'sort_order': 9},
            {'code': 'DE', 'name_zh': '德国', 'name_en': 'Germany', 'region': '欧洲', 'sort_order': 10},
            {'code': 'FR', 'name_zh': '法国', 'name_en': 'France', 'region': '欧洲', 'sort_order': 11},
            {'code': 'IT', 'name_zh': '意大利', 'name_en': 'Italy', 'region': '欧洲', 'sort_order': 12},
            {'code': 'BR', 'name_zh': '巴西', 'name_en': 'Brazil', 'region': '拉美', 'sort_order': 13},
            {'code': 'JP', 'name_zh': '日本', 'name_en': 'Japan', 'region': '东亚', 'sort_order': 14},
            {'code': 'SG', 'name_zh': '新加坡', 'name_en': 'Singapore', 'region': '东南亚', 'sort_order': 15},
        ]
        
        for country in countries:
            conn.execute(text("""
                INSERT INTO dict_country (code, name_zh, name_en, region, is_active, sort_order)
                VALUES (:code, :name_zh, :name_en, :region, TRUE, :sort_order)
                ON CONFLICT (code) DO NOTHING
            """), country)
        conn.commit()
    print("✓ 国家数据初始化完成（15个国家）")
    
    print("\n=" * 60)
    print("迁移 001 执行完成！")
    print("=" * 60)


def downgrade():
    """执行降级迁移（回滚）"""
    print("=" * 60)
    print("开始回滚迁移: 001_add_dictionary_tables")
    print("=" * 60)
    
    with engine.connect() as conn:
        print("\n删除字典表...")
        conn.execute(text("DROP TABLE IF EXISTS dict_category CASCADE"))
        conn.execute(text("DROP TABLE IF EXISTS dict_country CASCADE"))
        conn.execute(text("DROP TABLE IF EXISTS dict_platform CASCADE"))
        conn.commit()
    
    print("✓ 字典表已删除")
    print("\n=" * 60)
    print("迁移 001 回滚完成！")
    print("=" * 60)


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == "downgrade":
        downgrade()
    else:
        upgrade()
