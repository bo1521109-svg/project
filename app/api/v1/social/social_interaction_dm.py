"""
互动管理组 - 私信管理
"""
from fastapi import APIRouter

router = APIRouter(prefix="/social/interaction", tags=["社媒管理-互动管理"])

@router.get("/direct-messages")
async def get_interaction_direct_messages():
    """GET /api/v1/social/interaction/direct-messages - 私信管理"""
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
