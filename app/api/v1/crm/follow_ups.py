"""
跟进记录 API
"""
from fastapi import APIRouter, Query, Body

router = APIRouter()

MOCK_FOLLOW_UPS = [
    {"id": 1, "customer_id": 5, "customer_name": "Michael Brown", "type": "电话回访", "type_icon": "phone", "content": "确认下月订单数量和交期，客户对产品质量很满意", "status": "completed", "status_label": "已完成", "staff": "张三", "created_at": "2026-06-03 10:00", "next_follow_up": None},
    {"id": 2, "customer_id": 7, "customer_name": "Sophie Laurent", "type": "邮件跟进", "type_icon": "email", "content": "发送了全套产品资料和报价，客户表示需要时间评估", "status": "completed", "status_label": "已完成", "staff": "李四", "created_at": "2026-06-03 09:30", "next_follow_up": "2026-06-05 10:00"},
    {"id": 3, "customer_id": 1, "customer_name": "Carlos Mendes", "type": "WhatsApp消息", "type_icon": "whatsapp", "content": "样品已发出，提供物流单号，客户确认收到后会测试", "status": "completed", "status_label": "已完成", "staff": "张三", "created_at": "2026-06-03 14:00", "next_follow_up": "2026-06-10 10:00"},
    {"id": 4, "customer_id": 6, "customer_name": "Ahmed Rashid", "type": "视频会议", "type_icon": "video", "content": "远程产品演示，客户对手机配件系列很感兴趣", "status": "completed", "status_label": "已完成", "staff": "王五", "created_at": "2026-06-03 08:00", "next_follow_up": "2026-06-04 10:00"},
    {"id": 5, "customer_id": 11, "customer_name": "Anna Fischer", "type": "邮件跟进", "type_icon": "email", "content": "提供CE/RoHS认证文件和OEM报价方案", "status": "completed", "status_label": "已完成", "staff": "李四", "created_at": "2026-06-02 17:00", "next_follow_up": "2026-06-05 14:00"},
    {"id": 6, "customer_id": 4, "customer_name": "Priya Kapoor", "type": "电话回访", "type_icon": "phone", "content": "跟进之前报价，客户仍在多家比价中", "status": "pending", "status_label": "待跟进", "staff": "张三", "created_at": "2026-06-02 11:00", "next_follow_up": "2026-06-04 15:00"},
    {"id": 7, "customer_id": 12, "customer_name": "Omar Hassan", "type": "WhatsApp消息", "type_icon": "whatsapp", "content": "发送北非市场成功案例和产品价格表", "status": "pending", "status_label": "待跟进", "staff": "王五", "created_at": "2026-06-03 12:00", "next_follow_up": "2026-06-06 10:00"},
    {"id": 8, "customer_id": 3, "customer_name": "田中 健一", "type": "邮件跟进", "type_icon": "email", "content": "提供日本市场定制化方案和物流支持说明", "status": "completed", "status_label": "已完成", "staff": "李四", "created_at": "2026-06-01 16:00", "next_follow_up": "2026-06-04 09:00"},
    {"id": 9, "customer_id": 8, "customer_name": "Robert Kim", "type": "电话回访", "type_icon": "phone", "content": "介绍品牌代理政策和韩国市场支持方案", "status": "completed", "status_label": "已完成", "staff": "张三", "created_at": "2026-06-02 15:00", "next_follow_up": "2026-06-06 14:00"},
    {"id": 10, "customer_id": 2, "customer_name": "Emma Wilson", "type": "视频会议", "type_icon": "video", "content": "讨论批发价格和长期合作协议细节", "status": "pending", "status_label": "待跟进", "staff": "王五", "created_at": "2026-06-02 16:30", "next_follow_up": "2026-06-04 10:00"},
    {"id": 11, "customer_id": 5, "customer_name": "Michael Brown", "type": "样品寄送", "type_icon": "parcel", "content": "新款无线充电器样品寄出，附赠产品手册", "status": "completed", "status_label": "已完成", "staff": "李四", "created_at": "2026-06-01 10:00", "next_follow_up": "2026-06-07 10:00"},
    {"id": 12, "customer_id": 10, "customer_name": "David Chen", "type": "合同签署", "type_icon": "document", "content": "签署年度框架协议续约，维持原有优惠条款", "status": "completed", "status_label": "已完成", "staff": "王五", "created_at": "2026-06-01 14:00", "next_follow_up": None},
]


@router.get("")
async def get_follow_ups(
    page: int = Query(1, ge=1),
    page_size: int = Query(10, ge=1, le=50),
    status: str = Query("", description="状态: completed/pending"),
    staff: str = Query("", description="跟进人筛选"),
    customer_search: str = Query("", description="客户名搜索"),
    type: str = Query("", description="跟进类型"),
):
    """GET /api/v1/crm/follow-ups - 跟进记录列表"""
    filtered = MOCK_FOLLOW_UPS.copy()

    if status:
        filtered = [f for f in filtered if f["status"] == status]
    if staff:
        filtered = [f for f in filtered if f["staff"] == staff]
    if type:
        filtered = [f for f in filtered if f["type"] == type]
    if customer_search:
        keyword = customer_search.lower()
        filtered = [f for f in filtered if keyword in f["customer_name"].lower()]

    filtered.sort(key=lambda x: x["created_at"], reverse=True)
    total = len(filtered)
    start = (page - 1) * page_size
    end = start + page_size

    return {
        "code": 200,
        "data": {
            "items": filtered[start:end],
            "total": total,
            "page": page,
            "page_size": page_size,
            "total_pages": max(1, (total + page_size - 1) // page_size)
        },
        "message": "获取跟进记录成功"
    }


@router.post("")
async def create_follow_up(
    customer_id: int = Body(..., description="客户ID"),
    type: str = Body(..., description="跟进类型"),
    content: str = Body(..., description="跟进内容"),
    next_follow_up: str = Body(None, description="下次跟进时间"),
    staff: str = Body("张三", description="跟进人"),
):
    """POST /api/v1/crm/follow-ups - 创建跟进记录"""
    return {
        "code": 200,
        "data": {
            "id": len(MOCK_FOLLOW_UPS) + 1,
            "customer_id": customer_id,
            "type": type,
            "content": content,
            "next_follow_up": next_follow_up,
            "staff": staff,
            "status": "completed",
            "created_at": "2026-06-03 16:30"
        },
        "message": "跟进记录创建成功"
    }
