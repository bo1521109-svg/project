"""
平台管理 API 路由
"""
from fastapi import APIRouter

router = APIRouter()

# 导入所有平台管理相关的路由
from . import (
    admin_login_logs,
    admin_permissions,
    admin_users,
    admin_crawler_tasks
)

# 注册所有路由
router.include_router(admin_login_logs.router, prefix="/login-logs", tags=["平台管理 登录日志"])
router.include_router(admin_permissions.router, prefix="/permissions", tags=["平台管理 权限管理"])
router.include_router(admin_users.router, prefix="/users", tags=["平台管理 用户管理"])
router.include_router(admin_crawler_tasks.router, prefix="/crawler/tasks", tags=["平台管理 爬虫任务"])
