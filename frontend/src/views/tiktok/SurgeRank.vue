<template>
  <div class="page-container">
    <TikTokProductFilter @search="handleSearch" />
    <div class="results-section">
      <div class="results-placeholder">
        <el-empty description="商品飙升榜数据将在此展示" />
      </div>
    </div>
  </div>
</template>

<script setup>
import TikTokProductFilter from '@/components/TikTok/TikTokProductFilter.vue'
import request from '@/utils/request'

const API_PATH = '/v1/tiktok/products/surge-rank'

const handleSearch = async (params) => {
  try {
    const response = await request.get(API_PATH, { params })
    console.log('飙升榜数据:', response.data)
  } catch (e) {
    console.error('获取飙升榜数据失败:', e)
  }
}
</script>

<style scoped>
.page-container {
  background-color: #ffffff;
  min-height: 100vh;
}

.results-section {
  padding: 24px;
}
</style>
