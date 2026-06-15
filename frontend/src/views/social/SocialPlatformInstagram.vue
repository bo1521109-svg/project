<template>
  <div class="page-container">
    <div class="brand-header">
      <div class="bh-left">
        <svg class="bh-icon" viewBox="0 0 40 40" fill="none"><defs><linearGradient id="ig-grad" x1="0" y1="1" x2="1" y2="0"><stop offset="0%" stop-color="#ffdc80"/><stop offset="50%" stop-color="#fcaf45"/><stop offset="100%" stop-color="#e1306c"/></linearGradient></defs><circle cx="20" cy="20" r="18" fill="url(#ig-grad)"/><rect x="11" y="11" width="18" height="18" rx="4" stroke="#fff" stroke-width="2.5" fill="none"/><circle cx="20" cy="20" r="5" stroke="#fff" stroke-width="2" fill="none"/><circle cx="26" cy="14" r="1.2" fill="#fff"/></svg>
        <div>
          <h2 class="bh-title">Instagram</h2>
          <p class="bh-sub">视觉内容创作与品牌影响力分析</p>
        </div>
      </div>
      <el-button type="primary" style="background:linear-gradient(45deg,#f09433,#e6683c,#dc2743,#cc2366,#bc1888)">同步数据</el-button>
    </div>

    <div class="stat-row">
      <div v-for="s in stats" :key="s.label" class="stat-card">
        <div class="sc-icon" :style="{ background: s.bg }">{{ s.icon }}</div>
        <div class="sc-body">
          <div class="sc-num">{{ s.num }}<span class="sc-trend up"> {{ s.trend }}</span></div>
          <div class="sc-label">{{ s.label }}</div>
        </div>
      </div>
    </div>

    <!-- 内容表现 -->
    <div class="section">
      <div class="section-header">📱 最近内容表现</div>
      <div class="content-grid">
        <div v-for="c in contents" :key="c.id" class="content-card">
          <div class="cc-image" :style="{ background: c.bg }">
            <span style="font-size:36px">{{ c.emoji }}</span>
            <span class="cc-type">{{ c.typeLabel }}</span>
          </div>
          <div class="cc-body">
            <div class="cc-caption">{{ c.caption }}</div>
            <div class="cc-stats">
              <span>❤️ {{ c.likes }}</span>
              <span>💬 {{ c.comments }}</span>
              <span>📊 {{ c.reach }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 故事 & 受众 -->
    <div class="two-col">
      <div class="section half">
        <div class="section-header">📖 快拍(Stories)数据</div>
        <div class="story-stats">
          <div v-for="s in storyStats" :key="s.label" class="ss-item">
            <div class="ss-num">{{ s.num }}</div>
            <div class="ss-lbl">{{ s.label }}</div>
          </div>
        </div>
      </div>
      <div class="section half">
        <div class="section-header">🛍️ 购物标签表现</div>
        <div class="shop-list">
          <div v-for="s in shopTags" :key="s.name" class="shop-item">
            <span class="shop-icon">{{ s.icon }}</span>
            <div class="shop-info">
              <span class="shop-name">{{ s.name }}</span>
              <span class="shop-clicks">{{ s.clicks }}次点击</span>
            </div>
            <span class="shop-ctr">{{ s.ctr }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const stats = [
  { icon: '👥', bg: '#fce4ec', num: '28.5万', trend: '+6.8%', label: '粉丝数' },
  { icon: '👁️', bg: '#e8f5e9', num: '65万', trend: '+18.2%', label: '周触达' },
  { icon: '💝', bg: '#fff3e0', num: '5.2%', trend: '+2.5%', label: '互动率' },
  { icon: '📈', bg: '#e3f2fd', num: '2.8万', trend: '+4.3%', label: '新增粉丝/月' }
]

const contents = [
  { bg: '#fce4ec', emoji: '✨', typeLabel: '帖子', caption: '新品首发 | 春季限量款', likes: '1.5万', comments: '628', reach: '8.2万' },
  { bg: '#e8f5e9', emoji: '🎬', typeLabel: 'Reel', caption: '3秒变装挑战第5弹', likes: '3.2万', comments: '1.2k', reach: '18万' },
  { bg: '#fff3e0', emoji: '🛍️', typeLabel: '购物', caption: '本周热销TOP5合集', likes: '2.1万', comments: '856', reach: '12万' },
  { bg: '#e3f2fd', emoji: '📸', typeLabel: '帖子', caption: '幕后花絮 | 拍摄日常', likes: '1.8万', comments: '432', reach: '9.5万' },
  { bg: '#f3e5f5', emoji: '🎨', typeLabel: 'Reel', caption: 'DIY教程 | 5分钟改造', likes: '2.8万', comments: '965', reach: '15万' },
  { bg: '#ede7f6', emoji: '💫', typeLabel: '轮播', caption: '使用前后对比合集', likes: '2.5万', comments: '1.1k', reach: '13万' }
]

const storyStats = [
  { num: '8.5万', label: '日均展示' },
  { num: '92%', label: '完播率' },
  { num: '4.2%', label: '点击率' },
  { num: '3.6%', label: '回复率' },
  { num: '62%', label: '退订率' },
  { num: '1.8万', label: '日均互动' }
]

const shopTags = [
  { icon: '👜', name: '斜挎包新款', clicks: '5.2k', ctr: '3.8%' },
  { icon: '👗', name: '连衣裙夏季', clicks: '4.8k', ctr: '4.2%' },
  { icon: '👟', name: '运动鞋限量', clicks: '6.1k', ctr: '5.1%' },
  { icon: '💄', name: '口红套装', clicks: '3.5k', ctr: '3.1%' },
  { icon: '⌚', name: '智能手表', clicks: '4.2k', ctr: '3.6%' }
]
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.brand-header { display: flex; align-items: center; justify-content: space-between; background: linear-gradient(45deg, #f09433, #dc2743, #bc1888); border-radius: 16px; padding: 24px 28px; margin-bottom: 20px; }
.bh-left { display: flex; align-items: center; gap: 16px; }
.bh-icon { width: 40px; height: 40px; flex-shrink: 0; }
.bh-title { color: #fff; font-size: 24px; margin: 0; }
.bh-sub { color: rgba(255,255,255,0.75); font-size: 13px; margin: 4px 0 0; }

.stat-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 20px; }
.stat-card { background: #fff; border-radius: 14px; padding: 18px 20px; display: flex; align-items: center; gap: 14px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); }
.sc-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; }
.sc-body { display: flex; flex-direction: column; }
.sc-num { font-size: 22px; font-weight: 800; color: #1a1a1a; }
.sc-trend { font-size: 12px; font-weight: 500; }
.sc-trend.up { color: #10b981; }
.sc-label { font-size: 12px; color: #999; margin-top: 2px; }

.section { background: #fff; border-radius: 14px; padding: 20px; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); }
.section-header { font-size: 16px; font-weight: 700; color: #1a1a1a; margin-bottom: 16px; }
.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.half { margin-bottom: 0; }

.content-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 14px; }
.content-card { background: #fafafa; border-radius: 12px; overflow: hidden; transition: all 0.2s; }
.content-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
.cc-image { height: 140px; display: flex; align-items: center; justify-content: center; position: relative; }
.cc-type { position: absolute; top: 8px; left: 8px; font-size: 10px; padding: 2px 8px; background: rgba(0,0,0,0.5); color: #fff; border-radius: 4px; }
.cc-body { padding: 12px; }
.cc-caption { font-size: 13px; color: #333; line-height: 1.4; margin-bottom: 8px; }
.cc-stats { display: flex; gap: 12px; font-size: 11px; color: #999; }

.story-stats { display: grid; grid-template-columns: repeat(3,1fr); gap: 12px; }
.ss-item { background: linear-gradient(135deg, #fce4ec, #f3e5f5); border-radius: 10px; padding: 16px; text-align: center; }
.ss-num { font-size: 20px; font-weight: 700; color: #dc2743; }
.ss-lbl { font-size: 11px; color: #888; margin-top: 3px; }

.shop-list { display: flex; flex-direction: column; gap: 10px; }
.shop-item { display: flex; align-items: center; gap: 12px; padding: 10px; background: #fafafa; border-radius: 10px; }
.shop-icon { font-size: 24px; }
.shop-info { flex: 1; display: flex; flex-direction: column; }
.shop-name { font-size: 13px; font-weight: 600; color: #333; }
.shop-clicks { font-size: 11px; color: #aaa; }
.shop-ctr { font-size: 13px; font-weight: 600; color: #dc2743; }
</style>
