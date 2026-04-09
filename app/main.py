from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1 import router as api_v1_router
from app.models.store import Base
from app.db.database import engine
from app.core.config import settings
from app.core.logging_config import logger

# 自动创建数据库表结构
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="跨境电商独立站数据平台 - 第一期 MVP",
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_tags=[
        {
            "name": "独立站管理",
            "description": "管理 Shopify 独立站店铺，包括添加、查询、爬取等操作"
        },
        {
            "name": "商品管理",
            "description": "查询和管理爬取到的商品数据"
        },
        {
            "name": "default",
            "description": "系统基础接口"
        }
    ]
)

# CORS 中间件配置
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 注册 API 路由
app.include_router(api_v1_router, prefix=settings.API_PREFIX)


@app.on_event("startup")
async def startup_event():
    """应用启动时记录日志"""
    logger.info(f"{settings.PROJECT_NAME} 启动成功")
    logger.info(f"API 文档: http://localhost:8000/docs")


@app.get("/", tags=["default"], summary="根路径", description="返回系统欢迎信息和版本号")
async def root():
    """
    ## 系统根路径
    
    返回系统基本信息，确认服务正常运行。
    """
    return {"message": "系统启动成功，仅独立站模式", "version": settings.VERSION}


@app.get("/health", tags=["default"], summary="健康检查", description="检查系统和数据库连接状态")
async def health_check():
    """
    ## 健康检查接口
    
    用于监控系统运行状态，确认数据库连接正常。
    """
    return {"status": "healthy", "database": "connected"}
