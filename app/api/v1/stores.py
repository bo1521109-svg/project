from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.schemas.store import StoreCreate, StoreResponse
from app.models.store import Store
from app.db.database import get_db

router = APIRouter()


@router.post("/", response_model=StoreResponse, status_code=status.HTTP_201_CREATED)
async def create_store(store: StoreCreate, db: Session = Depends(get_db)):
    """添加新店铺 - 检查 URL 是否重复"""
    # 检查 URL 是否已存在
    existing_store = db.query(Store).filter(Store.url == store.url).first()
    if existing_store:
        raise HTTPException(status_code=400, detail="店铺 URL 已存在")
    
    # 创建新店铺
    new_store = Store(**store.model_dump())
    db.add(new_store)
    db.commit()
    db.refresh(new_store)
    return new_store


@router.get("/", response_model=List[StoreResponse])
async def get_stores(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """获取店铺列表 - 支持分页"""
    stores = db.query(Store).offset(skip).limit(limit).all()
    return stores


@router.get("/{store_id}", response_model=StoreResponse)
async def get_store(store_id: int, db: Session = Depends(get_db)):
    """获取单个店铺详情"""
    store = db.query(Store).filter(Store.id == store_id).first()
    if not store:
        raise HTTPException(status_code=404, detail="店铺不存在")
    return store
