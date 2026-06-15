<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">选品指南</h2>
      <p class="page-desc">TikTok电商选品方法论，挖掘跨境蓝海品类</p>
    </div>
    <div class="page-body">
      <div class="filter-bar">
        <span class="filter-label">分类：</span>
        <span v-for="f in filters" :key="f" class="filter-tag" :class="{ active: activeFilter === f }" @click="activeFilter = f">{{ f }}</span>
      </div>
      <div class="guide-grid">
        <div class="guide-card" v-for="(g, i) in guides" :key="g.title">
          <div class="guide-rank" v-if="i < 3" :class="'rank-' + (i + 1)">{{ i + 1 }}</div>
          <div class="guide-icon-wrap" :style="{ background: g.iconBg }">
            <span class="guide-icon">{{ g.icon }}</span>
          </div>
          <div class="guide-body">
            <div class="guide-title">{{ g.title }}</div>
            <div class="guide-desc">{{ g.desc }}</div>
            <div class="guide-tags">
              <span class="guide-tag" v-for="t in g.tags" :key="t">{{ t }}</span>
            </div>
          </div>
          <div class="guide-side">
            <div class="guide-reads">{{ g.reads >= 10000 ? (g.reads / 10000).toFixed(1) + 'w' : g.reads }}</div>
            <div class="guide-reads-label">阅读</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const activeFilter = ref('全部')
const filters = ref(['全部', '选品思维', '市场分析', '供应链', '趋势', '案例拆解', 'AI工具'])

const guides = ref([
  { icon: '🔬', iconBg: 'linear-gradient(135deg, #e0e7ff, #c7d2fe)', title: 'TikTok爆品筛选方法论', desc: '从趋势洞察到数据验证的完整选品流程', tags: ['选品思维', '数据驱动'], reads: 12500 },
  { icon: '🎯', iconBg: 'linear-gradient(135deg, #fce4ec, #f8bbd0)', title: '东南亚市场需求分析', desc: '印尼、越南、泰国热门品类全景解读', tags: ['市场分析', '东南亚'], reads: 9800 },
  { icon: '💡', iconBg: 'linear-gradient(135deg, #fff3e0, #ffe0b2)', title: '小众品类突围策略', desc: '避开红海竞争，找到高利润蓝海品类', tags: ['蓝海策略', '利润优化'], reads: 7200 },
  { icon: '📦', iconBg: 'linear-gradient(135deg, #e8f5e9, #c8e6c9)', title: '供应链选品与成本控制', desc: '从1688到海外仓的全链路成本优化方案', tags: ['供应链', '成本'], reads: 8600 },
  { icon: '🔥', iconBg: 'linear-gradient(135deg, #fce4ec, #ffcdd2)', title: '季节性商品运营节奏', desc: '节日、季节、大促节点的选品时机把握', tags: ['季节性', '大促'], reads: 5400 },
  { icon: '🏆', iconBg: 'linear-gradient(135deg, #fff8e1, #ffecb3)', title: '爆品案例拆解合集', desc: '月销过万单商品的选品逻辑复盘', tags: ['案例拆解', '爆品'], reads: 15300 },
  { icon: '🤖', iconBg: 'linear-gradient(135deg, #e3f2fd, #bbdefb)', title: 'AI辅助选品工具指南', desc: '利用AI工具提升选品效率和准确度', tags: ['AI工具', '效率'], reads: 6100 },
  { icon: '🌊', iconBg: 'linear-gradient(135deg, #e0f7fa, #b2ebf2)', title: '跨境品类趋势周报', desc: '每周更新各大站点品类增长趋势', tags: ['趋势', '周报'], reads: 11200 },
  { icon: '💎', iconBg: 'linear-gradient(135deg, #f3e5f5, #e1bee7)', title: '高客单价产品运营策略', desc: '从选品到转化的高客单产品打法', tags: ['高客单', '转化'], reads: 4800 },
])
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { margin-bottom: 24px; }
.page-title { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0 0 6px 0; }
.page-desc { font-size: 14px; color: #8c8c8c; margin: 0; }
.page-body { background: #fff; border-radius: 12px; padding: 28px; box-shadow: 0 1px 6px rgba(0,0,0,0.04); }

.filter-bar { display: flex; align-items: center; gap: 8px; margin-bottom: 24px; flex-wrap: wrap; }
.filter-label { font-size: 14px; font-weight: 600; color: #262626; }
.filter-tag { font-size: 13px; color: #666; padding: 5px 14px; border-radius: 16px; cursor: pointer; transition: all 0.2s; background: #f5f5f5; }
.filter-tag:hover { background: #ece6ff; color: #7c4dff; }
.filter-tag.active { background: linear-gradient(135deg, #7c4dff, #9b7ff7); color: #fff; }

.guide-grid { display: flex; flex-direction: column; gap: 12px; }
.guide-card { display: flex; align-items: center; gap: 16px; padding: 18px 20px; border: 1px solid #f0f0f0; border-radius: 14px; transition: all 0.25s; cursor: pointer; position: relative; }
.guide-card:hover { border-color: #c4b5fd; box-shadow: 0 3px 14px rgba(124,77,255,0.08); transform: translateX(4px); }
.guide-rank { width: 28px; height: 28px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 700; color: #fff; flex-shrink: 0; }
.rank-1 { background: linear-gradient(135deg, #f59e0b, #fbbf24); }
.rank-2 { background: linear-gradient(135deg, #94a3b8, #cbd5e1); }
.rank-3 { background: linear-gradient(135deg, #d97706, #f59e0b); }
.guide-icon-wrap { width: 48px; height: 48px; border-radius: 14px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.guide-icon { font-size: 24px; }
.guide-body { flex: 1; min-width: 0; }
.guide-title { font-size: 15px; font-weight: 600; color: #1a1a1a; margin-bottom: 4px; }
.guide-desc { font-size: 13px; color: #8c8c8c; margin-bottom: 6px; }
.guide-tags { display: flex; gap: 6px; }
.guide-tag { font-size: 11px; color: #7c4dff; background: #f5f0ff; padding: 2px 8px; border-radius: 4px; }
.guide-side { text-align: center; flex-shrink: 0; min-width: 50px; }
.guide-reads { font-size: 16px; font-weight: 700; color: #7c4dff; }
.guide-reads-label { font-size: 11px; color: #8c8c8c; }
</style>
