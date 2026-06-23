"""
TikTok 选爆品 - 商品飙升榜（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def tk_prod_surge_rank():
    """
    TikTok 商品飙升榜接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
