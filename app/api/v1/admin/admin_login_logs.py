"""
管理员 - 登录日志管理接口
"""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import func, desc
from typing import Optional
from datetime import datetime, timedelta

from app.db.database import get_db
from app.models.user import User, LoginLog
from app.api.v1.auth import get_current_user

router = APIRouter()


def require_admin(current_user: User = Depends(get_current_user)):
    """验证管理员权限"""
    if current_user.role != "admin":
        raise HTTPException(status_code=403, detail="需要管理员权限")
    return current_user


@router.get("/")
async def get_login_logs(
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    user_id: Optional[int] = Query(None, description="用户ID筛选"),
    username: Optional[str] = Query(None, description="用户名搜索"),
    start_date: Optional[str] = Query(None, description="开始日期（YYYY-MM-DD）"),
    end_date: Optional[str] = Query(None, description="结束日期（YYYY-MM-DD）"),
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    获取登录日志列表（分页）
    """
    # 构建查询
    query = db.query(LoginLog, User).join(User, LoginLog.user_id == User.id)
    
    # 用户ID筛选
    if user_id:
        query = query.filter(LoginLog.user_id == user_id)
    
    # 用户名搜索
    if username:
        query = query.filter(User.username.ilike(f"%{username}%"))
    
    # 日期范围筛选
    if start_date:
        try:
            start_dt = datetime.strptime(start_date, "%Y-%m-%d")
            query = query.filter(LoginLog.login_at >= start_dt)
        except ValueError:
            raise HTTPException(status_code=400, detail="开始日期格式错误")
    
    if end_date:
        try:
            end_dt = datetime.strptime(end_date, "%Y-%m-%d") + timedelta(days=1)
            query = query.filter(LoginLog.login_at < end_dt)
        except ValueError:
            raise HTTPException(status_code=400, detail="结束日期格式错误")
    
    # 总数
    total = query.count()
    
    # 分页
    results = query.order_by(desc(LoginLog.login_at)).offset((page - 1) * page_size).limit(page_size).all()
    
    # 构建返回数据
    logs = []
    for log, user in results:
        logs.append({
            "id": log.id,
            "user_id": user.id,
            "username": user.username,
            "role": user.role,
            "login_at": log.login_at,
            "ip_address": log.ip_address
        })
    
    return {
        "code": 200,
        "data": {
            "logs": logs,
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
async def get_login_stats(
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    获取登录统计信息
    """
    # 总登录次数
    total_logins = db.query(LoginLog).count()
    
    # 今日登录次数
    today = datetime.now().date()
    today_logins = db.query(LoginLog).filter(func.date(LoginLog.login_at) == today).count()
    
    # 本周登录次数
    week_ago = datetime.now() - timedelta(days=7)
    week_logins = db.query(LoginLog).filter(LoginLog.login_at >= week_ago).count()
    
    # 本月登录次数
    month_start = datetime.now().replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    month_logins = db.query(LoginLog).filter(LoginLog.login_at >= month_start).count()
    
    # 活跃用户数（本周至少登录一次）
    active_users = db.query(LoginLog.user_id).filter(
        LoginLog.login_at >= week_ago
    ).distinct().count()
    
    # 最近7天每日登录趋势
    daily_stats = []
    for i in range(6, -1, -1):
        date = (datetime.now() - timedelta(days=i)).date()
        count = db.query(LoginLog).filter(func.date(LoginLog.login_at) == date).count()
        daily_stats.append({
            "date": date.strftime("%Y-%m-%d"),
            "count": count
        })
    
    # 登录次数最多的用户（Top 10）
    top_users = db.query(
        User.id,
        User.username,
        func.count(LoginLog.id).label("login_count")
    ).join(LoginLog, User.id == LoginLog.user_id).group_by(
        User.id, User.username
    ).order_by(desc("login_count")).limit(10).all()
    
    top_users_list = [
        {
            "user_id": u.id,
            "username": u.username,
            "login_count": u.login_count
        }
        for u in top_users
    ]
    
    return {
        "code": 200,
        "data": {
            "total_logins": total_logins,
            "today_logins": today_logins,
            "week_logins": week_logins,
            "month_logins": month_logins,
            "active_users": active_users,
            "daily_trend": daily_stats,
            "top_users": top_users_list
        },
        "message": "获取成功"
    }


@router.get("/{log_id}")
async def get_login_log_detail(
    log_id: int,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    获取登录日志详情
    """
    result = db.query(LoginLog, User).join(
        User, LoginLog.user_id == User.id
    ).filter(LoginLog.id == log_id).first()
    
    if not result:
        raise HTTPException(status_code=404, detail="日志不存在")
    
    log, user = result
    
    # 获取该用户的前后登录记录
    prev_log = db.query(LoginLog).filter(
        LoginLog.user_id == user.id,
        LoginLog.login_at < log.login_at
    ).order_by(desc(LoginLog.login_at)).first()
    
    next_log = db.query(LoginLog).filter(
        LoginLog.user_id == user.id,
        LoginLog.login_at > log.login_at
    ).order_by(LoginLog.login_at).first()
    
    return {
        "code": 200,
        "data": {
            "log": {
                "id": log.id,
                "login_at": log.login_at,
                "ip_address": log.ip_address
            },
            "user": {
                "id": user.id,
                "username": user.username,
                "role": user.role,
                "phone": user.phone
            },
            "prev_login": {
                "id": prev_log.id,
                "login_at": prev_log.login_at
            } if prev_log else None,
            "next_login": {
                "id": next_log.id,
                "login_at": next_log.login_at
            } if next_log else None
        },
        "message": "获取成功"
    }


@router.delete("/{log_id}")
async def delete_login_log(
    log_id: int,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    删除登录日志
    """
    log = db.query(LoginLog).filter(LoginLog.id == log_id).first()
    if not log:
        raise HTTPException(status_code=404, detail="日志不存在")
    
    db.delete(log)
    db.commit()
    
    return {
        "code": 200,
        "data": {},
        "message": "日志删除成功"
    }


@router.delete("/batch")
async def batch_delete_logs(
    user_id: Optional[int] = Query(None, description="删除指定用户的所有日志"),
    before_date: Optional[str] = Query(None, description="删除指定日期之前的日志（YYYY-MM-DD）"),
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin)
):
    """
    批量删除登录日志
    """
    query = db.query(LoginLog)
    
    # 按用户ID删除
    if user_id:
        query = query.filter(LoginLog.user_id == user_id)
    
    # 按日期删除
    if before_date:
        try:
            before_dt = datetime.strptime(before_date, "%Y-%m-%d")
            query = query.filter(LoginLog.login_at < before_dt)
        except ValueError:
            raise HTTPException(status_code=400, detail="日期格式错误")
    
    # 如果没有任何筛选条件，拒绝删除
    if not user_id and not before_date:
        raise HTTPException(status_code=400, detail="必须指定删除条件")
    
    # 执行删除
    deleted_count = query.delete()
    db.commit()
    
    return {
        "code": 200,
        "data": {
            "deleted_count": deleted_count
        },
        "message": f"成功删除 {deleted_count} 条日志"
    }
