"""
内容创作 - 找创意组 - 视频卖点宝抄（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/selling-point")
async def content_creative_selling_point():
    """
    视频卖点宝抄接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
