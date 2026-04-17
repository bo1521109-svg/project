"""
TikTok 大盘 - AI 报告（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/ai")
async def tk_overview_ai():
    """
    TikTok AI 报告接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
