<template>
  <div class="influencer-rank-page">
    <TikTokInfluencerFilter @search="handleFilterSearch" />
    <div class="rank-content">
      <el-empty description="请通过上方筛选条件搜索带货达人" />
    </div>
  </div>
</template>

<script setup>
import TikTokInfluencerFilter from '@/components/TikTok/TikTokInfluencerFilter.vue'

const handleFilterSearch = (params) => {
  console.log('带货达人榜筛选参数:', params)
}
</script>

<style scoped>
.influencer-rank-page {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 120px);
  background: #f0f2f5;
  overflow: auto;
}
.rank-content {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fff;
  margin: 12px 24px;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
}
</style>
