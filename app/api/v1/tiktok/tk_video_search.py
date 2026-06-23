"""
TikTok 找视频 - 视频搜索（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def tk_video_search():
    """
    TikTok 视频搜索接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
