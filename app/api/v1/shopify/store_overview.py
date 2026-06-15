"""
店铺大盘模块 — 指标卡片 + Top10 店铺集中度
"""
import random
from datetime import date
from fastapi import APIRouter, Query
from typing import Optional

router = APIRouter()

MOCK_STORES = [
    {"id": 1, "name": "CollectibleFish", "avatar": "", "type": "local", "sales": 1285000, "avatar_letter": "C"},
    {"id": 2, "name": "Halara US", "avatar": "", "type": "local", "sales": 987000, "avatar_letter": "H"},
    {"id": 3, "name": "Bloom Nutrition", "avatar": "", "type": "cross_border", "sales": 865000, "avatar_letter": "B"},
    {"id": 4, "name": "Bubble Skincare", "avatar": "", "type": "local", "sales": 743000, "avatar_letter": "B"},
    {"id": 5, "name": "Cupshe", "avatar": "", "type": "cross_border", "sales": 621000, "avatar_letter": "C"},
    {"id": 6, "name": "Vitality", "avatar": "", "type": "managed", "sales": 498000, "avatar_letter": "V"},
    {"id": 7, "name": "Gymshark", "avatar": "", "type": "local", "sales": 385000, "avatar_letter": "G"},
    {"id": 8, "name": "Kylie Cosmetics", "avatar": "", "type": "cross_border", "sales": 312000, "avatar_letter": "K"},
    {"id": 9, "name": "Fashion Nova", "avatar": "", "type": "cross_border", "sales": 267000, "avatar_letter": "F"},
    {"id": 10, "name": "YoungLA", "avatar": "", "type": "managed", "sales": 198000, "avatar_letter": "Y"},
]

MOCK_CATEGORY_STORES = {
    "local": [
        {"id": 1, "name": "CollectibleFish", "avatar": "", "type": "local", "sales": 1285000, "avatar_letter": "C"},
        {"id": 2, "name": "Halara US", "avatar": "", "type": "local", "sales": 987000, "avatar_letter": "H"},
        {"id": 4, "name": "Bubble Skincare", "avatar": "", "type": "local", "sales": 743000, "avatar_letter": "B"},
        {"id": 7, "name": "Gymshark", "avatar": "", "type": "local", "sales": 385000, "avatar_letter": "G"},
        {"id": 11, "name": "SKIMS", "avatar": "", "type": "local", "sales": 342000, "avatar_letter": "S"},
        {"id": 12, "name": "Alo Yoga", "avatar": "", "type": "local", "sales": 298000, "avatar_letter": "A"},
        {"id": 13, "name": "Drunk Elephant", "avatar": "", "type": "local", "sales": 254000, "avatar_letter": "D"},
        {"id": 14, "name": "Rhode Skin", "avatar": "", "type": "local", "sales": 198000, "avatar_letter": "R"},
        {"id": 15, "name": "Glossier", "avatar": "", "type": "local", "sales": 156000, "avatar_letter": "G"},
        {"id": 16, "name": "Everlane", "avatar": "", "type": "local", "sales": 112000, "avatar_letter": "E"},
    ],
    "cross_border": [
        {"id": 3, "name": "Bloom Nutrition", "avatar": "", "type": "cross_border", "sales": 865000, "avatar_letter": "B"},
        {"id": 5, "name": "Cupshe", "avatar": "", "type": "cross_border", "sales": 621000, "avatar_letter": "C"},
        {"id": 8, "name": "Kylie Cosmetics", "avatar": "", "type": "cross_border", "sales": 312000, "avatar_letter": "K"},
        {"id": 9, "name": "Fashion Nova", "avatar": "", "type": "cross_border", "sales": 267000, "avatar_letter": "F"},
        {"id": 17, "name": "ColourPop", "avatar": "", "type": "cross_border", "sales": 234000, "avatar_letter": "C"},
        {"id": 18, "name": "Shein US", "avatar": "", "type": "cross_border", "sales": 198000, "avatar_letter": "S"},
        {"id": 19, "name": "Tarte", "avatar": "", "type": "cross_border", "sales": 165000, "avatar_letter": "T"},
        {"id": 20, "name": "PrettyLittleThing", "avatar": "", "type": "cross_border", "sales": 132000, "avatar_letter": "P"},
        {"id": 21, "name": "Boohoo", "avatar": "", "type": "cross_border", "sales": 98000, "avatar_letter": "B"},
        {"id": 22, "name": "Missguided", "avatar": "", "type": "cross_border", "sales": 72000, "avatar_letter": "M"},
    ],
    "managed": [
        {"id": 6, "name": "Vitality", "avatar": "", "type": "managed", "sales": 498000, "avatar_letter": "V"},
        {"id": 10, "name": "YoungLA", "avatar": "", "type": "managed", "sales": 198000, "avatar_letter": "Y"},
        {"id": 23, "name": "Temu Select", "avatar": "", "type": "managed", "sales": 176000, "avatar_letter": "T"},
        {"id": 24, "name": "AliExpress Plus", "avatar": "", "type": "managed", "sales": 145000, "avatar_letter": "A"},
        {"id": 25, "name": "DHgate Pro", "avatar": "", "type": "managed", "sales": 118000, "avatar_letter": "D"},
        {"id": 26, "name": "Made-in-China", "avatar": "", "type": "managed", "sales": 95000, "avatar_letter": "M"},
        {"id": 27, "name": "Global Sources", "avatar": "", "type": "managed", "sales": 72000, "avatar_letter": "G"},
        {"id": 28, "name": "Chinabrands", "avatar": "", "type": "managed", "sales": 58000, "avatar_letter": "C"},
        {"id": 29, "name": "Banggood Pro", "avatar": "", "type": "managed", "sales": 42000, "avatar_letter": "B"},
        {"id": 30, "name": "Gearbest Select", "avatar": "", "type": "managed", "sales": 28000, "avatar_letter": "G"},
    ],
}


def _vary_sales(stores, seed):
    """根据 seed 微调销售额，模拟不同类目/时间维度的差异"""
    rng = random.Random(seed)
    result = []
    for s in stores:
        new_sales = int(s["sales"] * rng.uniform(0.7, 1.3))
        result.append({**s, "sales": new_sales})
    result.sort(key=lambda x: x["sales"], reverse=True)
    return result


def _calc_cumulative_ratio(stores):
    total = sum(s["sales"] for s in stores)
    cumulative = 0
    for s in stores:
        cumulative += s["sales"]
        s["cumulative_ratio"] = round(cumulative / total * 100, 1) if total > 0 else 0
    return stores


@router.get("/metrics")
async def store_dashboard_metrics(
    category: Optional[str] = Query("all", description="商品分类"),
    period: Optional[str] = Query("daily", description="日/周/月"),
    date: Optional[str] = Query(None, description="日期"),
):
    rng = random.Random(hash(category + period + (date or "")) % 10000)
    return {
        "code": 200,
        "data": {
            "dailyActiveStores": round(rng.uniform(4.8, 6.8), 2),
            "localSalesRatio": round(rng.uniform(48, 60), 2),
            "crossBorderSalesRatio": round(rng.uniform(38, 50), 2),
            "managedSalesRatio": round(rng.uniform(5, 12), 2),
            "avgStoreSales": round(rng.uniform(900, 1500), 0),
        },
        "message": "success",
    }


@router.get("/top10")
async def store_dashboard_top10(
    store_type: Optional[str] = Query("all", description="店铺类型: all/local/cross_border/managed"),
    category: Optional[str] = Query("all", description="商品分类"),
    period: Optional[str] = Query("daily", description="日/周/月"),
    date: Optional[str] = Query(None, description="日期"),
):
    seed = hash(store_type + category + period + (date or "")) % 10000

    if store_type == "all":
        base = MOCK_STORES
    elif store_type in MOCK_CATEGORY_STORES:
        base = MOCK_CATEGORY_STORES[store_type][:10]
    else:
        base = MOCK_STORES

    stores = _vary_sales(base[:10], seed)
    stores = _calc_cumulative_ratio(stores)

    return {
        "code": 200,
        "data": {
            "stores": stores,
            "totalSales": sum(s["sales"] for s in stores),
        },
        "message": "success",
    }
