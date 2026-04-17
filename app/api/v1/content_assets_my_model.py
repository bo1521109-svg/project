"""
内容创作 - 资料库组 - 我的模特（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/my-model")
async def content_assets_my_model():
    """
    我的模特接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
