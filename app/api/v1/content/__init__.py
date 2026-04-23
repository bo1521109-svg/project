"""
内容创作 API 路由
"""
from fastapi import APIRouter

router = APIRouter()

# 导入所有内容创作相关的路由
from . import (
    content_ai_video_auto_clip,
    content_ai_video_clone,
    content_ai_video_seedance,
    content_assets_my_material,
    content_assets_my_model,
    content_assets_my_product,
    content_creative_natural_flow,
    content_creative_selling_point,
    content_creative_viral_analysis,
    content_image_gen_model_hold,
    content_image_gen_model_swap,
    content_image_gen_product_main
)

# 注册所有路由
router.include_router(content_ai_video_auto_clip.router, prefix="/ai-video/auto-clip", tags=["内容创作 自动生成样片"])
router.include_router(content_ai_video_clone.router, prefix="/ai-video/clone", tags=["内容创作 一键克隆视频"])
router.include_router(content_ai_video_seedance.router, prefix="/ai-video/seedance", tags=["内容创作 Seedance2.0/Sora2"])
router.include_router(content_assets_my_material.router, prefix="/assets/my-material", tags=["内容创作 我的素材"])
router.include_router(content_assets_my_model.router, prefix="/assets/my-model", tags=["内容创作 我的模特"])
router.include_router(content_assets_my_product.router, prefix="/assets/my-product", tags=["内容创作 我的产品"])
router.include_router(content_creative_natural_flow.router, prefix="/creative/natural-flow", tags=["内容创作 自然流/广告素材"])
router.include_router(content_creative_selling_point.router, prefix="/creative/selling-point", tags=["内容创作 视频卖点呈现"])
router.include_router(content_creative_viral_analysis.router, prefix="/creative/viral-analysis", tags=["内容创作 爆款视频分析"])
router.include_router(content_image_gen_model_hold.router, prefix="/image-gen/model-hold", tags=["内容创作 AI模特手持图"])
router.include_router(content_image_gen_model_swap.router, prefix="/image-gen/model-swap", tags=["内容创作 一键模特换衣"])
router.include_router(content_image_gen_product_main.router, prefix="/image-gen/product-main", tags=["内容创作 妙做商品主图"])
