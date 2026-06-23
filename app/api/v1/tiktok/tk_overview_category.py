"""
TikTok 品类大盘模块
从 Shopify 品类大盘复制并适配
"""
import random
from fastapi import APIRouter, Query
from typing import Optional

router = APIRouter()


def _generate_mock_data():
    random.seed(42)
    categories = [
        {
            "name": "美妆个护",
            "children": [
                {"name": "美妆"}, {"name": "美容护肤"}, {"name": "头部护理与造型"},
                {"name": "手足及指甲护理"}, {"name": "洗浴与身体护理"}, {"name": "男士护理"},
                {"name": "美容个护电器"}, {"name": "眼镜耳朵护理"}, {"name": "鼻子口腔护理"},
                {"name": "女性私密处护理"}, {"name": "特殊个护"}, {"name": "香水"},
            ]
        },
        {
            "name": "女装与女士内衣",
            "children": [
                {"name": "女士上装"}, {"name": "女士下装"}, {"name": "女士连衣裙"},
                {"name": "女士特殊服饰"}, {"name": "女士套装与连体衣"}, {"name": "女士内衣"},
                {"name": "女士睡衣和家居服"},
            ]
        },
        {
            "name": "保健",
            "children": [
                {"name": "保健食品"}, {"name": "医疗保健"}, {"name": "非处方药物与疗法"},
                {"name": "健康监测设备"}, {"name": "性保健用品"},
            ]
        },
        {
            "name": "电子产品",
            "children": [
                {"name": "手机配件"}, {"name": "摄影摄像"}, {"name": "影音设备"},
                {"name": "游戏设备"}, {"name": "智能及穿戴设备"}, {"name": "电子教育设备"},
                {"name": "通用配件"}, {"name": "平板电脑配件"}, {"name": "手机与平板"},
            ]
        },
        {
            "name": "居家日用",
            "children": [
                {"name": "家居收纳"}, {"name": "浴室用品"}, {"name": "装饰"},
                {"name": "家庭护理用品"}, {"name": "洗衣工具"}, {"name": "节庆及派对用品"},
                {"name": "家居日用"},
            ]
        },
        {
            "name": "食品饮料",
            "children": [
                {"name": "奶与乳制品"}, {"name": "饮料"}, {"name": "即食食品"},
                {"name": "主食与烹饪调味"}, {"name": "烘焙用品"}, {"name": "零食"},
                {"name": "生鲜冷冻食品"}, {"name": "酒"},
            ]
        },
        {
            "name": "汽车与摩托车",
            "children": [
                {"name": "摩托车零部件"}, {"name": "汽车电子产品"}, {"name": "外部配件"},
                {"name": "内部配件"}, {"name": "汽车修理工具"}, {"name": "汽车灯"},
                {"name": "沙滩车房车游艇设备"}, {"name": "洗车及保养"},
            ]
        },
        {
            "name": "家装建材",
            "children": [
                {"name": "太阳能与风能设备"}, {"name": "灯具和照明设备"}, {"name": "电气设备及用品"},
                {"name": "厨房设备"}, {"name": "家庭智能系统"}, {"name": "建筑用品"},
                {"name": "浴室设备"}, {"name": "安防劳保用品"}, {"name": "花园用品"},
            ]
        },
        {
            "name": "电脑办公",
            "children": [
                {"name": "电脑整机"}, {"name": "电脑笔记本电脑组件"}, {"name": "外设产品与配件"},
                {"name": "数据储存与软件"}, {"name": "网络组件"}, {"name": "办公设备"},
                {"name": "办公文具用品"},
            ]
        },
        {
            "name": "箱包",
            "children": [
                {"name": "女包"}, {"name": "男包"}, {"name": "旅行箱包"},
                {"name": "功能箱包"}, {"name": "箱包配件"},
            ]
        },
        {
            "name": "鞋靴",
            "children": [
                {"name": "女鞋"}, {"name": "男鞋"}, {"name": "鞋靴配件"},
            ]
        },
        {
            "name": "五金工具",
            "children": [
                {"name": "电动工具"}, {"name": "手动工具"}, {"name": "测量工具"},
                {"name": "园林工具"},
            ]
        },
        {
            "name": "收藏品",
            "children": [
                {"name": "当代文化收藏"}, {"name": "收藏卡片及配件"}, {"name": "运动收藏品"},
                {"name": "收藏钱币"}, {"name": "娱乐收藏"},
            ]
        },
        {
            "name": "玩具和爱好",
            "children": [
                {"name": "娃娃与毛绒玩具"}, {"name": "益智玩具"}, {"name": "运动与户外玩具"},
                {"name": "电动与遥控玩具"}, {"name": "棋盘娱乐"}, {"name": "传统与创新玩具"},
                {"name": "乐器与配件"}, {"name": "DIY爱好"},
            ]
        },
        {
            "name": "厨房用品",
            "children": [
                {"name": "咖啡用具与茶用具"}, {"name": "刀具"}, {"name": "烧烤用具"},
                {"name": "酒具"}, {"name": "烘焙用具"}, {"name": "烹饪工具"},
                {"name": "餐具"}, {"name": "饮具"}, {"name": "厨房器具"},
            ]
        },
        {
            "name": "母婴",
            "children": [
                {"name": "婴儿服饰"}, {"name": "婴儿鞋"}, {"name": "婴幼配件"},
                {"name": "婴儿洗护"}, {"name": "婴儿用品"}, {"name": "孕产用品"},
                {"name": "婴儿时尚配件"},
            ]
        },
        {
            "name": "家具",
            "children": [
                {"name": "家具辅料"}, {"name": "室内家具"}, {"name": "室外家具"},
                {"name": "儿童家具"}, {"name": "商用家具"},
            ]
        },
        {
            "name": "儿童时尚",
            "children": [
                {"name": "男童服饰"}, {"name": "女童服饰"}, {"name": "男童鞋"},
                {"name": "女童鞋"}, {"name": "儿童时尚配件"},
            ]
        },
        {
            "name": "穆斯林时尚",
            "children": [
                {"name": "面纱"}, {"name": "女士穆斯林服饰"}, {"name": "男士穆斯林服装"},
                {"name": "外套"}, {"name": "儿童穆斯林服装"}, {"name": "穆斯林配饰"},
                {"name": "祈祷用品"},
            ]
        },
        {
            "name": "运动户外",
            "children": [
                {"name": "运动服装"}, {"name": "运动鞋"}, {"name": "健身器材"},
                {"name": "户外装备"}, {"name": "骑行运动"}, {"name": "水上运动"},
                {"name": "冬季运动"}, {"name": "运动配件"},
            ]
        },
        {
            "name": "宠物用品",
            "children": [
                {"name": "宠物食品"}, {"name": "宠物服饰"}, {"name": "宠物玩具"},
                {"name": "宠物美容"}, {"name": "宠物健康"}, {"name": "宠物出行"},
            ]
        },
        {
            "name": "珠宝与手表",
            "children": [
                {"name": "戒指"}, {"name": "项链与吊坠"}, {"name": "耳饰"},
                {"name": "手镯与手链"}, {"name": "手表"}, {"name": "珠宝套装"},
                {"name": "男士珠宝"},
            ]
        },
        {
            "name": "纺织品",
            "children": [
                {"name": "床上用品"}, {"name": "毛巾浴巾"}, {"name": "窗帘"},
                {"name": "地毯"}, {"name": "靠垫抱枕"}, {"name": "桌布餐巾"},
            ]
        },
        {
            "name": "时尚配件",
            "children": [
                {"name": "假发"}, {"name": "平价饰品"}, {"name": "发饰"},
                {"name": "服饰配件"}, {"name": "眼镜"}, {"name": "手表与配件"},
                {"name": "服装布料"}, {"name": "婚礼配件"},
            ]
        },
        {
            "name": "男装与男士内衣",
            "children": [
                {"name": "男士上装"}, {"name": "男士下装"}, {"name": "男士套装与连体衣"},
                {"name": "男士内衣"}, {"name": "男士特殊服饰"}, {"name": "男士睡衣和家居服"},
            ]
        },
        {
            "name": "家电",
            "children": [
                {"name": "生活家电"}, {"name": "厨房家电"}, {"name": "大家电"},
                {"name": "商用电器"},
            ]
        },
        {
            "name": "图书杂志音像",
            "children": [
                {"name": "图书"}, {"name": "杂志"}, {"name": "音像制品"},
            ]
        },
        {
            "name": "二手",
            "children": [
                {"name": "二手服饰"}, {"name": "二手电子产品"}, {"name": "二手家居"},
                {"name": "二手收藏品"},
            ]
        },
    ]

    result = []
    for cat in categories:
        children = []
        for child in cat["children"]:
            value = random.randint(8000, 500000)
            change_rate = round(random.uniform(-45, 55), 2)
            sales = value
            volume = random.randint(100, 50000)
            children.append({
                "name": child["name"],
                "value": value,
                "changeRate": change_rate,
                "sales": sales,
                "volume": volume,
                "salesChange": round(random.uniform(-35, 45), 2),
                "volumeChange": round(random.uniform(-40, 50), 2),
                "blueOceanIndex": round(random.uniform(10, 98), 1),
            })
        total_value = sum(c["value"] for c in children)
        total_change_rate = round(
            sum(c["changeRate"] * c["value"] for c in children) / total_value, 2
        )
        result.append({
            "name": cat["name"],
            "value": total_value,
            "changeRate": total_change_rate,
            "children": children,
        })

    return result


@router.get("/")
async def tk_category_overview(
    country: Optional[str] = Query(None, description="国家代码"),
    date_from: Optional[str] = Query(None, description="开始日期"),
    date_to: Optional[str] = Query(None, description="结束日期"),
    sort_by: Optional[str] = Query("sales", description="排序方式"),
    color_mode: Optional[str] = Query("red-up", description="颜色模式"),
):
    categories = _generate_mock_data()

    sort_key_map = {
        "sales": "value",
        "volume": "volume",
        "salesChange": "salesChange",
        "volumeChange": "volumeChange",
        "blueOceanIndex": "blueOceanIndex",
    }
    sort_key = sort_key_map.get(sort_by, "value")

    for cat in categories:
        cat["children"].sort(key=lambda x: x.get(sort_key, 0), reverse=True)

    categories.sort(
        key=lambda c: sum(ch.get(sort_key, 0) for ch in c["children"]),
        reverse=True,
    )

    return {
        "code": 200,
        "data": {
            "categories": categories,
            "meta": {
                "sortBy": sort_by,
                "colorMode": color_mode,
                "country": country or "US",
                "dateFrom": date_from,
                "dateTo": date_to,
                "totalCategories": len(categories),
                "totalSubCategories": sum(len(c["children"]) for c in categories),
            },
        },
        "message": "success",
    }
