"""
TikTok 数据模块 - 统一导出
"""
from fastapi import APIRouter

router = APIRouter()

# TikTok 大盘组
from .tk_overview_category import router as tk_overview_category_router
from .tk_overview_product import router as tk_overview_product_router
from .tk_overview_store import router as tk_overview_store_router
from .tk_overview_ai import router as tk_overview_ai_router

# 选爆品组
from .tk_prod_search import router as tk_prod_search_router
from .tk_prod_sales_rank import router as tk_prod_sales_rank_router
from .tk_prod_surge_rank import router as tk_prod_surge_rank_router
from .tk_prod_potential_new import router as tk_prod_potential_new_router
from .tk_prod_history_rank import router as tk_prod_history_rank_router
from .tk_prod_amazon_search import router as tk_prod_amazon_search_router
from .tk_prod_tiktok_search import router as tk_prod_tiktok_search_router

# 盯爆店组
from .tk_store_search import router as tk_store_search_router
from .tk_store_best_sellers import router as tk_store_best_sellers_router
from .tk_store_surge_rank import router as tk_store_surge_rank_router

# 找视频组
from .tk_video_search import router as tk_video_search_router
from .tk_video_ai import router as tk_video_ai_router
from .tk_video_ads import router as tk_video_ads_router

# 选达人组
from .tk_inf_search import router as tk_inf_search_router
from .tk_inf_sales_rank import router as tk_inf_sales_rank_router
from .tk_inf_follower_rank import router as tk_inf_follower_rank_router
from .tk_inf_agency_rank import router as tk_inf_agency_rank_router

# 直播组
from .tk_live_search import router as tk_live_search_router

# 外贸组
from .trade_region import router as trade_region_router
from .trade_product import router as trade_product_router

# 服务商组
from .service_logistics import router as service_logistics_router
from .service_warehouse import router as service_warehouse_router
from .service_qualification import router as service_qualification_router
from .service_factory import router as service_factory_router
from .service_influencer import router as service_influencer_router

# 其他功能
from .purchase_renewal import router as purchase_renewal_router
from .knowledge_payment import router as knowledge_payment_router
from .overseas_explore import router as overseas_explore_router

# 注册所有 TikTok 路由
# TikTok 大盘组
router.include_router(tk_overview_category_router, prefix="/tiktok/category/overview", tags=["TikTok 品类大盘"])
router.include_router(tk_overview_product_router, prefix="/tiktok/product/overview", tags=["TikTok 商品大盘"])
router.include_router(tk_overview_store_router, prefix="/tiktok/store/overview", tags=["TikTok 店铺大盘"])
router.include_router(tk_overview_ai_router, prefix="/tiktok/ai", tags=["TikTok AI"])

# 选爆品组
router.include_router(tk_prod_search_router, prefix="/tiktok/products", tags=["TikTok 商品搜索"])
router.include_router(tk_prod_sales_rank_router, prefix="/tiktok/products/sales-rank", tags=["TikTok 商品销量榜"])
router.include_router(tk_prod_surge_rank_router, prefix="/tiktok/products/surge-rank", tags=["TikTok 商品飙升榜"])
router.include_router(tk_prod_potential_new_router, prefix="/tiktok/products/potential-new", tags=["TikTok 潜力新品"])
router.include_router(tk_prod_history_rank_router, prefix="/tiktok/products/history-rank", tags=["TikTok 历史同期榜"])
router.include_router(tk_prod_amazon_search_router, prefix="/tiktok/products/amazon-search", tags=["TikTok 亚马逊搜索"])
router.include_router(tk_prod_tiktok_search_router, prefix="/tiktok/products/tiktok-search", tags=["TikTok TikTok搜索"])

# 盯爆店组
router.include_router(tk_store_search_router, prefix="/tiktok/stores", tags=["TikTok 店铺搜索"])
router.include_router(tk_store_best_sellers_router, prefix="/tiktok/stores/best-sellers", tags=["TikTok 店铺爆卖榜"])
router.include_router(tk_store_surge_rank_router, prefix="/tiktok/stores/surge-rank", tags=["TikTok 店铺飙升榜"])

# 找视频组
router.include_router(tk_video_search_router, prefix="/tiktok/videos", tags=["TikTok 视频搜索"])
router.include_router(tk_video_ai_router, prefix="/tiktok/videos/ai", tags=["TikTok AI视频"])
router.include_router(tk_video_ads_router, prefix="/tiktok/ads", tags=["TikTok 广告搜索"])

# 选达人组
router.include_router(tk_inf_search_router, prefix="/tiktok/influencers", tags=["TikTok 达人搜索"])
router.include_router(tk_inf_sales_rank_router, prefix="/tiktok/influencers/sales-rank", tags=["TikTok 带货达人榜"])
router.include_router(tk_inf_follower_rank_router, prefix="/tiktok/influencers/follower-rank", tags=["TikTok 涨粉达人榜"])
router.include_router(tk_inf_agency_rank_router, prefix="/tiktok/influencers/agency-rank", tags=["TikTok 达人机构榜"])

# 直播组
router.include_router(tk_live_search_router, prefix="/tiktok/live/search", tags=["TikTok 直播搜索"])

# 外贸组
router.include_router(trade_region_router, prefix="/trade/region", tags=["TikTok 外贸区域"])
router.include_router(trade_product_router, prefix="/trade/product", tags=["TikTok 外贸产品"])

# 服务商组
router.include_router(service_logistics_router, prefix="/service/logistics", tags=["TikTok 国际物流"])
router.include_router(service_warehouse_router, prefix="/service/warehouse", tags=["TikTok 海外仓"])
router.include_router(service_qualification_router, prefix="/service/qualification", tags=["TikTok 资质办理"])
router.include_router(service_factory_router, prefix="/service/factory", tags=["TikTok 海外工厂"])
router.include_router(service_influencer_router, prefix="/service/influencer", tags=["TikTok 达人对接"])

# 其他功能
router.include_router(purchase_renewal_router, prefix="/purchase", tags=["TikTok 购买续费"])
router.include_router(knowledge_payment_router, prefix="/knowledge", tags=["TikTok 知识付费"])
router.include_router(overseas_explore_router, prefix="/overseas/explore", tags=["TikTok 出海探索"])

