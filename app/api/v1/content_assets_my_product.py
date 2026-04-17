"""
内容创作 - 资料库组 - 我的产品（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/my-product")
async def content_assets_my_product():
    """
    我的产品接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
