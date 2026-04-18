"""
用户模型
"""
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.sql import func
from app.db.base import Base


class User(Base):
    """用户表"""
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True, comment="用户ID")
    username = Column(String(50), unique=True, nullable=False, index=True, comment="用户名（唯一）")
    password_hash = Column(String(255), nullable=False, comment="密码哈希（加密存储）")
    role = Column(String(20), nullable=False, default="user", comment="用户角色（user/admin）")
    phone = Column(String(20), nullable=True, comment="手机号（可选）")
    invitation_code = Column(String(20), unique=True, nullable=False, index=True, comment="邀请码（唯一，自动生成）")
    invited_by = Column(Integer, ForeignKey("users.id"), nullable=True, comment="邀请人ID（外键，指向邀请人）")
    created_at = Column(DateTime(timezone=True), server_default=func.now(), comment="创建时间")

    def __repr__(self):
        return f"<User(id={self.id}, username={self.username})>"


class LoginLog(Base):
    """登录日志表（可选，用于审计）"""
    __tablename__ = "login_logs"

    id = Column(Integer, primary_key=True, index=True, comment="日志ID")
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, comment="用户ID（外键）")
    login_at = Column(DateTime(timezone=True), server_default=func.now(), comment="登录时间")
    ip_address = Column(String(45), nullable=True, comment="IP地址（支持IPv6）")

    def __repr__(self):
        return f"<LoginLog(id={self.id}, user_id={self.user_id}, login_at={self.login_at})>"
