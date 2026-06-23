"""
建站模块 - 站点数据模型
"""
from sqlalchemy import Column, Integer, String, Float, Boolean, DateTime, Text, ForeignKey
from sqlalchemy.sql import func
from app.db.base import Base


class Website(Base):
    """站点表 - 存储用户创建的独立站信息"""
    __tablename__ = "websites"

    id = Column(Integer, primary_key=True, index=True, comment="站点ID")
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, comment="创建者ID")

    # 基本信息
    name = Column(String(200), nullable=False, comment="站点名称")
    domain = Column(String(500), nullable=True, comment="绑定的域名")
    industry = Column(String(100), nullable=True, comment="所属行业")

    # 模板
    template_id = Column(Integer, nullable=True, comment="使用的模板ID")
    template_name = Column(String(200), nullable=True, comment="模板名称")

    # 状态: draft / published / paused
    status = Column(String(20), default="draft", comment="站点状态")

    # 统计数据
    visits = Column(Integer, default=0, comment="总访问量")
    orders = Column(Integer, default=0, comment="总订单数")
    conversion_rate = Column(Float, default=0.0, comment="转化率(%)")
    avg_order_value = Column(Float, default=0.0, comment="客单价")

    # 配置字段（JSON文本存储扩展配置）
    seo_config = Column(Text, nullable=True, comment="SEO配置")
    payment_config = Column(Text, nullable=True, comment="支付配置")
    shipping_config = Column(Text, nullable=True, comment="物流配置")
    theme_config = Column(Text, nullable=True, comment="主题配置")

    # 时间戳
    published_at = Column(DateTime(timezone=True), nullable=True, comment="发布时间")
    created_at = Column(DateTime(timezone=True), server_default=func.now(), comment="创建时间")
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), comment="更新时间")

    def __repr__(self):
        return f"<Website(id={self.id}, name={self.name}, domain={self.domain})>"


class Template(Base):
    """模板表 - 预定义的建站模板"""
    __tablename__ = "website_templates"

    id = Column(Integer, primary_key=True, index=True, comment="模板ID")
    name = Column(String(200), nullable=False, comment="模板名称")
    description = Column(Text, nullable=True, comment="模板描述")
    industry = Column(String(100), nullable=True, comment="适用行业")
    preview_url = Column(String(500), nullable=True, comment="预览图URL")
    is_active = Column(Boolean, default=True, comment="是否启用")
    sort_order = Column(Integer, default=0, comment="排序")
    created_at = Column(DateTime(timezone=True), server_default=func.now(), comment="创建时间")

    def __repr__(self):
        return f"<Template(id={self.id}, name={self.name})>"
