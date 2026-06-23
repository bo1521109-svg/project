<template>
  <div class="cross-platform-page">
    <!-- ====== 顶部标题 + 筛选 ====== -->
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">跨平台对比</h1>
        <p class="page-subtitle">TikTok · Shopify · Amazon 数据横向对比，找到最适合的平台</p>
      </div>
      <div class="header-filters">
        <el-select v-model="category" placeholder="全部品类" size="large" clearable class="filt-sel" @change="refresh">
          <el-option v-for="c in categories" :key="c" :label="c" :value="c" />
        </el-select>
        <div class="filter-group">
          <button v-for="r in times" :key="r" class="fbtn" :class="{ active: timeRange === r }" @click="timeRange = r; refresh()">{{ r }}天</button>
        </div>
      </div>
    </div>

    <!-- ====== 三平台对比卡片 ====== -->
    <div class="platform-row">
      <div v-for="(p, idx) in data.platforms" :key="p.id" class="plat-card" :style="{ animationDelay: idx * 0.1 + 's', borderTopColor: p.color }">
        <!-- 头部 -->
        <div class="plat-head">
          <span class="plat-icon">{{ p.icon }}</span>
          <div class="plat-name-row">
            <span class="plat-name">{{ p.name }}</span>
            <span class="plat-tagline">{{ p.tagline }}</span>
          </div>
        </div>

        <!-- 指标 3×2 -->
        <div class="plat-metrics">
          <div class="pm-item"><span class="pm-label">热销商品数</span><span class="pm-value">{{ fmtK(p.metrics.hotProducts) }}</span></div>
          <div class="pm-item"><span class="pm-label">平均价格</span><span class="pm-value">${{ p.metrics.avgPrice }}</span></div>
          <div class="pm-item"><span class="pm-label">总销售额</span><span class="pm-value">${{ fmtK(p.metrics.totalSales) }}K</span></div>
          <div class="pm-item"><span class="pm-label">增长率</span><span class="pm-value green">+{{ p.metrics.growthRate }}%</span></div>
          <div class="pm-item"><span class="pm-label">转化率</span><span class="pm-value">{{ p.metrics.conversionRate }}%</span></div>
          <div class="pm-item"><span class="pm-label">活跃店铺</span><span class="pm-value">{{ fmtK(p.metrics.activeShops) }}</span></div>
        </div>

        <!-- 热销品类 -->
        <div class="plat-top-cats">
          <span class="ptc-label">热销Top3</span>
          <div class="ptc-list">
            <span v-for="(c, ci) in p.topCategories" :key="ci" class="ptc-item">{{ ci+1 }}. {{ c }}</span>
          </div>
        </div>

        <!-- 优势标签 -->
        <div class="plat-tags">
          <span v-for="t in p.advantageTags.slice(0,3)" :key="t" class="atag">✓ {{ t }}</span>
        </div>

        <!-- 最适用 -->
        <div class="plat-best">
          <span class="best-label">最适用</span>
          <span class="best-text">{{ p.bestFor.slice(0,2).join('、') }}</span>
        </div>
      </div>
    </div>

    <!-- ====== 对比图表区 ====== -->
    <div class="charts-row">
      <div class="chart-card">
        <h4>各平台销售额对比</h4>
        <div ref="barRef" style="height:240px" />
      </div>
      <div class="chart-card">
        <h4>近{{ timeRange }}天趋势</h4>
        <div ref="lineRef" style="height:240px" />
      </div>
    </div>

    <!-- ====== 选品建议卡片 ====== -->
    <div class="rec-section">
      <h4 class="rec-title">🎯 选品建议</h4>
      <div class="rec-grid">
        <div v-for="r in filteredRecs" :key="r.id" class="rec-card">
          <span class="rec-icon">{{ r.icon }}</span>
          <div class="rec-body">
            <div class="rec-top">
              <span class="rec-cat">{{ r.category }}</span>
              <span class="rec-plat" :style="{ background: platformColor(r.recommendedPlatform) }">{{ r.recommendedPlatform }}</span>
            </div>
            <p class="rec-reason">{{ r.reason }}</p>
            <div class="rec-meta">
              <span>{{ r.priceRange }}</span>
              <span>预估ROI {{ r.expectedRoi }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick, watch } from 'vue'
import { getCrossPlatformData, mockCrossPlatformData } from '@/api/overseas'

const categories = ['服装','美妆','3C数码','家居','运动户外','食品饮料','珠宝饰品','母婴','宠物','个护']
const times = [7,30]
const category = ref('')
const timeRange = ref(30)

const raw = getCrossPlatformData({ category:'' })
const data = ref({ ...raw, platforms: raw.platforms.map(p => ({...p })) })

const recs = mockCrossPlatformData.recommendations
const filteredRecs = computed(() => {
  if (!category.value) return recs
  return recs.filter(r => r.category === category.value || r.platforms.includes(category.value.toLowerCase()))
})

const platColorMap = { 'TikTok Shop':'#FF004F','Shopify':'#96BF48','Amazon':'#FF9900' }
function platformColor(name) { return platColorMap[name] || '#909399' }
function fmtK(n) { return n >= 1000 ? (n/1000).toFixed(1)+'k' : String(n) }

function refresh() {
  const newData = getCrossPlatformData({ category: category.value })
  data.value = { ...newData, platforms: newData.platforms.map(p => ({...p })) }
  nextTick(() => { initBarChart(); initLineChart() })
}

// ====== ECharts ======
const barRef = ref(null), lineRef = ref(null)
let barInst = null, lineInst = null, echarts = null

async function loadEcharts() {
  if (!echarts) {
    echarts = await import('echarts/core')
    const { BarChart, LineChart } = await import('echarts/charts')
    const { GridComponent, TooltipComponent, LegendComponent } = await import('echarts/components')
    const { CanvasRenderer } = await import('echarts/renderers')
    echarts.use([BarChart, LineChart, GridComponent, TooltipComponent, LegendComponent, CanvasRenderer])
  }
  return echarts
}

async function initBarChart() {
  if (!barRef.value) return
  if (barInst) barInst.dispose()
  const ec = await loadEcharts()
  const platforms = data.value.platforms
  const colors = { tiktok:'#FF004F', shopify:'#96BF48', amazon:'#FF9900' }
  const platformColors = { tiktok: '#FF004F', shopify: '#96BF48', amazon: '#FF9900' }
  const categories = ['热销商品(K)','总销售额(K)','平均价格($)','增长率(%)','转化率(%)']

  // 收集每组原始数据用于 tooltip 和归一化
  const rawData = platforms.map(p => [
    { key: 'hotProducts', raw: p.metrics.hotProducts / 1000, rawNum: p.metrics.hotProducts },
    { key: 'totalSales', raw: p.metrics.totalSales, rawNum: p.metrics.totalSales },
    { key: 'avgPrice', raw: p.metrics.avgPrice, rawNum: p.metrics.avgPrice },
    { key: 'growthRate', raw: p.metrics.growthRate, rawNum: p.metrics.growthRate },
    { key: 'conversionRate', raw: p.metrics.conversionRate, rawNum: p.metrics.conversionRate }
  ])

  // 每组取最大值做归一化
  const maxPerGroup = categories.map((_, gi) =>
    Math.max(...platforms.map((_, pi) => rawData[pi][gi].raw), 1)
  )
  // 归一化到 0-100
  const normalized = platforms.map((_, pi) =>
    rawData[pi].map((item, gi) => Math.round(item.raw / maxPerGroup[gi] * 100))
  )

  barInst = ec.init(barRef.value)
  barInst.setOption({
    tooltip: {
      trigger: 'axis',
      backgroundColor: '#fff',
      borderColor: '#e8ecf1',
      padding: [10, 14],
      extraCssText: 'box-shadow:0 4px 20px rgba(0,0,0,0.08);border-radius:8px',
      formatter: (params) => {
        let html = `<b>${params[0].axisValue}</b><br/>`
        params.forEach((p, i) => {
          const raw = rawData[i][p.dataIndex]
          html += `<span style="display:inline-block;width:8px;height:8px;border-radius:50%;background:${platformColors[platforms[i].id]};margin-right:6px;"></span>${p.seriesName}：<b>${raw.rawNum}</b><br/>`
        })
        return html
      }
    },
    legend: { bottom: -4, itemWidth: 10, itemHeight: 10, textStyle: { fontSize: 11 }, padding: [0, 0, 10, 0] },
    grid: { left: 80, right: 16, top: 10, bottom: 40 },
    xAxis: { type: 'category', data: categories, axisLabel: { fontSize: 11, color: '#8A9AA8' } },
    yAxis: {
      type: 'value', min: 0, max: 100, interval: 25,
      axisLabel: { fontSize: 11, color: '#8A9AA8', formatter: '{value}%' },
      splitLine: { lineStyle: { color: '#F0F2F5', type: 'dashed' } }
    },
    series: platforms.map((p, i) => ({
      name: p.name,
      type: 'bar',
      data: normalized[i],
      itemStyle: { color: colors[p.id], borderRadius: [6, 6, 0, 0] },
      barGap: '20%',
      label: {
        show: false
      }
    }))
  })
}

async function initLineChart() {
  if (!lineRef.value) return
  if (lineInst) lineInst.dispose()
  const ec = await loadEcharts()
  const platforms = data.value.platforms
  const key = timeRange.value === 30 ? 'trend30d' : 'trend7d'
  const colors = { tiktok:'#FF004F', shopify:'#96BF48', amazon:'#FF9900' }
  lineInst = ec.init(lineRef.value)
  lineInst.setOption({
    tooltip: { trigger:'axis', backgroundColor:'#fff', borderColor:'#e8ecf1', padding:[10,14], extraCssText:'box-shadow:0 4px 20px rgba(0,0,0,0.08);border-radius:8px' },
    legend: { bottom: -4, itemWidth: 10, itemHeight: 10, textStyle: { fontSize: 11 }, padding: [0, 0, 10, 0] },
    grid: { left: 44, right: 16, top: 10, bottom: 40 },
    xAxis: { type:'category', data: platforms[0][key].map((_,i) => 'D'+(i+1)), axisLabel:{fontSize:10,color:'#8A9AA8'} },
    yAxis: { type:'value', splitLine:{lineStyle:{color:'#F0F2F5',type:'dashed'}}, axisLabel:{fontSize:11,color:'#8A9AA8'} },
    series: platforms.map(p => ({
      name: p.name, type:'line', data: p[key], smooth:true, symbol:'none',
      lineStyle: { color:colors[p.id], width:2 }
    }))
  })
}

function handleResize() { barInst?.resize(); lineInst?.resize() }

onMounted(() => { nextTick(() => { initBarChart(); initLineChart() }); window.addEventListener('resize', handleResize) })
onUnmounted(() => { window.removeEventListener('resize', handleResize); barInst?.dispose(); lineInst?.dispose() })
</script>

<style scoped>
.cross-platform-page { max-width:1440px; margin:0 auto; }

.page-header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:24px; flex-wrap:wrap; gap:14px; }
.header-left { display:flex; flex-direction:column; gap:6px; }
.page-title { margin:0; font-size:28px; font-weight:700; color:#1A2A3A; }
.page-subtitle { margin:0; font-size:14px; color:#8A9AA8; }
.header-filters { display:flex; align-items:center; gap:12px; }
.filt-sel { width:140px; }
.filt-sel :deep(.el-input__wrapper){ border-radius:12px; }
.filter-group { display:flex; background:#F0F2F5; border-radius:10px; padding:3px; }
.fbtn { padding:6px 16px; border:none; border-radius:8px; background:transparent; color:#8A9AA8; font-size:13px; font-weight:500; cursor:pointer; transition:all .2s; }
.fbtn:hover { color:#4A5A6A; }
.fbtn.active { background:#fff; color:#1A2A3A; box-shadow:0 1px 4px rgba(0,0,0,0.06); }

/* 三平台卡片 */
.platform-row { display:grid; grid-template-columns:repeat(3,1fr); gap:20px; margin-bottom:28px; }
@media (max-width:960px){ .platform-row { grid-template-columns:1fr; } }

.plat-card {
  background:#fff; border-radius:16px; padding:22px 24px;
  box-shadow:0 2px 12px rgba(0,0,0,0.04); border-top:4px solid;
  transition:all .3s; animation:cardIn .5s ease backwards;
}
@keyframes cardIn { from{opacity:0;transform:translateY(12px)} to{opacity:1;transform:translateY(0)} }
.plat-card:hover { transform:translateY(-3px); box-shadow:0 12px 32px rgba(0,0,0,0.06); }

.plat-head { display:flex; align-items:center; gap:12px; margin-bottom:16px; }
.plat-icon { font-size:28px; }
.plat-name-row { display:flex; flex-direction:column; gap:2px; }
.plat-name { font-size:16px; font-weight:700; color:#1A2A3A; }
.plat-tagline { font-size:11px; color:#8A9AA8; }

.plat-metrics { display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-bottom:14px; }
.pm-item { padding:8px 12px; background:#FAFBFC; border-radius:10px; }
.pm-label { display:block; font-size:11px; color:#8A9AA8; margin-bottom:2px; }
.pm-value { font-size:14px; font-weight:700; color:#1A2A3A; }
.pm-value.green { color:#52C41A; }

.plat-top-cats { margin-bottom:12px; }
.ptc-label { font-size:11px; color:#8A9AA8; display:block; margin-bottom:4px; }
.ptc-list { display:flex; flex-direction:column; gap:3px; }
.ptc-item { font-size:12px; color:#4A5A6A; font-weight:500; }

.plat-tags { display:flex; flex-wrap:wrap; gap:4px; margin-bottom:12px; }
.atag { font-size:10px; padding:2px 8px; border-radius:6px; background:#EDFCF2; color:#52C41A; }

.plat-best { padding:8px 10px; background:#F8FAFF; border-radius:8px; }
.best-label { font-size:10px; color:#409EFF; display:block; margin-bottom:2px; }
.best-text { font-size:12px; color:#1A2A3A; font-weight:500; }

/* 图表 */
.charts-row { display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-bottom:28px; }
@media (max-width:900px){ .charts-row { grid-template-columns:1fr; } }
.chart-card { background:#fff; border-radius:16px; padding:20px 24px; box-shadow:0 2px 12px rgba(0,0,0,0.04); }
.chart-card h4 { margin:0 0 8px; font-size:15px; font-weight:600; color:#1A2A3A; }

/* 选品建议 */
.rec-section { background:#fff; border-radius:16px; padding:20px 24px; box-shadow:0 2px 12px rgba(0,0,0,0.04); }
.rec-title { margin:0 0 16px; font-size:16px; font-weight:600; color:#1A2A3A; }
.rec-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:14px; }
@media (max-width:1100px){ .rec-grid { grid-template-columns:repeat(2,1fr); } }
@media (max-width:600px){ .rec-grid { grid-template-columns:1fr; } }
.rec-card { padding:14px; background:#FAFBFC; border-radius:12px; display:flex; gap:10px; transition:all .25s; }
.rec-card:hover { background:#F8FAFF; }
.rec-icon { font-size:22px; flex-shrink:0; }
.rec-top { display:flex; align-items:center; gap:6px; margin-bottom:6px; }
.rec-cat { font-size:13px; font-weight:600; color:#1A2A3A; }
.rec-plat { font-size:10px; padding:1px 6px; border-radius:6px; color:#fff; font-weight:500; flex-shrink:0; }
.rec-reason { margin:0 0 6px; font-size:11px; color:#6b7280; line-height:1.5; display:-webkit-box; -webkit-line-clamp:2; line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; }
.rec-meta { display:flex; justify-content:space-between; font-size:10px; color:#B0BCC8; }
</style>
