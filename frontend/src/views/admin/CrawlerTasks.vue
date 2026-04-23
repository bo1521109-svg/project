<template>
  <div class="crawler-tasks-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>爬虫任务管理</span>
          <el-button type="primary" @click="showAddDialog = true">添加爬虫任务</el-button>
        </div>
      </template>

      <!-- 爬虫任务列表表格 -->
      <div class="table-container">
        <el-table :data="tasks" style="width: 100%" v-loading="loading">
          <el-table-column prop="id" label="ID" width="80" class-name="mobile-hide" />
          <el-table-column prop="name" label="任务名称" min-width="200" />
          <el-table-column prop="url" label="目标网址" min-width="300" show-overflow-tooltip class-name="mobile-hide" />
          <el-table-column prop="platform" label="平台" width="120" class-name="mobile-hide" />
          <el-table-column prop="status" label="状态" width="120" class-name="mobile-simple">
            <template #default="{ row }">
              <el-tag :type="getStatusType(row.status)">{{ row.status }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="last_crawl_at" label="最后爬取时间" width="180" class-name="mobile-hide">
            <template #default="{ row }">
              {{ formatDate(row.last_crawl_at) }}
            </template>
          </el-table-column>
          <el-table-column label="操作" width="200" fixed="right" class-name="mobile-simple">
            <template #default="{ row }">
              <el-button 
                type="primary" 
                size="small" 
                :loading="row.is_crawling"
                :disabled="row.is_crawling"
                @click="startCrawl(row.id)"
              >
                {{ row.is_crawling ? '爬取中' : '爬取' }}
              </el-button>
              <el-button 
                type="danger" 
                size="small" 
                :disabled="row.is_crawling"
                @click="deleteTask(row)"
              >
                删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-card>

    <!-- 添加爬虫任务对话框 -->
    <el-dialog v-model="showAddDialog" title="添加爬虫任务" width="500px">
      <el-form :model="newTask" label-width="100px">
        <el-form-item label="任务名称" required>
          <el-input v-model="newTask.name" placeholder="请输入任务名称" />
        </el-form-item>
        <el-form-item label="目标网址" required>
          <el-input v-model="newTask.url" placeholder="https://example.com" />
        </el-form-item>
        <el-form-item label="平台">
          <el-input v-model="newTask.platform" placeholder="默认 shopify" />
        </el-form-item>
        <el-form-item label="国家">
          <el-input v-model="newTask.country" placeholder="可选" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="addTask" :loading="submitting">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../../utils/request'

// 数据
const tasks = ref([])
const loading = ref(false)
const showAddDialog = ref(false)
const submitting = ref(false)
const newTask = ref({
  name: '',
  url: '',
  platform: 'shopify',
  country: ''
})

// 获取爬虫任务列表
const fetchTasks = async () => {
  loading.value = true
  try {
    const response = await request.get('/v1/admin/crawler/tasks')
    tasks.value = response.data
  } catch (error) {
    ElMessage.error('获取爬虫任务列表失败：' + (error.response?.data?.detail || error.message))
  } finally {
    loading.value = false
  }
}

// 添加爬虫任务
const addTask = async () => {
  if (!newTask.value.name || !newTask.value.url) {
    ElMessage.warning('请填写任务名称和目标网址')
    return
  }

  submitting.value = true
  try {
    await request.post('/v1/admin/crawler/tasks', newTask.value)
    ElMessage.success('添加爬虫任务成功')
    showAddDialog.value = false
    newTask.value = { name: '', url: '', platform: 'shopify', country: '' }
    fetchTasks()
  } catch (error) {
    ElMessage.error('添加爬虫任务失败：' + (error.response?.data?.detail || error.message))
  } finally {
    submitting.value = false
  }
}

// 开始爬取
const startCrawl = async (taskId) => {
  try {
    // 更新本地状态
    const task = tasks.value.find(t => t.id === taskId)
    if (task) {
      task.is_crawling = true
    }

    const response = await request.post(`/v1/admin/crawler/tasks/${taskId}/crawl`)
    ElMessage.success(response.data.message || '爬取任务已启动')
    
    // 定时刷新状态
    setTimeout(() => {
      fetchTasks()
    }, 3000)
  } catch (error) {
    ElMessage.error('启动爬取失败：' + (error.response?.data?.detail || error.message))
    // 恢复状态
    const task = tasks.value.find(t => t.id === taskId)
    if (task) {
      task.is_crawling = false
    }
  }
}

// 删除爬虫任务
const deleteTask = async (task) => {
  try {
    // 二次确认
    await ElMessageBox.confirm(
      `确定要删除爬虫任务"${task.name}"吗？此操作将同时删除该任务下的所有数据，且不可恢复！`,
      '警告',
      {
        confirmButtonText: '确定删除',
        cancelButtonText: '取消',
        type: 'warning',
        confirmButtonClass: 'el-button--danger'
      }
    )

    // 执行删除
    const response = await request.delete(`/v1/admin/crawler/tasks/${task.id}`)
    ElMessage.success(response.data.message || '爬虫任务删除成功')
    
    // 刷新列表
    fetchTasks()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除爬虫任务失败：' + (error.response?.data?.detail || error.message))
    }
  }
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleString('zh-CN')
}

// 获取状态标签类型
const getStatusType = (status) => {
  const typeMap = {
    'active': 'success',
    'paused': 'warning',
    'error': 'danger'
  }
  return typeMap[status] || 'info'
}

// 页面加载时获取数据
onMounted(() => {
  fetchTasks()
})
</script>

<style scoped>
.crawler-tasks-container {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.table-container {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

:deep(.el-table) {
  min-width: 800px;
}

/* 移动端优化 */
@media (max-width: 768px) {
  .crawler-tasks-container {
    padding: 10px;
  }

  .card-header {
    flex-direction: column;
    gap: 10px;
    align-items: stretch;
  }

  .card-header .el-button {
    width: 100%;
  }

  :deep(.mobile-hide) {
    display: none !important;
  }

  :deep(.mobile-simple .cell) {
    padding: 5px !important;
  }
}
</style>
