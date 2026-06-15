<template>
  <div class="page-container">
    <!-- 顶部统计 -->
    <div class="top-section">
      <div class="page-header">
        <h2 class="page-title">爆款视频分析</h2>
      </div>
      <div class="stat-strip">
        <div class="strip-item" v-for="s in stats" :key="s.label">
          <div class="si-icon">{{ s.icon }}</div>
          <div class="si-info"><span class="si-num">{{ s.num }}</span><span class="si-lbl">{{ s.label }}</span></div>
        </div>
      </div>
    </div>

    <!-- 饼状图区域 -->
    <div class="chart-section">
      <div class="section-title">品类数据分布</div>
      <div class="chart-grid">
        <div class="chart-card" v-for="ch in chartList" :key="ch.key">
          <div class="chart-header">{{ ch.title }}</div>
          <div style="position:relative">
            <div :ref="el => setChartRef(ch.key, el)" class="chart-inst"></div>
            <!-- 悬浮提示 -->
            <div v-if="tooltip.key === ch.key" class="chart-tooltip" :style="tooltipStyle">
              <div class="tt-name">{{ tooltip.name }}</div>
              <div class="tt-value">{{ tooltip.value }}</div>
              <div class="tt-percent">{{ tooltip.percent }}%</div>
            </div>
          </div>
          <div class="chart-legend">
            <span 
              v-for="(item, idx) in legendData" 
              :key="item.name" 
              class="cl-item"
              @mouseenter="onLegendHover(ch.key, idx)"
              @mouseleave="onLegendLeave(ch.key)"
            >
              <i class="cl-dot" :style="{ background: item.color }"></i>{{ item.name }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- 榜单 -->
    <div class="section-title" style="margin-top: 20px;">爆款视频 TOP10</div>
    <div class="leaderboard">
      <div class="lb-item" v-for="(v, i) in videos" :key="i" :class="{ 'top-three': i < 3 }">
        <div class="lb-rank">
          <span v-if="i === 0" class="rank-crown">👑</span>
          <span v-else-if="i < 3" class="rank-medal">{{ ['🥈','🥉'][i-1] }}</span>
          <span v-else class="rank-num">{{ i + 1 }}</span>
        </div>
        <div class="lb-main">
          <div class="lb-title-row">
            <span class="lb-category" :style="{ background: v.catColor }">{{ v.category }}</span>
            <span class="lb-title">{{ v.title }}</span>
          </div>
          <div class="lb-metrics">
            <div class="lb-metric">
              <div class="lm-bar-bg"><div class="lm-bar" :style="{ width: (v.views / 300 * 100) + '%', background: v.barColor }"></div></div>
              <div class="lm-info"><span class="lm-label">播放</span><span class="lm-val">{{ v.views }}万</span></div>
            </div>
            <div class="lb-metric">
              <div class="lm-bar-bg"><div class="lm-bar" :style="{ width: v.engagement * 10 + '%', background: v.barColor }"></div></div>
              <div class="lm-info"><span class="lm-label">互动率</span><span class="lm-val">{{ v.engagement }}%</span></div>
            </div>
            <div class="lb-metric">
              <div class="lm-bar-bg"><div class="lm-bar" :style="{ width: v.conversion * 15 + '%', background: v.barColor }"></div></div>
              <div class="lm-info"><span class="lm-label">转化率</span><span class="lm-val">{{ v.conversion }}%</span></div>
            </div>
          </div>
        </div>
        <div class="lb-extra">
          <span class="lb-duration">⏱ {{ v.duration }}</span>
          <span class="lb-hook">{{ v.hook }}</span>
          <span class="lb-style">{{ v.style }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, onUnmounted, nextTick, watch } from 'vue'
import * as echarts from 'echarts'

const stats = [
  { icon: '📊', num: '1,286', label: '监测视频' },
  { icon: '🔥', num: '328', label: '本周爆款' },
  { icon: '💬', num: '4.2%', label: '平均互动率' },
  { icon: '⏱', num: '3.8s', label: '平均完播' }
]

const videos = [
  { category: '美妆', catColor: '#fce4ec', barColor: '#ec4899', title: '素人改造挑战｜普通女孩变欧美博主只需三步', views: 286, engagement: 7.8, conversion: 4.2, duration: '28s', hook: '悬念/反差', style: 'Vlog' },
  { category: '家居', catColor: '#e8f5e9', barColor: '#10b981', title: '10元以下收纳好物，租房党必看！', views: 253, engagement: 6.5, conversion: 5.1, duration: '42s', hook: '痛点/省钱', style: '测评' },
  { category: '服装', catColor: '#e3f2fd', barColor: '#3b82f6', title: '全网最全！显瘦穿搭公式一篇搞定', views: 218, engagement: 8.2, conversion: 3.8, duration: '35s', hook: '合集/教程', style: '穿搭' },
  { category: '3C数码', catColor: '#ede9fe', barColor: '#7c4dff', title: '男朋友收到这个礼物哭了…年度最走心推荐', views: 195, engagement: 5.6, conversion: 6.3, duration: '22s', hook: '情感/故事', style: '开箱' },
  { category: '厨具', catColor: '#fff3e0', barColor: '#f59e0b', title: '厨房小白的进阶之路，三款锅具横向测评', views: 182, engagement: 4.8, conversion: 4.5, duration: '55s', hook: '对比/测评', style: '测评' },
  { category: '运动', catColor: '#e0f2f1', barColor: '#14b8a6', title: '新手健身避坑指南，这些动作做错会伤腰', views: 167, engagement: 9.1, conversion: 2.8, duration: '38s', hook: '警告/避坑', style: '教程' },
  { category: '宠物', catColor: '#fce4ec', barColor: '#ec4899', title: '猫咪最爱的10款玩具，第7款让我家猫疯了', views: 145, engagement: 6.9, conversion: 5.8, duration: '25s', hook: '排名/悬念', style: 'Vlog' },
  { category: '食品', catColor: '#fff8e1', barColor: '#f59e0b', title: '打工人快速早餐合集，5分钟搞定一周', views: 132, engagement: 5.2, conversion: 7.2, duration: '48s', hook: '实用/省时', style: '教程' },
  { category: '鞋履', catColor: '#f3e5f5', barColor: '#a855f7', title: '这双鞋我穿了三个月，真实体验反馈来了', views: 118, engagement: 4.5, conversion: 4.6, duration: '31s', hook: '真实/长期', style: '测评' },
  { category: '数码', catColor: '#e3f2fd', barColor: '#3b82f6', title: '女生第一台相机怎么选？5000预算攻略', views: 105, engagement: 6.3, conversion: 3.9, duration: '46s', hook: '选购/攻略', style: '教程' }
]

const pieColors = ['#ec4899','#10b981','#3b82f6','#7c4dff','#f59e0b','#14b8a6','#f472b6','#8b5cf6','#a855f7','#6366f1']

// 按品类聚合数据
const categoryMap = new Map()
videos.forEach(v => {
  if (!categoryMap.has(v.category)) {
    categoryMap.set(v.category, { views: 0, engagement: 0, conversion: 0, count: 0 })
  }
  const c = categoryMap.get(v.category)
  c.views += v.views
  c.engagement += v.engagement
  c.conversion += v.conversion
  c.count++
})
const categories = Array.from(categoryMap.keys())

const legendData = categories.map((c, i) => ({
  name: c,
  color: pieColors[i % pieColors.length]
}))

const chartList = [
  { key: 'views', title: '播放量分布', unit: '万' },
  { key: 'engagement', title: '互动率分布', unit: '%' },
  { key: 'conversion', title: '转化率分布', unit: '%' },
  { key: 'count', title: '视频数量分布', unit: '个' }
]

const chartRefs = {}
const chartInstances = {}
const setChartRef = (key, el) => {
  if (el) chartRefs[key] = el
}

const tooltip = reactive({ key: null, name: '', value: '', percent: '', x: 0, y: 0 })
const tooltipStyle = computed(() => ({
  left: tooltip.x + 'px',
  top: tooltip.y + 'px'
}))

const makeData = (key) => {
  return categories.map((c, i) => ({
    name: c,
    value: Math.round((categoryMap.get(c)[key] || 0) * 10) / 10,
    itemStyle: { color: pieColors[i % pieColors.length] }
  }))
}

const makeOption = (key) => ({
  tooltip: {
    trigger: 'item',
    backgroundColor: 'rgba(20,20,30,0.92)',
    borderColor: 'transparent',
    textStyle: { color: '#fff', fontSize: 13 },
    formatter: '{b}<br/>{c} ({d}%)'
  },
  series: [{
    type: 'pie',
    radius: ['50%', '75%'],
    center: ['50%', '50%'],
    avoidLabelOverlap: false,
    itemStyle: { borderRadius: 4, borderColor: '#fff', borderWidth: 2 },
    label: { show: false },
    emphasis: {
      label: { show: true, fontSize: 14, fontWeight: 'bold', formatter: '{d}%' },
      scaleSize: 6,
      itemStyle: { shadowBlur: 20, shadowColor: 'rgba(0,0,0,0.15)' }
    },
    data: makeData(key)
  }]
})

const onLegendHover = (chartKey, idx) => {
  const chart = chartInstances[chartKey]
  if (!chart) return
  chart.dispatchAction({ type: 'highlight', seriesIndex: 0, dataIndex: idx })
}

const onLegendLeave = (chartKey) => {
  const chart = chartInstances[chartKey]
  if (!chart) return
  chart.dispatchAction({ type: 'downplay', seriesIndex: 0 })
}

let resizeHandler = null

onMounted(async () => {
  await nextTick()
  chartList.forEach(ch => {
    const dom = chartRefs[ch.key]
    if (!dom) return
    const instance = echarts.init(dom)
    instance.setOption(makeOption(ch.key))
    chartInstances[ch.key] = instance
  })
  resizeHandler = () => {
    Object.values(chartInstances).forEach(c => c.resize())
  }
  window.addEventListener('resize', resizeHandler)
})

onUnmounted(() => {
  Object.values(chartInstances).forEach(c => c.dispose())
  if (resizeHandler) window.removeEventListener('resize', resizeHandler)
})
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.top-section { background: #fff; border-radius: 16px; padding: 24px; margin-bottom: 20px; box-shadow: 0 1px 6px rgba(0,0,0,0.04); }
.page-title { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0 0 16px 0; }
.stat-strip { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; }
.strip-item { display: flex; align-items: center; gap: 12px; padding: 14px 16px; background: #fafafa; border-radius: 12px; }
.si-icon { font-size: 24px; }
.si-info { display: flex; flex-direction: column; }
.si-num { font-size: 22px; font-weight: 800; color: #1a1a1a; }
.si-lbl { font-size: 12px; color: #8c8c8c; }

.chart-section { background: #fff; border-radius: 16px; padding: 24px; margin-bottom: 20px; box-shadow: 0 1px 6px rgba(0,0,0,0.04); }
.section-title { font-size: 16px; font-weight: 700; color: #1a1a1a; margin-bottom: 16px; }
.chart-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; }
.chart-card { border: 1px solid #f0f0f0; border-radius: 12px; padding: 18px 14px 16px; transition: all 0.25s; background: #fafbfc; display: flex; flex-direction: column; }
.chart-card:hover { border-color: #c4b5fd; box-shadow: 0 4px 12px rgba(124,77,255,0.06); }
.chart-header { font-size: 13px; font-weight: 600; color: #555; margin-bottom: 8px; text-align: center; flex-shrink: 0; }
.chart-inst { width: 100%; height: 240px; }

.chart-tooltip { 
  position: absolute; background: rgba(20,20,30,0.92); color: #fff; border-radius: 8px; 
  padding: 10px 14px; font-size: 12px; pointer-events: none; z-index: 100; white-space: nowrap;
}
.tt-name { font-weight: 700; font-size: 13px; }
.tt-value { color: #ccc; margin-top: 2px; }
.tt-percent { color: #aaa; font-size: 11px; }

.chart-legend { display: flex; flex-wrap: wrap; gap: 4px 10px; margin-top: 8px; justify-content: center; }
.cl-item { font-size: 11px; color: #777; cursor: pointer; display: flex; align-items: center; gap: 4px; white-space: nowrap; }
.cl-item:hover { color: #333; }
.cl-dot { display: inline-block; width: 7px; height: 7px; border-radius: 50%; flex-shrink: 0; }

.leaderboard { display: flex; flex-direction: column; gap: 8px; }
.lb-item { display: flex; align-items: center; gap: 16px; padding: 16px 20px; background: #fff; border-radius: 14px; transition: all 0.25s; cursor: pointer; border: 1px solid transparent; box-shadow: 0 1px 3px rgba(0,0,0,0.03); }
.lb-item:hover { border-color: #c4b5fd; box-shadow: 0 4px 16px rgba(124,77,255,0.08); transform: translateX(4px); }
.lb-item.top-three { border: 1px solid #f0f0f0; }
.lb-rank { width: 44px; text-align: center; flex-shrink: 0; }
.rank-crown, .rank-medal { font-size: 26px; }
.rank-num { font-size: 18px; font-weight: 700; color: #b0b0b0; }
.lb-main { flex: 1; min-width: 0; }
.lb-title-row { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; }
.lb-category { font-size: 11px; font-weight: 600; padding: 2px 9px; border-radius: 6px; color: #666; flex-shrink: 0; }
.lb-title { font-size: 14px; font-weight: 600; color: #1a1a1a; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.lb-metrics { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
.lb-metric { display: flex; flex-direction: column; gap: 4px; }
.lm-bar-bg { height: 6px; background: #f0f0f0; border-radius: 3px; overflow: hidden; }
.lm-bar { height: 100%; border-radius: 3px; transition: width 0.6s ease; }
.lm-info { display: flex; justify-content: space-between; align-items: center; }
.lm-label { font-size: 10px; color: #b0b0b0; }
.lm-val { font-size: 12px; font-weight: 600; color: #555; }
.lb-extra { display: flex; gap: 8px; flex-shrink: 0; }
.lb-duration { font-size: 12px; color: #8c8c8c; }
.lb-hook { font-size: 11px; color: #7c4dff; background: #f5f0ff; padding: 2px 8px; border-radius: 6px; }
.lb-style { font-size: 11px; color: #666; background: #f5f5f5; padding: 2px 8px; border-radius: 6px; }
</style>
