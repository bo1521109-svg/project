from sqlalchemy import Column, Integer, String, Boolean, DateTime
from sqlalchemy.orm import declarative_base, relationship
from datetime import datetime

Base = declarative_base()


class Store(Base):
    """店铺表 - 存储独立站信息"""
    __tablename__ = "store"
    
    # 主键
    id = Column(Integer, primary_key=True, index=True, comment="主键")
    
    # 店铺基本信息
    name = Column(String(255), nullable=False, comment="店铺名")
    url = Column(String(500), unique=True, nullable=False, comment="唯一索引")
    platform = Column(String(50), default="shopify", comment="默认 shopify")
    country = Column(String(100), comment="国家")
    
    # 状态字段
    status = Column(String(20), default="active", comment="active/paused/error")
    is_crawling = Column(Boolean, default=False, comment="布尔值")
    
    # 时间戳
    last_crawl_at = Column(DateTime, nullable=True, comment="最后爬取时间")
    created_at = Column(DateTime, default=datetime.utcnow, comment="创建时间")
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, comment="更新时间")
    
    # 关系
    products = relationship("Product", back_populates="store")