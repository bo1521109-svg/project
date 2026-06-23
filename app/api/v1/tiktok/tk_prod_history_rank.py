"""
TikTok 商品 - 历史同期榜
"""
from fastapi import APIRouter, Query
from typing import Optional

router = APIRouter()


@router.get("/")
async def get_history_rank(
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    country: Optional[str] = Query("US", description="国家代码"),
    category: Optional[str] = Query(None, description="品类筛选"),
    period: Optional[str] = Query("last_year", description="对比周期：last_year(去年同期), last_month(上月同期)")
):
    """
    获取历史同期榜商品列表
    
    对比当前时间段与历史同期的商品销量变化
    """
    # 模拟数据
    products = [
        {
            "id": 1,
            "product_name": "Wireless Bluetooth Earbuds",
            "product_image": "https://via.placeholder.com/150",
            "current_sales": 15680,
            "history_sales": 8920,
            "growth_rate": 75.8,
            "current_price": 29.99,
            "history_price": 34.99,
            "price_change": -14.3,
            "store_name": "TechGear Store",
            "category": "Electronics",
            "country": country
        },
        {
            "id": 2,
            "product_name": "Smart Watch Fitness Tracker",
            "product_image": "https://via.placeholder.com/150",
            "current_sales": 12450,
            "history_sales": 6780,
            "growth_rate": 83.6,
            "current_price": 49.99,
            "history_price": 59.99,
            "price_change": -16.7,
            "store_name": "FitLife Shop",
            "category": "Electronics",
            "country": country
        },
        {
            "id": 3,
            "product_name": "LED Strip Lights 50ft",
            "product_image": "https://via.placeholder.com/150",
            "current_sales": 9870,
            "history_sales": 4560,
            "growth_rate": 116.4,
            "current_price": 19.99,
            "history_price": 24.99,
            "price_change": -20.0,
            "store_name": "HomeDecor Plus",
            "category": "Home & Garden",
            "country": country
        }
    ]
    
    # 应用品类筛选
    if category:
        products = [p for p in products if p["category"] == category]
    
    total = len(products) * 10  # 模拟总数
    
    return {
        "code": 200,
        "data": {
            "products": products,
            "period_info": {
                "current_period": "2026-04-01 to 2026-04-18",
                "history_period": "2025-04-01 to 2025-04-18" if period == "last_year" else "2026-03-01 to 2026-03-18",
                "period_type": period
            },
            "pagination": {
                "page": page,
                "page_size": page_size,
                "total": total,
                "total_pages": (total + page_size - 1) // page_size
            }
        },
        "message": "获取成功"
    }


@router.get("/stats")
async def get_history_stats(
    country: Optional[str] = Query("US", description="国家代码"),
    period: Optional[str] = Query("last_year", description="对比周期")
):
    """
    获取历史同期统计数据
    """
    return {
        "code": 200,
        "data": {
            "total_products": 1580,
            "avg_growth_rate": 68.5,
            "top_growth_category": "Electronics",
            "total_sales_current": 2580000,
            "total_sales_history": 1680000,
            "overall_growth": 53.6
        },
        "message": "获取成功"
    }
