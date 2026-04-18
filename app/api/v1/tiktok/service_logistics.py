"""
服务商 - 国际物流接口
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("")
async def get_logistics_services():
    """
    国际物流服务商
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
