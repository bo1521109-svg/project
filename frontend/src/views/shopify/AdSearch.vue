<template>
  <div class="ad-search-page">
    <ShopifyAdFilter @search="handleFilterSearch" />

    <div class="ad-content">
      <el-empty description="请通过上方筛选条件搜索广告素材">
        <template v-if="hasSearched">
          <p style="color:#999;font-size:13px;margin-top:8px">
            搜索关键词：{{ lastParams.keyword || '无' }} |
            国家/地区：{{ lastParams.country }} |
            广告类型：{{ lastParams.adType }} |
            平台：{{ lastParams.platform }}
          </p>
        </template>
      </el-empty>
    </div>
  </div>
</template>

<script setup>
/*
 * Shopify广告搜索页面
 * 使用ShopifyAdFilter筛选组件，预留广告列表展示区域
 */
import { ref } from 'vue'
import ShopifyAdFilter from '@/components/Shopify/ShopifyAdFilter.vue'

const hasSearched = ref(false)
const lastParams = ref({})

// 预留：后续联调时在此调用真实API获取广告数据
const handleFilterSearch = (params) => {
  hasSearched.value = true
  lastParams.value = params
  // TODO: 调用后端API获取广告素材数据
  console.log('接收广告筛选参数，准备请求广告数据:', params)
}
</script>

<style scoped>
.ad-search-page {
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

@media (max-width: 1024px) {
  .ad-search-page {
    height: auto;
    min-height: calc(100vh - 120px);
  }
}
</style>
