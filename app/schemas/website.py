"""
建站模块 - Pydantic 请求/响应 Schema
"""
from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel


# ========== 站点相关 Schema ==========

class WebsiteBase(BaseModel):
    """站点基础字段"""
    name: str
    domain: Optional[str] = None
    industry: Optional[str] = None
    template_id: Optional[int] = None
    template_name: Optional[str] = None


class WebsiteCreate(WebsiteBase):
    """创建站点的请求"""
    pass


class WebsiteUpdate(BaseModel):
    """更新站点的请求"""
    name: Optional[str] = None
    domain: Optional[str] = None
    industry: Optional[str] = None
    template_id: Optional[int] = None
    template_name: Optional[str] = None
    seo_config: Optional[str] = None
    payment_config: Optional[str] = None
    shipping_config: Optional[str] = None
    theme_config: Optional[str] = None


class WebsiteResponse(WebsiteBase):
    """站点响应"""
    id: int
    user_id: int
    status: str
    visits: int
    orders: int
    conversion_rate: float
    avg_order_value: float
    published_at: Optional[datetime] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class WebsiteListResponse(BaseModel):
    """站点列表响应（分页）"""
    total: int
    items: List[WebsiteResponse]
    page: int
    page_size: int


# ========== 模板相关 Schema ==========

class TemplateResponse(BaseModel):
    """模板响应"""
    id: int
    name: str
    description: Optional[str] = None
    industry: Optional[str] = None
    preview_url: Optional[str] = None
    sort_order: int

    class Config:
        from_attributes = True


class TemplateListResponse(BaseModel):
    """模板列表响应"""
    total: int
    items: List[TemplateResponse]
