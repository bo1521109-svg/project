"""
客资概览 API
"""
from fastapi import APIRouter, Query

router = APIRouter()


@router.get("")
async def get_crm_overview(
    period: str = Query("month", description="统计周期: today/week/month")
):
    """GET /api/v1/crm/overview - 客资概览数据"""
    # 根据周期返回不同数据
    data_map = {
        "today": {
            "total_customers": 3847,
            "new_today": 23,
            "active_customers": 156,
            "pending_follow_ups": 42,
            "conversion_rate": 18.5,
            "avg_response_time": "3.2min",
            "source_distribution": [
                {"name": "独立站", "count": 1205, "percentage": 31.3},
                {"name": "TikTok", "count": 892, "percentage": 23.2},
                {"name": "Instagram", "count": 634, "percentage": 16.5},
                {"name": "Facebook", "count": 487, "percentage": 12.7},
                {"name": "WhatsApp", "count": 329, "percentage": 8.6},
                {"name": "其它", "count": 300, "percentage": 7.8},
            ],
            "recent_customers": [
                {"id": 3847, "name": "Carlos M.", "source": "TikTok", "country": "巴西", "created": "2026-06-03 14:22", "status": "new"},
                {"id": 3846, "name": "Emma W.", "source": "独立站", "country": "美国", "created": "2026-06-03 13:15", "status": "new"},
                {"id": 3845, "name": "田中健一", "source": "Instagram", "country": "日本", "created": "2026-06-03 11:08", "status": "new"},
            ],
            "upcoming_follow_ups": [
                {"id": 1, "customer": "Lucas S.", "type": "电话回访", "scheduled": "2026-06-03 16:00", "priority": "high"},
                {"id": 2, "customer": "Sophie L.", "type": "邮件跟进", "scheduled": "2026-06-03 17:30", "priority": "medium"},
            ]
        },
        "week": {
            "total_customers": 3847,
            "new_this_week": 186,
            "active_customers": 523,
            "pending_follow_ups": 42,
            "conversion_rate": 22.1,
            "avg_response_time": "4.5min",
            "source_distribution": [
                {"name": "独立站", "count": 1205, "percentage": 31.3},
                {"name": "TikTok", "count": 892, "percentage": 23.2},
                {"name": "Instagram", "count": 634, "percentage": 16.5},
                {"name": "Facebook", "count": 487, "percentage": 12.7},
                {"name": "WhatsApp", "count": 329, "percentage": 8.6},
                {"name": "其它", "count": 300, "percentage": 7.8},
            ],
            "recent_customers": [
                {"id": 3847, "name": "Carlos M.", "source": "TikTok", "country": "巴西", "created": "2026-06-03 14:22", "status": "new"},
                {"id": 3846, "name": "Emma W.", "source": "独立站", "country": "美国", "created": "2026-06-03 13:15", "status": "new"},
                {"id": 3845, "name": "田中健一", "source": "Instagram", "country": "日本", "created": "2026-06-03 11:08", "status": "new"},
                {"id": 3844, "name": "Priya K.", "source": "Facebook", "country": "印度", "created": "2026-06-03 09:45", "status": "new"},
                {"id": 3843, "name": "Michael B.", "source": "独立站", "country": "英国", "created": "2026-06-03 08:30", "status": "new"},
            ],
            "upcoming_follow_ups": [
                {"id": 1, "customer": "Lucas S.", "type": "电话回访", "scheduled": "2026-06-03 16:00", "priority": "high"},
                {"id": 2, "customer": "Sophie L.", "type": "邮件跟进", "scheduled": "2026-06-03 17:30", "priority": "medium"},
                {"id": 3, "customer": "Ahmed R.", "type": "WhatsApp", "scheduled": "2026-06-04 10:00", "priority": "high"},
                {"id": 4, "customer": "Maria G.", "type": "样品寄送跟进", "scheduled": "2026-06-04 14:00", "priority": "medium"},
                {"id": 5, "customer": "David C.", "type": "合同签署", "scheduled": "2026-06-05 09:00", "priority": "high"},
            ]
        },
        "month": {
            "total_customers": 3847,
            "new_this_month": 586,
            "active_customers": 1203,
            "pending_follow_ups": 42,
            "conversion_rate": 24.8,
            "avg_response_time": "5.1min",
            "source_distribution": [
                {"name": "独立站", "count": 1205, "percentage": 31.3},
                {"name": "TikTok", "count": 892, "percentage": 23.2},
                {"name": "Instagram", "count": 634, "percentage": 16.5},
                {"name": "Facebook", "count": 487, "percentage": 12.7},
                {"name": "WhatsApp", "count": 329, "percentage": 8.6},
                {"name": "其它", "count": 300, "percentage": 7.8},
            ],
            "recent_customers": [
                {"id": 3847, "name": "Carlos M.", "source": "TikTok", "country": "巴西", "created": "2026-06-03 14:22", "status": "new"},
                {"id": 3846, "name": "Emma W.", "source": "独立站", "country": "美国", "created": "2026-06-03 13:15", "status": "new"},
                {"id": 3845, "name": "田中健一", "source": "Instagram", "country": "日本", "created": "2026-06-03 11:08", "status": "new"},
                {"id": 3844, "name": "Priya K.", "source": "Facebook", "country": "印度", "created": "2026-06-03 09:45", "status": "new"},
                {"id": 3843, "name": "Michael B.", "source": "独立站", "country": "英国", "created": "2026-06-03 08:30", "status": "new"},
                {"id": 3842, "name": "Anna F.", "source": "Instagram", "country": "德国", "created": "2026-06-02 16:20", "status": "contacted"},
                {"id": 3841, "name": "Omar H.", "source": "WhatsApp", "country": "阿联酋", "created": "2026-06-02 15:10", "status": "new"},
            ],
            "upcoming_follow_ups": [
                {"id": 1, "customer": "Lucas S.", "type": "电话回访", "scheduled": "2026-06-03 16:00", "priority": "high"},
                {"id": 2, "customer": "Sophie L.", "type": "邮件跟进", "scheduled": "2026-06-03 17:30", "priority": "medium"},
                {"id": 3, "customer": "Ahmed R.", "type": "WhatsApp", "scheduled": "2026-06-04 10:00", "priority": "high"},
                {"id": 4, "customer": "Maria G.", "type": "样品寄送跟进", "scheduled": "2026-06-04 14:00", "priority": "medium"},
                {"id": 5, "customer": "David C.", "type": "合同签署", "scheduled": "2026-06-05 09:00", "priority": "high"},
                {"id": 6, "customer": "Yuki T.", "type": "报价确认", "scheduled": "2026-06-05 11:00", "priority": "medium"},
                {"id": 7, "customer": "Robert K.", "type": "产品演示", "scheduled": "2026-06-06 14:00", "priority": "low"},
            ]
        }
    }
    return {
        "code": 200,
        "data": data_map.get(period, data_map["month"]),
        "message": "获取客资概览成功"
    }
