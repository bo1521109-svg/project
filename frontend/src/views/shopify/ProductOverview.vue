<template>
  <div class="product-overview-page">
    <div class="header-bar">
      <div class="breadcrumb">
        <span
          class="breadcrumb-item"
          :class="{ active: viewMode !== 'empty' }"
          @click="goToLevel1"
        >商品销售额占比</span>
        <template v-if="viewMode === 'level2' || viewMode === 'level3' || viewMode === 'empty'">
          <span class="breadcrumb-sep">&gt;</span>
          <span
            class="breadcrumb-item"
            :class="{ active: viewMode === 'level3' || viewMode === 'empty' }"
            @click="viewMode === 'level3' || viewMode === 'empty' ? goToLevel2() : null"
          >{{ level1Name }}</span>
        </template>
        <template v-if="viewMode === 'level3' || viewMode === 'empty'">
          <span class="breadcrumb-sep">&gt;</span>
          <span class="breadcrumb-item current">{{ level2Name }}</span>
        </template>
      </div>
      <div class="header-right">
        <span v-if="viewMode === 'empty'" class="empty-tip">暂无三级数据</span>
        <span v-else class="tip-text">点击矩形查看详情</span>
      </div>
    </div>

    <div class="treemap-container" ref="chartContainer">
      <div ref="chartDom" class="chart-dom"></div>
      <div v-if="viewMode === 'empty'" class="empty-state">
        <div class="empty-icon">📭</div>
        <div class="empty-text">该二级类目暂无三级明细数据</div>
        <div class="empty-sub">请通过商品搜索页直接查看</div>
        <el-button type="primary" size="small" @click="goToLevel2">返回上级</el-button>
      </div>
      <div
        v-if="tooltipVisible"
        class="custom-tooltip"
        :style="tooltipStyle"
      >
        <div class="tooltip-header">{{ tooltipData.name }}</div>
        <div class="tooltip-body">
          <div class="tooltip-row">
            <span class="tooltip-label">销售额</span>
            <span class="tooltip-value">{{ formatCurrency(tooltipData.sales) }}</span>
          </div>
          <div class="tooltip-row">
            <span class="tooltip-label">销售额环比</span>
            <span class="tooltip-value" :class="getChangeClass(tooltipData.changeRate)">
              {{ formatChange(tooltipData.changeRate) }}
            </span>
          </div>
          <div class="tooltip-row">
            <span class="tooltip-label">销量</span>
            <span class="tooltip-value">{{ formatNumber(tooltipData.volume) }}</span>
          </div>
          <div class="tooltip-row">
            <span class="tooltip-label">蓝海指数</span>
            <span class="tooltip-value blue-index">{{ tooltipData.blueOceanIndex }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import request from '@/utils/request'
import * as echarts from 'echarts'

const router = useRouter()

const viewMode = ref('level1')
const level1Name = ref('')
const level2Name = ref('')
const level1Code = ref('')
const level1Data = ref([])
const level2Data = ref([])

const chartContainer = ref(null)
const chartDom = ref(null)
let chartInstance = null
let resizeObserver = null

const tooltipVisible = ref(false)
const tooltipData = ref({})
const tooltipStyle = ref({})

const formatCurrency = (val) => {
  if (!val && val !== 0) return '--'
  if (val >= 1000000) return '$' + (val / 1000000).toFixed(1) + 'M'
  if (val >= 1000) return '$' + (val / 1000).toFixed(1) + 'K'
  return '$' + val.toLocaleString()
}

const formatNumber = (val) => {
  if (!val && val !== 0) return '--'
  if (val >= 10000) return (val / 10000).toFixed(1) + '万'
  return val.toLocaleString()
}

const formatChange = (val) => {
  if (val == null) return '--'
  const prefix = val >= 0 ? '+' : ''
  return prefix + val.toFixed(2) + '%'
}

const getChangeClass = (val) => {
  if (val == null) return ''
  return val >= 0 ? 'change-up' : 'change-down'
}

const LIGHT_BG = '#b39aff'
const HOVER_BG = '#7c4dff'

const buildTreemapOption = (data) => {
  const total = data.length
  return {
    tooltip: { show: false },
    series: [{
      type: 'treemap',
      roam: false,
      nodeClick: false,
      width: '100%',
      height: '100%',
      breadcrumb: { show: false },
      label: {
        show: true,
        formatter: (params) => {
          const d = params.data
          const rate = d.changeRate
          const prefix = rate >= 0 ? '+' : ''
          const name = d.name.length > 6 ? d.name.slice(0, 6) + '...' : d.name
          return `{name|${name}}\n{rate|${prefix}${rate.toFixed(1)}%}`
        },
        rich: {
          name: {
            fontSize: 14,
            fontWeight: 'bold',
            color: '#fff',
            textShadowColor: 'rgba(0,0,0,0.3)',
            textShadowBlur: 2,
            lineHeight: 20,
          },
          rate: {
            fontSize: 16,
            fontWeight: 'bold',
            color: '#fff',
            textShadowColor: 'rgba(0,0,0,0.3)',
            textShadowBlur: 2,
            lineHeight: 24,
          },
        },
        position: 'inside',
      },
      itemStyle: {
        borderColor: '#fff',
        borderWidth: 3,
        borderRadius: 6,
        gapWidth: 3,
      },
      data: data.map((item) => ({
        ...item,
        itemStyle: {
          color: LIGHT_BG,
          borderColor: '#fff',
          borderWidth: 3,
          borderRadius: 6,
        },
        emphasis: {
          itemStyle: {
            color: HOVER_BG,
            shadowBlur: 10,
            shadowOffsetY: -4,
            shadowColor: 'rgba(0,0,0,0.3)',
          },
        },
      })),
    }],
  }
}

const fetchLevel1 = async () => {
  try {
    const res = await request.get('/v1/shopify/product/overview/level1')
    if (res.data && res.data.code === 200) {
      level1Data.value = res.data.data.categories
      viewMode.value = 'level1'
      level1Name.value = ''
      level2Name.value = ''
      level1Code.value = ''
      renderChart(res.data.data.categories)
    }
  } catch (err) {
    console.error('Failed to fetch level1 data:', err)
  }
}

const fetchLevel2 = async (code, name) => {
  try {
    const res = await request.get('/v1/shopify/product/overview/level2', {
      params: { parent_code: code }
    })
    if (res.data && res.data.code === 200) {
      level2Data.value = res.data.data.categories
      level1Name.value = name || res.data.data.parentName
      level1Code.value = code
      viewMode.value = 'level2'
      renderChart(res.data.data.categories)
    }
  } catch (err) {
    console.error('Failed to fetch level2 data:', err)
  }
}

const fetchLevel3 = async (l2Code, l2Name) => {
  try {
    const res = await request.get('/v1/shopify/product/overview/level3', {
      params: { parent_code: level1Code.value, level2_code: l2Code }
    })
    if (res.data && res.data.code === 200) {
      if (res.data.data.empty) {
        level2Name.value = l2Name
        viewMode.value = 'empty'
      } else {
        level2Name.value = l2Name
        viewMode.value = 'level3'
        renderChart(res.data.data.categories)
      }
    }
  } catch (err) {
    console.error('Failed to fetch level3 data:', err)
  }
}

const renderChart = (data) => {
  if (!chartInstance) return
  const option = buildTreemapOption(data)
  chartInstance.setOption(option, true)
}

const goToLevel1 = () => {
  if (level1Data.value.length > 0) {
    viewMode.value = 'level1'
    level1Name.value = ''
    level2Name.value = ''
    level1Code.value = ''
    renderChart(level1Data.value)
  }
}

const goToLevel2 = () => {
  if (level2Data.value.length > 0) {
    viewMode.value = 'level2'
    level2Name.value = ''
    renderChart(level2Data.value)
  }
}

const onTreemapClick = (params) => {
  const d = params.data
  if (!d) return
  if (viewMode.value === 'level1' && d.code) {
    fetchLevel2(d.code, d.name)
  } else if (viewMode.value === 'level2' && d.code) {
    if (d.hasLevel3) {
      fetchLevel3(d.code, d.name)
    } else {
      level2Name.value = d.name
      viewMode.value = 'empty'
    }
  } else if (viewMode.value === 'level3') {
    router.push({
      path: '/shopify/products',
      query: { category: level1Name.value, subCategory: level2Name.value, thirdCategory: d.name }
    })
  }
}

const updateTooltipPosition = (event) => {
  if (!chartContainer.value) return
  const rect = chartContainer.value.getBoundingClientRect()
  tooltipStyle.value = {
    left: Math.min(event.clientX - rect.left + 16, rect.width - 220) + 'px',
    top: Math.max(event.clientY - rect.top - 100, 10) + 'px',
  }
}

const initChart = () => {
  if (!chartDom.value) return
  chartInstance = echarts.init(chartDom.value)

  chartInstance.on('mouseover', (params) => {
    const d = params.data
    if (!d || d.changeRate == null) { tooltipVisible.value = false; return }
    tooltipData.value = {
      name: d.name,
      changeRate: d.changeRate,
      sales: d.sales || d.value,
      volume: d.volume || 0,
      blueOceanIndex: d.blueOceanIndex || 0,
    }
    if (params.event && params.event.event) {
      updateTooltipPosition(params.event.event)
    }
    tooltipVisible.value = true
  })

  chartInstance.on('mousemove', (params) => {
    if (params.event && params.event.event) updateTooltipPosition(params.event.event)
  })

  chartInstance.on('mouseout', () => { tooltipVisible.value = false })
  chartInstance.on('click', onTreemapClick)
}

onMounted(() => {
  nextTick(() => {
    initChart()
    fetchLevel1()
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
.product-overview-page {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 120px);
  background: #f0f2f5;
  overflow: hidden;
}

.header-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 24px;
  background: #fff;
  border-bottom: 1px solid #e8e8e8;
  flex-shrink: 0;
}

.breadcrumb {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
}

.breadcrumb-item {
  color: #666;
  cursor: default;
  transition: color 0.2s;
}

.breadcrumb-item.active {
  color: #7c4dff;
  cursor: pointer;
}

.breadcrumb-item.active:hover {
  color: #651fff;
  text-decoration: underline;
}

.breadcrumb-item.current {
  color: #1a1a1a;
  font-weight: 600;
}

.breadcrumb-sep {
  color: #bbb;
  margin: 0 4px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.tip-text {
  font-size: 13px;
  color: #999;
}

.empty-tip {
  font-size: 13px;
  color: #faad14;
}

.treemap-container {
  flex: 1;
  position: relative;
  overflow: hidden;
  margin: 12px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}

.chart-dom {
  width: 100%;
  height: 100%;
}

.empty-state {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #fff;
  z-index: 10;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.empty-text {
  font-size: 16px;
  color: #666;
  margin-bottom: 8px;
}

.empty-sub {
  font-size: 13px;
  color: #999;
  margin-bottom: 20px;
}

.custom-tooltip {
  position: absolute;
  z-index: 9999;
  background: rgba(255,255,255,0.97);
  border-radius: 10px;
  box-shadow: 0 6px 24px rgba(0,0,0,0.18);
  padding: 14px 18px;
  min-width: 190px;
  pointer-events: none;
}

.tooltip-header {
  font-size: 14px;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 10px;
  padding-bottom: 8px;
  border-bottom: 1px solid #f0f0f0;
}

.tooltip-body {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.tooltip-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.tooltip-label {
  font-size: 12px;
  color: #8c8c8c;
}

.tooltip-value {
  font-size: 13px;
  font-weight: 600;
  color: #333;
}

.change-up { color: #ff4d4f; }
.change-down { color: #52c41a; }
.blue-index { color: #7c4dff; font-weight: 700; }
</style>
