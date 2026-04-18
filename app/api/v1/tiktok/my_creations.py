"""
我的 - 我的创作接口
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("")
async def get_my_creations():
    """
    获取我的创作列表
    """
    return {
        "code": 200,
        "data": {
            "creations": []
        },
        "message": "功能开发中",
        "placeholder": True
    }

@router.post("")
async def create_content():
    """
    创建内容
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }

@router.delete("/{creation_id}")
async def delete_creation(creation_id: int):
    """
    删除创作
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
