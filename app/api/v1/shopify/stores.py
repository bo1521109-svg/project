"""
Shopify 店铺相关 API - 仅数据查询
店铺管理功能已迁移到平台管理（/api/v1/admin/crawler/tasks）
"""
from fastapi import APIRouter, Depends, Query, Request
from sqlalchemy.orm import Session
from sqlalchemy import desc, asc
from typing import List, Optional, Dict, Any
from app.db.database import get_db
from app.models.store import Store
from app.models.user import User
from app.api.v1.auth import get_current_user
from app.schemas.store import StoreResponse
from app.core.logging_config import logger

router = APIRouter()


@router.get("/search", summary="搜索店铺", description="根据条件搜索店铺（支持国家、类目、销量筛选和排序）")
async def search_stores(
    request: Request,
    keyword: Optional[str] = Query(None, description="搜索关键词（可选）"),
    country_code: Optional[str] = Query(None, description="国家代码（如：US, GB）"),
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
    ## 搜索店铺（数据查询）
    
    支持多维度筛选和排序，未支持的参数会被忽略（不报错）。
    
    **支持的筛选条件：**
    - **keyword**: 搜索关键词（店铺名称或 URL）
    - **country_code**: 国家代码（如：US, GB, DE）
    - **category_code**: 类目代码（如：beauty, women-fashion）
    - **sales_7d_min/max**: 近7天销量区间
    - **sales_total_min/max**: 总销量区间
    - **sort_by**: 排序字段（sales_7d, sales_total）
    - **sort_order**: 排序方向（asc, desc）
    
    **返回：** 
    ```json
    {
        "data": [...],  // 店铺列表
        "total": 100,   // 总条数
        "filters_applied": {...},  // 实际生效的筛选条件
        "filters_ignored": [...]   // 被忽略的参数
    }
    ```
    """
    # 记录所有查询参数
    all_params = dict(request.query_params)
    logger.info(f"店铺搜索请求参数: {all_params}")
    
    # 支持的参数白名单
    supported_params = {
        'keyword', 'country_code', 'category_code',
        'sales_7d_min', 'sales_7d_max', 'sales_total_min', 'sales_total_max',
        'sort_by', 'sort_order', 'skip', 'limit'
    }
    
    # 识别未支持的参数
    ignored_params = [k for k in all_params.keys() if k not in supported_params]
    if ignored_params:
        logger.warning(f"未支持的参数（已忽略）: {ignored_params}")
    
    # 构建查询
    query = db.query(Store)
    filters_applied = {}
    
    # 1. 关键词搜索
    if keyword:
        query = query.filter(
            (Store.name.ilike(f"%{keyword}%")) | (Store.url.ilike(f"%{keyword}%"))
        )
        filters_applied['keyword'] = keyword
    
    # 2. 国家筛选
    if country_code:
        query = query.filter(Store.country_code == country_code)
        filters_applied['country_code'] = country_code
    
    # 3. 类目筛选（注意：店铺表没有 category_code，这里记录但不过滤）
    if category_code:
        logger.info(f"店铺搜索不支持类目筛选，参数已忽略: category_code={category_code}")
        ignored_params.append('category_code')
    
    # 4. 销量筛选 - 近7天
    if sales_7d_min is not None:
        query = query.filter(Store.sales_7d >= sales_7d_min)
        filters_applied['sales_7d_min'] = sales_7d_min
    if sales_7d_max is not None:
        query = query.filter(Store.sales_7d <= sales_7d_max)
        filters_applied['sales_7d_max'] = sales_7d_max
    
    # 5. 销量筛选 - 总销量
    if sales_total_min is not None:
        query = query.filter(Store.sales_total >= sales_total_min)
        filters_applied['sales_total_min'] = sales_total_min
    if sales_total_max is not None:
        query = query.filter(Store.sales_total <= sales_total_max)
        filters_applied['sales_total_max'] = sales_total_max
    
    # 6. 排序
    sort_field_map = {
        'sales_7d': Store.sales_7d,
        'sales_total': Store.sales_total
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
        # 默认按创建时间降序
        query = query.order_by(desc(Store.created_at))
    
    # 获取总数（在分页前）
    total = query.count()
    
    # 分页
    stores = query.offset(skip).limit(limit).all()
    
    # 构建响应
    response = {
        "data": [StoreResponse.from_orm(store) for store in stores],
        "total": total,
        "filters_applied": filters_applied,
        "filters_ignored": ignored_params if ignored_params else []
    }
    
    logger.info(f"店铺搜索结果: 总数={total}, 返回={len(stores)}, 生效筛选={filters_applied}")
    
    return response
