<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">案例分析</h2>
      <p class="page-desc">TikTok电商成功案例拆解，借鉴实战经验</p>
    </div>
    <div class="page-body">
      <div class="case-grid">
        <div class="case-card" v-for="c in cases" :key="c.title">
          <div class="case-banner" :style="{ background: c.bg }">
            <div class="banner-overlay"></div>
            <span class="case-emoji">{{ c.emoji }}</span>
            <span class="case-badge">{{ c.category }}</span>
          </div>
          <div class="case-content">
            <div class="case-title">{{ c.title }}</div>
            <div class="case-stats">
              <div class="case-stat">
                <span class="cs-icon">📦</span>
                <span class="cs-val">{{ c.sales }}</span>
                <span class="cs-lbl">月销量</span>
              </div>
              <div class="case-stat">
                <span class="cs-icon">💰</span>
                <span class="cs-val">{{ c.revenue }}</span>
                <span class="cs-lbl">月GMV</span>
              </div>
              <div class="case-stat">
                <span class="cs-icon">📈</span>
                <span class="cs-val">{{ c.roi }}</span>
                <span class="cs-lbl">ROI</span>
              </div>
            </div>
            <div class="case-tags">
              <span class="case-tag" v-for="tag in c.tags" :key="tag">{{ tag }}</span>
            </div>
            <div class="case-desc">{{ c.desc }}</div>
            <div class="case-footer">
              <div class="case-author">
                <span class="author-dot"></span>
                <span>{{ c.author }}</span>
              </div>
              <span class="case-read">查看详情 →</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const cases = ref([
  { emoji: '💄', bg: 'linear-gradient(135deg, #fce4ec, #f8bbd0)', category: '美妆', title: '国货美妆品牌东南亚突围战', sales: '8.2万', revenue: '$52万', roi: '4.8x', tags: ['美妆', '东南亚', '品牌出海'], desc: '通过达人矩阵+广告投放组合拳，3个月实现月销破百万', author: '运营研究社' },
  { emoji: '👗', bg: 'linear-gradient(135deg, #e8f5e9, #c8e6c9)', category: '服装', title: '女装快反供应链案例', sales: '12.5万', revenue: '$85万', roi: '3.5x', tags: ['服装', '供应链', '快反'], desc: '7天上新周期+达人种草模式打造爆款女装店铺', author: '供应链内参' },
  { emoji: '🔌', bg: 'linear-gradient(135deg, #e3f2fd, #bbdefb)', category: '3C', title: '3C配件低成本起量打法', sales: '5.8万', revenue: '$28万', roi: '6.2x', tags: ['3C数码', '低客单', '起量'], desc: '从0到日销2000单，靠自然流+小额广告撬动增长', author: 'TK电商观察' },
  { emoji: '🏠', bg: 'linear-gradient(135deg, #fff3e0, #ffe0b2)', category: '家居', title: '家居用品内容种草矩阵', sales: '3.2万', revenue: '$41万', roi: '2.8x', tags: ['家居', '内容营销', '种草'], desc: 'UGC内容矩阵+场景化视频实现高转化率', author: '内容工场' },
  { emoji: '🍵', bg: 'linear-gradient(135deg, #f3e5f5, #e1bee7)', category: '食品', title: '食品饮料跨境爆品打造', sales: '6.1万', revenue: '$18万', roi: '4.1x', tags: ['食品', '爆品', '跨境'], desc: '差异化口味定位+限时饥饿营销策略引爆销量', author: '品牌出海志' },
  { emoji: '🎮', bg: 'linear-gradient(135deg, #e0f7fa, #b2ebf2)', category: '玩具', title: '玩具品类季节性运营', sales: '9.3万', revenue: '$35万', roi: '5.5x', tags: ['玩具', '季节性', '礼品'], desc: '节日营销前置布局，Q4季度月销翻3倍', author: '运营研究社' },
])
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { margin-bottom: 24px; }
.page-title { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0 0 6px 0; }
.page-desc { font-size: 14px; color: #8c8c8c; margin: 0; }
.page-body { background: #fff; border-radius: 12px; padding: 28px; box-shadow: 0 1px 6px rgba(0,0,0,0.04); }

.case-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 24px; }
.case-card { border: 1px solid #f0f0f0; border-radius: 16px; overflow: hidden; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); cursor: pointer; }
.case-card:hover { border-color: #c4b5fd; box-shadow: 0 8px 30px rgba(124,77,255,0.1); transform: translateY(-4px); }
.case-banner { height: 120px; display: flex; align-items: center; justify-content: center; position: relative; overflow: hidden; }
.banner-overlay { position: absolute; inset: 0; background: rgba(255,255,255,0.15); }
.case-emoji { font-size: 52px; position: relative; z-index: 1; }
.case-badge { position: absolute; top: 14px; right: 14px; font-size: 12px; font-weight: 600; color: #fff; background: rgba(0,0,0,0.2); backdrop-filter: blur(6px); padding: 4px 12px; border-radius: 12px; z-index: 1; }

.case-content { padding: 20px; }
.case-title { font-size: 17px; font-weight: 700; color: #1a1a1a; margin-bottom: 14px; line-height: 1.4; }

.case-stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-bottom: 12px; }
.case-stat { text-align: center; padding: 12px 8px; background: #fafafa; border-radius: 12px; transition: background 0.2s; }
.case-stat:hover { background: #f5f0ff; }
.cs-icon { display: block; font-size: 16px; margin-bottom: 4px; }
.cs-val { display: block; font-size: 17px; font-weight: 700; background: linear-gradient(135deg, #7c4dff, #9b7ff7); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.cs-lbl { font-size: 11px; color: #8c8c8c; }

.case-tags { display: flex; gap: 6px; margin-bottom: 10px; }
.case-tag { font-size: 11px; color: #7c4dff; background: #f5f0ff; padding: 3px 9px; border-radius: 6px; }
.case-desc { font-size: 13px; color: #666; line-height: 1.6; margin-bottom: 14px; }

.case-footer { display: flex; align-items: center; justify-content: space-between; padding-top: 12px; border-top: 1px solid #f5f5f5; }
.case-author { display: flex; align-items: center; gap: 6px; font-size: 12px; color: #8c8c8c; }
.author-dot { width: 6px; height: 6px; border-radius: 50%; background: #7c4dff; }
.case-read { font-size: 12px; font-weight: 600; color: #7c4dff; }
</style>
