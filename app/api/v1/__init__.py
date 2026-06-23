"""
API v1 主路由
"""
from fastapi import APIRouter

# 导入认证模块
from .auth import router as auth_router

# 导入 AI 报告模块（独立站和TikTok共用）
from .ai_report import router as ai_report_router

# 导入出海生态模块
# 导入 AI 出海助手模块
from .ai_assistant import router as ai_assistant_router

# 导入子模块路由
from .shopify import router as shopify_router
from .content import router as content_router
from .social import router as social_router
from .crm import router as crm_router
from .my import router as my_router
from .admin import router as admin_router
from .tiktok import router as tiktok_router

router = APIRouter()

# 注册认证路由
router.include_router(auth_router, prefix="/auth", tags=["用户认证"])

# 注册独立站数据路由
router.include_router(shopify_router, prefix="/shopify")

# 向后兼容：直接注册 products 路由（用于旧前端代码）
# 注意：stores 路由已移除，店铺管理请使用 /admin/crawler/tasks
from .shopify.products import router as products_router
router.include_router(products_router, prefix="/products", tags=["商品管理（兼容）"])

# 注册内容创作路由
router.include_router(content_router, prefix="/content")

# 注册社媒管理路由
router.include_router(social_router, prefix="/social")

# 注册客资管家路由
router.include_router(crm_router, prefix="/crm")

# 注册"我的"路由
router.include_router(my_router, prefix="/my")

# 注册平台管理路由
router.include_router(admin_router, prefix="/admin")

# 注册 TikTok 数据路由
router.include_router(tiktok_router)

# 注册 AI 报告路由（独立站和TikTok共用）
router.include_router(ai_report_router, prefix="/shopify/ai-report", tags=["Shopify AI报告"])
router.include_router(ai_report_router, prefix="/tiktok/ai-report", tags=["TikTok AI报告"])

# 注册 AI 出海助手路由
router.include_router(ai_assistant_router, tags=["AI出海助手"])

# 注册建站模块路由
from .website import router as website_router
router.include_router(website_router, prefix="/website", tags=["建站管理"])
