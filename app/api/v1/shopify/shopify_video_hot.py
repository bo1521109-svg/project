"""
独立站 - 热门视频接口
"""
from fastapi import APIRouter, Query
from typing import Optional

router = APIRouter()


@router.get("")
async def get_hot_videos(
    platform: Optional[str] = Query("Shopify", description="平台类型"),
    region: Optional[str] = Query("欧美", description="地区"),
    page: Optional[int] = Query(1, description="页码"),
    page_size: Optional[int] = Query(20, description="每页数量")
):
    """
    获取热门视频列表
    
    参数：
    - platform: 平台类型（Shopify, WordPress等）
    - region: 地区（欧美、拉美等）
    - page: 页码
    - page_size: 每页数量
    
    返回：
    - 热门视频列表
    - 视频数据包含：标题、封面、播放量、点赞数、评论数、发布时间等
    """
    return {
        "code": 200,
        "message": "success",
        "data": {
            "total": 0,
            "page": page,
            "page_size": page_size,
            "videos": []
        },
        "placeholder": True,
        "note": "功能开发中"
    }


@router.get("/{video_id}")
async def get_video_detail(video_id: str):
    """
    获取视频详情
    
    参数：
    - video_id: 视频ID
    
    返回：
    - 视频详细信息
    - 包含：视频链接、描述、标签、商品链接等
    """
    return {
        "code": 200,
        "message": "success",
        "data": {
            "video_id": video_id,
            "title": "",
            "description": "",
            "cover_url": "",
            "video_url": "",
            "play_count": 0,
            "like_count": 0,
            "comment_count": 0,
            "share_count": 0,
            "tags": [],
            "products": [],
            "created_at": ""
        },
        "placeholder": True,
        "note": "功能开发中"
    }


@router.get("/stats/trending")
async def get_trending_stats(
    platform: Optional[str] = Query("Shopify", description="平台类型"),
    region: Optional[str] = Query("欧美", description="地区"),
    days: Optional[int] = Query(7, description="统计天数")
):
    """
    获取热门视频趋势统计
    
    参数：
    - platform: 平台类型
    - region: 地区
    - days: 统计天数
    
    返回：
    - 热门视频趋势数据
    - 包含：播放量趋势、热门标签、热门商品等
    """
    return {
        "code": 200,
        "message": "success",
        "data": {
            "trending_tags": [],
            "trending_products": [],
            "play_trend": [],
            "category_distribution": []
        },
        "placeholder": True,
        "note": "功能开发中"
    }
