from fastapi import APIRouter
from Myproject.api import users

router = APIRouter()

router.include_router(users.router, prefix="/users", tags=["users"])
