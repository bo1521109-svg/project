"""
店铺爆卖榜模块 - 功能开发中
"""
from fastapi import APIRouter

router = APIRouter()


@router.get("", summary="店铺爆卖榜", description="功能开发中")
async def store_best_sellers():
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
