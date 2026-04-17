"""
发布管理组 - 发布管理
"""
from fastapi import APIRouter

router = APIRouter(prefix="/social/publish", tags=["社媒管理-发布管理"])

@router.get("/manage")
async def get_publish_manage():
    """GET /api/v1/social/publish/manage - 发布管理"""
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
