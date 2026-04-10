"""
数据库 Base 类定义
独立文件避免循环导入
"""
from sqlalchemy.orm import declarative_base

Base = declarative_base()
