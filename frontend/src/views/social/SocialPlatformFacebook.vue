<template>
  <div class="page-container">
    <div class="brand-header">
      <div class="bh-left">
        <svg class="bh-icon" viewBox="0 0 40 40" fill="none"><circle cx="20" cy="20" r="18" fill="#1877f2"/><text x="20" y="27" text-anchor="middle" fill="#fff" font-size="22" font-weight="800" font-family="Arial">f</text></svg>
        <div>
          <h2 class="bh-title">Facebook</h2>
          <p class="bh-sub">社交网络主页运营与数据分析</p>
        </div>
      </div>
      <el-button type="primary" style="background:#1877f2">同步数据</el-button>
    </div>

    <div class="stat-row">
      <div v-for="s in stats" :key="s.label" class="stat-card">
        <div class="sc-icon" :style="{ background: s.bg }">{{ s.icon }}</div>
        <div class="sc-body">
          <div class="sc-num">{{ s.num }}<span class="sc-trend up"> {{ s.trend }}</span></div>
          <div class="sc-label">{{ s.label }}</div>
        </div>
      </div>
    </div>

    <!-- 帖子表现 -->
    <div class="section">
      <div class="section-header">📝 最近帖子表现</div>
      <div class="table-wrap">
        <table>
          <thead><tr><th style="width:60px">类型</th><th>内容摘要</th><th style="width:90px">覆盖</th><th style="width:80px">互动</th><th style="width:80px">点击</th><th style="width:100px">发布时间</th></tr></thead>
          <tbody>
            <tr v-for="p in posts" :key="p.id">
              <td><span class="ptype" :class="p.type">{{ typeLabel[p.type] }}</span></td>
              <td>{{ p.content }}</td>
              <td class="num">{{ p.reach }}</td>
              <td class="num">{{ p.engagement }}</td>
              <td class="num">{{ p.clicks }}</td>
              <td class="time">{{ p.time }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 受众画像 & 广告数据 -->
    <div class="two-col">
      <div class="section half">
        <div class="section-header">👥 受众画像</div>
        <div class="audience-bars">
          <div v-for="a in audience" :key="a.label" class="ab-item">
            <div class="ab-label">{{ a.label }}</div>
            <div class="ab-track"><div class="ab-fill" :style="{ width: a.pct+'%', background: a.color }"></div></div>
            <div class="ab-val">{{ a.pct }}%</div>
          </div>
        </div>
      </div>
      <div class="section half">
        <div class="section-header">📢 广告投放概览</div>
        <div class="ad-grid">
          <div v-for="a in adStats" :key="a.label" class="ad-card">
            <div class="ad-num">{{ a.num }}</div>
            <div class="ad-lbl">{{ a.label }}</div>
            <div class="ad-delta up">{{ a.delta }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const typeLabel = { image: '图片', video: '视频', link: '链接', live: '直播' }

const stats = [
  { icon: '👍', bg: '#e3f2fd', num: '35.6万', trend: '+5.2%', label: '主页赞' },
  { icon: '👥', bg: '#e8f5e9', num: '42.1万', trend: '+3.8%', label: '主页关注' },
  { icon: '📊', bg: '#fce4ec', num: '128万', trend: '+15.6%', label: '月覆盖人数' },
  { icon: '💬', bg: '#fff3e0', num: '3.2%', trend: '+1.1%', label: '平均互动率' }
]

const posts = [
  { type: 'video', content: '新品发布会回顾 | XYZ品牌2026春季系列首发', reach: '28万', engagement: '1.8万', clicks: '5.2k', time: '2小时前' },
  { type: 'image', content: '客户好评合集 | 真实用户反馈展示', reach: '22万', engagement: '1.5万', clicks: '3.1k', time: '6小时前' },
  { type: 'link', content: '限时优惠 | 全场满$50减$10，仅限本周', reach: '45万', engagement: '2.3万', clicks: '12.5k', time: '昨天' },
  { type: 'video', content: '产品使用教程 | 3分钟学会正确使用XX', reach: '19万', engagement: '1.2万', clicks: '4.8k', time: '昨天' },
  { type: 'image', content: '节日祝福 | 感恩节特别活动预告', reach: '32万', engagement: '2.1万', clicks: '6.3k', time: '2天前' },
  { type: 'live', content: 'CEO在线答疑 | 品牌理念与未来规划', reach: '15万', engagement: '8.5k', clicks: '2.9k', time: '3天前' },
  { type: 'link', content: '博文推荐 | 行业趋势分析报告', reach: '18万', engagement: '9.2k', clicks: '7.1k', time: '3天前' },
  { type: 'image', content: '幕后花絮 | 产品拍摄现场精彩瞬间', reach: '26万', engagement: '1.9万', clicks: '3.8k', time: '4天前' }
]

const audience = [
  { label: '18-24岁', pct: 15, color: '#1877f2' },
  { label: '25-34岁', pct: 38, color: '#42a5f5' },
  { label: '35-44岁', pct: 25, color: '#64b5f6' },
  { label: '45-54岁', pct: 14, color: '#90caf9' },
  { label: '55岁以上', pct: 8, color: '#bbdefb' }
]

const adStats = [
  { num: '$12.8K', label: '广告花费', delta: '+8.5%' },
  { num: '128万', label: '展示次数', delta: '+15.2%' },
  { num: '3.8万', label: '点击次数', delta: '+12.3%' },
  { num: '$0.34', label: '单次点击成本', delta: '-5.2%' },
  { num: '4.2%', label: '转化率', delta: '+2.1%' },
  { num: '$18.60', label: 'ROAS', delta: '+6.8%' }
]
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.brand-header { display: flex; align-items: center; justify-content: space-between; background: linear-gradient(135deg, #1877f2, #42a5f5); border-radius: 16px; padding: 24px 28px; margin-bottom: 20px; }
.bh-left { display: flex; align-items: center; gap: 16px; }
.bh-icon { width: 40px; height: 40px; flex-shrink: 0; }
.bh-title { color: #fff; font-size: 24px; margin: 0; }
.bh-sub { color: rgba(255,255,255,0.75); font-size: 13px; margin: 4px 0 0; }

.stat-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 20px; }
.stat-card { background: #fff; border-radius: 14px; padding: 18px 20px; display: flex; align-items: center; gap: 14px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); }
.sc-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; }
.sc-body { display: flex; flex-direction: column; }
.sc-num { font-size: 22px; font-weight: 800; color: #1a1a1a; }
.sc-trend { font-size: 12px; font-weight: 500; }
.sc-trend.up { color: #10b981; }
.sc-label { font-size: 12px; color: #999; margin-top: 2px; }

.section { background: #fff; border-radius: 14px; padding: 20px; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); }
.section-header { font-size: 16px; font-weight: 700; color: #1a1a1a; margin-bottom: 16px; }
.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.half { margin-bottom: 0; }

.table-wrap { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; }
thead th { text-align: left; padding: 10px 12px; font-size: 12px; color: #999; font-weight: 600; border-bottom: 2px solid #f0f0f0; }
tbody td { padding: 12px; font-size: 13px; color: #333; border-bottom: 1px solid #f5f5f5; vertical-align: middle; }
tbody tr:hover { background: #fafafa; }
.ptype { font-size: 11px; padding: 2px 8px; border-radius: 4px; font-weight: 600; }
.ptype.video { background: #e3f2fd; color: #1976d2; }
.ptype.image { background: #fce4ec; color: #c62828; }
.ptype.link { background: #e8f5e9; color: #2e7d32; }
.ptype.live { background: #fff3e0; color: #ef6c00; }
.num { color: #333; font-weight: 500; font-variant-numeric: tabular-nums; }
.time { color: #aaa; font-size: 12px; }

.audience-bars { display: flex; flex-direction: column; gap: 12px; }
.ab-item { display: flex; align-items: center; gap: 10px; }
.ab-label { width: 70px; font-size: 12px; color: #666; text-align: right; }
.ab-track { flex: 1; height: 8px; background: #f0f0f0; border-radius: 4px; overflow: hidden; }
.ab-fill { height: 100%; border-radius: 4px; }
.ab-val { width: 36px; font-size: 13px; font-weight: 600; color: #333; }

.ad-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 12px; }
.ad-card { background: #f8faff; border-radius: 10px; padding: 16px; text-align: center; }
.ad-num { font-size: 20px; font-weight: 700; color: #1877f2; }
.ad-lbl { font-size: 11px; color: #888; margin: 4px 0; }
.ad-delta { font-size: 11px; font-weight: 600; }
.ad-delta.up { color: #10b981; }
</style>
