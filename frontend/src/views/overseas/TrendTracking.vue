<template>
  <div class="trend-tracking">
    <!-- ====== 顶部标题 ====== -->
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">趋势追踪</h1>
        <p class="page-subtitle">热搜关键词 · 热门话题 · 品类趋势 · 政策动态</p>
      </div>
    </div>

    <!-- ====== 第一部分：热搜关键词（标签云） ====== -->
    <div class="section">
      <div class="section-header">
        <h2 class="section-title">🔍 热搜关键词</h2>
        <span class="section-hint">点击关键词查看品类趋势</span>
      </div>
      <div class="keyword-cloud">
        <span
          v-for="k in trendData.keywords"
          :key="k.keyword"
          class="keyword-item"
          :class="{ active: activeKeyword === k.keyword }"
          :style="{ fontSize: keywordSize(k.heat) + 'px' }"
          @click="onKeywordClick(k)"
        >
          {{ k.keyword }}
          <span v-if="k.trend === 'up'" class="kw-arrow up">↑</span>
          <span v-else-if="k.trend === 'down'" class="kw-arrow down">↓</span>
        </span>
      </div>
    </div>

    <!-- ====== 第二部分：热门话题 ====== -->
    <div class="section">
      <div class="section-header">
        <h2 class="section-title">📢 热门话题</h2>
        <span class="section-hint">基于 TikTok/Instagram/Twitter 讨论数据</span>
      </div>
      <div class="topics-scroll">
        <div
          v-for="t in trendData.topics"
          :key="t.topic"
          class="topic-card"
          :class="{ 'is-hot': t.heat >= 90 }"
        >
          <div class="topic-header">
            <span class="topic-name">{{ t.topic }}</span>
            <span v-if="t.heat >= 90" class="fire-badge">🔥</span>
          </div>
          <div class="topic-metrics">
            <span class="topic-discussions">{{ formatNum(t.discussions) }} 讨论</span>
          </div>
          <div class="topic-heat-bar">
            <div class="thb-fill" :style="{ width: t.heat + '%', background: heatGradient(t.heat) }" />
          </div>
          <span class="topic-heat-label">热度 {{ t.heat }}</span>
        </div>
      </div>
    </div>

    <!-- ====== 第三部分：品类趋势图 ====== -->
    <div class="section">
      <div class="section-header">
        <h2 class="section-title">📈 品类趋势 · 近30天</h2>
        <span class="section-hint">图例可点击切换</span>
      </div>
      <div class="chart-card card">
        <div ref="trendChartRef" class="chart-body" style="height: 400px" />
      </div>
    </div>

    <!-- ====== 第四部分：政策与合规动态 ====== -->
    <div class="section">
      <div class="section-header">
        <h2 class="section-title">📋 政策与合规动态</h2>
        <span class="section-hint">跨境政策实时追踪</span>
      </div>
      <div class="policy-list">
        <div
          v-for="p in trendData.policyNews"
          :key="p.id"
          class="policy-item"
        >
          <div class="policy-left">
            <span class="urgency-dot" :class="'urgency-' + p.urgency" />
            <div class="policy-info">
              <div class="pi-top">
                <span class="pi-category" :class="'urgency-' + p.urgency">
                  {{ p.urgency === 'high' ? '紧急' : p.urgency === 'medium' ? '关注' : '资讯' }}
                </span>
                <span class="pi-country">{{ countryFlag(p.country) }} {{ p.country }}</span>
              </div>
              <p class="pi-title">{{ p.title }}</p>
              <div class="pi-meta">
                <span class="pi-cat-label">{{ p.category }}</span>
                <span class="pi-date">{{ p.date }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
/**
 * 趋势追踪页面
 *
 * 功能：
 * - 热搜关键词标签云（大小=热度，点击高亮）
 * - 热门话题横向滚动卡片
 * - 品类趋势 ECharts 折线图（30天，图例可切换）
 * - 政策与合规动态列表（紧急/关注/资讯分级）
 *
 * 数据来源：frontend/src/api/overseas.js → getTrendData()
 */

import { ref, onMounted, onUnmounted, nextTick } from 'vue'
import * as echarts from 'echarts/core'
import { LineChart } from 'echarts/charts'
import { GridComponent, TooltipComponent, LegendComponent } from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import { getTrendData } from '@/api/overseas'

echarts.use([LineChart, GridComponent, TooltipComponent, LegendComponent, CanvasRenderer])

// ====== 数据 ======
const trendData = getTrendData()
const activeKeyword = ref('')

// ====== 国旗 ======
const flagMap = {
  '欧盟': '🇪🇺', '美国': '🇺🇸', '印尼': '🇮🇩', '英国': '🇬🇧',
  '巴西': '🇧🇷', '东南亚': '🌏', '德国': '🇩🇪', '日本': '🇯🇵',
  '阿联酋': '🇦🇪', '韩国': '🇰🇷'
}
function countryFlag(c) { return flagMap[c] || '🌐' }

// ====== 关键词字号 ======
function keywordSize(heat) {
  if (heat >= 90) return 26
  if (heat >= 80) return 22
  if (heat >= 70) return 18
  if (heat >= 60) return 16
  return 14
}

function onKeywordClick(k) {
  activeKeyword.value = activeKeyword.value === k.keyword ? '' : k.keyword
}

// ====== 格式化 ======
function formatNum(n) {
  if (n >= 1000000) return (n / 1000000).toFixed(1) + 'M'
  if (n >= 1000) return (n / 1000).toFixed(1) + 'K'
  return String(n)
}

function heatGradient(h) {
  if (h >= 90) return 'linear-gradient(90deg, #F56C6C, #FF7A45)'
  if (h >= 75) return 'linear-gradient(90deg, #E6A23C, #F5C542)'
  return 'linear-gradient(90deg, #409EFF, #79BBFF)'
}

// ====== ECharts 品类趋势图 ======
const trendChartRef = ref(null)
let trendChartInstance = null

const categoryConfig = [
  { key: 'clothing', label: '服装', color: '#C9A96E' },
  { key: 'beauty', label: '美妆', color: '#F56C6C' },
  { key: 'digital3c', label: '3C数码', color: '#409EFF' },
  { key: 'home', label: '家居', color: '#67C23A' },
  { key: 'sports', label: '运动户外', color: '#E6A23C' },
  { key: 'food', label: '食品饮料', color: '#FF8C42' },
  { key: 'jewelry', label: '珠宝饰品', color: '#A78BFA' },
  { key: 'baby', label: '母婴', color: '#EC407A' },
  { key: 'pet', label: '宠物', color: '#26C6DA' },
  { key: 'personalCare', label: '个护', color: '#FF7043' }
]

function initTrendChart() {
  if (!trendChartRef.value) return
  if (trendChartInstance) trendChartInstance.dispose()

  const data = trendData.categoryTrends

  trendChartInstance = echarts.init(trendChartRef.value)
  trendChartInstance.setOption({
    tooltip: {
      trigger: 'axis',
      backgroundColor: '#fff',
      borderColor: '#e8ecf1',
      borderWidth: 1,
      padding: [10, 14],
      extraCssText: 'box-shadow: 0 4px 20px rgba(0,0,0,0.08); border-radius: 8px;'
    },
    legend: {
      bottom: 0,
      textStyle: { fontSize: 11, color: '#8A9AA8' },
      itemWidth: 14, itemHeight: 2, itemGap: 16,
      type: 'scroll'
    },
    grid: { left: 42, right: 20, top: 20, bottom: 48 },
    xAxis: {
      type: 'category',
      data: Array.from({ length: data.length }, (_, i) => `D${i + 1}`),
      axisLine: { lineStyle: { color: '#E8ECF1' } },
      axisLabel: { fontSize: 9, color: '#B0BCC8', interval: 2 }
    },
    yAxis: {
      type: 'value',
      min: 40,
      max: 95,
      splitLine: { lineStyle: { color: '#F0F2F5', type: 'dashed' } },
      axisLabel: { fontSize: 11, color: '#8A9AA8' }
    },
    color: categoryConfig.map(c => c.color),
    series: categoryConfig.map(c => ({
      name: c.label,
      type: 'line',
      data: data.map(d => d[c.key]),
      smooth: true,
      symbol: 'none',
      lineStyle: { width: 2 }
    }))
  })
}

// ====== 响应式 ======
function handleResize() { trendChartInstance?.resize() }

onMounted(() => {
  nextTick(() => initTrendChart())
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  trendChartInstance?.dispose()
})
</script>

<style scoped>
.trend-tracking {
  max-width: 1440px;
  margin: 0 auto;
  min-height: 100vh;
}

/* ====== 页面标题 ====== */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 36px;
}
.header-left { display: flex; flex-direction: column; gap: 6px; }
.page-title { margin: 0; font-size: 28px; font-weight: 700; color: #1A2A3A; letter-spacing: -0.3px; }
.page-subtitle { margin: 0; font-size: 14px; color: #8A9AA8; }

/* ====== 章节 ====== */
.section { margin-bottom: 40px; }
.section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.section-title { margin: 0; font-size: 17px; font-weight: 600; color: #1A2A3A; }
.section-hint { font-size: 12px; color: #B0BCC8; }

/* ====== 通用卡片 ====== */
.card {
  background: #fff; border-radius: 16px;
  padding: 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.04);
}
.chart-body { width: 100%; }

/* ====== 关键词云 ====== */
.keyword-cloud {
  display: flex;
  flex-wrap: wrap;
  gap: 10px 20px;
  align-items: center;
  justify-content: center;
  padding: 32px 20px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
}
.keyword-item {
  cursor: pointer;
  font-weight: 600;
  padding: 4px 12px;
  border-radius: 20px;
  transition: all 0.2s;
  color: #4A5A6A;
  position: relative;
  white-space: nowrap;
}
.keyword-item:hover { background: #FDF8F0; color: #C9A96E; }
.keyword-item.active { background: #C9A96E; color: #fff; }
.kw-arrow { font-size: 10px; margin-left: 2px; }
.kw-arrow.up { color: #52C41A; }
.kw-arrow.down { color: #F56C6C; }
.keyword-item.active .kw-arrow { color: inherit; }

/* ====== 热门话题横向滚动 ====== */
.topics-scroll {
  display: flex;
  gap: 16px;
  overflow-x: auto;
  padding-bottom: 6px;
  scrollbar-width: thin;
  scrollbar-color: #E8ECF1 transparent;
}
.topics-scroll::-webkit-scrollbar { height: 6px; }
.topics-scroll::-webkit-scrollbar-thumb { background: #E8ECF1; border-radius: 3px; }

.topic-card {
  flex: 0 0 220px;
  background: #fff;
  border-radius: 14px;
  padding: 18px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.03);
  transition: all 0.25s;
  cursor: pointer;
  display: flex; flex-direction: column; gap: 10px;
  border-top: 3px solid #E8ECF1;
}
.topic-card:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(0,0,0,0.06); }
.topic-card.is-hot { border-top-color: #F56C6C; }

.topic-header { display: flex; justify-content: space-between; align-items: center; }
.topic-name { font-size: 14px; font-weight: 600; color: #1A2A3A; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.fire-badge { font-size: 18px; animation: pulse 1.5s infinite; }
@keyframes pulse { 0%,100% { opacity: 1; } 50% { opacity: 0.5; } }

.topic-discussions { font-size: 12px; color: #8A9AA8; }

.topic-heat-bar { height: 5px; background: #F0F2F5; border-radius: 3px; overflow: hidden; }
.thb-fill { height: 100%; border-radius: 3px; transition: width 0.5s; }

.topic-heat-label { font-size: 11px; color: #B0BCC8; text-align: right; }

/* ====== 政策列表 ====== */
.policy-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.policy-item {
  background: #fff;
  border-radius: 14px;
  padding: 18px 22px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.03);
  transition: all 0.2s;
  cursor: pointer;
}
.policy-item:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.06); transform: translateX(4px); }

.policy-left { display: flex; gap: 14px; }

.urgency-dot {
  width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0;
  margin-top: 6px;
}
.urgency-high { background: #F56C6C; box-shadow: 0 0 0 4px rgba(245,108,108,0.15); }
.urgency-medium { background: #E6A23C; box-shadow: 0 0 0 4px rgba(230,162,60,0.15); }
.urgency-low { background: #8A9AA8; box-shadow: 0 0 0 4px rgba(138,154,168,0.1); }

.policy-info { flex: 1; min-width: 0; }
.pi-top { display: flex; align-items: center; gap: 10px; margin-bottom: 6px; }
.pi-category {
  font-size: 10px; font-weight: 600; padding: 2px 8px; border-radius: 4px;
}
.pi-category.urgency-high { background: #FFF0F0; color: #F56C6C; }
.pi-category.urgency-medium { background: #FFF7E6; color: #E6A23C; }
.pi-category.urgency-low { background: #F5F6F8; color: #8A9AA8; }
.pi-country { font-size: 13px; color: #4A5A6A; font-weight: 500; }

.pi-title { margin: 0 0 6px; font-size: 14px; color: #1A2A3A; line-height: 1.4; font-weight: 500; }
.pi-meta { display: flex; gap: 12px; }
.pi-cat-label { font-size: 11px; color: #B0BCC8; }
.pi-date { font-size: 11px; color: #D0D8E0; }

/* ====== 响应式 ====== */
@media (max-width: 768px) {
  .keyword-cloud { padding: 20px 12px; gap: 8px 14px; }
  .page-header { flex-direction: column; align-items: flex-start; }
  .page-subtitle { font-size: 12px; }
}
</style>
