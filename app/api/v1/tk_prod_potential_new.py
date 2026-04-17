"""
TikTok 选爆品 - 潜力新品榜（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/potential-new")
async def tk_prod_potential_new():
    """
    TikTok 潜力新品榜接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
