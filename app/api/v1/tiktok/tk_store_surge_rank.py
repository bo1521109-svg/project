"""
TikTok 盯爆店 - 店铺飙升榜（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/surge-rank")
async def tk_store_surge_rank():
    """
    TikTok 店铺飙升榜接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
