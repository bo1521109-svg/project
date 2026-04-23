"""
社媒管理 API 路由
"""
from fastapi import APIRouter

router = APIRouter()

# 导入所有社媒管理相关的路由
from . import (
    social_accounts_manage,
    social_dashboard_overview,
    social_interaction_comment,
    social_interaction_dm,
    social_platform_fb,
    social_platform_ins,
    social_platform_youtube,
    social_private_line,
    social_private_whatsapp,
    social_publish_manage
)

# 注册所有路由
router.include_router(social_accounts_manage.router, prefix="/accounts/manage", tags=["社媒管理 账号管理"])
router.include_router(social_dashboard_overview.router, prefix="/dashboard/overview", tags=["社媒管理 数据看板"])
router.include_router(social_interaction_comment.router, prefix="/interaction/comments", tags=["社媒管理 评论互动"])
router.include_router(social_interaction_dm.router, prefix="/interaction/direct-messages", tags=["社媒管理 私信互动"])
router.include_router(social_platform_fb.router, prefix="/platforms/facebook", tags=["社媒管理 Facebook"])
router.include_router(social_platform_ins.router, prefix="/platforms/instagram", tags=["社媒管理 Instagram"])
router.include_router(social_platform_youtube.router, prefix="/platforms/youtube", tags=["社媒管理 YouTube"])
router.include_router(social_private_line.router, prefix="/private/line", tags=["社媒管理 Line"])
router.include_router(social_private_whatsapp.router, prefix="/private/whatsapp", tags=["社媒管理 WhatsApp"])
router.include_router(social_publish_manage.router, prefix="/publish/manage", tags=["社媒管理 发布管理"])
