"""
用户认证接口
"""
from datetime import datetime, timedelta
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from passlib.context import CryptContext
from jose import JWTError, jwt
import secrets
import string
import logging

from app.db.database import get_db
from app.models.user import User, LoginLog
from app.schemas.user import UserRegister, UserLogin, UserResponse, TokenResponse

router = APIRouter()
logger = logging.getLogger(__name__)

# 密码加密上下文（使用 bcrypt）
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# JWT 配置
SECRET_KEY = "your-secret-key-change-in-production"  # 生产环境请使用环境变量
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_DAYS = 7  # JWT 过期时间：7天

# HTTP Bearer 认证
security = HTTPBearer()


def generate_invitation_code(length: int = 8) -> str:
    """生成唯一邀请码"""
    characters = string.ascii_uppercase + string.digits
    return ''.join(secrets.choice(characters) for _ in range(length))


def hash_password(password: str) -> str:
    """加密密码（bcrypt 限制密码最多 72 字节）"""
    # bcrypt 限制密码最多 72 字节，超过部分会被截断
    if len(password.encode('utf-8')) > 72:
        password = password[:72]
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """验证密码（bcrypt 限制密码最多 72 字节）"""
    # bcrypt 限制密码最多 72 字节，超过部分会被截断
    if len(plain_password.encode('utf-8')) > 72:
        plain_password = plain_password[:72]
    return pwd_context.verify(plain_password, hashed_password)


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    """创建 JWT Token"""
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(days=ACCESS_TOKEN_EXPIRE_DAYS)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User:
    """
    依赖注入：获取当前登录用户（用于保护需要登录的接口）
    """
    token = credentials.credentials
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="无效的认证凭证",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id_str: str = payload.get("sub")
        if user_id_str is None:
            raise credentials_exception
        user_id = int(user_id_str)  # 将字符串转换为整数
    except (JWTError, ValueError):
        raise credentials_exception
    
    user = db.query(User).filter(User.id == user_id).first()
    if user is None:
        raise credentials_exception
    
    return user


@router.post("/register", response_model=UserResponse, summary="用户注册")
def register(user_data: UserRegister, db: Session = Depends(get_db)):
    """
    用户注册接口
    - 接收 username, password, invitation_code（可选）
    - 检查用户名唯一性
    - 加密密码
    - 生成唯一邀请码
    - 记录邀请关系
    """
    # 检查用户名是否已存在
    existing_user = db.query(User).filter(User.username == user_data.username).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="用户名已存在"
        )
    
    # 判断数据库中是否已有用户
    user_count = db.query(User).count()
    
    # 验证邀请码逻辑
    invited_by_id = None
    if user_count == 0:
        # 如果是第一个用户（count == 0），跳过邀请码验证，允许直接注册
        logger.info("第一个用户注册，跳过邀请码验证")
    else:
        # 如果有其他用户，则必须验证邀请码是否存在
        if not user_data.invitation_code:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="邀请码不存在，请检查或联系推荐人"
            )
        
        inviter = db.query(User).filter(User.invitation_code == user_data.invitation_code).first()
        if not inviter:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="邀请码不存在，请检查或联系推荐人"
            )
        invited_by_id = inviter.id
    
    # 生成唯一邀请码
    while True:
        new_invitation_code = generate_invitation_code()
        if not db.query(User).filter(User.invitation_code == new_invitation_code).first():
            break
    
    # 创建新用户
    new_user = User(
        username=user_data.username,
        password_hash=hash_password(user_data.password),
        phone=user_data.phone,
        invitation_code=new_invitation_code,
        invited_by=invited_by_id
    )
    
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    
    logger.info(f"用户注册成功: {new_user.username}, 邀请码: {new_user.invitation_code}")
    
    return new_user


@router.post("/login", response_model=TokenResponse, summary="用户登录")
def login(user_data: UserLogin, db: Session = Depends(get_db)):
    """
    用户登录接口
    - 接收 username, password
    - 验证用户名和密码
    - 返回 access_token, token_type, user_info
    """
    # 查找用户
    user = db.query(User).filter(User.username == user_data.username).first()
    if not user or not verify_password(user_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="用户名或密码错误"
        )
    
    # 创建 JWT Token（sub 必须是字符串）
    access_token = create_access_token(data={"sub": str(user.id)})
    
    # 记录登录日志（可选）
    login_log = LoginLog(
        user_id=user.id,
        ip_address=user_data.ip_address  # 可以从请求中获取
    )
    db.add(login_log)
    db.commit()
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user_info": {
            "id": user.id,
            "username": user.username,
            "phone": user.phone,
            "invitation_code": user.invitation_code,
            "created_at": user.created_at
        }
    }


@router.get("/users/me", response_model=UserResponse, summary="获取当前用户信息")
def get_me(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    """
    获取当前用户信息（需要 JWT 认证）
    - 返回当前用户信息（包含我的邀请码、邀请了多少人）
    """
    # 统计邀请了多少人
    invited_count = db.query(User).filter(User.invited_by == current_user.id).count()
    
    return {
        "id": current_user.id,
        "username": current_user.username,
        "phone": current_user.phone,
        "invitation_code": current_user.invitation_code,
        "invited_by": current_user.invited_by,
        "invited_count": invited_count,
        "created_at": current_user.created_at
    }
