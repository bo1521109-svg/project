"""
内容创作 - 去生图组 - 炒做商品主图（占位）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/product-main")
async def content_image_gen_product_main():
    """
    炒做商品主图接口（占位）
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
