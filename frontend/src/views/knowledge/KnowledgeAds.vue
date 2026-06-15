<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">投放教程</h2>
      <p class="page-desc">TikTok Ads广告投放体系教程，提升ROI</p>
    </div>
    <div class="page-body">
      <div class="tutorial-grid">
        <div class="tutorial-card" v-for="t in tutorials" :key="t.title">
          <div class="tutorial-top">
            <div class="tutorial-icon-wrap" :style="{ background: t.iconBg }">
              <span class="tutorial-icon">{{ t.icon }}</span>
            </div>
            <span class="tutorial-type" :style="{ background: t.typeBg, color: t.typeColor }">{{ t.type }}</span>
          </div>
          <div class="tutorial-title">{{ t.title }}</div>
          <div class="tutorial-desc">{{ t.desc }}</div>
          <div class="tutorial-meta">
            <div class="tutor-info">
              <div class="tutor-avatar" :style="{ background: t.avatarBg }">{{ t.tutor[0] }}</div>
              <span class="tutor-name">{{ t.tutor }}</span>
            </div>
            <span class="tutorial-time">{{ t.time }}</span>
          </div>
          <div class="tutorial-footer">
            <div class="tutorial-progress">
              <div class="progress-bar">
                <div class="progress-fill" :style="{ width: t.progress + '%', background: t.progressColor }"></div>
              </div>
              <span class="progress-text">已学 {{ t.progress }}%</span>
            </div>
            <span class="tutorial-cta">继续学习 →</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tutorials = ref([
  { icon: '🎬', iconBg: 'linear-gradient(135deg, #fee2e2, #fecaca)', type: '视频课', typeBg: '#fef2f2', typeColor: '#ef4444', title: 'TikTok Ads基础投放实操', desc: '从账号搭建到首条广告上线', tutor: '李明', avatarBg: 'linear-gradient(135deg, #ef4444, #f87171)', time: '3h 20min', progress: 85, progressColor: 'linear-gradient(90deg, #f87171, #ef4444)' },
  { icon: '📊', iconBg: 'linear-gradient(135deg, #dbeafe, #bfdbfe)', type: '视频课', typeBg: '#eff6ff', typeColor: '#3b82f6', title: '广告数据分析与优化', desc: 'CTR/CVR/ROAS核心指标优化', tutor: '张伟', avatarBg: 'linear-gradient(135deg, #3b82f6, #60a5fa)', time: '2h 50min', progress: 62, progressColor: 'linear-gradient(90deg, #60a5fa, #3b82f6)' },
  { icon: '🎯', iconBg: 'linear-gradient(135deg, #fef3c7, #fde68a)', type: '图文课', typeBg: '#fffbeb', typeColor: '#f59e0b', title: '受众定向与Lookalike策略', desc: '精准触达目标用户群体', tutor: '王芳', avatarBg: 'linear-gradient(135deg, #f59e0b, #fbbf24)', time: '1h 40min', progress: 40, progressColor: 'linear-gradient(90deg, #fbbf24, #f59e0b)' },
  { icon: '💡', iconBg: 'linear-gradient(135deg, #d1fae5, #a7f3d0)', type: '视频课', typeBg: '#ecfdf5', typeColor: '#10b981', title: '创意素材制作指南', desc: '高转化广告素材的设计方法论', tutor: '陈静', avatarBg: 'linear-gradient(135deg, #10b981, #34d399)', time: '2h 10min', progress: 78, progressColor: 'linear-gradient(90deg, #34d399, #10b981)' },
  { icon: '⚡', iconBg: 'linear-gradient(135deg, #ede9fe, #ddd6fe)', type: '直播课', typeBg: '#f5f3ff', typeColor: '#7c4dff', title: '广告预算优化与扩量策略', desc: '从小预算到大投放的节奏控制', tutor: '赵强', avatarBg: 'linear-gradient(135deg, #7c4dff, #a78bfa)', time: '未开始', progress: 30, progressColor: 'linear-gradient(90deg, #a78bfa, #7c4dff)' },
  { icon: '🔧', iconBg: 'linear-gradient(135deg, #fce7f3, #fbcfe8)', type: '图文课', typeBg: '#fdf2f8', typeColor: '#ec4899', title: '广告账户问题排查手册', desc: '常见审核拒审原因与解决方案', tutor: '刘洋', avatarBg: 'linear-gradient(135deg, #ec4899, #f472b6)', time: '1h 20min', progress: 55, progressColor: 'linear-gradient(90deg, #f472b6, #ec4899)' },
  { icon: '🏆', iconBg: 'linear-gradient(135deg, #fef3c7, #fde68a)', type: '视频课', typeBg: '#fffbeb', typeColor: '#d97706', title: '日耗过万广告账户实操', desc: '高消耗账户的精细化运营案例', tutor: '孙悦', avatarBg: 'linear-gradient(135deg, #d97706, #f59e0b)', time: '4h 30min', progress: 92, progressColor: 'linear-gradient(90deg, #f59e0b, #d97706)' },
  { icon: '🌍', iconBg: 'linear-gradient(135deg, #d1fae5, #a7f3d0)', type: '视频课', typeBg: '#ecfdf5', typeColor: '#059669', title: '多地区广告投放策略', desc: '欧美/东南亚/中东差异化投放', tutor: '周磊', avatarBg: 'linear-gradient(135deg, #059669, #34d399)', time: '2h', progress: 45, progressColor: 'linear-gradient(90deg, #34d399, #059669)' },
  { icon: '📈', iconBg: 'linear-gradient(135deg, #ede9fe, #ddd6fe)', type: '直播课', typeBg: '#f5f3ff', typeColor: '#7c4dff', title: 'ROI从1到5的进阶之路', desc: '全链路优化实现投放盈利', tutor: '李明', avatarBg: 'linear-gradient(135deg, #ef4444, #f87171)', time: '即将开课', progress: 18, progressColor: 'linear-gradient(90deg, #c4b5fd, #7c4dff)' },
])
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { margin-bottom: 24px; }
.page-title { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0 0 6px 0; }
.page-desc { font-size: 14px; color: #8c8c8c; margin: 0; }
.page-body { background: #fff; border-radius: 12px; padding: 28px; box-shadow: 0 1px 6px rgba(0,0,0,0.04); }

.tutorial-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
.tutorial-card { padding: 22px; border: 1px solid #f0f0f0; border-radius: 16px; transition: all 0.3s; cursor: pointer; display: flex; flex-direction: column; }
.tutorial-card:hover { border-color: #c4b5fd; box-shadow: 0 8px 25px rgba(124,77,255,0.1); transform: translateY(-3px); }
.tutorial-top { display: flex; align-items: center; justify-content: space-between; margin-bottom: 14px; }
.tutorial-icon-wrap { width: 46px; height: 46px; border-radius: 14px; display: flex; align-items: center; justify-content: center; }
.tutorial-icon { font-size: 22px; }
.tutorial-type { font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 8px; }
.tutorial-title { font-size: 15px; font-weight: 600; color: #1a1a1a; margin-bottom: 6px; line-height: 1.4; }
.tutorial-desc { font-size: 13px; color: #8c8c8c; margin-bottom: 14px; line-height: 1.5; }
.tutorial-meta { display: flex; align-items: center; justify-content: space-between; margin-bottom: 14px; }
.tutor-info { display: flex; align-items: center; gap: 8px; }
.tutor-avatar { width: 30px; height: 30px; border-radius: 50%; color: #fff; font-size: 13px; font-weight: 600; display: flex; align-items: center; justify-content: center; }
.tutor-name { font-size: 12px; color: #666; font-weight: 500; }
.tutorial-time { font-size: 11px; color: #b0b0b0; }
.tutorial-footer { border-top: 1px solid #f5f5f5; padding-top: 12px; display: flex; align-items: center; justify-content: space-between; }
.tutorial-progress { display: flex; align-items: center; gap: 10px; flex: 1; }
.progress-bar { flex: 1; height: 6px; background: #f0f0f0; border-radius: 3px; overflow: hidden; max-width: 100px; }
.progress-fill { height: 100%; border-radius: 3px; transition: width 0.6s ease; }
.progress-text { font-size: 11px; color: #8c8c8c; white-space: nowrap; }
.tutorial-cta { font-size: 12px; font-weight: 600; color: #7c4dff; white-space: nowrap; }
</style>
