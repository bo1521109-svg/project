from fastapi import APIRouter
from Myproject.schemas.user import User, UserCreate

router = APIRouter()


@router.get("/", response_model=list[User])
async def get_users():
    return [
        {"id": 1, "username": "user1", "email": "user1@example.com"},
        {"id": 2, "username": "user2", "email": "user2@example.com"}
    ]


@router.post("/", response_model=User)
async def create_user(user: UserCreate):
    return {"id": 1, "username": user.username, "email": user.email}
