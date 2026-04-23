"""
私域组 - Line 平台
"""
from fastapi import APIRouter

router = APIRouter(prefix="/social/private", tags=["社媒管理-私域"])

@router.get("/line")
async def get_line_private():
    """GET /api/v1/social/private/line - Line 私域管理"""
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
