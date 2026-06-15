<template>
  <div
    class="category-block"
    :class="{ 'is-hovered': isHovered }"
    @mouseenter="onMouseEnter"
    @mouseleave="onMouseLeave"
  >
    <div class="block-title">
      <span class="block-name">{{ category.name }}</span>
      <span class="block-change" :class="changeClass">{{ formatChange(category.changeRate) }}</span>
    </div>
    <div class="block-treemap" ref="chartRef" :style="{ height: treemapHeight + 'px' }"></div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, onUnmounted, nextTick, inject } from 'vue'
import * as echarts from 'echarts'
import { useRouter } from 'vue-router'

const GAP = 2

const props = defineProps({
  category: { type: Object, required: true },
  colorMode: { type: String, default: 'red-up' },
  searchKeyword: { type: String, default: '' },
  treemapHeight: { type: Number, default: 280 },
  isHovered: { type: Boolean, default: false }
})

const emit = defineEmits(['card-enter', 'card-leave'])

const router = useRouter()
const chartRef = ref(null)
const containerWidth = ref(300)
let chartInstance = null
let resizeObserver = null

const onMouseEnter = (e) => {
  emit('card-enter', e)
}

const onMouseLeave = () => {
  emit('card-leave')
}

const formatChange = (val) => {
  if (val == null) return '--'
  return (val >= 0 ? '+' : '') + val.toFixed(2) + '%'
}

const changeClass = computed(() => {
  const v = props.category.changeRate
  if (v == null) return ''
  if (v > 1) return props.colorMode === 'red-up' ? 'up' : 'down'
  if (v < -1) return props.colorMode === 'red-up' ? 'down' : 'up'
  return 'neutral'
})

const getBg = (rate) => {
  if (rate == null) return '#f0f0f0'
  if (rate > 1) return props.colorMode === 'red-up' ? '#ffe6e6' : '#e6fffb'
  if (rate < -1) return props.colorMode === 'red-up' ? '#e6fffb' : '#ffe6e6'
  return '#f5f5f5'
}

const getTxt = (rate) => {
  if (rate == null) return '#888'
  if (rate > 1) return props.colorMode === 'red-up' ? '#cf1322' : '#237804'
  if (rate < -1) return props.colorMode === 'red-up' ? '#237804' : '#cf1322'
  return '#666'
}

const labelFontScale = computed(() => {
  const count = (props.category.children || []).length
  const h = props.treemapHeight
  if (h >= 250) {
    if (count <= 4) return 1
    if (count <= 7) return 0.9
    if (count <= 10) return 0.78
    return 0.65
  }
  if (h >= 180) {
    if (count <= 4) return 0.85
    if (count <= 7) return 0.7
    return 0.55
  }
  if (h >= 120) {
    if (count <= 4) return 0.7
    return 0.5
  }
  return 0.4
})

const labelThreshold = computed(() => {
  return 0.035 / labelFontScale.value
})

const buildTreemapOption = () => {
  const children = props.category.children || []
  if (children.length === 0) return null

  const kw = props.searchKeyword.trim().toLowerCase()
  const hasSearch = kw.length > 0
  const scale = labelFontScale.value
  const fs = Math.max(7, Math.round(10 * scale))
  const fsRate = Math.max(7, Math.round(11 * scale))
  const lh = Math.max(10, Math.round(14 * scale))

  const totalVal = children.reduce((s, c) => s + (c.value || c.sales || 1), 0)
  const thresh = labelThreshold.value

  const data = children.map((child) => {
    const isMatch = hasSearch && child.name.toLowerCase().includes(kw)
    const bg = getBg(child.changeRate)
    const txt = getTxt(child.changeRate)
    const val = Math.max(child.value || child.sales || 1, 1)
    const pct = val / totalVal
    const showLabel = pct >= thresh

    const rateStr = child.changeRate != null
      ? (child.changeRate >= 0 ? '+' : '') + child.changeRate.toFixed(2) + '%'
      : '--'
    const nameTrunc = (child.name || '').length > 8
      ? (child.name || '').slice(0, 7) + '…'
      : (child.name || '')

    return {
      name: child.name,
      value: val,
      changeRate: child.changeRate || 0,
      sales: child.sales || child.value || 0,
      volume: child.volume || 0,
      salesChange: child.salesChange,
      volumeChange: child.volumeChange,
      blueOceanIndex: child.blueOceanIndex || 0,
      itemStyle: {
        color: bg,
        borderColor: isMatch ? '#722ed1' : (hasSearch ? 'rgba(0,0,0,0.04)' : '#fff'),
        borderWidth: isMatch ? 3 : 1,
        opacity: (hasSearch && !isMatch) ? 0.25 : 1
      },
      label: {
        show: showLabel,
        color: (hasSearch && !isMatch) ? 'rgba(0,0,0,0.15)' : txt,
        fontSize: fs,
        formatter: showLabel ? `{name|${nameTrunc}}\n{rate|${rateStr}}` : '',
        rich: {
          name: { fontSize: fs, lineHeight: lh },
          rate: { fontSize: fsRate, fontWeight: 'bold', lineHeight: lh }
        }
      }
    }
  })

  return {
    tooltip: { show: false },
    series: [{
      type: 'treemap',
      data,
      width: '100%',
      height: '100%',
      roam: false,
      nodeClick: false,
      breadcrumb: { show: false },
      top: 0, left: 0, right: 0, bottom: 0,
      label: { show: true, position: 'inside' },
      upperLabel: { show: false },
      itemStyle: { borderColor: '#fff', borderWidth: GAP, gapWidth: GAP },
      emphasis: {
        itemStyle: { shadowBlur: 10, shadowColor: 'rgba(0,0,0,0.2)' }
      }
    }]
  }
}

const initChart = () => {
  if (!chartRef.value) return
  if (chartInstance) chartInstance.dispose()
  chartInstance = echarts.init(chartRef.value)

  chartInstance.on('mouseover', (params) => {
    if (!params.data || !params.data.name) return
    const d = params.data
    const totalValue = (props.category.children || []).reduce((s, c) => s + (c.value || c.sales || 0), 0) || 1
    const share = ((d.value || 0) / totalValue * 100).toFixed(2)
    const ev = (params.event && params.event.event) ? params.event.event : { clientX: 0, clientY: 0 }
    showTooltipGlobal({
      path: props.category.name + ' > ' + d.name,
      sales: d.sales || d.value || 0,
      volume: d.volume || 0,
      changeRate: d.changeRate || 0,
      salesChange: d.salesChange != null ? d.salesChange : d.changeRate,
      volumeChange: d.volumeChange != null ? d.volumeChange : d.changeRate,
      share,
      blueOceanIndex: d.blueOceanIndex || 0
    }, ev)
  })

  chartInstance.on('mouseout', () => hideTooltipGlobal())

  chartInstance.on('click', (params) => {
    if (params.data && params.data.name) {
      router.push({
        path: '/shopify/products',
        query: { category: props.category.name, subcategory: params.data.name }
      })
    }
  })

  renderChart()
}

const renderChart = () => {
  if (!chartInstance) return
  const option = buildTreemapOption()
  if (!option) { chartInstance.clear(); return }
  chartInstance.setOption(option, true)
}

const disposeChart = () => {
  if (resizeObserver) { resizeObserver.disconnect(); resizeObserver = null }
  if (chartInstance) { chartInstance.dispose(); chartInstance = null }
}

watch(() => [props.category, props.colorMode, props.searchKeyword], () => {
  nextTick(() => renderChart())
}, { deep: true })

watch(() => props.treemapHeight, (newH) => {
  if (chartInstance && chartRef.value) {
    if (chartRef.value.style) chartRef.value.style.height = newH + 'px'
    chartInstance.resize()
  }
  nextTick(() => {
    if (chartInstance) chartInstance.resize()
    renderChart()
  })
})

const showTooltipGlobal = inject('showCategoryTooltip', () => {})
const hideTooltipGlobal = inject('hideCategoryTooltip', () => {})

onMounted(async () => {
  await nextTick()
  if (chartRef.value) {
    containerWidth.value = chartRef.value.offsetWidth || 300
    initChart()
    resizeObserver = new ResizeObserver(() => {
      if (chartInstance) chartInstance.resize()
      if (chartRef.value) containerWidth.value = chartRef.value.offsetWidth
    })
    resizeObserver.observe(chartRef.value)
  }
})

onUnmounted(() => disposeChart())
</script>

<style scoped>
.category-block {
  display: flex;
  flex-direction: column;
  position: relative;
  overflow: hidden;
  border: 2px solid transparent;
  border-radius: 6px;
  padding: 4px 6px;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.category-block.is-hovered {
  border-color: rgba(124, 77, 255, 0.35);
  box-shadow: 0 0 12px rgba(124, 77, 255, 0.12);
}

.block-title {
  display: flex;
  align-items: baseline;
  gap: 8px;
  margin-bottom: 4px;
  padding: 0 2px;
  flex-shrink: 0;
}

.block-name { font-size: 14px; font-weight: 700; color: #1a1a1a; }
.block-change { font-size: 12px; font-weight: 600; }
.block-change.up { color: #cf1322; }
.block-change.down { color: #237804; }
.block-change.neutral { color: #888; }

.block-treemap {
  flex-shrink: 0;
  border-radius: 2px;
  overflow: hidden;
}
</style>
