"""
TikTok 商品 - 亚马逊搜索
"""
from fastapi import APIRouter, Query
from typing import Optional

router = APIRouter()


@router.get("")
async def search_amazon_products(
    keyword: Optional[str] = Query(None, description="搜索关键词"),
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    country: Optional[str] = Query("US", description="国家代码"),
    category: Optional[str] = Query(None, description="品类筛选"),
    min_price: Optional[float] = Query(None, description="最低价格"),
    max_price: Optional[float] = Query(None, description="最高价格"),
    min_rating: Optional[float] = Query(None, ge=0, le=5, description="最低评分"),
    sort_by: Optional[str] = Query("relevance", description="排序方式：relevance(相关性), price_asc(价格升序), price_desc(价格降序), rating(评分)")
):
    """
    搜索亚马逊商品
    
    支持关键词搜索、价格筛选、评分筛选等
    """
    # 模拟数据
    products = [
        {
            "id": 1,
            "asin": "B08N5WRWNW",
            "product_name": "Apple AirPods Pro (2nd Generation)",
            "product_image": "https://via.placeholder.com/150",
            "price": 249.00,
            "rating": 4.7,
            "review_count": 45680,
            "sales_rank": 1,
            "category": "Electronics",
            "brand": "Apple",
            "is_prime": True,
            "in_stock": True,
            "seller": "Amazon.com",
            "country": country,
            "amazon_url": f"https://www.amazon.com/dp/B08N5WRWNW"
        },
        {
            "id": 2,
            "asin": "B0BSHF7WHW",
            "product_name": "Samsung Galaxy Buds2 Pro",
            "product_image": "https://via.placeholder.com/150",
            "price": 179.99,
            "rating": 4.5,
            "review_count": 12340,
            "sales_rank": 5,
            "category": "Electronics",
            "brand": "Samsung",
            "is_prime": True,
            "in_stock": True,
            "seller": "Amazon.com",
            "country": country,
            "amazon_url": f"https://www.amazon.com/dp/B0BSHF7WHW"
        },
        {
            "id": 3,
            "asin": "B09JQL3NWT",
            "product_name": "Sony WF-1000XM4 Wireless Earbuds",
            "product_image": "https://via.placeholder.com/150",
            "price": 278.00,
            "rating": 4.6,
            "review_count": 8920,
            "sales_rank": 3,
            "category": "Electronics",
            "brand": "Sony",
            "is_prime": True,
            "in_stock": True,
            "seller": "Amazon.com",
            "country": country,
            "amazon_url": f"https://www.amazon.com/dp/B09JQL3NWT"
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
    
    if min_rating:
        products = [p for p in products if p["rating"] >= min_rating]
    
    # 应用排序
    if sort_by == "price_asc":
        products.sort(key=lambda x: x["price"])
    elif sort_by == "price_desc":
        products.sort(key=lambda x: x["price"], reverse=True)
    elif sort_by == "rating":
        products.sort(key=lambda x: x["rating"], reverse=True)
    
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


@router.get("/categories")
async def get_amazon_categories(
    country: Optional[str] = Query("US", description="国家代码")
):
    """
    获取亚马逊品类列表
    """
    categories = [
        {"id": 1, "name": "Electronics", "product_count": 15680},
        {"id": 2, "name": "Home & Kitchen", "product_count": 12340},
        {"id": 3, "name": "Clothing, Shoes & Jewelry", "product_count": 9870},
        {"id": 4, "name": "Sports & Outdoors", "product_count": 8920},
        {"id": 5, "name": "Beauty & Personal Care", "product_count": 7650}
    ]
    
    return {
        "code": 200,
        "data": {
            "categories": categories,
            "country": country
        },
        "message": "获取成功"
    }


@router.get("/product/{asin}")
async def get_amazon_product_detail(
    asin: str,
    country: Optional[str] = Query("US", description="国家代码")
):
    """
    获取亚马逊商品详情
    """
    product = {
        "asin": asin,
        "product_name": "Apple AirPods Pro (2nd Generation)",
        "product_images": [
            "https://via.placeholder.com/500",
            "https://via.placeholder.com/500",
            "https://via.placeholder.com/500"
        ],
        "price": 249.00,
        "rating": 4.7,
        "review_count": 45680,
        "sales_rank": 1,
        "category": "Electronics",
        "brand": "Apple",
        "is_prime": True,
        "in_stock": True,
        "seller": "Amazon.com",
        "description": "Active Noise Cancellation, Transparency mode, Personalized Spatial Audio with dynamic head tracking",
        "features": [
            "Active Noise Cancellation",
            "Transparency mode",
            "Personalized Spatial Audio",
            "Up to 6 hours of listening time",
            "MagSafe Charging Case"
        ],
        "specifications": {
            "Brand": "Apple",
            "Model": "AirPods Pro (2nd Gen)",
            "Color": "White",
            "Connectivity": "Bluetooth",
            "Battery Life": "6 hours"
        },
        "country": country,
        "amazon_url": f"https://www.amazon.com/dp/{asin}"
    }
    
    return {
        "code": 200,
        "data": product,
        "message": "获取成功"
    }
