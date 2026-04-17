"""
社媒平台组 - Instagram 平台
"""
from fastapi import APIRouter

router = APIRouter(prefix="/social/platforms", tags=["社媒管理-平台"])

@router.get("/ins")
async def get_instagram_platform():
    """GET /api/v1/social/platforms/ins - Instagram 平台管理"""
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
