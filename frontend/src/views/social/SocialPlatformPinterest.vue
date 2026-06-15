<template>
  <div class="page-container">
    <div class="brand-header">
      <div class="bh-left">
        <svg class="bh-icon" viewBox="0 0 40 40" fill="none"><circle cx="20" cy="20" r="18" fill="#e60023"/><text x="20" y="27" text-anchor="middle" fill="#fff" font-size="20" font-weight="800" font-family="Arial">P</text></svg>
        <div>
          <h2 class="bh-title">Pinterest</h2>
          <p class="bh-sub">视觉灵感发现与品牌曝光分析</p>
        </div>
      </div>
      <el-button type="primary" style="background:#e60023">同步数据</el-button>
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

    <div class="section">
      <div class="section-header">📌 热门 Pin TOP8</div>
      <div class="pin-grid">
        <div v-for="p in pins" :key="p.id" class="pin-card">
          <div class="pc-image" :style="{ background: p.bg }"><span style="font-size:40px">{{ p.emoji }}</span><span class="pc-board">{{ p.board }}</span></div>
          <div class="pc-body">
            <div class="pc-title">{{ p.title }}</div>
            <div class="pc-stats">
              <div class="pcs-item"><span class="pcs-num">{{ p.impressions }}</span><span class="pcs-lbl">展示</span></div>
              <div class="pcs-item"><span class="pcs-num">{{ p.saves }}</span><span class="pcs-lbl">保存</span></div>
              <div class="pcs-item"><span class="pcs-num">{{ p.clicks }}</span><span class="pcs-lbl">点击</span></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="two-col">
      <div class="section half">
        <div class="section-header">📂 画板表现</div>
        <div class="board-list">
          <div v-for="b in boards" :key="b.name" class="board-item">
            <span class="bi-icon">{{ b.icon }}</span>
            <div class="bi-info"><div class="bi-name">{{ b.name }}</div><div class="bi-pins">{{ b.pins }}个Pin · {{ b.followers }}关注</div></div>
            <span class="bi-imp">{{ b.impressions }}</span>
          </div>
        </div>
      </div>
      <div class="section half">
        <div class="section-header">🔍 热门搜索词</div>
        <div class="search-list">
          <div v-for="(s,i) in searches" :key="s.name" class="search-item">
            <span class="si-rank">{{ i+1 }}</span>
            <span class="si-name">{{ s.name }}</span>
            <span class="si-vol">{{ s.volume }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const stats = [
  { icon: '👁️', bg: '#fce4ec', num: '55万', trend: '+15.2%', label: '月展示量' },
  { icon: '📌', bg: '#e8f5e9', num: '12.5万', trend: '+8.6%', label: '月保存量' },
  { icon: '🔗', bg: '#e3f2fd', num: '8.2万', trend: '+12.1%', label: '链接点击' },
  { icon: '👥', bg: '#fff3e0', num: '3.8万', trend: '+5.8%', label: '关注者' }
]

const pins = [
  { bg: '#fce4ec', emoji: '👗', board: 'Spring Fashion', title: '10 Must-Have Spring Outfits 2026', impressions: '28万', saves: '4.5万', clicks: '2.8万' },
  { bg: '#e8f5e9', emoji: '🏠', board: 'Home Decor', title: 'Minimalist Room Makeover Ideas', impressions: '22万', saves: '3.8万', clicks: '1.9万' },
  { bg: '#fff3e0', emoji: '🍳', board: 'Kitchen Ideas', title: 'Smart Kitchen Gadgets You Need', impressions: '18万', saves: '3.2万', clicks: '2.5万' },
  { bg: '#e3f2fd', emoji: '💻', board: 'Workspace', title: 'Ultimate Desk Setup Guide 2026', impressions: '15万', saves: '2.6万', clicks: '1.6万' },
  { bg: '#f3e5f5', emoji: '🎁', board: 'Gift Guides', title: 'Best Gifts Under $50', impressions: '25万', saves: '5.1万', clicks: '3.2万' },
  { bg: '#ede7f6', emoji: '🌿', board: 'Gardening', title: 'Easy Indoor Plants for Beginners', impressions: '12万', saves: '2.2万', clicks: '1.1万' },
  { bg: '#e0f7fa', emoji: '💄', board: 'Beauty Tips', title: 'Natural Makeup Tutorial Step by Step', impressions: '20万', saves: '3.5万', clicks: '2.1万' },
  { bg: '#f5f5f0', emoji: '🧘', board: 'Wellness', title: 'Morning Routine for Productivity', impressions: '16万', saves: '2.8万', clicks: '1.4万' }
]

const boards = [
  { icon: '👗', name: 'Spring Fashion 2026', pins: 156, followers: '2.8K', impressions: '85万/月' },
  { icon: '🏠', name: 'Home Decor Ideas', pins: 234, followers: '3.5K', impressions: '120万/月' },
  { icon: '💄', name: 'Beauty & Skincare', pins: 198, followers: '4.2K', impressions: '95万/月' },
  { icon: '🎁', name: 'Gift Guides', pins: 87, followers: '1.8K', impressions: '150万/月' },
  { icon: '🍳', name: 'Kitchen Gadgets', pins: 112, followers: '2.1K', impressions: '68万/月' }
]

const searches = [
  { name: 'spring outfit ideas 2026', volume: '高' },
  { name: 'home organization hacks', volume: '高' },
  { name: 'easy dinner recipes', volume: '高' },
  { name: 'nail art designs', volume: '中' },
  { name: 'minimalist bedroom', volume: '中' },
  { name: 'summer fashion trends', volume: '上升' }
]
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.brand-header { display: flex; align-items: center; justify-content: space-between; background: linear-gradient(135deg, #ad081b, #e60023); border-radius: 16px; padding: 24px 28px; margin-bottom: 20px; }
.bh-left { display: flex; align-items: center; gap: 16px; }
.bh-icon { width: 40px; height: 40px; flex-shrink: 0; }
.bh-title { color: #fff; font-size: 24px; margin: 0; }
.bh-sub { color: rgba(255,255,255,0.75); font-size: 13px; margin: 4px 0 0; }

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

.pin-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 14px; }
.pin-card { background: #fafafa; border-radius: 12px; overflow: hidden; transition: all 0.2s; }
.pin-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
.pc-image { height: 140px; display: flex; align-items: center; justify-content: center; position: relative; }
.pc-board { position: absolute; bottom: 6px; left: 6px; font-size: 9px; padding: 2px 6px; background: rgba(0,0,0,0.5); color: #fff; border-radius: 4px; }
.pc-body { padding: 12px; }
.pc-title { font-size: 12px; color: #333; font-weight: 600; line-height: 1.3; margin-bottom: 8px; }
.pc-stats { display: flex; gap: 12px; }
.pcs-item { display: flex; flex-direction: column; }
.pcs-num { font-size: 14px; font-weight: 700; color: #e60023; }
.pcs-lbl { font-size: 10px; color: #aaa; }

.board-list { display: flex; flex-direction: column; gap: 10px; }
.board-item { display: flex; align-items: center; gap: 12px; padding: 12px; background: #fafafa; border-radius: 10px; }
.bi-icon { font-size: 28px; }
.bi-info { flex: 1; }
.bi-name { font-weight: 600; color: #333; font-size: 13px; }
.bi-pins { font-size: 11px; color: #aaa; }
.bi-imp { font-size: 12px; font-weight: 600; color: #e60023; }

.search-list { display: flex; flex-direction: column; }
.search-item { display: flex; align-items: center; gap: 10px; padding: 10px 0; border-bottom: 1px solid #f5f5f5; }
.search-item:last-child { border-bottom: none; }
.si-rank { width: 24px; font-size: 14px; font-weight: 700; color: #ccc; }
.si-name { flex: 1; font-size: 13px; color: #333; }
.si-vol { font-size: 12px; color: #e60023; font-weight: 600; }
</style>
