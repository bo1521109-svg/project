<template>
  <div class="influencer-search-page">
    <TikTokInfluencerFilter @search="handleFilterSearch" />
    <div class="influencer-content">
      <el-empty description="请通过上方筛选条件搜索达人" />
    </div>
  </div>
</template>

<script setup>
/*
 * TikTok达人搜索页面
 * 使用TikTokInfluencerFilter筛选组件，预留达人列表展示区域
 */
import TikTokInfluencerFilter from '@/components/TikTok/TikTokInfluencerFilter.vue'

const handleFilterSearch = (params) => {
  // TODO: 后续联调时调用真实API获取达人数据
  console.log('达人搜索参数:', params)
}
</script>

<style scoped>
.influencer-search-page {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 120px);
  background: #f0f2f5;
  overflow: auto;
}
.influencer-content {
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
