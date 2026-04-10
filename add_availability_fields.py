"""
数据库迁移脚本：添加库存状态字段
为 Product 表添加 is_available、last_available、status_change_at 字段
"""
from sqlalchemy import create_engine, text
from app.core.config import settings

def add_availability_fields():
    """添加库存状态相关字段"""
    engine = create_engine(settings.DATABASE_URL)
    
    with engine.connect() as conn:
        # 开始事务
        trans = conn.begin()
        
        try:
            # 1. 添加 is_available 字段（布尔型，当前是否有货）
            print("添加 is_available 字段...")
            conn.execute(text("""
                ALTER TABLE product 
                ADD COLUMN IF NOT EXISTS is_available BOOLEAN DEFAULT NULL
            """))
            
            # 2. 添加 last_available 字段（布尔型，上次爬取时的状态）
            print("添加 last_available 字段...")
            conn.execute(text("""
                ALTER TABLE product 
                ADD COLUMN IF NOT EXISTS last_available BOOLEAN DEFAULT NULL
            """))
            
            # 3. 添加 status_change_at 字段（时间戳，状态变化时间）
            print("添加 status_change_at 字段...")
            conn.execute(text("""
                ALTER TABLE product 
                ADD COLUMN IF NOT EXISTS status_change_at TIMESTAMP DEFAULT NULL
            """))
            
            # 提交事务
            trans.commit()
            print("✓ 所有字段添加成功！")
            
            # 验证字段是否添加成功
            result = conn.execute(text("""
                SELECT column_name, data_type, is_nullable 
                FROM information_schema.columns 
                WHERE table_name = 'product' 
                AND column_name IN ('is_available', 'last_available', 'status_change_at')
            """))
            
            print("\n字段验证：")
            for row in result:
                print(f"  - {row[0]}: {row[1]} (nullable: {row[2]})")
                
        except Exception as e:
            trans.rollback()
            print(f"✗ 迁移失败: {e}")
            raise

if __name__ == "__main__":
    add_availability_fields()
