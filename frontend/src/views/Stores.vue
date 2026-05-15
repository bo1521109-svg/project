<template>
  <div class="stores-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>店铺管理</span>
          <el-button type="primary" @click="showAddDialog = true">添加店铺</el-button>
        </div>
      </template>

      <!-- 店铺列表表格 -->
      <div class="table-container">
        <el-table :data="stores" style="width: 100%" v-loading="loading">
          <el-table-column prop="id" label="ID" width="80" class-name="mobile-hide" />
          <el-table-column prop="name" label="店铺名称" min-width="200" />
          <el-table-column prop="url" label="店铺网址" min-width="300" show-overflow-tooltip class-name="mobile-hide" />
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
                @click="deleteStore(row)"
              >
                删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-card>

    <!-- 添加店铺对话框 -->
    <el-dialog v-model="showAddDialog" title="添加新店铺" width="500px">
      <el-form :model="newStore" label-width="100px">
        <el-form-item label="店铺名称" required>
          <el-input v-model="newStore.name" placeholder="请输入店铺名称" />
        </el-form-item>
        <el-form-item label="店铺网址" required>
          <el-input v-model="newStore.url" placeholder="https://example.com" />
        </el-form-item>
        <el-form-item label="平台">
          <el-input v-model="newStore.platform" placeholder="默认 shopify" />
        </el-form-item>
        <el-form-item label="国家">
          <el-input v-model="newStore.country" placeholder="可选" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="addStore" :loading="submitting">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../utils/request'

// 数据
const stores = ref([])
const loading = ref(false)
const showAddDialog = ref(false)
const submitting = ref(false)
const newStore = ref({
  name: '',
  url: '',
  platform: 'shopify',
  country: ''
})

// 获取店铺列表
const fetchStores = async () => {
  loading.value = true
  try {
    const response = await request.get('/v1/stores/')
    stores.value = response.data
  } catch (error) {
    ElMessage.error('获取店铺列表失败：' + (error.response?.data?.detail || error.message))
  } finally {
    loading.value = false
  }
}

// 添加店铺
const addStore = async () => {
  if (!newStore.value.name || !newStore.value.url) {
    ElMessage.warning('请填写店铺名称和网址')
    return
  }

  submitting.value = true
  try {
    await request.post('/v1/stores/', newStore.value)
    ElMessage.success('添加店铺成功')
    showAddDialog.value = false
    newStore.value = { name: '', url: '', platform: 'shopify', country: '' }
    fetchStores()
  } catch (error) {
    ElMessage.error('添加店铺失败：' + (error.response?.data?.detail || error.message))
  } finally {
    submitting.value = false
  }
}

// 开始爬取
const startCrawl = async (storeId) => {
  try {
    // 更新本地状态
    const store = stores.value.find(s => s.id === storeId)
    if (store) {
      store.is_crawling = true
    }

    const response = await request.post(`/v1/stores/${storeId}/crawl`)
    ElMessage.success(response.data.message || '爬取任务已启动')
    
    // 定时刷新状态
    setTimeout(() => {
      fetchStores()
    }, 3000)
  } catch (error) {
    ElMessage.error('启动爬取失败：' + (error.response?.data?.detail || error.message))
    // 恢复状态
    const store = stores.value.find(s => s.id === storeId)
    if (store) {
      store.is_crawling = false
    }
  }
}

// 删除店铺
const deleteStore = async (store) => {
  try {
    // 二次确认
    await ElMessageBox.confirm(
      `确定要删除店铺"${store.name}"吗？此操作将同时删除该店铺下的所有商品数据，且不可恢复！`,
      '警告',
      {
        confirmButtonText: '确定删除',
        cancelButtonText: '取消',
        type: 'warning',
        confirmButtonClass: 'el-button--danger'
      }
    )

    // 执行删除
    const response = await request.delete(`/v1/stores/${store.id}`)
    ElMessage.success(response.data.message || '店铺删除成功')
    
    // 刷新列表
    fetchStores()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除店铺失败：' + (error.response?.data?.detail || error.message))
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
  fetchStores()
})
</script>

<style scoped>
.stores-container {
  padding: 0;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.stores-container .el-card {
  height: 100%;
  display: flex;
  flex-direction: column;
  border-radius: 0;
  border: none;
}

.stores-container :deep(.el-card__body) {
  flex: 1;
  overflow: hidden;
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
  height: 100%;
}

:deep(.el-table) {
  min-width: 800px; /* 强制表格保持最小宽度 */
}

/* 移动端优化 */
@media (max-width: 768px) {
  .stores-container :deep(.el-card__body) {
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

  /* 隐藏部分列 */
  :deep(.mobile-hide) {
    display: none !important;
  }

  /* 简化操作列 */
  :deep(.mobile-simple .cell) {
    padding: 5px !important;
  }
}
</style>
