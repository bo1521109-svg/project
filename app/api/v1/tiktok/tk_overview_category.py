"""
TikTok 大盘 - 品类大盘（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/category")
async def tk_overview_category():
    """
    TikTok 品类大盘接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
