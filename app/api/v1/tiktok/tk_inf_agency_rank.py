"""
TikTok 选达人 - 达人机构榜（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/agency-rank")
async def tk_inf_agency_rank():
    """
    TikTok 达人机构榜接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
