<template>
  <div class="page-container">
    <div class="brand-header">
      <div class="bh-left">
        <svg class="bh-icon" viewBox="0 0 40 40" fill="none"><rect x="4" y="8" width="32" height="24" rx="6" fill="#ff0000"/><path d="M17 14v12l10-6-10-6Z" fill="#fff"/></svg>
        <div>
          <h2 class="bh-title">YouTube</h2>
          <p class="bh-sub">视频内容创作与频道数据分析</p>
        </div>
      </div>
      <el-button type="primary" style="background:#ff0000">同步数据</el-button>
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

    <!-- 视频表现 -->
    <div class="section">
      <div class="section-header">🎬 热门视频 TOP8</div>
      <div class="table-wrap">
        <table>
          <thead><tr><th style="width:60px">缩略图</th><th>视频标题</th><th style="width:100px">观看</th><th style="width:80px">点赞</th><th style="width:80px">评论</th><th style="width:80px">时长</th><th style="width:80px">CTR</th></tr></thead>
          <tbody>
            <tr v-for="(v,i) in videos" :key="i">
              <td><div class="thumb-cel" :style="{ background: v.bg }">{{ v.emoji }}</div></td>
              <td>{{ v.title }}</td>
              <td class="num">{{ v.views }}</td>
              <td class="num">{{ v.likes }}</td>
              <td class="num">{{ v.comments }}</td>
              <td>{{ v.duration }}</td>
              <td><span class="ctr-val">{{ v.ctr }}</span></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 观众分析 & 收入 -->
    <div class="two-col">
      <div class="section half">
        <div class="section-header">👥 观众分析</div>
        <div class="aud-row">
          <div v-for="a in audience" :key="a.label" class="aud-item">
            <div class="aud-key">{{ a.label }}</div>
            <div class="aud-bar"><div class="aud-fill" :style="{ width: a.pct+'%', background: a.color }"></div></div>
            <div class="aud-val">{{ a.pct }}%</div>
          </div>
        </div>
      </div>
      <div class="section half">
        <div class="section-header">💰 收入概览(估算)</div>
        <div class="rev-grid">
          <div v-for="r in revenue" :key="r.label" class="rev-card">
            <div class="rc-num" :style="{ color: r.color }">{{ r.num }}</div>
            <div class="rc-lbl">{{ r.label }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const stats = [
  { icon: '📢', bg: '#fce4ec', num: '68.5万', trend: '+12.8%', label: '订阅者' },
  { icon: '▶️', bg: '#e8f5e9', num: '1.2亿', trend: '+25.6%', label: '月观看量' },
  { icon: '⏱', bg: '#e3f2fd', num: '380万', trend: '+18.3%', label: '观看时长(小时)' },
  { icon: '💵', bg: '#fff3e0', num: '$8.2K', trend: '+22.1%', label: '月收入' }
]

const videos = [
  { bg: '#fce4ec', emoji: '📦', title: 'Ultimate Product Unboxing 2026 | Everything You Need', views: '186万', likes: '8.2万', comments: '3.5k', duration: '12:30', ctr: '8.5%' },
  { bg: '#e8f5e9', emoji: '🎓', title: 'Complete Tutorial: How to Use Our Product Like a Pro', views: '125万', likes: '5.6万', comments: '2.8k', duration: '18:45', ctr: '7.2%' },
  { bg: '#fff3e0', emoji: '🔄', title: 'Before & After: Amazing Product Transformation', views: '98万', likes: '4.8万', comments: '2.1k', duration: '8:15', ctr: '9.1%' },
  { bg: '#e3f2fd', emoji: '🎯', title: 'Top 10 Best Selling Items This Month', views: '85万', likes: '3.9万', comments: '1.6k', duration: '15:20', ctr: '6.8%' },
  { bg: '#f3e5f5', emoji: '🏆', title: 'We Tested 50 Products: These Are the Best', views: '72万', likes: '3.5万', comments: '2.4k', duration: '22:10', ctr: '5.9%' },
  { bg: '#ede7f6', emoji: '🎨', title: 'Behind the Scenes: How Our Products Are Made', views: '65万', likes: '3.1万', comments: '1.2k', duration: '10:50', ctr: '7.5%' },
  { bg: '#e0f7fa', emoji: '💡', title: '5 Hacks That Will Change How You Use Our Product', views: '58万', likes: '2.8万', comments: '1.8k', duration: '6:30', ctr: '8.8%' },
  { bg: '#fff3e0', emoji: '🎉', title: '100K Subscribers Celebration + HUGE Giveaway', views: '145万', likes: '12.5万', comments: '8.2k', duration: '25:00', ctr: '11.2%' }
]

const audience = [
  { label: '18-24', pct: 22, color: '#ff4444' },
  { label: '25-34', pct: 42, color: '#ff6666' },
  { label: '35-44', pct: 20, color: '#ff8888' },
  { label: '45-54', pct: 10, color: '#ffaaaa' },
  { label: '55+', pct: 6, color: '#ffcccc' }
]

const revenue = [
  { num: '$8,250', label: '广告收入', color: '#ff0000' },
  { num: '$3,450', label: '会员收入', color: '#10b981' },
  { num: '$12,800', label: '品牌合作', color: '#1d9bf0' },
  { num: '$2,100', label: '超级感谢', color: '#f59e0b' },
  { num: '$26,600', label: '总收入', color: '#7c4dff' },
  { num: '+18.2%', label: '环比增长', color: '#10b981' }
]
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.brand-header { display: flex; align-items: center; justify-content: space-between; background: linear-gradient(135deg, #cc0000, #ff0000); border-radius: 16px; padding: 24px 28px; margin-bottom: 20px; }
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

.table-wrap { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; }
thead th { text-align: left; padding: 10px 12px; font-size: 12px; color: #999; font-weight: 600; border-bottom: 2px solid #f0f0f0; }
tbody td { padding: 12px; font-size: 13px; color: #333; border-bottom: 1px solid #f5f5f5; vertical-align: middle; }
tbody tr:hover { background: #fafafa; }
.thumb-cel { width: 48px; height: 32px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 18px; }
.num { color: #333; font-weight: 500; font-variant-numeric: tabular-nums; }
.ctr-val { font-size: 12px; padding: 2px 8px; background: #e8f5e9; color: #2e7d32; border-radius: 4px; font-weight: 600; }

.aud-row { display: flex; flex-direction: column; gap: 12px; }
.aud-item { display: flex; align-items: center; gap: 10px; }
.aud-key { width: 50px; font-size: 12px; color: #666; }
.aud-bar { flex: 1; height: 10px; background: #f0f0f0; border-radius: 5px; overflow: hidden; }
.aud-fill { height: 100%; border-radius: 5px; }
.aud-val { width: 36px; font-size: 13px; font-weight: 600; color: #333; }

.rev-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 12px; }
.rev-card { background: #fafafa; border-radius: 10px; padding: 16px; text-align: center; }
.rc-num { font-size: 20px; font-weight: 700; }
.rc-lbl { font-size: 11px; color: #888; margin-top: 3px; }
</style>
