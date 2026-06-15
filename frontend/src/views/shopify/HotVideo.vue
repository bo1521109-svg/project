<template>
  <div class="hot-video-page">
    <ShopifyHotVideoFilter @filter-change="handleFilterChange" />

    <div class="video-content">
      <el-empty description="请通过上方筛选条件搜索热门视频">
        <template v-if="hasFilter">
          <p style="color:#999;font-size:13px;margin-top:8px">
            当前筛选：国家/地区={{ selectedCountry }} | 达人分类={{ selectedCategory }}
          </p>
        </template>
      </el-empty>
    </div>
  </div>
</template>

<script setup>
/*
 * Shopify热门视频页面
 * 使用ShopifyHotVideoFilter筛选组件，预留视频列表展示区域
 */
import { ref } from 'vue'
import ShopifyHotVideoFilter from '@/components/Shopify/ShopifyHotVideoFilter.vue'

const hasFilter = ref(false)
const selectedCountry = ref('全部')
const selectedCategory = ref('全部')

// 预留：后续联调时在此调用真实API获取视频列表
const handleFilterChange = (params) => {
  hasFilter.value = true
  selectedCountry.value = params.country || '全部'
  selectedCategory.value = params.category || '全部'
  // TODO: 调用后端API获取视频列表数据
  console.log('接收筛选参数，准备请求视频数据:', params)
}
</script>

<style scoped>
.hot-video-page {
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

@media (max-width: 1024px) {
  .hot-video-page {
    height: auto;
    min-height: calc(100vh - 120px);
  }
}
</style>
