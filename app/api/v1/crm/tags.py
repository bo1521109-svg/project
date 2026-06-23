"""
标签管理 API
"""
from fastapi import APIRouter, Body

router = APIRouter()

MOCK_TAGS = [
    {"id": 1, "name": "高意向", "color": "#F56C6C", "customer_count": 423},
    {"id": 2, "name": "VIP客户", "color": "#E6A23C", "customer_count": 156},
    {"id": 3, "name": "批發", "color": "#409EFF", "customer_count": 345},
    {"id": 4, "name": "样品申請", "color": "#67C23A", "customer_count": 278},
    {"id": 5, "name": "詢價", "color": "#909399", "customer_count": 412},
    {"id": 6, "name": "OEM", "color": "#8B5CF6", "customer_count": 189},
    {"id": 7, "name": "代理", "color": "#06B6D4", "customer_count": 234},
    {"id": 8, "name": "比價", "color": "#F97316", "customer_count": 298},
    {"id": 9, "name": "零售", "color": "#14B8A6", "customer_count": 567},
    {"id": 10, "name": "長期合作", "color": "#EC4899", "customer_count": 189},
    {"id": 11, "name": "中東市場", "color": "#D4A574", "customer_count": 86},
    {"id": 12, "name": "北非市場", "color": "#6B7280", "customer_count": 45},
    {"id": 13, "name": "認證需求", "color": "#3B82F6", "customer_count": 67},
    {"id": 14, "name": "品牌代理", "color": "#7C3AED", "customer_count": 98},
    {"id": 15, "name": "分銷商", "color": "#059669", "customer_count": 134},
]


@router.get("")
async def get_tags():
    """GET /api/v1/crm/tags - 标签列表"""
    return {
        "code": 200,
        "data": {
            "items": MOCK_TAGS,
            "total": len(MOCK_TAGS)
        },
        "message": "获取标签列表成功"
    }


@router.post("")
async def create_tag(
    name: str = Body(..., description="标签名称"),
    color: str = Body("#409EFF", description="标签颜色"),
):
    """POST /api/v1/crm/tags - 创建标签"""
    return {
        "code": 200,
        "data": {
            "id": len(MOCK_TAGS) + 1,
            "name": name,
            "color": color,
            "customer_count": 0
        },
        "message": "标签创建成功"
    }


@router.put("/{tag_id}")
async def update_tag(
    tag_id: int,
    name: str = Body(None, description="标签名称"),
    color: str = Body(None, description="标签颜色"),
):
    """PUT /api/v1/crm/tags/{id} - 更新标签"""
    return {
        "code": 200,
        "data": {"id": tag_id, "updated": True},
        "message": "标签更新成功"
    }


@router.delete("/{tag_id}")
async def delete_tag(tag_id: int):
    """DELETE /api/v1/crm/tags/{id} - 删除标签"""
    return {
        "code": 200,
        "data": {"id": tag_id, "deleted": True},
        "message": "标签删除成功"
    }
