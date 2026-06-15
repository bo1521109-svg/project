/*
 * 广告搜索筛选假数据
 * 预留后续联调时替换为真实API数据
 */
export const adCountryList = [
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

export const adTypeList = [
  { label: '全部', value: 'all' },
  { label: '图片广告', value: 'image' },
  { label: '视频广告', value: 'video' },
  { label: '轮播广告', value: 'carousel' },
  { label: '幻灯片广告', value: 'slideshow' },
  { label: '精品栏广告', value: 'collection' },
  { label: '即时体验广告', value: 'instant-experience' },
]

export const adPlatformList = [
  { label: '全部', value: 'all' },
  { label: 'Facebook', value: 'facebook' },
  { label: 'Instagram', value: 'instagram' },
  { label: 'Messenger', value: 'messenger' },
  { label: 'Audience Network', value: 'audience-network' },
]

export const adFilterOptions = {
  impressions: [
    { label: '全部', value: 'all' },
    { label: '< 1万', value: 'lt10k' },
    { label: '1万 - 10万', value: '10k-100k' },
    { label: '10万 - 100万', value: '100k-1m' },
    { label: '100万 - 1000万', value: '1m-10m' },
    { label: '> 1000万', value: 'gt10m' },
  ],
  engagementRate: [
    { label: '全部', value: 'all' },
    { label: '< 1%', value: 'lt1pct' },
    { label: '1% - 3%', value: '1-3pct' },
    { label: '3% - 5%', value: '3-5pct' },
    { label: '5% - 10%', value: '5-10pct' },
    { label: '> 10%', value: 'gt10pct' },
  ],
  advertiserFollowers: [
    { label: '全部', value: 'all' },
    { label: '< 1万', value: 'lt10k' },
    { label: '1万 - 10万', value: '10k-100k' },
    { label: '10万 - 100万', value: '100k-1m' },
    { label: '> 100万', value: 'gt1m' },
  ],
  mediaFormat: [
    { label: '全部', value: 'all' },
    { label: '图片', value: 'picture' },
    { label: '视频', value: 'video' },
  ],
}
