<template>
  <div class="products-container">
    <ProductFilter @search="handleFilterSearch" />

    <!-- 商品列表区域（原有内容） -->
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
          <el-table-column label="爬取时间" width="160" class-name="mobile-simple">
            <template #default="{ row }">
              <span style="font-size: 12px;">{{ formatDateTime(row.captured_at) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="价格" width="100" class-name="mobile-simple">
            <template #default="{ row }">
              {{ row.currency }} {{ formatPrice(row.price) }}
            </template>
          </el-table-column>
          <el-table-column label="库存状态" width="100">
            <template #default="{ row }">
              <el-tag v-if="row.is_available === true" type="success" size="small">有货</el-tag>
              <el-tag v-else-if="row.is_available === false" type="danger" size="small">无货</el-tag>
              <el-tag v-else type="info" size="small">未知</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="store_name" label="店铺名称" width="150" class-name="mobile-hide" show-overflow-tooltip />
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
import { Picture } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import request from '../../utils/request'
import ProductFilter from '../../components/Shopify/ProductFilter.vue'

const filterParams = ref({})

const handleFilterSearch = (params) => {
  filterParams.value = params
  currentPage.value = 1
  fetchProducts()
}


// ==================== 商品列表逻辑 ====================

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
    const response = await request.get('/v1/admin/crawler/tasks')
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
    
    const fp = filterParams.value
    if (fp.country && fp.country !== '' && fp.country !== 'all') {
      params.country_code = fp.country
    }
    
    if (fp.category && fp.category !== 'all' && fp.category !== '') {
      params.category_code = fp.category
    }
    
    if (fp.keyword && fp.keyword.trim() !== '') {
      params.keyword = fp.keyword.trim()
    }

    // 使用新的搜索 API
    const response = await request.get('/v1/shopify/products/search', { params })
    
    // 处理响应数据
    if (response.data.data) {
      // 新 API 返回格式：{ data: [...], total: 100, filters_applied: {...} }
      products.value = response.data.data
      total.value = response.data.total || 0
    } else {
      // 兼容旧格式
      products.value = response.data.items || response.data
      total.value = response.data.total || products.value.length
    }
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

// 格式化日期（完整格式）
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleString('zh-CN')
}

// 格式化日期时间（简洁格式：月-日 时:分）
const formatDateTime = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  return `${month}-${day} ${hours}:${minutes}`
}

// 打开商品链接
const openUrl = (url) => {
  if (url) {
    window.open(url, '_blank')
  }
}

onMounted(() => {
  fetchStores()
  fetchProducts()
})
</script>

<style scoped>
.products-container {
  padding: 20px;
  height: 100%;
  box-sizing: border-box;
}

.products-container .el-card {
  height: 100%;
  display: flex;
  flex-direction: column;
  border-radius: 8px;
}

.products-container :deep(.el-card__body) {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

.products-container :deep(.el-card__body)::-webkit-scrollbar {
  width: 6px;
}

.products-container :deep(.el-card__body)::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.products-container :deep(.el-card__body)::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.products-container :deep(.el-card__body)::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
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