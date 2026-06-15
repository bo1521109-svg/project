<template>
  <div class="store-search-page">
    <TikTokStoreFilter @search="handleFilterSearch" />

    <div class="results-section">
      <el-empty description="请输入搜索条件并点击搜索按钮" />
    </div>
  </div>
</template>

<script setup>
// TikTok店铺搜索页 - 使用抽取的TikTokStoreFilter共享组件
// 原本1510行的筛选代码已全部抽取到组件中，页面只负责接收参数并调用API
import TikTokStoreFilter from '../../components/TikTok/TikTokStoreFilter.vue'
import request from '@/utils/request'

// TikTok店铺搜索API - 后端prefix: /tiktok/stores
const API_PATH = '/v1/tiktok/stores'

// 接收筛选组件发出的搜索参数，调用后端API获取店铺搜索结果
const handleFilterSearch = async (params) => {
  try {
    const response = await request.get(API_PATH, { params })
    console.log('店铺搜索结果:', response.data)
  } catch (e) {
    console.error('店铺搜索失败:', e)
  }
}
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

.results-section {
  background: white;
  padding: 20px;
  border-radius: 0;
  box-shadow: none;
  flex: 1;
  min-height: 400px;
}

@media (max-width: 768px) {
  .store-search-page {
    padding: 10px;
  }
}
</style>
