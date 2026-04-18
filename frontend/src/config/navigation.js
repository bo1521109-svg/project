/**
 * 全局导航配置文件
 * 
 * 功能：基于角色的菜单过滤，支持"大卡片 + 小链接"的 Mega Menu 结构
 * 
 * 结构说明：
 * - 一级导航：包含 TikTok 数据、独立站数据、内容制作、社媒管理、建站精灵、客资管家、出海生态
 * - 管理员专属：在数组末尾追加"平台管理"（仅 role === 'admin' 时显示）
 * - 二级导航：每个一级项对应一个二级数组
 *   - card: 大卡片信息（标题、描述、图标）
 *   - links: 下方小链接列表（商品搜索、商品销量榜等）
 * - 占位标识：未开发模块的二级项添加 placeholder: true 标记
 */

/**
 * 导航数据结构
 * 
 * @typedef {Object} NavCard
 * @property {string} title - 卡片标题
 * @property {string} desc - 卡片描述
 * @property {string} icon - 卡片图标
 * 
 * @typedef {Object} NavLink
 * @property {string} name - 链接名称
 * @property {string} path - 路由路径
 * @property {boolean} placeholder - 是否为占位符（未开发模块）
 * 
 * @typedef {Object} NavItem
 * @property {string} name - 导航名称
 * @property {string} path - 路由路径
 * @property {string} icon - 图标名称（可选）
 * @property {Array<Object>} children - 子导航（包含 card 和 links）
 * @property {boolean} disabled - 是否禁用（未开发模块）
 * @property {boolean} placeholder - 是否为占位符（未开发模块）
 * @property {Array<string>} roles - 允许访问的角色列表（可选，默认所有角色可访问）
 */

/**
 * 完整导航配置
 */
export const navigationConfig = [
  // 一级导航：TikTok 数据
  {
    name: 'TikTok 数据',
    path: '/overseas/explore',
    icon: 'VideoPlay',
    children: [
      {
        // 大卡片 1：TikTok 大盘
        card: {
          title: 'TikTok 大盘',
          desc: '全局数据概览',
          icon: 'Histogram'
        },
        links: [
          { name: '品类大盘', path: '/tiktok/category/overview' },
          { name: '商品大盘', path: '/tiktok/product/overview' },
          { name: '店铺大盘', path: '/tiktok/store/overview' },
          { name: 'AI 报告', path: '/tiktok/ai-report' }
        ]
      },
      {
        // 大卡片 2：选爆品
        card: {
          title: '选爆品',
          desc: '发现热销商品',
          icon: 'ShoppingCart'
        },
        links: [
          { name: '商品搜索', path: '/tiktok/products' },
          { name: '商品销量榜', path: '/tiktok/products/sales-rank' },
          { name: '商品飙升榜', path: '/tiktok/products/surge-rank' },
          { name: '潜力新品榜', path: '/tiktok/products/potential-new' }
        ]
      },
      {
        // 大卡片 3：盯爆店
        card: {
          title: '盯爆店',
          desc: '追踪热门店铺',
          icon: 'Shop'
        },
        links: [
          { name: '店铺搜索', path: '/tiktok/stores' },
          { name: '店铺爆卖榜', path: '/tiktok/stores/best-sellers' },
          { name: '店铺飙升榜', path: '/tiktok/stores/surge-rank' },
          { name: '', path: '', isBlank: true }
        ]
      },
      {
        // 大卡片 4：内容
        card: {
          title: '内容',
          desc: '视频广告直播',
          icon: 'VideoPlay'
        },
        links: [
          { name: '视频搜索', path: '/tiktok/videos' },
          { name: 'AI 视频', path: '/tiktok/videos/ai' },
          { name: '广告搜索', path: '/tiktok/ads/search' },
          { name: '直播搜索', path: '/tiktok/live/search' }
        ]
      },
      {
        // 大卡片 5：选达人
        card: {
          title: '选达人',
          desc: '发现优质达人',
          icon: 'User'
        },
        links: [
          { name: '达人搜索', path: '/tiktok/influencers' },
          { name: '带货达人榜', path: '/tiktok/influencers/sales-rank' },
          { name: '涨粉达人榜', path: '/tiktok/influencers/follower-rank' },
          { name: '达人机构榜', path: '/tiktok/influencers/agency-rank' }
        ]
      }
    ]
  },

  // 一级导航：独立站数据
  {
    name: '独立站数据',
    path: '/shopify',
    icon: 'Shop',
    children: [
      {
        // 二级导航：大卡片
        card: {
          title: '选爆品',
          desc: '发现热销商品',
          icon: 'ShoppingCart'
        },
        // 三级导航：下方链接
        links: [
          { name: '商品搜索', path: '/shopify/products', placeholder: false },
          { name: '商品销量榜', path: '/shopify/products/sales-rank', placeholder: true },
          { name: '商品飙升榜', path: '/shopify/products/surge-rank', placeholder: true },
          { name: '潜力新品榜', path: '/shopify/products/potential-new', placeholder: true }
        ]
      },
      {
        // 二级导航：大卡片
        card: {
          title: '盯爆店',
          desc: '追踪热门店铺',
          icon: 'Shop'
        },
        // 三级导航：下方链接
        links: [
          { name: '店铺搜索', path: '/shopify/stores', placeholder: false },
          { name: '店铺爆卖榜', path: '/shopify/stores/best-sellers', placeholder: true },
          { name: '店铺飙升榜', path: '/shopify/stores/surge-rank', placeholder: true }
        ]
      },
      {
        // 二级导航：大卡片
        card: {
          title: '数据大盘',
          desc: '全局数据概览',
          icon: 'DataAnalysis'
        },
        // 三级导航：下方链接
        links: [
          { name: '品类大盘', path: '/shopify/category/overview', placeholder: true },
          { name: '商品大盘', path: '/shopify/product/overview', placeholder: true },
          { name: '店铺大盘', path: '/shopify/store/overview', placeholder: true },
          { name: 'AI 报告', path: '/shopify/ai-report', placeholder: true }
        ]
      },
      {
        // 二级导航：大卡片
        card: {
          title: '找广告',
          desc: '广告素材库',
          icon: 'Picture'
        },
        // 三级导航：下方链接
        links: [
          { name: '广告库', path: '/shopify/ads/library', placeholder: true }
        ]
      }
    ]
  },

  // 一级导航：内容制作
  {
    name: '内容创作',
    path: '/content',
    icon: 'Edit',
    children: [
      {
        // 大卡片 1：找创意
        card: {
          title: '找创意',
          desc: '激发创作灵感',
          icon: 'Lightning'
        },
        links: [
          { name: '自然流广告素材', path: '/content/creative/natural-flow' },
          { name: '爆款视频分析', path: '/content/creative/viral-analysis' },
          { name: '视频卖点宝抄', path: '/content/creative/selling-point' },
          { name: '', path: '', isBlank: true }
        ]
      },
      {
        // 大卡片 2：AI 视频
        card: {
          title: 'AI 视频',
          desc: '智能视频生成',
          icon: 'VideoCamera'
        },
        links: [
          { name: 'Seedance2.0/Sora2', path: '/content/ai-video/seedance' },
          { name: '自动生成片片', path: '/content/ai-video/auto-clip' },
          { name: '一键克隆视频', path: '/content/ai-video/clone' },
          { name: '', path: '', isBlank: true }
        ]
      },
      {
        // 大卡片 3：去生图
        card: {
          title: '去生图',
          desc: 'AI 图片生成',
          icon: 'Picture'
        },
        links: [
          { name: '炒做商品主图', path: '/content/image-gen/product-main' },
          { name: '一键模特换衣', path: '/content/image-gen/model-swap' },
          { name: 'AI 模特手持图', path: '/content/image-gen/model-hold' },
          { name: '', path: '', isBlank: true }
        ]
      },
      {
        // 大卡片 4：资料库
        card: {
          title: '资料库',
          desc: '素材管理中心',
          icon: 'FolderOpened'
        },
        links: [
          { name: '我的产品', path: '/content/assets/my-product' },
          { name: '我的模特', path: '/content/assets/my-model' },
          { name: '我的素材', path: '/content/assets/my-material' },
          { name: '', path: '', isBlank: true }
        ]
      },
      {
        // 大卡片 5：空白占位（第 5 列留白）
        card: null,
        links: []
      }
    ]
  },

  // 一级导航：社媒管理
  {
    name: '社媒管理',
    path: '/social',
    icon: 'ChatDotRound',
    children: [
      {
        // 第 1 列：社媒平台
        card: { title: '社媒平台', desc: '主流社交平台', icon: 'Globe' },
        links: [
          { name: 'Facebook', path: '/social/platforms/facebook' },
          { name: 'Instagram', path: '/social/platforms/instagram' },
          { name: 'YouTube', path: '/social/platforms/youtube' },
          { isBlank: true }
        ]
      },
      {
        // 第 2 列：私域
        card: { title: '私域', desc: '私域流量管理', icon: 'Lock' },
        links: [
          { name: 'Line', path: '/social/private/line' },
          { name: "What's App", path: '/social/private/whatsapp' },
          { isBlank: true },
          { isBlank: true }
        ]
      },
      {
        // 第 3 列：数据看板
        card: { title: '数据看板', desc: '运营数据分析', icon: 'TrendCharts' },
        links: [
          { name: '总览数据概况', path: '/social/dashboard/overview' },
          { isBlank: true },
          { isBlank: true }
        ]
      },
      {
        // 第 4 列：发布管理
        card: { title: '发布管理', desc: '内容发布管理', icon: 'Upload' },
        links: [
          { name: '管理发布预约', path: '/social/publish/manage' },
          { isBlank: true },
          { isBlank: true }
        ]
      },
      {
        // 第 5 列：互动管理
        card: { title: '互动管理', desc: '评论私信管理', icon: 'ChatDotRound' },
        links: [
          { name: '管理评论互动', path: '/social/interaction/comments' },
          { name: '管理私信互动', path: '/social/interaction/direct-messages' },
          { isBlank: true }
        ]
      },
      {
        // 第 6 列：账号管理
        card: { title: '账号管理', desc: '社媒账号管理', icon: 'User' },
        links: [
          { name: '管理社媒账号', path: '/social/accounts/manage' },
          { isBlank: true },
          { isBlank: true }
        ]
      }
    ]
  },

  // 一级导航：建站精灵
  {
    name: '建站精灵',
    path: '/website',
    icon: 'Monitor',
    disabled: true,
    placeholder: true,
    children: [
      {
        card: {
          title: '快速建站',
          desc: '模板与域名管理',
          icon: 'Monitor'
        },
        links: [
          { name: '模板库', path: '/website/templates', placeholder: true },
          { name: '我的网站', path: '/website/my-sites', placeholder: true },
          { name: '域名管理', path: '/website/domains', placeholder: true }
        ]
      }
    ]
  },

  // 一级导航：客资管家
  {
    name: '客资管家',
    path: '/crm',
    icon: 'User',
    disabled: true,
    placeholder: true,
    children: [
      {
        card: {
          title: 'CRM 管理',
          desc: '客户与订单管理',
          icon: 'User'
        },
        links: [
          { name: '客户管理', path: '/crm/customers', placeholder: true },
          { name: '订单管理', path: '/crm/orders', placeholder: true },
          { name: '数据报表', path: '/crm/reports', placeholder: true }
        ]
      }
    ]
  },

  // 一级导航：出海生态
  {
    name: '出海生态',
    path: '/ecosystem',
    icon: 'Star',
    tags: 'New',
    children: [
      {
        card: { title: '开放平台', desc: '整合开放平台', icon: 'Box' },
        links: [{ name: '接入开放平台', path: '/ecosystem/open-platform' }]
      },
      {
        card: { title: '资源资源', desc: '优质服务商圈', icon: 'Connection' },
        links: [{ name: '资源服务商圈', path: '/ecosystem/resources' }]
      },
      {
        card: { title: '跨境智库', desc: '地图导航地图', icon: 'Reading' },
        links: [{ name: '学习智库', path: '/ecosystem/knowledge-base' }]
      }
    ]
  }
]

/**
 * 管理员专属导航（仅 role === 'admin' 时追加）
 */
export const adminNavigation = {
  name: '平台管理',
  path: '/admin',
  icon: 'Setting',
  roles: ['admin'],
  children: [
    {
      card: {
        title: '爬虫管理',
        desc: '管理爬虫任务',
        icon: 'Connection'
      },
      links: [
        { name: '爬虫任务列表', path: '/admin/crawler/tasks' },
        { name: '爬虫日志', path: '/admin/crawler/logs' },
        { name: '爬虫配置', path: '/admin/crawler/config' },
        { name: '', path: '', isBlank: true }
      ]
    },
    {
      card: {
        title: '用户管理',
        desc: '管理平台用户',
        icon: 'User'
      },
      links: [
        { name: '用户列表', path: '/admin/users' },
        { name: '角色权限', path: '/admin/permissions' },
        { name: '登录日志', path: '/admin/login-logs' },
        { name: '', path: '', isBlank: true }
      ]
    }
  ]
}

/**
 * 根据用户角色过滤导航
 * 
 * @param {string} userRole - 用户角色（如 'admin', 'user'）
 * @returns {Array<NavItem>} 过滤后的一级+二级导航结构
 */
export function getFilteredNav(userRole) {
  // 复制基础导航配置
  let filteredNav = [...navigationConfig]

  // 如果是管理员，追加"平台管理"
  if (userRole === 'admin') {
    filteredNav.push(adminNavigation)
  }

  // 过滤掉用户无权访问的导航项
  filteredNav = filteredNav.filter(item => {
    // 如果导航项指定了 roles，检查用户角色是否在列表中
    if (item.roles && !item.roles.includes(userRole)) {
      return false
    }
    return true
  })

  return filteredNav
}

/**
 * 获取所有可访问的路由路径（用于路由守卫）
 * 
 * @param {string} userRole - 用户角色
 * @returns {Array<string>} 可访问的路由路径列表
 */
export function getAccessiblePaths(userRole) {
  const nav = getFilteredNav(userRole)
  const paths = []

  nav.forEach(item => {
    // 添加一级路径（如果不是占位符）
    if (!item.placeholder && item.path) {
      paths.push(item.path)
    }

    // 添加二级和三级路径
    if (item.children) {
      item.children.forEach(child => {
        // 添加 links 中的路径
        if (child.links) {
          child.links.forEach(link => {
            if (!link.placeholder && link.path) {
              paths.push(link.path)
            }
          })
        }
      })
    }
  })

  return paths
}
