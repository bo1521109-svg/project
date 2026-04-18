"""
出海探索接口
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/markets")
async def get_markets():
    """
    获取市场列表
    """
    return {
        "code": 200,
        "data": {
            "markets": []
        },
        "message": "功能开发中",
        "placeholder": True
    }

@router.get("/trends")
async def get_trends():
    """
    获取趋势分析
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }

@router.get("/opportunities")
async def get_opportunities():
    """
    获取商机推荐
    """
    return {
        "code": 200,
        "data": {
            "opportunities": []
        },
        "message": "功能开发中",
        "placeholder": True
    }
