"""
TikTok 直播搜索接口
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("")
async def search_live():
    """
    直播搜索
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
