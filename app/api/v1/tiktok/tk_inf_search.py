"""
TikTok 选达人 - 达人搜索（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def tk_inf_search():
    """
    TikTok 达人搜索接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
