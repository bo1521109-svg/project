"""
服务商 - 海外仓接口
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("")
async def get_warehouse_services():
    """
    海外仓服务商
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
