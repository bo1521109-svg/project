<template>
  <div class="ranking-page">
    <TikTokStoreFilter @search="handleFilterSearch" />

    <el-card>
      <div class="placeholder-content">
        <el-empty description="功能开发中，敬请期待" :image-size="200" />
      </div>
    </el-card>
  </div>
</template>

<script setup>
// 使用TikTok专属的店铺筛选组件（包含店铺类型/模式/定位等TikTok特有筛选维度）
import TikTokStoreFilter from '../../components/TikTok/TikTokStoreFilter.vue'
import request from '@/utils/request'

// TikTok店铺飙升榜（热推榜）API - 后端prefix: /tiktok/stores/surge-rank
const API_PATH = '/v1/tiktok/stores/surge-rank'

// 接收筛选组件发出的搜索参数，调用后端API获取店铺飙升榜数据
const handleFilterSearch = async (params) => {
  try {
    const response = await request.get(API_PATH, { params })
    console.log('店铺飙升榜数据:', response.data)
  } catch (e) {
    console.error('获取店铺飙升榜失败:', e)
  }
}
</script>

<style scoped>
.ranking-page {
  padding: 20px;
  height: 100%;
  box-sizing: border-box;
}

.ranking-page .el-card {
  height: 100%;
  display: flex;
  flex-direction: column;
  border-radius: 8px;
}

.placeholder-content {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 400px;
}
</style>
