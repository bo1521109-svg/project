<template>
  <div class="page-container">
    <div class="brand-header">
      <div class="bh-left">
        <svg class="bh-icon" viewBox="0 0 40 40" fill="none"><circle cx="20" cy="20" r="18" fill="#111"/><path d="M22.5 11h3.2l-7 8 8.3 11h-6.5l-5-6.6-5.8 6.6H6.5l7.5-8.5L6 11h6.7l4.5 6 5.3-6Zm-1.1 17h1.8L11.8 12.8H9.8L21.4 28Z" fill="#e7e9ea"/></svg>
        <div>
          <h2 class="bh-title">Twitter / X</h2>
          <p class="bh-sub">实时社交互动与品牌声量监控</p>
        </div>
      </div>
      <el-button type="primary" style="background:#1d9bf0">同步数据</el-button>
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

    <!-- 最近推文 -->
    <div class="section">
      <div class="section-header">💬 最近推文表现</div>
      <div class="tweet-list">
        <div v-for="t in tweets" :key="t.id" class="tweet-item">
          <div class="tw-avatar">{{ t.avatar }}</div>
          <div class="tw-body">
            <div class="tw-header"><span class="tw-name">{{ t.name }}</span><span class="tw-handle">@{{ t.handle }}</span><span class="tw-time">· {{ t.time }}</span></div>
            <div class="tw-text">{{ t.text }}</div>
            <div class="tw-actions">
              <span v-for="a in [{icon:'💬',n:t.comments},{icon:'🔄',n:t.retweets},{icon:'❤️',n:t.likes},{icon:'📊',n:t.views}]" :key="a.icon" class="twa-item">{{ a.icon }} {{ a.n }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 趋势话题 & 社区 -->
    <div class="two-col">
      <div class="section half">
        <div class="section-header">🔥 趋势话题</div>
        <div class="trend-list">
          <div v-for="(t,i) in trends" :key="t.name" class="trend-item">
            <div class="tr-rank">{{ i+1 }}</div>
            <div class="tr-body">
              <div class="tr-topic">{{ t.topic }}</div>
              <div class="tr-name">{{ t.name }}</div>
              <div class="tr-posts">{{ t.posts }}条推文</div>
            </div>
          </div>
        </div>
      </div>
      <div class="section half">
        <div class="section-header">📊 账号表现</div>
        <div class="metrics-list">
          <div v-for="m in metrics" :key="m.label" class="metric-item">
            <span class="mt-label">{{ m.label }}</span>
            <div class="mt-bar-bg"><div class="mt-bar" :style="{ width: m.pct+'%', background: m.color }"></div></div>
            <span class="mt-val">{{ m.value }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const stats = [
  { icon: '👥', bg: '#e3f2fd', num: '12.8万', trend: '+8.2%', label: '关注者' },
  { icon: '👁️', bg: '#e8f5e9', num: '320万', trend: '+22.1%', label: '月展示量' },
  { icon: '🔄', bg: '#fce4ec', num: '8.5万', trend: '+15.3%', label: '月互动量' },
  { icon: '📈', bg: '#fff3e0', num: '5.2K', trend: '+3.8%', label: '新增关注/月' }
]

const tweets = [
  { avatar: '🏢', name: 'Brand Official', handle: 'brand_official', time: '1小时', text: 'Exciting news! Our new collection just dropped. Check it out! 🔥 #NewArrival #Spring2026', comments: '128', retweets: '245', likes: '1.2K', views: '18K' },
  { avatar: '🎯', name: 'Brand Official', handle: 'brand_official', time: '3小时', text: 'Customer satisfaction is our #1 priority. Here is what our users are saying about the new update ⬇️', comments: '86', retweets: '156', likes: '890', views: '14K' },
  { avatar: '📦', name: 'Brand Official', handle: 'brand_official', time: '5小时', text: 'Limited time offer: Use code SPRING20 for 20% off sitewide. Ends Sunday! 🎉', comments: '215', retweets: '432', likes: '1.8K', views: '25K' },
  { avatar: '🎨', name: 'Brand Official', handle: 'brand_official', time: '昨天', text: 'Behind the scenes: How we design our packaging to be 100% eco-friendly 🌱', comments: '95', retweets: '178', likes: '1.1K', views: '19K' },
  { avatar: '🛠️', name: 'Brand Official', handle: 'brand_official', time: '昨天', text: 'Quick tip Tuesday: 3 ways to maximize your productivity with our tool 🧵', comments: '162', retweets: '289', likes: '1.5K', views: '22K' },
  { avatar: '🎉', name: 'Brand Official', handle: 'brand_official', time: '2天前', text: 'WE JUST HIT 100K FOLLOWERS! Thank you all for the amazing support 🎊❤️', comments: '456', retweets: '1.2K', likes: '5.8K', views: '52K' }
]

const trends = [
  { topic: 'Technology', name: '#AIRevolution2026', posts: '125K' },
  { topic: 'E-commerce', name: '#DropshippingTips', posts: '98K' },
  { topic: 'Marketing', name: '#SocialMediaStrategy', posts: '87K' },
  { topic: 'Business', name: '#StartupLife', posts: '76K' },
  { topic: 'Design', name: '#ProductDesign', posts: '65K' },
  { topic: 'Trending', name: '#ViralMoment', posts: '210K' },
  { topic: 'Shopping', name: '#BestDeals', posts: '55K' }
]

const metrics = [
  { label: '品牌提及', pct: 85, value: '12.5K次', color: '#1d9bf0' },
  { label: '正面情绪', pct: 72, value: '72%', color: '#10b981' },
  { label: '链接点击率', pct: 45, value: '4.5%', color: '#f59e0b' },
  { label: '互动转化率', pct: 38, value: '3.8%', color: '#ef4444' }
]
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.brand-header { display: flex; align-items: center; justify-content: space-between; background: #15202b; border-radius: 16px; padding: 24px 28px; margin-bottom: 20px; }
.bh-left { display: flex; align-items: center; gap: 16px; }
.bh-icon { width: 40px; height: 40px; flex-shrink: 0; }
.bh-title { color: #e7e9ea; font-size: 24px; margin: 0; }
.bh-sub { color: #71767b; font-size: 13px; margin: 4px 0 0; }

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

.tweet-list { display: flex; flex-direction: column; gap: 0; }
.tweet-item { display: flex; gap: 12px; padding: 14px 0; border-bottom: 1px solid #f0f0f0; }
.tweet-item:last-child { border-bottom: none; }
.tw-avatar { width: 40px; height: 40px; border-radius: 50%; background: #1d9bf0; display: flex; align-items: center; justify-content: center; font-size: 20px; flex-shrink: 0; }
.tw-body { flex: 1; min-width: 0; }
.tw-header { font-size: 12px; margin-bottom: 4px; }
.tw-name { font-weight: 700; color: #1a1a1a; }
.tw-handle, .tw-time { color: #999; }
.tw-text { font-size: 13px; color: #333; line-height: 1.5; margin-bottom: 8px; }
.tw-actions { display: flex; gap: 20px; }
.twa-item { font-size: 12px; color: #888; cursor: pointer; }

.trend-list { display: flex; flex-direction: column; }
.trend-item { display: flex; gap: 12px; padding: 12px 0; border-bottom: 1px solid #f5f5f5; }
.trend-item:last-child { border-bottom: none; }
.tr-rank { width: 24px; font-size: 14px; font-weight: 700; color: #ccc; padding-top: 2px; }
.tr-body { flex: 1; }
.tr-topic { font-size: 10px; color: #aaa; }
.tr-name { font-size: 14px; font-weight: 700; color: #1d9bf0; }
.tr-posts { font-size: 11px; color: #aaa; }

.metrics-list { display: flex; flex-direction: column; gap: 14px; }
.metric-item { display: flex; align-items: center; gap: 10px; }
.mt-label { width: 80px; font-size: 12px; color: #666; text-align: right; flex-shrink: 0; }
.mt-bar-bg { flex: 1; height: 8px; background: #f0f0f0; border-radius: 4px; overflow: hidden; }
.mt-bar { height: 100%; border-radius: 4px; }
.mt-val { width: 60px; font-size: 13px; font-weight: 600; color: #333; text-align: right; }
</style>
