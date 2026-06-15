<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">外贸产品</h2>
      <p class="page-desc">跨境热销商品库，覆盖多平台多地区外贸产品数据</p>
    </div>
    <div class="page-body">
      <div class="stat-row">
        <div class="stat-item"><span class="stat-num">12,856</span><span class="stat-text">商品总数</span></div>
        <div class="stat-item"><span class="stat-num">2,341</span><span class="stat-text">本周新增</span></div>
        <div class="stat-item"><span class="stat-num">36</span><span class="stat-text">覆盖国家</span></div>
        <div class="stat-item"><span class="stat-num">87.3%</span><span class="stat-text">出单率</span></div>
      </div>
      <el-table :data="tableData" style="width: 100%">
        <el-table-column prop="name" label="商品名称" min-width="180" />
        <el-table-column prop="category" label="品类" width="120" />
        <el-table-column prop="source" label="来源平台" width="110" />
        <el-table-column prop="targetRegion" label="目标区域" width="140" />
        <el-table-column prop="price" label="均价(USD)" sortable width="110" />
        <el-table-column prop="monthlySales" label="月销量" sortable width="100" />
        <el-table-column prop="trend" label="趋势" width="80">
          <template #default="{ row }">
            <span :style="{ color: row.trend > 0 ? '#22c55e' : '#ef4444' }">
              {{ row.trend > 0 ? '↑' : '↓' }}{{ Math.abs(row.trend) }}%
            </span>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { name: '无线蓝牙耳机 Pro Max', category: '电子配件', source: '1688', targetRegion: '北美/东南亚', price: 12.5, monthlySales: 8500, trend: 23 },
  { name: '女士瑜伽运动套装', category: '运动服饰', source: '义乌购', targetRegion: '欧美', price: 18.8, monthlySales: 6200, trend: 15 },
  { name: '不锈钢保温杯 500ml', category: '家居用品', source: '1688', targetRegion: '全球', price: 6.2, monthlySales: 12000, trend: 8 },
  { name: 'LED化妆镜带灯', category: '美妆工具', source: '义乌购', targetRegion: '东南亚', price: 9.9, monthlySales: 4300, trend: 31 },
  { name: '宠物自动喂食器', category: '宠物用品', source: '1688', targetRegion: '欧美', price: 22.0, monthlySales: 2800, trend: 45 },
  { name: '车载手机支架通用款', category: '汽车用品', source: '1688', targetRegion: '全球', price: 4.5, monthlySales: 9800, trend: -3 },
  { name: '儿童益智积木100粒', category: '玩具', source: '义乌购', targetRegion: '欧美/中东', price: 15.6, monthlySales: 3500, trend: 12 },
  { name: '户外折叠露营椅', category: '户外用品', source: '1688', targetRegion: '北美', price: 28.0, monthlySales: 1900, trend: 52 },
])
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { margin-bottom: 24px; }
.page-title { font-size: 20px; font-weight: 700; color: #1a1a1a; margin: 0 0 8px 0; }
.page-desc { font-size: 14px; color: #8c8c8c; margin: 0; }
.page-body { background: #fff; border-radius: 8px; padding: 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.04); }
.stat-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; }
.stat-item { background: linear-gradient(135deg, #f5f0ff, #faf8ff); border: 1px solid #ece6ff; border-radius: 12px; padding: 20px; text-align: center; }
.stat-num { display: block; font-size: 28px; font-weight: 700; background: linear-gradient(135deg, #7c4dff, #9b7ff7); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.stat-text { font-size: 13px; color: #8c8c8c; margin-top: 4px; display: block; }
</style>
