"""
管理员 - 角色权限管理接口
"""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Optional, List
from pydantic import BaseModel

from app.db.database import get_db
from app.models.user import User
from app.api.v1.auth import get_current_user

router = APIRouter()


def require_admin(current_user: User = Depends(get_current_user)):
    """验证管理员权限"""
    if current_user.role != "admin":
        raise HTTPException(status_code=403, detail="需要管理员权限")
    return current_user


class RoleInfo(BaseModel):
    """角色信息"""
    role_key: str
    role_name: str
    description: str
    user_count: int


class PermissionInfo(BaseModel):
    """权限信息"""
    permission_key: str
    permission_name: str
    description: str
    module: str


@router.get("/")
async def get_roles(
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    获取所有角色列表
    """
    # 统计各角色的用户数量
    admin_count = db.query(User).filter(User.role == "admin").count()
    user_count = db.query(User).filter(User.role == "user").count()
    
    roles = [
        {
            "role_key": "admin",
            "role_name": "管理员",
            "description": "拥有所有权限，可以管理用户、爬虫等",
            "user_count": admin_count,
            "permissions": [
                "user_management",
                "crawler_management",
                "system_config",
                "data_export",
                "log_view"
            ]
        },
        {
            "role_key": "user",
            "role_name": "普通用户",
            "description": "基础功能权限，可以使用数据查询、内容创作等功能",
            "user_count": user_count,
            "permissions": [
                "data_view",
                "content_create",
                "social_manage",
                "personal_center"
            ]
        }
    ]
    
    return {
        "code": 200,
        "data": {
            "roles": roles
        },
        "message": "获取成功"
    }


@router.get("/permissions")
async def get_permissions(
    module: Optional[str] = Query(None, description="模块筛选"),
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    获取所有权限列表
    """
    permissions = [
        # 用户管理模块
        {
            "permission_key": "user_management",
            "permission_name": "用户管理",
            "description": "管理平台用户、角色、权限",
            "module": "admin"
        },
        {
            "permission_key": "crawler_management",
            "permission_name": "爬虫管理",
            "description": "管理爬虫任务、日志、配置",
            "module": "admin"
        },
        {
            "permission_key": "system_config",
            "permission_name": "系统配置",
            "description": "修改系统配置参数",
            "module": "admin"
        },
        {
            "permission_key": "data_export",
            "permission_name": "数据导出",
            "description": "导出平台数据",
            "module": "admin"
        },
        {
            "permission_key": "log_view",
            "permission_name": "日志查看",
            "description": "查看系统日志、登录日志",
            "module": "admin"
        },
        # 普通用户模块
        {
            "permission_key": "data_view",
            "permission_name": "数据查看",
            "description": "查看 TikTok、独立站等数据",
            "module": "data"
        },
        {
            "permission_key": "content_create",
            "permission_name": "内容创作",
            "description": "使用 AI 视频、图片生成等功能",
            "module": "content"
        },
        {
            "permission_key": "social_manage",
            "permission_name": "社媒管理",
            "description": "管理社交媒体账号、发布内容",
            "module": "social"
        },
        {
            "permission_key": "personal_center",
            "permission_name": "个人中心",
            "description": "管理个人信息、收藏、创作",
            "module": "user"
        }
    ]
    
    # 模块筛选
    if module:
        permissions = [p for p in permissions if p["module"] == module]
    
    return {
        "code": 200,
        "data": {
            "permissions": permissions
        },
        "message": "获取成功"
    }


@router.get("/{role_key}")
async def get_role_detail(
    role_key: str,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    获取角色详情
    """
    if role_key not in ["admin", "user"]:
        raise HTTPException(status_code=404, detail="角色不存在")
    
    # 统计用户数量
    user_count = db.query(User).filter(User.role == role_key).count()
    
    # 获取该角色的用户列表（最近10个）
    users = db.query(User).filter(User.role == role_key).order_by(User.created_at.desc()).limit(10).all()
    user_list = [
        {
            "id": u.id,
            "username": u.username,
            "created_at": u.created_at
        }
        for u in users
    ]
    
    # 角色信息
    role_info = {
        "admin": {
            "role_key": "admin",
            "role_name": "管理员",
            "description": "拥有所有权限，可以管理用户、爬虫等",
            "permissions": [
                "user_management",
                "crawler_management",
                "system_config",
                "data_export",
                "log_view"
            ]
        },
        "user": {
            "role_key": "user",
            "role_name": "普通用户",
            "description": "基础功能权限，可以使用数据查询、内容创作等功能",
            "permissions": [
                "data_view",
                "content_create",
                "social_manage",
                "personal_center"
            ]
        }
    }
    
    return {
        "code": 200,
        "data": {
            "role": role_info[role_key],
            "user_count": user_count,
            "recent_users": user_list
        },
        "message": "获取成功"
    }
