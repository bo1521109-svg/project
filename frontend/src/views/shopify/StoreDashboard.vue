<template>
  <div class="store-dashboard-page">
    <div class="header-bar">
      <div class="header-left">
        <h3 class="page-title">店铺大盘</h3>
      </div>
      <div class="header-right">
        <el-select
          v-model="filters.category"
          placeholder="商品分类"
          size="default"
          class="filter-select"
          @change="onFilterChange"
        >
          <el-option
            v-for="cat in categoryOptions"
            :key="cat.value"
            :label="cat.label"
            :value="cat.value"
          />
        </el-select>
        <el-radio-group
          v-model="filters.period"
          size="default"
          class="period-toggle"
          @change="onFilterChange"
        >
          <el-radio-button value="daily">日</el-radio-button>
          <el-radio-button value="weekly">周</el-radio-button>
          <el-radio-button value="monthly">月</el-radio-button>
        </el-radio-group>
        <el-date-picker
          v-model="filters.date"
          type="date"
          placeholder="选择日期"
          size="default"
          class="date-picker"
          value-format="YYYY-MM-DD"
          @change="onFilterChange"
        />
      </div>
    </div>

    <div class="metrics-row">
      <div class="metric-card" v-for="card in metricCards" :key="card.key">
        <div class="metric-icon" :style="{ background: card.color }">
          <el-icon :size="22"><component :is="card.icon" /></el-icon>
        </div>
        <div class="metric-info">
          <div class="metric-title">{{ card.title }}</div>
          <div class="metric-value">{{ card.value }}</div>
        </div>
      </div>
    </div>

    <div class="chart-section">
      <div class="chart-tabs">
        <div
          v-for="tab in storeTabs"
          :key="tab.value"
          class="chart-tab"
          :class="{ active: filters.storeType === tab.value }"
          @click="onTabChange(tab.value)"
        >
          {{ tab.label }}
        </div>
      </div>
      <div class="chart-container" ref="chartContainer">
        <div ref="chartDom" class="chart-dom"></div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted, nextTick, computed } from 'vue'
import {
  Shop, DataAnalysis, TrendCharts, Money, OfficeBuilding
} from '@element-plus/icons-vue'
import request from '@/utils/request'
import * as echarts from 'echarts'
import { shopifyCategories } from '@/config/categories'

const filters = reactive({
  category: 'all',
  period: 'daily',
  date: new Date().toISOString().slice(0, 10),
  storeType: 'all',
})

const metricCards = ref([
  { key: 'dailyActiveStores', title: '日动销店铺数', value: '--', icon: 'Shop', color: '#7c4dff' },
  { key: 'localSalesRatio', title: '本土店销售额占比', value: '--', icon: 'OfficeBuilding', color: '#00bcd4' },
  { key: 'crossBorderSalesRatio', title: '跨境店销售额占比', value: '--', icon: 'DataAnalysis', color: '#ff6d00' },
  { key: 'managedSalesRatio', title: '全托管店销售额占比', value: '--', icon: 'TrendCharts', color: '#4caf50' },
  { key: 'avgStoreSales', title: '店均销售额', value: '--', icon: 'Money', color: '#e91e63' },
])

const categoryOptions = computed(() => {
  const topLevel = shopifyCategories.filter(c => c.value !== 'all')
  return [
    { label: '全部', value: 'all' },
    ...topLevel.map(c => ({ label: c.label, value: c.value })),
  ]
})

const chartDom = ref(null)
const chartContainer = ref(null)
let chartInstance = null
let resizeObserver = null

const storeTabs = [
  { label: '全部', value: 'all' },
  { label: '本土店', value: 'local' },
  { label: '跨境店', value: 'cross_border' },
  { label: '全托管店', value: 'managed' },
]

const AVATAR_COLORS = [
  '#7c4dff', '#00bcd4', '#ff6d00', '#4caf50', '#e91e63',
  '#ff9800', '#2196f3', '#9c27b0', '#009688', '#f44336',
]

const formatCurrency = (val) => {
  if (!val && val !== 0) return '--'
  if (val >= 1000000) return '$' + (val / 1000000).toFixed(2) + 'M'
  if (val >= 1000) return '$' + (val / 1000).toFixed(1) + 'K'
  return '$' + val.toLocaleString()
}

const formatNumber = (val) => {
  if (!val && val !== 0) return '--'
  if (val >= 10000) return (val / 10000).toFixed(2) + '万'
  return val.toLocaleString()
}

const getMockMetrics = () => {
  const seed = (filters.category + filters.period + filters.date).length
  return {
    dailyActiveStores: (4.5 + (seed % 30) / 10).toFixed(2),
    localSalesRatio: (50 + (seed % 20)).toFixed(2),
    crossBorderSalesRatio: (40 + (seed % 10)).toFixed(2),
    managedSalesRatio: (5 + (seed % 10)).toFixed(2),
    avgStoreSales: (900 + (seed % 600)),
  }
}

const getMockTop10 = () => {
  const allStores = [
    { name: 'CollectibleFish', type: 'local', sales: 1285000, avatar_letter: 'C' },
    { name: 'Halara US', type: 'local', sales: 987000, avatar_letter: 'H' },
    { name: 'Bloom Nutrition', type: 'cross_border', sales: 865000, avatar_letter: 'B' },
    { name: 'Bubble Skincare', type: 'local', sales: 743000, avatar_letter: 'B' },
    { name: 'Cupshe', type: 'cross_border', sales: 621000, avatar_letter: 'C' },
    { name: 'Vitality', type: 'managed', sales: 498000, avatar_letter: 'V' },
    { name: 'Gymshark', type: 'local', sales: 385000, avatar_letter: 'G' },
    { name: 'Kylie Cosmetics', type: 'cross_border', sales: 312000, avatar_letter: 'K' },
    { name: 'Fashion Nova', type: 'cross_border', sales: 267000, avatar_letter: 'F' },
    { name: 'YoungLA', type: 'managed', sales: 198000, avatar_letter: 'Y' },
  ]
  const typeStores = {
    local: [
      { name: 'CollectibleFish', type: 'local', sales: 1285000, avatar_letter: 'C' },
      { name: 'Halara US', type: 'local', sales: 987000, avatar_letter: 'H' },
      { name: 'Bubble Skincare', type: 'local', sales: 743000, avatar_letter: 'B' },
      { name: 'Gymshark', type: 'local', sales: 385000, avatar_letter: 'G' },
      { name: 'SKIMS', type: 'local', sales: 342000, avatar_letter: 'S' },
      { name: 'Alo Yoga', type: 'local', sales: 298000, avatar_letter: 'A' },
      { name: 'Drunk Elephant', type: 'local', sales: 254000, avatar_letter: 'D' },
      { name: 'Rhode Skin', type: 'local', sales: 198000, avatar_letter: 'R' },
      { name: 'Glossier', type: 'local', sales: 156000, avatar_letter: 'G' },
      { name: 'Everlane', type: 'local', sales: 112000, avatar_letter: 'E' },
    ],
    cross_border: [
      { name: 'Bloom Nutrition', type: 'cross_border', sales: 865000, avatar_letter: 'B' },
      { name: 'Cupshe', type: 'cross_border', sales: 621000, avatar_letter: 'C' },
      { name: 'Kylie Cosmetics', type: 'cross_border', sales: 312000, avatar_letter: 'K' },
      { name: 'Fashion Nova', type: 'cross_border', sales: 267000, avatar_letter: 'F' },
      { name: 'ColourPop', type: 'cross_border', sales: 234000, avatar_letter: 'C' },
      { name: 'Shein US', type: 'cross_border', sales: 198000, avatar_letter: 'S' },
      { name: 'Tarte', type: 'cross_border', sales: 165000, avatar_letter: 'T' },
      { name: 'PrettyLittleThing', type: 'cross_border', sales: 132000, avatar_letter: 'P' },
      { name: 'Boohoo', type: 'cross_border', sales: 98000, avatar_letter: 'B' },
      { name: 'Missguided', type: 'cross_border', sales: 72000, avatar_letter: 'M' },
    ],
    managed: [
      { name: 'Vitality', type: 'managed', sales: 498000, avatar_letter: 'V' },
      { name: 'YoungLA', type: 'managed', sales: 198000, avatar_letter: 'Y' },
      { name: 'Temu Select', type: 'managed', sales: 176000, avatar_letter: 'T' },
      { name: 'AliExpress Plus', type: 'managed', sales: 145000, avatar_letter: 'A' },
      { name: 'DHgate Pro', type: 'managed', sales: 118000, avatar_letter: 'D' },
      { name: 'Made-in-China', type: 'managed', sales: 95000, avatar_letter: 'M' },
      { name: 'Global Sources', type: 'managed', sales: 72000, avatar_letter: 'G' },
      { name: 'Chinabrands', type: 'managed', sales: 58000, avatar_letter: 'C' },
      { name: 'Banggood Pro', type: 'managed', sales: 42000, avatar_letter: 'B' },
      { name: 'Gearbest Select', type: 'managed', sales: 28000, avatar_letter: 'G' },
    ],
  }
  const stores = filters.storeType === 'all' ? allStores : (typeStores[filters.storeType] || allStores)
  const seed = (filters.category + filters.period + filters.date).length
  const varied = stores.map((s, i) => ({
    ...s,
    sales: Math.round(s.sales * (0.7 + (seed + i) % 7 / 10)),
  }))
  varied.sort((a, b) => b.sales - a.sales)
  const total = varied.reduce((sum, s) => sum + s.sales, 0)
  let cumulative = 0
  varied.forEach(s => {
    cumulative += s.sales
    s.cumulative_ratio = Math.round(cumulative / total * 1000) / 10
  })
  return varied.slice(0, 10)
}

const buildChartOption = (stores) => {
  const names = stores.map(s => s.name.length > 10 ? s.name.slice(0, 10) + '...' : s.name)
  const fullNames = stores.map(s => s.name)
  const salesData = stores.map(s => s.sales)
  const ratioData = stores.map(s => s.cumulative_ratio)
  const avatarLetters = stores.map(s => s.avatar_letter || s.name[0])

  const maxSales = Math.max(...salesData)

  return {
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'cross', crossStyle: { color: '#999' } },
      formatter: (params) => {
        const bar = params.find(p => p.seriesName === '销售额')
        const line = params.find(p => p.seriesName === '累计占比')
        if (!bar) return ''
        return `
          <div style="font-weight:600;margin-bottom:4px">${fullNames[bar.dataIndex]}</div>
          <div style="display:flex;align-items:center;gap:6px">
            <span style="display:inline-block;width:8px;height:8px;border-radius:2px;background:#7c4dff"></span>
            销售额：${formatCurrency(bar.value)}
          </div>
          <div style="display:flex;align-items:center;gap:6px;margin-top:2px">
            <span style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#ff6d00"></span>
            累计占比：${line ? line.value : '--'}%
          </div>
        `
      },
    },
    legend: {
      bottom: 0,
      data: ['销售额', '累计占比'],
      itemWidth: 12,
      itemHeight: 12,
    },
    grid: {
      left: 60,
      right: 60,
      top: 60,
      bottom: 50,
    },
    xAxis: {
      type: 'category',
      data: names,
      axisLabel: {
        fontSize: 11,
        rotate: names.some(n => n.length > 8) ? 30 : 0,
        interval: 0,
      },
      axisTick: { alignWithLabel: true },
    },
    yAxis: [
      {
        type: 'value',
        name: '销售额',
        nameTextStyle: { fontSize: 12, color: '#999' },
        axisLabel: {
          formatter: (val) => val >= 1000000 ? (val / 1000000).toFixed(1) + 'M'
            : val >= 1000 ? (val / 1000).toFixed(0) + 'K' : val,
          fontSize: 11,
        },
        splitLine: { lineStyle: { color: '#f0f0f0', type: 'dashed' } },
      },
      {
        type: 'value',
        name: '累计占比(%)',
        nameTextStyle: { fontSize: 12, color: '#999' },
        min: 0,
        max: 100,
        axisLabel: { formatter: '{value}%', fontSize: 11 },
        splitLine: { show: false },
      },
    ],
    series: [
      {
        name: '销售额',
        type: 'bar',
        data: salesData.map((val, i) => ({
          value: val,
          itemStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: '#7c4dff' },
              { offset: 1, color: '#b39aff' },
            ]),
            borderRadius: [6, 6, 0, 0],
          },
          emphasis: {
            itemStyle: { color: '#651fff' },
          },
        })),
        barWidth: 28,
        label: {
          show: true,
          position: 'top',
          distance: 32,
          formatter: (params) => {
            const idx = params.dataIndex
            const letter = avatarLetters[idx]
            const color = AVATAR_COLORS[idx % AVATAR_COLORS.length]
            return `{avatar|${letter}}`
          },
          rich: {
            avatar: {
              backgroundColor: AVATAR_COLORS[0],
              color: '#fff',
              borderRadius: 24,
              width: 34,
              height: 34,
              lineHeight: 34,
              align: 'center',
              fontSize: 14,
              fontWeight: 'bold',
              borderWidth: 2,
              borderColor: '#fff',
            },
          },
          fontSize: 14,
        },
      },
      {
        name: '累计占比',
        type: 'line',
        yAxisIndex: 1,
        data: ratioData.map(val => ({
          value: val,
          itemStyle: { color: '#ff6d00' },
        })),
        lineStyle: { color: '#ff6d00', width: 2 },
        symbol: 'circle',
        symbolSize: 8,
        itemStyle: { color: '#ff6d00', borderColor: '#fff', borderWidth: 2 },
        label: {
          show: true,
          formatter: '{c}%',
          fontSize: 10,
          color: '#ff6d00',
          position: 'top',
          distance: 8,
        },
      },
    ],
  }
}

const updateChart = (stores) => {
  if (!chartInstance) return
  const option = buildChartOption(stores)
  chartInstance.setOption(option, true)
}

const updateMetrics = (data) => {
  metricCards.value[0].value = data.dailyActiveStores + '万'
  metricCards.value[1].value = data.localSalesRatio + '%'
  metricCards.value[2].value = data.crossBorderSalesRatio + '%'
  metricCards.value[3].value = data.managedSalesRatio + '%'
  metricCards.value[4].value = '$' + data.avgStoreSales
}

const fetchData = async () => {
  try {
    const [metricsRes, top10Res] = await Promise.all([
      request.get('/v1/shopify/store/overview/metrics', {
        params: {
          category: filters.category,
          period: filters.period,
          date: filters.date,
        },
      }),
      request.get('/v1/shopify/store/overview/top10', {
        params: {
          store_type: filters.storeType,
          category: filters.category,
          period: filters.period,
          date: filters.date,
        },
      }),
    ])
    if (metricsRes.data && metricsRes.data.code === 200) {
      updateMetrics(metricsRes.data.data)
    }
    if (top10Res.data && top10Res.data.code === 200) {
      updateChart(top10Res.data.data.stores)
    }
  } catch (err) {
    console.warn('API unavailable, using mock data:', err.message)
    updateMetrics(getMockMetrics())
    updateChart(getMockTop10())
  }
}

const onFilterChange = () => {
  fetchData()
}

const onTabChange = (type) => {
  filters.storeType = type
  fetchData()
}

const initChart = () => {
  if (!chartDom.value) return
  chartInstance = echarts.init(chartDom.value)
}

onMounted(() => {
  nextTick(() => {
    initChart()
    fetchData()
  })
  resizeObserver = new ResizeObserver(() => {
    if (chartInstance) chartInstance.resize()
  })
  if (chartDom.value) resizeObserver.observe(chartDom.value)
})

onUnmounted(() => {
  if (resizeObserver) { resizeObserver.disconnect(); resizeObserver = null }
  if (chartInstance) { chartInstance.dispose(); chartInstance = null }
})
</script>

<style scoped>
.store-dashboard-page {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 60px);
  background: #f0f2f5;
  overflow: hidden;
}

.header-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 24px;
  background: #fff;
  border-bottom: 1px solid #e8e8e8;
  flex-shrink: 0;
}

.header-left {
  display: flex;
  align-items: center;
}

.page-title {
  font-size: 18px;
  font-weight: 600;
  color: #1a1a1a;
  margin: 0;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.filter-select {
  width: 140px;
}

.period-toggle {
  flex-shrink: 0;
}

.date-picker {
  width: 150px;
}

.metrics-row {
  display: flex;
  gap: 16px;
  padding: 16px 24px;
  flex-shrink: 0;
}

.metric-card {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 14px;
  background: #fff;
  border-radius: 10px;
  padding: 16px 20px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
  transition: box-shadow 0.2s, transform 0.2s;
}

.metric-card:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
  transform: translateY(-2px);
}

.metric-icon {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}

.metric-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.metric-title {
  font-size: 12px;
  color: #8c8c8c;
  white-space: nowrap;
}

.metric-value {
  font-size: 22px;
  font-weight: 700;
  color: #1a1a1a;
  letter-spacing: -0.5px;
}

.chart-section {
  flex: 1;
  margin: 0 24px 16px;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.chart-tabs {
  display: flex;
  gap: 0;
  padding: 12px 20px 0;
  border-bottom: 1px solid #f0f0f0;
  flex-shrink: 0;
}

.chart-tab {
  padding: 8px 20px;
  font-size: 14px;
  color: #666;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  transition: color 0.2s, border-color 0.2s;
  user-select: none;
}

.chart-tab:hover {
  color: #7c4dff;
}

.chart-tab.active {
  color: #7c4dff;
  font-weight: 600;
  border-bottom-color: #7c4dff;
}

.chart-container {
  flex: 1;
  position: relative;
  overflow: hidden;
}

.chart-dom {
  width: 100%;
  height: 100%;
}
</style>
