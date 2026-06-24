import { createRouter, createWebHistory } from 'vue-router'
import VerticalLayout from '../layout/VerticalLayout.vue'
import Stores from '../views/Stores.vue'
import Products from '../views/shopify/ProductSearch.vue'
import Profile from '../views/Profile.vue'
import Login from '../views/Login.vue'
import Placeholder from '../views/Placeholder.vue'
import ContentWorkbench from '../views/content/Workbench.vue'
import SocialWorkbench from '../views/social/Workbench.vue'
import UserManagement from '../views/admin/UserManagement.vue'
import PermissionManagement from '../views/admin/PermissionManagement.vue'
import LoginLogs from '../views/admin/LoginLogs.vue'
import StoreSearch from '../views/shopify/StoreSearch.vue'
import StoreBestSellers from '../views/shopify/StoreBestSellers.vue'
import StoreSurgeRank from '../views/shopify/StoreSurgeRank.vue'
import CategoryOverview from '../views/shopify/CategoryOverview.vue'
import ProductOverview from '../views/shopify/ProductOverview.vue'
import StoreDashboard from '../views/shopify/StoreDashboard.vue'
import TikTokStoreSearch from '../views/tiktok/StoreSearch.vue'
import TikTokProductSearch from '../views/tiktok/ProductSearch.vue'
import TikTokSalesRank from '../views/tiktok/SalesRank.vue'
import TikTokSurgeRank from '../views/tiktok/SurgeRank.vue'
import TikTokStoreBestSellers from '../views/tiktok/StoreBestSellers.vue'
import TikTokStoreSurgeRank from '../views/tiktok/StoreSurgeRank.vue'
import TikTokStoreDashboard from '../views/tiktok/StoreDashboard.vue'
import TikTokProductOverview from '../views/tiktok/ProductOverview.vue'
import TikTokCategoryOverview from '../views/tiktok/CategoryOverview.vue'
import TikTokVideoSearch from '../views/tiktok/VideoSearch.vue'
import TikTokAdSearch from '../views/tiktok/AdSearch.vue'
import TikTokInfluencerSearch from '../views/tiktok/InfluencerSearch.vue'
import TikTokInfluencerSalesRank from '../views/tiktok/SalesRank.vue'
import TikTokInfluencerFollowerRank from '../views/tiktok/FollowerRank.vue'
import TikTokInfluencerAgencyRank from '../views/tiktok/AgencyRank.vue'
import TradeProduct from '../views/trade/TradeProduct.vue'
import TradeRegion from '../views/trade/TradeRegion.vue'
import ServiceLogistics from '../views/service/ServiceLogistics.vue'
import ServiceWarehouse from '../views/service/ServiceWarehouse.vue'
import ServiceQualification from '../views/service/ServiceQualification.vue'
import ServiceFactory from '../views/service/ServiceFactory.vue'
import ServiceInfluencer from '../views/service/ServiceInfluencer.vue'
import KnowledgeCourses from '../views/knowledge/KnowledgeCourses.vue'
import KnowledgeGuides from '../views/knowledge/KnowledgeGuides.vue'
import KnowledgeAds from '../views/knowledge/KnowledgeAds.vue'
import KnowledgeCases from '../views/knowledge/KnowledgeCases.vue'
import CreativeNaturalFlow from '../views/content/NaturalFlow.vue'
import CreativeViralAnalysis from '../views/content/ViralAnalysis.vue'
import CreativeSellingPoint from '../views/content/SellingPoint.vue'
import CreativeSeedance from '../views/content/Seedance.vue'
import CreativeAutoClip from '../views/content/AutoClip.vue'
import CreativeClone from '../views/content/Clone.vue'
import CreativeProductMain from '../views/content/ProductMain.vue'
import CreativeModelSwap from '../views/content/ModelSwap.vue'
import CreativeModelHold from '../views/content/ModelHold.vue'
import ContentMyProduct from '../views/content/MyProduct.vue'
import ContentMyModel from '../views/content/MyModel.vue'
import ContentMyMaterial from '../views/content/MyMaterial.vue'
import TikTokAIVideo from '../views/tiktok/AIVideo.vue'
import HotVideo from '../views/shopify/HotVideo.vue'
import AdSearch from '../views/shopify/AdSearch.vue'
import SalesRank from '../views/shopify/SalesRank.vue'
import SurgeRank from '../views/shopify/SurgeRank.vue'
// 社媒平台
import SocialTikTok from '../views/social/SocialPlatformTikTok.vue'
import SocialFacebook from '../views/social/SocialPlatformFacebook.vue'
import SocialInstagram from '../views/social/SocialPlatformInstagram.vue'
import SocialTwitter from '../views/social/SocialPlatformTwitter.vue'
import SocialYoutube from '../views/social/SocialPlatformYoutube.vue'
import SocialPinterest from '../views/social/SocialPlatformPinterest.vue'
import SocialReddit from '../views/social/SocialPlatformReddit.vue'
// 私域
import SocialPrivateLine from '../views/social/SocialPrivateLine.vue'
import SocialPrivateWhatsapp from '../views/social/SocialPrivateWhatsapp.vue'
// 数据看板 & 发布管理
import SocialDashboardOverview from '../views/social/SocialDashboardOverview.vue'
import SocialPublishManage from '../views/social/SocialPublishManage.vue'
// 互动管理
import SocialInteractionComments from '../views/social/SocialInteractionComments.vue'
import SocialInteractionDirectMessages from '../views/social/SocialInteractionDirectMessages.vue'
// 账号管理
import SocialAccountsManage from '../views/social/SocialAccountsManage.vue'
// 客资管家
import CRMOverview from '../views/crm/CRMOverview.vue'
import CRMCustomers from '../views/crm/CRMCustomers.vue'
import CRMFollowUps from '../views/crm/CRMFollowUps.vue'
import CRMAnalytics from '../views/crm/CRMAnalytics.vue'
import CRMTags from '../views/crm/CRMTags.vue'
// 我的
import MyFavorites from '../views/my/MyFavorites.vue'
import MyCreations from '../views/my/MyCreations.vue'
import Purchase from '../views/my/Purchase.vue'
import { useUserStore } from '../stores/user'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: { title: '登录', requiresAuth: false }
  },
  // 站点预览（无需登录，无侧边栏布局）
  {
    path: '/preview/:siteId',
    name: 'SitePreview',
    component: () => import('../views/website/SitePreview.vue'),
    meta: { title: '站点预览', requiresAuth: false }
  },
  {
    path: '/website/:id/preview',
    component: () => import('../views/website/SitePreview.vue'),
    meta: { title: '站点预览', requiresAuth: false }
  },
  {
    path: '/',
    component: VerticalLayout,
    redirect: '/overseas/explore',
    meta: { requiresAuth: true }, // 需要登录
    children: [
      // ========== 独立站数据（已开发） ==========
      {
        path: '/stores',
        name: 'Stores',
        component: Stores,
        meta: { title: '店铺管理', requiresAuth: true }
      },
      {
        path: '/products',
        name: 'Products',
        component: Products,
        meta: { title: '商品列表', requiresAuth: true }
      },
      {
        path: '/profile',
        name: 'Profile',
        component: Profile,
        meta: { title: '个人中心', requiresAuth: true }
      },

      // ========== 独立站数据 - 工作台 ==========
      {
        path: '/shopify/workbench',
        name: 'ShopifyWorkbench',
        component: Placeholder,
        meta: { title: '工作台', requiresAuth: true, placeholder: true }
      },

      // ========== 独立站数据 - 选爆品（复用 + 占位） ==========
      {
        path: '/shopify/products',
        name: 'ShopifyProducts',
        component: Products,
        meta: { title: '商品搜索', requiresAuth: true, placeholder: false }
      },
      {
        path: '/shopify/products/sales-rank',
        name: 'ShopifyProductsSalesRank',
        component: SalesRank,
        meta: { title: '商品销量榜', requiresAuth: true, placeholder: false }
      },
      {
        path: '/shopify/products/surge-rank',
        name: 'ShopifyProductsSurgeRank',
        component: SurgeRank,
        meta: { title: '商品飙升榜', requiresAuth: true, placeholder: false }
      },
      {
        path: '/shopify/products/potential-new',
        name: 'ShopifyProductsPotentialNew',
        component: Placeholder,
        meta: { title: '潜力新品榜', requiresAuth: true, placeholder: true }
      },

      // ========== 独立站数据 - 盯爆店（复用 + 占位） ==========
      {
        path: '/shopify/stores/search',
        name: 'ShopifyStoresSearch',
        component: StoreSearch,
        meta: { title: '店铺搜索', requiresAuth: true, placeholder: false }
      },
      {
        path: '/shopify/stores/best-sellers',
        name: 'ShopifyStoresBestSellers',
        component: StoreBestSellers,
        meta: { title: '店铺爆卖榜', requiresAuth: true, placeholder: false }
      },
      {
        path: '/shopify/stores/surge-rank',
        name: 'ShopifyStoresSurgeRank',
        component: StoreSurgeRank,
        meta: { title: '店铺飙升榜', requiresAuth: true, placeholder: false }
      },

      // ========== 独立站数据 - 数据大盘（占位） ==========
      {
        path: '/shopify/category/overview',
        name: 'ShopifyCategoryOverview',
        component: CategoryOverview,
        meta: { title: '品类大盘', requiresAuth: true, placeholder: false }
      },
      {
        path: '/shopify/product/overview',
        name: 'ShopifyProductOverview',
        component: ProductOverview,
        meta: { title: '商品大盘', requiresAuth: true, placeholder: false }
      },
      {
        path: '/shopify/store/overview',
        name: 'ShopifyStoreOverview',
        component: StoreDashboard,
        meta: { title: '店铺大盘', requiresAuth: true, placeholder: false }
      },
      {
        path: '/shopify/ai-report',
        name: 'ShopifyAiReport',
        component: Placeholder,
        meta: { title: 'AI 报告', requiresAuth: true, placeholder: true }
      },

      // ========== 独立站数据 - 找广告（占位） ==========
      {
        path: '/shopify/ads/library',
        name: 'ShopifyAdsLibrary',
        component: AdSearch,
        meta: { title: '广告搜索', requiresAuth: true, placeholder: false }
      },

      // ========== 独立站数据 - 视频（占位） ==========
      {
        path: '/shopify/videos/hot',
        name: 'ShopifyVideosHot',
        component: HotVideo,
        meta: { title: '热门视频', requiresAuth: true, placeholder: false }
      },
      {
        path: '/shopify/videos/ai',
        name: 'ShopifyVideosAi',
        component: Placeholder,
        meta: { title: 'AI话题', requiresAuth: true, placeholder: true }
      },

      // ========== TikTok 数据 - 数据大盘（占位） ==========
      {
        path: '/tiktok/category/overview',
        name: 'TikTokCategoryOverview',
        component: TikTokCategoryOverview,
        meta: { title: '品类大盘', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/product/overview',
        name: 'TikTokProductOverview',
        component: TikTokProductOverview,
        meta: { title: '商品大盘', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/store/overview',
        name: 'TikTokStoreOverview',
        component: TikTokStoreDashboard,
        meta: { title: '店铺大盘', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/ai-report',
        name: 'TikTokAiReport',
        component: Placeholder,
        meta: { title: 'AI 报告', requiresAuth: true, placeholder: true }
      },

      // ========== TikTok 数据 - 选爆品（占位） ==========
      {
        path: '/tiktok/products',
        name: 'TikTokProducts',
        component: TikTokProductSearch,
        meta: { title: '商品搜索', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/products/sales-rank',
        name: 'TikTokProductsSalesRank',
        component: TikTokSalesRank,
        meta: { title: '商品销量榜', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/products/surge-rank',
        name: 'TikTokProductsSurgeRank',
        component: TikTokSurgeRank,
        meta: { title: '商品飙升榜', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/products/potential-new',
        name: 'TikTokProductsPotentialNew',
        component: Placeholder,
        meta: { title: '潜力新品榜', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/products/history-rank',
        name: 'TikTokProductsHistoryRank',
        component: Placeholder,
        meta: { title: '历史同期榜', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/products/amazon-search',
        name: 'TikTokProductsAmazonSearch',
        component: Placeholder,
        meta: { title: '亚马逊搜索', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/products/tiktok-search',
        name: 'TikTokProductsTikTokSearch',
        component: Placeholder,
        meta: { title: 'TikTok搜索', requiresAuth: true, placeholder: true }
      },

      // ========== TikTok 数据 - 盯爆店（占位） ==========
      {
        path: '/tiktok/stores',
        name: 'TikTokStores',
        component: TikTokStoreSearch,
        meta: { title: '店铺搜索', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/stores/best-sellers',
        name: 'TikTokStoresBestSellers',
        component: TikTokStoreBestSellers,
        meta: { title: '店铺爆卖榜', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/stores/surge-rank',
        name: 'TikTokStoresSurgeRank',
        component: TikTokStoreSurgeRank,
        meta: { title: '店铺飙升榜', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/stores/medium',
        name: 'TikTokStoresMedium',
        component: Placeholder,
        meta: { title: '腰部店', requiresAuth: true, placeholder: true }
      },

      // ========== TikTok 数据 - 找达人 ==========
      {
        path: '/tiktok/influencers',
        name: 'TikTokInfluencers',
        component: TikTokInfluencerSearch,
        meta: { title: '达人搜索', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/influencers/sales-rank',
        name: 'TikTokInfluencersSalesRank',
        component: TikTokInfluencerSalesRank,
        meta: { title: '带货达人榜', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/influencers/follower-rank',
        name: 'TikTokInfluencersFollowerRank',
        component: TikTokInfluencerFollowerRank,
        meta: { title: '涨粉达人榜', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/influencers/agency-rank',
        name: 'TikTokInfluencersAgencyRank',
        component: TikTokInfluencerAgencyRank,
        meta: { title: '达人机构榜', requiresAuth: true, placeholder: false }
      },

      // ========== TikTok 数据 - 找视频 ==========
      {
        path: '/tiktok/videos',
        name: 'TikTokVideos',
        component: TikTokVideoSearch,
        meta: { title: '视频搜索', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/videos/ai',
        name: 'TikTokVideosAi',
        component: TikTokAIVideo,
        meta: { title: 'AI 视频', requiresAuth: true, placeholder: false }
      },

      // ========== TikTok 数据 - 找广告 ==========
      {
        path: '/tiktok/ads/search',
        name: 'TikTokAdsSearch',
        component: TikTokAdSearch,
        meta: { title: '广告搜索', requiresAuth: true, placeholder: false }
      },
      {
        path: '/tiktok/ads/mobile',
        name: 'TikTokAdsMobile',
        component: Placeholder,
        meta: { title: '建站广告', requiresAuth: true, placeholder: true }
      },

      // ========== TikTok 数据 - 直播（占位） ==========
      {
        path: '/tiktok/live/search',
        name: 'TikTokLiveSearch',
        component: Placeholder,
        meta: { title: '直播搜索', requiresAuth: true, placeholder: true }
      },

      // ========== 外贸 ==========
      {
        path: '/trade/region',
        name: 'TradeRegion',
        component: TradeRegion,
        meta: { title: '外贸区域', requiresAuth: true, placeholder: false }
      },
      {
        path: '/trade/product',
        name: 'TradeProduct',
        component: TradeProduct,
        meta: { title: '外贸产品', requiresAuth: true, placeholder: false }
      },

      // ========== 服务商 ==========
      {
        path: '/service/logistics',
        name: 'ServiceLogistics',
        component: ServiceLogistics,
        meta: { title: '国际物流', requiresAuth: true, placeholder: false }
      },
      {
        path: '/service/warehouse',
        name: 'ServiceWarehouse',
        component: ServiceWarehouse,
        meta: { title: '海外仓', requiresAuth: true, placeholder: false }
      },
      {
        path: '/service/qualification',
        name: 'ServiceQualification',
        component: ServiceQualification,
        meta: { title: '资质办理', requiresAuth: true, placeholder: false }
      },
      {
        path: '/service/factory',
        name: 'ServiceFactory',
        component: ServiceFactory,
        meta: { title: '海外工厂', requiresAuth: true, placeholder: false }
      },
      {
        path: '/service/influencer',
        name: 'ServiceInfluencer',
        component: ServiceInfluencer,
        meta: { title: '达人对接', requiresAuth: true, placeholder: false }
      },

      // ========== 我的 ==========
      {
        path: '/my/favorites',
        name: 'MyFavorites',
        component: MyFavorites,
        meta: { title: '我的收藏', requiresAuth: true, placeholder: false }
      },
      {
        path: '/my/creations',
        name: 'MyCreations',
        component: MyCreations,
        meta: { title: '我的创作', requiresAuth: true, placeholder: false }
      },
      {
        path: '/purchase',
        name: 'Purchase',
        component: Purchase,
        meta: { title: '购买续费', requiresAuth: true, placeholder: false }
      },
      // ========== 知识付费 ==========
      {
        path: '/knowledge/courses',
        name: 'KnowledgeCourses',
        component: KnowledgeCourses,
        meta: { title: '运营课程', requiresAuth: true, placeholder: false }
      },
      {
        path: '/knowledge/guides',
        name: 'KnowledgeGuides',
        component: KnowledgeGuides,
        meta: { title: '选品指南', requiresAuth: true, placeholder: false }
      },
      {
        path: '/knowledge/ads',
        name: 'KnowledgeAds',
        component: KnowledgeAds,
        meta: { title: '投放教程', requiresAuth: true, placeholder: false }
      },
      {
        path: '/knowledge/cases',
        name: 'KnowledgeCases',
        component: KnowledgeCases,
        meta: { title: '案例分析', requiresAuth: true, placeholder: false }
      },
      // 兼容旧路由 /knowledge
      {
        path: '/knowledge',
        redirect: '/knowledge/courses'
      },
      {
        path: '/overseas/explore',
        name: 'OverseasExplore',
        component: () => import('../views/overseas/OverseasDashboard.vue'),
        meta: { title: '出海工作台', requiresAuth: true }
      },
      // 市场洞察
      { path: '/overseas/markets/overview', component: () => import('../views/overseas/markets/MarketOverview.vue'), meta: { title: '市场总览', requiresAuth: true } },
      { path: '/overseas/markets/compare', component: () => import('../views/overseas/markets/MarketCompare.vue'), meta: { title: '市场对比', requiresAuth: true } },
      { path: '/overseas/markets/hot-ranking', component: () => import('../views/overseas/markets/CategoryHotRanking.vue'), meta: { title: '品类热度榜', requiresAuth: true } },
      // 商机发现
      { path: '/overseas/opportunities/product-radar', component: () => import('../views/overseas/opportunities/ProductRadar.vue'), meta: { title: '爆品雷达', requiresAuth: true } },
      { path: '/overseas/opportunities/blue-ocean', component: () => import('../views/overseas/opportunities/BlueOcean.vue'), meta: { title: '蓝海品类', requiresAuth: true } },
      { path: '/overseas/opportunities/cross-platform', component: () => import('../views/overseas/opportunities/CrossPlatform.vue'), meta: { title: '跨平台对比', requiresAuth: true } },
      // 趋势追踪
      { path: '/overseas/trends', component: () => import('../views/overseas/TrendTracking.vue'), meta: { title: '趋势追踪', requiresAuth: true } },
      // AI 出海助手
      { path: '/overseas/ai-assistant', component: Placeholder, meta: { title: 'AI 出海助手', placeholder: true } },
      // 生态服务
      { path: '/overseas/ecosystem', component: () => import('../views/overseas/Ecosystem.vue'), meta: { title: '生态服务', requiresAuth: true } },


      // ========== 内容创作 - 工作台 ==========
      {
        path: '/content/workbench',
        name: 'ContentWorkbench',
        component: ContentWorkbench,
        meta: { title: '工作台', requiresAuth: true }
      },

      // ========== 内容创作 - 找创意 ==========
      {
        path: '/content/creative/natural-flow',
        name: 'ContentCreativeNaturalFlow',
        component: CreativeNaturalFlow,
        meta: { title: '自然流/广告素材', requiresAuth: true, placeholder: false }
      },
      {
        path: '/content/creative/viral-analysis',
        name: 'ContentCreativeViralAnalysis',
        component: CreativeViralAnalysis,
        meta: { title: '爆款视频分析', requiresAuth: true, placeholder: false }
      },
      {
        path: '/content/creative/selling-point',
        name: 'ContentCreativeSellingPoint',
        component: CreativeSellingPoint,
        meta: { title: '视频卖点呈现', requiresAuth: true, placeholder: false }
      },

      // ========== 内容创作 - AI 视频 ==========
      {
        path: '/content/ai-video/seedance',
        name: 'ContentAiVideoSeedance',
        component: CreativeSeedance,
        meta: { title: 'Seedance2.0/Sora2', requiresAuth: true, placeholder: false }
      },
      {
        path: '/content/ai-video/auto-clip',
        name: 'ContentAiVideoAutoClip',
        component: CreativeAutoClip,
        meta: { title: '自动生成样片', requiresAuth: true, placeholder: false }
      },
      {
        path: '/content/ai-video/clone',
        name: 'ContentAiVideoClone',
        component: CreativeClone,
        meta: { title: '一键克隆视频', requiresAuth: true, placeholder: false }
      },

      // ========== 内容创作 - 去生图 ==========
      {
        path: '/content/image-gen/product-main',
        name: 'ContentImageGenProductMain',
        component: CreativeProductMain,
        meta: { title: '妙做商品主图', requiresAuth: true, placeholder: false }
      },
      {
        path: '/content/image-gen/model-swap',
        name: 'ContentImageGenModelSwap',
        component: CreativeModelSwap,
        meta: { title: '一键模特换衣', requiresAuth: true, placeholder: false }
      },
      {
        path: '/content/image-gen/model-hold',
        name: 'ContentImageGenModelHold',
        component: CreativeModelHold,
        meta: { title: 'AI 模特手持图', requiresAuth: true, placeholder: false }
      },

      // ========== 内容创作 - 资料库 ==========
      {
        path: '/content/assets/my-product',
        name: 'ContentAssetsMyProduct',
        component: ContentMyProduct,
        meta: { title: '我的产品', requiresAuth: true, placeholder: false }
      },
      {
        path: '/content/assets/my-model',
        name: 'ContentAssetsMyModel',
        component: ContentMyModel,
        meta: { title: '我的模特', requiresAuth: true, placeholder: false }
      },
      {
        path: '/content/assets/my-material',
        name: 'ContentAssetsMyMaterial',
        component: ContentMyMaterial,
        meta: { title: '我的素材', requiresAuth: true, placeholder: false }
      },

      // ========== 社媒管理 - 工作台 ==========
      {
        path: '/social/workbench',
        name: 'SocialWorkbench',
        component: SocialWorkbench,
        meta: { title: '工作台', requiresAuth: true }
      },

      // ========== 社媒管理（占位） ==========
      {
        path: '/social',
        redirect: '/social/workbench'
      },
      // 社媒平台组
      {
        path: '/social/platforms/tiktok',
        name: 'SocialPlatformTikTok',
        component: SocialTikTok,
        meta: { title: 'TikTok', requiresAuth: true, placeholder: false }
      },
      {
        path: '/social/platforms/facebook',
        name: 'SocialPlatformFacebook',
        component: SocialFacebook,
        meta: { title: 'Facebook', requiresAuth: true, placeholder: false }
      },
      {
        path: '/social/platforms/instagram',
        name: 'SocialPlatformInstagram',
        component: SocialInstagram,
        meta: { title: 'Instagram', requiresAuth: true, placeholder: false }
      },
      {
        path: '/social/platforms/twitter',
        name: 'SocialPlatformTwitter',
        component: SocialTwitter,
        meta: { title: 'Twitter/X', requiresAuth: true, placeholder: false }
      },
      {
        path: '/social/platforms/youtube',
        name: 'SocialPlatformYoutube',
        component: SocialYoutube,
        meta: { title: 'YouTube', requiresAuth: true, placeholder: false }
      },
      {
        path: '/social/platforms/pinterest',
        name: 'SocialPlatformPinterest',
        component: SocialPinterest,
        meta: { title: 'Pinterest', requiresAuth: true, placeholder: false }
      },
      {
        path: '/social/platforms/reddit',
        name: 'SocialPlatformReddit',
        component: SocialReddit,
        meta: { title: 'Reddit', requiresAuth: true, placeholder: false }
      },
      // 私域组
      {
        path: '/social/private/line',
        name: 'SocialPrivateLine',
        component: SocialPrivateLine,
        meta: { title: 'Line', requiresAuth: true, placeholder: false }
      },
      {
        path: '/social/private/whatsapp',
        name: 'SocialPrivateWhatsapp',
        component: SocialPrivateWhatsapp,
        meta: { title: "What's App", requiresAuth: true, placeholder: false }
      },
      // 数据看板组
      {
        path: '/social/dashboard/overview',
        name: 'SocialDashboardOverview',
        component: SocialDashboardOverview,
        meta: { title: '数据看板', requiresAuth: true, placeholder: false }
      },
      // 发布管理组
      {
        path: '/social/publish/manage',
        name: 'SocialPublishManage',
        component: SocialPublishManage,
        meta: { title: '发布管理', requiresAuth: true, placeholder: false }
      },
      // 互动管理组
      {
        path: '/social/interaction/comments',
        name: 'SocialInteractionComments',
        component: SocialInteractionComments,
        meta: { title: '智能评论回复', requiresAuth: true, placeholder: false }
      },
      {
        path: '/social/interaction/direct-messages',
        name: 'SocialInteractionDirectMessages',
        component: SocialInteractionDirectMessages,
        meta: { title: '智能私信回复', requiresAuth: true, placeholder: false }
      },
      // 账号管理组
      {
        path: '/social/accounts/manage',
        name: 'SocialAccountsManage',
        component: SocialAccountsManage,
        meta: { title: '智能账号管理', requiresAuth: true, placeholder: false }
      },

      // ========== 建站精灵 ==========
      {
        path: '/website',
        redirect: '/website/my-sites'
      },
      {
        path: '/website/my-sites',
        name: 'WebsiteMySites',
        component: () => import('../views/website/SiteList.vue'),
        meta: { title: '我的网站', requiresAuth: true }
      },
      {
        path: '/website/create',
        name: 'WebsiteCreate',
        component: () => import('../views/website/SiteForm.vue'),
        meta: { title: '创建站点', requiresAuth: true }
      },
      {
        path: '/website/:id',
        name: 'WebsiteDetail',
        component: () => import('../views/website/SiteDetail.vue'),
        meta: { title: '站点详情', requiresAuth: true }
      },
      {
        path: '/website/templates',
        name: 'TemplateLibrary',
        component: () => import('../views/website/TemplateLibrary.vue'),
        meta: { title: '模板库' }
      },
      {
        path: '/website/domains',
        name: 'DomainManagementPage',
        component: () => import('../views/website/DomainManagementPage.vue'),
        meta: { title: '域名管理' }
      },

      // ========== 客资管家 ==========
      {
        path: '/crm',
        redirect: '/crm/overview'
      },
      {
        path: '/crm/overview',
        name: 'CRMOverview',
        component: CRMOverview,
        meta: { title: '客资概览', requiresAuth: true, placeholder: false }
      },
      {
        path: '/crm/customers',
        name: 'CRMCustomers',
        component: CRMCustomers,
        meta: { title: '客户管理', requiresAuth: true, placeholder: false }
      },
      {
        path: '/crm/follow-ups',
        name: 'CRMFollowUps',
        component: CRMFollowUps,
        meta: { title: '跟进记录', requiresAuth: true, placeholder: false }
      },
      {
        path: '/crm/analytics',
        name: 'CRMAnalytics',
        component: CRMAnalytics,
        meta: { title: '客资分析', requiresAuth: true, placeholder: false }
      },
      {
        path: '/crm/tags',
        name: 'CRMTags',
        component: CRMTags,
        meta: { title: '标签管理', requiresAuth: true, placeholder: false }
      },

      // ========== 出海生态（占位） ==========
      {
        path: '/ecosystem',
        redirect: '/overseas/explore'
      },
      {
        path: '/ecosystem/knowledge-base',
        name: 'EcosystemKnowledgeBase',
        component: () => import('../views/ecosystem/KnowledgeBase.vue'),
        meta: { title: '学习智库', requiresAuth: true }
      },

      // ========== 平台管理（管理员专属） ==========
      {
        path: '/admin',
        redirect: '/admin/crawler/tasks'
      },
      // 爬虫管理
      {
        path: '/admin/crawler/tasks',
        name: 'AdminCrawlerTasks',
        component: () => import('../views/admin/CrawlerTasks.vue'),
        meta: { title: '爬虫任务列表', requiresAuth: true, requiresAdmin: true }
      },
      {
        path: '/admin/crawler/logs',
        name: 'AdminCrawlerLogs',
        component: () => import('../views/admin/CrawlerLogs.vue'),
        meta: { title: '爬虫日志', requiresAuth: true, requiresAdmin: true }
      },
      {
        path: '/admin/crawler/config',
        name: 'AdminCrawlerConfig',
        component: () => import('../views/admin/CrawlerConfig.vue'),
        meta: { title: '爬虫配置', requiresAuth: true, requiresAdmin: true }
      },
      // 用户管理
      {
        path: '/admin/users',
        name: 'AdminUsers',
        component: UserManagement,
        meta: { title: '用户管理', requiresAuth: true, requiresAdmin: true }
      },
      {
        path: '/admin/permissions',
        name: 'AdminPermissions',
        component: PermissionManagement,
        meta: { title: '权限管理', requiresAuth: true, requiresAdmin: true }
      },
      {
        path: '/admin/login-logs',
        name: 'AdminLoginLogs',
        component: LoginLogs,
        meta: { title: '登录日志', requiresAuth: true, requiresAdmin: true }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 全局路由守卫
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  const isLoggedIn = userStore.isLoggedIn()
  const userRole = userStore.userInfo?.role || 'user' // 获取用户角色，默认为 'user'

  console.log('路由守卫:', {
    to: to.path,
    from: from.path,
    isLoggedIn,
    userRole,
    userInfo: userStore.userInfo,
    requiresAuth: to.meta.requiresAuth,
    requiresAdmin: to.meta.requiresAdmin
  })

  // 访问需要登录的页面（/stores, /products 等）
  if (to.meta.requiresAuth && !isLoggedIn) {
    // 无 token，重定向到登录页
    console.log('未登录，重定向到登录页')
    next('/login')
  } 
  // 访问管理员专属页面，但用户不是管理员
  else if (to.meta.requiresAdmin && userRole !== 'admin') {
    // 非管理员访问管理员页面，重定向到首页
    console.log('非管理员，重定向到首页')
    next('/stores')
  }
  // 已登录用户访问登录页，重定向到店铺管理
  else if (to.path === '/login' && isLoggedIn) {
    console.log('已登录，重定向到店铺管理')
    next('/stores')
  } 
  // 其他情况正常放行
  else {
    console.log('正常放行')
    next()
  }
})

export default router
