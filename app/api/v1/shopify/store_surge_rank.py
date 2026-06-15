"""
店铺飙升榜模块 - 功能开发中
"""
from fastapi import APIRouter

router = APIRouter()


@router.get("", summary="店铺飙升榜", description="功能开发中")
async def store_surge_rank():
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
