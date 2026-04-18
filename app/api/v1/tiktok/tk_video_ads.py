"""
TikTok 找视频 - 广告搜索（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/ads")
async def tk_video_ads():
    """
    TikTok 广告搜索接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
