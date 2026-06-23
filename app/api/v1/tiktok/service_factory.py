"""
服务商 - 海外工厂接口
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_factory_services():
    """
    海外工厂服务商
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
