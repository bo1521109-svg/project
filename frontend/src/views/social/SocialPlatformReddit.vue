<template>
  <div class="page-container">
    <div class="brand-header">
      <div class="bh-left">
        <svg class="bh-icon" viewBox="0 0 40 40" fill="none"><circle cx="20" cy="20" r="18" fill="#ff4500"/><ellipse cx="20" cy="22" rx="8" ry="4" fill="#fff"/><circle cx="17" cy="20" r="2" fill="#ff4500"/><circle cx="23" cy="20" r="2" fill="#ff4500"/><path d="M14 16c-.6-1.2.2-2.5 1.5-2.5 1 0 1.5.8 1.3 1.8" stroke="#fff" stroke-width="1.8" fill="none" stroke-linecap="round"/><path d="M26 16c.6-1.2-.2-2.5-1.5-2.5-1 0-1.5.8-1.3 1.8" stroke="#fff" stroke-width="1.8" fill="none" stroke-linecap="round"/></svg>
        <div>
          <h2 class="bh-title">Reddit</h2>
          <p class="bh-sub">社区讨论与产品口碑监测</p>
        </div>
      </div>
      <el-button type="primary" style="background:#ff4500">同步数据</el-button>
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

    <!-- 热门帖子 -->
    <div class="section">
      <div class="section-header">🔥 热门帖子</div>
      <div class="post-list">
        <div v-for="p in posts" :key="p.id" class="post-item">
          <div class="post-vote">
            <span class="pv-up">▲</span>
            <span class="pv-num">{{ p.upvotes }}</span>
            <span class="pv-down">▼</span>
          </div>
          <div class="post-body">
            <div class="pb-meta">
              <span class="pb-sub">{{ p.subreddit }}</span>
              <span>· 由 u/{{ p.author }} 发布</span>
              <span>· {{ p.time }}</span>
            </div>
            <div class="pb-title">{{ p.title }}</div>
            <div class="pb-flair" v-if="p.flair">{{ p.flair }}</div>
            <div class="pb-actions">
              <span>💬 {{ p.comments }} 评论</span>
              <span>📊 {{ p.views }} 浏览</span>
              <span>📈 情绪: {{ p.sentiment }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="two-col">
      <!-- 子版块 -->
      <div class="section half">
        <div class="section-header">📁 关注子版块</div>
        <div class="sub-list">
          <div v-for="s in subreddits" :key="s.name" class="sub-item">
            <span class="sub-icon">{{ s.icon }}</span>
            <div class="sub-info">
              <div class="sub-name">r/{{ s.name }}</div>
              <div class="sub-desc">{{ s.desc }}</div>
            </div>
            <div class="sub-meta">
              <span class="sm-mem">{{ s.members }}</span>
              <span class="sm-lbl">成员</span>
            </div>
          </div>
        </div>
      </div>
      <!-- 品牌提及情绪 -->
      <div class="section half">
        <div class="section-header">📊 品牌提及情绪</div>
        <div class="sentiment-area">
          <div class="sent-summary">
            <div class="ss-positive">
              <div class="ssp-num">68%</div>
              <div class="ssp-lbl">正面</div>
            </div>
            <div class="ss-neutral">
              <div class="ssn-num">22%</div>
              <div class="ssn-lbl">中立</div>
            </div>
            <div class="ss-negative">
              <div class="ssn-num">10%</div>
              <div class="ssn-lbl">负面</div>
            </div>
          </div>
          <div class="mention-list">
            <div v-for="(m,i) in mentions" :key="i" class="mention-item">
              <span class="ml-emoji">{{ m.emoji }}</span>
              <div class="ml-text">{{ m.text }}</div>
              <span class="ml-score">+{{ m.score }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const stats = [
  { icon: '👥', bg: '#fff3e0', num: '2.5万', trend: '+12.5%', label: 'Karma分' },
  { icon: '📈', bg: '#e8f5e9', num: '15.2万', trend: '+28.1%', label: '月帖子浏览量' },
  { icon: '💬', bg: '#e3f2fd', num: '3.8K', trend: '+18.6%', label: '月评论数' },
  { icon: '📊', bg: '#fce4ec', num: '68%', trend: '+5.2%', label: '正面提及率' }
]

const posts = [
  { subreddit: 'r/ecommerce', author: 'shopowner_2026', time: '3小时前', title: 'How I grew my Shopify store to $50K/month using Reddit marketing', upvotes: '2.8K', comments: '456', views: '18K', sentiment: '正面', flair: 'Success Story' },
  { subreddit: 'r/amazonfba', author: 'seller_pro', time: '6小时前', title: 'PSA: New FBA fee changes for Q3 2026 - what you need to know', upvotes: '1.5K', comments: '328', views: '12K', sentiment: '中立', flair: 'News' },
  { subreddit: 'r/dropship', author: 'dropship_master', time: '昨天', title: 'Honest review of Top 5 dropshipping suppliers I have used', upvotes: '3.2K', comments: '521', views: '22K', sentiment: '正面', flair: 'Review' },
  { subreddit: 'r/Entrepreneur', author: 'startup_founder', time: '昨天', title: 'From zero to $10K MRR in 6 months - detailed breakdown', upvotes: '4.1K', comments: '632', views: '28K', sentiment: '正面', flair: 'AMA' },
  { subreddit: 'r/marketing', author: 'brand_builder', time: '2天前', title: 'Why most social media marketing fails and how to fix it', upvotes: '2.1K', comments: '289', views: '15K', sentiment: '中立', flair: 'Discussion' },
  { subreddit: 'r/smallbusiness', author: 'local_owner', time: '2天前', title: 'Warning: Common mistakes new business owners make with SEO', upvotes: '1.8K', comments: '245', views: '11K', sentiment: '中立', flair: 'Tips' }
]

const subreddits = [
  { icon: '🛒', name: 'ecommerce', desc: '电商运营讨论', members: '280K' },
  { icon: '📦', name: 'dropship', desc: '一件代发经验分享', members: '180K' },
  { icon: '💼', name: 'Entrepreneur', desc: '创业者社区', members: '850K' },
  { icon: '📊', name: 'marketing', desc: '市场营销策略', members: '520K' },
  { icon: '🏪', name: 'smallbusiness', desc: '小商家互助', members: '320K' },
  { icon: '📦', name: 'amazonfba', desc: 'FBA卖家讨论', members: '150K' }
]

const mentions = [
  { emoji: '😊', text: '"Best product I have bought all year. Quality is amazing!" - u/happy_customer', score: 856 },
  { emoji: '😊', text: '"Their customer service went above and beyond. Impressed!" - u/loyal_buyer', score: 642 },
  { emoji: '😊', text: '"Shipping was super fast. Will definitely order again." - u/repeat_customer', score: 523 },
  { emoji: '😊', text: '"Great value for the price. Highly recommend!" - u/first_time_buyer', score: 418 }
]
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.brand-header { display: flex; align-items: center; justify-content: space-between; background: linear-gradient(135deg, #1a1a1b, #ff4500); border-radius: 16px; padding: 24px 28px; margin-bottom: 20px; }
.bh-left { display: flex; align-items: center; gap: 16px; }
.bh-icon { width: 40px; height: 40px; flex-shrink: 0; }
.bh-title { color: #fff; font-size: 24px; margin: 0; }
.bh-sub { color: rgba(255,255,255,0.6); font-size: 13px; margin: 4px 0 0; }

.stat-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 20px; }
.stat-card { background: #fff; border-radius: 14px; padding: 18px 20px; display: flex; align-items: center; gap: 14px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); }
.sc-icon { width: 48px; height: 48px; border-radius: 12px; font-size: 22px; display: flex; align-items: center; justify-content: center; }
.sc-body { display: flex; flex-direction: column; }
.sc-num { font-size: 22px; font-weight: 800; color: #1a1a1a; }
.sc-trend { font-size: 12px; font-weight: 500; }
.sc-trend.up { color: #10b981; }
.sc-label { font-size: 12px; color: #999; margin-top: 2px; }

.section { background: #fff; border-radius: 14px; padding: 20px; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); }
.section-header { font-size: 16px; font-weight: 700; color: #1a1a1a; margin-bottom: 16px; }
.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.half { margin-bottom: 0; }

.post-list { display: flex; flex-direction: column; }
.post-item { display: flex; gap: 12px; padding: 14px 0; border-bottom: 1px solid #f0f0f0; }
.post-item:last-child { border-bottom: none; }
.post-vote { display: flex; flex-direction: column; align-items: center; width: 40px; flex-shrink: 0; }
.pv-up, .pv-down { font-size: 10px; color: #ccc; cursor: pointer; }
.pv-up:hover { color: #ff4500; }
.pv-down:hover { color: #7193ff; }
.pv-num { font-size: 13px; font-weight: 700; color: #333; }
.post-body { flex: 1; min-width: 0; }
.pb-meta { font-size: 11px; color: #aaa; margin-bottom: 4px; display: flex; gap: 4px; }
.pb-sub { font-weight: 700; color: #ff4500; }
.pb-title { font-size: 14px; font-weight: 600; color: #1a1a1a; line-height: 1.4; margin-bottom: 6px; }
.pb-flair { display: inline-block; font-size: 10px; padding: 2px 8px; background: #f5f5f5; border-radius: 4px; color: #666; margin-bottom: 6px; }
.pb-actions { display: flex; gap: 14px; font-size: 11px; color: #999; }

.sub-list { display: flex; flex-direction: column; gap: 8px; }
.sub-item { display: flex; align-items: center; gap: 12px; padding: 12px; background: #fafafa; border-radius: 10px; }
.sub-icon { font-size: 24px; }
.sub-info { flex: 1; }
.sub-name { font-weight: 700; color: #ff4500; font-size: 13px; }
.sub-desc { font-size: 11px; color: #aaa; }
.sub-meta { text-align: center; }
.sm-mem { display: block; font-weight: 700; color: #333; font-size: 14px; }
.sm-lbl { font-size: 10px; color: #aaa; }

.sentiment-area { display: flex; flex-direction: column; gap: 14px; }
.sent-summary { display: flex; gap: 12px; }
.sent-summary > div { flex: 1; border-radius: 10px; padding: 16px; text-align: center; }
.ss-positive { background: #e8f5e9; }
.ss-neutral { background: #fafafa; }
.ss-negative { background: #fce4ec; }
.ssp-num, .ssn-num { font-size: 24px; font-weight: 800; }
.ss-positive .ssp-num { color: #2e7d32; }
.ss-neutral .ssn-num { color: #999; }
.ss-negative .ssn-num { color: #c62828; }
.ssp-lbl, .ssn-lbl { font-size: 11px; color: #888; margin-top: 3px; }

.mention-list { display: flex; flex-direction: column; gap: 8px; }
.mention-item { display: flex; align-items: flex-start; gap: 8px; padding: 8px; background: #fafafa; border-radius: 8px; }
.ml-emoji { font-size: 18px; flex-shrink: 0; }
.ml-text { flex: 1; font-size: 12px; color: #555; line-height: 1.4; }
.ml-score { font-size: 12px; font-weight: 700; color: #ff4500; flex-shrink: 0; }
</style>
