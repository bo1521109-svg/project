<template>
  <div class="hot-ranking-page">
    <!-- ====== 顶部标题 + 筛选 ====== -->
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">品类热度榜</h1>
        <p class="page-subtitle">发现全球品类热点，抓住增长机会</p>
      </div>
      <div class="header-filters">
        <el-select v-model="filters.market" placeholder="选择市场" size="large" class="filter-select" @change="refreshData">
          <el-option label="🌍 全球" value="" />
          <el-option v-for="m in markets" :key="m.code" :label="flagMap[m.code] + ' ' + m.name" :value="m.code" />
        </el-select>
        <div class="filter-group">
          <button v-for="r in timeRanges" :key="r.value" class="filter-btn" :class="{ active: filters.timeRange === r.value }" @click="filters.timeRange = r.value; refreshData()">{{ r.label }}</button>
        </div>
      </div>
    </div>

    <!-- ====== 主体：表格 + 详情面板 ====== -->
    <div class="main-body">
      <!-- 左侧：品类排行表格 -->
      <div class="table-card" :class="{ 'has-detail': detailCategory }">
        <el-table :data="rankingList" style="width:100%" size="large" highlight-current-row @row-click="openDetail" :row-class-name="rowClass">
          <!-- 排名 -->
          <el-table-column label="排名" width="80" align="center">
            <template #default="{ row }">
              <span v-if="row.rank <= 3" class="rank-badge" :class="'rank-' + row.rank">
                <span v-if="row.rank === 1">🥇</span>
                <span v-else-if="row.rank === 2">🥈</span>
                <span v-else>🥉</span>
              </span>
              <span v-else class="rank-num">#{{ row.rank }}</span>
            </template>
          </el-table-column>

          <!-- 品类 -->
          <el-table-column label="品类" width="160">
            <template #default="{ row }">
              <div class="category-cell">
                <span class="cat-icon">{{ row.icon }}</span>
                <span class="cat-name">{{ row.category }}</span>
              </div>
            </template>
          </el-table-column>

          <!-- 热度指数 + 进度条 -->
          <el-table-column label="热度指数" width="180">
            <template #default="{ row }">
              <div class="heat-cell">
                <div class="heat-bar-row">
                  <div class="heat-bar-bg">
                    <div class="heat-bar-fill" :class="row.rank <= 3 ? 'top' : ''" :style="{ width: row.heatPercent + '%' }" />
                  </div>
                  <span class="heat-num" :class="{ 'text-gold': row.rank <= 3 }">{{ row.heatIndex }}</span>
                </div>
              </div>
            </template>
          </el-table-column>

          <!-- 增长率 -->
          <el-table-column label="增长率" width="120" align="center">
            <template #default="{ row }">
              <span class="growth-cell" :class="row.growthRate >= 15 ? 'up' : 'normal'">
                <span class="growth-arrow">{{ row.trend === 'up' ? '▲' : '▼' }}</span>
                +{{ row.growthRate }}%
              </span>
            </template>
          </el-table-column>

          <!-- 主要市场 -->
          <el-table-column label="主要市场" min-width="180">
            <template #default="{ row }">
              <div class="market-tags">
                <span v-for="mkt in row.mainMarkets" :key="mkt" class="mkt-tag">{{ mkt }}</span>
              </div>
            </template>
          </el-table-column>

          <!-- 代表商品 -->
          <el-table-column label="代表商品" min-width="240">
            <template #default="{ row }">
              <div class="prod-list">
                <span v-for="(p, pi) in row.representativeProducts?.slice(0,4)" :key="pi" class="prod-chip">{{ p }}</span>
              </div>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 右侧：品类详情面板 -->
      <transition name="slide">
        <div v-if="detailCategory" class="detail-panel">
          <div class="detail-header">
            <div>
              <span class="detail-icon">{{ detailCategory.icon }}</span>
              <span class="detail-name">{{ detailCategory.category }}</span>
            </div>
            <el-icon :size="18" class="close-icon" @click="detailCategory = null"><Close /></el-icon>
          </div>

          <!-- 指标 -->
          <div class="detail-metrics">
            <div class="dm-item"><span class="dm-label">热度指数</span><span class="dm-value gold">{{ detailCategory.heatIndex }}</span></div>
            <div class="dm-item"><span class="dm-label">增长率</span><span class="dm-value green">+{{ detailCategory.growthRate }}%</span></div>
            <div class="dm-item"><span class="dm-label">主要市场</span><span class="dm-value">{{ detailCategory.mainMarkets.join('、') }}</span></div>
          </div>

          <!-- 趋势图 -->
          <div class="detail-chart">
            <h4>{{ trendLabel }} 热度趋势</h4>
            <div ref="trendRef" style="height:200px" />
          </div>

          <!-- 代表商品列表 -->
          <div class="detail-products">
            <h4>代表商品</h4>
            <div class="dp-list">
              <div v-for="(p, pi) in detailCategory.representativeProducts" :key="pi" class="dp-item">
                <span class="dp-num">{{ pi + 1 }}</span>
                <span>{{ p }}</span>
              </div>
            </div>
          </div>
        </div>
      </transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, nextTick, onMounted } from 'vue'
import { Close } from '@element-plus/icons-vue'
import { getMarkets, getCategoryHotRanking } from '@/api/overseas'

const flagMap = { US:'🇺🇸',CA:'🇨🇦',MX:'🇲🇽',GB:'🇬🇧',DE:'🇩🇪',FR:'🇫🇷',IT:'🇮🇹',ES:'🇪🇸',ID:'🇮🇩',TH:'🇹🇭',VN:'🇻🇳',PH:'🇵🇭',MY:'🇲🇾',SG:'🇸🇬',BR:'🇧🇷',AR:'🇦🇷',CO:'🇨🇴',KZ:'🇰🇿',UZ:'🇺🇿',AE:'🇦🇪',SA:'🇸🇦' }

const markets = ref(getMarkets())
const timeRanges = [{value:'7d',label:'7天'},{value:'30d',label:'30天'},{value:'90d',label:'90天'}]

const filters = ref({ market:'', timeRange:'30d' })
const rawData = ref(getCategoryHotRanking({ market:'', timeRange:'30d' }))
const rankingList = ref([])
const detailCategory = ref(null)

function refreshData() {
  const data = getCategoryHotRanking({ market: filters.value.market, timeRange: filters.value.timeRange })
  rankingList.value = data.map((item, idx) => ({
    ...item,
    rank: idx + 1,
    heatPercent: Math.max(5, Math.min(100, (item.marketHeatIndex || item.heatIndex)))
  }))
  detailCategory.value = null
}
refreshData()

const trendLabel = computed(() => {
  const t = timeRanges.find(r => r.value === filters.value.timeRange)
  return t ? '近' + t.label : ''
})

function rowClass({ row }) {
  return row.rank <= 3 ? 'top-row' : ''
}
function openDetail(row) {
  detailCategory.value = { ...row }
  nextTick(initTrendChart)
}

// ====== ECharts ======
const trendRef = ref(null)
let chartInstance = null
let echarts = null

async function loadEcharts() {
  if (!echarts) {
    echarts = await import('echarts/core')
    const { LineChart } = await import('echarts/charts')
    const { GridComponent, TooltipComponent } = await import('echarts/components')
    const { CanvasRenderer } = await import('echarts/renderers')
    echarts.use([LineChart, GridComponent, TooltipComponent, CanvasRenderer])
  }
  return echarts
}

async function initTrendChart() {
  if (!trendRef.value || !detailCategory.value) return
  if (chartInstance) chartInstance.dispose()
  const ec = await loadEcharts()
  const cat = detailCategory.value
  const key = 'trend' + filters.value.timeRange
  const data = cat[key] || cat.trend30d || []

  chartInstance = ec.init(trendRef.value)
  chartInstance.setOption({
    tooltip: { trigger:'axis', backgroundColor:'#fff', borderColor:'#e8ecf1', padding:[8,12], extraCssText:'box-shadow:0 4px 20px rgba(0,0,0,0.08);border-radius:8px' },
    grid: { left:36, right:12, top:8, bottom:20 },
    xAxis: { type:'category', data:data.map((_,i) => 'D'+(i+1)), show:false },
    yAxis: { type:'value', min:30, max:100, splitLine:{lineStyle:{color:'#F0F2F5',type:'dashed'}}, axisLabel:{fontSize:10,color:'#8A9AA8'} },
    series: [{
      type:'line', data, smooth:true, symbol:'none', lineStyle:{width:3,color:'#C9A96E'},
      areaStyle: { color:{ type:'linear',x:0,y:0,x2:0,y2:1, colorStops:[{offset:0,color:'rgba(201,169,110,0.25)'},{offset:1,color:'rgba(201,169,110,0.02)'}] } }
    }]
  })
}
watch(filters, () => {}, { deep:true })
</script>

<style scoped>
.hot-ranking-page { max-width:1440px; margin:0 auto; }

.page-header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:28px; flex-wrap:wrap; gap:16px; }
.header-left { display:flex; flex-direction:column; gap:6px; }
.page-title { margin:0; font-size:28px; font-weight:700; color:#1A2A3A; }
.page-subtitle { margin:0; font-size:14px; color:#8A9AA8; }
.header-filters { display:flex; align-items:center; gap:12px; flex-wrap:wrap; }
.filter-select { width:200px; }
.filter-group { display:flex; background:#F0F2F5; border-radius:10px; padding:3px; }
.filter-btn { padding:6px 16px; border:none; border-radius:8px; background:transparent; color:#8A9AA8; font-size:13px; font-weight:500; cursor:pointer; transition:all .2s; }
.filter-btn:hover { color:#4A5A6A; }
.filter-btn.active { background:#fff; color:#1A2A3A; box-shadow:0 1px 4px rgba(0,0,0,0.06); }

/* 主体布局 */
.main-body { display:flex; gap:0; }
.table-card { flex:1; background:#fff; border-radius:16px; padding:8px 16px 16px; box-shadow:0 2px 12px rgba(0,0,0,0.04); transition:all .3s; }
.table-card.has-detail { border-radius:16px 0 0 16px; border-right:none; }

/* 排名徽章 */
.rank-badge { font-size:24px; }
.rank-num { font-size:14px; font-weight:700; color:#909399; }

/* 品类 */
.category-cell { display:flex; align-items:center; gap:8px; }
.cat-icon { font-size:20px; }
.cat-name { font-size:14px; font-weight:600; color:#1A2A3A; }

/* 热度条 */
.heat-bar-row { display:flex; align-items:center; gap:8px; }
.heat-bar-bg { flex:1; height:8px; background:#F0F2F5; border-radius:4px; overflow:hidden; }
.heat-bar-fill { height:100%; background:linear-gradient(90deg,#C9A96E,#E8D5A3); border-radius:4px; transition:width .6s; }
.heat-bar-fill.top { background:linear-gradient(90deg,#ff6b35,#ff9a62); }
.heat-num { font-size:15px; font-weight:700; color:#4A5A6A; }
.text-gold { color:#C9A96E; }

/* 增长率 */
.growth-cell { font-size:13px; font-weight:600; }
.growth-cell.up { color:#52C41A; }
.growth-cell.normal { color:#8A9AA8; }
.growth-arrow { font-size:10px; }

/* 市场标签 */
.market-tags { display:flex; gap:4px; flex-wrap:wrap; }
.mkt-tag { font-size:11px; padding:3px 10px; border-radius:6px; background:#F5F6F8; color:#606266; }

/* 代表商品 */
.prod-list { display:flex; gap:4px; flex-wrap:wrap; }
.prod-chip { font-size:11px; padding:2px 8px; border-radius:6px; background:linear-gradient(135deg,#ECF5FF,#E8F4FD); color:#409EFF; }

/* 前三行高亮 */
:deep(.top-row) { background:linear-gradient(90deg,#FFFDF5,transparent) !important; }
:deep(.top-row:hover) td { background:rgba(201,169,110,0.06) !important; }

/* 详情面板 */
.detail-panel {
  width:360px; flex-shrink:0; background:#FAFBFC;
  border-radius:0 16px 16px 0; padding:20px 22px;
  border:1px solid #e8ecf1; border-left:none;
  box-shadow:0 2px 12px rgba(0,0,0,0.04); overflow-y:auto;
}
.slide-enter-active,.slide-leave-active { transition:all .3s ease; }
.slide-enter-from,.slide-leave-to { opacity:0; transform:translateX(20px); }

.detail-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; }
.detail-icon { font-size:24px; margin-right:8px; }
.detail-name { font-size:18px; font-weight:700; color:#1A2A3A; }
.close-icon { cursor:pointer; color:#909399; }
.close-icon:hover { color:#606266; }

.detail-metrics { display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-bottom:16px; }
.dm-item { padding:10px; background:#fff; border-radius:10px; display:flex; flex-direction:column; gap:4px; }
.dm-item:last-child { grid-column:1/-1; }
.dm-label { font-size:11px; color:#8A9AA8; }
.dm-value { font-size:14px; font-weight:600; color:#1A2A3A; }
.dm-value.gold { color:#C9A96E; }
.dm-value.green { color:#52C41A; }

.detail-chart { margin-bottom:16px; }
.detail-chart h4,.detail-products h4 { margin:0 0 10px; font-size:13px; font-weight:600; color:#1A2A3A; }

.dp-list { display:flex; flex-direction:column; gap:6px; }
.dp-item { display:flex; align-items:center; gap:8px; font-size:13px; color:#606266; padding:6px 10px; background:#fff; border-radius:8px; }
.dp-num { width:20px; height:20px; border-radius:50%; background:#F0F2F5; color:#909399; font-size:11px; font-weight:600; display:flex; align-items:center; justify-content:center; flex-shrink:0; }

@media (max-width:900px) { .main-body { flex-direction:column; } .detail-panel { width:100%; border-radius:0 0 16px 16px; border:1px solid #e8ecf1; border-top:none; } .table-card.has-detail { border-radius:16px 16px 0 0; } }
</style>
