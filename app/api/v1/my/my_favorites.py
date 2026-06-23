"""
我的 - 我的收藏接口（独立站和TikTok共用）
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_my_favorites():
    """
    获取我的收藏列表
    """
    return {
        "code": 200,
        "data": {
            "favorites": []
        },
        "message": "功能开发中",
        "placeholder": True
    }

@router.post("/")
async def add_favorite():
    """
    添加收藏
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }

@router.delete("/{favorite_id}")
async def delete_favorite(favorite_id: int):
    """
    删除收藏
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
