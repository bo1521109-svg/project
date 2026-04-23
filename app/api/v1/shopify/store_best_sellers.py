"""
店铺爆卖榜模块（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("")
async def store_best_sellers():
    """
    店铺爆卖榜接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
