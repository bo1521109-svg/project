<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">运营课程</h2>
      <p class="page-desc">TikTok电商运营体系课程，从入门到精通</p>
    </div>
    <div class="page-body">
      <div class="stat-row">
        <div class="stat-item" v-for="s in stats" :key="s.label">
          <div class="stat-icon-wrap"><span class="stat-icon">{{ s.icon }}</span></div>
          <span class="stat-num">{{ s.num }}</span>
          <span class="stat-text">{{ s.label }}</span>
        </div>
      </div>
      <div class="course-grid">
        <div class="course-card" v-for="c in courses" :key="c.title">
          <div class="course-cover" :style="{ background: c.gradient }">
            <span class="cover-badge" v-if="c.hot">🔥 热门</span>
            <span class="cover-icon">{{ c.icon }}</span>
            <div class="cover-level">{{ c.level }}</div>
          </div>
          <div class="course-info">
            <div class="course-title">{{ c.title }}</div>
            <div class="course-meta">
              <span class="meta-item">📚 {{ c.lessons }}节</span>
              <span class="meta-item">👤 {{ c.students }}人</span>
            </div>
            <div class="course-footer">
              <span class="course-price">{{ c.price }}</span>
              <div class="course-rating">
                <span class="stars">{{ '★'.repeat(Math.floor(c.rating)) }}</span>
                <span class="rating-num">{{ c.rating }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const stats = ref([
  { icon: '📚', num: '128', label: '课程总数' },
  { icon: '👥', num: '8,620', label: '付费学员' },
  { icon: '⭐', num: '4.8', label: '平均评分' },
  { icon: '👍', num: '96%', label: '好评率' }
])

const courses = ref([
  { icon: '📱', gradient: 'linear-gradient(135deg, #667eea, #764ba2)', title: 'TikTok Shop从0到1开店指南', level: '入门', lessons: 24, students: '3,200', price: '¥199', rating: 4.9, hot: true },
  { icon: '🎯', gradient: 'linear-gradient(135deg, #f093fb, #f5576c)', title: 'TikTok算法推荐机制深度解析', level: '进阶', lessons: 18, students: '2,100', price: '¥299', rating: 4.8 },
  { icon: '💰', gradient: 'linear-gradient(135deg, #4facfe, #00f2fe)', title: 'TikTok广告投放ROI优化实战', level: '高级', lessons: 32, students: '1,800', price: '¥499', rating: 4.7, hot: true },
  { icon: '📸', gradient: 'linear-gradient(135deg, #43e97b, #38f9d7)', title: '爆款短视频拍摄与剪辑全流程', level: '入门', lessons: 16, students: '4,500', price: '¥99', rating: 4.9 },
  { icon: '🏪', gradient: 'linear-gradient(135deg, #fa709a, #fee140)', title: 'TK小店精细化运营方法论', level: '进阶', lessons: 28, students: '2,600', price: '¥349', rating: 4.8 },
  { icon: '📊', gradient: 'linear-gradient(135deg, #a18cd1, #fbc2eb)', title: '直播带货话术与场控技巧', level: '进阶', lessons: 20, students: '1,900', price: '¥249', rating: 4.6 },
  { icon: '🌍', gradient: 'linear-gradient(135deg, #ff9a9e, #fecfef)', title: '跨境多站点运营策略', level: '高级', lessons: 22, students: '1,200', price: '¥399', rating: 4.7 },
  { icon: '🔍', gradient: 'linear-gradient(135deg, #a1c4fd, #c2e9fb)', title: '达人合作与红人营销全攻略', level: '进阶', lessons: 15, students: '2,800', price: '¥199', rating: 4.8 },
  { icon: '📈', gradient: 'linear-gradient(135deg, #d4a5a5, #7c4dff)', title: 'TikTok数据分析与选品决策', level: '高级', lessons: 26, students: '1,500', price: '¥449', rating: 4.9, hot: true },
])
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { margin-bottom: 24px; }
.page-title { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0 0 6px 0; }
.page-desc { font-size: 14px; color: #8c8c8c; margin: 0; }
.page-body { background: #fff; border-radius: 12px; padding: 28px; box-shadow: 0 1px 6px rgba(0,0,0,0.04); }
.stat-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 28px; }
.stat-item { background: linear-gradient(135deg, #faf8ff, #f5f0ff); border: 1px solid #ece6ff; border-radius: 14px; padding: 22px; text-align: center; transition: transform 0.2s; }
.stat-item:hover { transform: translateY(-2px); }
.stat-icon-wrap { margin-bottom: 8px; }
.stat-icon { font-size: 24px; }
.stat-num { display: block; font-size: 30px; font-weight: 800; background: linear-gradient(135deg, #7c4dff, #9b7ff7); -webkit-background-clip: text; -webkit-text-fill-color: transparent; letter-spacing: -1px; }
.stat-text { font-size: 13px; color: #8c8c8c; margin-top: 2px; display: block; }

.course-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
.course-card { border: 1px solid #f0f0f0; border-radius: 14px; overflow: hidden; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); cursor: pointer; background: #fff; }
.course-card:hover { border-color: #c4b5fd; box-shadow: 0 8px 25px rgba(124,77,255,0.12); transform: translateY(-4px); }
.course-cover { height: 140px; display: flex; flex-direction: column; align-items: center; justify-content: center; position: relative; overflow: hidden; }
.course-cover::after { content: ''; position: absolute; bottom: 0; left: 0; right: 0; height: 40px; background: linear-gradient(transparent, rgba(0,0,0,0.1)); }
.cover-badge { position: absolute; top: 10px; left: 12px; font-size: 11px; color: #fff; background: rgba(255,255,255,0.25); backdrop-filter: blur(4px); padding: 3px 10px; border-radius: 10px; z-index: 1; }
.cover-icon { font-size: 42px; position: relative; z-index: 1; }
.cover-level { position: absolute; bottom: 10px; right: 12px; font-size: 11px; color: #fff; background: rgba(255,255,255,0.25); backdrop-filter: blur(4px); padding: 2px 9px; border-radius: 8px; z-index: 1; }
.course-info { padding: 16px; }
.course-title { font-size: 14px; font-weight: 600; color: #1a1a1a; margin-bottom: 8px; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.course-meta { display: flex; gap: 16px; margin-bottom: 12px; }
.meta-item { font-size: 12px; color: #8c8c8c; }
.course-footer { display: flex; justify-content: space-between; align-items: center; }
.course-price { font-size: 18px; font-weight: 700; background: linear-gradient(135deg, #7c4dff, #9b7ff7); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.course-rating { display: flex; align-items: center; gap: 4px; }
.stars { color: #f59e0b; font-size: 13px; }
.rating-num { font-size: 12px; color: #8c8c8c; }
</style>
