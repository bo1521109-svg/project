<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">视频卖点呈现</h2>
      <p class="page-desc">产品在视频中的卖点展示方式分析</p>
    </div>

    <div class="timeline">
      <div class="tl-item" v-for="(s, i) in sellpoints" :key="i" :class="{ 'tl-right': i % 2 === 1 }">
        <div class="tl-card" :style="{ borderTop: '3px solid ' + s.accent }">
          <div class="tl-card-top">
            <div class="tl-product">
              <span class="tl-emoji">{{ s.emoji }}</span>
              <span class="tl-product-name">{{ s.product }}</span>
            </div>
            <div class="tl-score" :style="{ background: s.accent }">{{ s.score }}<span class="tl-unit">分</span></div>
          </div>
          <div class="tl-title">{{ s.title }}</div>
          <div class="tl-flow">
            <div class="tl-step" v-for="(p, pi) in s.points" :key="pi">
              <div class="step-dot" :style="{ background: s.accent }">{{ pi + 1 }}</div>
              <div class="step-line" v-if="pi < s.points.length - 1" :style="{ background: s.accent }"></div>
              <div class="step-text">{{ p }}</div>
            </div>
          </div>
          <div class="tl-footer">
            <span class="tl-range" :style="{ background: s.accent + '20', color: s.accent }">
              ⏱ 卖点爆发 {{ s.timing }}
            </span>
            <span class="tl-tag" v-for="t in s.tags" :key="t">{{ t }}</span>
          </div>
        </div>
        <div class="tl-node" :style="{ background: s.accent }">
          <span>{{ i + 1 }}</span>
        </div>
      </div>
      <div class="tl-line"></div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const sellpoints = ref([
  { emoji: '💄', accent: '#ec4899', score: 92, product: '哑光口红', title: '色泽饱满+不沾杯实测', points: ['开屏即展示上唇效果', '纸巾不沾杯对比演示', '8小时持妆延时记录'], timing: '0-10s', tags: ['对比演示', '持久实测'] },
  { emoji: '👗', accent: '#10b981', score: 88, product: '显瘦连衣裙', title: '三围对比+多场景穿搭', points: ['穿前穿后腰围视觉差', '办公室/约会/度假三场景', '面料垂感慢镜头'], timing: '5-22s', tags: ['场景穿搭', '视觉效果'] },
  { emoji: '🔌', accent: '#3b82f6', score: 86, product: '降噪耳机', title: '噪音对比+续航实测', points: ['地铁噪音分贝测试', '开机瞬间静音效果', '一周使用无需充电'], timing: '2-15s', tags: ['数据实测', '场景化'] },
  { emoji: '🍳', accent: '#f59e0b', score: 90, product: '空气炸锅', title: '一锅出菜+无油对比', points: ['传统油炸vs空气炸成品对比', '新手也能复刻的简单食谱', '清洗方便度真实演示'], timing: '8-28s', tags: ['对比测评', '实用教程'] },
  { emoji: '🧴', accent: '#14b8a6', score: 84, product: '防脱洗发水', title: '28天发量变化追踪', points: ['使用前发缝宽度记录', '每周同角度真实拍摄', '掉发数量递减数据'], timing: '3-12s', tags: ['长期追踪', '真实记录'] },
  { emoji: '🎒', accent: '#7c4dff', score: 87, product: '通勤双肩包', title: '容量测试+防水挑战', points: ['装满物品容量极限展示', '泼水防水效果实拍', '分层收纳设计讲解'], timing: '5-18s', tags: ['极限测试', '功能展示'] },
])
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { margin-bottom: 28px; }
.page-title { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0 0 6px 0; }
.page-desc { font-size: 14px; color: #8c8c8c; margin: 0; }

.timeline { position: relative; padding: 0 20px; }
.tl-line { position: absolute; left: 50%; top: 0; bottom: 0; width: 2px; background: linear-gradient(180deg, #7c4dff, #ddd6fe); transform: translateX(-50%); }

.tl-item { display: flex; align-items: flex-start; margin-bottom: 32px; position: relative; }
.tl-item:not(.tl-right) { justify-content: flex-start; padding-right: 50%; }
.tl-item.tl-right { justify-content: flex-end; padding-left: 50%; }

.tl-card { flex: 1; max-width: 420px; background: #fff; border-radius: 16px; padding: 20px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); transition: all 0.3s; cursor: pointer; }
.tl-card:hover { box-shadow: 0 6px 24px rgba(0,0,0,0.08); transform: translateY(-2px); }

.tl-card-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
.tl-product { display: flex; align-items: center; gap: 8px; }
.tl-emoji { font-size: 28px; }
.tl-product-name { font-size: 14px; font-weight: 600; color: #1a1a1a; }
.tl-score { color: #fff; font-size: 22px; font-weight: 800; padding: 4px 12px; border-radius: 12px; line-height: 1; }
.tl-unit { font-size: 12px; font-weight: 500; }
.tl-title { font-size: 16px; font-weight: 700; color: #1a1a1a; margin-bottom: 14px; }

.tl-flow { display: flex; align-items: flex-start; gap: 0; margin-bottom: 14px; }
.tl-step { display: flex; flex-direction: column; align-items: center; flex: 1; position: relative; }
.step-dot { width: 28px; height: 28px; border-radius: 50%; color: #fff; font-size: 12px; font-weight: 700; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.step-line { width: 100%; height: 2px; flex-shrink: 0; margin-top: 13px; position: absolute; left: 50%; top: 14px; }
.step-text { font-size: 11px; color: #555; text-align: center; margin-top: 8px; line-height: 1.5; max-width: 100px; }

.tl-footer { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.tl-range { font-size: 12px; font-weight: 600; padding: 3px 10px; border-radius: 8px; }
.tl-tag { font-size: 11px; color: #8c8c8c; background: #f5f5f5; padding: 3px 8px; border-radius: 6px; }

.tl-node { width: 36px; height: 36px; border-radius: 50%; color: #fff; font-size: 14px; font-weight: 700; display: flex; align-items: center; justify-content: center; position: absolute; left: 50%; top: 16px; transform: translateX(-50%); z-index: 2; box-shadow: 0 0 0 4px #f0f2f5; }
</style>
