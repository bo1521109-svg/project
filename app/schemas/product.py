from pydantic import BaseModel, ConfigDict
from datetime import datetime
from typing import Optional


class ProductCreate(BaseModel):
    """商品创建 Schema - 输入"""
    store_id: int
    title: str
    url: str
    price: Optional[float] = None
    currency: str = "USD"
    image_url: Optional[str] = None
    sales_estimate: int = 0


class ProductResponse(BaseModel):
    """商品响应 Schema - 输出"""
    id: int
    store_id: int
    title: str
    url: str
    price: Optional[float]
    currency: str
    image_url: Optional[str]
    sales_estimate: int
    captured_at: Optional[datetime]
    created_at: datetime
    updated_at: datetime
    
    model_config = ConfigDict(from_attributes=True)
