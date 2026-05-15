from fastapi import APIRouter, Depends, HTTPException, status, Query, Request
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import desc, asc
from typing import List, Optional, Dict, Any
from app.schemas.product import ProductResponse
from app.models.product import Product
from app.models.user import User
from app.db.database import get_db
from app.api.v1.auth import get_current_user
from app.core.logging_config import logger

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
    
    **返回：** 商品列表（按抓取时间降序排列，最新爬取的在前，包含店铺名称）
    """
    # 使用 joinedload 预加载 store 关系，避免 N+1 查询问题
    query = db.query(Product).options(joinedload(Product.store))
    
    # 如果指定了 store_id，进行筛选
    if store_id:
        query = query.filter(Product.store_id == store_id)
    
    # 按抓取时间降序排列（最新爬取的在前，NULL 值排在最后）
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


@router.get("/search", summary="搜索商品", description="根据条件搜索商品（支持国家、类目、销量筛选和排序）")
async def search_products(
    request: Request,
    keyword: Optional[str] = Query(None, description="搜索关键词（可选）"),
    store_id: Optional[int] = Query(None, description="店铺 ID（可选）"),
    country_code: Optional[str] = Query(None, description="国家代码（通过店铺关联）"),
    category_code: Optional[str] = Query(None, description="类目代码（如：beauty, women-fashion）"),
    sales_7d_min: Optional[int] = Query(None, description="近7天销量最小值", ge=0),
    sales_7d_max: Optional[int] = Query(None, description="近7天销量最大值", ge=0),
    sales_total_min: Optional[int] = Query(None, description="总销量最小值", ge=0),
    sales_total_max: Optional[int] = Query(None, description="总销量最大值", ge=0),
    sort_by: Optional[str] = Query(None, description="排序字段（sales_7d, sales_total）"),
    sort_order: Optional[str] = Query("desc", description="排序方向（asc, desc）"),
    skip: int = Query(0, description="跳过多少条记录", ge=0),
    limit: int = Query(100, description="最多返回多少条", ge=1, le=500),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    ## 搜索商品
    
    支持多维度筛选和排序，未支持的参数会被忽略（不报错）。
    
    **支持的筛选条件：**
    - **keyword**: 搜索关键词（商品标题）
    - **store_id**: 店铺 ID
    - **country_code**: 国家代码（通过店铺关联筛选）
    - **category_code**: 类目代码（如：beauty, women-fashion）
    - **sales_7d_min/max**: 近7天销量区间
    - **sales_total_min/max**: 总销量区间
    - **sort_by**: 排序字段（sales_7d, sales_total）
    - **sort_order**: 排序方向（asc, desc）
    
    **返回：** 
    ```json
    {
        "data": [...],  // 商品列表
        "total": 100,   // 总条数
        "filters_applied": {...},  // 实际生效的筛选条件
        "filters_ignored": [...]   // 被忽略的参数
    }
    ```
    """
    # 记录所有查询参数
    all_params = dict(request.query_params)
    logger.info(f"商品搜索请求参数: {all_params}")
    
    # 支持的参数白名单
    supported_params = {
        'keyword', 'store_id', 'country_code', 'category_code',
        'sales_7d_min', 'sales_7d_max', 'sales_total_min', 'sales_total_max',
        'sort_by', 'sort_order', 'skip', 'limit'
    }
    
    # 识别未支持的参数
    ignored_params = [k for k in all_params.keys() if k not in supported_params]
    if ignored_params:
        logger.warning(f"未支持的参数（已忽略）: {ignored_params}")
    
    # 使用 joinedload 预加载 store 关系
    query = db.query(Product).options(joinedload(Product.store))
    filters_applied = {}
    
    # 1. 关键词搜索
    if keyword:
        query = query.filter(Product.title.ilike(f"%{keyword}%"))
        filters_applied['keyword'] = keyword
    
    # 2. 店铺筛选
    if store_id:
        query = query.filter(Product.store_id == store_id)
        filters_applied['store_id'] = store_id
    
    # 3. 国家筛选（通过店铺关联）
    if country_code:
        from app.models.store import Store
        query = query.join(Store).filter(Store.country_code == country_code)
        filters_applied['country_code'] = country_code
    
    # 4. 类目筛选
    if category_code:
        query = query.filter(Product.category_code == category_code)
        filters_applied['category_code'] = category_code
    
    # 5. 销量筛选 - 近7天
    if sales_7d_min is not None:
        query = query.filter(Product.sales_7d >= sales_7d_min)
        filters_applied['sales_7d_min'] = sales_7d_min
    if sales_7d_max is not None:
        query = query.filter(Product.sales_7d <= sales_7d_max)
        filters_applied['sales_7d_max'] = sales_7d_max
    
    # 6. 销量筛选 - 总销量
    if sales_total_min is not None:
        query = query.filter(Product.sales_total >= sales_total_min)
        filters_applied['sales_total_min'] = sales_total_min
    if sales_total_max is not None:
        query = query.filter(Product.sales_total <= sales_total_max)
        filters_applied['sales_total_max'] = sales_total_max
    
    # 7. 排序
    sort_field_map = {
        'sales_7d': Product.sales_7d,
        'sales_total': Product.sales_total
    }
    
    if sort_by and sort_by in sort_field_map:
        sort_field = sort_field_map[sort_by]
        if sort_order == 'asc':
            query = query.order_by(asc(sort_field))
        else:
            query = query.order_by(desc(sort_field))
        filters_applied['sort_by'] = sort_by
        filters_applied['sort_order'] = sort_order
    else:
        # 默认按抓取时间降序
        query = query.order_by(desc(Product.captured_at).nullslast())
    
    # 获取总数（在分页前）
    total = query.count()
    
    # 分页
    products = query.offset(skip).limit(limit).all()
    
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
    
    # 构建响应
    response = {
        "data": result,
        "total": total,
        "filters_applied": filters_applied,
        "filters_ignored": ignored_params if ignored_params else []
    }
    
    logger.info(f"商品搜索结果: 总数={total}, 返回={len(products)}, 生效筛选={filters_applied}")
    
    return response


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
