"""
内容创作 - 资料库组 - 我的素材（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/my-material")
async def content_assets_my_material():
    """
    我的素材接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
