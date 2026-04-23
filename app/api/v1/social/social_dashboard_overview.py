"""
数据看板组 - 数据概览
"""
from fastapi import APIRouter

router = APIRouter(prefix="/social/dashboard", tags=["社媒管理-数据看板"])

@router.get("/overview")
async def get_dashboard_overview():
    """GET /api/v1/social/dashboard/overview - 数据看板概览"""
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
