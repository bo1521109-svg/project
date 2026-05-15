"""
字典表模型 - 统一管理枚举值
用于标准化平台、国家、类目等配置
"""
from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, Text
from sqlalchemy.orm import relationship
from app.db.base import Base


class Platform(Base):
    """平台字典表"""
    __tablename__ = "dict_platform"
    
    id = Column(Integer, primary_key=True, index=True, comment="主键")
    code = Column(String(50), unique=True, nullable=False, index=True, comment="平台代码（如：shopify, tiktok）")
    name_zh = Column(String(100), nullable=False, comment="中文名称")
    name_en = Column(String(100), nullable=True, comment="英文名称")
    is_active = Column(Boolean, default=True, comment="是否启用")
    sort_order = Column(Integer, default=0, comment="排序顺序")
    description = Column(Text, nullable=True, comment="平台描述")
    
    def __repr__(self):
        return f"<Platform(code={self.code}, name_zh={self.name_zh})>"


class Country(Base):
    """国家字典表"""
    __tablename__ = "dict_country"
    
    id = Column(Integer, primary_key=True, index=True, comment="主键")
    code = Column(String(10), unique=True, nullable=False, index=True, comment="国家代码（ISO 3166-1，如：US, CN）")
    name_zh = Column(String(100), nullable=False, comment="中文名称")
    name_en = Column(String(100), nullable=False, comment="英文名称")
    region = Column(String(50), nullable=True, comment="区域分组（如：北美、东南亚）")
    is_active = Column(Boolean, default=True, comment="是否启用")
    sort_order = Column(Integer, default=0, comment="排序顺序")
    
    def __repr__(self):
        return f"<Country(code={self.code}, name_zh={self.name_zh})>"


class Category(Base):
    """类目字典表（树形结构）"""
    __tablename__ = "dict_category"
    
    id = Column(Integer, primary_key=True, index=True, comment="主键")
    code = Column(String(100), unique=True, nullable=False, index=True, comment="类目代码（如：beauty, beauty-makeup）")
    name_zh = Column(String(200), nullable=False, comment="中文名称")
    name_en = Column(String(200), nullable=True, comment="英文名称")
    parent_id = Column(Integer, ForeignKey("dict_category.id"), nullable=True, comment="父类目ID（NULL表示一级类目）")
    level = Column(Integer, default=1, comment="层级（1=一级类目，2=二级类目）")
    platform_code = Column(String(50), nullable=True, comment="所属平台（NULL表示全平台共用）")
    is_active = Column(Boolean, default=True, comment="是否启用")
    sort_order = Column(Integer, default=0, comment="排序顺序")
    
    # 自引用关系
    children = relationship("Category", backref="parent", remote_side=[id])
    
    def __repr__(self):
        return f"<Category(code={self.code}, name_zh={self.name_zh}, level={self.level})>"
