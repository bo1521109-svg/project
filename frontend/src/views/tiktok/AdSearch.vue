<template>
  <div class="tk-ad-search-page">
    <TikTokAdFilter @search="handleFilterSearch" />
    <div class="ad-content">
      <el-empty description="请通过上方筛选条件搜索广告素材" />
    </div>
  </div>
</template>

<script setup>
/*
 * TikTok广告搜索页面
 * 使用TikTokAdFilter筛选组件，预留广告列表展示区域
 */
import TikTokAdFilter from '@/components/TikTok/TikTokAdFilter.vue'

const handleFilterSearch = (params) => {
  // TODO: 后续联调时调用真实API获取广告数据
  console.log('TikTok广告搜索参数:', params)
}
</script>

<style scoped>
.tk-ad-search-page {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 120px);
  background: #f0f2f5;
  overflow: auto;
}
.ad-content {
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
