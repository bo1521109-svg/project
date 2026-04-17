"""
TikTok 选达人 - 带货达人榜（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/sales-rank")
async def tk_inf_sales_rank():
    """
    TikTok 带货达人榜接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
