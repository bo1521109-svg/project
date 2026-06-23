"""
建站模块 - 站点管理 API
"""
from datetime import datetime
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from sqlalchemy import desc

from app.db.database import get_db
from app.models.website import Website, Template
from app.models.user import User
from app.schemas.website import (
    WebsiteCreate, WebsiteUpdate, WebsiteResponse, WebsiteListResponse,
    TemplateResponse, TemplateListResponse
)
from app.api.v1.auth import get_current_user

router = APIRouter()


# ==================== 站点 CRUD ====================

@router.get("/websites", response_model=WebsiteListResponse, summary="获取站点列表")
def list_websites(
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(12, ge=1, le=100, description="每页数量"),
    search: Optional[str] = Query(None, description="按名称搜索"),
    status_filter: Optional[str] = Query(None, alias="status", description="按状态筛选"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """获取当前用户的站点列表，支持分页、搜索、状态筛选"""
    query = db.query(Website).filter(Website.user_id == current_user.id)

    # 搜索过滤
    if search:
        query = query.filter(Website.name.ilike(f"%{search}%"))

    # 状态过滤
    if status_filter:
        query = query.filter(Website.status == status_filter)

    # 统计总数
    total = query.count()

    # 分页+排序
    items = query.order_by(desc(Website.updated_at)).offset(
        (page - 1) * page_size
    ).limit(page_size).all()

    return WebsiteListResponse(total=total, items=items, page=page, page_size=page_size)


@router.post("/websites", response_model=WebsiteResponse, status_code=status.HTTP_201_CREATED, summary="创建站点")
def create_website(
    data: WebsiteCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """创建新站点"""
    website = Website(
        user_id=current_user.id,
        name=data.name,
        domain=data.domain,
        industry=data.industry,
        template_id=data.template_id,
        template_name=data.template_name,
        status="draft"
    )
    db.add(website)
    db.commit()
    db.refresh(website)
    return website


@router.get("/websites/{website_id}", response_model=WebsiteResponse, summary="获取站点详情")
def get_website(
    website_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """获取指定站点的详细信息"""
    website = db.query(Website).filter(
        Website.id == website_id,
        Website.user_id == current_user.id
    ).first()
    if not website:
        raise HTTPException(status_code=404, detail="站点不存在")
    return website


@router.put("/websites/{website_id}", response_model=WebsiteResponse, summary="更新站点")
def update_website(
    website_id: int,
    data: WebsiteUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """更新站点配置"""
    website = db.query(Website).filter(
        Website.id == website_id,
        Website.user_id == current_user.id
    ).first()
    if not website:
        raise HTTPException(status_code=404, detail="站点不存在")

    # 只更新传入的字段
    update_data = data.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(website, field, value)

    website.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(website)
    return website


@router.delete("/websites/{website_id}", status_code=status.HTTP_204_NO_CONTENT, summary="删除站点")
def delete_website(
    website_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """删除指定站点"""
    website = db.query(Website).filter(
        Website.id == website_id,
        Website.user_id == current_user.id
    ).first()
    if not website:
        raise HTTPException(status_code=404, detail="站点不存在")

    db.delete(website)
    db.commit()
    return None


# ==================== 发布/暂停 ====================

@router.post("/websites/{website_id}/publish", response_model=WebsiteResponse, summary="发布站点")
def publish_website(
    website_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """发布站点（草稿→已发布 / 暂停→已发布）"""
    website = db.query(Website).filter(
        Website.id == website_id,
        Website.user_id == current_user.id
    ).first()
    if not website:
        raise HTTPException(status_code=404, detail="站点不存在")
    if website.status == "published":
        raise HTTPException(status_code=400, detail="站点已发布，无需重复操作")

    website.status = "published"
    website.published_at = datetime.utcnow()
    website.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(website)
    return website


@router.post("/websites/{website_id}/pause", response_model=WebsiteResponse, summary="暂停站点")
def pause_website(
    website_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """暂停已发布的站点"""
    website = db.query(Website).filter(
        Website.id == website_id,
        Website.user_id == current_user.id
    ).first()
    if not website:
        raise HTTPException(status_code=404, detail="站点不存在")
    if website.status != "published":
        raise HTTPException(status_code=400, detail="只有已发布的站点才能暂停")

    website.status = "paused"
    website.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(website)
    return website


# ==================== 模板 ====================

@router.get("/templates", response_model=TemplateListResponse, summary="获取模板列表")
def list_templates(
    industry: Optional[str] = Query(None, description="按行业筛选"),
    db: Session = Depends(get_db)
):
    """获取可用的建站模板列表"""
    query = db.query(Template).filter(Template.is_active == True)

    if industry:
        query = query.filter(Template.industry == industry)

    items = query.order_by(Template.sort_order).all()
    return TemplateListResponse(total=len(items), items=items)
