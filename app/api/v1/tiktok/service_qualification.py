"""
服务商 - 资质办理接口
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_qualification_services():
    """
    资质办理服务商
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
