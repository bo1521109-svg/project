"""
服务商 - 达人对接接口
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_influencer_services():
    """
    达人对接服务商
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
