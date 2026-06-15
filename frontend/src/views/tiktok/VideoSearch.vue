<template>
  <div class="tk-video-page">
    <TikTokVideoFilter @search="handleFilterSearch" />
    <div class="video-content">
      <el-empty description="请通过上方筛选条件搜索热门视频" />
    </div>
  </div>
</template>

<script setup>
/*
 * TikTok视频搜索页面
 * 使用TikTokVideoFilter筛选组件，预留视频列表展示区域
 */
import TikTokVideoFilter from '@/components/TikTok/TikTokVideoFilter.vue'

const handleFilterSearch = (params) => {
  // TODO: 后续联调时调用真实API获取视频数据
  console.log('TikTok视频搜索参数:', params)
}
</script>

<style scoped>
.tk-video-page {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 120px);
  background: #f0f2f5;
  overflow: auto;
}
.video-content {
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
