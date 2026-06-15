"""
商品销量榜模块 - 按总销量降序排列
"""
from fastapi import APIRouter, Depends, Query, Request
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import desc, asc
from typing import Optional
from app.schemas.product import ProductResponse
from app.models.product import Product
from app.models.user import User
from app.db.database import get_db
from app.api.v1.auth import get_current_user
from app.core.logging_config import logger

router = APIRouter()


@router.get("", summary="商品销量榜", description="按总销量降序排列，支持国家、类目、销量区间筛选")
async def product_sales_rank(
    request: Request,
    keyword: Optional[str] = Query(None, description="搜索关键词"),
    country_code: Optional[str] = Query(None, description="国家代码"),
    category_code: Optional[str] = Query(None, description="类目代码"),
    sales_total_min: Optional[int] = Query(None, description="总销量最小值", ge=0),
    sales_total_max: Optional[int] = Query(None, description="总销量最大值", ge=0),
    skip: int = Query(0, description="跳过条数", ge=0),
    limit: int = Query(100, description="返回条数", ge=1, le=500),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    all_params = dict(request.query_params)
    logger.info(f"销量榜请求参数: {all_params}")

    query = db.query(Product).options(joinedload(Product.store))
    filters_applied = {}

    if keyword:
        query = query.filter(Product.title.ilike(f"%{keyword}%"))
        filters_applied['keyword'] = keyword

    if country_code:
        from app.models.store import Store
        query = query.join(Store).filter(Store.country_code == country_code)
        filters_applied['country_code'] = country_code

    if category_code:
        query = query.filter(Product.category_code == category_code)
        filters_applied['category_code'] = category_code

    if sales_total_min is not None:
        query = query.filter(Product.sales_total >= sales_total_min)
        filters_applied['sales_total_min'] = sales_total_min
    if sales_total_max is not None:
        query = query.filter(Product.sales_total <= sales_total_max)
        filters_applied['sales_total_max'] = sales_total_max

    query = query.order_by(desc(Product.sales_total))
    filters_applied['sort_by'] = 'sales_total'
    filters_applied['sort_order'] = 'desc'

    total = query.count()
    products = query.offset(skip).limit(limit).all()

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
            "sales_7d": product.sales_7d,
            "sales_total": product.sales_total,
            "captured_at": product.captured_at,
            "created_at": product.created_at,
            "updated_at": product.updated_at,
            "store_name": product.store.name if product.store else None
        }
        result.append(ProductResponse(**product_dict))

    logger.info(f"销量榜结果: 总数={total}, 返回={len(products)}")

    return {
        "data": result,
        "total": total,
        "filters_applied": filters_applied
    }
