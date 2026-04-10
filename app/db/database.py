from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.db.base import Base
import os

# 从环境变量读取数据库连接地址
# 关键配置：默认连接地址应适配 Docker 环境，主机名为 db（对应 docker-compose 中的服务名），而不是 localhost
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://myuser:mypassword@db:5432/ecommerce_db")

# 创建数据库引擎
engine = create_engine(DATABASE_URL, echo=True)

# 创建会话工厂
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def get_db():
    """
    依赖函数，用于在 API 中注入数据库会话。
    使用 yield 确保请求结束后自动关闭会话。
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
