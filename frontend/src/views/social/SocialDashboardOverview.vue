<template>
  <div class="page-container">
    <div class="page-header">
      <h2>📊 数据看板</h2>
      <el-select v-model="period" size="default" style="width:120px">
        <el-option label="今日" value="today" />
        <el-option label="本周" value="week" />
        <el-option label="本月" value="month" />
      </el-select>
    </div>

    <!-- 全平台汇总 -->
    <div class="stat-row">
      <div v-for="s in summaryStats" :key="s.label" class="stat-card">
        <div class="sc-icon" :style="{ background: s.bg }">{{ s.icon }}</div>
        <div class="sc-body">
          <div class="sc-num">{{ s.num }}<span class="sc-trend" :class="s.trendUp ? 'up' : 'down'"> {{ s.trend }}</span></div>
          <div class="sc-label">{{ s.label }}</div>
        </div>
      </div>
    </div>

    <!-- 平台对比 -->
    <div class="section">
      <div class="section-header">📈 各平台关键指标对比</div>
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>平台</th>
              <th style="text-align:right">粉丝/订阅</th>
              <th style="text-align:right">本月内容</th>
              <th style="text-align:right">总互动量</th>
              <th style="text-align:right">互动率</th>
              <th style="text-align:right">环比增长</th>
              <th style="text-align:right">最高播放</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="p in platforms" :key="p.name">
              <td>
                <div class="pf-cell">
                  <span class="pf-dot" :style="{ background: p.color }"></span>
                  <span class="pf-name">{{ p.name }}</span>
                </div>
              </td>
              <td class="num">{{ p.followers }}</td>
              <td class="num">{{ p.content }}</td>
              <td class="num">{{ p.engagement }}</td>
              <td class="num">{{ p.rate }}</td>
              <td class="num"><span class="growth" :class="p.growthUp ? 'g-up' : 'g-down'">{{ p.growth }}</span></td>
              <td class="num">{{ p.topView }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 双栏 -->
    <div class="two-col">
      <!-- 内容发布趋势 -->
      <div class="section half">
        <div class="section-header">📅 本周内容发布趋势</div>
        <div class="trend-bars">
          <div v-for="d in weeklyTrend" :key="d.day" class="tb-col">
            <div class="tb-bar-wrap">
              <div class="tb-bar" :style="{ height: d.posts*4+'px', background: d.posts>4 ? '#1d9bf0' : '#90caf9' }"></div>
            </div>
            <div class="tb-label">{{ d.day }}</div>
            <div class="tb-count">{{ d.posts }}篇</div>
          </div>
        </div>
      </div>

      <!-- 最佳发布时间 -->
      <div class="section half">
        <div class="section-header">⏰ 最佳发布时间段</div>
        <div class="time-heat">
          <div v-for="t in timeSlots" :key="t.slot" class="th-row">
            <span class="th-label">{{ t.slot }}</span>
            <div class="th-bar"><div class="th-fill" :style="{ width: t.pct+'%', background: t.pct>60 ? '#10b981' : t.pct>30 ? '#f59e0b' : '#e0e0e0' }"></div></div>
            <span class="th-val">{{ t.avgEng }}互动</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 最新动态 -->
    <div class="section">
      <div class="section-header">🔔 最近动态</div>
      <div class="activity-list">
        <div v-for="a in activities" :key="a.id" class="act-item">
          <div class="act-dot" :style="{ background: a.color }"></div>
          <div class="act-body">
            <div class="act-text">
              <span class="act-platform">{{ a.platform }}</span>
              {{ a.text }}
            </div>
            <div class="act-meta">
              <span class="act-time">{{ a.time }}</span>
              <span v-if="a.metric" class="act-metric">{{ a.metric }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
const period = ref('week')

const summaryStats = [
  { icon: '👥', bg: '#e3f2fd', num: '168.5万', trend: '+8.3%', trendUp: true, label: '跨平台总粉丝' },
  { icon: '👁️', bg: '#e8f5e9', num: '12.8亿', trend: '+25.6%', trendUp: true, label: '本月总展示量' },
  { icon: '💬', bg: '#fff3e0', num: '58.2万', trend: '+18.9%', trendUp: true, label: '本月总互动量' },
  { icon: '📊', bg: '#fce4ec', num: '5.4%', trend: '+1.2%', trendUp: true, label: '平均互动率' }
]

const platforms = [
  { name: 'TikTok', color: '#ff0050', followers: '52.1万', content: '45', engagement: '18.2万', rate: '6.8%', growth: '+12.5%', growthUp: true, topView: '256万' },
  { name: 'Instagram', color: '#e1306c', followers: '28.5万', content: '32', engagement: '8.5万', rate: '5.2%', growth: '+6.8%', growthUp: true, topView: '89万' },
  { name: 'Facebook', color: '#1877f2', followers: '35.6万', content: '28', engagement: '6.2万', rate: '3.2%', growth: '+3.8%', growthUp: true, topView: '45万' },
  { name: 'YouTube', color: '#ff0000', followers: '68.5万', content: '18', engagement: '12.5万', rate: '8.5%', growth: '+25.6%', growthUp: true, topView: '186万' },
  { name: 'Twitter/X', color: '#1d9bf0', followers: '12.8万', content: '56', engagement: '8.5万', rate: '4.1%', growth: '+15.3%', growthUp: true, topView: '32万' },
  { name: 'Pinterest', color: '#e60023', followers: '3.8万', content: '24', engagement: '5.5万', rate: '2.8%', growth: '+5.8%', growthUp: true, topView: '28万' },
  { name: 'Reddit', color: '#ff4500', followers: '2.5万', content: '38', engagement: '3.8万', rate: '5.6%', growth: '+12.5%', growthUp: true, topView: '15万' }
]

const weeklyTrend = [
  { day: '周一', posts: 5 },
  { day: '周二', posts: 7 },
  { day: '周三', posts: 8 },
  { day: '周四', posts: 6 },
  { day: '周五', posts: 4 },
  { day: '周六', posts: 2 },
  { day: '周日', posts: 3 }
]

const timeSlots = [
  { slot: '06:00-09:00', pct: 35, avgEng: '256' },
  { slot: '09:00-12:00', pct: 58, avgEng: '423' },
  { slot: '12:00-15:00', pct: 72, avgEng: '586' },
  { slot: '15:00-18:00', pct: 45, avgEng: '338' },
  { slot: '18:00-21:00', pct: 85, avgEng: '892' },
  { slot: '21:00-24:00', pct: 62, avgEng: '521' }
]

const activities = [
  { platform: 'TikTok', text: '新视频「产品开箱挑战」播放量突破 200 万', time: '2小时前', color: '#ff0050', metric: '📊 210万播放' },
  { platform: 'YouTube', text: '新视频「Ultimate Product Unboxing」获得 8.2 万赞', time: '5小时前', color: '#ff0000', metric: '❤️ 8.2万赞' },
  { platform: 'Instagram', text: 'Reel「3秒变装挑战第5弹」触达 18 万用户', time: '8小时前', color: '#e1306c', metric: '👁️ 18万触达' },
  { platform: 'Facebook', text: '限时优惠帖子获得 2.3 万互动', time: '昨天', color: '#1877f2', metric: '💬 2.3万互动' },
  { platform: 'Twitter/X', text: '品牌提及量今日增长 +15%', time: '昨天', color: '#1d9bf0', metric: '📈 +15%' },
  { platform: 'Reddit', text: '产品推荐帖在 r/ecommerce 获得 2.8K 赞', time: '2天前', color: '#ff4500', metric: '⬆️ 2.8K' }
]
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
.page-header h2 { font-size: 22px; font-weight: 800; color: #1a1a1a; margin: 0; }

.stat-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 20px; }
.stat-card { background: #fff; border-radius: 14px; padding: 18px 20px; display: flex; align-items: center; gap: 14px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); transition: all 0.2s; }
.stat-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
.sc-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; }
.sc-body { display: flex; flex-direction: column; }
.sc-num { font-size: 22px; font-weight: 800; color: #1a1a1a; }
.sc-trend { font-size: 12px; font-weight: 500; }
.sc-trend.up { color: #10b981; }
.sc-trend.down { color: #ef4444; }
.sc-label { font-size: 12px; color: #999; margin-top: 2px; }

.section { background: #fff; border-radius: 14px; padding: 20px; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); }
.section-header { font-size: 16px; font-weight: 700; color: #1a1a1a; margin-bottom: 16px; }
.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.half { margin-bottom: 0; }

.table-wrap { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; }
thead th { text-align: left; padding: 10px 12px; font-size: 12px; color: #999; font-weight: 600; border-bottom: 2px solid #f0f0f0; }
tbody td { padding: 12px; font-size: 13px; color: #333; border-bottom: 1px solid #f5f5f5; }
tbody tr:hover { background: #fafafa; }
.pf-cell { display: flex; align-items: center; gap: 8px; }
.pf-dot { width: 8px; height: 8px; border-radius: 50%; }
.pf-name { font-weight: 600; }
.num { text-align: right; font-weight: 500; font-variant-numeric: tabular-nums; }
.growth { font-weight: 600; }
.g-up { color: #10b981; }
.g-down { color: #ef4444; }

.trend-bars { display: flex; align-items: flex-end; justify-content: space-around; gap: 8px; padding: 10px 0; }
.tb-col { display: flex; flex-direction: column; align-items: center; gap: 8px; }
.tb-bar-wrap { height: 60px; display: flex; align-items: flex-end; }
.tb-bar { width: 28px; border-radius: 6px 6px 0 0; min-height: 4px; transition: all 0.3s; }
.tb-bar:hover { opacity: 0.8; }
.tb-label { font-size: 11px; color: #999; }
.tb-count { font-size: 12px; font-weight: 600; color: #333; }

.time-heat { display: flex; flex-direction: column; gap: 10px; }
.th-row { display: flex; align-items: center; gap: 10px; }
.th-label { width: 85px; font-size: 12px; color: #666; }
.th-bar { flex: 1; height: 8px; background: #f0f0f0; border-radius: 4px; overflow: hidden; }
.th-fill { height: 100%; border-radius: 4px; }
.th-val { width: 60px; font-size: 12px; color: #888; text-align: right; }

.activity-list { display: flex; flex-direction: column; }
.act-item { display: flex; gap: 12px; padding: 14px 0; border-bottom: 1px solid #f5f5f5; }
.act-item:last-child { border-bottom: none; }
.act-dot { width: 8px; height: 8px; border-radius: 50%; margin-top: 6px; flex-shrink: 0; }
.act-body { flex: 1; display: flex; justify-content: space-between; align-items: flex-start; }
.act-text { font-size: 13px; color: #333; line-height: 1.4; }
.act-platform { font-weight: 700; margin-right: 4px; }
.act-meta { display: flex; flex-direction: column; align-items: flex-end; gap: 3px; flex-shrink: 0; margin-left: 12px; }
.act-time { font-size: 11px; color: #bbb; }
.act-metric { font-size: 12px; color: #666; font-weight: 500; }
</style>
