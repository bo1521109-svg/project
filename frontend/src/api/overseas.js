/**
 * 出海模块 - 完整伪数据层（纯前端，不请求后端）
 * 涵盖市场洞察、爆品发现、达人营销、竞品监控、趋势分析、生态服务、AI 助手
 */

// ======================================================================
//  1. 核心指标
// ======================================================================

export const mockOverviewData = {
  totalProducts: 12580,
  totalShops: 3460,
  totalInfluencers: 8920,
  totalMarkets: 15,
  todayGmv: 12800000,
  todayOrders: 45200,
  avgConversionRate: 4.8,
  avgRoas: 3.2
}

/** 获取核心指标 */
export function getOverviewData() {
  return { ...mockOverviewData }
}

// ======================================================================
//  2. 市场数据（15 个国家）
// ======================================================================

export const mockMarkets = [
  // ========== 北美市场 ==========
  { code: 'US', name: '美国', ecomScale: 12000, growthRate: 12.5, tiktokPenetration: 38, topCategories: ['电子配件', '家居用品', '运动户外'], difficulty: '中', platforms: ['Amazon', 'eBay', 'Walmart', 'Shopify'], tariff: '0%-25%', logistics: '7-15天', heat: 95 },
  { code: 'CA', name: '加拿大', ecomScale: 2800, growthRate: 10.2, tiktokPenetration: 34, topCategories: ['电子配件', '户外装备', '家居用品'], difficulty: '中', platforms: ['Amazon', 'Shopify', 'Walmart'], tariff: '0%-18%', logistics: '7-12天', heat: 88 },
  { code: 'MX', name: '墨西哥', ecomScale: 850, growthRate: 17.8, tiktokPenetration: 39, topCategories: ['电子配件', '服装', '家居用品'], difficulty: '中', platforms: ['Mercado Libre', 'Amazon', 'Coppel'], tariff: '0%-30%', logistics: '10-18天', heat: 72 },
  // ========== 欧洲市场 ==========
  { code: 'GB', name: '英国', ecomScale: 3200, growthRate: 9.8, tiktokPenetration: 35, topCategories: ['服饰鞋包', '家居家具', '美妆'], difficulty: '中', platforms: ['Amazon', 'Argos', 'Tesco'], tariff: '3%-12%', logistics: '8-15天', heat: 85 },
  { code: 'DE', name: '德国', ecomScale: 3500, growthRate: 9.2, tiktokPenetration: 29, topCategories: ['家居家具', '服饰鞋包', '电子数码'], difficulty: '高', platforms: ['Amazon', 'Otto', 'Zalando'], tariff: '3%-12%', logistics: '10-20天', heat: 82 },
  { code: 'FR', name: '法国', ecomScale: 2900, growthRate: 10.1, tiktokPenetration: 31, topCategories: ['服饰鞋包', '家居家具', '美妆'], difficulty: '高', platforms: ['Amazon', 'Cdiscount', 'Fnac'], tariff: '3%-12%', logistics: '10-18天', heat: 79 },
  { code: 'IT', name: '意大利', ecomScale: 2200, growthRate: 8.7, tiktokPenetration: 26, topCategories: ['服饰鞋包', '家居家具', '食品'], difficulty: '中', platforms: ['Amazon', 'eBay', 'Zalando'], tariff: '3%-12%', logistics: '10-20天', heat: 76 },
  { code: 'ES', name: '西班牙', ecomScale: 1600, growthRate: 11.5, tiktokPenetration: 30, topCategories: ['服饰鞋包', '家居家具', '食品'], difficulty: '中', platforms: ['Amazon', 'El Corte Ingles', 'Fnac'], tariff: '3%-12%', logistics: '10-18天', heat: 74 },
  // ========== 东南亚市场 ==========
  { code: 'ID', name: '印尼', ecomScale: 1800, growthRate: 28.4, tiktokPenetration: 52, topCategories: ['美妆个护', '服装', '食品饮料'], difficulty: '低', platforms: ['Shopee', 'Tokopedia', 'Lazada'], tariff: '0%-5%', logistics: '5-10天', heat: 92 },
  { code: 'TH', name: '泰国', ecomScale: 1100, growthRate: 22.3, tiktokPenetration: 45, topCategories: ['美妆个护', '服装', '食品饮料'], difficulty: '低', platforms: ['Shopee', 'Lazada', 'Central'], tariff: '0%-5%', logistics: '3-7天', heat: 88 },
  { code: 'VN', name: '越南', ecomScale: 980, growthRate: 25.1, tiktokPenetration: 48, topCategories: ['服装', '食品饮料', '美妆个护'], difficulty: '低', platforms: ['Shopee', 'Lazada', 'Tiki'], tariff: '0%-5%', logistics: '3-7天', heat: 86 },
  { code: 'PH', name: '菲律宾', ecomScale: 650, growthRate: 20.7, tiktokPenetration: 42, topCategories: ['美妆个护', '服装', '食品饮料'], difficulty: '低', platforms: ['Shopee', 'Lazada', 'Zalora'], tariff: '0%-5%', logistics: '5-8天', heat: 83 },
  { code: 'MY', name: '马来西亚', ecomScale: 720, growthRate: 18.6, tiktokPenetration: 40, topCategories: ['美妆个护', '服装', '食品饮料'], difficulty: '低', platforms: ['Shopee', 'Lazada', 'PG Mall'], tariff: '0%-5%', logistics: '3-7天', heat: 81 },
  { code: 'SG', name: '新加坡', ecomScale: 580, growthRate: 14.2, tiktokPenetration: 36, topCategories: ['电子数码', '美妆个护', '食品饮料'], difficulty: '中', platforms: ['Shopee', 'Lazada', 'Amazon'], tariff: '0%-7%', logistics: '3-7天', heat: 78 },
  // ========== 拉美市场 ==========
  { code: 'BR', name: '巴西', ecomScale: 2200, growthRate: 19.5, tiktokPenetration: 44, topCategories: ['电子配件', '运动户外', '服装'], difficulty: '中', platforms: ['Mercado Livre', 'Shopee', 'Magalu'], tariff: '0%-35%', logistics: '15-30天', heat: 68 },
  { code: 'AR', name: '阿根廷', ecomScale: 520, growthRate: 14.8, tiktokPenetration: 32, topCategories: ['运动户外', '电子配件', '服装'], difficulty: '中', platforms: ['Mercado Livre', 'Amazon'], tariff: '0%-35%', logistics: '15-25天', heat: 58 },
  { code: 'CO', name: '哥伦比亚', ecomScale: 380, growthRate: 21.3, tiktokPenetration: 38, topCategories: ['电子配件', '运动户外', '服装'], difficulty: '中', platforms: ['Mercado Livre', 'Amazon', 'Shopee'], tariff: '0%-35%', logistics: '12-25天', heat: 62 },
  // ========== 中亚市场 ==========
  { code: 'KZ', name: '哈萨克斯坦', ecomScale: 320, growthRate: 18.2, tiktokPenetration: 28, topCategories: ['轻工业品', '日用百货', '电子配件'], difficulty: '低', platforms: ['Kaspi', 'Ozon', 'Wildberries'], tariff: '5%-15%', logistics: '10-20天', heat: 58 },
  { code: 'UZ', name: '乌兹别克斯坦', ecomScale: 180, growthRate: 22.5, tiktokPenetration: 22, topCategories: ['轻工业品', '日用百货', '服装'], difficulty: '低', platforms: ['Uzum', 'Ozon'], tariff: '5%-15%', logistics: '12-20天', heat: 52 },
  // ========== 中东市场 ==========
  { code: 'AE', name: '阿联酋', ecomScale: 920, growthRate: 25.8, tiktokPenetration: 41, topCategories: ['电子数码', '奢侈品', '美妆'], difficulty: '中', platforms: ['Amazon', 'Noon', 'Namshi'], tariff: '0%-5%', logistics: '10-18天', heat: 75 },
  { code: 'SA', name: '沙特阿拉伯', ecomScale: 750, growthRate: 28.6, tiktokPenetration: 46, topCategories: ['电子数码', '奢侈品', '服装'], difficulty: '中', platforms: ['Amazon', 'Noon', 'Jarir'], tariff: '0%-5%', logistics: '10-18天', heat: 78 }
]

/** 获取所有市场数据 */
export function getMarkets() {
  return [...mockMarkets]
}

/** 根据国家代码获取单个市场 */
export function getMarketByCode(code) {
  return mockMarkets.find(m => m.code === code) || null
}

// ======================================================================
//  3. 爆品数据（50 条）
// ======================================================================

const firstNames = ['简约', '潮流', '轻奢', '时尚', '复古', '北欧', '日式', '韩版', '美式', '户外', '运动', '极客', '科技', '经典', '创意', '自然', '优雅', '可爱', '个性', '专业']
const prodNouns = ['连衣裙', 'T恤', '蓝牙耳机', '手机壳', '瑜伽裤', '手表', '手链', '项链', '保温杯', '背包', '运动鞋', '帽子', '围巾', '墨镜', '台灯', '香薰', '面膜', '洗面奶', '护肤品套装', '咖啡机']

const productCategories = ['服装', '美妆', '3C数码', '家居', '运动户外', '食品', '珠宝饰品', '母婴', '宠物', '个护']
const platforms = ['TikTok', 'Shopify', 'Amazon']
const tags = ['热卖', '新品', '趋势']
const countries = ['US', 'GB', 'ID', 'VN', 'TH', 'BR', 'MX', 'PH', 'MY', 'SG']

const shopNames = ['FashionVibe', 'TechGadget', 'HomeLiving', 'BeautyGlow', 'PetPals', 'SportMax', 'BabyJoy', 'CoffeeHub', 'GreenLeaf', 'JewelryCraft']
const shopDomainSuffixes = ['.com', '.shop', '.store', '.co', '.online']

export const mockHotProducts = Array.from({ length: 50 }, (_, i) => {
  const cat = productCategories[i % productCategories.length]
  const platform = platforms[i % platforms.length]
  const country = countries[i % countries.length]
  const tag = tags[i % tags.length]
  const basePrice = Math.floor(Math.random() * 120) + 5
  return {
    id: i + 1,
    name: `${firstNames[i % firstNames.length]}${prodNouns[i % prodNouns.length]}`,
    category: cat,
    platform,
    price: basePrice + (i % 3 === 0 ? 0.99 : 0),
    weeklySales: Math.floor(Math.random() * 15000) + 500,
    growthRate: Math.round((Math.random() * 60 + 10) * 10) / 10,
    popularityScore: Math.floor(Math.random() * 41) + 60,
    shopName: shopNames[i % shopNames.length],
    country,
    tags: [tag, cat === '美妆' || cat === '个护' ? '复购高' : '高转化'],
    // 伪数据专用字段
    category_hot: Math.round(Math.random() * 30 + 60)
  }
})

/** 分页获取爆品列表 */
export function getHotProducts({ page = 1, pageSize = 20, category = '', platform = '', keyword = '' } = {}) {
  let list = [...mockHotProducts]
  if (category) list = list.filter(p => p.category === category)
  if (platform) list = list.filter(p => p.platform === platform)
  if (keyword) { const q = keyword.toLowerCase(); list = list.filter(p => p.name.includes(q) || p.shopName.toLowerCase().includes(q)) }
  const total = list.length
  const start = (page - 1) * pageSize
  return { items: list.slice(start, start + pageSize), total, page, pageSize }
}

// ======================================================================
//  4. 达人数据（40 条）
// ======================================================================

const influencerNames = ['Lily Chen', 'Sophia Wang', 'Mia Brown', 'Emma Taylor', 'Olivia Kim', 'Ethan Liu', 'Lucas Zhou', 'Noah Yang', 'Liam Lee', 'Mason Zhang',
  'Ava Wu', 'Isabella Li', 'Sophie Park', 'Grace Huang', 'Chloe Xu', 'Zoe Tan', 'Aria Luo', 'Emily He', 'Harper Lin', 'Ella Guo',
  'James Zheng', 'Benjamin Shi', 'Henry Mai', 'Daniel Feng', 'Matthew Xie', 'Jack Yao', 'Owen Cao', 'Samuel Deng', 'Joseph Pan', 'David Su',
  'Abigail Zhu', 'Evelyn Jiang', 'Hannah Qian', 'Victoria Wei', 'Scarlett Shen', 'Layla Cui', 'Penelope Lei', 'Riley Long', 'Aurora Fang', 'Nova Zeng']

const categories = ['服装', '美妆', '3C数码', '家居', '运动户外', '食品', '珠宝饰品', '母婴', '宠物']
const avatarSeed = ['face1', 'face2', 'face3', 'face4', 'face5', 'face6', 'face7', 'face8', 'face9', 'face10']

export const mockInfluencers = Array.from({ length: 40 }, (_, i) => {
  const cat = categories[i % categories.length]
  const followerBase = [10000, 50000, 100000, 500000, 1000000]
  const followerCount = followerBase[i % followerBase.length] * (Math.floor(Math.random() * 5) + 3)
  return {
    id: i + 1,
    name: influencerNames[i],
    avatarUrl: `https://picsum.photos/seed/${avatarSeed[i % avatarSeed.length]}/100/100`,
    country: countries[i % countries.length],
    followers: followerCount,
    category: cat,
    avgLikes: Math.floor(Math.random() * 50000) + 2000,
    avgComments: Math.floor(Math.random() * 8000) + 500,
    avgShares: Math.floor(Math.random() * 3000) + 200,
    engagementRate: Math.round((Math.random() * 4 + 1.5) * 10) / 10,
   带货评分: Math.floor(Math.random() * 4) + 7,
    estCooperationFee: Math.floor(Math.random() * 8000) + 500,
    tags: [Math.random() > 0.5 ? '种草力强' : '转化高', Math.random() > 0.6 ? '视频达人' : '直播达人'],
    avgWeightedScore: Math.round(Math.random() * 2 + 8)
  }
})

/** 分页获取达人列表 */
export function getInfluencers({ page = 1, pageSize = 20, category = '', country = '', keyword = '', sortBy = '' } = {}) {
  let list = [...mockInfluencers]
  if (category) list = list.filter(k => k.category === category)
  if (country) list = list.filter(k => k.country === country)
  if (keyword) { const q = keyword.toLowerCase(); list = list.filter(k => k.name.toLowerCase().includes(q)) }
  if (sortBy === 'followers') list.sort((a, b) => b.followers - a.followers)
  else if (sortBy === 'engagement') list.sort((a, b) => b.engagementRate - a.engagementRate)
  else if (sortBy === 'score') list.sort((a, b) => b.带货评分 - a.带货评分)
  const total = list.length
  const start = (page - 1) * pageSize
  return { items: list.slice(start, start + pageSize), total, page, pageSize }
}

// ======================================================================
//  5. 趋势数据
// ======================================================================

// 热搜关键词
export const mockHotKeywords = [
  { keyword: 'tiktok爆款连衣裙', heat: 98, trend: 'up' },
  { keyword: '蓝牙耳机降噪', heat: 95, trend: 'up' },
  { keyword: '瑜伽裤女', heat: 92, trend: 'up' },
  { keyword: '韩版面膜套装', heat: 89, trend: 'up' },
  { keyword: '运动水壶大容量', heat: 87, trend: 'up' },
  { keyword: '无线充电器', heat: 85, trend: 'stable' },
  { keyword: '夏季凉鞋女', heat: 83, trend: 'up' },
  { keyword: '迷你投影仪', heat: 81, trend: 'up' },
  { keyword: '智能手表男', heat: 78, trend: 'stable' },
  { keyword: '宠物喂食器', heat: 76, trend: 'up' },
  { keyword: 'Stanley水杯', heat: 74, trend: 'down' },
  { keyword: '咖啡胶囊', heat: 72, trend: 'stable' },
  { keyword: '香薰蜡烛', heat: 70, trend: 'up' },
  { keyword: '大码女装', heat: 68, trend: 'stable' },
  { keyword: '男士护肤套装', heat: 65, trend: 'up' },
  { keyword: '儿童益智玩具', heat: 63, trend: 'stable' },
  { keyword: '电动牙刷', heat: 61, trend: 'down' },
  { keyword: '手工皂', heat: 58, trend: 'stable' },
  { keyword: '空气炸锅', heat: 56, trend: 'down' },
  { keyword: '收纳神器', heat: 54, trend: 'stable' }
]

// 热门话题
export const mockHotTopics = [
  { topic: '#TikTokMadeMeBuyIt', discussions: 520000, heat: 98 },
  { topic: '#SmallBizSeason', discussions: 380000, heat: 95 },
  { topic: '#AmazonFindsUnder20', discussions: 340000, heat: 92 },
  { topic: '#SheinHaul', discussions: 290000, heat: 89 },
  { topic: '#ViralBeautyProducts', discussions: 260000, heat: 86 },
  { topic: '#SummerOutfitInspo', discussions: 230000, heat: 83 },
  { topic: '#HomeOrganization', discussions: 210000, heat: 80 },
  { topic: '#TikTokShopFinds', discussions: 190000, heat: 77 },
  { topic: '#SustainableFashion', discussions: 170000, heat: 74 },
  { topic: '#PetProducts', discussions: 150000, heat: 71 },
  { topic: '#TechGadgets', discussions: 130000, heat: 68 },
  { topic: '#FitnessGear', discussions: 110000, heat: 65 },
  { topic: '#SkincareRoutine', discussions: 95000, heat: 62 },
  { topic: '#DIYCrafts', discussions: 82000, heat: 59 },
  { topic: '#HealthySnacks', discussions: 70000, heat: 56 }
]

// 近 7 天各品类热度趋势
export const mockCategoryTrends = [
  { date: '06-10', clothing: 86, beauty: 82, digital3c: 78, home: 74, sports: 70, food: 66, jewelry: 62, baby: 58, pet: 54, personalCare: 61 },
  { date: '06-11', clothing: 88, beauty: 83, digital3c: 76, home: 75, sports: 72, food: 67, jewelry: 63, baby: 59, pet: 55, personalCare: 62 },
  { date: '06-12', clothing: 85, beauty: 81, digital3c: 80, home: 73, sports: 71, food: 65, jewelry: 64, baby: 60, pet: 56, personalCare: 63 },
  { date: '06-13', clothing: 90, beauty: 85, digital3c: 79, home: 76, sports: 73, food: 68, jewelry: 65, baby: 61, pet: 57, personalCare: 64 },
  { date: '06-14', clothing: 87, beauty: 84, digital3c: 81, home: 72, sports: 74, food: 66, jewelry: 66, baby: 58, pet: 58, personalCare: 65 },
  { date: '06-15', clothing: 91, beauty: 86, digital3c: 82, home: 77, sports: 75, food: 69, jewelry: 67, baby: 62, pet: 59, personalCare: 66 },
  { date: '06-16', clothing: 89, beauty: 87, digital3c: 83, home: 78, sports: 76, food: 70, jewelry: 68, baby: 63, pet: 60, personalCare: 65 }
]

/** 获取热搜关键词 */
export function getHotKeywords(page = 1, pageSize = 10) {
  const start = (page - 1) * pageSize
  return { items: mockHotKeywords.slice(start, start + pageSize), total: mockHotKeywords.length }
}

/** 获取热门话题 */
export function getHotTopics(page = 1, pageSize = 10) {
  const start = (page - 1) * pageSize
  return { items: mockHotTopics.slice(start, start + pageSize), total: mockHotTopics.length }
}

/** 获取品类趋势 */
export function getCategoryTrends() {
  return [...mockCategoryTrends]
}

// ======================================================================
//  7. 生态服务商数据（12 条）
// ======================================================================

export const mockServiceProviders = [
  { id: 1, name: '跨境宝物流', category: '物流', description: '全球仓储 + 跨境直邮，覆盖 50+ 国家', rating: 4.8, price: '按单计费', contact: 'service@kua-jing-bao.com', features: ['FBA头程', '海外仓', '小包直邮'], logo: '📦' },
  { id: 2, name: 'PingPong 支付', category: '支付', description: '多币种收款、汇率锁定、VAT 缴税一站式', rating: 4.7, price: '费率 0.5% 起', contact: 'support@pingpong.com', features: ['多币种收款', 'VAT缴税', '汇率锁定'], logo: '💳' },
  { id: 3, name: '店小秘 ERP', category: 'ERP', description: '多平台多店铺统一管理、订单处理自动化', rating: 4.6, price: '免费版/付费版', contact: 'bd@dianxiaomi.com', features: ['订单管理', '库存同步', '数据分析'], logo: '📊' },
  { id: 4, name: '合规助手', category: '合规', description: '跨境法务 + 税务 + 产品合规一站式咨询', rating: 4.5, price: '按需报价', contact: 'info@hegui-helper.com', features: ['产品认证', '税务筹划', '知识产权'], logo: '⚖️' },
  { id: 5, name: '译语通', category: '翻译', description: 'AI+人工翻译，支持 30+ 语言本地化', rating: 4.4, price: '¥0.5/字起', contact: 'hello@yiyu-tong.com', features: ['产品翻译', '本地化', 'SEO关键词'], logo: '🌐' },
  { id: 6, name: '光影内容工场', category: '视频制作', description: '跨境电商视频制作、3D 展示、直播搭建', rating: 4.9, price: '¥2000/条起', contact: 'pro@guangying.com', features: ['产品视频', '3D展示', '直播场景'], logo: '🎬' },
  { id: 7, name: 'OceanAds', category: '广告投放', description: 'TikTok / Meta / Google 广告代投 + 优化', rating: 4.8, price: '消耗 5% 服务费', contact: 'ad@oceanads.io', features: ['TikTok广告', 'Meta投放', 'Google Ads'], logo: '📢' },
  { id: 8, name: '出海商学院', category: '培训咨询', description: '从 0 到 1 跨境电商全链路培训与陪跑', rating: 4.6, price: '¥999/期', contact: 'edu@chuhaibiz.com', features: ['线上课程', '线下工作坊', '1v1陪跑'], logo: '🎓' },
  { id: 9, name: 'ECPro 建站', category: '建站工具', description: 'Shopify 精品建站 + 主题定制 + 插件开发', rating: 4.7, price: '¥3000 起', contact: 'dev@ecpro.com', features: ['Shopify建站', '主题定制', '插件开发'], logo: '🛠️' },
  { id: 10, name: '达人管家', category: '达人营销', description: '跨境 KOL 资源对接、效果监测、内容分发', rating: 4.5, price: '按项目', contact: 'kol@daren-guanjia.com', features: ['KOL对接', '效果追踪', 'MCN合作'], logo: '🤝' },
  { id: 11, name: '测品大师', category: '测品工具', description: 'AI 选品 + 测品 + 竞品监控一体化工具', rating: 4.8, price: '¥499/月', contact: 'ai@cepinda-shi.com', features: ['AI选品', '测品', '竞品监控'], logo: '🔍' },
  { id: 12, name: '回款通', category: '金融', description: '跨境电商供应链金融、垫资回款、信用保险', rating: 4.4, price: '费率透明', contact: 'finance@huikuantong.com', features: ['垫资回款', '信用保险', '汇率对冲'], logo: '🏦' }
]

/** 获取服务商列表 */
export function getServiceProviders(category = '') {
  let list = [...mockServiceProviders]
  if (category) list = list.filter(s => s.category === category)
  return list
}

/** 获取服务商分类列表 */
export function getServiceCategories() {
  return [...new Set(mockServiceProviders.map(s => s.category))]
}

// ======================================================================
//  7.5. 生态服务聚合数据（首页+生态页用）
//  - 包含分类统计、推荐服务商、全部服务商、生态动态
// ======================================================================

export const mockEcosystemData = {
  // ---- 分类统计 ----
  categories: [
    { id: 1, name: '建站服务', icon: '🌐', count: 12 },
    { id: 2, name: '流量投放', icon: '📱', count: 8 },
    { id: 3, name: '跨境物流', icon: '📦', count: 15 },
    { id: 4, name: '跨境支付', icon: '💳', count: 10 },
    { id: 5, name: '合规认证', icon: '📋', count: 7 },
    { id: 6, name: '视频制作', icon: '🎬', count: 6 },
    { id: 7, name: '达人合作', icon: '🤝', count: 9 },
    { id: 8, name: '数据工具', icon: '📊', count: 5 }
  ],

  // ---- 推荐服务商（4家）----
  recommended: [
    {
      id: 1, name: 'Shopify', category: '建站服务', rating: 4.8, reviews: 2340,
      desc: '全球领先的独立站建站平台，提供主题、插件、支付一站式方案',
      logo: 'https://picsum.photos/seed/shopify/80/80', certified: true
    },
    {
      id: 2, name: 'PingPong 支付', category: '跨境支付', rating: 4.7, reviews: 1890,
      desc: '多币种收款、汇率锁定、VAT 缴税一站式跨境支付解决方案',
      logo: 'https://picsum.photos/seed/pingpong/80/80', certified: true
    },
    {
      id: 3, name: '跨境宝物流', category: '跨境物流', rating: 4.6, reviews: 3210,
      desc: '全球仓储 + FBA 头程 + 跨境直邮，覆盖 50+ 国家',
      logo: 'https://picsum.photos/seed/logistics/80/80', certified: true
    },
    {
      id: 4, name: 'OceanAds 投放', category: '流量投放', rating: 4.9, reviews: 1560,
      desc: 'TikTok / Meta / Google 广告代投 + 数据优化，ROAS 提升 200%+',
      logo: 'https://picsum.photos/seed/oceanads/80/80', certified: false
    }
  ],

  // ---- 全部服务商（24家，覆盖所有 8 个分类）----
  providers: [
    // 建站服务（3家）
    { id: 1, name: 'Shopify', category: '建站服务', rating: 4.8, reviews: 2340, desc: '全球领先的独立站建站平台，提供主题、插件、支付一站式方案', logo: 'https://picsum.photos/seed/sp1/80/80', certified: true, year: 2006, status: 'available' },
    { id: 2, name: 'Shoplazza 店匠', category: '建站服务', rating: 4.5, reviews: 980, desc: '专注跨境电商的独立站建站工具，中文后台友好', logo: 'https://picsum.photos/seed/sp2/80/80', certified: true, year: 2017, status: 'available' },
    { id: 3, name: 'ECPro 建站', category: '建站服务', rating: 4.3, reviews: 520, desc: 'Shopify 精品建站 + 主题定制 + 插件开发', logo: 'https://picsum.photos/seed/sp3/80/80', certified: false, year: 2019, status: 'available' },
    // 流量投放（3家）
    { id: 4, name: 'OceanAds', category: '流量投放', rating: 4.9, reviews: 1560, desc: 'TikTok / Meta / Google 广告代投 + 数据优化', logo: 'https://picsum.photos/seed/sp4/80/80', certified: false, year: 2018, status: 'available' },
    { id: 5, name: 'AdsForce', category: '流量投放', rating: 4.6, reviews: 870, desc: 'AI 驱动的跨境电商广告投放自动化平台', logo: 'https://picsum.photos/seed/sp5/80/80', certified: true, year: 2020, status: 'available' },
    { id: 6, name: '出海流量通', category: '流量投放', rating: 4.4, reviews: 640, desc: '一站式跨平台流量采买与归因分析', logo: 'https://picsum.photos/seed/sp6/80/80', certified: false, year: 2021, status: 'available' },
    // 跨境物流（3家）
    { id: 7, name: '跨境宝物流', category: '跨境物流', rating: 4.6, reviews: 3210, desc: '全球仓储 + FBA 头程 + 跨境直邮，覆盖 50+ 国家', logo: 'https://picsum.photos/seed/sp7/80/80', certified: true, year: 2015, status: 'available' },
    { id: 8, name: '飞速国际物流', category: '跨境物流', rating: 4.5, reviews: 2100, desc: '东南亚专线物流，一站式清关+最后一公里配送', logo: 'https://picsum.photos/seed/sp8/80/80', certified: true, year: 2016, status: 'available' },
    { id: 9, name: 'GlobalShip Pro', category: '跨境物流', rating: 4.3, reviews: 1450, desc: '欧美海外仓 + 退货处理 + FBA 中转', logo: 'https://picsum.photos/seed/sp9/80/80', certified: false, year: 2018, status: 'available' },
    // 跨境支付（3家）
    { id: 10, name: 'PingPong 支付', category: '跨境支付', rating: 4.7, reviews: 1890, desc: '多币种收款、汇率锁定、VAT 缴税一站式', logo: 'https://picsum.photos/seed/sp10/80/80', certified: true, year: 2015, status: 'available' },
    { id: 11, name: '连连支付', category: '跨境支付', rating: 4.6, reviews: 2100, desc: '全球收款 + 虚拟卡 + 供应链金融', logo: 'https://picsum.photos/seed/sp11/80/80', certified: true, year: 2009, status: 'available' },
    { id: 12, name: 'Airwallex 空中云汇', category: '跨境支付', rating: 4.8, reviews: 1580, desc: '企业级全球账户 + 多币种钱包 + 实时汇率', logo: 'https://picsum.photos/seed/sp12/80/80', certified: true, year: 2015, status: 'available' },
    // 合规认证（3家）
    { id: 13, name: '合规通', category: '合规认证', rating: 4.5, reviews: 780, desc: '跨境法务 + 税务 + 产品合规一站式咨询', logo: 'https://picsum.photos/seed/sp13/80/80', certified: true, year: 2020, status: 'available' },
    { id: 14, name: 'CE-RoHS 认证中心', category: '合规认证', rating: 4.4, reviews: 560, desc: '欧盟 CE / RoHS / REACH 快速认证服务', logo: 'https://picsum.photos/seed/sp14/80/80', certified: true, year: 2018, status: 'available' },
    { id: 15, name: '知识产权卫士', category: '合规认证', rating: 4.2, reviews: 340, desc: '跨境商标注册 + 专利保护 + 版权维权', logo: 'https://picsum.photos/seed/sp15/80/80', certified: false, year: 2021, status: 'available' },
    // 视频制作（3家）
    { id: 16, name: '光影内容工场', category: '视频制作', rating: 4.9, reviews: 1240, desc: '跨境电商视频制作、3D 展示、直播搭建', logo: 'https://picsum.photos/seed/sp16/80/80', certified: true, year: 2019, status: 'available' },
    { id: 17, name: '出海视觉', category: '视频制作', rating: 4.6, reviews: 680, desc: 'TikTok 短视频 + 信息流广告素材批量生产', logo: 'https://picsum.photos/seed/sp17/80/80', certified: false, year: 2020, status: 'available' },
    { id: 18, name: 'VidPro AI', category: '视频制作', rating: 4.5, reviews: 420, desc: 'AI 驱动的产品视频生成平台，多语言配音', logo: 'https://picsum.photos/seed/sp18/80/80', certified: false, year: 2022, status: 'available' },
    // 达人合作（3家）
    { id: 19, name: '达人管家', category: '达人合作', rating: 4.5, reviews: 920, desc: '跨境 KOL 资源对接、效果监测、内容分发', logo: 'https://picsum.photos/seed/sp19/80/80', certified: false, year: 2020, status: 'available' },
    { id: 20, name: 'InfluMKT', category: '达人合作', rating: 4.7, reviews: 750, desc: '全球达人数据库 + 智能匹配 + ROI 追踪', logo: 'https://picsum.photos/seed/sp20/80/80', certified: true, year: 2019, status: 'available' },
    { id: 21, name: 'MCN 出海联盟', category: '达人合作', rating: 4.4, reviews: 580, desc: '东南亚 + 北美 MCN 资源直连，本土化运营', logo: 'https://picsum.photos/seed/sp21/80/80', certified: false, year: 2021, status: 'available' },
    // 数据工具（3家）
    { id: 22, name: '店小秘 ERP', category: '数据工具', rating: 4.6, reviews: 3200, desc: '多平台多店铺统一管理、订单处理自动化', logo: 'https://picsum.photos/seed/sp22/80/80', certified: true, year: 2014, status: 'available' },
    { id: 23, name: '选品大师 AI', category: '数据工具', rating: 4.5, reviews: 1120, desc: 'AI 选品 + 测品 + 竞品监控一体化工具', logo: 'https://picsum.photos/seed/sp23/80/80', certified: false, year: 2021, status: 'available' },
    { id: 24, name: 'DataCross 跨境数据', category: '数据工具', rating: 4.8, reviews: 890, desc: 'TikTok + Shopify + Amazon 跨平台数据聚合分析', logo: 'https://picsum.photos/seed/sp24/80/80', certified: true, year: 2020, status: 'available' }
  ],

  // ---- 生态动态（8条）----
  dynamics: [
    { id: 1, provider: 'Shopify', title: '推出 AI 建站助手新功能，一句话生成完整独立站', time: '2026-06-18', tag: '新品' },
    { id: 2, provider: 'PingPong 支付', title: '新增印尼盾直接结算，费率降至 0.3%', time: '2026-06-16', tag: '利好' },
    { id: 3, provider: 'OceanAds', title: 'TikTok Shop 广告 ROAS 平均提升 2.5 倍', time: '2026-06-14', tag: '数据' },
    { id: 4, provider: '跨境宝物流', title: '越南海外仓正式启用，配送时效缩短至 2 天', time: '2026-06-12', tag: '升级' },
    { id: 5, provider: '合规通', title: '欧盟 GPSR 法规更新，不合规产品面临下架风险', time: '2026-06-10', tag: '预警' },
    { id: 6, provider: '光影内容工场', title: '上线 AI 虚拟主播带货服务，支持 10+ 语言', time: '2026-06-08', tag: '新品' },
    { id: 7, provider: 'InfluMKT', title: '全球达人数据库突破 50 万，新增中东 KOL 资源', time: '2026-06-05', tag: '升级' },
    { id: 8, provider: 'Airwallex', title: '推出跨境电商专属企业信用卡，返现高达 2%', time: '2026-06-02', tag: '利好' }
  ]
}

/** 获取生态聚合数据（返回页面所需格式） */
export function getEcosystemData() {
  // 映射推荐服务商字段
  const featuredProviders = mockEcosystemData.recommended.map(p => ({
    id: p.id,
    name: p.name,
    logo: p.logo,
    category: p.category,
    rating: p.rating,
    reviewCount: p.reviews,
    description: p.desc,
    verified: p.certified,
    established: 10 + p.id,
    fullDescription: p.desc + '。已为超过 ' + p.reviews + ' 家出海企业提供专业服务，覆盖建站、运营、增长全链路。',
    cooperationCount: p.reviews * 2 + p.id * 100,
    tags: { '建站服务': ['SaaS建站', '主题定制', '插件生态'], '跨境支付': ['多币种收款', 'VAT缴税', '汇率锁定'], '跨境物流': ['FBA头程', '海外仓', '小包直邮'], '流量投放': ['广告代投', '数据分析', 'ROI优化'] }[p.category] || ['专业服务', '高效稳定'],
    contact: {
      email: p.name.toLowerCase().replace(/\s/g, '') + '@service.com',
      website: 'https://www.' + p.name.toLowerCase().replace(/\s/g, '') + '.com',
      wechat: p.name.replace(/\s/g, '') + '_official'
    }
  }))

  // 映射全部服务商字段
  const providers = mockEcosystemData.providers.map(p => ({
    id: p.id,
    name: p.name,
    logo: p.logo,
    category: p.category,
    rating: p.rating,
    reviewCount: p.reviews,
    description: p.desc,
    verified: p.certified,
    established: new Date().getFullYear() - p.year,
    fullDescription: p.desc + '。拥有专业团队和经验丰富的行业专家，致力于为出海企业提供高质量的' + p.category + '解决方案。',
    cooperationCount: p.reviews * 3 + p.id * 80,
    tags: ['专业服务', '经验丰富', '客户信任'].slice(0, 1 + (p.id % 3)),
    contact: {
      email: p.name.toLowerCase().replace(/\s/g, '') + '@service.com',
      website: 'https://www.' + p.name.toLowerCase().replace(/\s/g, '').replace(/[^a-z0-9]/g, '-') + '.com',
      wechat: p.name.replace(/\s/g, '') + '_service'
    }
  }))

  // 映射动态字段
  const news = mockEcosystemData.dynamics.map(d => ({
    id: d.id,
    providerName: d.provider,
    title: d.title,
    time: d.time,
    tag: d.tag
  }))

  return {
    categories: [...mockEcosystemData.categories],
    featuredProviders,
    providers,
    news
  }
}

/** 获取推荐服务商 */
export function getRecommendedProviders() {
  return getEcosystemData().featuredProviders
}

/** 筛选服务商（按分类、关键字、排序） */
export function getEcosystemProviders({ categoryId = '', keyword = '', sortBy = 'recommended' } = {}) {
  let list = getEcosystemData().providers

  // 按分类ID筛选
  if (categoryId) {
    const cat = mockEcosystemData.categories.find(c => String(c.id) === String(categoryId))
    if (cat) list = list.filter(p => p.category === cat.name)
  }

  // 按关键字搜索
  if (keyword.trim()) {
    const kw = keyword.trim().toLowerCase()
    list = list.filter(p => p.name.toLowerCase().includes(kw) || p.category.toLowerCase().includes(kw) || p.description.toLowerCase().includes(kw))
  }

  // 排序
  const sortFns = {
    recommended: (a, b) => b.cooperationCount - a.cooperationCount,
    rating: (a, b) => b.rating - a.rating,
    cooperation: (a, b) => b.reviewCount - a.reviewCount
  }
  const fn = sortFns[sortBy] || sortFns.recommended
  list.sort(fn)
  return list
}

/** 获取生态动态 */
export function getEcosystemDynamics() {
  return [...mockEcosystemData.dynamics]
}

/** 获取全部分类 */
export function getEcosystemCategories() {
  return [...mockEcosystemData.categories]
}

// ======================================================================
//  8. AI 出海助手问答（10 组）
// ======================================================================

export const mockQA = [
  {
    id: 1,
    question: '新手出海应该优先选择哪个市场？',
    answer: '建议优先考虑东南亚市场（印尼、泰国、越南），原因：\n1. TikTok 渗透率高，短视频电商红利明显\n2. 市场增速快（年均 20%+），竞争相对蓝海\n3. 文化相近，选品和内容策略更容易本地化\n4. 物流和支付基础设施日趋完善\n\n如果预算充足且有品牌基础，可同时布局美国市场。'
  },
  {
    id: 2,
    question: '如何选品才能更容易出单？',
    answer: '爆品选品核心逻辑：\n1. 视频友好型产品（能通过 15 秒展示卖点）\n2. 价格在 $15-$50 之间的冲动消费品\n3. 轻小件、物流成本可控\n4. 复购率高或客单价低的上瘾品（美妆、零食、配件）\n5. 利用 TikTok 热门话题和趋势数据追踪选品\n\n推荐工具：TikTok Creative Center、Google Trends、亚马逊新品榜'
  },
  {
    id: 3,
    question: '东南亚市场最适合做什么品类？',
    answer: '东南亚热销品类 TOP 5：\n1. 美妆个护（面膜、口红、护肤套装）— 女性用户主导\n2. 服装配饰（穆斯林时尚、大码女装、配饰）\n3. 3C 配件（手机壳、充电器、蓝牙耳机）— 性价比优先\n4. 家居好物（收纳、香薰、小家电）\n5. 宠物用品（服饰、玩具、喂食器）\n\n提示：注意宗教和文化差异，如印尼市场避免暴露类产品。'
  },
  {
    id: 4,
    question: '应该选择 TikTok Shop 还是独立站（Shopify）？',
    answer: '两者各有优势，建议组合打法：\n\nTikTok Shop 优势：\n- 流量成本低，内容驱动自然流量\n- 转化路径短（即看即买）\n- 适合测品和快速起量\n\n独立站（Shopify）优势：\n- 用户数据完全归自己\n- 复购和 LTV 更高\n- 品牌建设空间大\n\n建议策略：先用 TikTok Shop 测品验证，积累数据后引导到独立站做复购。'
  },
  {
    id: 5,
    question: '跨境物流怎么选最划算？',
    answer: '物流方案选择指南：\n\n1. 小包直邮（$0-$15 产品）：\n   - 云途、燕文等专线小包\n   - 时效 7-15 天，成本低\n\n2. 海外仓（$15 以上产品）：\n   - 谷仓、万邑通等第三方海外仓\n   - 时效 2-5 天，提升转化率\n\n3. FBA（亚马逊卖家）：\n   - 亚马逊官方仓储\n   - Prime 会员免运费，转化最高\n\n建议新卖家从小包直邮起步，月销稳定后布局海外仓。'
  },
  {
    id: 6,
    question: '跨境支付需要注意什么？',
    answer: '跨境支付核心要点：\n\n1. 多币种收款：选择支持 USD/EUR/GBP/SGD 的收款工具\n2. 费率对比：PingPong（0.5%）、连连（0.7%）、Payoneer（1%+）\n3. 汇率锁定：大额回款建议锁定汇率，避免汇率波动\n4. 提现时效：T+1 到 T+3 不等\n5. 合规材料：提前准备好公司资质、营业执照等 KYC 文件\n\n推荐：PingPong + Paypal 组合使用。'
  },
  {
    id: 7,
    question: '怎样找到靠谱的海外达人？',
    answer: '达人合作流程：\n\n1. 明确目标：品牌曝光 → 选头部（100K+），带货转化 → 选中腰部（10K-100K）\n2. 寻找渠道：\n   - TikTok Creator Marketplace\n   - 达人管家等中介平台\n   - Instagram / YouTube 直接搜索\n3. 合作形式：免费寄样 + 佣金（纯佣），或固定费用 + 佣金\n4. 评估指标：完播率 > 评论区互动 > 点赞数 > 粉丝数\n5. 合同要点：明确排他期、素材使用权、ROI 要求'
  },
  {
    id: 8,
    question: '产品合规方面有哪些红线？',
    answer: '跨境合规红线：\n\n美国市场：\n- FCC（电子产品）、FDA（食品/化妆品）、CPSC（儿童产品）\n- 各州消费税合规\n\n欧洲市场：\n- CE 认证 + UKCA（英国）\n- REACH（化学品）、RoHS（电子）\n- GDPR 数据合规\n- EP 包装法 + WEEE 电子垃圾\n\n东南亚市场：\n- BPOM（印尼化妆品/食品认证）\n- SNI（印尼国家标准）\n\n建议：高单价品类提前申请认证，否则面临下架风险。'
  },
  {
    id: 9,
    question: 'TikTok 广告和自然流量怎么配合？',
    answer: 'TikTok 流量矩阵策略：\n\n自然流量（0 成本）：\n- 每天发布 3-5 条短视频\n- 利用热门音乐和挑战话题\n- 企业号认证获得基础信任\n\n付费广告（加速器）：\n- Spark Ads 加热自然爆款视频\n- 直播间引流（Live Ads）\n- 商品卡广告（Product Ads）\n\n最优策略：自然内容测试 → 爆款视频加 Spark Ads → 直播承接转化 → 沉淀到独立站做复购。'
  },
  {
    id: 10,
    question: '出海品牌如何做本土化运营？',
    answer: '本土化运营四大维度：\n\n1. 语言本地化：\n   - 产品描述、客服话术、广告文案使用当地语言\n   - 雇佣当地运营人员或使用专业翻译服务\n\n2. 视觉本地化：\n   - 模特形象、场景符合当地审美\n   - 包装设计考虑文化符号\n\n3. 支付本地化：\n   - 印尼：GoPay、OVO\n   - 泰国：TrueMoney\n   - 巴西：Pix、Boleto\n\n4. 营销本地化：\n   - 结合当地节日（斋月、泼水节、黑五）\n   - 与本地 KOL 合作建立信任'
  }
]

/** 获取 AI 问答列表 */
export function getQA(page = 1, pageSize = 10) {
  const start = (page - 1) * pageSize
  return { items: mockQA.slice(start, start + pageSize), total: mockQA.length }
}

/** 根据关键词搜索问答 */
export function searchQA(keyword) {
  if (!keyword.trim()) return [...mockQA]
  const q = keyword.toLowerCase()
  return mockQA.filter(item => item.question.toLowerCase().includes(q) || item.answer.toLowerCase().includes(q))
}


// ======================================================================
//  8.5. 品类热度榜数据
// ======================================================================

/** 品类图标映射 */
const categoryIcons = {
  '服装': '👗', '美妆': '💄', '3C数码': '📱', '家居': '🏠',
  '运动户外': '⚽', '食品饮料': '🍜', '珠宝饰品': '💎', '母婴': '👶',
  '宠物': '🐾', '个护': '🧴', '箱包': '🎒', '汽车配件': '🚗',
  '文具': '📚', '园艺': '🌿', '健康保健': '💊'
}

/** 各品类的代表商品 */
const categoryProducts = {
  '服装': ['简约连衣裙', '潮流T恤', '瑜伽裤', '防晒衣', '大码女装'],
  '美妆': ['韩版面膜套装', '口红礼盒', '防晒霜', '眼影盘', '粉底液'],
  '3C数码': ['蓝牙耳机', '手机壳', '无线充电器', '智能手表', '迷你投影仪'],
  '家居': ['收纳神器', '香薰蜡烛', '北欧台灯', '保温杯', '空气炸锅'],
  '运动户外': ['运动水壶', '瑜伽垫', '跑步鞋', '登山背包', '骑行手套'],
  '食品饮料': ['咖啡胶囊', '蛋白棒', '康普茶', '坚果礼盒', '方便拉面'],
  '珠宝饰品': ['手链', '项链', '耳环', '戒指', '发饰'],
  '母婴': ['儿童益智玩具', '婴儿爬服', '妈咪包', '学步鞋', '奶瓶套装'],
  '宠物': ['宠物喂食器', '宠物服饰', '猫砂盆', '狗玩具', '宠物牵引绳'],
  '个护': ['电动牙刷', '男士护肤套装', '手工皂', '洗发水', '沐浴露'],
  '箱包': ['双肩背包', '斜挎包', '行李箱', '钱包', '帆布包'],
  '汽车配件': ['车载充电器', '汽车香薰', '遮阳挡', '防滑垫', '行车记录仪'],
  '文具': ['手账本', '荧光笔套装', '便签纸', '笔记本', '印章'],
  '园艺': ['盆栽植物', '花盆', '浇水壶', '园艺工具套装', '种子包'],
  '健康保健': ['维生素片', '护眼丸', '按摩仪', '血压计', '睡眠眼罩']
}

/** 各品类在不同市场中的热度系数（用于市场筛选） */
const categoryMarketHeat = {
  '服装': { US: 95, GB: 88, ID: 92, VN: 90, TH: 85, PH: 82, BR: 78, MX: 75 },
  '美妆': { US: 90, GB: 85, ID: 95, VN: 88, TH: 92, PH: 88, BR: 80, MX: 76 },
  '3C数码': { US: 88, GB: 82, SG: 85, MY: 78, BR: 72, ID: 75, AE: 80 },
  '家居': { US: 82, GB: 80, DE: 85, FR: 78, IT: 76, ES: 72, BR: 68 },
  '运动户外': { US: 85, GB: 78, CA: 82, MX: 75, BR: 80, AR: 72 },
  '食品饮料': { ID: 85, TH: 88, VN: 85, PH: 82, MY: 78, SG: 72, GB: 68 },
  '珠宝饰品': { US: 78, GB: 75, AE: 82, SA: 80, ID: 76, TH: 72 },
  '母婴': { US: 80, GB: 78, ID: 75, PH: 72, BR: 70, MX: 68 },
  '宠物': { US: 78, GB: 75, DE: 72, JP: 76, KR: 78, CN: 82 },
  '个护': { US: 85, GB: 82, ID: 88, TH: 85, VN: 82, PH: 80 },
  '箱包': { US: 76, GB: 72, FR: 78, IT: 80, ID: 74, TH: 70 },
  '汽车配件': { US: 72, DE: 76, JP: 78, BR: 68, MX: 70, ID: 65 },
  '文具': { US: 68, GB: 65, JP: 82, KR: 80, CN: 78, DE: 66 },
  '园艺': { US: 72, GB: 70, DE: 74, FR: 68, CA: 72, AU: 76 },
  '健康保健': { US: 82, GB: 78, DE: 76, JP: 80, KR: 78, AU: 75 }
}

/** 生成趋势数据（带随机波动的平滑曲线） */
function generateTrendData(base, days, variance = 8) {
  const data = []
  let v = base - variance + Math.random() * variance * 2
  for (let i = 0; i < days; i++) {
    v = v + (Math.random() - 0.5) * variance
    v = Math.max(base - variance * 1.5, Math.min(base + variance * 1.5, v))
    // 向基准值回归
    v = v * 0.8 + base * 0.2
    data.push(Math.round(v))
  }
  return data
}

export const mockCategoryHotRanking = [
  { id: 1,  category: '服装',       heatIndex: 98, growthRate: 15.3, trend: 'up',   mainMarkets: ['美国', '印尼', '英国'] },
  { id: 2,  category: '美妆',       heatIndex: 95, growthRate: 18.6, trend: 'up',   mainMarkets: ['印尼', '泰国', '越南'] },
  { id: 3,  category: '3C数码',     heatIndex: 91, growthRate: 8.2,  trend: 'up',   mainMarkets: ['美国', '阿联酋', '新加坡'] },
  { id: 4,  category: '食品饮料',   heatIndex: 88, growthRate: 22.4, trend: 'up',   mainMarkets: ['印尼', '泰国', '越南'] },
  { id: 5,  category: '个护',       heatIndex: 85, growthRate: 12.8, trend: 'up',   mainMarkets: ['美国', '印尼', '英国'] },
  { id: 6,  category: '运动户外',   heatIndex: 82, growthRate: 11.5, trend: 'up',   mainMarkets: ['美国', '巴西', '墨西哥'] },
  { id: 7,  category: '健康保健',   heatIndex: 78, growthRate: 16.2, trend: 'up',   mainMarkets: ['美国', '英国', '日本'] },
  { id: 8,  category: '家居',       heatIndex: 76, growthRate: 9.8,  trend: 'up',   mainMarkets: ['德国', '法国', '英国'] },
  { id: 9,  category: '宠物',       heatIndex: 73, growthRate: 14.5, trend: 'up',   mainMarkets: ['美国', '英国', '韩国'] },
  { id: 10, category: '母婴',       heatIndex: 70, growthRate: 7.8,  trend: 'up',   mainMarkets: ['美国', '英国', '印尼'] },
  { id: 11, category: '珠宝饰品',   heatIndex: 67, growthRate: 10.2, trend: 'up',   mainMarkets: ['阿联酋', '沙特', '美国'] },
  { id: 12, category: '箱包',       heatIndex: 64, growthRate: 8.9,  trend: 'up',   mainMarkets: ['法国', '意大利', '美国'] },
  { id: 13, category: '汽车配件',   heatIndex: 58, growthRate: 6.5,  trend: 'up',   mainMarkets: ['德国', '日本', '美国'] },
  { id: 14, category: '园艺',       heatIndex: 55, growthRate: 12.1, trend: 'up',   mainMarkets: ['德国', '英国', '澳大利亚'] },
  { id: 15, category: '文具',       heatIndex: 52, growthRate: 5.4,  trend: 'up',   mainMarkets: ['日本', '韩国', '中国'] },
].map(item => ({
  ...item,
  icon: categoryIcons[item.category] || '📦',
  representativeProducts: categoryProducts[item.category] || [],
  trend30d: generateTrendData(item.heatIndex, 30, 8),
  trend7d: generateTrendData(item.heatIndex, 7, 5),
  trend90d: generateTrendData(Math.max(40, item.heatIndex - 8), 90, 10),
  marketHeat: categoryMarketHeat[item.category] || {}
}))

/** 获取品类热度榜（支持市场筛选、时间范围、排序） */
export function getCategoryHotRanking({ market = '', timeRange = '30d', sortBy = 'heatIndex' } = {}) {
  let list = [...mockCategoryHotRanking]

  // 如果选择了市场，按该市场的热度重新排序
  if (market && market !== 'global') {
    list = list.map(item => ({
      ...item,
      marketHeatIndex: (item.marketHeat && item.marketHeat[market]) || item.heatIndex - 20,
      marketGrowthRate: item.growthRate + (Math.random() * 4 - 2)
    }))
  } else {
    list = list.map(item => ({
      ...item,
      marketHeatIndex: item.heatIndex,
      marketGrowthRate: item.growthRate
    }))
  }

  // 排序
  if (sortBy === 'heatIndex') {
    list.sort((a, b) => b.marketHeatIndex - a.marketHeatIndex)
  } else if (sortBy === 'growthRate') {
    list.sort((a, b) => (b.marketGrowthRate || b.growthRate) - (a.marketGrowthRate || a.growthRate))
  }

  // 渲染排名
  return list.map((item, idx) => ({
    ...item,
    rank: idx + 1,
    trendData: timeRange === '7d' ? item.trend7d : timeRange === '90d' ? item.trend90d : item.trend30d,
    displayHeatIndex: item.marketHeatIndex !== undefined ? item.marketHeatIndex : item.heatIndex,
    displayGrowthRate: item.marketGrowthRate !== undefined ? item.marketGrowthRate : item.growthRate
  }))
}

// ======================================================================
//  8.6. 爆品雷达数据
// ======================================================================

/** 为爆品生成图片占位 URL */
function productImageUrl(id, name) {
  return `https://picsum.photos/seed/prod${id}/400/400`
}

/** 获取爆品雷达统计 */
export function getProductRadarStats({ category = '', platform = '', keyword = '' } = {}) {
  let list = [...mockHotProducts]
  if (category) list = list.filter(p => p.category === category)
  if (platform) list = list.filter(p => p.platform === platform)
  if (keyword) { const q = keyword.toLowerCase(); list = list.filter(p => p.name.includes(q) || p.shopName.toLowerCase().includes(q)) }

  const growthRates = list.map(p => p.growthRate)
  const avgHeat = list.length
    ? Math.round(list.reduce((s, p) => s + p.popularityScore, 0) / list.length * 10) / 10
    : 0
  const maxGrowth = growthRates.length ? Math.max(...growthRates) : 0

  return {
    total: list.length,
    newToday: Math.floor(list.length * 0.24),  // ~24% 今日新增
    avgHeat,
    maxGrowth
  }
}

/** 分页获取爆品雷达列表 */
export function getProductRadarProducts({ page = 1, pageSize = 12, category = '', platform = '', keyword = '', sortBy = 'popularityScore' } = {}) {
  let list = [...mockHotProducts].map(p => ({
    ...p,
    imageUrl: productImageUrl(p.id, p.name),
    dailySales: Math.floor(p.weeklySales / 7),
    conversionRate: Math.round((Math.random() * 6 + 3) * 10) / 10  // 3%-9%
  }))

  if (category) list = list.filter(p => p.category === category)
  if (platform) list = list.filter(p => p.platform === platform)
  if (keyword) {
    const q = keyword.toLowerCase()
    list = list.filter(p => p.name.includes(q) || p.shopName.toLowerCase().includes(q) || p.category.includes(q))
  }

  // 排序
  if (sortBy === 'popularityScore') {
    list.sort((a, b) => b.popularityScore - a.popularityScore)
  } else if (sortBy === 'growthRate') {
    list.sort((a, b) => b.growthRate - a.growthRate)
  } else if (sortBy === 'weeklySales') {
    list.sort((a, b) => b.weeklySales - a.weeklySales)
  } else if (sortBy === 'newest') {
    list.sort((a, b) => b.id - a.id)
  }

  const total = list.length
  const start = (page - 1) * pageSize
  return {
    items: list.slice(start, start + pageSize),
    total,
    page,
    pageSize
  }
}

// ======================================================================
//  8.7. 蓝海品类数据
// ======================================================================

/** 蓝海品类图标 */
const blueOceanIcons = {
  '智能家居': '🏠', '环保用品': '🌿', '健康监测': '💊', '宠物智能': '🐾',
  '户外露营': '⛺', 'DIY手工': '🎨', '个护仪器': '💆', '教育玩具': '🧩',
  '车旅用品': '🚗', '银发经济': '👴', '冥想放松': '🧘', '微型园艺': '🪴'
}

/** 生成蓝海趋势数据（上升趋势） */
function generateBlueOceanTrend(base, days = 7) {
  const data = []
  let v = base - 8
  for (let i = 0; i < days; i++) {
    v = v + (Math.random() * 4 + 1)  // 持续上升
    v = Math.min(100, Math.max(base - 8, v))
    data.push(Math.round(v))
  }
  return data
}

export const mockBlueOceanData = [
  {
    id: 1,
    category: '微型园艺',
    icon: '🪴',
    blueOceanIndex: 95,
    competitionLevel: '低',
    competitionScore: 18,
    demandGrowth: 32.5,
    marketSize: 680,
    targetMarkets: ['印尼', '泰国', '越南'],
    entryMethod: '短视频教学种草 + 种子套装 + 订阅制每月新植物',
    trend7d: generateBlueOceanTrend(88, 7),
    trend30d: generateBlueOceanTrend(70, 30),
    relatedProducts: ['桌面盆栽套装', '智能花盆', '多肉植物礼盒', '苔藓微景观', '植物生长灯'],
    reason: 'Z世代办公桌文化兴起，迷你绿植需求爆发，目前供应链分散缺乏品牌'
  },
  {
    id: 2,
    category: '健康监测',
    icon: '💊',
    blueOceanIndex: 92,
    competitionLevel: '低',
    competitionScore: 22,
    demandGrowth: 28.8,
    marketSize: 1200,
    targetMarkets: ['美国', '英国', '德国'],
    entryMethod: 'FDA/CE认证 + 健康博主合作 + 订阅制数据服务',
    trend7d: generateBlueOceanTrend(85, 7),
    trend30d: generateBlueOceanTrend(68, 30),
    relatedProducts: ['智能血压计', '血糖监测仪', '睡眠追踪手环', '血氧仪', '心电图贴片'],
    reason: '后疫情时代居家健康意识增强，可穿戴+家用医疗设备组合赛道空白'
  },
  {
    id: 3,
    category: '宠物智能',
    icon: '🐾',
    blueOceanIndex: 90,
    competitionLevel: '低',
    competitionScore: 25,
    demandGrowth: 27.2,
    marketSize: 950,
    targetMarkets: ['美国', '英国', '韩国'],
    entryMethod: '众筹平台首发 + 宠物博主测评 + 订阅制耗材模式',
    trend7d: generateBlueOceanTrend(82, 7),
    trend30d: generateBlueOceanTrend(65, 30),
    relatedProducts: ['智能喂食器', '宠物GPS追踪器', '自动猫砂盆', '宠物饮水机', '宠物摄像头'],
    reason: '宠物人性化趋势加速，智能硬件渗透率不足10%，增长空间巨大'
  },
  {
    id: 4,
    category: '户外露营',
    icon: '⛺',
    blueOceanIndex: 88,
    competitionLevel: '低',
    competitionScore: 28,
    demandGrowth: 25.6,
    marketSize: 1500,
    targetMarkets: ['美国', '加拿大', '澳大利亚'],
    entryMethod: '轻量化差异化 + 户外KOL测评 + 内容营销',
    trend7d: generateBlueOceanTrend(78, 7),
    trend30d: generateBlueOceanTrend(60, 30),
    relatedProducts: ['超轻帐篷', '折叠桌椅', '便携炉具', '户外电源', '露营灯具'],
    reason: '城市人逃离压力需求强烈，轻奢露营(Glamping)品类高端化空间大'
  },
  {
    id: 5,
    category: '个护仪器',
    icon: '💆',
    blueOceanIndex: 86,
    competitionLevel: '低',
    competitionScore: 30,
    demandGrowth: 24.3,
    marketSize: 1800,
    targetMarkets: ['美国', '法国', '日本'],
    entryMethod: '社交媒体种草 + 美容院渠道 + 明星推荐',
    trend7d: generateBlueOceanTrend(75, 7),
    trend30d: generateBlueOceanTrend(58, 30),
    relatedProducts: ['LED面膜仪', '射频美容仪', '脱毛仪', '洁面仪', '头皮按摩仪'],
    reason: '居家美容从可选变为刚需，专业级家用仪器价格带下探打开大众市场'
  },
  {
    id: 6,
    category: '环保用品',
    icon: '🌿',
    blueOceanIndex: 84,
    competitionLevel: '中',
    competitionScore: 35,
    demandGrowth: 22.8,
    marketSize: 2100,
    targetMarkets: ['德国', '英国', '法国'],
    entryMethod: '环保认证 + 零废弃理念 + B2B企业礼品渠道',
    trend7d: generateBlueOceanTrend(72, 7),
    trend30d: generateBlueOceanTrend(55, 30),
    relatedProducts: ['可降解餐具', '蜂蜡保鲜布', '竹纤维牙刷', '固体洗发皂', '环保购物袋'],
    reason: '欧洲环保法规趋严，一次性塑料替代品订单量激增，供应链缺口明显'
  },
  {
    id: 7,
    category: 'DIY手工',
    icon: '🎨',
    blueOceanIndex: 82,
    competitionLevel: '低',
    competitionScore: 24,
    demandGrowth: 26.4,
    marketSize: 720,
    targetMarkets: ['美国', '英国', '日本'],
    entryMethod: '视频教程带货 + 材料包订阅 + 社区运营',
    trend7d: generateBlueOceanTrend(70, 7),
    trend30d: generateBlueOceanTrend(52, 30),
    relatedProducts: ['香薰蜡烛DIY套装', '羊毛毡材料包', '手工皂套件', '编织工具包', '数字油画'],
    reason: '居家时间增加催生手工经济，材料包+教学视频模式复购率极高'
  },
  {
    id: 8,
    category: '教育玩具',
    icon: '🧩',
    blueOceanIndex: 80,
    competitionLevel: '中',
    competitionScore: 38,
    demandGrowth: 21.5,
    marketSize: 1600,
    targetMarkets: ['美国', '英国', '新加坡'],
    entryMethod: '教育机构合作 + STEAM认证 + 家长社区运营',
    trend7d: generateBlueOceanTrend(67, 7),
    trend30d: generateBlueOceanTrend(50, 30),
    relatedProducts: ['编程机器人', '科学实验套装', 'AR地球仪', '拼图玩具', '磁力积木'],
    reason: '家长对STEAM教育投入增加，中国玩具品牌性价比优势明显'
  },
  {
    id: 9,
    category: '冥想放松',
    icon: '🧘',
    blueOceanIndex: 78,
    competitionLevel: '低',
    competitionScore: 20,
    demandGrowth: 29.2,
    marketSize: 580,
    targetMarkets: ['美国', '澳大利亚', '英国'],
    entryMethod: 'App联动硬件 + 瑜伽/冥想社区 + 企业福利渠道',
    trend7d: generateBlueOceanTrend(64, 7),
    trend30d: generateBlueOceanTrend(48, 30),
    relatedProducts: ['冥想坐垫', '白噪音机', '香薰机', '重力毯', '瑜伽辅助工具'],
    reason: '全球心理健康关注度上升，冥想类产品从利基走向主流，市场供给不足'
  },
  {
    id: 10,
    category: '银发经济',
    icon: '👴',
    blueOceanIndex: 76,
    competitionLevel: '低',
    competitionScore: 15,
    demandGrowth: 30.8,
    marketSize: 2500,
    targetMarkets: ['日本', '德国', '美国'],
    entryMethod: '老龄化产品认证 + 养老机构渠道 + 子女礼品营销',
    trend7d: generateBlueOceanTrend(60, 7),
    trend30d: generateBlueOceanTrend(45, 30),
    relatedProducts: ['大字手机', '防滑扶手', '助行器', '智能药盒', '老人定位手表'],
    reason: '全球老龄化加速，适老化消费品类极度稀缺，几乎无品牌竞争'
  },
  {
    id: 11,
    category: '车旅用品',
    icon: '🚗',
    blueOceanIndex: 74,
    competitionLevel: '中',
    competitionScore: 40,
    demandGrowth: 20.2,
    marketSize: 3200,
    targetMarkets: ['美国', '巴西', '墨西哥'],
    entryMethod: '汽车社群种草 + Amazon车品分类 + 短视频展示装车效果',
    trend7d: generateBlueOceanTrend(56, 7),
    trend30d: generateBlueOceanTrend(42, 30),
    relatedProducts: ['车载冰箱', '汽车收纳架', '座垫套', '汽车遮阳帘', '车内氛围灯'],
    reason: '汽车后市场庞大，中国供应链优势明显，精细化车品品类品牌化机会大'
  },
  {
    id: 12,
    category: '智能家居',
    icon: '🏠',
    blueOceanIndex: 72,
    competitionLevel: '中',
    competitionScore: 42,
    demandGrowth: 18.9,
    marketSize: 3800,
    targetMarkets: ['美国', '德国', '阿联酋'],
    entryMethod: 'Matter协议兼容 + 智能音箱生态 + 安装服务打包',
    trend7d: generateBlueOceanTrend(52, 7),
    trend30d: generateBlueOceanTrend(40, 30),
    relatedProducts: ['智能插座', '门窗传感器', '智能灯泡', '温控器', '智能门铃'],
    reason: 'Matter协议统一后中小品牌机会大增，安装简单化是关键突破口'
  }
]

/** 获取蓝海品类列表（支持多维度排序） */
export function getBlueOceanData({ sortBy = 'blueOceanIndex', market = '' } = {}) {
  let list = [...mockBlueOceanData]

  // 市场筛选
  if (market) {
    list = list.filter(item => item.targetMarkets.includes(market))
  }

  // 排序
  if (sortBy === 'blueOceanIndex') {
    list.sort((a, b) => b.blueOceanIndex - a.blueOceanIndex)
  } else if (sortBy === 'demandGrowth') {
    list.sort((a, b) => b.demandGrowth - a.demandGrowth)
  } else if (sortBy === 'marketSize') {
    list.sort((a, b) => b.marketSize - a.marketSize)
  } else if (sortBy === 'competition') {
    list.sort((a, b) => a.competitionScore - b.competitionScore)
  }

  return list
}

// ======================================================================
//  8.8. 跨平台对比数据 (TikTok Shop / Shopify / Amazon)
// ======================================================================

/** 生成跨平台趋势数据 */
function generatePlatformTrend(base, days, variance = 100) {
  const data = []
  let v = base
  for (let i = 0; i < days; i++) {
    v = v + (Math.random() - 0.45) * variance  // slight upward bias
    v = Math.max(base * 0.8, Math.min(base * 1.3, v))
    data.push(Math.round(v))
  }
  return data
}

export const mockCrossPlatformData = {
  platforms: [
    {
      id: 'tiktok',
      name: 'TikTok Shop',
      icon: '🎵',
      color: '#FF004F',
      gradient: 'linear-gradient(135deg, #1A1A2E 0%, #16213E 100%)',
      tagline: '内容电商 · 短视频+直播',
      metrics: {
        hotProducts: 12500,
        avgPrice: 18.5,
        totalSales: 8500,
        growthRate: 35.2,
        conversionRate: 4.8,
        activeShops: 89000
      },
      topCategories: ['服装', '美妆', '食品饮料'],
      categorySales: {
        '服装': 3200, '美妆': 2800, '食品饮料': 1200,
        '家居': 500, '3C数码': 800, '运动户外': 350,
        '珠宝饰品': 280, '母婴': 200, '宠物': 180, '个护': 1090
      },
      advantageTags: ['内容驱动自然流量', '年轻用户群体(18-34)', '冲动消费转化高', '直播带货生态成熟'],
      weaknessTags: ['客单价偏低($15-30为主)', '售后退货率较高'],
      trend30d: generatePlatformTrend(2200, 30, 120),
      trend7d: generatePlatformTrend(2800, 7, 80),
      bestFor: ['快消品/冲动消费品', '美妆个护', '低价爆款($5-30)', '新奇特产品']
    },
    {
      id: 'shopify',
      name: 'Shopify',
      icon: '🛒',
      color: '#96BF48',
      gradient: 'linear-gradient(135deg, #1B3A1B 0%, #2D5A2D 100%)',
      tagline: '独立站电商 · 品牌化运营',
      metrics: {
        hotProducts: 8200,
        avgPrice: 42.8,
        totalSales: 12000,
        growthRate: 22.6,
        conversionRate: 3.2,
        activeShops: 42000
      },
      topCategories: ['家居', '服装', '运动户外'],
      categorySales: {
        '家居': 3800, '服装': 3200, '运动户外': 2100,
        '3C数码': 1200, '珠宝饰品': 800, '美妆': 500,
        '母婴': 350, '宠物': 300, '食品饮料': 150, '个护': 600
      },
      advantageTags: ['用户数据完全自有', '品牌溢价空间大', '复购和LTV高于平台', '营销工具灵活丰富'],
      weaknessTags: ['需要自建流量', '运营门槛较高'],
      trend30d: generatePlatformTrend(3200, 30, 150),
      trend7d: generatePlatformTrend(3800, 7, 100),
      bestFor: ['品牌化商品', '中高客单价($30-100)', '差异化/定制产品', 'DTC品牌']
    },
    {
      id: 'amazon',
      name: 'Amazon',
      icon: '📦',
      color: '#FF9900',
      gradient: 'linear-gradient(135deg, #1A2332 0%, #232F3E 100%)',
      tagline: '综合电商 · FBA物流体系',
      metrics: {
        hotProducts: 18500,
        avgPrice: 28.2,
        totalSales: 35000,
        growthRate: 15.8,
        conversionRate: 5.6,
        activeShops: 150000
      },
      topCategories: ['3C数码', '家居', '运动户外'],
      categorySales: {
        '3C数码': 8500, '家居': 7200, '运动户外': 5800,
        '服装': 4500, '美妆': 3200, '食品饮料': 2100,
        '珠宝饰品': 1500, '母婴': 2500, '宠物': 2000, '个护': 1700
      },
      advantageTags: ['Prime会员巨大流量池', 'FBA物流体验极佳', '用户信任度高', '转化率领先'],
      weaknessTags: ['竞争激烈/价格战', '平台规则严格'],
      trend30d: generatePlatformTrend(8500, 30, 300),
      trend7d: generatePlatformTrend(9200, 7, 200),
      bestFor: ['标品/刚需品', '有供应链优势', '高评分/口碑产品', 'FBA适合的产品']
    }
  ],

  /** 跨平台选品建议 */
  recommendations: [
    {
      id: 1,
      category: '美妆个护',
      icon: '💄',
      recommendedPlatform: 'TikTok Shop',
      platforms: ['tiktok', 'amazon'],
      reason: 'TikTok视频展示效果最佳，冲动消费转化高；Amazon作为补充渠道铺货',
      priceRange: '$8-35',
      competitionLevel: '中',
      expectedRoi: '3.2-5.0x'
    },
    {
      id: 2,
      category: '家居好物',
      icon: '🏠',
      recommendedPlatform: 'Shopify',
      platforms: ['shopify', 'amazon'],
      reason: '高客单价适合独立站品牌化运营，复购率高；Amazon FBA保证物流体验',
      priceRange: '$25-80',
      competitionLevel: '中高',
      expectedRoi: '2.5-3.8x'
    },
    {
      id: 3,
      category: '3C配件',
      icon: '📱',
      recommendedPlatform: 'Amazon',
      platforms: ['amazon'],
      reason: 'Amazon用户搜索习惯成熟，3C品类自然流量大，竞品对标清晰',
      priceRange: '$10-50',
      competitionLevel: '高',
      expectedRoi: '2.0-3.2x'
    },
    {
      id: 4,
      category: '服装配饰',
      icon: '👗',
      recommendedPlatform: 'TikTok Shop',
      platforms: ['tiktok', 'shopify'],
      reason: '穿搭内容天然适合TikTok展示，爆款逻辑清晰；独立站沉淀品牌粉丝',
      priceRange: '$12-45',
      competitionLevel: '中',
      expectedRoi: '3.0-4.5x'
    },
    {
      id: 5,
      category: '运动户外',
      icon: '⚽',
      recommendedPlatform: 'Amazon',
      platforms: ['amazon', 'shopify'],
      reason: 'Amazon户外品类搜索量大，品牌化后引流独立站做高客单价产品',
      priceRange: '$20-100',
      competitionLevel: '中',
      expectedRoi: '2.8-4.0x'
    },
    {
      id: 6,
      category: '宠物用品',
      icon: '🐾',
      recommendedPlatform: 'TikTok Shop',
      platforms: ['tiktok', 'amazon'],
      reason: '萌宠内容在TikTok天然爆款体质，宠物用品冲动消费强；Amazon覆盖搜索用户',
      priceRange: '$8-30',
      competitionLevel: '低',
      expectedRoi: '3.5-5.5x'
    },
    {
      id: 7,
      category: '珠宝饰品',
      icon: '💎',
      recommendedPlatform: 'Shopify',
      platforms: ['shopify'],
      reason: '高溢价品类适合独立站品牌化，DTC模式最大化利润空间',
      priceRange: '$15-60',
      competitionLevel: '中',
      expectedRoi: '3.0-5.0x'
    },
    {
      id: 8,
      category: '母婴用品',
      icon: '👶',
      recommendedPlatform: 'Amazon',
      platforms: ['amazon', 'shopify'],
      reason: '母婴用户信任优先，Amazon评论体系建立信用，独立站做订阅复购',
      priceRange: '$15-80',
      competitionLevel: '中高',
      expectedRoi: '2.5-3.5x'
    }
  ]
}

/** 获取跨平台对比数据（支持品类筛选） */
export function getCrossPlatformData({ category = '' } = {}) {
  let data = { ...mockCrossPlatformData, platforms: mockCrossPlatformData.platforms.map(p => ({ ...p })) }

  if (category) {
    // 筛选品类，调整指标
    data.platforms = data.platforms.map(p => {
      const catSales = p.categorySales[category] || 0
      const totalFromTop = Object.values(p.categorySales).reduce((s, v) => s + v, 0)

      return {
        ...p,
        metrics: {
          ...p.metrics,
          hotProducts: Math.round(p.metrics.hotProducts * (catSales / totalFromTop || 0.1)),
          avgPrice: p.metrics.avgPrice * (Math.random() * 0.3 + 0.85),
          totalSales: Math.round(catSales),
          growthRate: Math.round((p.metrics.growthRate * (Math.random() * 0.4 + 0.8)) * 10) / 10
        }
      }
    })

    // 调整建议列表
    data.recommendations = data.recommendations.filter(r =>
      r.category === category || r.category.includes(category)
    )
    if (data.recommendations.length === 0) {
      data.recommendations = [{
        id: 99, category, icon: '📦',
        recommendedPlatform: '多平台测试',
        platforms: ['tiktok', 'shopify', 'amazon'],
        reason: `该品类建议在三个平台同时测品，根据数据反馈确定主力平台`,
        priceRange: '视品类',
        competitionLevel: '未知',
        expectedRoi: '待测试'
      }]
    }
  }

  return data
}

// ======================================================================
//  8.10. 趋势追踪数据
// ======================================================================

/** 政策与合规动态 */
const mockTrendPolicyNews = [
  {
    id: 1,
    country: '欧盟',
    title: 'EPR 包装法扩展：2026 年 Q3 起新增纺织品和家具品类强制合规',
    date: '2026-06-15',
    urgency: 'high',
    category: '环保合规',
    description: '欧盟《生产者延伸责任》(EPR) 法规进一步扩展，自 2026 年 Q3 起，纺织品和家具品类将被纳入强制合规范围。跨境卖家需提前注册 EPR 编号，否则面临下架风险。'
  },
  {
    id: 2,
    country: '美国',
    title: 'TikTok Shop 美国站调整佣金费率：美妆品类涨至 8%',
    date: '2026-06-12',
    urgency: 'high',
    category: '平台政策',
    description: 'TikTok Shop 美国站宣布自 2026 年 7 月 1 日起调整平台佣金费率。美妆个护品类从 5% 上调至 8%，服装品类保持 5% 不变，3C 数码从 4% 上调至 6%。'
  },
  {
    id: 3,
    country: '印尼',
    title: '印尼海关新规：进口商品最低免税额降至 $3',
    date: '2026-06-10',
    urgency: 'high',
    category: '海关税务',
    description: '印尼海关总署发布新规，将跨境进口商品最低免税额从 $75 降至 $3，几乎覆盖所有跨境电商包裹。卖家需重新核算成本结构。'
  },
  {
    id: 4,
    country: '英国',
    title: 'UKCA 认证过渡期延长至 2027 年，CE 标志继续有效',
    date: '2026-06-08',
    urgency: 'medium',
    category: '产品认证',
    description: '英国政府宣布 UKCA 认证过渡期延长至 2027 年底。在此期间，CE 标志在英国市场继续有效。利好跨境卖家降低双重认证成本。'
  },
  {
    id: 5,
    country: '巴西',
    title: '巴西税务改革：跨境电商平台需代扣代缴 ICMS 税',
    date: '2026-06-05',
    urgency: 'medium',
    category: '税务政策',
    description: '巴西各州统一实施跨境电商 ICMS 税（州增值税）代扣代缴制度，税率统一为 17%。平台方将自动计算并代扣税款。'
  },
  {
    id: 6,
    country: '东南亚',
    title: '东南亚多国推进电商税收协调，2027 年或出台统一税率框架',
    date: '2026-06-01',
    urgency: 'medium',
    category: '区域政策',
    description: '东盟电商工作组会议提出 2027 年建立区域统一跨境电商税率框架，拟将税率统一在 5%-10% 区间。目前处于征求意见阶段。'
  },
  {
    id: 7,
    country: '德国',
    title: '德国《供应链尽职调查法》修订：新增电商平台合规要求',
    date: '2026-05-28',
    urgency: 'low',
    category: '合规法规',
    description: '德国修订《供应链尽职调查法》，电商平台需对年营收超 €5000 万的卖家进行供应链尽职调查，预计 2027 年 1 月生效。'
  },
  {
    id: 8,
    country: '日本',
    title: '日本修订药事法：跨境保健品进口备案流程简化',
    date: '2026-05-25',
    urgency: 'low',
    category: '法规更新',
    description: '日本厚生劳动省修订药事法实施细则，简化跨境电商保健品进口备案流程。新规将审批时间从 60 天缩短至 30 天。'
  },
  {
    id: 9,
    country: '阿联酋',
    title: '阿联酋推出跨境电商 VAT 快速退税通道',
    date: '2026-05-20',
    urgency: 'low',
    category: '税务政策',
    description: '阿联酋联邦税务局推出跨境电商 VAT 快速退税通道，符合条件的企业可在 7 个工作日内完成退税。年销售额超 AED 375,000 需注册 VAT。'
  },
  {
    id: 10,
    country: '韩国',
    title: '韩国 KC 安全认证范围扩大至智能家居品类',
    date: '2026-05-18',
    urgency: 'low',
    category: '产品认证',
    description: '韩国技术标准院(KATS)将 KC 安全认证范围扩大至智能家居设备（智能插座、摄像头等）。2026 年 9 月起未认证产品将禁止销售。'
  }
]

/** 将 7 天趋势数据扩展为 30 天 */
function extendCategoryTrendsTo30d() {
  const original = mockCategoryTrends
  const categoryKeys = ['clothing', 'beauty', 'digital3c', 'home', 'sports', 'food', 'jewelry', 'baby', 'pet', 'personalCare']

  // 基于现有 7 天趋势生成 30 天数据
  const result = []
  for (let day = 1; day <= 30; day++) {
    const idx = (day - 1) % 7 // 循环使用 7 天模式
    const base = { day }
    categoryKeys.forEach(key => {
      const originalValue = original[idx][key]
      // 添加轻微随机波动
      const noise = (Math.random() - 0.5) * 6
      base[key] = Math.round(Math.max(40, Math.min(95, originalValue + noise)))
    })
    result.push(base)
  }
  return result
}

/** 获取趋势追踪所有数据 */
export function getTrendData() {
  return {
    keywords: mockHotKeywords,
    topics: mockHotTopics,
    categoryTrends: extendCategoryTrendsTo30d(),
    policyNews: mockTrendPolicyNews
  }
}

// ======================================================================
//  8.11. 出海智库数据
// ======================================================================

export const mockKnowledgeArticles = [
  // ---- 出海百科 ----
  {
    id: 1,
    title: '2026 跨境电商新手入门完全指南',
    category: 'encyclopedia',
    categoryName: '出海百科',
    summary: '从0到1的跨境出海全流程解析，覆盖选品、建站、物流、支付、营销五大核心环节。',
    fullContent: `<h3>一、市场选择</h3><p>新手建议优先考虑东南亚市场（印尼、泰国、越南），因为文化相近、TikTok渗透率高、物流成本可控。预算充足也可布局美国市场。</p><h3>二、选品策略</h3><p>选品三要素：视频友好型（15秒展示卖点）、价格$15-$50冲动消费品、轻小件物流可控。推荐利用TikTok Creative Center和Google Trends进行趋势验证。</p><h3>三、建站与平台</h3><p>TikTok Shop适合快速测品和起量，转化路径短。Shopify独立站适合品牌沉淀和复购。建议组合打法：TikTok测品→独立站承接复购。</p><h3>四、物流方案</h3><p>小包直邮适合$0-$15产品（云途、燕文），海外仓适合$15以上产品（谷仓、万邑通），FBA适合亚马逊卖家。</p>`,
    coverImage: 'https://picsum.photos/seed/kb-guide/600/340',
    readCount: 15200,
    updatedAt: '2026-06-15',
    tags: ['入门指南', '选品', '全流程'],
    relatedArticles: [4, 5, 10]
  },
  {
    id: 2,
    title: '跨境物流全链路深度解析',
    category: 'encyclopedia',
    categoryName: '出海百科',
    summary: '国际物流四大模式对比：小包直邮、海外仓、FBA、专线物流，帮你找到最优方案。',
    fullContent: `<h3>小包直邮</h3><p>适合$0-$15低价产品，时效7-15天。推荐云途、燕文等专线小包，成本低但时效不稳定。</p><h3>海外仓一件代发</h3><p>适合$15以上产品，时效2-5天。推荐谷仓、万邑通等第三方海外仓，显著提升转化率。</p><h3>FBA（亚马逊物流）</h3><p>亚马逊官方仓储配送，Prime会员免运费，转化率最高。但仓储费较高，适合动销快的产品。</p><h3>专线物流</h3><p>针对特定国家/区域的优化线路，时效和成本平衡。如中美专线、中欧铁路等。</p>`,
    coverImage: 'https://picsum.photos/seed/kb-logistics/600/340',
    readCount: 9800,
    updatedAt: '2026-06-12',
    tags: ['物流', '海外仓', 'FBA'],
    relatedArticles: [1, 8, 12]
  },
  {
    id: 3,
    title: '跨境电商支付与税务合规手册',
    category: 'encyclopedia',
    categoryName: '出海百科',
    summary: '多币种收款工具对比、VAT税务筹划、各国关税政策一览。',
    fullContent: `<h3>收款工具</h3><p>推荐PingPong（0.5%费率）、连连支付（0.7%）、Payoneer（1%+）。大额回款建议锁定汇率。</p><h3>VAT税务</h3><p>欧盟国家需注册VAT（英国20%、德国19%）。注意EPR包装法、WEEE电子回收等环保合规要求。</p><h3>关税政策</h3><p>美国：$800以下免税（De Minimis）。欧盟：€150以下免关税但需缴VAT。印尼：$3以上即征税。</p>`,
    coverImage: 'https://picsum.photos/seed/kb-payment/600/340',
    readCount: 7600,
    updatedAt: '2026-06-08',
    tags: ['支付', '税务', '合规'],
    relatedArticles: [1, 6, 9]
  },
  // ---- 成功案例 ----
  {
    id: 4,
    title: '案例：国货美妆品牌 6 个月东南亚 GMV 破百万美金',
    category: 'case-study',
    categoryName: '成功案例',
    summary: '某国货美妆品牌通过TikTok内容种草+达人矩阵+独立站承接，实现爆发式增长的全链路复盘。',
    fullContent: `<h3>背景</h3><p>国内知名美妆品牌，2025年Q4启动东南亚出海，主攻印尼和越南市场。</p><h3>策略</h3><p>1. TikTok内容矩阵：每天发布5-8条本地化短视频。2. 达人合作：与50+中腰部达人合作种草。3. 独立站承接：引导复购用户到独立站。4. Spark Ads加热爆款视频。</p><h3>成果</h3><p>6个月累计GMV突破100万美金，独立站复购率35%，TikTok粉丝增长至50万+。</p><h3>关键启示</h3><p>本地化内容+达人矩阵是东南亚市场的核心增长引擎，独立站是利润和复购的关键。</p>`,
    coverImage: 'https://picsum.photos/seed/kb-beauty/600/340',
    readCount: 13200,
    updatedAt: '2026-06-14',
    tags: ['美妆', 'TikTok', '东南亚'],
    relatedArticles: [1, 7, 8]
  },
  {
    id: 5,
    title: '案例：3C 配件卖家从 Amazon 到 TikTok 的跨平台增长之路',
    category: 'case-study',
    categoryName: '成功案例',
    summary: '一家3C配件卖家如何利用Amazon积累的供应链优势，在TikTok Shop开辟第二增长曲线。',
    fullContent: `<h3>背景</h3><p>深圳3C配件卖家，Amazon年销售额$500万，2025年开始布局TikTok Shop。</p><h3>策略</h3><p>1. 产品线拆分为Amazon专供（高端）和TikTok定制（性价比）。2. 短视频展示产品使用场景。3. 邀请科技类达人测评。</p><h3>成果</h3><p>TikTok Shop上线3个月月销$20万，总ROAS 4.5x，成功降低对Amazon单一渠道依赖。</p>`,
    coverImage: 'https://picsum.photos/seed/kb-3c/600/340',
    readCount: 10800,
    updatedAt: '2026-06-10',
    tags: ['3C数码', '跨平台', 'Amazon'],
    relatedArticles: [2, 4, 10]
  },
  {
    id: 6,
    title: '案例：家居品牌 DTC 独立站从 0 到年销千万美金',
    category: 'case-study',
    categoryName: '成功案例',
    summary: '一个中国家居品牌如何通过Shopify独立站+社交媒体营销，在欧美市场建立DTC品牌。',
    fullContent: `<h3>背景</h3><p>佛山家居品牌，2024年初启动DTC出海，主攻美国和欧洲市场。</p><h3>策略</h3><p>1. 高颜值产品+场景化视觉内容。2. Instagram/Pinterest种草引流。3. 邮件营销+订阅制提升LTV。4. SEO长尾关键词覆盖。</p><h3>成果</h3><p>运营18个月年销突破$1000万，复购率42%，客单价$85，品牌搜索量增长300%。</p>`,
    coverImage: 'https://picsum.photos/seed/kb-home/600/340',
    readCount: 9500,
    updatedAt: '2026-06-05',
    tags: ['家居', 'DTC', '品牌化'],
    relatedArticles: [3, 9, 11]
  },
  // ---- 课程推荐 ----
  {
    id: 7,
    title: 'TikTok 广告投放从入门到精通',
    category: 'course',
    categoryName: '课程推荐',
    summary: '系统学习TikTok广告投放全流程：账户搭建、素材制作、受众定向、数据优化。',
    fullContent: `<h3>课程大纲</h3><p>第一章：TikTok广告生态与账户体系<br/>第二章：广告素材创意方法论<br/>第三章：受众定向与出价策略<br/>第四章：Spark Ads与信息流广告<br/>第五章：数据看板与ROI优化<br/>第六章：直播间引流与商品卡广告</p><h3>适合人群</h3><p>跨境电商运营、广告优化师、品牌营销负责人。有基础数字营销经验更佳。</p><h3>课程时长</h3><p>共12课时，每课时45分钟。提供实操练习和1v1答疑。</p>`,
    coverImage: 'https://picsum.photos/seed/kb-tiktok-ad/600/340',
    readCount: 18500,
    updatedAt: '2026-06-16',
    tags: ['TikTok广告', '投放', '课程'],
    relatedArticles: [4, 5, 8]
  },
  {
    id: 8,
    title: 'Shopify 独立站从建站到运营全能课',
    category: 'course',
    categoryName: '课程推荐',
    summary: '零基础搭建高转化Shopify独立站，覆盖主题定制、插件配置、SEO优化、邮件营销。',
    fullContent: `<h3>课程大纲</h3><p>第一章：Shopify店铺搭建与主题选择<br/>第二章：产品页面优化与A/B测试<br/>第三章：支付与物流集成<br/>第四章：SEO优化与内容营销<br/>第五章：邮件营销自动化<br/>第六章：数据分析与增长策略</p><h3>适合人群</h3><p>跨境电商创业者、独立站运营、品牌DTC转型企业。零基础可上手。</p>`,
    coverImage: 'https://picsum.photos/seed/kb-shopify/600/340',
    readCount: 14200,
    updatedAt: '2026-06-13',
    tags: ['Shopify', '建站', '运营'],
    relatedArticles: [1, 6, 11]
  },
  {
    id: 9,
    title: '跨境电商合规与知识产权保护',
    category: 'course',
    categoryName: '课程推荐',
    summary: '全面了解跨境合规红线：产品认证、知识产权、数据保护、税务合规。',
    fullContent: `<h3>课程大纲</h3><p>第一章：各国产品认证体系（CE/FDA/FCC/UKCA）<br/>第二章：知识产权保护与商标注册<br/>第三章：数据隐私与GDPR合规<br/>第四章：税务合规与转移定价<br/>第五章：环保法规（EPR/WEEE/REACH）<br/>第六章：应对投诉与法律纠纷</p><h3>适合人群</h3><p>法务、合规负责人、跨境电商运营、品牌经理。</p>`,
    coverImage: 'https://picsum.photos/seed/kb-compliance/600/340',
    readCount: 6800,
    updatedAt: '2026-06-01',
    tags: ['合规', '知识产权', '认证'],
    relatedArticles: [3, 6, 12]
  },
  // ---- 工具推荐 ----
  {
    id: 10,
    title: '2026 跨境电商必备工具清单 Top 20',
    category: 'tool',
    categoryName: '工具推荐',
    summary: '精选20款跨境电商运营必备工具，涵盖选品、数据分析、广告优化、翻译等。',
    fullContent: `<h3>选品工具</h3><p>· Jungle Scout — Amazon选品数据分析<br/>· PipiADS — TikTok广告素材库<br/>· 选品大师 — AI选品推荐</p><h3>数据分析</h3><p>· Google Trends — 趋势验证<br/>· SimilarWeb — 竞品流量分析<br/>· 跨境数据雷达 — 多平台数据聚合</p><h3>广告优化</h3><p>· OceanAds — 多平台广告代投<br/>· AdSpy — 广告素材库</p><h3>翻译本地化</h3><p>· DeepL — 高质量翻译<br/>· Weglot — 网站多语言</p>`,
    coverImage: 'https://picsum.photos/seed/kb-tools/600/340',
    readCount: 16800,
    updatedAt: '2026-06-17',
    tags: ['工具', '效率', '推荐'],
    relatedArticles: [1, 5, 7]
  },
  {
    id: 11,
    title: 'AI 赋能跨境电商：从内容到运营的全场景应用',
    category: 'tool',
    categoryName: '工具推荐',
    summary: '探索AI在跨境电商中的前沿应用：AI视频生成、智能客服、自动化运营。',
    fullContent: `<h3>AI内容创作</h3><p>· Seedance/Sora — AI视频生成<br/>· Midjourney — AI商品图生成<br/>· Claude/ChatGPT — 文案撰写与翻译</p><h3>AI运营</h3><p>· 智能客服机器人 — 24/7多语言客服<br/>· AI选品引擎 — 自动化选品推荐<br/>· 智能定价工具 — 竞品价格追踪与自动调价</p><h3>AI营销</h3><p>· 智能广告优化 — 自动出价与素材测试<br/>· 个性化推荐 — 千人千面商品推荐</p>`,
    coverImage: 'https://picsum.photos/seed/kb-ai/600/340',
    readCount: 12300,
    updatedAt: '2026-06-16',
    tags: ['AI', '自动化', '效率'],
    relatedArticles: [7, 8, 10]
  },
  {
    id: 12,
    title: '跨境运营必备的免费工具资源',
    category: 'tool',
    categoryName: '工具推荐',
    summary: '预算有限的初创团队也能用的免费/开源工具，从建站到营销全覆盖。',
    fullContent: `<h3>建站</h3><p>· WooCommerce — 免费开源电商插件<br/>· Carrd — 免费单页网站</p><h3>设计</h3><p>· Canva — 免费设计工具<br/>· Remove.bg — 免费去背景</p><h3>营销</h3><p>· Mailchimp — 免费邮件营销（<2000订阅者）<br/>· Buffer — 社交媒体排期</p><h3>数据分析</h3><p>· Google Analytics — 免费网站分析<br/>· Google Search Console — SEO工具</p>`,
    coverImage: 'https://picsum.photos/seed/kb-free/600/340',
    readCount: 8900,
    updatedAt: '2026-06-09',
    tags: ['免费', '工具', '初创'],
    relatedArticles: [10, 2, 8]
  }
]

/** 获取智库文章列表（支持分类筛选 + 搜索） */
export function getKnowledgeData({ category = '', keyword = '' } = {}) {
  let list = [...mockKnowledgeArticles]
  if (category) list = list.filter(a => a.category === category)
  if (keyword) {
    const q = keyword.toLowerCase()
    list = list.filter(a =>
      a.title.toLowerCase().includes(q) ||
      a.summary.includes(q) ||
      a.tags.some(t => t.includes(q))
    )
  }
  return list
}

/** 根据ID获取单篇文章 */
export function getKnowledgeArticleById(id) {
  return mockKnowledgeArticles.find(a => a.id === id) || null
}

/** 获取相关推荐文章 */
export function getRelatedKnowledgeArticles(ids) {
  if (!ids || !ids.length) return []
  return ids.map(id => mockKnowledgeArticles.find(a => a.id === id)).filter(Boolean)
}

import request from '@/utils/request'

/**
 * 发送消息给 AI 助手
 * - 后端配置了大模型 → 调用大模型（智能回答）
 * - 后端未配置 → 走 FAQ 匹配（规则回答）
 * - 请求失败 → 前端降级到本地 FAQ 匹配
 */
export async function chatWithAI(question, history = []) {
  try {
    const res = await request.post('/v1/ai-assistant/chat', { question, history })
    return res.data || res
  } catch (err) {
    // 降级：本地 FAQ 匹配
    console.warn('[AI助手] 后端不可用，使用本地 FAQ 降级')
    const matched = matchLocalFAQ(question)
    return {
      answer: matched ? matched.answer : '抱歉，AI 助手暂时不可用。请稍后重试或联系客服。',
      source: 'faq',
      related_questions: mockQA.slice(0, 3).map(q => q.question)
    }
  }
}

/** 获取引导问题（优先后端） */
export async function getAISuggestions() {
  try {
    const res = await request.get('/v1/ai-assistant/suggestions')
    return res.data?.questions || mockQA.slice(0, 6).map(q => ({ id: q.id, question: q.question, category: q.category }))
  } catch {
    return mockQA.slice(0, 6).map(q => ({ id: q.id, question: q.question, category: q.category }))
  }
}

/**
 * 本地 FAQ 匹配（降级用）
 * - 完全匹配 → 100 分
 * - 包含匹配 → 80 分
 * - 关键词重合 → 加权计算
 */
function matchLocalFAQ(question) {
  const q = question.toLowerCase()
  let best = null
  let bestScore = 0

  for (const faq of mockQA) {
    let score = 0
    const fq = faq.question.toLowerCase()
    if (q === fq) { score = 100 }
    else if (fq.includes(q) || q.includes(fq.slice(0, 6))) { score = 80 }
    else {
      const words = fq.match(/[\u4e00-\u9fff\w]+/g) || []
      const matched = words.filter(w => q.includes(w)).length
      score = words.length ? (matched / words.length) * 60 : 0
    }
    if (score > bestScore && score >= 30) { bestScore = score; best = faq }
  }
  return best
}
