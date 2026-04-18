"""
TikTok 数据模块 - 统一导出
"""

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

# 我的组
from .my_favorites import router as my_favorites_router
from .my_creations import router as my_creations_router

# 其他功能
from .purchase_renewal import router as purchase_renewal_router
from .knowledge_payment import router as knowledge_payment_router
from .overseas_explore import router as overseas_explore_router

__all__ = [
    # TikTok 大盘
    'tk_overview_category_router',
    'tk_overview_product_router',
    'tk_overview_store_router',
    'tk_overview_ai_router',
    # 选爆品
    'tk_prod_search_router',
    'tk_prod_sales_rank_router',
    'tk_prod_surge_rank_router',
    'tk_prod_potential_new_router',
    'tk_prod_history_rank_router',
    'tk_prod_amazon_search_router',
    'tk_prod_tiktok_search_router',
    # 盯爆店
    'tk_store_search_router',
    'tk_store_best_sellers_router',
    'tk_store_surge_rank_router',
    # 找视频
    'tk_video_search_router',
    'tk_video_ai_router',
    'tk_video_ads_router',
    # 选达人
    'tk_inf_search_router',
    'tk_inf_sales_rank_router',
    'tk_inf_follower_rank_router',
    'tk_inf_agency_rank_router',
    # 直播
    'tk_live_search_router',
    # 外贸
    'trade_region_router',
    'trade_product_router',
    # 服务商
    'service_logistics_router',
    'service_warehouse_router',
    'service_qualification_router',
    'service_factory_router',
    'service_influencer_router',
    # 我的
    'my_favorites_router',
    'my_creations_router',
    # 其他
    'purchase_renewal_router',
    'knowledge_payment_router',
    'overseas_explore_router',
]
