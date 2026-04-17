"""
TikTok 大盘 - 店铺大盘（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/store")
async def tk_overview_store():
    """
    TikTok 店铺大盘接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
