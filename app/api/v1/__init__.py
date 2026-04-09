from fastapi import APIRouter
from .stores import router as stores_router
from .products import router as products_router
from .auth import router as auth_router

router = APIRouter()

router.include_router(stores_router, prefix="/stores", tags=["独立站管理"])
router.include_router(products_router, prefix="/products", tags=["商品管理"])
router.include_router(auth_router, prefix="/auth", tags=["用户认证"])
