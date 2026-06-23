<template>
  <div class="site-detail">
    <!-- 加载中 -->
    <div v-if="loading" class="loading-container">
      <el-skeleton :rows="5" animated />
    </div>

    <template v-else-if="site">
      <!-- ====== 顶部信息栏 ====== -->
      <div class="detail-header">
        <div class="header-left">
          <div class="header-icon" :class="statusClass">
            <el-icon :size="24"><Monitor /></el-icon>
          </div>
          <div class="header-info">
            <div class="header-title-row">
              <h1 class="header-title">{{ site.name }}</h1>
              <el-tag :type="statusTagType" size="small" effect="dark">
                {{ statusLabel }}
              </el-tag>
            </div>
            <p class="header-domain">{{ site.domain || '未绑定域名' }}</p>
          </div>
        </div>

        <div class="header-actions">
          <el-button type="primary" plain @click="previewSite">
            <el-icon><View /></el-icon>
            预览站点
          </el-button>
          <el-button
            v-if="site.status === 'draft' || site.status === 'paused' || site.status === 'archived'"
            type="primary"
            @click="handlePublish"
          >
            <el-icon><CaretRight /></el-icon>
            {{ site.status === 'archived' ? '重新发布' : '发布' }}
          </el-button>
          <el-button
            v-if="site.status === 'published'"
            type="warning"
            @click="handlePause"
          >
            <el-icon><VideoPause /></el-icon>
            暂停
          </el-button>
          <el-button
            v-if="site.status === 'published' || site.status === 'paused'"
            type="danger"
            @click="handleArchive"
          >
            <el-icon><Remove /></el-icon>
            下线
          </el-button>
          <el-dropdown trigger="click" @command="handleMoreAction">
            <el-button>
              更多<el-icon><ArrowDown /></el-icon>
            </el-button>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="edit">编辑站点</el-dropdown-item>
                <el-dropdown-item command="copy">复制站点</el-dropdown-item>
                <el-dropdown-item command="delete" divided>删除站点</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>

      <!-- ====== Tab 切换 ====== -->
      <el-tabs v-model="activeTab" class="detail-tabs">
        <!-- Tab 1: 概览 -->
        <el-tab-pane label="概览" name="overview">
          <!-- 统计卡片 -->
          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-icon visits"><el-icon :size="20"><View /></el-icon></div>
              <div class="stat-body">
                <span class="stat-value">{{ formatNumber(site.visits) }}</span>
                <span class="stat-label">总访问量</span>
              </div>
            </div>
            <div class="stat-card">
              <div class="stat-icon orders"><el-icon :size="20"><ShoppingCart /></el-icon></div>
              <div class="stat-body">
                <span class="stat-value">{{ formatNumber(site.orders) }}</span>
                <span class="stat-label">总订单数</span>
              </div>
            </div>
            <div class="stat-card">
              <div class="stat-icon conversion"><el-icon :size="20"><TrendCharts /></el-icon></div>
              <div class="stat-body">
                <span class="stat-value">{{ site.conversion_rate }}%</span>
                <span class="stat-label">转化率</span>
              </div>
            </div>
            <div class="stat-card">
              <div class="stat-icon aov"><el-icon :size="20"><Coin /></el-icon></div>
              <div class="stat-body">
                <span class="stat-value">${{ site.avg_order_value }}</span>
                <span class="stat-label">客单价</span>
              </div>
            </div>
          </div>

          <!-- 7 天趋势图 -->
          <div class="chart-section">
            <h3 class="section-title">最近 7 天趋势</h3>
            <div class="chart-container">
              <v-chart :option="chartOption" autoresize />
            </div>
          </div>
        </el-tab-pane>

        <!-- Tab 2: 基础设置 -->
        <el-tab-pane label="基础设置" name="settings">
          <div class="settings-form">
            <el-form :model="settingsForm" label-width="120px" label-position="left">
              <el-form-item label="站点名称">
                <el-input v-model="settingsForm.name" />
              </el-form-item>
              <el-form-item label="域名">
                <el-input v-model="settingsForm.domain">
                  <template #prepend>https://</template>
                </el-input>
              </el-form-item>
              <el-form-item label="所属行业">
                <el-select v-model="settingsForm.industry" style="width: 100%">
                  <el-option label="服装" value="服装" />
                  <el-option label="数码" value="数码" />
                  <el-option label="家居" value="家居" />
                  <el-option label="美妆" value="美妆" />
                  <el-option label="宠物" value="宠物" />
                  <el-option label="运动" value="运动" />
                  <el-option label="母婴" value="母婴" />
                  <el-option label="食品" value="食品" />
                  <el-option label="其他" value="其他" />
                </el-select>
              </el-form-item>
              <el-form-item label="站点描述">
                <el-input
                  v-model="settingsForm.description"
                  type="textarea"
                  :rows="3"
                  placeholder="填写站点的简短描述，有助于 SEO"
                />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="saveSettings">保存设置</el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>

        <!-- Tab 3: SEO 设置 -->
        <el-tab-pane label="SEO设置" name="seo">
          <div class="settings-form">
            <el-form label-width="120px" label-position="left">
              <el-form-item label="SEO 标题">
                <el-input v-model="seoForm.title" placeholder="建议包含主要关键词" />
              </el-form-item>
              <el-form-item label="SEO 描述">
                <el-input
                  v-model="seoForm.description"
                  type="textarea"
                  :rows="3"
                  placeholder="页面描述，会显示在搜索结果中"
                />
              </el-form-item>
              <el-form-item label="SEO 关键词">
                <el-input
                  v-model="seoForm.keywords"
                  placeholder="多个关键词用英文逗号分隔"
                />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="saveSeo">保存 SEO 配置</el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>

        <!-- Tab 4: 支付配置 -->
        <el-tab-pane label="支付配置" name="payment">
          <div class="settings-form">
            <el-form label-width="160px" label-position="left">
              <el-form-item label="启用 PayPal">
                <el-switch v-model="paymentForm.paypal" />
              </el-form-item>
              <el-form-item label="PayPal Client ID">
                <el-input v-model="paymentForm.paypalClientId" placeholder="输入 PayPal Client ID" />
              </el-form-item>
              <el-form-item label="启用 Stripe">
                <el-switch v-model="paymentForm.stripe" />
              </el-form-item>
              <el-form-item label="Stripe Secret Key">
                <el-input v-model="paymentForm.stripeKey" placeholder="输入 Stripe Secret Key" />
              </el-form-item>
              <el-form-item label="启用货到付款">
                <el-switch v-model="paymentForm.cod" />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="savePayment">保存支付配置</el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>

        <!-- Tab 5: 物流配置 -->
        <el-tab-pane label="物流配置" name="shipping">
          <div class="settings-form">
            <el-form label-width="160px" label-position="left">
              <el-form-item label="免费配送门槛">
                <el-input-number
                  v-model="shippingForm.freeThreshold"
                  :min="0"
                  :precision="2"
                  style="width: 200px"
                />
                <span style="margin-left: 8px; color: #909399;">美元，0 表示不启用</span>
              </el-form-item>
              <el-form-item label="标准运费">
                <el-input-number
                  v-model="shippingForm.standardRate"
                  :min="0"
                  :precision="2"
                  style="width: 200px"
                />
                <span style="margin-left: 8px; color: #909399;">美元</span>
              </el-form-item>
              <el-form-item label="预计发货天数">
                <el-input-number
                  v-model="shippingForm.processingDays"
                  :min="1"
                  :max="30"
                  style="width: 200px"
                />
              </el-form-item>
              <el-form-item label="支持配送区域">
                <el-select
                  v-model="shippingForm.regions"
                  multiple
                  placeholder="选择配送区域"
                  style="width: 100%"
                >
                  <el-option label="北美" value="north_america" />
                  <el-option label="欧洲" value="europe" />
                  <el-option label="东南亚" value="southeast_asia" />
                  <el-option label="东亚" value="east_asia" />
                  <el-option label="大洋洲" value="oceania" />
                  <el-option label="全球" value="worldwide" />
                </el-select>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="saveShipping">保存物流配置</el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>
      </el-tabs>
    </template>

    <!-- 站点不存在 -->
    <el-empty v-else description="站点不存在" />

    <!-- ====== 复制站点对话框 ====== -->
    <el-dialog
      v-model="showCloneDialog"
      title="复制站点"
      width="420px"
      :close-on-click-modal="false"
      @close="cloneForm.name = ''"
    >
      <el-form :model="cloneForm" label-width="0">
        <el-form-item>
          <el-input
            v-model="cloneForm.name"
            placeholder="请输入新站点名称"
            size="large"
            clearable
            autofocus
          />
        </el-form-item>
      </el-form>
      <div class="clone-info">
        <p>将基于「<strong>{{ site?.name }}</strong>」创建副本</p>
        <p class="clone-detail">将使用相同模板和设置，状态为草稿</p>
      </div>
      <template #footer>
        <el-button @click="showCloneDialog = false">取消</el-button>
        <el-button type="primary" @click="handleCloneConfirm">确认复制</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Monitor, View, CaretRight, VideoPause, ArrowDown, Remove,
  ShoppingCart, TrendCharts, Coin
} from '@element-plus/icons-vue'
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { LineChart } from 'echarts/charts'
import {
  GridComponent, TooltipComponent, LegendComponent
} from 'echarts/components'

// 注册 ECharts 组件
use([CanvasRenderer, LineChart, GridComponent, TooltipComponent, LegendComponent])

const route = useRoute()
const router = useRouter()

// ====== 状态 ======
const loading = ref(true)
const site = ref(null)
const activeTab = ref(route.query.tab || 'overview')

// 克隆站点
const showCloneDialog = ref(false)
const cloneForm = reactive({ name: '' })

// 设置表单
const settingsForm = ref({ name: '', domain: '', industry: '', description: '' })
const seoForm = ref({ title: '', description: '', keywords: '' })
const paymentForm = ref({ paypal: true, paypalClientId: '', stripe: false, stripeKey: '', cod: true })
const shippingForm = ref({ freeThreshold: 0, standardRate: 9.99, processingDays: 3, regions: ['north_america'] })

// ====== 伪数据（7天趋势） ======
const sevenDays = ['06-09', '06-10', '06-11', '06-12', '06-13', '06-14', '06-15']
const mockVisitsData = [320, 480, 560, 420, 680, 750, 610]
const mockOrdersData = [12, 18, 23, 16, 29, 34, 27]

const chartOption = computed(() => ({
  tooltip: { trigger: 'axis' },
  legend: { data: ['访问量', '订单数'], bottom: 0 },
  grid: { left: 40, right: 20, bottom: 40, top: 20 },
  xAxis: {
    type: 'category',
    data: sevenDays,
    axisLine: { lineStyle: { color: '#e4e7ed' } }
  },
  yAxis: [
    {
      type: 'value',
      name: '访问量',
      splitLine: { lineStyle: { color: '#f5f7fa' } }
    },
    {
      type: 'value',
      name: '订单数',
      splitLine: { show: false }
    }
  ],
  series: [
    {
      name: '访问量',
      type: 'line',
      smooth: true,
      data: mockVisitsData,
      lineStyle: { color: '#409eff', width: 2 },
      areaStyle: {
        color: {
          type: 'linear',
          x: 0, y: 0, x2: 0, y2: 1,
          colorStops: [
            { offset: 0, color: 'rgba(64,158,255,0.3)' },
            { offset: 1, color: 'rgba(64,158,255,0.02)' }
          ]
        }
      },
      itemStyle: { color: '#409eff' }
    },
    {
      name: '订单数',
      type: 'line',
      smooth: true,
      data: mockOrdersData,
      yAxisIndex: 1,
      lineStyle: { color: '#67c23a', width: 2 },
      areaStyle: {
        color: {
          type: 'linear',
          x: 0, y: 0, x2: 0, y2: 1,
          colorStops: [
            { offset: 0, color: 'rgba(103,194,58,0.3)' },
            { offset: 1, color: 'rgba(103,194,58,0.02)' }
          ]
        }
      },
      itemStyle: { color: '#67c23a' }
    }
  ]
}))

// ====== 计算属性 ======
const statusLabel = computed(() => {
  const map = { draft: '草稿', published: '已发布', paused: '已暂停', archived: '已下线' }
  return map[site.value?.status] || site.value?.status
})

const statusTagType = computed(() => {
  const map = { draft: 'info', published: 'success', paused: 'warning', archived: 'danger' }
  return map[site.value?.status] || 'info'
})

const statusClass = computed(() => {
  const map = { draft: 'status-draft', published: 'status-published', paused: 'status-paused', archived: 'status-archived' }
  return map[site.value?.status] || ''
})

// ====== 站点伪数据 ======
const mockSiteDetail = {
  id: 1, name: 'FashionVibe 时尚馆', domain: 'fashionvibe.com',
  industry: '服装', template_id: 1, template_name: '时尚精品',
  status: 'published', visits: 28450, orders: 1234,
  conversion_rate: 4.3, avg_order_value: 89.5,
  created_at: '2026-01-15T08:00:00Z', updated_at: '2026-06-10T10:30:00Z'
}

// ====== 初始化伪数据 ======
const id = Number(route.params.id)
site.value = { ...mockSiteDetail, id }
settingsForm.value = {
  name: site.value.name,
  domain: site.value.domain || '',
  industry: site.value.industry || '',
  description: ''
}
loading.value = false


// ====== 方法 ======

/** 预览 — 新窗口打开预览页 */
function previewSite() {
  window.open(`/website/${site.value.id}/preview`, '_blank')
}

/** 发布 / 重新发布 */
function handlePublish() {
  if (site.value.status === 'archived') {
    site.value.status = 'published'
    ElMessage.success('已重新发布')
  } else {
    site.value.status = 'published'
    ElMessage.success('发布成功')
  }
  refreshSiteData()
}

/** 暂停 */
function handlePause() {
  site.value.status = 'paused'
  ElMessage.success('已暂停')
  refreshSiteData()
}

/** 下线（归档） */
function handleArchive() {
  ElMessageBox.confirm(
    `确定下线 "${site.value.name}"？下线后网站将不可访问。`,
    '确认下线',
    { confirmButtonText: '下线', cancelButtonText: '取消', type: 'warning' }
  ).then(() => {
    site.value.status = 'archived'
    ElMessage.success('已下线')
    refreshSiteData()
  }).catch(() => {})
}

/** 刷新页面数据 */
function refreshSiteData() {
  loading.value = true
  // 模拟重新加载数据
  setTimeout(() => {
    // 保留 site 的已有数据，仅刷新时间戳
    site.value.updated_at = new Date().toISOString()
    loading.value = false
  }, 300)
}

/** 更多操作命令 */
function handleMoreAction(cmd) {
  if (cmd === 'edit') {
    router.push(`/website/create?edit=${site.value.id}`)
  } else if (cmd === 'copy') {
    // 打开克隆对话框
    cloneForm.name = site.value.name + ' 副本'
    showCloneDialog.value = true
  } else if (cmd === 'delete') {
    // 软删除 — 输入名称确认
    ElMessageBox.prompt(
      `确定删除 "${site.value.name}"？请输入站点名称以确认操作：`,
      '确认删除',
      {
        confirmButtonText: '确认删除',
        cancelButtonText: '取消',
        inputPattern: new RegExp(`^${escapeRegex(site.value.name)}$`),
        inputErrorMessage: `请输入 "${site.value.name}" 以确认`,
        type: 'warning'
      }
    ).then(({ value }) => {
      if (value === site.value.name) {
        site.value.status = 'deleted'
        site.value.updated_at = new Date().toISOString()
        ElMessage.success(`"${site.value.name}" 已移入回收站`)
        router.push('/website')
      }
    }).catch(() => {})
  }
}

/** 确认克隆站点 */
function handleCloneConfirm() {
  if (!cloneForm.name.trim()) {
    ElMessage.warning('请输入站点名称')
    return
  }
  ElMessage.success(`已复制站点「${cloneForm.name.trim()}」，请在列表页查看`)
  showCloneDialog.value = false
  cloneForm.name = ''
}

// ====== 保存设置 ======

function saveSettings() {
  // 同步到 site 对象
  site.value.name = settingsForm.value.name
  site.value.domain = settingsForm.value.domain
  site.value.industry = settingsForm.value.industry
  ElMessage.success('保存成功')
}

function saveSeo() {
  // 保存到 site 的 seo_config 虚拟字段
  site.value.seo_config = {
    title: seoForm.value.title,
    description: seoForm.value.description,
    keywords: seoForm.value.keywords
  }
  ElMessage.success('保存成功')
}

function savePayment() {
  ElMessage.success('支付配置已保存')
}

function saveShipping() {
  ElMessage.success('物流配置已保存')
}

/** 转义正则特殊字符 */
function escapeRegex(str) {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
}

function formatNumber(n) {
  if (!n) return '0'
  if (n >= 10000) return (n / 10000).toFixed(1) + 'w'
  if (n >= 1000) return (n / 1000).toFixed(1) + 'k'
  return String(n)
}
</script>

<style scoped>
.site-detail {
  max-width: 1200px;
  margin: 0 auto;
}

.loading-container {
  padding: 40px;
}

/* 顶部 */
.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #fff;
  border-radius: 8px;
  padding: 20px 24px;
  margin-bottom: 20px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.header-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}

.header-icon.status-draft { background: #909399; }
.header-icon.status-published { background: #67c23a; }
.header-icon.status-paused { background: #e6a23c; }

.header-title-row {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 4px;
}

.header-title {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #303133;
}

.header-domain {
  margin: 0;
  font-size: 13px;
  color: #909399;
}

.header-actions {
  display: flex;
  gap: 8px;
  flex-shrink: 0;
}

/* Tab */
.detail-tabs {
  background: #fff;
  border-radius: 8px;
  padding: 0 20px 20px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
}

/* 统计卡片 */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 16px;
  margin-bottom: 24px;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 14px;
  background: #fafafa;
  border-radius: 8px;
  padding: 16px 20px;
  border: 1px solid #f0f0f0;
}

.stat-icon {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}

.stat-icon.visits { background: linear-gradient(135deg, #409eff, #79bbff); }
.stat-icon.orders { background: linear-gradient(135deg, #67c23a, #95d475); }
.stat-icon.conversion { background: linear-gradient(135deg, #e6a23c, #f4d19b); }
.stat-icon.aov { background: linear-gradient(135deg, #f56c6c, #f89898); }

.stat-body {
  display: flex;
  flex-direction: column;
}

.stat-value {
  font-size: 22px;
  font-weight: 700;
  color: #303133;
  line-height: 1.2;
}

.stat-label {
  font-size: 12px;
  color: #909399;
  margin-top: 2px;
}

/* 图表 */
.chart-section {
  margin-top: 8px;
}

.section-title {
  margin: 0 0 16px 0;
  font-size: 15px;
  font-weight: 600;
  color: #303133;
}

.chart-container {
  height: 320px;
  width: 100%;
}

/* 设置表单 */
.settings-form {
  max-width: 600px;
  padding: 20px 0;
}

/* 已下线状态 */
.status-archived { background: #f56c6c; }

/* 克隆信息 */
.clone-info { margin-top: -8px; padding: 12px 16px; background: #f5f7fa; border-radius: 8px; font-size: 13px; color: #606266; }
.clone-info p { margin: 0 0 4px; }
.clone-detail { font-size: 12px; color: #909399; }
</style>
