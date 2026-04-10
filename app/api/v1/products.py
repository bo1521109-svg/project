from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Optional
from app.schemas.product import ProductResponse
from app.models.product import Product
from app.models.user import User
from app.db.database import get_db
from app.api.v1.auth import get_current_user

router = APIRouter()


@router.get("/", response_model=List[ProductResponse], summary="获取商品列表", description="查询所有商品，支持按店铺筛选")
async def get_products(
    store_id: Optional[int] = None,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    ## 获取商品列表
    
    查询所有商品信息，支持按店铺筛选和分页。
    
    **参数说明：**
    - **store_id**: 店铺 ID（可选，用于筛选）
    - **skip**: 跳过多少条记录（默认 0）
    - **limit**: 最多返回多少条（默认 100）
    
    **返回：** 商品列表（按抓取时间降序排列，最新爬取的在前）
    """
    query = db.query(Product)
    
    # 如果指定了 store_id，进行筛选
    if store_id:
        query = query.filter(Product.store_id == store_id)
    
    # 按抓取时间降序排列（最新爬取的在前，NULL 值排在最后）
    products = query.order_by(Product.captured_at.desc().nullslast()).offset(skip).limit(limit).all()
    return products


@router.get("/{product_id}", response_model=ProductResponse, summary="获取商品详情", description="根据 ID 查询单个商品的详细信息")
async def get_product(
    product_id: int, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    ## 获取单个商品详情
    
    根据商品 ID 查询详细信息。
    
    **参数说明：**
    - **product_id**: 商品 ID（必填）
    
    **返回：** 商品详细信息
    """
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="商品不存在")
    return product
