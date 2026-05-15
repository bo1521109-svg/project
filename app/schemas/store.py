from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import Optional


class StoreCreate(BaseModel):
    """店铺创建 Schema - 输入"""
    name: str
    url: str
    platform: str = "shopify"
    country: Optional[str] = None


class StoreResponse(BaseModel):
    """店铺响应 Schema - 输出"""
    id: int
    name: str
    url: str
    platform: Optional[str] = None
    country: Optional[str] = None
    platform_code: Optional[str] = None
    country_code: Optional[str] = None
    sales_7d: Optional[int] = 0
    sales_total: Optional[int] = 0
    status: Optional[str] = "active"
    is_crawling: Optional[bool] = False
    last_crawl_at: Optional[datetime] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
    
    model_config = ConfigDict(from_attributes=True)
