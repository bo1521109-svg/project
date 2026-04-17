"""
店铺大盘模块（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("")
async def store_overview():
    """
    店铺大盘接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
