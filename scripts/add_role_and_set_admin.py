"""
添加用户角色字段并设置xiaxia为管理员
"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy import text
from app.db.database import engine

def add_role_column_and_set_admin():
    """添加role字段并设置xiaxia为管理员"""
    with engine.connect() as conn:
        # 检查role列是否存在
        result = conn.execute(text("""
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_name='users' AND column_name='role'
        """))
        
        if result.fetchone() is None:
            print("添加role字段...")
            # 添加role列，默认值为'user'
            conn.execute(text("""
                ALTER TABLE users 
                ADD COLUMN role VARCHAR(20) NOT NULL DEFAULT 'user'
            """))
            conn.commit()
            print("✓ role字段添加成功")
        else:
            print("✓ role字段已存在")
        
        # 设置xiaxia为管理员
        print("设置xiaxia为管理员...")
        result = conn.execute(text("""
            UPDATE users 
            SET role = 'admin' 
            WHERE username = 'xiaxia'
        """))
        conn.commit()
        
        if result.rowcount > 0:
            print(f"✓ 成功将xiaxia设置为管理员")
        else:
            print("⚠ 未找到xiaxia用户")
        
        # 验证结果
        result = conn.execute(text("""
            SELECT username, role 
            FROM users 
            WHERE username = 'xiaxia'
        """))
        user = result.fetchone()
        if user:
            print(f"✓ 验证成功: {user[0]} - {user[1]}")
        
        print("\n所有用户角色:")
        result = conn.execute(text("SELECT username, role FROM users"))
        for row in result:
            print(f"  - {row[0]}: {row[1]}")

if __name__ == "__main__":
    add_role_column_and_set_admin()
