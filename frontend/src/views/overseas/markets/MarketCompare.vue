<template>
  <div class="market-compare" ref="pageRef">
    <!-- ====== 顶部：标题 + 市场选择器 ====== -->
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">市场对比</h1>
        <p class="page-subtitle">多维度横向PK · 精准选市场</p>
      </div>
      <div class="header-selector">
        <span class="selector-label">选择对比市场：</span>
        <el-select
          v-model="selectedCodes"
          multiple
          collapse-tags
          collapse-tags-tooltip
          :max-collapse-tags="2"
          placeholder="请选择市场（最多4个）"
          class="market-select"
          popper-class="market-select-popper"
        >
          <el-option
            v-for="m in allMarkets"
            :key="m.code"
            :label="countryFlag(m.code) + ' ' + m.name"
            :value="m.code"
            :disabled="selectedCodes.length >= 4 && !selectedCodes.includes(m.code)"
          >
            <span class="option-flag">{{ countryFlag(m.code) }}</span>
            <span class="option-name">{{ m.name }}</span>
            <span class="option-detail">{{ m.ecomScale }}B / +{{ m.growthRate }}%</span>
          </el-option>
        </el-select>
      </div>
    </div>

    <!-- ====== 对比卡片行 ====== -->
    <div class="compare-cards-row" v-if="selectedMarkets.length > 0">
      <div
        v-for="(m, idx) in selectedMarkets"
        :key="m.code"
        class="compare-card"
        :class="{ 'is-lead': idx === 0 && selectedMarkets.length > 1 }"
        :style="{ animationDelay: idx * 0.08 + 's' }"
      >
        <!-- 卡片头部：国旗 + 国家名 + 区域标签 -->
        <div class="card-head">
          <div class="card-country">
            <span class="card-flag">{{ countryFlag(m.code) }}</span>
            <div class="card-name-row">
              <span class="card-name">{{ m.name }}</span>
              <span class="card-region" :style="{ background: regionColor(m.code) }">{{ getRegion(m.code) }}</span>
            </div>
          </div>
          <span class="diff-badge" :class="'diff-' + (m.difficulty === '低' ? 'low' : m.difficulty === '中' ? 'mid' : 'high')">
            {{ difficultyLabel(m.difficulty) }}
          </span>
        </div>

        <!-- 核心指标 2×2 网格 -->
        <div class="metrics-grid">
          <div class="metric-cell">
            <span class="metric-label">电商规模</span>
            <span class="metric-value">${{ m.ecomScale }}B</span>
          </div>
          <div class="metric-cell">
            <span class="metric-label">年增长率</span>
            <span class="metric-value growth-up">+{{ m.growthRate }}%</span>
          </div>
          <div class="metric-cell">
            <span class="metric-label">TikTok 渗透</span>
            <span class="metric-value">{{ m.tiktokPenetration }}%</span>
          </div>
          <div class="metric-cell">
            <span class="metric-label">市场热度</span>
            <span class="metric-value heat">{{ m.heat }}</span>
          </div>
        </div>

        <!-- 评分条：物流时效 / 支付覆盖率 / 竞争度 -->
        <div class="score-bars">
          <div class="score-item">
            <div class="score-header">
              <span class="score-label">物流时效</span>
              <span class="score-value">{{ logScore(m) }}</span>
            </div>
            <div class="score-track">
              <div
                class="score-fill"
                :style="{ width: logPercent(m) + '%', background: barGradient(logPercent(m)) }"
              />
            </div>
          </div>
          <div class="score-item">
            <div class="score-header">
              <span class="score-label">支付覆盖</span>
              <span class="score-value">{{ payScore(m) }}</span>
            </div>
            <div class="score-track">
              <div
                class="score-fill"
                :style="{ width: payPercent(m) + '%', background: barGradient(payPercent(m)) }"
              />
            </div>
          </div>
          <div class="score-item">
            <div class="score-header">
              <span class="score-label">竞争度</span>
              <span class="score-value">{{ compScore(m) }}</span>
            </div>
            <div class="score-track">
              <div
                class="score-fill"
                :style="{ width: compPercent(m) + '%', background: barGradient(compPercent(m)) }"
              />
            </div>
          </div>
        </div>

        <!-- 平台标签 -->
        <div class="card-platforms">
          <span v-for="p in m.platforms" :key="p" class="platform-tag">{{ p }}</span>
        </div>

        <!-- 进入难度 -->
        <div class="card-footer">
          <span class="footer-label">进入难度评估</span>
          <span class="footer-value" :class="'diff-' + (m.difficulty === '低' ? 'low' : m.difficulty === '中' ? 'mid' : 'high')">
            {{ entryAdvice(m) }}
          </span>
        </div>
      </div>

      <!-- 空卡片占位补齐 4 列 -->
      <div
        v-for="n in (4 - selectedMarkets.length)"
        :key="'empty-' + n"
        class="compare-card empty-card"
      >
        <div class="empty-inner">
          <el-icon :size="32" color="#D0D8E0"><Plus /></el-icon>
          <span class="empty-text">选择市场进行对比</span>
        </div>
      </div>
    </div>

    <!-- 未选择时的引导 -->
    <div v-else class="empty-state">
      <span class="empty-icon">🌍</span>
      <p class="empty-title">请选择要对比的市场</p>
      <p class="empty-hint">从上方下拉框中选择最多 4 个市场，开始多维度横向对比</p>
    </div>

    <!-- ====== 下半部分：雷达图 + 排名表 (≥2) ====== -->
    <div v-if="selectedMarkets.length >= 2" class="bottom-section">
      <!-- 雷达图 -->
      <div class="card radar-card">
        <div class="card-header">
          <h3 class="card-title">多维度雷达对比</h3>
          <div class="radar-legend">
            <span
              v-for="(m, i) in selectedMarkets"
              :key="m.code"
              class="legend-tag"
              :style="{ borderColor: radarColors[i], color: radarColors[i] }"
            >
              <span class="legend-dot" :style="{ background: radarColors[i] }" />
              {{ m.name }}
            </span>
          </div>
        </div>
        <div ref="radarChartRef" class="chart-container" style="height: 380px" />
      </div>

      <!-- 综合评分排名表 -->
      <div class="card rank-card">
        <div class="card-header">
          <h3 class="card-title">综合对比排名</h3>
          <span class="rank-hint">基于加权综合评分</span>
        </div>
        <el-table
          :data="rankedMarkets"
          stripe
          class="rank-table"
          :header-cell-style="tableHeaderStyle"
          :row-class-name="tableRowClass"
        >
          <el-table-column prop="rank" label="排名" width="60" align="center">
            <template #default="{ row }">
              <span class="rank-num" :class="{ 'top-rank': row.rank <= 3 }">{{ row.rank }}</span>
            </template>
          </el-table-column>
          <el-table-column label="国家" width="130">
            <template #default="{ row }">
              <span class="country-cell">
                <span class="flag">{{ countryFlag(row.code) }}</span>
                <span>{{ row.name }}</span>
              </span>
            </template>
          </el-table-column>
          <el-table-column label="综合评分" width="100" align="center" sortable prop="totalScore">
            <template #default="{ row }">
              <span class="total-score" :style="{ color: scoreColor(row.totalScore) }">{{ row.totalScore.toFixed(1) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="优势标签" min-width="160">
            <template #default="{ row }">
              <div class="tag-row">
                <span v-for="t in row.advantageTags" :key="t" class="adv-tag">{{ t }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="建议" min-width="200">
            <template #default="{ row }">
              <span class="advice-text">{{ row.advice }}</span>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>

    <!-- 仅 1 个市场时展示全量排名表 -->
    <div v-else-if="selectedMarkets.length === 1" class="bottom-section single">
      <div class="card rank-card full-width">
        <div class="card-header">
          <h3 class="card-title">全球市场排名</h3>
          <span class="rank-hint">所有市场综合评分</span>
        </div>
        <el-table
          :data="allRankedMarkets"
          stripe
          class="rank-table"
          :header-cell-style="tableHeaderStyle"
          :row-class-name="tableRowClass"
        >
          <el-table-column prop="rank" label="排名" width="60" align="center">
            <template #default="{ row }">
              <span class="rank-num" :class="{ 'top-rank': row.rank <= 3 }">{{ row.rank }}</span>
            </template>
          </el-table-column>
          <el-table-column label="国家" width="130">
            <template #default="{ row }">
              <span class="country-cell">
                <span class="flag">{{ countryFlag(row.code) }}</span>
                <span>{{ row.name }}</span>
              </span>
            </template>
          </el-table-column>
          <el-table-column label="综合评分" width="100" align="center" sortable prop="totalScore">
            <template #default="{ row }">
              <span class="total-score" :style="{ color: scoreColor(row.totalScore) }">{{ row.totalScore.toFixed(1) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="电商规模" width="100" align="center">
            <template #default="{ row }">${{ row.ecomScale }}B</template>
          </el-table-column>
          <el-table-column label="增长率" width="90" align="center">
            <template #default="{ row }">{{ row.growthRate }}%</template>
          </el-table-column>
          <el-table-column label="TikTok渗透" width="110" align="center">
            <template #default="{ row }">{{ row.tiktokPenetration }}%</template>
          </el-table-column>
          <el-table-column label="优势标签" min-width="160">
            <template #default="{ row }">
              <div class="tag-row">
                <span v-for="t in row.advantageTags" :key="t" class="adv-tag">{{ t }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="建议" min-width="200">
            <template #default="{ row }">
              <span class="advice-text">{{ row.advice }}</span>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>
  </div>
</template>

<script setup>
/**
 * 市场对比页面
 *
 * 功能：
 *  - 多选下拉（最多 4 个市场），默认选中美国、印尼、英国
 *  - 对比卡片：国旗+国家名、核心指标 2×2 网格、评分条（物流/支付/竞争）、进入难度
 *  - 雷达图（ECharts）：市场规模、增长潜力、数字化程度、物流便利度、竞争度
 *  - 综合评分排名表：排名、国家、综合评分、优势标签、建议
 *
 * 数据来源：frontend/src/api/overseas.js → getMarkets()
 */

import { ref, computed, onMounted, onUnmounted, nextTick, watch } from 'vue'
import { Plus } from '@element-plus/icons-vue'
import * as echarts from 'echarts/core'
import { RadarChart } from 'echarts/charts'
import { GridComponent, TooltipComponent, LegendComponent } from 'echarts/components'
import { CanvasRenderer } from 'echarts/renderers'
import { getMarkets } from '@/api/overseas'

echarts.use([RadarChart, GridComponent, TooltipComponent, LegendComponent, CanvasRenderer])

// ====== 数据 ======
const allMarkets = getMarkets()
const selectedCodes = ref(['US', 'ID', 'GB'])
const pageRef = ref(null)

const selectedMarkets = computed(() =>
  selectedCodes.value.map(code => allMarkets.find(m => m.code === code)).filter(Boolean)
)

// ====== 国旗映射 ======
const flagMap = {
  US: '🇺🇸', CA: '🇨🇦', MX: '🇲🇽', GB: '🇬🇧', DE: '🇩🇪', FR: '🇫🇷',
  IT: '🇮🇹', ES: '🇪🇸', ID: '🇮🇩', TH: '🇹🇭', VN: '🇻🇳', PH: '🇵🇭',
  MY: '🇲🇾', SG: '🇸🇬', BR: '🇧🇷', AR: '🇦🇷', CO: '🇨🇴',
  KZ: '🇰🇿', UZ: '🇺🇿', AE: '🇦🇪', SA: '🇸🇦'
}

function countryFlag(code) {
  return flagMap[code] || '🌐'
}

// ====== 区域映射 ======
const regionMap = {
  US: '北美', CA: '北美', MX: '北美',
  GB: '欧洲', DE: '欧洲', FR: '欧洲', IT: '欧洲', ES: '欧洲',
  ID: '东南亚', TH: '东南亚', VN: '东南亚', PH: '东南亚', MY: '东南亚', SG: '东南亚',
  BR: '拉美', AR: '拉美', CO: '拉美',
  KZ: '中亚', UZ: '中亚',
  AE: '中东', SA: '中东'
}
const regionColors = {
  '北美': '#409EFF', '欧洲': '#A78BFA', '东南亚': '#67C23A',
  '拉美': '#E6A23C', '中亚': '#F56C6C', '中东': '#C9A96E'
}
function getRegion(code) { return regionMap[code] || '其他' }
function regionColor(code) { return regionColors[regionMap[code]] || '#8A9AA8' }

// ====== 难度文字 ======
function difficultyLabel(d) {
  return { '低': '容易进入', '中': '中等难度', '高': '高门槛' }[d] || d
}
function entryAdvice(m) {
  if (m.difficulty === '低') return '推荐优先进入'
  if (m.difficulty === '中') return '准备充分后进入'
  return '建议有基础后考虑'
}

// ====== 物流评分（解析 X-Y天） ======
function logScore(m) {
  const match = m.logistics.match(/(\d+)/)
  const d = match ? parseInt(match[1]) : 15
  if (d <= 5) return '优秀'
  if (d <= 8) return '良好'
  if (d <= 12) return '一般'
  return '较慢'
}
function logPercent(m) {
  const match = m.logistics.match(/(\d+)/)
  const d = match ? parseInt(match[1]) : 15
  return Math.max(10, Math.min(100, 100 - ((d - 3) / 27) * 90))
}

// ====== 支付覆盖评分 ======
function payScore(m) {
  const c = (m.platforms || []).length
  if (c >= 4) return '广泛'
  if (c >= 3) return '良好'
  return '一般'
}
function payPercent(m) {
  return Math.min(100, ((m.platforms || []).length / 5) * 100)
}

// ====== 竞争度评分（越低越好） ======
function compScore(m) {
  if (m.difficulty === '低') return '蓝海'
  if (m.difficulty === '中') return '适中'
  return '红海'
}
function compPercent(m) {
  if (m.difficulty === '低') return 80
  if (m.difficulty === '中') return 50
  return 20
}

// ====== 进度条渐变色 ======
function barGradient(p) {
  if (p >= 70) return 'linear-gradient(90deg, #52C41A, #73D13D)'
  if (p >= 40) return 'linear-gradient(90deg, #C9A96E, #E0C080)'
  return 'linear-gradient(90deg, #F56C6C, #F89880)'
}

// ====== 综合评分 ======
function computeTotalScore(m) {
  const maxScale = 12000, maxGrowth = 30, maxPen = 55
  const s = Math.min(100, (m.ecomScale / maxScale) * 100)  // 规模
  const g = Math.min(100, (m.growthRate / maxGrowth) * 100) // 增长
  const d = Math.min(100, (m.tiktokPenetration / maxPen) * 100) // 数字化
  const l = logPercent(m)   // 物流
  const c = compPercent(m)  // 竞争
  return s * 0.25 + g * 0.25 + d * 0.20 + l * 0.15 + c * 0.15
}

// ====== 优势标签 ======
function generateAdvantageTags(m) {
  const tags = []
  if (m.ecomScale >= 3000) tags.push('市场规模大')
  if (m.growthRate >= 20) tags.push('高增长')
  if (m.tiktokPenetration >= 40) tags.push('TikTok红利')
  if (logPercent(m) >= 70) tags.push('物流便利')
  if (m.difficulty === '低') tags.push('进入门槛低')
  if (m.topCategories && m.topCategories.length) tags.push((m.topCategories[0]) + '热销')
  return tags.slice(0, 3)
}

// ====== 建议 ======
function generateAdvice(m) {
  if (m.difficulty === '低' && m.growthRate >= 20) return '强烈推荐优先布局'
  if (m.difficulty === '低') return '推荐进入，适合新手试水'
  if (m.growthRate >= 25) return '高增长窗口期，建议加快布局'
  if (m.ecomScale >= 3000) return '成熟市场，适合有资源的团队'
  if (m.difficulty === '高') return '门槛高，提前做好合规准备'
  return '评估后谨慎进入'
}

// ====== 排名列表 ======
const rankedMarkets = computed(() =>
  selectedMarkets.value
    .map(m => ({
      ...m,
      totalScore: computeTotalScore(m),
      advantageTags: generateAdvantageTags(m),
      advice: generateAdvice(m)
    }))
    .sort((a, b) => b.totalScore - a.totalScore)
    .map((m, i) => ({ ...m, rank: i + 1 }))
)

const allRankedMarkets = computed(() =>
  allMarkets
    .map(m => ({
      ...m,
      totalScore: computeTotalScore(m),
      advantageTags: generateAdvantageTags(m),
      advice: generateAdvice(m)
    }))
    .sort((a, b) => b.totalScore - a.totalScore)
    .map((m, i) => ({ ...m, rank: i + 1 }))
)

// ====== 雷达图 ======
const radarChartRef = ref(null)
let radarChartInstance = null
const radarColors = ['#C9A96E', '#409EFF', '#67C23A', '#F56C6C']
const radarIndicators = [
  { name: '市场规模', max: 100 },
  { name: '增长潜力', max: 100 },
  { name: '数字化程度', max: 100 },
  { name: '物流便利度', max: 100 },
  { name: '进入友好度', max: 100 }
]

function buildRadarData(m) {
  const maxScale = 12000, maxGrowth = 30, maxPen = 55
  return {
    name: m.name,
    value: [
      Math.min(100, (m.ecomScale / maxScale) * 100),
      Math.min(100, (m.growthRate / maxGrowth) * 100),
      Math.min(100, (m.tiktokPenetration / maxPen) * 100),
      logPercent(m),
      compPercent(m)
    ]
  }
}

function initRadarChart() {
  if (!radarChartRef.value || selectedMarkets.value.length < 2) return
  if (radarChartInstance) radarChartInstance.dispose()

  const data = selectedMarkets.value.map((m, i) => ({
    ...buildRadarData(m),
    name: m.name,
    value: buildRadarData(m).value,
    itemStyle: { color: radarColors[i] },
    lineStyle: { color: radarColors[i], width: 2.5 },
    areaStyle: { color: radarColors[i], opacity: 0.08 },
    symbol: 'circle',
    symbolSize: 6
  }))

  radarChartInstance = echarts.init(radarChartRef.value)
  radarChartInstance.setOption({
    tooltip: {
      trigger: 'item',
      backgroundColor: '#fff',
      borderColor: '#e8ecf1',
      borderWidth: 1,
      padding: [10, 14],
      extraCssText: 'box-shadow: 0 4px 20px rgba(0,0,0,0.08); border-radius: 8px;'
    },
    legend: { show: false },
    radar: {
      center: ['50%', '52%'],
      radius: '68%',
      axisName: { color: '#4A5A6A', fontSize: 12, fontWeight: 500, padding: [3, 8] },
      indicator: radarIndicators,
      axisLine: { lineStyle: { color: '#E8ECF1' } },
      splitLine: { lineStyle: { color: '#F0F2F5', type: 'dashed' } },
      splitArea: { show: true, areaStyle: { color: ['rgba(201,169,110,0.02)', 'transparent'] } },
      shape: 'polygon'
    },
    series: [{
      type: 'radar',
      data,
      emphasis: { lineStyle: { width: 3.5 }, areaStyle: { opacity: 0.15 } }
    }]
  })
}

// ====== 表格样式 ======
function tableHeaderStyle() {
  return {
    background: '#FAFBFC', color: '#4A5A6A', fontWeight: 600,
    fontSize: '13px', borderBottom: '2px solid #E8ECF1'
  }
}
function tableRowClass({ row }) {
  if (row.rank === 1) return 'top-1-row'
  if (row.rank === 2) return 'top-2-row'
  if (row.rank === 3) return 'top-3-row'
  return ''
}
function scoreColor(s) {
  if (s >= 80) return '#52C41A'
  if (s >= 60) return '#C9A96E'
  if (s >= 40) return '#E6A23C'
  return '#F56C6C'
}

// ====== 响应式 & 生命周期 ======
function handleResize() {
  if (radarChartInstance) radarChartInstance.resize()
}

onMounted(() => {
  nextTick(() => {
    if (selectedMarkets.value.length >= 2) initRadarChart()
  })
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  if (radarChartInstance) radarChartInstance.dispose()
})

watch(selectedMarkets, () => {
  nextTick(() => {
    if (selectedMarkets.value.length >= 2) initRadarChart()
  })
}, { deep: true })
</script>

<style scoped>
.market-compare {
  max-width: 1440px;
  margin: 0 auto;
  min-height: 100vh;
}

/* ====== 页面标题 ====== */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 28px;
  gap: 20px;
  flex-wrap: wrap;
}
.header-left { display: flex; flex-direction: column; gap: 6px; }
.page-title { margin: 0; font-size: 28px; font-weight: 700; color: #1A2A3A; letter-spacing: -0.3px; }
.page-subtitle { margin: 0; font-size: 14px; color: #8A9AA8; }
.header-selector { display: flex; align-items: center; gap: 10px; flex-shrink: 0; }
.selector-label { font-size: 13px; color: #4A5A6A; font-weight: 500; white-space: nowrap; }
.market-select { width: 360px; }

.option-flag { font-size: 18px; margin-right: 6px; }
.option-name { font-size: 13px; color: #1A2A3A; }
.option-detail { font-size: 11px; color: #8A9AA8; margin-left: 8px; }

/* ====== 对比卡片行 ====== */
.compare-cards-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 28px;
}
.compare-card {
  background: #fff;
  border-radius: 16px;
  padding: 22px 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: 2px solid transparent;
  transition: all 0.3s;
  animation: cardSlideIn 0.5s ease backwards;
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.compare-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 28px rgba(0, 0, 0, 0.08);
}
.compare-card.is-lead {
  border-color: #C9A96E;
  box-shadow: 0 4px 20px rgba(201, 169, 110, 0.12);
}
@keyframes cardSlideIn {
  from { opacity: 0; transform: translateY(16px); }
  to { opacity: 1; transform: translateY(0); }
}

/* 空卡片 */
.empty-card {
  border: 2px dashed #E8ECF1;
  background: #FAFBFC;
  box-shadow: none;
  cursor: default;
}
.empty-card:hover { transform: none; box-shadow: none; border-color: #D0D8E0; }
.empty-inner {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 10px;
}
.empty-text { font-size: 13px; color: #B0BCC8; }

/* 卡片头部 */
.card-head { display: flex; justify-content: space-between; align-items: flex-start; }
.card-country { display: flex; align-items: center; gap: 10px; }
.card-flag { font-size: 32px; line-height: 1; }
.card-name-row { display: flex; flex-direction: column; gap: 4px; }
.card-name { font-size: 16px; font-weight: 600; color: #1A2A3A; }
.card-region {
  font-size: 11px; color: #fff; padding: 1px 8px;
  border-radius: 10px; display: inline-block; width: fit-content; font-weight: 500;
}

/* 难度徽章 */
.diff-badge { font-size: 11px; font-weight: 600; padding: 4px 10px; border-radius: 12px; white-space: nowrap; }
.diff-low { background: #F0FAF0; color: #52C41A; }
.diff-mid { background: #FFF7E6; color: #E6A23C; }
.diff-high { background: #FFF0F0; color: #F56C6C; }

/* 指标网格（2×2） */
.metrics-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
  background: #FAFBFC;
  border-radius: 12px;
  padding: 14px;
}
.metric-cell { display: flex; flex-direction: column; gap: 2px; }
.metric-label { font-size: 11px; color: #8A9AA8; }
.metric-value { font-size: 18px; font-weight: 700; color: #1A2A3A; }
.growth-up { color: #52C41A; }
.heat { color: #C9A96E; }

/* 评分条 */
.score-bars { display: flex; flex-direction: column; gap: 10px; }
.score-item { display: flex; flex-direction: column; gap: 4px; }
.score-header { display: flex; justify-content: space-between; }
.score-label { font-size: 11px; color: #8A9AA8; }
.score-value { font-size: 11px; color: #4A5A6A; font-weight: 500; }
.score-track { height: 6px; background: #F0F2F5; border-radius: 3px; overflow: hidden; }
.score-fill { height: 100%; border-radius: 3px; transition: width 0.5s ease; }

/* 平台标签 */
.card-platforms { display: flex; flex-wrap: wrap; gap: 6px; }
.platform-tag {
  font-size: 11px; color: #8A9AA8; background: #F5F6F8;
  padding: 2px 8px; border-radius: 4px;
}

/* 卡片底部 */
.card-footer {
  display: flex; justify-content: space-between; align-items: center;
  padding-top: 12px; border-top: 1px solid #F0F2F5;
}
.footer-label { font-size: 12px; color: #8A9AA8; }
.footer-value { font-size: 13px; font-weight: 600; }

/* ====== 空状态 ====== */
.empty-state {
  text-align: center; padding: 80px 20px;
  background: #fff; border-radius: 16px; box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}
.empty-icon { font-size: 48px; display: block; margin-bottom: 16px; }
.empty-title { font-size: 16px; color: #4A5A6A; font-weight: 600; margin: 0 0 8px; }
.empty-hint { font-size: 13px; color: #8A9AA8; margin: 0; }

/* ====== 底部区域 ====== */
.bottom-section { display: flex; gap: 24px; align-items: flex-start; }
.bottom-section.single .rank-card.full-width { flex: 1; }
.radar-card { flex: 0 0 48%; }
.rank-card { flex: 1; min-width: 0; }

/* 通用卡片 */
.card {
  background: #fff; border-radius: 16px;
  padding: 24px; box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}
.card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.card-title { margin: 0; font-size: 16px; font-weight: 600; color: #1A2A3A; }
.chart-container { width: 100%; }

/* 雷达图图例 */
.radar-legend { display: flex; gap: 12px; flex-wrap: wrap; }
.legend-tag {
  display: flex; align-items: center; gap: 5px;
  font-size: 12px; font-weight: 500; padding: 3px 10px;
  border-radius: 12px; border: 1.5px solid; background: #fff;
}
.legend-dot { width: 8px; height: 8px; border-radius: 50%; }
.rank-hint { font-size: 12px; color: #B0BCC8; }

/* ====== 表格 ====== */
.rank-table { border-radius: 8px; overflow: hidden; }
.rank-table :deep(.el-table__cell) { padding: 12px 8px; }
.rank-num {
  display: inline-flex; align-items: center; justify-content: center;
  width: 28px; height: 28px; border-radius: 50%;
  font-size: 14px; font-weight: 700; color: #8A9AA8; background: #F5F6F8;
}
.rank-num.top-rank { color: #fff; background: #C9A96E; }
.country-cell { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #1A2A3A; font-weight: 500; }
.flag { font-size: 20px; line-height: 1; }
.total-score { font-size: 20px; font-weight: 700; }

.tag-row { display: flex; flex-wrap: wrap; gap: 5px; }
.adv-tag {
  font-size: 11px; color: #C9A96E; background: #FDF8F0;
  padding: 2px 8px; border-radius: 4px; border: 1px solid #F5E6C8;
}
.advice-text { font-size: 12px; color: #4A5A6A; line-height: 1.5; }

.rank-table :deep(.top-1-row) { background: #FDF8F0 !important; }
.rank-table :deep(.top-2-row) td { border-top: none; }
.rank-table :deep(.top-3-row) td { border-top: none; }

/* ====== 响应式 ====== */
@media (max-width: 1200px) {
  .compare-cards-row { grid-template-columns: repeat(2, 1fr); }
  .bottom-section { flex-direction: column; }
  .radar-card { flex: 1; width: 100%; }
}
@media (max-width: 768px) {
  .compare-cards-row { grid-template-columns: 1fr; }
  .page-header { flex-direction: column; align-items: flex-start; }
  .market-select { width: 100%; }
  .header-selector { width: 100%; }
}
</style>
