"""
客资分析 API
"""
from fastapi import APIRouter, Query

router = APIRouter()


@router.get("")
async def get_crm_analytics(
    period: str = Query("month", description="周期: week/month/quarter/year")
):
    """GET /api/v1/crm/analytics - 客资分析数据"""
    data = {
        "stats": {
            "total_leads": 3847,
            "conversion_rate": 24.8,
            "avg_deal_size": 12500,
            "avg_sales_cycle": "18天",
            "total_revenue": 482500,
            "repeat_rate": 35.2,
        },
        "monthly_trend": [
            {"month": "1月", "new_customers": 320, "converted": 78},
            {"month": "2月", "new_customers": 285, "converted": 65},
            {"month": "3月", "new_customers": 410, "converted": 102},
            {"month": "4月", "new_customers": 456, "converted": 115},
            {"month": "5月", "new_customers": 520, "converted": 138},
            {"month": "6月", "new_customers": 586, "converted": 148},
        ],
        "source_analysis": [
            {"source": "独立站", "leads": 1205, "converted": 328, "conversion_rate": 27.2, "revenue": 215000},
            {"source": "TikTok", "leads": 892, "converted": 215, "conversion_rate": 24.1, "revenue": 128000},
            {"source": "Instagram", "leads": 634, "converted": 148, "conversion_rate": 23.3, "revenue": 82000},
            {"source": "Facebook", "leads": 487, "converted": 112, "conversion_rate": 23.0, "revenue": 45000},
            {"source": "WhatsApp", "leads": 329, "converted": 85, "conversion_rate": 25.8, "revenue": 42000},
            {"source": "其它", "leads": 300, "converted": 68, "conversion_rate": 22.7, "revenue": 30500},
        ],
        "status_distribution": [
            {"status": "潜在客户", "count": 1845, "percentage": 48.0, "color": "#409EFF"},
            {"status": "已联系", "count": 892, "percentage": 23.2, "color": "#E6A23C"},
            {"status": "洽谈中", "count": 634, "percentage": 16.5, "color": "#67C23A"},
            {"status": "已成交", "count": 376, "percentage": 9.8, "color": "#F56C6C"},
            {"status": "已流失", "count": 100, "percentage": 2.6, "color": "#909399"},
        ],
        "country_distribution": [
            {"country": "美国", "count": 856, "percentage": 22.3},
            {"country": "巴西", "count": 523, "percentage": 13.6},
            {"country": "日本", "count": 412, "percentage": 10.7},
            {"country": "印度", "count": 356, "percentage": 9.3},
            {"country": "英国", "count": 298, "percentage": 7.7},
            {"country": "德国", "count": 245, "percentage": 6.4},
            {"country": "法国", "count": 198, "percentage": 5.1},
            {"country": "阿联酋", "count": 186, "percentage": 4.8},
            {"country": "韩国", "count": 165, "percentage": 4.3},
            {"country": "其它", "count": 608, "percentage": 15.8},
        ],
        "tag_analysis": [
            {"tag": "高意向", "count": 423, "percentage": 11.0},
            {"tag": "VIP客户", "count": 156, "percentage": 4.1},
            {"tag": "批发", "count": 345, "percentage": 9.0},
            {"tag": "样品申请", "count": 278, "percentage": 7.2},
            {"tag": "询价", "count": 412, "percentage": 10.7},
            {"tag": "OEM", "count": 189, "percentage": 4.9},
            {"tag": "代理", "count": 234, "percentage": 6.1},
            {"tag": "比价", "count": 298, "percentage": 7.7},
            {"tag": "零售", "count": 567, "percentage": 14.7},
            {"tag": "长期合作", "count": 189, "percentage": 4.9},
        ],
        "staff_performance": [
            {"staff": "张三", "customers": 1280, "converted": 156, "revenue": 195000, "avg_response": "3.2min"},
            {"staff": "李四", "customers": 1050, "converted": 128, "revenue": 162000, "avg_response": "4.5min"},
            {"staff": "王五", "customers": 960, "converted": 92, "revenue": 125500, "avg_response": "5.8min"},
        ]
    }

    return {
        "code": 200,
        "data": data,
        "message": "获取客资分析成功"
    }
