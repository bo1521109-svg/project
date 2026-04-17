"""
出海生态模块 API
"""
from fastapi import APIRouter

router = APIRouter(prefix="/ecosystem", tags=["出海生态"])

@router.get("/open-platform")
async def get_open_platform():
    """GET /api/v1/ecosystem/open-platform - 开放平台（整合开放平台）"""
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }

@router.get("/resources")
async def get_resources():
    """GET /api/v1/ecosystem/resources - 资源资源（优质服务商圈）"""
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }

@router.get("/knowledge-base")
async def get_knowledge_base():
    """GET /api/v1/ecosystem/knowledge-base - 跨境智库（地图导航地图）"""
    return {
        "code": 200,
        "data": {},
        "message": "功能开发中",
        "placeholder": True
    }
