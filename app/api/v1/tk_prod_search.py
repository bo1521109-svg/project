"""
TikTok 选爆品 - 商品搜索（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("")
async def tk_prod_search():
    """
    TikTok 商品搜索接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
