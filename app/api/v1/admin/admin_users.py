"""
管理员 - 用户管理接口
"""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import func, desc
from typing import Optional
from datetime import datetime

from app.db.database import get_db
from app.models.user import User, LoginLog
from app.api.v1.auth import get_current_user, hash_password

router = APIRouter()


def require_admin(current_user: User = Depends(get_current_user)):
    """验证管理员权限"""
    if current_user.role != "admin":
        raise HTTPException(status_code=403, detail="需要管理员权限")
    return current_user


@router.get("")
async def get_users(
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    keyword: Optional[str] = Query(None, description="搜索关键词（用户名/手机号）"),
    role: Optional[str] = Query(None, description="角色筛选"),
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    获取用户列表（分页）
    """
    # 构建查询
    query = db.query(User)
    
    # 关键词搜索
    if keyword:
        query = query.filter(
            (User.username.ilike(f"%{keyword}%")) | 
            (User.phone.ilike(f"%{keyword}%"))
        )
    
    # 角色筛选
    if role:
        query = query.filter(User.role == role)
    
    # 总数
    total = query.count()
    
    # 分页
    users = query.order_by(desc(User.created_at)).offset((page - 1) * page_size).limit(page_size).all()
    
    # 统计每个用户的邀请人数和登录次数
    user_list = []
    for user in users:
        invited_count = db.query(User).filter(User.invited_by == user.id).count()
        login_count = db.query(LoginLog).filter(LoginLog.user_id == user.id).count()
        last_login = db.query(LoginLog).filter(LoginLog.user_id == user.id).order_by(desc(LoginLog.login_at)).first()
        
        user_list.append({
            "id": user.id,
            "username": user.username,
            "role": user.role,
            "phone": user.phone,
            "invitation_code": user.invitation_code,
            "invited_by": user.invited_by,
            "invited_count": invited_count,
            "login_count": login_count,
            "last_login_at": last_login.login_at if last_login else None,
            "created_at": user.created_at
        })
    
    return {
        "code": 200,
        "data": {
            "users": user_list,
            "pagination": {
                "page": page,
                "page_size": page_size,
                "total": total,
                "total_pages": (total + page_size - 1) // page_size
            }
        },
        "message": "获取成功"
    }


@router.get("/stats")
async def get_user_stats(
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    获取用户统计信息
    """
    # 总用户数
    total_users = db.query(User).count()
    
    # 管理员数量
    admin_count = db.query(User).filter(User.role == "admin").count()
    
    # 普通用户数量
    user_count = db.query(User).filter(User.role == "user").count()
    
    # 今日新增用户
    today = datetime.now().date()
    today_users = db.query(User).filter(func.date(User.created_at) == today).count()
    
    # 本周新增用户
    week_ago = datetime.now().date().replace(day=datetime.now().day - 7)
    week_users = db.query(User).filter(User.created_at >= week_ago).count()
    
    # 本月新增用户
    month_start = datetime.now().date().replace(day=1)
    month_users = db.query(User).filter(User.created_at >= month_start).count()
    
    return {
        "code": 200,
        "data": {
            "total_users": total_users,
            "admin_count": admin_count,
            "user_count": user_count,
            "today_new": today_users,
            "week_new": week_users,
            "month_new": month_users
        },
        "message": "获取成功"
    }


@router.get("/{user_id}")
async def get_user_detail(
    user_id: int,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    获取用户详情
    """
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    
    # 邀请人信息
    inviter = None
    if user.invited_by:
        inviter_user = db.query(User).filter(User.id == user.invited_by).first()
        if inviter_user:
            inviter = {
                "id": inviter_user.id,
                "username": inviter_user.username
            }
    
    # 被邀请的用户列表
    invited_users = db.query(User).filter(User.invited_by == user.id).all()
    invited_list = [{"id": u.id, "username": u.username, "created_at": u.created_at} for u in invited_users]
    
    # 登录记录（最近10条）
    login_logs = db.query(LoginLog).filter(LoginLog.user_id == user.id).order_by(desc(LoginLog.login_at)).limit(10).all()
    login_list = [{"login_at": log.login_at, "ip_address": log.ip_address} for log in login_logs]
    
    return {
        "code": 200,
        "data": {
            "id": user.id,
            "username": user.username,
            "role": user.role,
            "phone": user.phone,
            "invitation_code": user.invitation_code,
            "inviter": inviter,
            "invited_users": invited_list,
            "recent_logins": login_list,
            "created_at": user.created_at
        },
        "message": "获取成功"
    }


@router.put("/{user_id}/role")
async def update_user_role(
    user_id: int,
    role: str,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    修改用户角色
    """
    if role not in ["user", "admin"]:
        raise HTTPException(status_code=400, detail="无效的角色")
    
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    
    # 不能修改自己的角色
    if user.id == admin.id:
        raise HTTPException(status_code=400, detail="不能修改自己的角色")
    
    user.role = role
    db.commit()
    
    return {
        "code": 200,
        "data": {
            "id": user.id,
            "username": user.username,
            "role": user.role
        },
        "message": "角色修改成功"
    }


@router.put("/{user_id}/password")
async def reset_user_password(
    user_id: int,
    new_password: str,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    重置用户密码
    """
    if len(new_password) < 6:
        raise HTTPException(status_code=400, detail="密码长度至少6位")
    
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    
    user.password_hash = hash_password(new_password)
    db.commit()
    
    return {
        "code": 200,
        "data": {
            "id": user.id,
            "username": user.username
        },
        "message": "密码重置成功"
    }


@router.delete("/{user_id}")
async def delete_user(
    user_id: int,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    删除用户
    """
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    
    # 不能删除自己
    if user.id == admin.id:
        raise HTTPException(status_code=400, detail="不能删除自己")
    
    # 删除用户的登录日志
    db.query(LoginLog).filter(LoginLog.user_id == user_id).delete()
    
    # 删除用户
    db.delete(user)
    db.commit()
    
    return {
        "code": 200,
        "data": {},
        "message": "用户删除成功"
    }
