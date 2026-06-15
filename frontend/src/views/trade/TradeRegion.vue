<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">外贸区域</h2>
      <p class="page-desc">各地区外贸市场概况，包含进口政策、热门品类与物流时效参考</p>
    </div>
    <div class="page-body">
      <div class="region-grid">
        <div class="region-card" v-for="r in regions" :key="r.name">
          <div class="region-flag">{{ r.flag }}</div>
          <div class="region-name">{{ r.name }}</div>
          <div class="region-detail">
            <div class="detail-row"><span class="lbl">热门品类</span><span class="val">{{ r.category }}</span></div>
            <div class="detail-row"><span class="lbl">进口关税</span><span class="val">{{ r.tariff }}</span></div>
            <div class="detail-row"><span class="lbl">物流时效</span><span class="val">{{ r.logistics }}</span></div>
            <div class="detail-row"><span class="lbl">市场热度</span>
              <span class="val">
                <el-progress :percentage="r.heat" :stroke-width="6" :color="'#7c4dff'" />
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const regions = ref([
  { flag: '🇺🇸', name: '北美市场', category: '电子配件 / 家居用品', tariff: '0%-25%', logistics: '7-15天', heat: 95 },
  { flag: '🇪🇺', name: '欧洲市场', category: '服饰鞋包 / 家居家具', tariff: '3%-12%', logistics: '10-20天', heat: 82 },
  { flag: '🌏', name: '东南亚市场', category: '美妆个护 / 食品饮料', tariff: '0%-5%', logistics: '3-7天', heat: 88 },
  { flag: '🇧🇷', name: '拉美市场', category: '电子配件 / 运动户外', tariff: '0%-35%', logistics: '15-30天', heat: 65 },
  { flag: '🌍', name: '中亚市场', category: '轻工业品 / 日用百货', tariff: '5%-15%', logistics: '10-20天', heat: 58 },
  { flag: '🌍', name: '中东市场', category: '电子数码 / 奢侈品', tariff: '0%-5%', logistics: '10-18天', heat: 58 },
])
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { margin-bottom: 24px; }
.page-title { font-size: 20px; font-weight: 700; color: #1a1a1a; margin: 0 0 8px 0; }
.page-desc { font-size: 14px; color: #8c8c8c; margin: 0; }
.page-body { background: #fff; border-radius: 8px; padding: 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.04); }
.region-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; }
.region-card { padding: 20px; border: 1px solid #f0f0f0; border-radius: 12px; transition: all 0.2s; }
.region-card:hover { border-color: #7c4dff; box-shadow: 0 2px 12px rgba(124,77,255,0.1); }
.region-flag { font-size: 36px; margin-bottom: 8px; }
.region-name { font-size: 16px; font-weight: 600; color: #1a1a1a; margin-bottom: 12px; }
.detail-row { display: flex; justify-content: space-between; align-items: center; padding: 6px 0; font-size: 13px; }
.lbl { color: #8c8c8c; }
.val { color: #262626; font-weight: 500; max-width: 140px; }
</style>
