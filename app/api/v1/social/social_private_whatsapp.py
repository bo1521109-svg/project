"""
私域组 - WhatsApp 平台
"""
from fastapi import APIRouter

router = APIRouter(prefix="/social/private", tags=["社媒管理-私域"])

@router.get("/whatsapp")
async def get_whatsapp_private():
    """GET /api/v1/social/private/whatsapp - WhatsApp 私域管理"""
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
