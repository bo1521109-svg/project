<template>
  <div class="crm-overview">
    <!-- 页面标题 -->
    <div class="page-header">
      <h2 class="page-title">客资概览</h2>
      <div class="header-actions">
        <el-segmented v-model="period" :options="periodOptions" size="small" />
        <el-button type="primary" size="small" :icon="Refresh" @click="refresh">刷新数据</el-button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-row">
      <div class="stat-card" v-for="card in statCards" :key="card.key">
        <div class="stat-icon" :style="{ background: card.bg }">
          <el-icon :size="22"><component :is="card.icon" /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ card.value }}</div>
          <div class="stat-label">{{ card.label }}</div>
          <div class="stat-change" :class="card.change > 0 ? 'up' : 'down'">
            {{ card.change > 0 ? '+' : '' }}{{ card.change }}%
            <span class="change-text">较上期</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 主体两栏 -->
    <div class="main-grid">
      <!-- 左：新增客户列表 -->
      <div class="panel">
        <div class="panel-header">
          <h3>最近新增客户</h3>
          <el-button text type="primary" @click="$router.push('/crm/customers')">查看全部</el-button>
        </div>
        <el-table :data="recentCustomers" style="width: 100%" size="small" stripe>
          <el-table-column prop="name" label="客户名称" min-width="120">
            <template #default="{ row }">
              <span class="customer-name">{{ row.name }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="country" label="国家" width="80" />
          <el-table-column prop="source" label="来源" width="90">
            <template #default="{ row }">
              <el-tag size="small" :type="sourceType(row.source)">{{ row.source }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="状态" width="90">
            <template #default="{ row }">
              <el-tag size="small" :type="statusType(row.status)">{{ row.status_label }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="created" label="时间" width="150" />
        </el-table>
      </div>

      <!-- 右：待跟进列表 -->
      <div class="panel">
        <div class="panel-header">
          <h3>待跟进提醒</h3>
          <el-button text type="primary" @click="$router.push('/crm/follow-ups')">查看全部</el-button>
        </div>
        <div class="followup-list">
          <div class="followup-item" v-for="item in upcomingFollowUps" :key="item.id">
            <div class="fu-left">
              <div class="fu-priority" :class="item.priority"></div>
              <div class="fu-info">
                <div class="fu-customer">{{ item.customer }}</div>
                <div class="fu-type">{{ item.type }}</div>
              </div>
            </div>
            <div class="fu-time">{{ item.scheduled }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 来源渠道分布 -->
    <div class="panel">
      <div class="panel-header">
        <h3>来源渠道分布</h3>
      </div>
      <div class="source-bars">
        <div class="source-bar-item" v-for="item in sourceDistribution" :key="item.name">
          <div class="sb-label">{{ item.name }}</div>
          <div class="sb-track">
            <div class="sb-fill" :style="{ width: item.percentage + '%', background: sourceColor(item.name) }"></div>
          </div>
          <div class="sb-value">{{ item.count }} <span class="sb-pct">{{ item.percentage }}%</span></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Refresh, User, TrendCharts, Clock, DataAnalysis } from '@element-plus/icons-vue'

const period = ref('month')
const periodOptions = [
  { label: '今日', value: 'today' },
  { label: '本周', value: 'week' },
  { label: '本月', value: 'month' },
]

// Mock 数据
const mockData = {
  today: {
    stats: { total_customers: 3847, new_label: '今日新增', new_count: 23, active: 156, pending: 42, conversion: 18.5, response: '3.2min' },
    recent: [
      { name: 'Carlos Mendes', country: '巴西', source: 'TikTok', status: 'potential', status_label: '潜在客户', created: '2026-06-03 14:22' },
      { name: 'Emma Wilson', country: '美国', source: '独立站', status: 'potential', status_label: '潜在客户', created: '2026-06-03 13:15' },
      { name: '田中 健一', country: '日本', source: 'Instagram', status: 'potential', status_label: '潜在客户', created: '2026-06-03 11:08' },
    ],
    followups: [
      { id: 1, customer: 'Lucas S.', type: '电话回访', scheduled: '16:00', priority: 'high' },
      { id: 2, customer: 'Sophie L.', type: '邮件跟进', scheduled: '17:30', priority: 'medium' },
    ],
    sources: [
      { name: '独立站', count: 1205, percentage: 31.3 },
      { name: 'TikTok', count: 892, percentage: 23.2 },
      { name: 'Instagram', count: 634, percentage: 16.5 },
      { name: 'Facebook', count: 487, percentage: 12.7 },
      { name: 'WhatsApp', count: 329, percentage: 8.6 },
      { name: '其它', count: 300, percentage: 7.8 },
    ]
  },
  week: {
    stats: { total_customers: 3847, new_label: '本周新增', new_count: 186, active: 523, pending: 42, conversion: 22.1, response: '4.5min' },
    recent: [
      { name: 'Carlos Mendes', country: '巴西', source: 'TikTok', status: 'potential', status_label: '潜在客户', created: '2026-06-03 14:22' },
      { name: 'Emma Wilson', country: '美国', source: '独立站', status: 'potential', status_label: '潜在客户', created: '2026-06-03 13:15' },
      { name: '田中 健一', country: '日本', source: 'Instagram', status: 'potential', status_label: '潜在客户', created: '2026-06-03 11:08' },
      { name: 'Priya Kapoor', country: '印度', source: 'Facebook', status: 'contacted', status_label: '已联系', created: '2026-06-03 09:45' },
      { name: 'Michael Brown', country: '英国', source: '独立站', status: 'contracted', status_label: '已成交', created: '2026-06-03 08:30' },
    ],
    followups: [
      { id: 1, customer: 'Lucas S.', type: '电话回访', scheduled: '06-03 16:00', priority: 'high' },
      { id: 2, customer: 'Sophie L.', type: '邮件跟进', scheduled: '06-03 17:30', priority: 'medium' },
      { id: 3, customer: 'Ahmed R.', type: 'WhatsApp', scheduled: '06-04 10:00', priority: 'high' },
      { id: 4, customer: 'Maria G.', type: '样品寄送跟进', scheduled: '06-04 14:00', priority: 'medium' },
      { id: 5, customer: 'David C.', type: '合同签署', scheduled: '06-05 09:00', priority: 'high' },
    ],
    sources: [
      { name: '独立站', count: 1205, percentage: 31.3 },
      { name: 'TikTok', count: 892, percentage: 23.2 },
      { name: 'Instagram', count: 634, percentage: 16.5 },
      { name: 'Facebook', count: 487, percentage: 12.7 },
      { name: 'WhatsApp', count: 329, percentage: 8.6 },
      { name: '其它', count: 300, percentage: 7.8 },
    ]
  },
  month: {
    stats: { total_customers: 3847, new_label: '本月新增', new_count: 586, active: 1203, pending: 42, conversion: 24.8, response: '5.1min' },
    recent: [
      { name: 'Carlos Mendes', country: '巴西', source: 'TikTok', status: 'potential', status_label: '潜在客户', created: '2026-06-03 14:22' },
      { name: 'Emma Wilson', country: '美国', source: '独立站', status: 'potential', status_label: '潜在客户', created: '2026-06-03 13:15' },
      { name: '田中 健一', country: '日本', source: 'Instagram', status: 'potential', status_label: '潜在客户', created: '2026-06-03 11:08' },
      { name: 'Priya Kapoor', country: '印度', source: 'Facebook', status: 'contacted', status_label: '已联系', created: '2026-06-03 09:45' },
      { name: 'Michael Brown', country: '英国', source: '独立站', status: 'contracted', status_label: '已成交', created: '2026-06-03 08:30' },
      { name: 'Anna Fischer', country: '德国', source: 'Instagram', status: 'negotiating', status_label: '洽谈中', created: '2026-06-02 16:20' },
      { name: 'Omar Hassan', country: '埃及', source: 'WhatsApp', status: 'potential', status_label: '潜在客户', created: '2026-06-02 15:10' },
    ],
    followups: [
      { id: 1, customer: 'Lucas S.', type: '电话回访', scheduled: '06-03 16:00', priority: 'high' },
      { id: 2, customer: 'Sophie L.', type: '邮件跟进', scheduled: '06-03 17:30', priority: 'medium' },
      { id: 3, customer: 'Ahmed R.', type: 'WhatsApp', scheduled: '06-04 10:00', priority: 'high' },
      { id: 4, customer: 'Maria G.', type: '样品寄送跟进', scheduled: '06-04 14:00', priority: 'medium' },
      { id: 5, customer: 'David C.', type: '合同签署', scheduled: '06-05 09:00', priority: 'high' },
      { id: 6, customer: 'Yuki T.', type: '报价确认', scheduled: '06-05 11:00', priority: 'medium' },
      { id: 7, customer: 'Robert K.', type: '产品演示', scheduled: '06-06 14:00', priority: 'low' },
    ],
    sources: [
      { name: '独立站', count: 1205, percentage: 31.3 },
      { name: 'TikTok', count: 892, percentage: 23.2 },
      { name: 'Instagram', count: 634, percentage: 16.5 },
      { name: 'Facebook', count: 487, percentage: 12.7 },
      { name: 'WhatsApp', count: 329, percentage: 8.6 },
      { name: '其它', count: 300, percentage: 7.8 },
    ]
  }
}

const currentData = computed(() => mockData[period.value])

const statCards = computed(() => {
  const s = currentData.value.stats
  return [
    { key: 'total', icon: User, bg: 'linear-gradient(135deg, #667eea, #764ba2)', value: s.total_customers.toLocaleString(), label: '客户总数', change: 12.5 },
    { key: 'new', icon: TrendCharts, bg: 'linear-gradient(135deg, #f093fb, #f5576c)', value: s.new_count.toLocaleString(), label: s.new_label, change: 8.3 },
    { key: 'active', icon: DataAnalysis, bg: 'linear-gradient(135deg, #4facfe, #00f2fe)', value: s.active.toLocaleString(), label: '活跃客户', change: 15.2 },
    { key: 'pending', icon: Clock, bg: 'linear-gradient(135deg, #fa709a, #fee140)', value: s.pending.toLocaleString(), label: '待跟进', change: -5.1 },
  ]
})

const recentCustomers = computed(() => currentData.value.recent)
const upcomingFollowUps = computed(() => currentData.value.followups)
const sourceDistribution = computed(() => currentData.value.sources)

function sourceType(source) {
  const map = { '独立站': 'success', 'TikTok': '', 'Instagram': 'danger', 'Facebook': 'primary', 'WhatsApp': 'success' }
  return map[source] || 'info'
}

function statusType(status) {
  const map = { potential: 'info', contacted: 'warning', negotiating: '', contracted: 'success' }
  return map[status] || 'info'
}

function sourceColor(name) {
  const map = { '独立站': '#67C23A', 'TikTok': '#303133', 'Instagram': '#E0437C', 'Facebook': '#1877F2', 'WhatsApp': '#25D366', '其它': '#909399' }
  return map[name] || '#409EFF'
}

function refresh() {
  // 模拟刷新
}
</script>

<style scoped>
.crm-overview { max-width: 1400px; }

.page-header {
  display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;
}
.page-title { font-size: 20px; font-weight: 700; color: #303133; margin: 0; }
.header-actions { display: flex; gap: 12px; align-items: center; }

/* 统计卡片 */
.stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 20px; }
.stat-card {
  background: #fff; border-radius: 10px; padding: 18px 20px;
  display: flex; align-items: center; gap: 16px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
  transition: all 0.3s;
}
.stat-card:hover { transform: translateY(-2px); box-shadow: 0 4px 16px rgba(0,0,0,0.1); }
.stat-icon {
  width: 48px; height: 48px; border-radius: 10px;
  display: flex; align-items: center; justify-content: center; color: #fff; flex-shrink: 0;
}
.stat-value { font-size: 24px; font-weight: 700; color: #303133; line-height: 1.2; }
.stat-label { font-size: 13px; color: #909399; margin-top: 2px; }
.stat-change { font-size: 12px; margin-top: 2px; font-weight: 500; }
.stat-change.up { color: #67C23A; }
.stat-change.down { color: #F56C6C; }
.change-text { font-weight: 400; color: #909399; }

/* 主体两栏 */
.main-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 20px; }

/* 面板 */
.panel {
  background: #fff; border-radius: 10px; padding: 16px 20px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}
.panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
.panel-header h3 { font-size: 15px; font-weight: 600; color: #303133; margin: 0; }

.customer-name { font-weight: 500; color: #303133; cursor: pointer; }
.customer-name:hover { color: #f5576c; }

/* 跟进列表 */
.followup-list { display: flex; flex-direction: column; gap: 0; }
.followup-item {
  display: flex; justify-content: space-between; align-items: center;
  padding: 10px 0; border-bottom: 1px solid #f0f0f0;
}
.followup-item:last-child { border-bottom: none; }
.fu-left { display: flex; align-items: center; gap: 10px; }
.fu-priority { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
.fu-priority.high { background: #F56C6C; }
.fu-priority.medium { background: #E6A23C; }
.fu-priority.low { background: #909399; }
.fu-customer { font-size: 13px; font-weight: 500; color: #303133; }
.fu-type { font-size: 12px; color: #909399; }
.fu-time { font-size: 12px; color: #606266; font-weight: 500; }

/* 来源渠道条 */
.source-bars { display: flex; flex-direction: column; gap: 10px; }
.source-bar-item { display: flex; align-items: center; gap: 12px; }
.sb-label { width: 80px; font-size: 13px; color: #606266; text-align: right; flex-shrink: 0; }
.sb-track { flex: 1; height: 22px; background: #f5f7fa; border-radius: 4px; overflow: hidden; }
.sb-fill { height: 100%; border-radius: 4px; transition: width 0.6s ease; min-width: 0; }
.sb-value { font-size: 13px; color: #303133; font-weight: 500; width: 70px; flex-shrink: 0; }
.sb-pct { color: #909399; font-weight: 400; font-size: 12px; }

:deep(.el-table) { font-size: 13px; }
</style>
