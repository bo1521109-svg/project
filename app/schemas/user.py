"""
用户相关的 Pydantic Schema
"""
from pydantic import BaseModel, ConfigDict, Field
from typing import Optional
from datetime import datetime


class UserRegister(BaseModel):
    """用户注册输入"""
    username: str = Field(..., min_length=3, max_length=50, description="用户名")
    password: str = Field(..., min_length=6, description="密码")
    phone: Optional[str] = Field(None, max_length=20, description="手机号（可选）")
    invitation_code: Optional[str] = Field(None, description="邀请码（可选）")


class UserLogin(BaseModel):
    """用户登录输入"""
    username: str = Field(..., description="用户名")
    password: str = Field(..., description="密码")
    ip_address: Optional[str] = Field(None, description="IP地址（可选）")


class UserResponse(BaseModel):
    """用户信息输出"""
    id: int
    username: str
    phone: Optional[str] = None
    invitation_code: str
    invited_by: Optional[int] = None
    invited_count: Optional[int] = 0  # 邀请了多少人
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


class TokenResponse(BaseModel):
    """登录返回 Token"""
    access_token: str
    token_type: str
    user_info: dict
