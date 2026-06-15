<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">达人对接</h2>
      <p class="page-desc">海外红人营销资源对接，覆盖TikTok、Instagram、YouTube等主流平台</p>
    </div>
    <div class="page-body">
      <div class="stat-row">
        <div class="stat-item"><span class="stat-num">8,500+</span><span class="stat-text">合作达人</span></div>
        <div class="stat-item"><span class="stat-num">120+</span><span class="stat-text">MCN机构</span></div>
        <div class="stat-item"><span class="stat-num">35</span><span class="stat-text">覆盖国家</span></div>
        <div class="stat-item"><span class="stat-num">4.8</span><span class="stat-text">平均评分</span></div>
      </div>
      <el-table :data="tableData" style="width: 100%">
        <el-table-column prop="name" label="机构/达人" min-width="160" />
        <el-table-column prop="platform" label="平台" width="100" />
        <el-table-column prop="region" label="区域" width="120" />
        <el-table-column prop="followers" label="粉丝量" sortable width="120" />
        <el-table-column prop="category" label="擅长类目" min-width="160" />
        <el-table-column prop="price" label="合作报价(USD)" sortable width="150" />
        <el-table-column prop="cases" label="成功案例" width="100" />
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { name: 'StarLink MCN', platform: 'TikTok', region: '美国', followers: '500万+', category: '美妆/时尚/生活方式', price: '$3000-8000', cases: 230 },
  { name: 'ViralBoost Agency', platform: 'TikTok/IG', region: '英国/欧洲', followers: '300万+', category: '家居/运动/户外', price: '$2000-5000', cases: 180 },
  { name: '东南亚达人联盟', platform: 'TikTok', region: '东南亚', followers: '800万+', category: '美妆/食品/电子', price: '$500-2000', cases: 350 },
  { name: '@BeautyQueen_Lisa', platform: 'TikTok', region: '美国', followers: '120万', category: '美妆护肤', price: '$1500-3000', cases: 85 },
  { name: '@TechReviewMike', platform: 'YouTube', region: '全球', followers: '80万', category: '3C数码', price: '$2000-4000', cases: 120 },
  { name: '巴西达人矩阵', platform: 'TikTok/IG', region: '巴西', followers: '200万+', category: '时尚/运动/美妆', price: '$800-1500', cases: 95 },
  { name: '@HomeDecor_Emma', platform: 'Instagram', region: '欧洲', followers: '65万', category: '家居装饰', price: '$1200-2500', cases: 60 },
  { name: '日本达人事务所', platform: 'TikTok/YouTube', region: '日本', followers: '400万+', category: '美妆/食品/母婴', price: '$1500-3500', cases: 200 },
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
