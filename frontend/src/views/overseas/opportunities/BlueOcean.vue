<template>
  <div class="blue-ocean-page">
    <!-- ====== 顶部标题 ====== -->
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">蓝海品类<span class="title-icon">🌊</span></h1>
        <p class="page-subtitle">基于数据智能挖掘的低竞争高潜力赛道，抢占先机</p>
      </div>
    </div>

    <!-- ====== 蓝海矩阵图 ====== -->
    <div class="matrix-card">
      <div class="card-head">
        <h3>蓝海矩阵</h3>
        <span class="head-hint">X轴：竞争度 ← 低 → 高 ｜ Y轴：需求增长 ↑</span>
      </div>
      <div ref="matrixRef" style="height:340px" />
    </div>

    <!-- ====== 蓝海品类卡片列表 ====== -->
    <div class="card-grid">
      <div v-for="(item, idx) in items" :key="item.id" class="blue-card" :style="{ animationDelay: idx * 0.06 + 's' }">
        <!-- 头部 -->
        <div class="bc-header">
          <div class="bc-title-row">
            <span class="bc-icon">{{ item.icon }}</span>
            <span class="bc-name">{{ item.category }}</span>
          </div>
          <div class="bc-index-wrap">
            <span class="bc-index-num">{{ item.blueOceanIndex }}</span>
            <span class="bc-index-label">蓝海指数</span>
          </div>
        </div>

        <!-- 迷你趋势线 -->
        <div class="bc-trend">
          <svg width="100%" height="36" viewBox="0 0 100 36">
            <polyline :points="svgPoints(item)" stroke="#409EFF" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
          </svg>
          <span class="trend-label">+{{ item.demandGrowth }}%</span>
        </div>

        <!-- 指标行 -->
        <div class="bc-metrics">
          <div class="bcm-item">
            <span class="bcm-label">竞争度</span>
            <span class="bcm-value" :class="compClass(item.competitionLevel)">{{ item.competitionLevel }}</span>
          </div>
          <div class="bcm-item">
            <span class="bcm-label">市场规模</span>
            <span class="bcm-value">${{ item.marketSize }}M</span>
          </div>
        </div>

        <!-- 目标市场 -->
        <div class="bc-markets">
          <span v-for="mkt in item.targetMarkets" :key="mkt" class="mkt-tag">{{ mkt }}</span>
        </div>

        <!-- 切入方式 -->
        <p class="bc-entry">💡 {{ item.entryMethod }}</p>

        <!-- 按钮 -->
        <el-button type="primary" plain size="small" round class="bc-btn" @click="openDetail(item)">查看详情</el-button>
      </div>
    </div>

    <!-- ====== 详情弹窗 ====== -->
    <el-dialog v-model="detailVisible" width="500px" class="detail-dialog" destroy-on-close>
      <template #header>
        <div class="dialog-hd">
          <span class="bc-icon">{{ detailItem?.icon }}</span>
          <span class="bc-name">{{ detailItem?.category }}</span>
          <span class="bc-index-num sm">{{ detailItem?.blueOceanIndex }}</span>
        </div>
      </template>
      <template v-if="detailItem">
        <div class="detail-body">
          <div class="detail-row"><span class="dl">市场规模</span><span class="dv">${{ detailItem.marketSize }}M</span></div>
          <div class="detail-row"><span class="dl">需求增长</span><span class="dv green">+{{ detailItem.demandGrowth }}%</span></div>
          <div class="detail-row"><span class="dl">竞争分数</span><span class="dv">{{ detailItem.competitionScore }}/100（越低越好）</span></div>
          <div class="detail-row"><span class="dl">切入方式</span><span class="dv">{{ detailItem.entryMethod }}</span></div>
          <div class="detail-row"><span class="dl">蓝海理由</span><span class="dv">{{ detailItem.reason }}</span></div>
          <div class="detail-row"><span class="dl">代表商品</span><span class="dv"><span v-for="(p, i) in detailItem.relatedProducts" :key="i" class="rp-tag">{{ p }}</span></span></div>
        </div>
      </template>
      <template #footer><el-button @click="detailVisible=false">关闭</el-button></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue'
import { getBlueOceanData, mockBlueOceanData } from '@/api/overseas'

const items = ref(getBlueOceanData({ sortBy:'blueOceanIndex' }))
const detailVisible = ref(false)
const detailItem = ref(null)

function compClass(level) { return level === '低' ? 'low' : level === '中' ? 'mid' : 'high' }
function openDetail(item) { detailItem.value = item; detailVisible.value = true }
function svgPoints(item) {
  const data = item.trend7d || [70,72,75,78,82,85,88]
  return data.map((v, i) => `${(i / (data.length-1)) * 100},${36 - (v / 100) * 32}`).join(' ')
}

// ====== ECharts 散点图 ======
const matrixRef = ref(null)
let chartInstance = null
let echarts = null

async function loadEcharts() {
  if (!echarts) {
    echarts = await import('echarts/core')
    const { ScatterChart } = await import('echarts/charts')
    const { GridComponent, TooltipComponent, MarkAreaComponent } = await import('echarts/components')
    const { CanvasRenderer } = await import('echarts/renderers')
    echarts.use([ScatterChart, GridComponent, TooltipComponent, MarkAreaComponent, CanvasRenderer])
  }
  return echarts
}

async function initMatrix() {
  if (!matrixRef.value) return
  if (chartInstance) chartInstance.dispose()
  const ec = await loadEcharts()

  const data = mockBlueOceanData.map(item => ({
    value: [item.competitionScore, item.demandGrowth],
    name: item.category,
    symbolSize: item.blueOceanIndex * 0.5
  }))

  chartInstance = ec.init(matrixRef.value)
  chartInstance.setOption({
    tooltip: {
      trigger:'item',
      backgroundColor:'#fff', borderColor:'#e8ecf1', padding:[10,14],
      extraCssText:'box-shadow:0 4px 20px rgba(0,0,0,0.08);border-radius:8px',
      formatter: (params) => {
        const item = mockBlueOceanData.find(d => d.category === params.name)
        if (!item) return params.name
        return `<div style="font-size:13px;line-height:1.7">
          <b>${item.icon} ${item.category}</b><br/>
          蓝海指数：<b>${item.blueOceanIndex}</b><br/>
          竞争度：<b>${item.competitionScore}/100</b><br/>
          需求增长：<b>+${item.demandGrowth}%</b><br/>
          市场规模：<b>$${item.marketSize}M</b>
        </div>`
      }
    },
    grid: { left:50, right:20, top:20, bottom:40 },
    xAxis: { name:'竞争度 →', nameLocation:'center', nameGap:24, min:10, max:50, axisLabel:{fontSize:11,color:'#8A9AA8'}, splitLine:{lineStyle:{color:'#F0F2F5',type:'dashed'}} },
    yAxis: { name:'需求增长 %', min:18, max:36, axisLabel:{fontSize:11,color:'#8A9AA8'}, splitLine:{lineStyle:{color:'#F0F2F5',type:'dashed'}} },
    series: [{
      type:'scatter',
      data,
      itemStyle: {
        color: (params) => {
          const item = mockBlueOceanData.find(d => d.category === params.name)
          const score = item ? item.competitionScore : 40
          return score <= 25 ? '#409EFF' : score <= 35 ? '#67C23A' : '#E6A23C'
        }
      },
      label: { show:true, formatter:'{b}', position:'top', fontSize:11, color:'#4A5A6A' },
      markArea: {
        silent:true,
        data: [[
          { xAxis:10, yAxis:26, itemStyle:{color:'rgba(64,158,255,0.06)'} },
          { xAxis:28, yAxis:36 }
        ]],
        label: { show:true, position:['50%','80%'], formatter:'蓝海区', fontSize:12, color:'#409EFF', fontWeight:'bold' }
      }
    }]
  })
}

function handleResize() { chartInstance?.resize() }

onMounted(() => {
  nextTick(initMatrix)
  window.addEventListener('resize', handleResize)
})
onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  chartInstance?.dispose()
})
</script>

<style scoped>
.blue-ocean-page { max-width:1440px; margin:0 auto; }

.page-header { margin-bottom:24px; }
.header-left { display:flex; flex-direction:column; gap:6px; }
.page-title { margin:0; font-size:28px; font-weight:700; color:#1A2A3A; display:flex; align-items:center; gap:10px; }
.title-icon { font-size:24px; }
.page-subtitle { margin:0; font-size:14px; color:#8A9AA8; }

/* 矩阵图 */
.matrix-card { background:#fff; border-radius:16px; padding:20px 24px; box-shadow:0 2px 12px rgba(0,0,0,0.04); margin-bottom:28px; }
.card-head { display:flex; justify-content:space-between; align-items:center; margin-bottom:4px; }
.card-head h3 { margin:0; font-size:16px; font-weight:600; color:#1A2A3A; }
.head-hint { font-size:12px; color:#B0BCC8; }

/* 卡片网格 */
.card-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:20px; margin-bottom:28px; }
@media (max-width:900px){ .card-grid { grid-template-columns:1fr; } }

.blue-card {
  background:#fff; border-radius:16px; padding:22px 24px;
  box-shadow:0 2px 12px rgba(0,0,0,0.04); transition:all .3s;
  animation:cardIn .5s ease backwards;
}
@keyframes cardIn { from{opacity:0;transform:translateY(12px)} to{opacity:1;transform:translateY(0)} }
.blue-card:hover { transform:translateY(-3px); box-shadow:0 12px 32px rgba(0,0,0,0.06); border-color:#c4cdff; }

.bc-header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:14px; }
.bc-title-row { display:flex; align-items:center; gap:8px; }
.bc-icon { font-size:24px; }
.bc-name { font-size:17px; font-weight:700; color:#1A2A3A; }

.bc-index-wrap { display:flex; flex-direction:column; align-items:center; gap:2px; }
.bc-index-num { font-size:28px; font-weight:800; color:#409EFF; line-height:1; }
.bc-index-num.sm { font-size:22px; }
.bc-index-label { font-size:10px; color:#8A9AA8; }

.bc-trend { display:flex; align-items:center; gap:8px; margin-bottom:14px; background:#F8FAFF; border-radius:8px; padding:6px 10px; }
.trend-label { font-size:13px; font-weight:600; color:#52C41A; flex-shrink:0; }

.bc-metrics { display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-bottom:12px; }
.bcm-item { padding:8px 12px; background:#FAFBFC; border-radius:10px; }
.bcm-label { display:block; font-size:11px; color:#8A9AA8; margin-bottom:2px; }
.bcm-value { font-size:14px; font-weight:600; color:#1A2A3A; }
.bcm-value.low { color:#52C41A; }
.bcm-value.mid { color:#E6A23C; }
.bcm-value.high { color:#F56C6C; }

.bc-markets { display:flex; gap:4px; flex-wrap:wrap; margin-bottom:10px; }
.mkt-tag { font-size:11px; padding:3px 10px; border-radius:6px; background:#ECF5FF; color:#409EFF; font-weight:500; }

.bc-entry { margin:0 0 12px; font-size:12px; color:#6b7280; line-height:1.6; }
.bc-btn { width:100%; }

/* 详情弹窗 */
.detail-dialog :deep(.el-dialog__body){ padding:0 20px 20px; }
.dialog-hd { display:flex; align-items:center; gap:10px; }
.detail-body { display:flex; flex-direction:column; gap:10px; }
.detail-row { padding:10px 14px; background:#FAFBFC; border-radius:10px; display:flex; flex-direction:column; gap:4px; }
.dl { font-size:11px; color:#8A9AA8; }
.dv { font-size:13px; font-weight:500; color:#303133; line-height:1.5; }
.dv.green { color:#52C41A; font-weight:600; }
.rp-tag { display:inline-block; font-size:11px; padding:3px 10px; border-radius:6px; background:#ECF5FF; color:#409EFF; margin:2px 4px 2px 0; }
</style>
