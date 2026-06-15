/*
 * TikTok广告搜索筛选假数据
 */
export const tkAdCountryList = [
  { label: '全部', value: 'all' },
  { label: '美国', value: 'US' },
  { label: '印度尼西亚', value: 'ID' },
  { label: '英国', value: 'GB' },
  { label: '越南', value: 'VN' },
  { label: '泰国', value: 'TH' },
  { label: '马来西亚', value: 'MY' },
  { label: '菲律宾', value: 'PH' },
  { label: '西班牙', value: 'ES' },
  { label: '墨西哥', value: 'MX' },
  { label: '德国', value: 'DE' },
  { label: '法国', value: 'FR' },
  { label: '意大利', value: 'IT' },
  { label: '巴西', value: 'BR' },
  { label: '日本', value: 'JP' },
  { label: '新加坡', value: 'SG' },
]

export const tkAdTypeList = [
  { label: '全部', value: 'all' },
  { label: '信息流广告', value: 'in-feed' },
  { label: '开屏广告', value: 'brand-takeover' },
  { label: 'TopView', value: 'top-view' },
  { label: '挑战赛', value: 'hashtag-challenge' },
  { label: '品牌效果广告', value: 'branded-effect' },
  { label: '搜索广告', value: 'search-ad' },
  { label: 'Spark Ads', value: 'spark-ads' },
]

export const tkAdIndustryList = [
  { label: '全部', value: 'all' },
  { label: '电商零售', value: 'ecommerce' },
  { label: '游戏', value: 'gaming' },
  { label: '金融保险', value: 'finance' },
  { label: '教育培训', value: 'education' },
  { label: '美妆个护', value: 'beauty' },
  { label: '服饰鞋包', value: 'fashion' },
  { label: '食品饮料', value: 'food' },
  { label: '家居建材', value: 'home' },
  { label: '旅游出行', value: 'travel' },
  { label: '汽车', value: 'auto' },
  { label: '医疗健康', value: 'health' },
  { label: '社交应用', value: 'social' },
  { label: '工具应用', value: 'tools' },
  { label: '其他', value: 'other' },
]

export const tkAdFilterOptions = {
  impressions: [
    { label: '全部', value: 'all' },
    { label: '< 1万', value: 'lt10k' },
    { label: '1万 - 10万', value: '10k-100k' },
    { label: '10万 - 100万', value: '100k-1m' },
    { label: '100万 - 1000万', value: '1m-10m' },
    { label: '> 1000万', value: 'gt10m' },
  ],
  ctr: [
    { label: '全部', value: 'all' },
    { label: '< 0.5%', value: 'lt05pct' },
    { label: '0.5% - 1%', value: '05-1pct' },
    { label: '1% - 3%', value: '1-3pct' },
    { label: '> 3%', value: 'gt3pct' },
  ],
  cvr: [
    { label: '全部', value: 'all' },
    { label: '< 1%', value: 'lt1pct' },
    { label: '1% - 3%', value: '1-3pct' },
    { label: '3% - 5%', value: '3-5pct' },
    { label: '> 5%', value: 'gt5pct' },
  ],
  engagementRate: [
    { label: '全部', value: 'all' },
    { label: '< 1%', value: 'lt1pct' },
    { label: '1% - 3%', value: '1-3pct' },
    { label: '3% - 5%', value: '3-5pct' },
    { label: '5% - 10%', value: '5-10pct' },
    { label: '> 10%', value: 'gt10pct' },
  ],
  duration: [
    { label: '全部', value: 'all' },
    { label: '近7天', value: '7d' },
    { label: '近30天', value: '30d' },
    { label: '近90天', value: '90d' },
  ],
}
