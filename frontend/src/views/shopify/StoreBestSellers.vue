<template>
  <div class="ranking-page">
    <StoreFilter @search="handleFilterSearch" />

    <el-card>
      <div class="placeholder-content">
        <el-empty description="功能开发中，敬请期待" :image-size="200" />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import StoreFilter from '../../components/Shopify/StoreFilter.vue'

const handleFilterSearch = (params) => {
  console.log('店铺爆卖榜筛选条件：', params)
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
