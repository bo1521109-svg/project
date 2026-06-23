"""
TikTok 商品 - TikTok搜索
"""
from fastapi import APIRouter, Query
from typing import Optional

router = APIRouter()


@router.get("/")
async def search_tiktok_products(
    keyword: Optional[str] = Query(None, description="搜索关键词"),
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    country: Optional[str] = Query("US", description="国家代码"),
    category: Optional[str] = Query(None, description="品类筛选"),
    min_price: Optional[float] = Query(None, description="最低价格"),
    max_price: Optional[float] = Query(None, description="最高价格"),
    min_sales: Optional[int] = Query(None, description="最低销量"),
    sort_by: Optional[str] = Query("relevance", description="排序方式：relevance(相关性), sales(销量), price_asc(价格升序), price_desc(价格降序)")
):
    """
    搜索TikTok商品
    
    支持关键词搜索、价格筛选、销量筛选等
    """
    # 模拟数据
    products = [
        {
            "id": 1,
            "product_id": "TK1234567890",
            "product_name": "Wireless Bluetooth Earbuds Pro",
            "product_image": "https://via.placeholder.com/150",
            "price": 29.99,
            "original_price": 59.99,
            "discount": 50,
            "sales": 15680,
            "sales_7d": 3420,
            "sales_30d": 12560,
            "rating": 4.8,
            "review_count": 2340,
            "store_name": "TechGear Official",
            "store_id": "store_001",
            "category": "Electronics",
            "country": country,
            "video_count": 156,
            "is_hot": True,
            "tags": ["Best Seller", "Fast Shipping"],
            "tiktok_url": "https://www.tiktok.com/@shop/product/TK1234567890"
        },
        {
            "id": 2,
            "product_id": "TK2345678901",
            "product_name": "Smart Watch Fitness Tracker 2024",
            "product_image": "https://via.placeholder.com/150",
            "price": 49.99,
            "original_price": 99.99,
            "discount": 50,
            "sales": 12450,
            "sales_7d": 2890,
            "sales_30d": 9870,
            "rating": 4.7,
            "review_count": 1890,
            "store_name": "FitLife Store",
            "store_id": "store_002",
            "category": "Electronics",
            "country": country,
            "video_count": 234,
            "is_hot": True,
            "tags": ["Trending", "New Arrival"],
            "tiktok_url": "https://www.tiktok.com/@shop/product/TK2345678901"
        },
        {
            "id": 3,
            "product_id": "TK3456789012",
            "product_name": "LED Strip Lights RGB 50ft",
            "product_image": "https://via.placeholder.com/150",
            "price": 19.99,
            "original_price": 39.99,
            "discount": 50,
            "sales": 9870,
            "sales_7d": 2100,
            "sales_30d": 7650,
            "rating": 4.6,
            "review_count": 1560,
            "store_name": "HomeDecor Plus",
            "store_id": "store_003",
            "category": "Home & Garden",
            "country": country,
            "video_count": 189,
            "is_hot": False,
            "tags": ["Popular"],
            "tiktok_url": "https://www.tiktok.com/@shop/product/TK3456789012"
        }
    ]
    
    # 应用筛选条件
    if keyword:
        products = [p for p in products if keyword.lower() in p["product_name"].lower()]
    
    if category:
        products = [p for p in products if p["category"] == category]
    
    if min_price:
        products = [p for p in products if p["price"] >= min_price]
    
    if max_price:
        products = [p for p in products if p["price"] <= max_price]
    
    if min_sales:
        products = [p for p in products if p["sales"] >= min_sales]
    
    # 应用排序
    if sort_by == "sales":
        products.sort(key=lambda x: x["sales"], reverse=True)
    elif sort_by == "price_asc":
        products.sort(key=lambda x: x["price"])
    elif sort_by == "price_desc":
        products.sort(key=lambda x: x["price"], reverse=True)
    
    total = len(products) * 10  # 模拟总数
    
    return {
        "code": 200,
        "data": {
            "products": products,
            "search_info": {
                "keyword": keyword,
                "country": country,
                "total_results": total
            },
            "pagination": {
                "page": page,
                "page_size": page_size,
                "total": total,
                "total_pages": (total + page_size - 1) // page_size
            }
        },
        "message": "搜索成功"
    }


@router.get("/trending")
async def get_trending_products(
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    country: Optional[str] = Query("US", description="国家代码"),
    time_range: Optional[str] = Query("7d", description="时间范围：24h, 7d, 30d")
):
    """
    获取TikTok热门商品
    """
    products = [
        {
            "id": 1,
            "product_id": "TK1234567890",
            "product_name": "Viral Makeup Brush Set",
            "product_image": "https://via.placeholder.com/150",
            "price": 24.99,
            "sales": 25680,
            "growth_rate": 156.8,
            "video_count": 456,
            "trending_score": 98.5,
            "category": "Beauty",
            "country": country
        },
        {
            "id": 2,
            "product_id": "TK2345678901",
            "product_name": "Portable Blender Mini",
            "product_image": "https://via.placeholder.com/150",
            "price": 34.99,
            "sales": 18920,
            "growth_rate": 142.3,
            "video_count": 389,
            "trending_score": 95.2,
            "category": "Home & Kitchen",
            "country": country
        }
    ]
    
    total = len(products) * 5
    
    return {
        "code": 200,
        "data": {
            "products": products,
            "time_range": time_range,
            "pagination": {
                "page": page,
                "page_size": page_size,
                "total": total,
                "total_pages": (total + page_size - 1) // page_size
            }
        },
        "message": "获取成功"
    }


@router.get("/product/{product_id}")
async def get_tiktok_product_detail(
    product_id: str,
    country: Optional[str] = Query("US", description="国家代码")
):
    """
    获取TikTok商品详情
    """
    product = {
        "product_id": product_id,
        "product_name": "Wireless Bluetooth Earbuds Pro",
        "product_images": [
            "https://via.placeholder.com/500",
            "https://via.placeholder.com/500",
            "https://via.placeholder.com/500"
        ],
        "price": 29.99,
        "original_price": 59.99,
        "discount": 50,
        "sales": 15680,
        "sales_trend": {
            "7d": 3420,
            "30d": 12560,
            "90d": 15680
        },
        "rating": 4.8,
        "review_count": 2340,
        "store_name": "TechGear Official",
        "store_id": "store_001",
        "category": "Electronics",
        "description": "High-quality wireless earbuds with active noise cancellation",
        "features": [
            "Active Noise Cancellation",
            "30-hour battery life",
            "IPX7 Waterproof",
            "Touch Control",
            "Fast Charging"
        ],
        "specifications": {
            "Brand": "TechGear",
            "Model": "TG-BT500",
            "Color": "Black",
            "Connectivity": "Bluetooth 5.3",
            "Battery Life": "30 hours"
        },
        "video_count": 156,
        "top_videos": [
            {
                "video_id": "v123456",
                "video_url": "https://www.tiktok.com/@user/video/123456",
                "thumbnail": "https://via.placeholder.com/200",
                "views": 1250000,
                "likes": 85600,
                "comments": 3420
            }
        ],
        "country": country,
        "tiktok_url": f"https://www.tiktok.com/@shop/product/{product_id}"
    }
    
    return {
        "code": 200,
        "data": product,
        "message": "获取成功"
    }
