/**
 * 模板库 - 伪数据（纯前端模块，不请求后端）
 */

export const mockTemplates = [
  // ========== 时尚 (fashion) ==========
  {
    id: 1, name: '轻奢风尚', category: 'fashion', categoryLabel: '时尚',
    description: '专为时尚服装品牌打造，极简大气展示',
    previewImage: 'https://picsum.photos/seed/fashion1/300/200',
    price: '免费', isFree: true, usageCount: 12860,
    tags: ['响应式', 'SEO优化', '多语言'],
    features: ['商品筛选', '尺码指南', 'Lookbook展示', '限时促销弹窗'],
    popularity: 95
  },
  {
    id: 2, name: '潮流街拍', category: 'fashion', categoryLabel: '时尚',
    description: '适合时尚博主与潮牌店铺，支持视频封面',
    previewImage: 'https://picsum.photos/seed/fashion2/300/200',
    price: '¥299', isFree: false, usageCount: 6890,
    tags: ['视频背景', '社交分享'],
    features: ['视频轮播', 'Instagram同步', '穿搭方案推荐'],
    popularity: 82
  },
  {
    id: 3, name: '珠宝闪耀', category: 'fashion', categoryLabel: '时尚',
    description: '珠宝饰品品牌专用，突出产品光泽与细节',
    previewImage: 'https://picsum.photos/seed/fashion3/300/200',
    price: '免费', isFree: true, usageCount: 4520,
    tags: ['高清大图', '响应式'],
    features: ['360°展示', '放大镜效果', '礼物推荐'],
    popularity: 71
  },

  // ========== 科技 (tech) ==========
  {
    id: 4, name: '科技极简', category: 'tech', categoryLabel: '科技',
    description: '数码3C产品专用，深色主题，科技感十足',
    previewImage: 'https://picsum.photos/seed/tech1/300/200',
    price: '免费', isFree: true, usageCount: 23450,
    tags: ['深色模式', '响应式'],
    features: ['参数对比', '快速下单', '评测展示', '库存状态'],
    popularity: 98
  },
  {
    id: 5, name: '智能生活', category: 'tech', categoryLabel: '科技',
    description: '智能家居 & IoT 产品展示，清新蓝白风格',
    previewImage: 'https://picsum.photos/seed/tech2/300/200',
    price: '¥499', isFree: false, usageCount: 3210,
    tags: ['SEO优化', '多语言', '快速加载'],
    features: ['场景化展示', '安装指引', 'App下载引导'],
    popularity: 63
  },
  {
    id: 6, name: '电竞风暴', category: 'tech', categoryLabel: '科技',
    description: '游戏外设与电竞装备店铺模板，酷炫动态效果',
    previewImage: 'https://picsum.photos/seed/tech3/300/200',
    price: '¥399', isFree: false, usageCount: 1870,
    tags: ['动画效果', '深色模式'],
    features: ['赛事日历', '战队展示', '预售功能'],
    popularity: 55
  },

  // ========== 家居 (home) ==========
  {
    id: 7, name: '北欧慢生活', category: 'home', categoryLabel: '家居',
    description: '家居生活品牌，温暖柔和的原木色调',
    previewImage: 'https://picsum.photos/seed/home1/300/200',
    price: '免费', isFree: true, usageCount: 10980,
    tags: ['响应式', 'SEO优化'],
    features: ['场景搭配', 'AR预览', '家装日记'],
    popularity: 88
  },
  {
    id: 8, name: '轻奢家居', category: 'home', categoryLabel: '家居',
    description: '高端家居品牌专属，大理石纹理搭配金色点缀',
    previewImage: 'https://picsum.photos/seed/home2/300/200',
    price: '¥599', isFree: false, usageCount: 4560,
    tags: ['响应式', '多语言', '高清大图'],
    features: ['定制服务', '案例展示', '设计师推荐'],
    popularity: 74
  },
  {
    id: 9, name: '日式简约', category: 'home', categoryLabel: '家居',
    description: '日式风格家居店铺，纯白搭配原木色',
    previewImage: 'https://picsum.photos/seed/home3/300/200',
    price: '免费', isFree: true, usageCount: 7340,
    tags: ['快速加载', 'SEO优化'],
    features: ['分类导航', '搭配推荐', '尺寸助手'],
    popularity: 79
  },

  // ========== 食品餐饮 (food) ==========
  {
    id: 10, name: '鲜食日记', category: 'food', categoryLabel: '食品餐饮',
    description: '生鲜食品与有机农场店铺，自然绿色调',
    previewImage: 'https://picsum.photos/seed/food1/300/200',
    price: '免费', isFree: true, usageCount: 8920,
    tags: ['响应式', '快速加载'],
    features: ['产地溯源', '营养展示', '食谱推荐', '周期购'],
    popularity: 85
  },
  {
    id: 11, name: '咖啡时光', category: 'food', categoryLabel: '食品餐饮',
    description: '咖啡与烘焙品牌，复古暖色调',
    previewImage: 'https://picsum.photos/seed/food2/300/200',
    price: '¥199', isFree: false, usageCount: 3650,
    tags: ['社交分享', '动画效果'],
    features: ['门店定位', '会员系统', '积分商城'],
    popularity: 68
  },

  // ========== 运动户外 (sport) ==========
  {
    id: 12, name: '极限探索', category: 'sport', categoryLabel: '运动户外',
    description: '户外运动装备品牌，大胆配色 + 动感元素',
    previewImage: 'https://picsum.photos/seed/sport1/300/200',
    price: '¥299', isFree: false, usageCount: 5780,
    tags: ['响应式', '视频背景'],
    features: ['装备对比', '活动日历', '社区论坛'],
    popularity: 76
  },
  {
    id: 13, name: '瑜伽之道', category: 'sport', categoryLabel: '运动户外',
    description: '瑜伽健身品牌，安静柔和的色彩搭配',
    previewImage: 'https://picsum.photos/seed/sport2/300/200',
    price: '免费', isFree: true, usageCount: 6230,
    tags: ['SEO优化', '多语言'],
    features: ['课程预约', '导师介绍', '线上教学'],
    popularity: 72
  },

  // ========== 母婴童装 (baby) ==========
  {
    id: 14, name: '萌宝天地', category: 'baby', categoryLabel: '母婴童装',
    description: '母婴用品一站式店铺，暖萌可爱的设计风格',
    previewImage: 'https://picsum.photos/seed/baby1/300/200',
    price: '免费', isFree: true, usageCount: 15670,
    tags: ['响应式', 'SEO优化', '快速加载'],
    features: ['年龄筛选', '安全认证', '育儿百科', '成长记录'],
    popularity: 92
  },
  {
    id: 15, name: '童梦乐园', category: 'baby', categoryLabel: '母婴童装',
    description: '童装品牌专用，多彩活泼的视觉风格',
    previewImage: 'https://picsum.photos/seed/baby2/300/200',
    price: '¥199', isFree: false, usageCount: 8140,
    tags: ['响应式', '社交分享'],
    features: ['尺码推荐', '套装搭配', '买家秀'],
    popularity: 81
  },

  // ========== 美妆个护 (beauty) ==========
  {
    id: 16, name: '美肌日记', category: 'beauty', categoryLabel: '美妆个护',
    description: '美妆护肤品店铺模板，轻奢优雅视觉',
    previewImage: 'https://picsum.photos/seed/beauty1/300/200',
    price: '免费', isFree: true, usageCount: 18730,
    tags: ['响应式', '视频背景', 'SEO优化'],
    features: ['成分解析', '肤质测试', '试用申请', '会员特权'],
    popularity: 96
  },
  {
    id: 17, name: '香气物语', category: 'beauty', categoryLabel: '美妆个护',
    description: '香氛与个护品牌，柔和渐变色调',
    previewImage: 'https://picsum.photos/seed/beauty2/300/200',
    price: '¥399', isFree: false, usageCount: 4390,
    tags: ['多语言', '高清大图'],
    features: ['香调介绍', '礼品包装', '刻字定制'],
    popularity: 65
  },

  // ========== 教育培训 (edu) ==========
  {
    id: 18, name: '智慧学堂', category: 'edu', categoryLabel: '教育培训',
    description: '在线教育 & 知识付费平台模板，清爽学术风',
    previewImage: 'https://picsum.photos/seed/edu1/300/200',
    price: '¥299', isFree: false, usageCount: 6740,
    tags: ['响应式', '多语言', '快速加载'],
    features: ['课程大纲', '试看功能', '证书发放', '学员社区'],
    popularity: 78
  },
  {
    id: 19, name: '技能工坊', category: 'edu', categoryLabel: '教育培训',
    description: '职业技能培训品牌，专业沉稳的蓝白色调',
    previewImage: 'https://picsum.photos/seed/edu2/300/200',
    price: '免费', isFree: true, usageCount: 5280,
    tags: ['SEO优化', '响应式'],
    features: ['课程日历', '讲师主页', '作业点评'],
    popularity: 69
  },

  // 额外补充分类
  {
    id: 20, name: '宠物星球', category: 'baby', categoryLabel: '母婴童装',
    description: '宠物用品独立站，萌趣生动的卡通风格',
    previewImage: 'https://picsum.photos/seed/pet1/300/200',
    price: '免费', isFree: true, usageCount: 11230,
    tags: ['响应式', '快速加载'],
    features: ['品种筛选', '喂养指南', '社区晒宠'],
    popularity: 87
  },
  {
    id: 21, name: '原木手工', category: 'home', categoryLabel: '家居',
    description: '手工艺品独立站，质朴温暖的复古设计',
    previewImage: 'https://picsum.photos/seed/home4/300/200',
    price: '¥199', isFree: false, usageCount: 2890,
    tags: ['SEO优化', '响应式'],
    features: ['工匠故事', '定制入口', '工艺展示'],
    popularity: 58
  },
  {
    id: 22, name: '营地生活', category: 'sport', categoryLabel: '运动户外',
    description: '露营装备品牌，大地色系自然风格',
    previewImage: 'https://picsum.photos/seed/sport3/300/200',
    price: '免费', isFree: true, usageCount: 9340,
    tags: ['快速加载', '响应式'],
    features: ['装备清单', '营地推荐', '团购功能'],
    popularity: 84
  },
  {
    id: 23, name: '妆容教室', category: 'beauty', categoryLabel: '美妆个护',
    description: '彩妆教程+产品销售，图文并茂展示',
    previewImage: 'https://picsum.photos/seed/beauty3/300/200',
    price: '¥299', isFree: false, usageCount: 5120,
    tags: ['视频背景', 'SEO优化'],
    features: ['教程视频', '色号推荐', '虚拟试妆'],
    popularity: 73
  },
  {
    id: 24, name: '环球食货', category: 'food', categoryLabel: '食品餐饮',
    description: '进口食品 & 地方特产，鲜艳丰富的配色',
    previewImage: 'https://picsum.photos/seed/food3/300/200',
    price: '免费', isFree: true, usageCount: 7680,
    tags: ['多语言', '响应式'],
    features: ['国家分类', '礼盒专区', '买手推荐'],
    popularity: 77
  }
]

/** 分类筛选选项 */
export const categoryFilters = [
  { key: 'all', label: '全部' },
  { key: 'fashion', label: '时尚' },
  { key: 'tech', label: '科技' },
  { key: 'home', label: '家居' },
  { key: 'food', label: '食品餐饮' },
  { key: 'sport', label: '运动户外' },
  { key: 'baby', label: '母婴童装' },
  { key: 'beauty', label: '美妆个护' },
  { key: 'edu', label: '教育培训' }
]
