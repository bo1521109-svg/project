"""
我的 API 路由
"""
from fastapi import APIRouter

router = APIRouter()

# 导入所有"我的"相关的路由
from . import (
    my_creations,
    my_favorites
)

# 注册所有路由
router.include_router(my_creations.router, prefix="/creations", tags=["我的 创作"])
router.include_router(my_favorites.router, prefix="/favorites", tags=["我的 收藏"])
