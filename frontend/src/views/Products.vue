<template>
  <div class="products-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>商品列表</span>
          <el-select 
            v-model="selectedStoreId" 
            placeholder="按店铺筛选" 
            clearable
            @change="fetchProducts"
            style="width: 200px"
          >
            <el-option
              v-for="store in stores"
              :key="store.id"
              :label="store.name"
              :value="store.id"
            />
          </el-select>
        </div>
      </template>

      <!-- 商品列表表格 -->
      <div class="table-container">
        <el-table :data="products" style="width: 100%" v-loading="loading">
          <el-table-column label="图片" width="80" class-name="mobile-image">
            <template #default="{ row }">
              <el-image
                :src="row.image_url"
                fit="cover"
                style="width: 60px; height: 60px"
                :preview-src-list="[row.image_url]"
              >
                <template #error>
                  <div class="image-slot">
                    <el-icon><Picture /></el-icon>
                  </div>
                </template>
              </el-image>
            </template>
          </el-table-column>
          <el-table-column prop="title" label="商品标题" min-width="150" show-overflow-tooltip />
          <el-table-column label="价格" width="100" class-name="mobile-simple">
            <template #default="{ row }">
              {{ row.currency }} {{ formatPrice(row.price) }}
            </template>
          </el-table-column>
          <el-table-column prop="store_id" label="店铺ID" width="100" class-name="mobile-hide" />
          <el-table-column label="销售预估" width="120" class-name="mobile-hide">
            <template #default="{ row }">
              {{ row.sales_estimate || 0 }}
            </template>
          </el-table-column>
          <el-table-column label="抓取时间" width="180" class-name="mobile-hide">
            <template #default="{ row }">
              {{ formatDate(row.captured_at) }}
            </template>
          </el-table-column>
          <el-table-column label="操作" width="120" fixed="right" class-name="mobile-simple">
            <template #default="{ row }">
              <el-button 
                type="primary" 
                size="small" 
                link
                @click="openUrl(row.url)"
              >
                详情
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :total="total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="fetchProducts"
          @current-change="fetchProducts"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Picture } from '@element-plus/icons-vue'
import request from '../utils/request'

// 数据
const products = ref([])
const stores = ref([])
const loading = ref(false)
const selectedStoreId = ref(null)
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)

// 获取店铺列表（用于筛选）
const fetchStores = async () => {
  try {
    const response = await request.get('/v1/stores/')
    stores.value = response.data
  } catch (error) {
    console.error('获取店铺列表失败', error)
  }
}

// 获取商品列表
const fetchProducts = async () => {
  loading.value = true
  try {
    const params = {
      skip: (currentPage.value - 1) * pageSize.value,
      limit: pageSize.value
    }
    
    // 如果选择了店铺，添加筛选参数
    if (selectedStoreId.value) {
      params.store_id = selectedStoreId.value
    }

    const response = await request.get('/v1/products/', { params })
    products.value = response.data.items || response.data
    total.value = response.data.total || products.value.length
  } catch (error) {
    ElMessage.error('获取商品列表失败：' + (error.response?.data?.detail || error.message))
  } finally {
    loading.value = false
  }
}

// 格式化价格（保留2位小数）
const formatPrice = (price) => {
  if (!price) return '0.00'
  return parseFloat(price).toFixed(2)
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleString('zh-CN')
}

// 打开商品链接
const openUrl = (url) => {
  if (url) {
    window.open(url, '_blank')
  }
}

// 页面加载时获取数据
onMounted(() => {
  fetchStores()
  fetchProducts()
})
</script>

<style scoped>
.products-container {
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
  min-width: 600px !important; /* 表格最小宽度，允许横向滚动 */
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  color: #909399;
  font-size: 30px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* 移动端优化 */
@media (max-width: 768px) {
  .products-container {
    padding: 10px;
  }

  .card-header {
    flex-direction: column;
    gap: 10px;
    align-items: stretch;
  }

  .card-header .el-select {
    width: 100% !important;
  }

  /* 隐藏部分列 */
  :deep(.mobile-hide) {
    display: none !important;
  }

  /* 分页组件简化 */
  .pagination :deep(.el-pagination) {
    justify-content: center;
  }

  .pagination :deep(.el-pagination__sizes),
  .pagination :deep(.el-pagination__jump) {
    display: none;
  }
}

/* 小屏幕手机优化 (<430px) */
@media (max-width: 430px) {
  :deep(.el-table) {
    min-width: 600px !important; /* 保持最小宽度，允许横向滚动 */
  }

  /* 图片列固定宽度 80px */
  :deep(.mobile-image) {
    width: 80px !important;
  }

  :deep(.mobile-image .cell) {
    padding: 5px !important;
  }

  /* 商品标题列设置 min-width: 150px，使用省略号 */
  :deep(.el-table__body-wrapper .el-table__body tbody tr td:nth-child(2)) {
    min-width: 150px !important;
  }

  :deep(.el-table__body-wrapper .el-table__body tbody tr td:nth-child(2) .cell) {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  /* 价格列固定宽度 100px */
  :deep(.el-table__body-wrapper .el-table__body tbody tr td:nth-child(3)) {
    width: 100px !important;
  }

  /* 简化操作列 */
  :deep(.mobile-simple .cell) {
    padding: 5px !important;
  }

  /* 隐藏"店铺ID"和"销售预估"列 */
  :deep(.mobile-hide) {
    display: none !important;
  }
}
</style>
