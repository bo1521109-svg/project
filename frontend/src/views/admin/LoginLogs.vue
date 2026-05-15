<template>
  <div class="login-logs">
    <el-card class="stats-card">
      <div class="stats-grid">
        <div class="stat-item">
          <div class="stat-label">总登录次数</div>
          <div class="stat-value">{{ stats.total_logins }}</div>
        </div>
        <div class="stat-item">
          <div class="stat-label">今日登录</div>
          <div class="stat-value">{{ stats.today_logins }}</div>
        </div>
        <div class="stat-item">
          <div class="stat-label">本周登录</div>
          <div class="stat-value">{{ stats.week_logins }}</div>
        </div>
        <div class="stat-item">
          <div class="stat-label">活跃用户</div>
          <div class="stat-value">{{ stats.active_users }}</div>
        </div>
      </div>
    </el-card>

    <el-card class="chart-card">
      <h3>登录趋势（最近7天）</h3>
      <div class="chart-container">
        <div v-for="item in stats.daily_trend" :key="item.date" class="chart-bar">
          <div class="bar" :style="{ height: getBarHeight(item.count) + 'px' }">
            <span class="bar-value">{{ item.count }}</span>
          </div>
          <div class="bar-label">{{ formatShortDate(item.date) }}</div>
        </div>
      </div>
    </el-card>

    <el-card class="table-card">
      <div class="table-header">
        <h3>登录日志</h3>
        <div class="search-bar">
          <el-input
            v-model="searchUsername"
            placeholder="搜索用户名"
            style="width: 200px"
            clearable
          />
          <el-date-picker
            v-model="dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            style="width: 300px; margin-left: 10px"
          />
          <el-button type="primary" @click="handleSearch" style="margin-left: 10px">搜索</el-button>
        </div>
      </div>

      <el-table :data="logs" style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="用户名" width="150" />
        <el-table-column prop="role" label="角色" width="120">
          <template #default="{ row }">
            <el-tag :type="row.role === 'admin' ? 'danger' : 'info'">
              {{ row.role === 'admin' ? '管理员' : '普通用户' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="ip_address" label="IP地址" width="150" />
        <el-table-column prop="login_at" label="登录时间" width="200">
          <template #default="{ row }">
            {{ formatDate(row.login_at) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :total="total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handlePageChange"
        style="margin-top: 20px; justify-content: flex-end"
      />
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'

const stats = ref({
  total_logins: 0,
  today_logins: 0,
  week_logins: 0,
  month_logins: 0,
  active_users: 0,
  daily_trend: []
})

const logs = ref([])
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)
const searchUsername = ref('')
const dateRange = ref([])

const fetchStats = async () => {
  try {
    const token = localStorage.getItem('token')
    const response = await axios.get('/api/v1/admin/login-logs/stats', {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (response.data.code === 200) {
      stats.value = response.data.data
    }
  } catch (error) {
    console.error('获取统计数据失败:', error)
  }
}

const fetchLogs = async () => {
  loading.value = true
  try {
    const token = localStorage.getItem('token')
    const params = {
      page: currentPage.value,
      page_size: pageSize.value
    }
    
    if (searchUsername.value) {
      params.username = searchUsername.value
    }
    
    if (dateRange.value && dateRange.value.length === 2) {
      params.start_date = formatDateParam(dateRange.value[0])
      params.end_date = formatDateParam(dateRange.value[1])
    }
    
    const response = await axios.get('/api/v1/admin/login-logs', {
      headers: { Authorization: `Bearer ${token}` },
      params
    })
    
    if (response.data.code === 200) {
      logs.value = response.data.data.logs
      total.value = response.data.data.pagination.total
    }
  } catch (error) {
    ElMessage.error('获取登录日志失败')
    console.error('获取登录日志失败:', error)
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  currentPage.value = 1
  fetchLogs()
}

const handlePageChange = (page) => {
  currentPage.value = page
  fetchLogs()
}

const handleSizeChange = (size) => {
  pageSize.value = size
  currentPage.value = 1
  fetchLogs()
}

const handleDelete = (row) => {
  ElMessageBox.confirm(`确定要删除这条登录日志吗？`, '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const token = localStorage.getItem('token')
      const response = await axios.delete(`/api/v1/admin/login-logs/${row.id}`, {
        headers: { Authorization: `Bearer ${token}` }
      })
      if (response.data.code === 200) {
        ElMessage.success('删除成功')
        fetchLogs()
        fetchStats()
      }
    } catch (error) {
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
}

const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleString('zh-CN')
}

const formatDateParam = (date) => {
  const d = new Date(date)
  const year = d.getFullYear()
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

const formatShortDate = (dateStr) => {
  const date = new Date(dateStr)
  return `${date.getMonth() + 1}/${date.getDate()}`
}

const getBarHeight = (count) => {
  const maxCount = Math.max(...stats.value.daily_trend.map(item => item.count), 1)
  return Math.max((count / maxCount) * 150, 20)
}

onMounted(() => {
  fetchStats()
  fetchLogs()
})
</script>

<style scoped>
.login-logs {
  padding: 0;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.login-logs .el-card {
  border-radius: 0;
  border: none;
}

.login-logs :deep(.el-card__body) {
  padding: 20px;
}

.stats-card {
  margin-bottom: 20px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.stat-item {
  text-align: center;
  padding: 20px;
  background: #f5f7fa;
  border-radius: 8px;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 28px;
  font-weight: bold;
  color: #303133;
}

.chart-card {
  margin-bottom: 20px;
}

.chart-card h3 {
  margin: 0 0 20px 0;
  font-size: 16px;
  font-weight: 600;
}

.chart-container {
  display: flex;
  align-items: flex-end;
  justify-content: space-around;
  height: 200px;
  padding: 20px 0;
}

.chart-bar {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}

.bar {
  width: 60px;
  background: linear-gradient(180deg, #409EFF 0%, #66b1ff 100%);
  border-radius: 4px 4px 0 0;
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding-top: 5px;
  transition: all 0.3s;
  position: relative;
}

.bar:hover {
  background: linear-gradient(180deg, #66b1ff 0%, #409EFF 100%);
}

.bar-value {
  color: #fff;
  font-size: 12px;
  font-weight: bold;
}

.bar-label {
  margin-top: 8px;
  font-size: 12px;
  color: #606266;
}

.table-card {
  margin-top: 20px;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.table-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
}

.search-bar {
  display: flex;
  align-items: center;
}
</style>
