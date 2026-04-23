"""
账号管理组 - 账号管理
"""
from fastapi import APIRouter

router = APIRouter(prefix="/social/accounts", tags=["社媒管理-账号管理"])

@router.get("/manage")
async def get_accounts_manage():
    """GET /api/v1/social/accounts/manage - 账号管理"""
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
