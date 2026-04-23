"""
Shopify 店铺相关 API - 仅数据查询
店铺管理功能已迁移到平台管理（/api/v1/admin/crawler/tasks）
"""
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List
from app.db.database import get_db
from app.models.store import Store
from app.models.user import User
from app.api.v1.auth import get_current_user
from app.schemas.store import StoreResponse

router = APIRouter()


@router.get("/search", response_model=List[StoreResponse], summary="搜索店铺", description="根据关键词搜索店铺（仅查询）")
async def search_stores(
    keyword: str = Query(..., description="搜索关键词", min_length=1),
    skip: int = Query(0, description="跳过多少条记录"),
    limit: int = Query(100, description="最多返回多少条"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    ## 搜索店铺（数据查询）
    
    根据关键词搜索店铺名称或 URL，支持模糊匹配。
    
    **注意**: 此接口仅用于数据查询，店铺管理请使用平台管理功能。
    
    **参数说明：**
    - **keyword**: 搜索关键词（必填，至少 1 个字符）
    - **skip**: 跳过多少条记录（默认 0）
    - **limit**: 最多返回多少条（默认 100）
    
    **返回：** 匹配的店铺列表
    """
    # 模糊搜索店铺名称或 URL
    stores = db.query(Store).filter(
        (Store.name.ilike(f"%{keyword}%")) | (Store.url.ilike(f"%{keyword}%"))
    ).offset(skip).limit(limit).all()
    
    return stores
