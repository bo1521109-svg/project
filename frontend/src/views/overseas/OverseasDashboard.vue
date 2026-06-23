<template>
  <div class="overseas-dashboard" ref="pageRef">
    <!-- ====== 顶部：页面标题区 ====== -->
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">出海工作台</h1>
        <p class="page-subtitle">全球数据概览 · 实时监控</p>
      </div>
      <div class="header-right">
        <span class="update-time">
          <el-icon :size="14"><Clock /></el-icon>
          更新于：{{ currentTime }}
        </span>
      </div>
    </div>

    <!-- ====== KPI 指标行 ====== -->
    <div class="kpi-row">
      <div v-for="(kpi, i) in kpiList" :key="i" class="kpi-card">
        <div class="kpi-left">
          <span class="kpi-label">{{ kpi.label }}</span>
          <span class="kpi-value">{{ kpi.value }}</span>
          <span class="kpi-change" :class="kpi.change >= 0 ? 'up' : 'down'">
            <el-icon :size="10">
              <CaretTop v-if="kpi.change >= 0" />
              <CaretBottom v-else />
            </el-icon>
            {{ kpi.change >= 0 ? '+' : '' }}{{ kpi.change }}%
          </span>
        </div>
        <div class="kpi-right" ref="sparklineRefs">
          <!-- 微型 Sparkline 使用内联 SVG -->
          <svg :width="80" :height="40" viewBox="0 0 80 40" class="sparkline-svg">
            <polyline
              :points="kpi.sparkPoints"
              :stroke="kpi.change >= 0 ? '#52C41A' : '#F56C6C'"
              fill="none"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
          </svg>
        </div>
      </div>
    </div>

    <!-- ====== 主体：左 65% + 右 35% ====== -->
    <div class="main-body">
      <!-- 左侧区域 -->
      <div class="main-left">
        <!-- 全球热力分布图 -->
        <div class="card map-card">
          <div class="card-header">
            <h3 class="card-title">全球市场热力分布</h3>
            <el-tooltip content="气泡大小 = 电商规模，颜色 = 增长率" placement="left">
              <el-icon :size="16" color="#8A9AA8"><InfoFilled /></el-icon>
            </el-tooltip>
          </div>
          <div ref="mapChartRef" class="chart-container" style="height: 280px;" />
        </div>

        <!-- 品类热度趋势 -->
        <div class="card trend-card">
          <div class="card-header">
            <h3 class="card-title">热门品类趋势 · 近7天</h3>
            <div class="trend-legend">
              <span v-for="leg in trendLegend" :key="leg.name" class="legend-item">
                <span class="legend-dot" :style="{ background: leg.color }" />
                {{ leg.label }}
              </span>
            </div>
          </div>
          <div ref="trendChartRef" class="chart-container" style="height: 280px;" />
        </div>
      </div>

      <!-- 右侧区域 -->
      <div class="main-right">
        <!-- 实时动态流 -->
        <div class="card feed-card">
          <div class="card-header">
            <h3 class="card-title">实时动态</h3>
            <span class="feed-dot" />
          </div>
          <div class="feed-list" ref="feedListRef">
            <div v-for="(item, i) in feedItems" :key="i" class="feed-item" :style="{ animationDelay: i * 0.05 + 's' }">
              <span class="feed-icon">{{ item.icon }}</span>
              <div class="feed-content">
                <span class="feed-text" v-html="item.text" />
                <span class="feed-time">{{ item.time }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 快捷入口 -->
        <div class="card quick-card">
          <div class="card-header">
            <h3 class="card-title">快捷入口</h3>
          </div>
          <div class="quick-grid">
            <div v-for="(q, i) in quickLinks" :key="i" class="quick-item" @click="navigateTo(q.path)">
              <span class="quick-icon" :style="{ background: q.bg }">{{ q.icon }}</span>
              <span class="quick-label">{{ q.label }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { Clock, InfoFilled, CaretTop, CaretBottom } from '@element-plus/icons-vue'
import * as echarts from 'echarts/core'
import { BarChart, LineChart } from 'echarts/charts'
import {
  GridComponent, TooltipComponent, LegendComponent,
  DataZoomComponent
} from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import {
  getOverviewData,
  getMarkets,
  mockHotProducts,
  mockHotKeywords,
  mockCategoryTrends
} from '@/api/overseas'

// 注册 ECharts 组件
echarts.use([BarChart, LineChart, GridComponent, TooltipComponent, LegendComponent, DataZoomComponent, CanvasRenderer])

const router = useRouter()
const pageRef = ref(null)

// ====== 当前时间 ======
const currentTime = ref('')
let timeInterval = null

function updateTime() {
  const now = new Date()
  const pad = n => String(n).padStart(2, '0')
  currentTime.value = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())} ${pad(now.getHours())}:${pad(now.getMinutes())}:${pad(now.getSeconds())}`
}

onMounted(() => {
  updateTime()
  timeInterval = setInterval(updateTime, 1000)
})

onUnmounted(() => {
  if (timeInterval) clearInterval(timeInterval)
})

// ====== KPI 数据 ======
const overview = getOverviewData()

const sparkData = [
  [2, 4, 3, 5, 4, 6, 5, 7, 6, 8, 7, 9],
  [5, 6, 5, 7, 6, 7, 8, 7, 9, 8, 9, 10],
  [3, 4, 3, 5, 4, 5, 6, 5, 7, 6, 7, 8],
  [1, 2, 1.5, 2.5, 2, 3, 2.5, 3.5, 3, 4, 3.5, 4.5]
]

const kpiList = [
  {
    label: '今日预估 GTV',
    value: '$12.8M',
    change: 15.3,
    sparkPoints: sparkData[0].map((v, i) => `${(i / 11) * 80},${40 - (v / 9) * 36}`).join(' ')
  },
  {
    label: '今日总订单',
    value: '45.2K',
    change: 8.7,
    sparkPoints: sparkData[1].map((v, i) => `${(i / 11) * 80},${40 - (v / 10) * 36}`).join(' ')
  },
  {
    label: '活跃店铺',
    value: '3,460',
    change: 5.2,
    sparkPoints: sparkData[2].map((v, i) => `${(i / 11) * 80},${40 - (v / 8) * 36}`).join(' ')
  },
  {
    label: '平均 ROAS',
    value: '3.2x',
    change: 0.4,
    sparkPoints: sparkData[3].map((v, i) => `${(i / 11) * 80},${40 - (v / 5) * 36}`).join(' ')
  }
]

// ====== 市场热力图（水平条形图） ======
const mapChartRef = ref(null)
let mapChartInstance = null

// 国家名称映射
const countryNameMap = {
  US: '🇺🇸 美国', GB: '🇬🇧 英国', ID: '🇮🇩 印尼', VN: '🇻🇳 越南',
  TH: '🇹🇭 泰国', PH: '🇵🇭 菲律宾', MY: '🇲🇾 马来西亚', SG: '🇸🇬 新加坡',
  JP: '🇯🇵 日本', KR: '🇰🇷 韩国', BR: '🇧🇷 巴西', MX: '🇲🇽 墨西哥',
  FR: '🇫🇷 法国', DE: '🇩🇪 德国', AU: '🇦🇺 澳大利亚'
}

function initMapChart() {
  if (!mapChartRef.value) return
  if (mapChartInstance) mapChartInstance.dispose()

  const markets = getMarkets()
  const sorted = [...markets].sort((a, b) => b.ecomScale - a.ecomScale)
  const barColors = ['#C9A96E', '#D4B87A', '#DFC78A', '#EAD69A', '#B8945E', '#A0844E', '#C9A96E', '#D4B87A', '#DFC78A', '#EAD69A', '#B8945E', '#A0844E', '#C9A96E', '#D4B87A', '#DFC78A']

  const option = {
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'shadow' },
      formatter: (params) => {
        const d = sorted[params[0].dataIndex]
        return `<div style="font-size:13px;line-height:1.8;">
          <b>${countryNameMap[d.code] || d.name}</b><br/>
          电商规模：<b>$${d.ecomScale}B</b><br/>
          年增长率：<b>${d.growthRate}%</b><br/>
          TikTok渗透率：${d.tiktokPenetration}%<br/>
          进入难度：${d.difficulty}<br/>
          热销品类：${d.topCategories.join('、')}
        </div>`
      },
      backgroundColor: '#fff',
      borderColor: '#e8ecf1',
      borderWidth: 1,
      padding: [12, 16],
      extraCssText: 'box-shadow: 0 4px 20px rgba(0,0,0,0.08); border-radius: 8px;'
    },
    grid: { left: 100, right: 20, top: 10, bottom: 20 },
    xAxis: {
      type: 'value',
      splitLine: { lineStyle: { color: '#F0F2F5', type: 'dashed' } },
      axisLabel: { fontSize: 11, color: '#8A9AA8', formatter: '${value}B' }
    },
    yAxis: {
      type: 'category',
      data: sorted.map(m => countryNameMap[m.code] || m.name),
      axisLine: { show: false },
      axisTick: { show: false },
      axisLabel: { fontSize: 12, fontWeight: 500, color: '#4A5A6A' }
    },
    series: [{
      type: 'bar',
      data: sorted.map((m, i) => ({
        value: m.ecomScale,
        itemStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
            { offset: 0, color: '#C9A96E' },
            { offset: 1, color: '#E8D5A3' }
          ]),
          borderRadius: [0, 6, 6, 0]
        }
      })),
      barWidth: 18,
      label: {
        show: true,
        position: 'right',
        formatter: (p) => `$${sorted[p.dataIndex].ecomScale}B`,
        fontSize: 11,
        color: '#8A9AA8'
      }
    }]
  }

  mapChartInstance = echarts.init(mapChartRef.value)
  mapChartInstance.setOption(option)
}

// ====== 品类趋势图 ======
const trendChartRef = ref(null)
let trendChartInstance = null

const trendLegend = [
  { name: 'clothing', label: '服装', color: '#C9A96E' },
  { name: 'beauty', label: '美妆', color: '#F56C6C' },
  { name: 'digital3c', label: '3C数码', color: '#409EFF' },
  { name: 'home', label: '家居', color: '#67C23A' },
  { name: 'sports', label: '运动', color: '#E6A23C' },
  { name: 'jewelry', label: '珠宝饰品', color: '#A78BFA' }
]

function initTrendChart() {
  if (!trendChartRef.value) return
  if (trendChartInstance) trendChartInstance.dispose()

  const data = mockCategoryTrends
  const series = trendLegend.map(leg => ({
    name: leg.label,
    type: 'line',
    smooth: true,
    symbol: 'circle',
    symbolSize: 4,
    lineStyle: { width: 2.5 },
    data: data.map(d => d[leg.name]),
    areaStyle: {
      opacity: 0.05
    }
  }))

  const option = {
    tooltip: {
      trigger: 'axis',
      backgroundColor: '#fff',
      borderColor: '#e8ecf1',
      borderWidth: 1,
      padding: [10, 14],
      extraCssText: 'box-shadow: 0 4px 20px rgba(0,0,0,0.08); border-radius: 8px;'
    },
    legend: { show: false },
    grid: { left: 40, right: 16, top: 10, bottom: 28 },
    xAxis: {
      type: 'category',
      data: data.map(d => d.date),
      axisLine: { lineStyle: { color: '#E8ECF1' } },
      axisLabel: { fontSize: 11, color: '#8A9AA8' }
    },
    yAxis: {
      type: 'value',
      min: 50,
      max: 95,
      splitLine: { lineStyle: { color: '#F0F2F5', type: 'dashed' } },
      axisLabel: { fontSize: 11, color: '#8A9AA8' }
    },
    color: ['#C9A96E', '#F56C6C', '#409EFF', '#67C23A', '#E6A23C', '#A78BFA'],
    series
  }

  trendChartInstance = echarts.init(trendChartRef.value)
  trendChartInstance.setOption(option)
}

// ====== 实时动态 ======
const feedItems = [
  { icon: '🔥', text: '<b>无线蓝牙耳机</b> 在印尼市场爆发，单日销量突破 <b>2,300</b>', time: '2分钟前' },
  { icon: '📹', text: '达人 <b>@Sophia Wang</b> 正在直播带货美妆套装', time: '5分钟前' },
  { icon: '👤', text: '美国达人 <b>Emma Taylor</b> 达成合作意向，粉丝 52 万', time: '8分钟前' },
  { icon: '📊', text: '<b>瑜伽裤</b> 品类广告 ROAS 提升至 <b>4.8x</b>，建议加大投放', time: '12分钟前' },
  { icon: '🔥', text: '<b>韩版面膜套装</b> 在 TikTok Shop 热卖，7 天销量 8,900 件', time: '15分钟前' },
  { icon: '👤', text: '巴西达人 <b>Lucas Zhou</b>  签约成功，合作费用 $1,200', time: '20分钟前' },
  { icon: '📹', text: '泰国直播间同时在线突破 <b>1,200</b> 人，转化率 5.2%', time: '25分钟前' },
  { icon: '📊', text: '东南亚市场 <b>3C配件</b> 广告点击率上升 22%', time: '30分钟前' },
  { icon: '🔥', text: '<b>宠物喂食器</b>  在美区 Amazon 冲进品类 TOP 10', time: '35分钟前' },
  { icon: '👤', text: '印尼达人 <b>Mia Brown</b>  完成首场带货，GMV $8,500', time: '40分钟前' }
]

// ====== 快捷入口 ======
const quickLinks = [
  { icon: '🔍', label: '选爆品', path: '/overseas/opportunities/product-radar', bg: 'linear-gradient(135deg, #C9A96E, #E8D5A3)' },
  { icon: '🏪', label: '盯爆店', path: '/tiktok/stores', bg: 'linear-gradient(135deg, #409EFF, #79BBFF)' },
  { icon: '👥', label: '找达人', path: '/tiktok/influencers', bg: 'linear-gradient(135deg, #A78BFA, #C4B5FD)' },
  { icon: '🎬', label: 'AI创作', path: '/content/workbench', bg: 'linear-gradient(135deg, #67C23A, #95D475)' }
]

function navigateTo(path) {
  router.push(path)
}

// ====== ECharts 响应式 ======
function handleResize() {
  mapChartInstance?.resize()
  trendChartInstance?.resize()
}

onMounted(() => {
  nextTick(() => {
    initMapChart()
    initTrendChart()
  })
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  mapChartInstance?.dispose()
  trendChartInstance?.dispose()
})
</script>

<style scoped>
.overseas-dashboard {
  max-width: 1440px;
  margin: 0 auto;
  min-height: 100vh;
}

/* ====== 页面标题 ====== */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 28px;
}
.header-left { display: flex; flex-direction: column; gap: 6px; }
.page-title { margin: 0; font-size: 28px; font-weight: 700; color: #1A2A3A; letter-spacing: -0.3px; }
.page-subtitle { margin: 0; font-size: 14px; color: #8A9AA8; }
.header-right { flex-shrink: 0; }
.update-time { display: flex; align-items: center; gap: 6px; font-size: 13px; color: #8A9AA8; }

/* ====== KPI 指标行 ====== */
.kpi-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 28px;
}
.kpi-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #fff;
  border-radius: 16px;
  padding: 22px 24px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
  transition: transform 0.3s, box-shadow 0.3s;
}
.kpi-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.06);
}
.kpi-left { display: flex; flex-direction: column; gap: 4px; }
.kpi-label { font-size: 13px; color: #8A9AA8; font-weight: 500; }
.kpi-value { font-size: 32px; font-weight: 700; color: #1A2A3A; letter-spacing: -0.5px; line-height: 1.1; }
.kpi-change {
  display: flex; align-items: center; gap: 2px;
  font-size: 12px; font-weight: 600; margin-top: 2px;
}
.kpi-change.up { color: #52C41A; }
.kpi-change.down { color: #F56C6C; }
.sparkline-svg { opacity: 0.6; flex-shrink: 0; }

/* ====== 主体布局 ====== */
.main-body { display: flex; gap: 24px; align-items: flex-start; }
.main-left { flex: 0 0 65%; display: flex; flex-direction: column; gap: 24px; }
.main-right { flex: 0 0 35%; display: flex; flex-direction: column; gap: 24px; }

/* ====== 通用卡片 ====== */
.card {
  background: #fff;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}
.card-title { margin: 0; font-size: 16px; font-weight: 600; color: #1A2A3A; }
.chart-container { width: 100%; }

/* ====== 品类趋势图例 ====== */
.trend-legend { display: flex; gap: 14px; flex-wrap: wrap; }
.legend-item { display: flex; align-items: center; gap: 5px; font-size: 11px; color: #8A9AA8; }
.legend-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }

/* ====== 实时动态 ====== */
.feed-card { max-height: 420px; overflow: hidden; }
.feed-dot {
  width: 8px; height: 8px; border-radius: 50%;
  background: #52C41A; flex-shrink: 0;
  box-shadow: 0 0 0 3px rgba(82,196,26,0.2);
  animation: pulse-dot 2s infinite;
}
@keyframes pulse-dot {
  0%, 100% { box-shadow: 0 0 0 3px rgba(82,196,26,0.2); }
  50% { box-shadow: 0 0 0 6px rgba(82,196,26,0.08); }
}
.feed-list { overflow-y: auto; max-height: 340px; scrollbar-width: thin; }
.feed-list::-webkit-scrollbar { width: 4px; }
.feed-list::-webkit-scrollbar-thumb { background: #E8ECF1; border-radius: 4px; }
.feed-item {
  display: flex; gap: 12px; padding: 12px 0;
  border-bottom: 1px solid #F5F6F8;
  animation: feedIn 0.4s ease backwards;
}
.feed-item:last-child { border-bottom: none; }
@keyframes feedIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }
.feed-icon { font-size: 18px; flex-shrink: 0; width: 24px; text-align: center; line-height: 1.4; }
.feed-content { flex: 1; min-width: 0; }
.feed-text { font-size: 13px; color: #4A5A6A; line-height: 1.5; display: block; }
.feed-text :deep(b) { font-weight: 600; color: #1A2A3A; }
.feed-time { font-size: 11px; color: #B0BCC8; margin-top: 4px; display: block; }

/* ====== 快捷入口 ====== */
.quick-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.quick-item {
  display: flex; flex-direction: column; align-items: center; gap: 10px;
  padding: 20px 12px; border-radius: 14px;
  background: #FAFBFC; cursor: pointer;
  transition: all 0.25s; border: 1px solid transparent;
}
.quick-item:hover { background: #fff; border-color: #E8ECF1; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.04); }
.quick-icon {
  width: 44px; height: 44px; border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  font-size: 20px; color: #fff;
}
.quick-label { font-size: 13px; font-weight: 600; color: #4A5A6A; }

/* ====== 响应式 ====== */
@media (max-width: 1200px) {
  .main-body { flex-direction: column; }
  .main-left, .main-right { flex: 1; }
}
@media (max-width: 900px) {
  .kpi-row { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 600px) {
  .kpi-row { grid-template-columns: 1fr; }
  .page-header { flex-direction: column; align-items: flex-start; gap: 12px; }
  .trend-legend { display: none; }
}
</style>
