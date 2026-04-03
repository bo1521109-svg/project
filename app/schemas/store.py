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
    platform: str
    country: Optional[str]
    status: str
    is_crawling: bool
    last_crawl_at: Optional[datetime]
    created_at: datetime
    updated_at: datetime
    
    model_config = ConfigDict(from_attributes=True)
