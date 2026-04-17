from fastapi import APIRouter
from .stores import router as stores_router
from .products import router as products_router
from .auth import router as auth_router

# 导入新的独立站数据模块
from .product_search import router as product_search_router
from .product_sales_rank import router as product_sales_rank_router
from .product_surge_rank import router as product_surge_rank_router
from .product_potential_new import router as product_potential_new_router
from .store_search import router as store_search_router
from .store_best_sellers import router as store_best_sellers_router
from .store_surge_rank import router as store_surge_rank_router
from .category_overview import router as category_overview_router
from .product_overview import router as product_overview_router
from .store_overview import router as store_overview_router
from .ai_report import router as ai_report_router
from .ad_library import router as ad_library_router

# 导入 TikTok 数据模块（按 5 个模块组分组）
# TikTok 大盘组（/tiktok/overview）
from .tk_overview_category import router as tk_overview_category_router
from .tk_overview_product import router as tk_overview_product_router
from .tk_overview_store import router as tk_overview_store_router
from .tk_overview_ai import router as tk_overview_ai_router

# 选爆品组（/tiktok/products）
from .tk_prod_search import router as tk_prod_search_router
from .tk_prod_sales_rank import router as tk_prod_sales_rank_router
from .tk_prod_surge_rank import router as tk_prod_surge_rank_router
from .tk_prod_potential_new import router as tk_prod_potential_new_router

# 盯爆店组（/tiktok/stores）
from .tk_store_search import router as tk_store_search_router
from .tk_store_best_sellers import router as tk_store_best_sellers_router
from .tk_store_surge_rank import router as tk_store_surge_rank_router

# 找视频组（/tiktok/videos）
from .tk_video_search import router as tk_video_search_router
from .tk_video_ai import router as tk_video_ai_router
from .tk_video_ads import router as tk_video_ads_router

# 选达人组（/tiktok/influencers）
from .tk_inf_search import router as tk_inf_search_router
from .tk_inf_sales_rank import router as tk_inf_sales_rank_router
from .tk_inf_follower_rank import router as tk_inf_follower_rank_router
from .tk_inf_agency_rank import router as tk_inf_agency_rank_router

# 导入内容创作模块（按 4 个模块组分组）
# 找创意组（/content/creative）
from .content_creative_natural_flow import router as content_creative_natural_flow_router
from .content_creative_viral_analysis import router as content_creative_viral_analysis_router
from .content_creative_selling_point import router as content_creative_selling_point_router

# AI 视频组（/content/ai-video）
from .content_ai_video_seedance import router as content_ai_video_seedance_router
from .content_ai_video_auto_clip import router as content_ai_video_auto_clip_router
from .content_ai_video_clone import router as content_ai_video_clone_router

# 去生图组（/content/image-gen）
from .content_image_gen_product_main import router as content_image_gen_product_main_router
from .content_image_gen_model_swap import router as content_image_gen_model_swap_router
from .content_image_gen_model_hold import router as content_image_gen_model_hold_router

# 资料库组（/content/assets）
from .content_assets_my_product import router as content_assets_my_product_router
from .content_assets_my_model import router as content_assets_my_model_router
from .content_assets_my_material import router as content_assets_my_material_router

# 导入社媒管理模块（按 6 个模块组分组）
# 社媒平台组（/social/platforms）
from .social_platform_fb import router as social_platform_fb_router
from .social_platform_ins import router as social_platform_ins_router
from .social_platform_youtube import router as social_platform_youtube_router

# 私域组（/social/private）
from .social_private_line import router as social_private_line_router
from .social_private_whatsapp import router as social_private_whatsapp_router

# 数据看板组（/social/dashboard）
from .social_dashboard_overview import router as social_dashboard_overview_router

# 发布管理组（/social/publish）
from .social_publish_manage import router as social_publish_manage_router

# 互动管理组（/social/interaction）
from .social_interaction_comment import router as social_interaction_comment_router
from .social_interaction_dm import router as social_interaction_dm_router

# 账号管理组（/social/accounts）
from .social_accounts_manage import router as social_accounts_manage_router

# 导入出海生态模块
from .ecosystem_api import router as ecosystem_api_router

router = APIRouter()

# 原有路由
router.include_router(stores_router, prefix="/stores", tags=["独立站管理"])
router.include_router(products_router, prefix="/products", tags=["商品管理"])
router.include_router(auth_router, prefix="/auth", tags=["用户认证"])

# 新的独立站数据路由（二级导航）
router.include_router(product_search_router, prefix="/shopify/products", tags=["Shopify 商品"])
router.include_router(product_sales_rank_router, prefix="/shopify/products/sales-rank", tags=["Shopify 商品"])
router.include_router(product_surge_rank_router, prefix="/shopify/products/surge-rank", tags=["Shopify 商品"])
router.include_router(product_potential_new_router, prefix="/shopify/products/potential-new", tags=["Shopify 商品"])
router.include_router(store_search_router, prefix="/shopify/stores", tags=["Shopify 店铺"])
router.include_router(store_best_sellers_router, prefix="/shopify/stores/best-sellers", tags=["Shopify 店铺"])
router.include_router(store_surge_rank_router, prefix="/shopify/stores/surge-rank", tags=["Shopify 店铺"])
router.include_router(category_overview_router, prefix="/shopify/category/overview", tags=["Shopify 数据大盘"])
router.include_router(product_overview_router, prefix="/shopify/product/overview", tags=["Shopify 数据大盘"])
router.include_router(store_overview_router, prefix="/shopify/store/overview", tags=["Shopify 数据大盘"])
router.include_router(ai_report_router, prefix="/shopify/ai-report", tags=["Shopify AI"])
router.include_router(ad_library_router, prefix="/shopify/ads/library", tags=["Shopify 广告"])

# TikTok 数据路由（按 5 个模块组注册）
# TikTok 大盘组
router.include_router(tk_overview_category_router, prefix="/tiktok/overview", tags=["TikTok 大盘"])
router.include_router(tk_overview_product_router, prefix="/tiktok/overview", tags=["TikTok 大盘"])
router.include_router(tk_overview_store_router, prefix="/tiktok/overview", tags=["TikTok 大盘"])
router.include_router(tk_overview_ai_router, prefix="/tiktok/overview", tags=["TikTok 大盘"])

# 选爆品组
router.include_router(tk_prod_search_router, prefix="/tiktok/products", tags=["TikTok 选爆品"])
router.include_router(tk_prod_sales_rank_router, prefix="/tiktok/products", tags=["TikTok 选爆品"])
router.include_router(tk_prod_surge_rank_router, prefix="/tiktok/products", tags=["TikTok 选爆品"])
router.include_router(tk_prod_potential_new_router, prefix="/tiktok/products", tags=["TikTok 选爆品"])

# 盯爆店组
router.include_router(tk_store_search_router, prefix="/tiktok/stores", tags=["TikTok 盯爆店"])
router.include_router(tk_store_best_sellers_router, prefix="/tiktok/stores", tags=["TikTok 盯爆店"])
router.include_router(tk_store_surge_rank_router, prefix="/tiktok/stores", tags=["TikTok 盯爆店"])

# 找视频组
router.include_router(tk_video_search_router, prefix="/tiktok/videos", tags=["TikTok 找视频"])
router.include_router(tk_video_ai_router, prefix="/tiktok/videos", tags=["TikTok 找视频"])
router.include_router(tk_video_ads_router, prefix="/tiktok/videos", tags=["TikTok 找视频"])

# 选达人组
router.include_router(tk_inf_search_router, prefix="/tiktok/influencers", tags=["TikTok 选达人"])
router.include_router(tk_inf_sales_rank_router, prefix="/tiktok/influencers", tags=["TikTok 选达人"])
router.include_router(tk_inf_follower_rank_router, prefix="/tiktok/influencers", tags=["TikTok 选达人"])
router.include_router(tk_inf_agency_rank_router, prefix="/tiktok/influencers", tags=["TikTok 选达人"])

# 内容创作路由（按 4 个模块组注册）
# 找创意组
router.include_router(content_creative_natural_flow_router, prefix="/content/creative", tags=["内容创作-找创意"])
router.include_router(content_creative_viral_analysis_router, prefix="/content/creative", tags=["内容创作-找创意"])
router.include_router(content_creative_selling_point_router, prefix="/content/creative", tags=["内容创作-找创意"])

# AI 视频组
router.include_router(content_ai_video_seedance_router, prefix="/content/ai-video", tags=["内容创作-AI视频"])
router.include_router(content_ai_video_auto_clip_router, prefix="/content/ai-video", tags=["内容创作-AI视频"])
router.include_router(content_ai_video_clone_router, prefix="/content/ai-video", tags=["内容创作-AI视频"])

# 去生图组
router.include_router(content_image_gen_product_main_router, prefix="/content/image-gen", tags=["内容创作-去生图"])
router.include_router(content_image_gen_model_swap_router, prefix="/content/image-gen", tags=["内容创作-去生图"])
router.include_router(content_image_gen_model_hold_router, prefix="/content/image-gen", tags=["内容创作-去生图"])

# 资料库组
router.include_router(content_assets_my_product_router, prefix="/content/assets", tags=["内容创作-资料库"])
router.include_router(content_assets_my_model_router, prefix="/content/assets", tags=["内容创作-资料库"])
router.include_router(content_assets_my_material_router, prefix="/content/assets", tags=["内容创作-资料库"])

# 社媒管理路由（按 6 个模块组注册）
# 社媒平台组
router.include_router(social_platform_fb_router, tags=["社媒管理-平台"])
router.include_router(social_platform_ins_router, tags=["社媒管理-平台"])
router.include_router(social_platform_youtube_router, tags=["社媒管理-平台"])

# 私域组
router.include_router(social_private_line_router, tags=["社媒管理-私域"])
router.include_router(social_private_whatsapp_router, tags=["社媒管理-私域"])

# 数据看板组
router.include_router(social_dashboard_overview_router, tags=["社媒管理-数据看板"])

# 发布管理组
router.include_router(social_publish_manage_router, tags=["社媒管理-发布管理"])

# 互动管理组
router.include_router(social_interaction_comment_router, tags=["社媒管理-互动管理"])
router.include_router(social_interaction_dm_router, tags=["社媒管理-互动管理"])

# 账号管理组
router.include_router(social_accounts_manage_router, tags=["社媒管理-账号管理"])

# 出海生态路由
router.include_router(ecosystem_api_router, tags=["出海生态"])
