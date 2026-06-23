"""
独立站工作台 API

提供独立站数据的工作台功能，包括：
- 数据概览
- 快捷操作
- 最近访问
- 数据统计
"""

from fastapi import APIRouter, Query
from typing import Optional
from datetime import datetime

router = APIRouter()


@router.get("/")
async def get_workbench_overview():
    """
    获取工作台概览数据
    
    返回：
    - 数据概览
    - 快捷入口
    - 最近访问
    """
    return {
        "code": 200,
        "message": "success",
        "data": {
            "overview": {
                "total_products": 1250,
                "total_stores": 380,
                "total_ads": 5600,
                "total_videos": 2100
            },
            "quick_access": [
                {
                    "name": "商品搜索",
                    "path": "/shopify/products",
                    "icon": "ShoppingBag",
                    "count": 1250
                },
                {
                    "name": "店铺搜索",
                    "path": "/shopify/stores",
                    "icon": "Shop",
                    "count": 380
                },
                {
                    "name": "广告库",
                    "path": "/shopify/ads/library",
                    "icon": "Picture",
                    "count": 5600
                },
                {
                    "name": "品类大盘",
                    "path": "/shopify/category/overview",
                    "icon": "Histogram",
                    "count": 0
                }
            ],
            "recent_visits": [
                {
                    "name": "商品搜索",
                    "path": "/shopify/products",
                    "visit_time": "2024-01-20 14:30:00"
                },
                {
                    "name": "店铺搜索",
                    "path": "/shopify/stores",
                    "visit_time": "2024-01-20 13:15:00"
                }
            ],
            "statistics": {
                "today_visits": 156,
                "week_visits": 892,
                "month_visits": 3420
            }
        }
    }


@router.get("/stats")
async def get_workbench_stats(
    period: Optional[str] = Query("week", description="统计周期: day, week, month")
):
    """
    获取工作台统计数据
    
    参数：
    - period: 统计周期（day/week/month）
    
    返回：
    - 访问统计
    - 数据趋势
    """
    return {
        "code": 200,
        "message": "success",
        "data": {
            "period": period,
            "visits": {
                "total": 892 if period == "week" else 156,
                "trend": "+12.5%"
            },
            "popular_modules": [
                {"name": "商品搜索", "visits": 320},
                {"name": "店铺搜索", "visits": 280},
                {"name": "广告库", "visits": 150},
                {"name": "品类大盘", "visits": 142}
            ]
        }
    }
