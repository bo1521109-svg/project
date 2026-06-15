<template>
  <div class="category-overview">
    <div class="top-bar">
      <el-input
        v-model="searchKeyword"
        placeholder="输入三级分类关键词搜索"
        class="search-input"
        clearable
        size="default"
      >
        <template #prefix>
          <el-icon class="search-icon"><Search /></el-icon>
        </template>
      </el-input>

      <div class="color-mode-select">
        <el-select v-model="colorMode" size="default" class="select-inline">
          <el-option label="红涨绿跌" value="red-up" />
          <el-option label="红跌绿涨" value="red-down" />
        </el-select>
      </div>

      <div class="sort-bar">
        <span class="sort-label-text">排序：</span>
        <span
          v-for="s in sortOptions"
          :key="s.value"
          class="sort-item"
          :class="{ active: sortBy === s.value }"
          @click="setSortBy(s.value)"
        >
          {{ s.label }}
          <el-icon v-if="sortBy === s.value" class="sort-arrow"><ArrowDown /></el-icon>
          <el-tooltip
            v-if="s.value === 'blueOceanIndex'"
            content="体现品类竞争程度，指数越高代表该品类越值得进入，综合考量市场容量与竞争饱和度"
            placement="top"
          >
            <el-icon class="info-icon"><QuestionFilled /></el-icon>
          </el-tooltip>
        </span>
      </div>

      <div class="time-bar">
        <el-button-group class="time-btns">
          <el-button
            :type="timePreset === 'day' ? 'primary' : ''"
            size="small"
            @click="setTimePreset('day')"
          >日</el-button>
          <el-button
            :type="timePreset === 'week' ? 'primary' : ''"
            size="small"
            @click="setTimePreset('week')"
          >周</el-button>
          <el-button
            :type="timePreset === 'month' ? 'primary' : ''"
            size="small"
            @click="setTimePreset('month')"
          >月</el-button>
        </el-button-group>
      </div>

      <div class="date-picker-wrap">
        <el-date-picker
          v-model="currentDate"
          type="date"
          :clearable="false"
          size="small"
          class="date-inline"
          format="YYYY年M月D日"
          value-format="YYYY-MM-DD"
        />
        <div class="date-nav">
          <el-icon class="nav-icon" @click="prevDay"><ArrowLeft /></el-icon>
          <el-icon class="nav-icon" @click="nextDay"><ArrowRight /></el-icon>
        </div>
      </div>
    </div>

    <div class="body-area" ref="bodyRef" v-loading="loading">
      <div class="category-columns" :style="columnsStyle">
        <template v-for="cat in sortedCategories" :key="cat.name">
          <CategoryBlock
            v-if="cat.children && cat.children.length > 0"
            :category="cat"
            :color-mode="colorMode"
            :search-keyword="searchKeyword"
            :treemap-height="getTreemapHeight(cat)"
            :is-hovered="hoveredCategory === cat.name"
            :style="getCardStyle(cat)"
            @card-enter="onCardEnter($event, cat)"
            @card-leave="onCardLeave"
          />
          <div v-else class="empty-block" :style="{ minHeight: '100px' }">
            <div class="block-title-placeholder">
              <span class="block-name">{{ cat.name }}</span>
              <span class="block-change neutral">--</span>
            </div>
            <div class="empty-body">暂无数据</div>
          </div>
        </template>
      </div>
    </div>

    <Teleport to="body">
      <div
        v-if="tooltipVisible"
        class="global-tooltip"
        :style="tooltipPosition"
      >
        <div class="ttp-header">{{ tooltipData.path }}</div>
        <div class="ttp-body">
          <div class="ttp-row"><span class="ttp-label">销售额</span><span class="ttp-val">{{ formatCurrency(tooltipData.sales) }}</span></div>
          <div class="ttp-row"><span class="ttp-label">销售额环比</span><span class="ttp-val" :style="getRateStyle(tooltipData.salesChange || tooltipData.changeRate)">{{ formatChange(tooltipData.salesChange != null ? tooltipData.salesChange : tooltipData.changeRate) }}</span></div>
          <div class="ttp-row"><span class="ttp-label">销量</span><span class="ttp-val">{{ formatNumber(tooltipData.volume) }}</span></div>
          <div class="ttp-row"><span class="ttp-label">销量环比</span><span class="ttp-val" :style="getRateStyle(tooltipData.volumeChange != null ? tooltipData.volumeChange : tooltipData.changeRate)">{{ formatChange(tooltipData.volumeChange != null ? tooltipData.volumeChange : tooltipData.changeRate) }}</span></div>
          <div class="ttp-row"><span class="ttp-label">大盘占比</span><span class="ttp-val">{{ tooltipData.share }}%</span></div>
          <div class="ttp-row"><span class="ttp-label">蓝海指数</span><span class="ttp-val blue">{{ tooltipData.blueOceanIndex || '--' }}</span></div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, provide, onMounted, onUnmounted, nextTick } from 'vue'
import { Search, ArrowDown, ArrowLeft, ArrowRight, QuestionFilled } from '@element-plus/icons-vue'
import request from '@/utils/request'
import CategoryBlock from '@/components/Shopify/CategoryBlock.vue'

const searchKeyword = ref('')
const colorMode = ref('red-up')
const sortBy = ref('sales')
const timePreset = ref('day')
const currentDate = ref('')
const loading = ref(false)
const rawCategories = ref([])

const bodyRef = ref(null)
const bodyWidth = ref(1200)
const bodyHeight = ref(800)
let bodyResizeObserver = null

const TITLE_H = 28
const GAP = 10

const GRID_COLS = computed(() => {
  if (bodyWidth.value >= 1600) return 5
  if (bodyWidth.value >= 1200) return 4
  if (bodyWidth.value >= 900) return 3
  return 2
})

const columnsStyle = computed(() => ({
  gridTemplateColumns: `repeat(${GRID_COLS.value}, 1fr)`,
  gridAutoRows: '28px',
  gap: '5px'
}))

const catSalesCache = computed(() => {
  const map = {}
  for (const cat of sortedCategories.value) {
    const children = cat.children || []
    map[cat.name] = cat.value || children.reduce((s, c) => s + (c.value || c.sales || 0), 0)
  }
  return map
})

const maxSales = computed(() => {
  const vals = Object.values(catSalesCache.value)
  return vals.length > 0 ? Math.max(...vals) : 1
})

const totalSales = computed(() => {
  return Object.values(catSalesCache.value).reduce((s, v) => s + v, 0)
})

const getTreemapHeight = (cat) => {
  const span = getCardSpan(cat)
  return Math.max(32, span * 33 - 28)
}

const ROW_H = 33

const availableRows = computed(() => {
  return Math.max(10, Math.floor((bodyHeight.value - 12) / ROW_H))
})

const cardSpanMap = computed(() => {
  const cats = sortedCategories.value
  const cols = GRID_COLS.value
  const maxRows = availableRows.value
  const map = {}

  const colCats = Array.from({ length: cols }, () => [])
  for (let i = 0; i < cats.length; i++) {
    colCats[i % cols].push(cats[i])
  }

  for (const col of colCats) {
    if (col.length === 0) continue
    const salesList = col.map(c => catSalesCache.value[c.name] || 1)
    const colTotal = salesList.reduce((s, v) => s + v, 0)
    let spans = salesList.map(s => Math.max(3, Math.round((s / colTotal) * maxRows)))
    let sum = spans.reduce((s, v) => s + v, 0)
    if (sum > maxRows) {
      const factor = maxRows / sum
      spans = spans.map(s => Math.max(3, Math.round(s * factor)))
      sum = spans.reduce((s, v) => s + v, 0)
    }
    while (sum > maxRows) {
      const maxIdx = spans.indexOf(Math.max(...spans))
      if (spans[maxIdx] > 3) { spans[maxIdx]--; sum-- } else break
    }
    while (sum < maxRows) {
      const maxIdx = spans.indexOf(Math.max(...spans))
      spans[maxIdx]++; sum++
    }
    for (let j = 0; j < col.length; j++) {
      map[col[j].name] = spans[j]
    }
  }
  return map
})

const getCardSpan = (cat) => {
  return cardSpanMap.value[cat.name] || 3
}

const getCardStyle = (cat) => {
  return { gridRowEnd: `span ${getCardSpan(cat)}` }
}

const hoveredCategory = ref(null)

const onCardEnter = (event, cat) => {
  hoveredCategory.value = cat.name
  const children = cat.children || []
  const totalVal = catSalesCache.value[cat.name] || 1
  const globalTotal = totalSales.value || 1
  const totalVol = children.reduce((s, c) => s + (c.volume || 0), 0)
  showCategoryTooltip({
    path: cat.name,
    sales: totalVal,
    volume: totalVol,
    changeRate: cat.changeRate || 0,
    salesChange: cat.changeRate,
    volumeChange: cat.changeRate,
    share: ((totalVal / globalTotal) * 100).toFixed(2),
    blueOceanIndex: children.length > 0
      ? (children.reduce((s, c) => s + (c.blueOceanIndex || 0), 0) / children.length).toFixed(1)
      : '--'
  }, event)
}

const onCardLeave = () => {
  hoveredCategory.value = null
  hideCategoryTooltip()
}

const sortOptions = [
  { label: '销售额', value: 'sales' },
  { label: '销售额环比', value: 'salesChange' },
  { label: '销量', value: 'volume' },
  { label: '销量环比', value: 'volumeChange' },
  { label: '蓝海指数', value: 'blueOceanIndex' }
]

const tooltipVisible = ref(false)
const tooltipData = ref({})
const tooltipPosition = ref({})

const formatCurrency = (val) => {
  if (!val && val !== 0) return '--'
  if (val >= 1000000) return '$' + (val / 1000000).toFixed(2) + 'M'
  if (val >= 1000) return '$' + (val / 1000).toFixed(1) + 'K'
  return '$' + val.toFixed(0)
}

const formatNumber = (val) => {
  if (!val && val !== 0) return '--'
  if (val >= 10000) return (val / 10000).toFixed(1) + '万'
  return val.toLocaleString()
}

const formatChange = (val) => {
  if (val == null) return '--'
  return (val >= 0 ? '+' : '') + val.toFixed(2) + '%'
}

const getRateStyle = (rate) => {
  if (rate == null) return {}
  if (rate > 1) return { color: colorMode.value === 'red-up' ? '#cf1322' : '#237804' }
  if (rate < -1) return { color: colorMode.value === 'red-up' ? '#237804' : '#cf1322' }
  return { color: '#888' }
}

const computeSortValue = (cat, metric) => {
  const children = cat.children || []
  if (children.length === 0) return 0
  switch (metric) {
    case 'sales':
      return cat.value || children.reduce((s, c) => s + (c.value || c.sales || 0), 0)
    case 'salesChange':
      return cat.changeRate || children.reduce((s, c) => s + (c.changeRate || 0), 0) / children.length
    case 'volume':
      return children.reduce((s, c) => s + (c.volume || 0), 0)
    case 'volumeChange':
      return children.reduce((s, c) => s + (c.volumeChange || 0), 0) / (children.length || 1)
    case 'blueOceanIndex':
      return children.reduce((s, c) => s + (c.blueOceanIndex || 0), 0) / (children.length || 1)
    default:
      return 0
  }
}

const sortChildren = (children, metric) => {
  const sorted = [...children]
  sorted.sort((a, b) => {
    let aVal, bVal
    switch (metric) {
      case 'sales': aVal = a.value || a.sales || 0; bVal = b.value || b.sales || 0; break
      case 'salesChange': aVal = a.changeRate || 0; bVal = b.changeRate || 0; break
      case 'volume': aVal = a.volume || 0; bVal = b.volume || 0; break
      case 'volumeChange': aVal = a.volumeChange || 0; bVal = b.volumeChange || 0; break
      case 'blueOceanIndex': aVal = a.blueOceanIndex || 0; bVal = b.blueOceanIndex || 0; break
      default: aVal = 0; bVal = 0
    }
    return bVal - aVal
  })
  return sorted
}

const sortedCategories = computed(() => {
  const cats = rawCategories.value.map(cat => ({
    ...cat,
    children: sortChildren(cat.children || [], sortBy.value)
  }))
  cats.sort((a, b) => computeSortValue(b, sortBy.value) - computeSortValue(a, sortBy.value))
  return cats
})

const showCategoryTooltip = (data, event) => {
  tooltipData.value = data
  const x = Math.min(event.clientX + 16, window.innerWidth - 240)
  const y = Math.min(event.clientY - 80, window.innerHeight - 260)
  tooltipPosition.value = { left: x + 'px', top: y + 'px' }
  tooltipVisible.value = true
}

const hideCategoryTooltip = () => {
  tooltipVisible.value = false
}

provide('showCategoryTooltip', showCategoryTooltip)
provide('hideCategoryTooltip', hideCategoryTooltip)

const setSortBy = (val) => {
  sortBy.value = val
}

const setTimePreset = (preset) => {
  timePreset.value = preset
  const today = new Date()
  const target = new Date(today)
  if (preset === 'day') target.setDate(today.getDate() - 1)
  else if (preset === 'week') target.setDate(today.getDate() - 7)
  else target.setMonth(today.getMonth() - 1)
  currentDate.value = target.toISOString().split('T')[0]
}

const prevDay = () => {
  const d = new Date(currentDate.value || Date.now())
  d.setDate(d.getDate() - 1)
  currentDate.value = d.toISOString().split('T')[0]
}

const nextDay = () => {
  const d = new Date(currentDate.value || Date.now())
  d.setDate(d.getDate() + 1)
  currentDate.value = d.toISOString().split('T')[0]
}

const fetchData = async () => {
  loading.value = true
  try {
    const params = { sort_by: sortBy.value, color_mode: colorMode.value }
    if (currentDate.value) {
      params.date_to = currentDate.value
    }
    const res = await request.get('/v1/shopify/category/overview', { params })
    if (res.data && res.data.code === 200 && res.data.data) {
      rawCategories.value = res.data.data.categories || []
    } else {
      rawCategories.value = []
    }
  } catch (e) {
    console.error('获取品类数据失败:', e)
    rawCategories.value = []
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  const today = new Date()
  currentDate.value = today.toISOString().split('T')[0]
  nextTick(() => {
    fetchData()
    if (bodyRef.value) {
      bodyWidth.value = bodyRef.value.clientWidth
      bodyHeight.value = bodyRef.value.clientHeight
      bodyResizeObserver = new ResizeObserver((entries) => {
        for (const entry of entries) {
          bodyWidth.value = entry.contentRect.width
          bodyHeight.value = entry.contentRect.height
        }
      })
      bodyResizeObserver.observe(bodyRef.value)
    }
  })
})

onUnmounted(() => {
  if (bodyResizeObserver) { bodyResizeObserver.disconnect(); bodyResizeObserver = null }
})
</script>

<style scoped>
.category-overview {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 120px);
  background: #fff;
  overflow: hidden;
}

.top-bar {
  display: flex;
  align-items: center;
  padding: 10px 20px;
  background: #fff;
  border-bottom: 1px solid #e8e8e8;
  flex-shrink: 0;
  gap: 0;
  height: 52px;
  box-sizing: border-box;
}

.search-input { width: 220px; flex-shrink: 0; }
.search-input :deep(.el-input__wrapper) { border-radius: 20px; }
.search-icon { color: #999; }
.color-mode-select { margin-left: 16px; flex-shrink: 0; }
.select-inline { width: 130px; }

.sort-bar {
  display: flex;
  align-items: center;
  margin-left: 24px;
  gap: 4px;
  flex-shrink: 0;
}
.sort-label-text { font-size: 13px; color: #666; margin-right: 4px; }
.sort-item {
  font-size: 13px;
  color: #999;
  cursor: pointer;
  padding: 4px 10px;
  border-radius: 4px;
  white-space: nowrap;
  display: inline-flex;
  align-items: center;
  gap: 2px;
  transition: color 0.2s;
}
.sort-item:hover { color: #555; }
.sort-item.active { color: #1a1a1a; font-weight: 600; }
.sort-arrow { font-size: 10px; }
.info-icon { font-size: 14px; color: #bbb; margin-left: 2px; }

.time-bar { margin-left: 24px; flex-shrink: 0; }
.time-btns :deep(.el-button) { padding: 4px 12px; }

.date-picker-wrap {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-left: auto;
  flex-shrink: 0;
}
.date-inline { width: 170px; }
.date-nav { display: flex; gap: 2px; }
.nav-icon { font-size: 16px; color: #999; cursor: pointer; }
.nav-icon:hover { color: #555; }

.body-area {
  flex: 1;
  overflow: hidden;
  padding: 12px 20px;
}

.category-columns {
  display: grid;
  height: 100%;
}

.empty-block {
  display: flex;
  flex-direction: column;
  break-inside: avoid;
  margin-bottom: 10px;
}
.block-title-placeholder {
  display: flex;
  align-items: baseline;
  gap: 8px;
  margin-bottom: 6px;
  padding: 0 2px;
  flex-shrink: 0;
}
.block-title-placeholder .block-name {
  font-size: 14px;
  font-weight: 700;
  color: #1a1a1a;
}
.block-title-placeholder .block-change.neutral { color: #888; font-size: 12px; font-weight: 600; }
.empty-body {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #bbb;
  font-size: 13px;
  background: #fafafa;
  border-radius: 4px;
  min-height: 60px;
}

@media (max-width: 768px) {
  .top-bar { flex-wrap: wrap; height: auto; gap: 8px; padding: 8px 12px; }
  .color-mode-select { margin-left: 0; }
  .sort-bar { margin-left: 0; }
  .time-bar { margin-left: 0; }
  .date-picker-wrap { margin-left: 0; }
  .search-input { width: 160px; }
  .select-inline { width: 110px; }
  .date-inline { width: 150px; }
}
</style>

<style>
.global-tooltip {
  position: fixed;
  z-index: 10001;
  background: rgba(255,255,255,0.98);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.18);
  padding: 14px 18px;
  min-width: 220px;
  pointer-events: none;
}
.ttp-header {
  font-size: 14px;
  font-weight: 600;
  color: #1a1a1a;
  margin-bottom: 10px;
  padding-bottom: 8px;
  border-bottom: 1px solid #f0f0f0;
}
.ttp-body { display: flex; flex-direction: column; gap: 5px; }
.ttp-row { display: flex; justify-content: space-between; align-items: center; }
.ttp-label { font-size: 12px; color: #8c8c8c; }
.ttp-val { font-size: 13px; font-weight: 600; color: #333; }
.ttp-val.blue { color: #7c4dff !important; font-weight: 700; }
</style>
