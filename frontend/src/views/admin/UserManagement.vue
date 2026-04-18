<template>
  <div class="user-management">
    <el-card class="stats-card">
      <div class="stats-grid">
        <div class="stat-item">
          <div class="stat-label">总用户数</div>
          <div class="stat-value">{{ stats.total_users }}</div>
        </div>
        <div class="stat-item">
          <div class="stat-label">管理员</div>
          <div class="stat-value">{{ stats.admin_count }}</div>
        </div>
        <div class="stat-item">
          <div class="stat-label">普通用户</div>
          <div class="stat-value">{{ stats.user_count }}</div>
        </div>
        <div class="stat-item">
          <div class="stat-label">本月新增</div>
          <div class="stat-value">{{ stats.month_new }}</div>
        </div>
      </div>
    </el-card>

    <el-card class="table-card">
      <div class="table-header">
        <h3>用户列表</h3>
        <div class="search-bar">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索用户名或手机号"
            style="width: 300px"
            clearable
            @clear="handleSearch"
          >
            <template #append>
              <el-button @click="handleSearch" :icon="Search">搜索</el-button>
            </template>
          </el-input>
          <el-select v-model="roleFilter" placeholder="角色筛选" style="width: 150px; margin-left: 10px" @change="handleSearch">
            <el-option label="全部" value="" />
            <el-option label="管理员" value="admin" />
            <el-option label="普通用户" value="user" />
          </el-select>
        </div>
      </div>

      <el-table :data="users" style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="用户名" width="150" />
        <el-table-column prop="role" label="角色" width="120">
          <template #default="{ row }">
            <el-tag :type="row.role === 'admin' ? 'danger' : 'info'">
              {{ row.role === 'admin' ? '管理员' : '普通用户' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="phone" label="手机号" width="150" />
        <el-table-column prop="invitation_code" label="邀请码" width="120" />
        <el-table-column prop="invited_count" label="邀请人数" width="100" />
        <el-table-column prop="login_count" label="登录次数" width="100" />
        <el-table-column prop="created_at" label="注册时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.created_at) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="handleEdit(row)">编辑</el-button>
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
import { Search } from '@element-plus/icons-vue'
import axios from 'axios'

const stats = ref({
  total_users: 0,
  admin_count: 0,
  user_count: 0,
  today_new: 0,
  week_new: 0,
  month_new: 0
})

const users = ref([])
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)
const searchKeyword = ref('')
const roleFilter = ref('')

const fetchStats = async () => {
  try {
    const token = localStorage.getItem('token')
    const response = await axios.get('/api/v1/admin/users/stats', {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (response.data.code === 200) {
      stats.value = response.data.data
    }
  } catch (error) {
    console.error('获取统计数据失败:', error)
  }
}

const fetchUsers = async () => {
  loading.value = true
  try {
    const token = localStorage.getItem('token')
    const params = {
      page: currentPage.value,
      page_size: pageSize.value
    }
    if (searchKeyword.value) {
      params.keyword = searchKeyword.value
    }
    if (roleFilter.value) {
      params.role = roleFilter.value
    }
    
    const response = await axios.get('/api/v1/admin/users', {
      headers: { Authorization: `Bearer ${token}` },
      params
    })
    
    if (response.data.code === 200) {
      users.value = response.data.data.users
      total.value = response.data.data.pagination.total
    }
  } catch (error) {
    ElMessage.error('获取用户列表失败')
    console.error('获取用户列表失败:', error)
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  currentPage.value = 1
  fetchUsers()
}

const handlePageChange = (page) => {
  currentPage.value = page
  fetchUsers()
}

const handleSizeChange = (size) => {
  pageSize.value = size
  currentPage.value = 1
  fetchUsers()
}

const handleEdit = (row) => {
  ElMessageBox.prompt('请输入新角色', '修改用户角色', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    inputValue: row.role,
    inputValidator: (value) => {
      if (!value || !['admin', 'user'].includes(value)) {
        return '请输入 admin 或 user'
      }
      return true
    }
  }).then(async ({ value }) => {
    try {
      const token = localStorage.getItem('token')
      const response = await axios.put(
        `/api/v1/admin/users/${row.id}/role`,
        null,
        {
          headers: { Authorization: `Bearer ${token}` },
          params: { role: value }
        }
      )
      if (response.data.code === 200) {
        ElMessage.success('角色修改成功')
        fetchUsers()
        fetchStats()
      }
    } catch (error) {
      ElMessage.error('角色修改失败')
    }
  }).catch(() => {})
}

const handleDelete = (row) => {
  ElMessageBox.confirm(`确定要删除用户 ${row.username} 吗？`, '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const token = localStorage.getItem('token')
      const response = await axios.delete(`/api/v1/admin/users/${row.id}`, {
        headers: { Authorization: `Bearer ${token}` }
      })
      if (response.data.code === 200) {
        ElMessage.success('删除成功')
        fetchUsers()
        fetchStats()
      }
    } catch (error) {
      ElMessage.error(error.response?.data?.detail || '删除失败')
    }
  }).catch(() => {})
}

const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleString('zh-CN')
}

onMounted(() => {
  fetchStats()
  fetchUsers()
})
</script>

<style scoped>
.user-management {
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
