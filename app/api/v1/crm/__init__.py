"""
客资管家 API 路由
"""
from fastapi import APIRouter

router = APIRouter()

# 导入所有客资管理相关的路由
from . import (
    overview,
    customers,
    follow_ups,
    analytics,
    tags
)

# 注册所有路由
router.include_router(overview.router, prefix="/overview", tags=["客资管家 概览"])
router.include_router(customers.router, prefix="/customers", tags=["客资管家 客户管理"])
router.include_router(follow_ups.router, prefix="/follow-ups", tags=["客资管家 跟进记录"])
router.include_router(analytics.router, prefix="/analytics", tags=["客资管家 客资分析"])
router.include_router(tags.router, prefix="/tags", tags=["客资管家 标签管理"])
