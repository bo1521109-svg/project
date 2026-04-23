"""
独立站数据 API 路由
"""
from fastapi import APIRouter

router = APIRouter()

# 导入所有独立站相关的路由
from . import (
    ad_search,
    category_overview,
    product_overview,
    product_potential_new,
    product_sales_rank,
    product_surge_rank,
    products,
    shopify_video_ai,
    shopify_video_hot,
    shopify_workbench,
    store_best_sellers,
    store_overview,
    store_surge_rank,
    stores
)

# 注册所有路由
router.include_router(ad_search.router, prefix="/ads/library", tags=["Shopify 广告搜索"])
router.include_router(category_overview.router, prefix="/category/overview", tags=["Shopify 品类大盘"])
router.include_router(product_overview.router, prefix="/product/overview", tags=["Shopify 商品大盘"])
router.include_router(product_potential_new.router, prefix="/products/potential-new", tags=["Shopify 潜力新品"])
router.include_router(product_sales_rank.router, prefix="/products/sales-rank", tags=["Shopify 商品销量榜"])
router.include_router(product_surge_rank.router, prefix="/products/surge-rank", tags=["Shopify 商品飙升榜"])
router.include_router(products.router, prefix="/products", tags=["Shopify 商品"])
router.include_router(shopify_video_ai.router, prefix="/videos/ai", tags=["Shopify AI话题"])
router.include_router(shopify_video_hot.router, prefix="/videos/hot", tags=["Shopify 热门视频"])
router.include_router(shopify_workbench.router, prefix="/workbench", tags=["Shopify 工作台"])
router.include_router(store_best_sellers.router, prefix="/stores/best-sellers", tags=["Shopify 店铺爆卖榜"])
router.include_router(store_overview.router, prefix="/store/overview", tags=["Shopify 店铺大盘"])
router.include_router(store_surge_rank.router, prefix="/stores/surge-rank", tags=["Shopify 店铺飙升榜"])
router.include_router(stores.router, prefix="/stores", tags=["Shopify 店铺"])
