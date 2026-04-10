from sqlalchemy import Column, Integer, String, Float, ForeignKey, DateTime, Boolean
from sqlalchemy.orm import relationship
from datetime import datetime
from app.db.base import Base


class Product(Base):
    """商品表 - 存储商品信息"""
    __tablename__ = "product"
    
    # 主键
    id = Column(Integer, primary_key=True, index=True, comment="主键")
    
    # 外键
    store_id = Column(Integer, ForeignKey("store.id"), nullable=False, comment="外键")
    
    # 商品基本信息
    title = Column(String(500), nullable=False, comment="商品标题")
    url = Column(String(500), unique=True, nullable=False, comment="唯一索引")
    price = Column(Float, comment="价格")
    currency = Column(String(10), default="USD", comment="默认 USD")
    image_url = Column(String(500), comment="图片链接")
    category = Column(String(255), comment="商品类目")
    
    # 库存状态监控（基于 available 字段）
    is_available = Column(Boolean, nullable=True, comment="当前是否有货（True=有货，False=无货）")
    last_available = Column(Boolean, nullable=True, comment="上次爬取时的状态")
    status_change_at = Column(DateTime, nullable=True, comment="状态变化时间（从有货变无货，或反之）")
    
    # 销售数据（用于估算销量 - 已废弃，改用 available 状态监控）
    last_stock = Column(Integer, nullable=True, comment="上次库存数（用于计算销量）")
    sales_estimate = Column(Integer, default=0, comment="预估销量（昨日库存 - 今日库存）")
    
    # 时间戳
    captured_at = Column(DateTime, nullable=True, comment="抓取时间")
    created_at = Column(DateTime, default=datetime.utcnow, comment="创建时间")
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, comment="更新时间")
    
    # 关系
    store = relationship("Store", back_populates="products")
