from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Index
from sqlalchemy.orm import relationship
from datetime import datetime
from app.db.base import Base


class Store(Base):
    """店铺表 - 存储独立站信息"""
    __tablename__ = "store"
    
    # 主键
    id = Column(Integer, primary_key=True, index=True, comment="主键")
    
    # 店铺基本信息
    name = Column(String(255), nullable=False, comment="店铺名")
    url = Column(String(500), unique=True, nullable=False, comment="唯一索引")
    
    # 平台和国家（标准化字段）
    platform_code = Column(String(50), ForeignKey("dict_platform.code"), nullable=True, comment="平台代码（外键到字典表）")
    country_code = Column(String(10), ForeignKey("dict_country.code"), nullable=True, comment="国家代码（外键到字典表）")
    
    # 兼容旧字段（保留不删除）
    platform = Column(String(50), default="shopify", comment="平台（旧字段，兼容保留）")
    country = Column(String(100), comment="国家（旧字段，兼容保留）")
    
    # 销量字段（新增）
    sales_7d = Column(Integer, default=0, comment="近7天销量")
    sales_total = Column(Integer, default=0, comment="总销量")
    
    # 数据来源标记
    data_source = Column(String(50), nullable=True, comment="数据来源标记（如：crawler, api, manual）")
    
    # 任务配置字段（爬虫执行时读取）
    target_country_code = Column(String(10), ForeignKey("dict_country.code"), nullable=True, comment="任务配置：目标国家代码")
    target_category_code = Column(String(100), ForeignKey("dict_category.code"), nullable=True, comment="任务配置：目标类目代码")
    is_manual_reviewed = Column(Boolean, default=False, comment="是否人工复核过")
    
    # 状态字段
    status = Column(String(20), default="active", comment="active/paused/error")
    is_crawling = Column(Boolean, default=False, comment="布尔值")
    
    # 时间戳
    last_crawl_at = Column(DateTime, nullable=True, comment="最后爬取时间")
    created_at = Column(DateTime, default=datetime.utcnow, comment="创建时间")
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, comment="更新时间")
    
    # 关系
    products = relationship("Product", back_populates="store", cascade="all, delete-orphan")
    
    # 复合索引（为高频筛选加速）
    __table_args__ = (
        Index('idx_store_platform_country_sales', 'platform_code', 'country_code', 'sales_7d'),
        Index('idx_store_sales_7d_desc', 'sales_7d'),
        Index('idx_store_sales_total_desc', 'sales_total'),
    )