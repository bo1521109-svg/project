"""
TikTok 选达人 - 涨粉达人榜（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/follower-rank")
async def tk_inf_follower_rank():
    """
    TikTok 涨粉达人榜接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
