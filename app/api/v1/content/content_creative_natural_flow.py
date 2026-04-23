"""
内容创作 - 找创意组 - 自然流广告素材（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/natural-flow")
async def content_creative_natural_flow():
    """
    自然流广告素材接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
