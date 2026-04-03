from fastapi import APIRouter
from .stores import router as stores_router

router = APIRouter()

router.include_router(stores_router, prefix="/stores", tags=["独立站管理"])
