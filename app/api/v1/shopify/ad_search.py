"""
广告搜索模块（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def ad_search():
    """
    广告搜索接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
