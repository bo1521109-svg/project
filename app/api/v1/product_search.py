"""
商品搜索模块
复用现有的 products.py 中的商品列表接口
"""
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session, joinedload
from typing import List
from app.db.database import get_db
from app.models.product import Product
from app.models.user import User
from app.schemas.product import ProductResponse
from app.api.v1.auth import get_current_user

router = APIRouter()

@router.get("", response_model=List[ProductResponse])
async def product_search(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    商品搜索接口（复用商品列表逻辑）
    """
    # 使用 joinedload 预加载 store 关系
    query = db.query(Product).options(joinedload(Product.store))
    
    # 按抓取时间降序排列
    products = query.order_by(Product.captured_at.desc().nullslast()).offset(skip).limit(limit).all()
    
    # 手动添加 store_name 到每个商品
    result = []
    for product in products:
        product_dict = {
            "id": product.id,
            "store_id": product.store_id,
            "title": product.title,
            "url": product.url,
            "price": product.price,
            "currency": product.currency,
            "image_url": product.image_url,
            "category": product.category,
            "is_available": product.is_available,
            "last_available": product.last_available,
            "status_change_at": product.status_change_at,
            "last_stock": product.last_stock,
            "sales_estimate": product.sales_estimate,
            "captured_at": product.captured_at,
            "created_at": product.created_at,
            "updated_at": product.updated_at,
            "store_name": product.store.name if product.store else None
        }
        result.append(ProductResponse(**product_dict))
    
    return result
