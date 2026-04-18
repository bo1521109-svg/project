"""
购买续费接口
"""
from fastapi import APIRouter

router = APIRouter()

@router.get("/plans")
async def get_pricing_plans():
    """
    获取套餐列表
    """
    return {
        "code": 200,
        "data": {
            "plans": [
                {
                    "id": 1,
                    "name": "基础版",
                    "price": 99,
                    "duration": "月",
                    "features": []
                },
                {
                    "id": 2,
                    "name": "专业版",
                    "price": 299,
                    "duration": "月",
                    "features": []
                },
                {
                    "id": 3,
                    "name": "企业版",
                    "price": 999,
                    "duration": "月",
                    "features": []
                }
            ]
        },
        "message": "功能开发中",
        "placeholder": True
    }

@router.post("/order")
async def create_order():
    """
    创建订单
    """
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
