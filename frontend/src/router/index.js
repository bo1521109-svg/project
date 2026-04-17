import { createRouter, createWebHistory } from 'vue-router'
import HorizontalLayout from '../layout/HorizontalLayout.vue'
import Stores from '../views/Stores.vue'
import Products from '../views/Products.vue'
import Profile from '../views/Profile.vue'
import Login from '../views/Login.vue'
import Placeholder from '../views/Placeholder.vue'
import { useUserStore } from '../stores/user'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: { title: '登录', requiresAuth: false }
  },
  {
    path: '/',
    component: HorizontalLayout,
    redirect: '/stores',
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
        component: Placeholder,
        meta: { title: '商品销量榜', requiresAuth: true, placeholder: true }
      },
      {
        path: '/shopify/products/surge-rank',
        name: 'ShopifyProductsSurgeRank',
        component: Placeholder,
        meta: { title: '商品飙升榜', requiresAuth: true, placeholder: true }
      },
      {
        path: '/shopify/products/potential-new',
        name: 'ShopifyProductsPotentialNew',
        component: Placeholder,
        meta: { title: '潜力新品榜', requiresAuth: true, placeholder: true }
      },

      // ========== 独立站数据 - 盯爆店（复用 + 占位） ==========
      {
        path: '/shopify/stores',
        name: 'ShopifyStores',
        component: Stores,
        meta: { title: '店铺搜索', requiresAuth: true, placeholder: false }
      },
      {
        path: '/shopify/stores/best-sellers',
        name: 'ShopifyStoresBestSellers',
        component: Placeholder,
        meta: { title: '店铺爆卖榜', requiresAuth: true, placeholder: true }
      },
      {
        path: '/shopify/stores/surge-rank',
        name: 'ShopifyStoresSurgeRank',
        component: Placeholder,
        meta: { title: '店铺飙升榜', requiresAuth: true, placeholder: true }
      },

      // ========== 独立站数据 - 数据大盘（占位） ==========
      {
        path: '/shopify/category/overview',
        name: 'ShopifyCategoryOverview',
        component: Placeholder,
        meta: { title: '品类大盘', requiresAuth: true, placeholder: true }
      },
      {
        path: '/shopify/product/overview',
        name: 'ShopifyProductOverview',
        component: Placeholder,
        meta: { title: '商品大盘', requiresAuth: true, placeholder: true }
      },
      {
        path: '/shopify/store/overview',
        name: 'ShopifyStoreOverview',
        component: Placeholder,
        meta: { title: '店铺大盘', requiresAuth: true, placeholder: true }
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
        component: Placeholder,
        meta: { title: '广告库', requiresAuth: true, placeholder: true }
      },

      // ========== TikTok 数据 - 数据大盘（占位） ==========
      {
        path: '/tiktok/category/overview',
        name: 'TikTokCategoryOverview',
        component: Placeholder,
        meta: { title: '品类大盘', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/product/overview',
        name: 'TikTokProductOverview',
        component: Placeholder,
        meta: { title: '商品大盘', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/store/overview',
        name: 'TikTokStoreOverview',
        component: Placeholder,
        meta: { title: '店铺大盘', requiresAuth: true, placeholder: true }
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
        component: Placeholder,
        meta: { title: '商品搜索', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/products/sales-rank',
        name: 'TikTokProductsSalesRank',
        component: Placeholder,
        meta: { title: '商品销量榜', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/products/surge-rank',
        name: 'TikTokProductsSurgeRank',
        component: Placeholder,
        meta: { title: '商品飙升榜', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/products/potential-new',
        name: 'TikTokProductsPotentialNew',
        component: Placeholder,
        meta: { title: '潜力新品榜', requiresAuth: true, placeholder: true }
      },

      // ========== TikTok 数据 - 盯爆店（占位） ==========
      {
        path: '/tiktok/stores',
        name: 'TikTokStores',
        component: Placeholder,
        meta: { title: '店铺搜索', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/stores/best-sellers',
        name: 'TikTokStoresBestSellers',
        component: Placeholder,
        meta: { title: '店铺爆卖榜', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/stores/surge-rank',
        name: 'TikTokStoresSurgeRank',
        component: Placeholder,
        meta: { title: '店铺飙升榜', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/stores/medium',
        name: 'TikTokStoresMedium',
        component: Placeholder,
        meta: { title: '腰部店', requiresAuth: true, placeholder: true }
      },

      // ========== TikTok 数据 - 找达人（占位） ==========
      {
        path: '/tiktok/influencers',
        name: 'TikTokInfluencers',
        component: Placeholder,
        meta: { title: '达人搜索', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/influencers/sales-rank',
        name: 'TikTokInfluencersSalesRank',
        component: Placeholder,
        meta: { title: '带货达人榜', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/influencers/follower-rank',
        name: 'TikTokInfluencersFollowerRank',
        component: Placeholder,
        meta: { title: '涨粉达人榜', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/influencers/agency-rank',
        name: 'TikTokInfluencersAgencyRank',
        component: Placeholder,
        meta: { title: '达人机构榜', requiresAuth: true, placeholder: true }
      },

      // ========== TikTok 数据 - 找视频（占位） ==========
      {
        path: '/tiktok/videos',
        name: 'TikTokVideos',
        component: Placeholder,
        meta: { title: '视频搜索', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/videos/ai',
        name: 'TikTokVideosAi',
        component: Placeholder,
        meta: { title: 'AI 爆款', requiresAuth: true, placeholder: true }
      },

      // ========== TikTok 数据 - 找广告（占位） ==========
      {
        path: '/tiktok/ads/search',
        name: 'TikTokAdsSearch',
        component: Placeholder,
        meta: { title: '广告搜索', requiresAuth: true, placeholder: true }
      },
      {
        path: '/tiktok/ads/mobile',
        name: 'TikTokAdsMobile',
        component: Placeholder,
        meta: { title: '建站广告', requiresAuth: true, placeholder: true }
      },



      // ========== 内容创作 - 找创意（占位） ==========
      {
        path: '/content/creative/natural-flow',
        name: 'ContentCreativeNaturalFlow',
        component: Placeholder,
        meta: { title: '自然流广告素材', requiresAuth: true, placeholder: true }
      },
      {
        path: '/content/creative/viral-analysis',
        name: 'ContentCreativeViralAnalysis',
        component: Placeholder,
        meta: { title: '爆款视频分析', requiresAuth: true, placeholder: true }
      },
      {
        path: '/content/creative/selling-point',
        name: 'ContentCreativeSellingPoint',
        component: Placeholder,
        meta: { title: '视频卖点宝抄', requiresAuth: true, placeholder: true }
      },

      // ========== 内容创作 - AI 视频（占位） ==========
      {
        path: '/content/ai-video/seedance',
        name: 'ContentAiVideoSeedance',
        component: Placeholder,
        meta: { title: 'Seedance2.0/Sora2', requiresAuth: true, placeholder: true }
      },
      {
        path: '/content/ai-video/auto-clip',
        name: 'ContentAiVideoAutoClip',
        component: Placeholder,
        meta: { title: '自动生成片片', requiresAuth: true, placeholder: true }
      },
      {
        path: '/content/ai-video/clone',
        name: 'ContentAiVideoClone',
        component: Placeholder,
        meta: { title: '一键克隆视频', requiresAuth: true, placeholder: true }
      },

      // ========== 内容创作 - 去生图（占位） ==========
      {
        path: '/content/image-gen/product-main',
        name: 'ContentImageGenProductMain',
        component: Placeholder,
        meta: { title: '炒做商品主图', requiresAuth: true, placeholder: true }
      },
      {
        path: '/content/image-gen/model-swap',
        name: 'ContentImageGenModelSwap',
        component: Placeholder,
        meta: { title: '一键模特换衣', requiresAuth: true, placeholder: true }
      },
      {
        path: '/content/image-gen/model-hold',
        name: 'ContentImageGenModelHold',
        component: Placeholder,
        meta: { title: 'AI 模特手持图', requiresAuth: true, placeholder: true }
      },

      // ========== 内容创作 - 资料库（占位） ==========
      {
        path: '/content/assets/my-product',
        name: 'ContentAssetsMyProduct',
        component: Placeholder,
        meta: { title: '我的产品', requiresAuth: true, placeholder: true }
      },
      {
        path: '/content/assets/my-model',
        name: 'ContentAssetsMyModel',
        component: Placeholder,
        meta: { title: '我的模特', requiresAuth: true, placeholder: true }
      },
      {
        path: '/content/assets/my-material',
        name: 'ContentAssetsMyMaterial',
        component: Placeholder,
        meta: { title: '我的素材', requiresAuth: true, placeholder: true }
      },

      // ========== 社媒管理（占位） ==========
      {
        path: '/social',
        redirect: '/social/platforms/facebook'
      },
      // 社媒平台组
      {
        path: '/social/platforms/facebook',
        name: 'SocialPlatformFacebook',
        component: Placeholder,
        meta: { title: 'Facebook', requiresAuth: true, placeholder: true }
      },
      {
        path: '/social/platforms/instagram',
        name: 'SocialPlatformInstagram',
        component: Placeholder,
        meta: { title: 'Instagram', requiresAuth: true, placeholder: true }
      },
      {
        path: '/social/platforms/youtube',
        name: 'SocialPlatformYoutube',
        component: Placeholder,
        meta: { title: 'YouTube', requiresAuth: true, placeholder: true }
      },
      // 私域组
      {
        path: '/social/private/line',
        name: 'SocialPrivateLine',
        component: Placeholder,
        meta: { title: 'Line', requiresAuth: true, placeholder: true }
      },
      {
        path: '/social/private/whatsapp',
        name: 'SocialPrivateWhatsapp',
        component: Placeholder,
        meta: { title: "What's App", requiresAuth: true, placeholder: true }
      },
      // 数据看板组
      {
        path: '/social/dashboard/overview',
        name: 'SocialDashboardOverview',
        component: Placeholder,
        meta: { title: '数据看板', requiresAuth: true, placeholder: true }
      },
      // 发布管理组
      {
        path: '/social/publish/manage',
        name: 'SocialPublishManage',
        component: Placeholder,
        meta: { title: '发布管理', requiresAuth: true, placeholder: true }
      },
      // 互动管理组
      {
        path: '/social/interaction/comments',
        name: 'SocialInteractionComments',
        component: Placeholder,
        meta: { title: '智能评论回复', requiresAuth: true, placeholder: true }
      },
      {
        path: '/social/interaction/direct-messages',
        name: 'SocialInteractionDirectMessages',
        component: Placeholder,
        meta: { title: '智能私信回复', requiresAuth: true, placeholder: true }
      },
      // 账号管理组
      {
        path: '/social/accounts/manage',
        name: 'SocialAccountsManage',
        component: Placeholder,
        meta: { title: '智能账号管理', requiresAuth: true, placeholder: true }
      },

      // ========== 建站精灵（占位） ==========
      {
        path: '/website',
        redirect: '/website/templates'
      },
      {
        path: '/website/templates',
        name: 'WebsiteTemplates',
        component: Placeholder,
        meta: { title: '模板库', requiresAuth: true }
      },
      {
        path: '/website/my-sites',
        name: 'WebsiteMySites',
        component: Placeholder,
        meta: { title: '我的网站', requiresAuth: true }
      },
      {
        path: '/website/domains',
        name: 'WebsiteDomains',
        component: Placeholder,
        meta: { title: '域名管理', requiresAuth: true }
      },

      // ========== 客资管家（占位） ==========
      {
        path: '/crm',
        redirect: '/crm/customers'
      },
      {
        path: '/crm/customers',
        name: 'CrmCustomers',
        component: Placeholder,
        meta: { title: '客户管理', requiresAuth: true }
      },
      {
        path: '/crm/orders',
        name: 'CrmOrders',
        component: Placeholder,
        meta: { title: '订单管理', requiresAuth: true }
      },
      {
        path: '/crm/reports',
        name: 'CrmReports',
        component: Placeholder,
        meta: { title: '数据报表', requiresAuth: true }
      },

      // ========== 出海生态（占位） ==========
      {
        path: '/ecosystem',
        redirect: '/ecosystem/open-platform'
      },
      {
        path: '/ecosystem/open-platform',
        name: 'EcosystemOpenPlatform',
        component: Placeholder,
        meta: { title: '接入开放平台', requiresAuth: true, placeholder: true }
      },
      {
        path: '/ecosystem/resources',
        name: 'EcosystemResources',
        component: Placeholder,
        meta: { title: '资源服务商圈', requiresAuth: true, placeholder: true }
      },
      {
        path: '/ecosystem/knowledge-base',
        name: 'EcosystemKnowledgeBase',
        component: Placeholder,
        meta: { title: '学习智库', requiresAuth: true, placeholder: true }
      },

      // ========== 平台管理（管理员专属） ==========
      {
        path: '/admin',
        redirect: '/admin/users'
      },
      {
        path: '/admin/users',
        name: 'AdminUsers',
        component: Placeholder,
        meta: { title: '用户管理', requiresAuth: true, requiresAdmin: true }
      },
      {
        path: '/admin/permissions',
        name: 'AdminPermissions',
        component: Placeholder,
        meta: { title: '权限管理', requiresAuth: true, requiresAdmin: true }
      },
      {
        path: '/admin/settings',
        name: 'AdminSettings',
        component: Placeholder,
        meta: { title: '系统设置', requiresAuth: true, requiresAdmin: true }
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
  const userRole = userStore.user?.role || 'user' // 获取用户角色，默认为 'user'

  // 访问需要登录的页面（/stores, /products 等）
  if (to.meta.requiresAuth && !isLoggedIn) {
    // 无 token，重定向到登录页
    next('/login')
  } 
  // 访问管理员专属页面，但用户不是管理员
  else if (to.meta.requiresAdmin && userRole !== 'admin') {
    // 非管理员访问管理员页面，重定向到首页
    next('/stores')
  }
  // 已登录用户访问登录页，重定向到店铺管理
  else if (to.path === '/login' && isLoggedIn) {
    next('/stores')
  } 
  // 其他情况正常放行
  else {
    next()
  }
})

export default router
