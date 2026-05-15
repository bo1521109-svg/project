"""
平台管理 - 爬虫任务管理 API
"""
from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks
from sqlalchemy.orm import Session
from typing import List, Optional
from app.db.database import get_db
from app.models.store import Store
from app.models.user import User
from app.api.v1.auth import get_current_user
from pydantic import BaseModel
from datetime import datetime

router = APIRouter()


class CrawlerTaskCreate(BaseModel):
    """创建爬虫任务的请求模型"""
    name: str
    url: str
    platform: str = "shopify"
    country: Optional[str] = None
    target_country_code: Optional[str] = None  # 新增：任务配置-目标国家代码
    target_category_code: Optional[str] = None  # 新增：任务配置-目标类目代码


class CrawlerTaskResponse(BaseModel):
    """爬虫任务响应模型"""
    id: int
    name: str
    url: str
    platform: str
    country: Optional[str] = None
    target_country_code: Optional[str] = None  # 新增：任务配置-目标国家代码
    target_category_code: Optional[str] = None  # 新增：任务配置-目标类目代码
    is_manual_reviewed: bool = False  # 新增：是否人工复核过
    status: str
    last_crawl_at: Optional[datetime] = None
    is_crawling: bool = False

    class Config:
        from_attributes = True


@router.get("", response_model=List[CrawlerTaskResponse])
async def get_crawler_tasks(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    获取所有爬虫任务列表
    """
    tasks = db.query(Store).all()
    return tasks


@router.post("", response_model=CrawlerTaskResponse)
async def create_crawler_task(
    task: CrawlerTaskCreate, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    创建新的爬虫任务
    """
    # 检查是否已存在相同URL的任务
    existing_task = db.query(Store).filter(Store.url == task.url).first()
    if existing_task:
        raise HTTPException(status_code=400, detail="该URL的爬虫任务已存在")
    
    # 创建新任务
    new_task = Store(
        name=task.name,
        url=task.url,
        platform=task.platform,
        country=task.country,
        target_country_code=task.target_country_code,  # 新增：任务配置
        target_category_code=task.target_category_code,  # 新增：任务配置
        status="active",
        data_source="task_config"  # 标记数据来源为任务配置
    )
    
    db.add(new_task)
    db.commit()
    db.refresh(new_task)
    
    return new_task


@router.post("/{task_id}/crawl")
async def start_crawl_task(
    task_id: int, 
    background_tasks: BackgroundTasks, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    启动爬虫任务
    """
    from app.crawler.tasks import crawl_task_async
    
    task = db.query(Store).filter(Store.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="爬虫任务不存在")
    
    # 检查是否正在爬取
    if task.is_crawling:
        raise HTTPException(status_code=400, detail="该爬虫任务正在执行中，请稍后再试")
    
    # 更新状态为爬取中
    task.is_crawling = True
    db.commit()
    
    # 调用实际的爬虫逻辑（后台任务）
    background_tasks.add_task(
        crawl_task_async,
        store_id=task_id,
        store_url=task.url
    )
    
    return {"message": f"爬虫任务 {task.name} 已启动", "task_id": task_id}


@router.delete("/{task_id}")
async def delete_crawler_task(
    task_id: int, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    删除爬虫任务
    """
    task = db.query(Store).filter(Store.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="爬虫任务不存在")
    
    db.delete(task)
    db.commit()
    
    return {"message": f"爬虫任务 {task.name} 已删除", "task_id": task_id}


@router.get("/{task_id}", response_model=CrawlerTaskResponse)
async def get_crawler_task(
    task_id: int, 
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    获取单个爬虫任务详情
    """
    task = db.query(Store).filter(Store.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="爬虫任务不存在")
    
    return task
