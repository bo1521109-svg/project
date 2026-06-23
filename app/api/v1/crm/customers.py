"""
客户管理 API
"""
from fastapi import APIRouter, Query, Body

router = APIRouter()

# 模拟客户数据
MOCK_CUSTOMERS = [
    {"id": 1, "name": "Carlos Mendes", "email": "carlos@email.com.br", "phone": "+55 11 99999-8888", "country": "巴西", "source": "TikTok", "source_tag": "TikTok视频评论区", "status": "potential", "status_label": "潜在客户", "interest": "蓝牙耳机", "tags": ["高意向", "询价"], "budget": "$5,000-10,000", "notes": "对ANC降噪功能特别感兴趣，需要样品测试", "created_at": "2026-05-28 10:15", "last_contact": "2026-06-03 14:00", "orders": 0, "total_spent": 0},
    {"id": 2, "name": "Emma Wilson", "email": "emma.w@email.com", "phone": "+1 415 555-0123", "country": "美国", "source": "独立站", "source_tag": "独立站询盘表单", "status": "negotiating", "status_label": "洽谈中", "interest": "智能手表", "tags": ["B2B批发", "高意向"], "budget": "$50,000+", "notes": "批发客户，月需求量500台以上，价格敏感", "created_at": "2026-05-25 09:30", "last_contact": "2026-06-03 11:20", "orders": 2, "total_spent": 18500},
    {"id": 3, "name": "田中 健一", "email": "tanaka@email.jp", "phone": "+81 90-1234-5678", "country": "日本", "source": "Instagram", "source_tag": "Instagram DM", "status": "potential", "status_label": "潜在客户", "interest": "美容仪器", "tags": ["样品申请", "分销商"], "budget": "$20,000-30,000", "notes": "日本地区分销商，有线下实体店渠道", "created_at": "2026-05-22 14:45", "last_contact": "2026-06-02 16:30", "orders": 0, "total_spent": 0},
    {"id": 4, "name": "Priya Kapoor", "email": "priya.k@email.in", "phone": "+91 98765-43210", "country": "印度", "source": "Facebook", "source_tag": "Facebook广告", "status": "contacted", "status_label": "已联系", "interest": "充电器/数据线", "tags": ["低意向", "比价"], "budget": "$1,000-3,000", "notes": "多家比价中，对MOQ有顾虑", "created_at": "2026-05-20 11:00", "last_contact": "2026-06-01 10:00", "orders": 0, "total_spent": 0},
    {"id": 5, "name": "Michael Brown", "email": "michael.b@email.co.uk", "phone": "+44 20 7946 0123", "country": "英国", "source": "独立站", "source_tag": "Google搜索", "status": "contracted", "status_label": "已成交", "interest": "无线充电器", "tags": ["VIP客户", "长期合作"], "budget": "$100,000+", "notes": "长期合作客户，每月稳定下单", "created_at": "2026-04-15 08:20", "last_contact": "2026-06-03 09:15", "orders": 15, "total_spent": 125800},
    {"id": 6, "name": "Ahmed Rashid", "email": "ahmed.r@email.ae", "phone": "+971 50 123 4567", "country": "阿联酋", "source": "WhatsApp", "source_tag": "WhatsApp群组", "status": "negotiating", "status_label": "洽谈中", "interest": "手机配件全系列", "tags": ["中东市场", "高意向"], "budget": "$30,000-50,000", "notes": "迪拜电子产品批发商，独家代理需求", "created_at": "2026-05-18 13:30", "last_contact": "2026-06-03 15:45", "orders": 1, "total_spent": 8500},
    {"id": 7, "name": "Sophie Laurent", "email": "sophie.l@email.fr", "phone": "+33 6 12 34 56 78", "country": "法国", "source": "Instagram", "source_tag": "KOL推荐", "status": "contacted", "status_label": "已联系", "interest": "护肤品", "tags": ["询价", "样品申请"], "budget": "$5,000-8,000", "notes": "法国本土美妆博主推荐来的客户", "created_at": "2026-06-01 10:00", "last_contact": "2026-06-02 14:30", "orders": 0, "total_spent": 0},
    {"id": 8, "name": "Robert Kim", "email": "robert.k@email.kr", "phone": "+82 10-1234-5678", "country": "韩国", "source": "TikTok", "source_tag": "TikTok直播", "status": "potential", "status_label": "潜在客户", "interest": "耳机/音箱", "tags": ["高意向", "品牌代理"], "budget": "$15,000-25,000", "notes": "韩国地区品牌代理意向，有电商运营经验", "created_at": "2026-05-30 16:20", "last_contact": "2026-06-03 10:00", "orders": 0, "total_spent": 0},
    {"id": 9, "name": "Maria Garcia", "email": "maria.g@email.mx", "phone": "+52 55 1234 5678", "country": "墨西哥", "source": "Facebook", "source_tag": "Facebook群组", "status": "contacted", "status_label": "已联系", "interest": "家居用品", "tags": ["低意向", "零售"], "budget": "$2,000-5,000", "notes": "小型零售店主，试单意愿强", "created_at": "2026-05-28 09:00", "last_contact": "2026-06-01 11:00", "orders": 0, "total_spent": 0},
    {"id": 10, "name": "David Chen", "email": "david.c@email.sg", "phone": "+65 9123 4567", "country": "新加坡", "source": "独立站", "source_tag": "Referral推荐", "status": "contracted", "status_label": "已成交", "interest": "智能家居", "tags": ["VIP客户", "长期合作"], "budget": "$200,000+", "notes": "东南亚最大客户，月度采购额$20k+", "created_at": "2026-03-10 10:00", "last_contact": "2026-06-03 08:00", "orders": 28, "total_spent": 268500},
    {"id": 11, "name": "Anna Fischer", "email": "anna.f@email.de", "phone": "+49 30 12345678", "country": "德国", "source": "独立站", "source_tag": "B2B平台", "status": "negotiating", "status_label": "洽谈中", "interest": "太阳能充电器", "tags": ["认证需求", "OEM"], "budget": "$40,000-60,000", "notes": "需要CE/RoHS认证，OEM贴牌需求", "created_at": "2026-05-15 14:00", "last_contact": "2026-06-02 17:00", "orders": 0, "total_spent": 0},
    {"id": 12, "name": "Omar Hassan", "email": "omar.h@email.eg", "phone": "+20 10 1234 5678", "country": "埃及", "source": "WhatsApp", "source_tag": "WhatsApp Business", "status": "potential", "status_label": "潜在客户", "interest": "手机配件", "tags": ["北非市场", "批发"], "budget": "$10,000-15,000", "notes": "北非地区批发商，开拓新市场机会", "created_at": "2026-06-02 12:30", "last_contact": "2026-06-03 12:00", "orders": 0, "total_spent": 0},
]

MOCK_FOLLOW_UPS = {
    1: [
        {"id": 101, "customer_id": 1, "type": "WhatsApp消息", "content": "发送了蓝牙耳机产品目录和报价单", "created_at": "2026-06-02 10:00", "staff": "张三"},
        {"id": 102, "customer_id": 1, "type": "电话沟通", "content": "客户对ANC降噪功能很感兴趣，要求寄样品", "created_at": "2026-06-01 15:30", "staff": "张三"},
        {"id": 103, "customer_id": 1, "type": "首次联系", "content": "TikTok视频评论区留言询问价格，主动私信联系", "created_at": "2026-05-28 14:00", "staff": "张三"},
    ]
}


@router.get("")
async def get_customers(
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(10, ge=1, le=50, description="每页数量"),
    search: str = Query("", description="搜索关键词(客户名/邮箱/电话)"),
    status: str = Query("", description="状态筛选: potential/contacted/negotiating/contracted"),
    source: str = Query("", description="来源筛选"),
    tag: str = Query("", description="标签筛选"),
    sort_by: str = Query("created_at", description="排序字段"),
    sort_order: str = Query("desc", description="排序方向: asc/desc"),
):
    """GET /api/v1/crm/customers - 客户列表(分页+筛选)"""
    filtered = MOCK_CUSTOMERS.copy()

    if search:
        keyword = search.lower()
        filtered = [c for c in filtered if
                    keyword in c["name"].lower() or
                    keyword in c["email"].lower() or
                    keyword in c["phone"].lower()]

    if status:
        filtered = [c for c in filtered if c["status"] == status]

    if source:
        filtered = [c for c in filtered if c["source"] == source]

    if tag:
        filtered = [c for c in filtered if tag in c["tags"]]

    # 排序
    reverse = sort_order == "desc"
    if sort_by in ["created_at", "last_contact"]:
        filtered.sort(key=lambda x: x[sort_by], reverse=reverse)
    elif sort_by in ["orders", "total_spent"]:
        filtered.sort(key=lambda x: x[sort_by], reverse=reverse)

    total = len(filtered)
    start = (page - 1) * page_size
    end = start + page_size
    items = filtered[start:end]

    return {
        "code": 200,
        "data": {
            "items": items,
            "total": total,
            "page": page,
            "page_size": page_size,
            "total_pages": (total + page_size - 1) // page_size if total > 0 else 1
        },
        "message": "获取客户列表成功"
    }


@router.get("/{customer_id}")
async def get_customer_detail(customer_id: int):
    """GET /api/v1/crm/customers/{id} - 客户详情"""
    customer = next((c for c in MOCK_CUSTOMERS if c["id"] == customer_id), None)
    if not customer:
        return {"code": 404, "data": None, "message": "客户不存在"}

    follow_ups = MOCK_FOLLOW_UPS.get(customer_id, [])

    # 为其他客户生成通用跟进记录
    if customer_id not in MOCK_FOLLOW_UPS:
        follow_ups = [
            {"id": customer_id * 1000 + 1, "customer_id": customer_id,
             "type": "首次联系", "content": "客户通过{}首次联系".format(customer["source_tag"]),
             "created_at": customer["created_at"], "staff": "张三"},
        ]

    return {
        "code": 200,
        "data": {
            "customer": customer,
            "follow_ups": follow_ups
        },
        "message": "获取客户详情成功"
    }


@router.post("")
async def create_customer(
    name: str = Body(..., description="客户名称"),
    email: str = Body("", description="邮箱"),
    phone: str = Body("", description="电话"),
    country: str = Body("", description="国家"),
    source: str = Body("独立站", description="来源渠道"),
    interest: str = Body("", description="感兴趣产品"),
    tags: list = Body([], description="标签列表"),
    notes: str = Body("", description="备注"),
):
    """POST /api/v1/crm/customers - 创建客户"""
    new_id = max(c["id"] for c in MOCK_CUSTOMERS) + 1
    return {
        "code": 200,
        "data": {
            "id": new_id,
            "name": name,
            "email": email,
            "phone": phone,
            "country": country,
            "source": source,
            "interest": interest,
            "tags": tags,
            "notes": notes,
            "status": "potential",
            "created_at": "2026-06-03 16:00",
        },
        "message": "客户创建成功"
    }


@router.put("/{customer_id}")
async def update_customer(
    customer_id: int,
    name: str = Body(None, description="客户名称"),
    status: str = Body(None, description="状态"),
    tags: list = Body(None, description="标签列表"),
    notes: str = Body(None, description="备注"),
):
    """PUT /api/v1/crm/customers/{id} - 更新客户"""
    return {
        "code": 200,
        "data": {"id": customer_id, "updated": True},
        "message": "客户信息更新成功"
    }


@router.delete("/{customer_id}")
async def delete_customer(customer_id: int):
    """DELETE /api/v1/crm/customers/{id} - 删除客户"""
    return {
        "code": 200,
        "data": {"id": customer_id, "deleted": True},
        "message": "客户删除成功"
    }
