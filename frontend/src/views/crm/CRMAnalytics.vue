<template>
  <div class="crm-analytics">
    <div class="page-header">
      <h2 class="page-title">客资分析</h2>
      <el-segmented v-model="period" :options="periodOpts" size="small" />
    </div>

    <!-- 核心指标 -->
    <div class="stats-row">
      <div class="stat-card" v-for="s in coreStats" :key="s.key">
        <div class="sc-label">{{ s.label }}</div>
        <div class="sc-value">{{ s.value }}</div>
        <div class="sc-sub">{{ s.sub }}</div>
      </div>
    </div>

    <!-- 图表行 -->
    <div class="chart-row">
      <!-- 客户状态分布饼图 -->
      <div class="chart-panel">
        <h3>客户状态分布</h3>
        <div class="pie-chart-wrapper">
          <div class="pie-ring">
            <svg viewBox="0 0 200 200" class="pie-svg">
              <g v-for="(seg, i) in statusSegments" :key="i">
                <path
                  :d="seg.path"
                  :fill="seg.color"
                  class="pie-segment"
                  @mouseenter="hoverSegment = seg"
                  @mouseleave="hoverSegment = null"
                  :style="{ transform: hoverSegment === seg ? 'scale(1.05)' : 'scale(1)', transformOrigin: '100px 100px' }"
                />
              </g>
              <circle cx="100" cy="100" r="55" fill="#fff" />
              <text x="100" y="96" text-anchor="middle" font-size="20" font-weight="700" fill="#303133">{{ totalCustomers }}</text>
              <text x="100" y="114" text-anchor="middle" font-size="11" fill="#909399">总客户数</text>
            </svg>
            <div class="pie-tooltip" v-if="hoverSegment" :style="{ background: hoverSegment.color }">
              {{ hoverSegment.label }}: {{ hoverSegment.value }} ({{ hoverSegment.pct }}%)
            </div>
          </div>
          <div class="pie-legend">
            <div class="legend-item" v-for="seg in statusSegments" :key="seg.label">
              <span class="legend-dot" :style="{ background: seg.color }"></span>
              <span class="legend-label">{{ seg.label }}</span>
              <span class="legend-val">{{ seg.pct }}%</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 客户来源分析 -->
      <div class="chart-panel">
        <h3>来源渠道转化</h3>
        <el-table :data="sourceAnalysis" style="width: 100%" size="small">
          <el-table-column prop="source" label="来源" width="80" />
          <el-table-column prop="leads" label="线索" width="70" />
          <el-table-column prop="converted" label="转化" width="70" />
          <el-table-column prop="conversion_rate" label="转化率" width="90">
            <template #default="{ row }">
              <span :style="{ color: row.conversion_rate > 25 ? '#67C23A' : row.conversion_rate > 23 ? '#E6A23C' : '#F56C6C' }">
                {{ row.conversion_rate }}%
              </span>
            </template>
          </el-table-column>
          <el-table-column prop="revenue" label="营收" width="100">
            <template #default="{ row }">${{ row.revenue.toLocaleString() }}</template>
          </el-table-column>
        </el-table>
      </div>
    </div>

    <!-- 趋势与区域 -->
    <div class="chart-row">
      <!-- 月度趋势 -->
      <div class="chart-panel">
        <h3>月度新增客户趋势</h3>
        <div class="bar-chart">
          <div class="bar-item" v-for="m in monthlyTrend" :key="m.month">
            <div class="bar-columns">
              <div class="bar-col bar-new" :style="{ height: (m.new_customers / 6) + 'px' }" :title="'新增: ' + m.new_customers"></div>
              <div class="bar-col bar-converted" :style="{ height: (m.converted / 6) + 'px' }" :title="'转化: ' + m.converted"></div>
            </div>
            <div class="bar-label">{{ m.month }}</div>
          </div>
        </div>
        <div class="bar-legend">
          <span class="bl-item"><span class="bl-dot" style="background:#667eea"></span>新增客户</span>
          <span class="bl-item"><span class="bl-dot" style="background:#f5576c"></span>成交客户</span>
        </div>
      </div>

      <!-- 国家分布 TOP10 -->
      <div class="chart-panel">
        <h3>客户国家分布 TOP10</h3>
        <div class="country-list">
          <div class="country-item" v-for="c in countryDist" :key="c.country">
            <span class="cl-rank" :class="{ 'top3': c.rank <= 3 }">{{ c.rank }}</span>
            <span class="cl-name">{{ c.country }}</span>
            <div class="cl-bar">
              <div class="cl-fill" :style="{ width: c.percentage + '%', background: c.rank <= 3 ? '#f5576c' : '#909399' }"></div>
            </div>
            <span class="cl-val">{{ c.count.toLocaleString() }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 跟进人表现 -->
    <div class="chart-panel" style="margin-top: 0;">
      <h3>跟进人表现</h3>
      <el-table :data="staffPerformance" style="width: 100%" size="small" stripe>
        <el-table-column prop="staff" label="跟进人" width="80" />
        <el-table-column prop="customers" label="负责客户" width="90" />
        <el-table-column prop="converted" label="已成交" width="80" />
        <el-table-column prop="revenue" label="成交金额" width="120">
          <template #default="{ row }">${{ row.revenue.toLocaleString() }}</template>
        </el-table-column>
        <el-table-column prop="avg_response" label="平均响应" width="100" />
        <el-table-column label="转化率" width="150">
          <template #default="{ row }">
            <el-progress :percentage="Math.round(row.converted / row.customers * 1000) / 10" :stroke-width="8" color="#f5576c" />
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const period = ref('month')
const periodOpts = [{ label: '本周', value: 'week' }, { label: '本月', value: 'month' }, { label: '本季', value: 'quarter' }]

const totalCustomers = 3847
const hoverSegment = ref(null)

// 核心指标
const coreStats = [
  { key: 'leads', label: '总线索数', value: '3,847', sub: '↑ 12.5%' },
  { key: 'conv', label: '转化率', value: '24.8%', sub: '↑ 2.3%' },
  { key: 'deal', label: '平均客单', value: '$12,500', sub: '↑ 5.8%' },
  { key: 'cycle', label: '平均成交周期', value: '18天', sub: '↓ 2天' },
  { key: 'revenue', label: '总营收', value: '$482,500', sub: '↑ 18.2%' },
  { key: 'repeat', label: '复购率', value: '35.2%', sub: '↑ 1.8%' },
]

// 饼图数据 - 用SVG路径
function describeArc(cx, cy, r, startAngle, endAngle) {
  const start = polarToCartesian(cx, cy, r, endAngle)
  const end = polarToCartesian(cx, cy, r, startAngle)
  const largeArcFlag = endAngle - startAngle > 180 ? 1 : 0
  return `M ${cx} ${cy} L ${start.x} ${start.y} A ${r} ${r} 0 ${largeArcFlag} 0 ${end.x} ${end.y} Z`
}

function polarToCartesian(cx, cy, r, angle) {
  const rad = (angle - 90) * Math.PI / 180
  return { x: cx + r * Math.cos(rad), y: cy + r * Math.sin(rad) }
}

const statusSegments = (() => {
  const data = [
    { label: '潜在客户', value: 1845, color: '#409EFF' },
    { label: '已联系', value: 892, color: '#E6A23C' },
    { label: '洽谈中', value: 634, color: '#67C23A' },
    { label: '已成交', value: 376, color: '#F56C6C' },
    { label: '已流失', value: 100, color: '#909399' },
  ]
  let cumulative = 0
  return data.map(d => {
    const angle = d.value / totalCustomers * 360
    const start = cumulative
    cumulative += angle
    d.path = describeArc(100, 100, 85, start, cumulative)
    d.pct = Math.round(d.value / totalCustomers * 1000) / 10
    return d
  })
})()

// 来源分析
const sourceAnalysis = [
  { source: '独立站', leads: 1205, converted: 328, conversion_rate: 27.2, revenue: 215000 },
  { source: 'TikTok', leads: 892, converted: 215, conversion_rate: 24.1, revenue: 128000 },
  { source: 'Instagram', leads: 634, converted: 148, conversion_rate: 23.3, revenue: 82000 },
  { source: 'Facebook', leads: 487, converted: 112, conversion_rate: 23.0, revenue: 45000 },
  { source: 'WhatsApp', leads: 329, converted: 85, conversion_rate: 25.8, revenue: 42000 },
  { source: '其它', leads: 300, converted: 68, conversion_rate: 22.7, revenue: 30500 },
]

// 月度趋势
const monthlyTrend = [
  { month: '1月', new_customers: 320, converted: 78 },
  { month: '2月', new_customers: 285, converted: 65 },
  { month: '3月', new_customers: 410, converted: 102 },
  { month: '4月', new_customers: 456, converted: 115 },
  { month: '5月', new_customers: 520, converted: 138 },
  { month: '6月', new_customers: 586, converted: 148 },
]

// 国家分布
const countryDist = [
  { rank: 1, country: '美国', count: 856, percentage: 22.3 },
  { rank: 2, country: '巴西', count: 523, percentage: 13.6 },
  { rank: 3, country: '日本', count: 412, percentage: 10.7 },
  { rank: 4, country: '印度', count: 356, percentage: 9.3 },
  { rank: 5, country: '英国', count: 298, percentage: 7.7 },
  { rank: 6, country: '德国', count: 245, percentage: 6.4 },
  { rank: 7, country: '法国', count: 198, percentage: 5.1 },
  { rank: 8, country: '阿联酋', count: 186, percentage: 4.8 },
  { rank: 9, country: '韩国', count: 165, percentage: 4.3 },
  { rank: 10, country: '其它', count: 608, percentage: 15.8 },
]

// 跟进人表现
const staffPerformance = [
  { staff: '张三', customers: 1280, converted: 156, revenue: 195000, avg_response: '3.2min' },
  { staff: '李四', customers: 1050, converted: 128, revenue: 162000, avg_response: '4.5min' },
  { staff: '王五', customers: 960, converted: 92, revenue: 125500, avg_response: '5.8min' },
]
</script>

<style scoped>
.crm-analytics { max-width: 1400px; }

.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.page-title { font-size: 20px; font-weight: 700; color: #303133; margin: 0; }

/* 核心指标 */
.stats-row { display: grid; grid-template-columns: repeat(6, 1fr); gap: 12px; margin-bottom: 20px; }
.stat-card {
  background: #fff; border-radius: 10px; padding: 14px 16px; text-align: center;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}
.sc-label { font-size: 12px; color: #909399; margin-bottom: 4px; }
.sc-value { font-size: 20px; font-weight: 700; color: #303133; }
.sc-sub { font-size: 11px; color: #67C23A; margin-top: 2px; }

/* 图表行 */
.chart-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px; }
.chart-panel {
  background: #fff; border-radius: 10px; padding: 16px 20px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}
.chart-panel h3 { font-size: 15px; font-weight: 600; color: #303133; margin: 0 0 14px 0; }

/* 饼图 */
.pie-chart-wrapper { display: flex; align-items: center; gap: 24px; }
.pie-ring { position: relative; flex-shrink: 0; }
.pie-svg { width: 180px; height: 180px; }
.pie-segment { transition: transform 0.3s ease; cursor: pointer; }

.pie-tooltip {
  position: absolute; bottom: -30px; left: 50%; transform: translateX(-50%);
  padding: 4px 10px; border-radius: 4px; color: #fff; font-size: 11px;
  white-space: nowrap; z-index: 10;
}

.pie-legend { display: flex; flex-direction: column; gap: 8px; }
.legend-item { display: flex; align-items: center; gap: 8px; font-size: 12px; }
.legend-dot { width: 10px; height: 10px; border-radius: 3px; flex-shrink: 0; }
.legend-label { color: #606266; flex: 1; }
.legend-val { color: #303133; font-weight: 500; }

/* 柱状图 */
.bar-chart { display: flex; justify-content: space-around; align-items: flex-end; height: 160px; padding: 0 10px; }
.bar-item { display: flex; flex-direction: column; align-items: center; gap: 6px; }
.bar-columns { display: flex; gap: 4px; align-items: flex-end; height: 130px; }
.bar-col { width: 18px; border-radius: 4px 4px 0 0; transition: height 0.5s ease; }
.bar-new { background: #667eea; }
.bar-converted { background: #f5576c; opacity: 0.7; }
.bar-label { font-size: 11px; color: #909399; }

.bar-legend { display: flex; justify-content: center; gap: 20px; margin-top: 8px; }
.bl-item { display: flex; align-items: center; gap: 6px; font-size: 12px; color: #606266; }
.bl-dot { width: 10px; height: 10px; border-radius: 2px; }

/* 国家排行 */
.country-list { display: flex; flex-direction: column; gap: 8px; }
.country-item { display: flex; align-items: center; gap: 10px; }
.cl-rank { width: 20px; font-size: 12px; color: #909399; font-weight: 500; text-align: center; }
.cl-rank.top3 { color: #f5576c; font-weight: 700; }
.cl-name { width: 55px; font-size: 12px; color: #303133; }
.cl-bar { flex: 1; height: 16px; background: #f5f7fa; border-radius: 3px; overflow: hidden; }
.cl-fill { height: 100%; border-radius: 3px; transition: width 0.6s ease; }
.cl-val { font-size: 12px; color: #606266; width: 45px; text-align: right; }

:deep(.el-table) { font-size: 13px; }
</style>
