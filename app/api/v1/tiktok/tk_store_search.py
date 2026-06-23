"""
TikTok 盯爆店 - 店铺搜索（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def tk_store_search():
    """
    TikTok 店铺搜索接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
