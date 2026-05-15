from sqlalchemy import Column, Integer, String, Float, ForeignKey, DateTime, Boolean, Index
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
    
    # 类目和平台（标准化字段）
    category_code = Column(String(100), ForeignKey("dict_category.code"), nullable=True, comment="类目代码（外键到字典表）")
    platform_code = Column(String(50), ForeignKey("dict_platform.code"), nullable=True, comment="平台代码（外键到字典表）")
    
    # 兼容旧字段（保留不删除）
    category = Column(String(255), comment="商品类目（旧字段，兼容保留）")
    
    # 销量字段（新增）
    sales_7d = Column(Integer, default=0, comment="近7天销量")
    sales_total = Column(Integer, default=0, comment="总销量")
    
    # 数据来源标记
    data_source = Column(String(50), nullable=True, comment="数据来源标记（如：crawler, api, manual）")
    
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
    
    # 复合索引（为高频筛选加速）
    __table_args__ = (
        Index('idx_product_platform_category_sales', 'platform_code', 'category_code', 'sales_7d'),
        Index('idx_product_store_available', 'store_id', 'is_available'),
        Index('idx_product_sales_7d_desc', 'sales_7d'),
        Index('idx_product_sales_total_desc', 'sales_total'),
    )
