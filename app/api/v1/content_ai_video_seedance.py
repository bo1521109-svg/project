"""
内容创作 - AI 视频组 - Seedance2.0/Sora2（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/seedance")
async def content_ai_video_seedance():
    """
    Seedance2.0/Sora2 接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
