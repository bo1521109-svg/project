"""
店铺搜索模块
复用现有的 stores.py 中的店铺列表接口
"""
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from app.db.database import get_db
from app.models.store import Store
from app.models.user import User
from app.schemas.store import StoreResponse
from app.api.v1.auth import get_current_user

router = APIRouter()

@router.get("", response_model=List[StoreResponse])
async def store_search(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    店铺搜索接口（复用店铺列表逻辑）
    """
    stores = db.query(Store).offset(skip).limit(limit).all()
    return stores
