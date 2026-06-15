<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">国际物流</h2>
      <p class="page-desc">跨境物流服务商对比，涵盖海运、空运、专线等多种运输方式</p>
    </div>
    <div class="page-body">
      <el-table :data="tableData" style="width: 100%">
        <el-table-column prop="name" label="服务商" min-width="160" />
        <el-table-column prop="type" label="运输方式" width="100" />
        <el-table-column prop="routes" label="主要线路" min-width="180" />
        <el-table-column prop="time" label="时效(天)" sortable width="110" />
        <el-table-column prop="price" label="参考运价(USD/kg)" sortable width="150" />
        <el-table-column prop="rating" label="评分" width="80">
          <template #default="{ row }"><span style="color: #f59e0b;">★ {{ row.rating }}</span></template>
        </el-table-column>
        <el-table-column prop="volume" label="月处理量(吨)" sortable width="130" />
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { name: '纵腾国际物流', type: '空运', routes: '中国→美国/英国/德国', time: '5-8', price: 5.8, rating: 4.8, volume: 3200 },
  { name: '云途物流', type: '专线', routes: '中国→东南亚/欧洲', time: '7-12', price: 3.2, rating: 4.7, volume: 4500 },
  { name: '燕文物流', type: '海运', routes: '中国→全球各大港口', time: '25-35', price: 1.5, rating: 4.5, volume: 8200 },
  { name: '递四方', type: '空运+专线', routes: '中国→北美/欧洲/澳洲', time: '5-15', price: 4.6, rating: 4.6, volume: 5100 },
  { name: '万邑通', type: '海运+仓储', routes: '中国→美国/欧洲/日本', time: '20-30', price: 2.0, rating: 4.4, volume: 6800 },
  { name: '顺丰国际', type: '空运', routes: '中国→全球', time: '3-7', price: 8.5, rating: 4.9, volume: 1800 },
  { name: 'DHL跨境电商', type: '快递', routes: '中国→全球', time: '3-5', price: 12.0, rating: 4.8, volume: 1200 },
  { name: '中邮海外仓', type: '海运+仓储', routes: '中国→美国/英国/澳洲', time: '25-40', price: 1.8, rating: 4.3, volume: 9500 },
])
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { margin-bottom: 24px; }
.page-title { font-size: 20px; font-weight: 700; color: #1a1a1a; margin: 0 0 8px 0; }
.page-desc { font-size: 14px; color: #8c8c8c; margin: 0; }
.page-body { background: #fff; border-radius: 8px; padding: 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.04); }
</style>
