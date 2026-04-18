"""
知识付费接口
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/courses")
async def get_courses():
    """
    获取课程列表
    """
    return {
        "code": 200,
        "data": {
            "courses": []
        },
        "message": "功能开发中",
        "placeholder": True
    }

@router.get("/courses/{course_id}")
async def get_course_detail(course_id: int):
    """
    获取课程详情
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }

@router.post("/purchase")
async def purchase_course():
    """
    购买课程
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
