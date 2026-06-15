<template>
  <div class="store-search-page">
    <StoreFilter @search="handleFilterSearch" />

    <el-card>
      <template #header>
        <div class="card-header">
          <span>店铺列表 (Total {{ total }})</span>
        </div>
      </template>

      <div class="table-container">
        <el-table :data="stores" style="width: 100%" v-loading="loading">
          <el-table-column prop="name" labe
          l="店铺名称" min-width="200" show-overflow-tooltip />
          <el-table-column label="国家/地区" width="120">
            <template #default="{ row }">
              {{ getCountryLabel(row.country_code || row.country) }}
            </template>
          </el-table-column>
          <el-table-column label="近7天销量" width="120" sortable>
            <template #default="{ row }">
              {{ formatNumber(row.sales_7d) }}
            </template>
          </el-table-column>
          <el-table-column label="总销量" width="120" sortable>
            <template #default="{ row }">
              {{ formatNumber(row.sales_total) }}
            </template>
          </el-table-column>
          <el-table-column label="状态" width="100">
            <template #default="{ row }">
              <el-tag v-if="row.status === 'active'" type="success" size="small">活跃</el-tag>
              <el-tag v-else-if="row.status === 'paused'" type="warning" size="small">暂停</el-tag>
              <el-tag v-else type="info" size="small">{{ row.status }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="120" fixed="right">
            <template #default="{ row }">
              <el-button
                type="primary"
                size="small"
                link
                @click="openUrl(row.url)"
              >
                访问店铺
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
          @size-change="fetchStores"
          @current-change="fetchStores"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import request from '../../utils/request'
import StoreFilter from '../../components/Shopify/StoreFilter.vue'

const filterParams = ref({})

const handleFilterSearch = (params) => {
  filterParams.value = params
  currentPage.value = 1
  fetchStores()
}

const stores = ref([])
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)

const getCountryLabel = (code) => {
  const countryCode = code ? code.toUpperCase() : null
  if (!countryCode) return '-'
  const countries = [
    { label: '美国', value: 'US' },
    { label: '印度尼西亚', value: 'ID' },
    { label: '英国', value: 'GB' },
    { label: '越南', value: 'VN' },
    { label: '泰国', value: 'TH' },
    { label: '马来西亚', value: 'MY' },
    { label: '菲律宾', value: 'PH' },
    { label: '西班牙', value: 'ES' },
    { label: '墨西哥', value: 'MX' },
    { label: '德国', value: 'DE' },
    { label: '法国', value: 'FR' },
    { label: '意大利', value: 'IT' },
    { label: '巴西', value: 'BR' },
    { label: '日本', value: 'JP' },
    { label: '新加坡', value: 'SG' }
  ]
  const country = countries.find(c => c.value === countryCode)
  return country ? country.label : countryCode
}

const fetchStores = async () => {
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

    if (fp.keyword && fp.keyword.trim() !== '') {
      params.keyword = fp.keyword.trim()
    }

    if (fp.sales7d && fp.sales7d !== 'all') {
      const sales7dOptions = [
        { label: '全部', value: 'all', min: '', max: '' },
        { label: '>10万', value: '>100000', min: '100000', max: '' },
        { label: '5万-10万', value: '50000-100000', min: '50000', max: '100000' },
        { label: '1万-5万', value: '10000-50000', min: '10000', max: '50000' },
        { label: '5000-9999', value: '5000-9999', min: '5000', max: '9999' },
        { label: '1000-4999', value: '1000-4999', min: '1000', max: '4999' },
        { label: '500-999', value: '500-999', min: '500', max: '999' },
        { label: '<500', value: '<500', min: '', max: '500' }
      ]
      const option = sales7dOptions.find(opt => opt.value === fp.sales7d)
      if (option) {
        if (option.min) params.sales_7d_min = parseInt(option.min)
        if (option.max) params.sales_7d_max = parseInt(option.max)
      }
    }

    if (fp.totalSales && fp.totalSales !== 'all') {
      const totalSalesOptions = [
        { label: '全部', value: 'all', min: '', max: '' },
        { label: '>100万', value: '>1000000', min: '1000000', max: '' },
        { label: '50万-100万', value: '500000-1000000', min: '500000', max: '1000000' },
        { label: '10万-50万', value: '100000-500000', min: '100000', max: '500000' },
        { label: '1万-10万', value: '10000-100000', min: '10000', max: '100000' },
        { label: '5000-1万', value: '5000-10000', min: '5000', max: '10000' },
        { label: '<5000', value: '<5000', min: '', max: '5000' }
      ]
      const option = totalSalesOptions.find(opt => opt.value === fp.totalSales)
      if (option) {
        if (option.min) params.sales_total_min = parseInt(option.min)
        if (option.max) params.sales_total_max = parseInt(option.max)
      }
    }

    const response = await request.get('/v1/shopify/stores/search', { params })

    if (response.data && response.data.data) {
      stores.value = response.data.data
      total.value = response.data.total || 0
    } else if (Array.isArray(response.data)) {
      stores.value = response.data
      total.value = response.data.length
    } else {
      stores.value = []
      total.value = 0
    }
  } catch (error) {
    ElMessage.error('获取店铺列表失败：' + (error.response?.data?.detail || error.message))
    stores.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

const formatNumber = (num) => {
  if (!num && num !== 0) return '-'
  return num.toLocaleString()
}

const openUrl = (url) => {
  if (url) {
    window.open(url, '_blank')
  }
}

fetchStores()
</script>

<style scoped>
.store-search-page {
  padding: 0;
  background: #f5f7fa;
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: auto;
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

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

@media (max-width: 768px) {
  .store-search-page { padding: 10px; }
  .pagination :deep(.el-pagination) { justify-content: center; }
}
</style>
