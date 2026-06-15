<template>
  <div class="store-search-page">
    <TikTokProductFilter @search="handleSearch" />
    <div class="results-section">
      <div class="results-placeholder">
        <el-empty description="商品搜索结果将在此展示" />
      </div>
    </div>
  </div>
</template>

<script setup>
import TikTokProductFilter from '@/components/TikTok/TikTokProductFilter.vue'

const handleSearch = (params) => {
  console.log('搜索参数:', params)
}
</script>

<style scoped>
.store-search-page {
  background-color: #ffffff;
  min-height: 100vh;
}

.results-section {
  padding: 24px;
}
</style>
