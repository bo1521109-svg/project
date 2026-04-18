"""
TikTok 大盘 - 商品大盘（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/product")
async def tk_overview_product():
    """
    TikTok 商品大盘接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
