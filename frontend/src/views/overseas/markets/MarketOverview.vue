<template>
  <div class="market-overview">
    <!-- ====== 顶部：标题 + 筛选 ====== -->
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">市场总览</h1>
        <p class="page-subtitle">全球 15 个市场实时数据</p>
      </div>
      <div class="header-filters">
        <!-- 时间切换 -->
        <div class="filter-group">
          <button
            v-for="r in timeRanges"
            :key="r.value"
            class="filter-btn"
            :class="{ active: activeTimeRange === r.value }"
            @click="activeTimeRange = r.value"
          >{{ r.label }}</button>
        </div>
        <!-- 区域筛选 -->
        <div class="filter-group">
          <button
            v-for="reg in regions"
            :key="reg.value"
            class="filter-btn"
            :class="{ active: activeRegion === reg.value }"
            @click="switchRegion(reg.value)"
          >{{ reg.label }}</button>
        </div>
      </div>
    </div>

    <!-- ====== 核心指标行 ====== -->
    <div class="kpi-row">
      <div class="kpi-card">
        <div class="kpi-left">
          <span class="kpi-label">总市场规模</span>
          <span class="kpi-value">${{ totalMarketScale }}B</span>
        </div>
        <div class="kpi-icon gold"><el-icon :size="24"><TrendCharts /></el-icon></div>
      </div>
      <div class="kpi-card">
        <div class="kpi-left">
          <span class="kpi-label">覆盖国家数</span>
          <span class="kpi-value">{{ filteredMarkets.length }}</span>
        </div>
        <div class="kpi-icon blue"><el-icon :size="24"><Connection /></el-icon></div>
      </div>
      <div class="kpi-card">
        <div class="kpi-left">
          <span class="kpi-label">平均增长率</span>
          <span class="kpi-value">{{ avgGrowthRate }}%</span>
        </div>
        <div class="kpi-icon green"><el-icon :size="24"><TrendCharts /></el-icon></div>
      </div>
      <div class="kpi-card">
        <div class="kpi-left">
          <span class="kpi-label">TikTok 渗透率</span>
          <span class="kpi-value">{{ avgTiktokPenetration }}%</span>
        </div>
        <div class="kpi-icon purple"><el-icon :size="24"><Monitor /></el-icon></div>
      </div>
    </div>

    <!-- ====== 市场卡片网格 ====== -->
    <div class="market-grid">
      <div
        v-for="(m, idx) in filteredMarkets"
        :key="m.code"
        class="market-card"
        :style="{ animationDelay: idx * 0.04 + 's' }"
        @click="openDetail(m)"
      >
        <!-- 顶部：国旗 + 国家名 + 难度标签 -->
        <div class="card-top">
          <div class="card-country">
            <span class="card-flag">{{ countryFlag(m.code) }}</span>
            <span class="card-name">{{ m.name }}</span>
          </div>
          <span class="diff-tag" :class="'diff-' + (m.difficulty === '低' ? 'low' : m.difficulty === '中' ? 'mid' : 'high')">
            {{ m.difficulty }}
          </span>
        </div>

        <!-- 电商规模 + 增长率 -->
        <div class="card-metrics">
          <div class="metric-block">
            <span class="metric-label">电商规模</span>
            <span class="metric-value">${{ m.ecomScale }}B</span>
          </div>
          <div class="metric-block right">
            <span class="metric-label">增长率</span>
            <span class="metric-value growth-up">+{{ m.growthRate }}%</span>
          </div>
        </div>

        <!-- TikTok 渗透率进度条 -->
        <div class="penetration-row">
          <span class="pen-label">TikTok 渗透率</span>
          <div class="pen-bar-bg">
            <div class="pen-bar-fill" :style="{ width: m.tiktokPenetration + '%' }" />
          </div>
          <span class="pen-value">{{ m.tiktokPenetration }}%</span>
        </div>

        <!-- 热销品类标签 -->
        <div class="cat-tags">
          <span v-for="(cat, ci) in m.topCategories" :key="ci" class="cat-tag">{{ cat }}</span>
        </div>
      </div>
    </div>

    <!-- ====== 底部：市场规模排行图表 ====== -->
    <div class="chart-card">
      <div class="chart-header">
        <h3 class="chart-title">市场规模排行</h3>
        <span class="chart-hint">按电商规模排序（Unit: Billion USD）</span>
      </div>
      <div ref="chartRef" class="chart-container" style="height: 380px;" />
    </div>

    <!-- ====== 市场详情弹窗 ====== -->
    <el-dialog
      v-model="detailVisible"
      width="600px"
      :title="detailMarket ? countryFlag(detailMarket.code) + ' ' + detailMarket.name : ''"
      class="detail-dialog"
      destroy-on-close
    >
      <template v-if="detailMarket">
        <div class="detail-grid">
          <div class="detail-stat">
            <span class="ds-label">国家代码</span>
            <span class="ds-value">{{ detailMarket.code }}</span>
          </div>
          <div class="detail-stat">
            <span class="ds-label">进入难度</span>
            <span class="ds-value">
              <span class="diff-tag inline" :class="'diff-' + (detailMarket.difficulty === '低' ? 'low' : detailMarket.difficulty === '中' ? 'mid' : 'high')">
                {{ detailMarket.difficulty }}
              </span>
            </span>
          </div>
          <div class="detail-stat">
            <span class="ds-label">电商规模</span>
            <span class="ds-value num">${{ detailMarket.ecomScale }}B</span>
          </div>
          <div class="detail-stat">
            <span class="ds-label">年增长率</span>
            <span class="ds-value num green">+{{ detailMarket.growthRate }}%</span>
          </div>
          <div class="detail-stat">
            <span class="ds-label">TikTok 渗透率</span>
            <span class="ds-value num">{{ detailMarket.tiktokPenetration }}%</span>
          </div>
          <div class="detail-stat">
            <span class="ds-label">热销品类</span>
            <span class="ds-value">
              <span v-for="(cat, ci) in detailMarket.topCategories" :key="ci" class="cat-tag">{{ cat }}</span>
            </span>
          </div>
          <div class="detail-stat full">
            <span class="ds-label">主要电商平台</span>
            <span class="ds-value">
              <span v-for="(p, pi) in detailMarket.platforms" :key="pi" class="plat-tag">{{ p }}</span>
            </span>
          </div>
        </div>

        <!-- 市场分析建议 -->
        <div class="analysis-box">
          <h4 class="analysis-title">📊 市场分析</h4>
          <ul class="analysis-list">
            <li>TikTok 渗透率 {{ detailMarket.tiktokPenetration }}%，{{ detailMarket.tiktokPenetration >= 40 ? '适合通过内容电商切入' : '建议结合传统电商 + 短视频双渠道' }}</li>
            <li>市场年增长率 {{ detailMarket.growthRate }}%，{{ detailMarket.growthRate >= 20 ? '高速增长市场，建议快速布局' : detailMarket.growthRate >= 12 ? '稳步增长，适合深耕' : '成熟市场，建议差异化竞争' }}</li>
            <li>进入难度「{{ detailMarket.difficulty }}」，{{ detailMarket.difficulty === '低' ? '门槛较低，适合新手卖家试水' : detailMarket.difficulty === '中' ? '需要一定资源和本地化能力' : '竞争激烈，建议有品牌和供应链基础再进入' }}</li>
            <li>热销品类：{{ detailMarket.topCategories.join('、') }}，建议优先从这些品类切入</li>
          </ul>
        </div>
      </template>

      <template #footer>
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button type="primary" @click="goToMarketProducts(detailMarket?.code)">
          查看该市场爆品
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { TrendCharts, Monitor, Connection } from '@element-plus/icons-vue'
import { getMarkets } from '@/api/overseas'

// ECharts 动态导入（避免 rollup 构建报错）
let echarts = null
async function loadEcharts() {
  if (!echarts) {
    echarts = await import('echarts/core')
    const { BarChart } = await import('echarts/charts')
    const { GridComponent, TooltipComponent } = await import('echarts/components')
    const { CanvasRenderer } = await import('echarts/renderers')
    echarts.use([BarChart, GridComponent, TooltipComponent, CanvasRenderer])
  }
  return echarts
}

const router = useRouter()

// ====== 时间范围 ======
const timeRanges = [
  { value: '7d', label: '7天' },
  { value: '30d', label: '30天' },
  { value: '90d', label: '90天' }
]
const activeTimeRange = ref('7d')

// ====== 区域筛选 ======
const regionMap = {
  'all': { label: '全部', codes: [] },
  'north-america': { label: '北美', codes: ['US', 'CA', 'MX'] },
  'europe': { label: '欧洲', codes: ['GB', 'DE', 'FR', 'IT', 'ES'] },
  'se-asia': { label: '东南亚', codes: ['ID', 'TH', 'VN', 'PH', 'MY', 'SG'] },
  'south-america': { label: '拉美', codes: ['BR', 'AR', 'CO'] },
  'middle-asia': { label: '中亚', codes: ['KZ', 'UZ'] },
  'middle-east': { label: '中东', codes: ['AE', 'SA'] }
}
const regions = Object.entries(regionMap).map(([value, r]) => ({ value, label: r.label }))
const activeRegion = ref('all')

// ====== 数据 ======
const allMarkets = ref(getMarkets())

const filteredMarkets = computed(() => {
  const region = regionMap[activeRegion.value]
  if (!region || activeRegion.value === 'all') return allMarkets.value
  return allMarkets.value.filter(m => region.codes.includes(m.code))
})

const totalMarketScale = computed(() => filteredMarkets.value.reduce((s, m) => s + m.ecomScale, 0))
const avgGrowthRate = computed(() => {
  const list = filteredMarkets.value
  if (!list.length) return 0
  return (list.reduce((s, m) => s + m.growthRate, 0) / list.length).toFixed(1)
})
const avgTiktokPenetration = computed(() => {
  const list = filteredMarkets.value
  if (!list.length) return 0
  return Math.round(list.reduce((s, m) => s + m.tiktokPenetration, 0) / list.length)
})

function switchRegion(value) {
  activeRegion.value = value
  nextTick(() => updateChart())
}

// ====== 国旗映射 ======
const flagMap = {
  US: '🇺🇸', CA: '🇨🇦', MX: '🇲🇽',
  GB: '🇬🇧', DE: '🇩🇪', FR: '🇫🇷', IT: '🇮🇹', ES: '🇪🇸',
  ID: '🇮🇩', TH: '🇹🇭', VN: '🇻🇳', PH: '🇵🇭', MY: '🇲🇾', SG: '🇸🇬',
  BR: '🇧🇷', AR: '🇦🇷', CO: '🇨🇴',
  KZ: '🇰🇿', UZ: '🇺🇿',
  AE: '🇦🇪', SA: '🇸🇦'
}
function countryFlag(code) { return flagMap[code] || '🌍' }

// ====== ECharts 横向条形图 ======
const chartRef = ref(null)
let chartInstance = null

async function initChart() {
  if (!chartRef.value) return
  if (chartInstance) chartInstance.dispose()

  const ec = await loadEcharts()
  const data = [...filteredMarkets.value].sort((a, b) => a.ecomScale - b.ecomScale)

  const barColors = data.map(m =>
    m.growthRate >= 20 ? '#67C23A' : m.growthRate >= 12 ? '#C9A96E' : '#409EFF'
  )

  const option = {
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'shadow' },
      backgroundColor: '#fff',
      borderColor: '#e8ecf1',
      borderWidth: 1,
      padding: [12, 16],
      extraCssText: 'box-shadow: 0 4px 20px rgba(0,0,0,0.08); border-radius: 8px;',
      formatter: (params) => {
        const m = data[params[0].dataIndex]
        return `<div style="font-size:13px;line-height:1.8;">
          <b>${flagMap[m.code]} ${m.name}</b><br/>
          电商规模：<b>$${m.ecomScale}B</b><br/>
          年增长率：<b>${m.growthRate}%</b><br/>
          TikTok渗透率：${m.tiktokPenetration}%<br/>
          进入难度：${m.difficulty}
        </div>`
      }
    },
    grid: { left: 80, right: 60, top: 10, bottom: 20 },
    xAxis: {
      type: 'value',
      splitLine: { lineStyle: { color: '#F0F2F5', type: 'dashed' } },
      axisLabel: { fontSize: 11, color: '#8A9AA8', formatter: '${value}B' }
    },
    yAxis: {
      type: 'category',
      data: data.map(m => `${flagMap[m.code]} ${m.name}`),
      axisLine: { show: false },
      axisTick: { show: false },
      axisLabel: { fontSize: 12, fontWeight: 500, color: '#4A5A6A' }
    },
    series: [{
      type: 'bar',
      data: data.map((m, i) => ({
        value: m.ecomScale,
        itemStyle: {
          color: barColors[i],
          borderRadius: [0, 6, 6, 0]
        }
      })),
      barWidth: 20,
      label: {
        show: true,
        position: 'right',
        formatter: (p) => `$${data[p.dataIndex].ecomScale}B`,
        fontSize: 11,
        color: '#8A9AA8'
      }
    }]
  }

  chartInstance = ec.init(chartRef.value)
  chartInstance.setOption(option)
}

async function updateChart() {
  if (chartInstance) {
    chartInstance.dispose()
    chartInstance = null
  }
  await initChart()
}

// ====== 详情弹窗 ======
const detailVisible = ref(false)
const detailMarket = ref(null)

function openDetail(market) {
  detailMarket.value = market
  detailVisible.value = true
}

function goToMarketProducts(code) {
  detailVisible.value = false
  router.push(`/overseas/opportunities/product-radar?market=${code}`)
}

// ====== 响应式 ======
function handleResize() { chartInstance?.resize() }

onMounted(() => {
  nextTick(() => initChart())
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  chartInstance?.dispose()
})
</script>

<style scoped>
.market-overview {
  max-width: 1440px;
  margin: 0 auto;
}

/* ====== 页面标题 ====== */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 28px;
  flex-wrap: wrap;
  gap: 16px;
}
.header-left { display: flex; flex-direction: column; gap: 6px; }
.page-title { margin: 0; font-size: 28px; font-weight: 700; color: #1A2A3A; letter-spacing: -0.3px; }
.page-subtitle { margin: 0; font-size: 14px; color: #8A9AA8; }
.header-filters { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }

.filter-group { display: flex; background: #F0F2F5; border-radius: 10px; padding: 3px; }
.filter-btn {
  padding: 6px 16px; border: none; border-radius: 8px;
  background: transparent; color: #8A9AA8; font-size: 13px;
  font-weight: 500; cursor: pointer; transition: all 0.2s;
}
.filter-btn:hover { color: #4A5A6A; }
.filter-btn.active { background: #fff; color: #1A2A3A; box-shadow: 0 1px 4px rgba(0,0,0,0.06); }

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
.kpi-card:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,0.06); }
.kpi-left { display: flex; flex-direction: column; gap: 4px; }
.kpi-label { font-size: 13px; color: #8A9AA8; font-weight: 500; }
.kpi-value { font-size: 28px; font-weight: 700; color: #1A2A3A; letter-spacing: -0.5px; line-height: 1.1; }

.kpi-icon {
  width: 44px; height: 44px; border-radius: 12px;
  display: flex; align-items: center; justify-content: center; color: #fff;
  flex-shrink: 0;
}
.kpi-icon.gold { background: linear-gradient(135deg, #C9A96E, #E8D5A3); }
.kpi-icon.blue { background: linear-gradient(135deg, #409EFF, #79BBFF); }
.kpi-icon.green { background: linear-gradient(135deg, #67C23A, #95D475); }
.kpi-icon.purple { background: linear-gradient(135deg, #A78BFA, #C4B5FD); }

/* ====== 市场卡片网格 ====== */
.market-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin-bottom: 28px;
}
@media (max-width: 1100px) { .market-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 680px) { .market-grid { grid-template-columns: 1fr; } }

.market-card {
  background: #fff;
  border-radius: 16px;
  padding: 22px 24px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
  cursor: pointer;
  transition: all 0.3s;
  animation: cardFadeIn 0.5s ease backwards;
}
@keyframes cardFadeIn { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
.market-card:hover { transform: translateY(-4px); box-shadow: 0 12px 32px rgba(0,0,0,0.08); }

.card-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.card-country { display: flex; align-items: center; gap: 10px; }
.card-flag { font-size: 26px; line-height: 1; }
.card-name { font-size: 16px; font-weight: 700; color: #1A2A3A; }

/* 进入难度标签 */
.diff-tag {
  font-size: 11px; font-weight: 600; padding: 3px 12px; border-radius: 8px; flex-shrink: 0;
}
.diff-low { background: #EDFCF2; color: #52C41A; }
.diff-mid { background: #FFF8E6; color: #E6A23C; }
.diff-high { background: #FEF0F0; color: #F56C6C; }

/* 指标 */
.card-metrics { display: flex; gap: 8px; margin-bottom: 14px; }
.metric-block { flex: 1; padding: 10px 14px; background: #FAFBFC; border-radius: 10px; }
.metric-block.right { text-align: right; }
.metric-label { display: block; font-size: 11px; color: #8A9AA8; margin-bottom: 2px; }
.metric-value { font-size: 18px; font-weight: 700; color: #1A2A3A; }
.growth-up { color: #52C41A; }

/* TikTok 渗透率 */
.penetration-row { display: flex; align-items: center; gap: 10px; margin-bottom: 14px; }
.pen-label { font-size: 11px; color: #8A9AA8; flex-shrink: 0; }
.pen-bar-bg { flex: 1; height: 8px; background: #F0F2F5; border-radius: 4px; overflow: hidden; }
.pen-bar-fill { height: 100%; background: linear-gradient(90deg, #C9A96E, #E8D5A3); border-radius: 4px; transition: width 0.6s; }
.pen-value { font-size: 12px; font-weight: 600; color: #C9A96E; flex-shrink: 0; }

/* 热销品类标签 */
.cat-tags { display: flex; gap: 6px; flex-wrap: wrap; }
.cat-tag {
  font-size: 11px; padding: 3px 10px; border-radius: 6px;
  background: linear-gradient(135deg, #ECF5FF, #E8F4FD); color: #409EFF; font-weight: 500;
}

/* ====== 图表卡片 ====== */
.chart-card {
  background: #fff;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
  margin-bottom: 28px;
}
.chart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; }
.chart-title { margin: 0; font-size: 16px; font-weight: 600; color: #1A2A3A; }
.chart-hint { font-size: 12px; color: #B0BCC8; }
.chart-container { width: 100%; }

/* ====== 详情弹窗 ====== */
.detail-dialog :deep(.el-dialog__body) { padding: 0 20px 20px; }
.detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.detail-stat {
  background: #FAFBFC; border-radius: 10px; padding: 12px 16px;
  display: flex; flex-direction: column; gap: 4px;
}
.detail-stat.full { grid-column: 1 / -1; }
.ds-label { font-size: 11px; color: #8A9AA8; }
.ds-value { font-size: 14px; font-weight: 600; color: #1A2A3A; display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
.ds-value.num { font-size: 18px; }
.ds-value.green { color: #52C41A; }

.plat-tag {
  font-size: 11px; padding: 3px 10px; border-radius: 6px;
  background: #F0F2F5; color: #606266; font-weight: 500;
}

.analysis-box {
  margin-top: 16px; padding: 18px 20px;
  background: linear-gradient(135deg, #FFFDF5, #FFF9E6);
  border-radius: 12px; border: 1px solid #F5EDD0;
}
.analysis-title { margin: 0 0 12px; font-size: 14px; font-weight: 700; color: #C9A96E; }
.analysis-list { margin: 0; padding: 0 0 0 18px; display: flex; flex-direction: column; gap: 8px; }
.analysis-list li { font-size: 13px; color: #4A5A6A; line-height: 1.5; }
.inline { display: inline-block; }

/* ====== 响应式 ====== */
@media (max-width: 768px) {
  .kpi-row { grid-template-columns: repeat(2, 1fr); }
  .page-header { flex-direction: column; align-items: flex-start; }
  .detail-grid { grid-template-columns: 1fr; }
}
@media (max-width: 480px) {
  .kpi-row { grid-template-columns: 1fr; }
}
</style>
