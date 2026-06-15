<template>
  <div class="ranking-container">
    <ProductFilter @search="handleFilterSearch" />

    <el-card>
      <template #header>
        <div class="card-header">
          <span>商品飙升榜</span>
        </div>
      </template>

      <div class="table-container">
        <el-table :data="rankingData" style="width: 100%" v-loading="loading">
          <el-table-column type="index" label="排名" width="60" />
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
          <el-table-column prop="store_name" label="店铺名称" width="150" show-overflow-tooltip />
          <el-table-column label="价格" width="100">
            <template #default="{ row }">
              {{ row.currency }} {{ formatPrice(row.price) }}
            </template>
          </el-table-column>
          <el-table-column label="近7天销量" width="120" sortable>
            <template #default="{ row }">
              {{ row.sales_7d || '-' }}
            </template>
          </el-table-column>
          <el-table-column prop="sales_total" label="总销量" width="120" sortable />
          <el-table-column label="操作" width="120" fixed="right">
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

      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :total="total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="fetchRanking"
          @current-change="fetchRanking"
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
  fetchRanking()
}

const rankingData = ref([])
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)

const fetchRanking = async () => {
  loading.value = true
  try {
    const params = {
      skip: (currentPage.value - 1) * pageSize.value,
      limit: pageSize.value
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

    const response = await request.get('/v1/shopify/products/surge-rank', { params })

    if (response.data.data) {
      rankingData.value = response.data.data
      total.value = response.data.total || 0
    } else {
      rankingData.value = response.data.items || response.data
      total.value = response.data.total || rankingData.value.length
    }
  } catch (error) {
    ElMessage.error('获取飙升榜失败：' + (error.response?.data?.detail || error.message))
  } finally {
    loading.value = false
  }
}

const formatPrice = (price) => {
  if (!price) return '0.00'
  return parseFloat(price).toFixed(2)
}

const openUrl = (url) => {
  if (url) {
    window.open(url, '_blank')
  }
}

onMounted(() => {
  fetchRanking()
})
</script>

<style scoped>
.ranking-container {
  padding: 20px;
  height: 100%;
  box-sizing: border-box;
}

.ranking-container .el-card {
  height: 100%;
  display: flex;
  flex-direction: column;
  border-radius: 8px;
}

.ranking-container :deep(.el-card__body) {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

.ranking-container :deep(.el-card__body)::-webkit-scrollbar {
  width: 6px;
}

.ranking-container :deep(.el-card__body)::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.ranking-container :deep(.el-card__body)::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.ranking-container :deep(.el-card__body)::-webkit-scrollbar-thumb:hover {
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
  min-width: 600px !important;
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

@media (max-width: 768px) {
  .ranking-container {
    padding: 10px;
  }

  .card-header {
    flex-direction: column;
    gap: 10px;
    align-items: stretch;
  }

  :deep(.mobile-hide) {
    display: none !important;
  }

  .pagination :deep(.el-pagination) {
    justify-content: center;
  }

  .pagination :deep(.el-pagination__sizes),
  .pagination :deep(.el-pagination__jump) {
    display: none;
  }
}
</style>
