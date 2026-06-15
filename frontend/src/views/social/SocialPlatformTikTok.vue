<template>
  <div class="page-container">
    <div class="brand-header">
      <div class="bh-left">
        <svg class="bh-icon" viewBox="0 0 40 40" fill="none"><circle cx="20" cy="20" r="18" fill="#111"/><path d="M24.5 8C22.2 9.2 22.6 12.3 22.6 12.3V8h-3.8v16.5c0 1.8-1.5 3.3-3.3 3.3-1.8 0-3.3-1.5-3.3-3.3 0-1.8 1.5-3.3 3.3-3.3.34 0 .65.05.95.15v-4c-.32-.05-.63-.08-.95-.08-4.03 0-7.3 3.27-7.3 7.3s3.27 7.3 7.3 7.3 7.3-3.27 7.3-7.3V15c1.3 1 3.1 1.6 3.1 1.6v-3.8s-1.8-.5-3.1-1.8V8Z" fill="#00f2ea" opacity=".7"/><path d="M22.6 12.3c0-3.6 1.9-4.3 1.9-4.3V8h-1.9v4.3ZM26.8 12.8v-3.8s-1.8-.5-3.1-1.8V8c1.3 1.3 3.1 1.8 3.1 1.8v3.8l-3.1-1.6Z" fill="#ff0050"/></svg>
        <div>
          <h2 class="bh-title">TikTok</h2>
          <p class="bh-sub">短视频创作与数据分析平台</p>
        </div>
      </div>
      <el-button type="primary" style="background:linear-gradient(135deg,#00f2ea,#ff0050)">同步数据</el-button>
    </div>

    <!-- 统计卡片 -->
    <div class="stat-row">
      <div v-for="s in stats" :key="s.label" class="stat-card">
        <div class="sc-icon" :style="{ background: s.bg }">{{ s.icon }}</div>
        <div class="sc-body">
          <div class="sc-num">{{ s.num }}<span class="sc-trend up"> {{ s.trend }}</span></div>
          <div class="sc-label">{{ s.label }}</div>
        </div>
      </div>
    </div>

    <!-- 热门视频 -->
    <div class="section">
      <div class="section-header">🔥 热门视频 TOP10</div>
      <div class="table-wrap">
        <table>
          <thead><tr><th style="width:60px">排名</th><th>视频标题</th><th style="width:100px">播放量</th><th style="width:80px">点赞</th><th style="width:80px">评论</th><th style="width:80px">分享</th></tr></thead>
          <tbody>
            <tr v-for="(v,i) in topVideos" :key="i" :class="{ row1: i===0 }">
              <td><span :class="'rank rank'+i">{{ i+1 }}</span></td>
              <td>{{ v.title }}</td>
              <td class="num">{{ v.views }}</td>
              <td class="num">{{ v.likes }}</td>
              <td class="num">{{ v.comments }}</td>
              <td class="num">{{ v.shares }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 热门话题 & 音乐 -->
    <div class="two-col">
      <div class="section half">
        <div class="section-header"># 热门话题</div>
        <div class="tag-cloud">
          <span v-for="t in hashtags" :key="t.name" class="htag" :style="{ fontSize: t.size+'px', opacity: t.opacity }">#{{ t.name }} <small>{{ t.views }}</small></span>
        </div>
      </div>
      <div class="section half">
        <div class="section-header">🎶 热门音乐</div>
        <div class="music-list">
          <div v-for="(m,i) in topMusic" :key="i" class="music-item">
            <span class="mi-rank">{{ i+1 }}</span>
            <span class="mi-cover">{{ m.emoji }}</span>
            <div class="mi-info">
              <span class="mi-name">{{ m.name }}</span>
              <span class="mi-artist">{{ m.artist }}</span>
            </div>
            <span class="mi-uses">{{ m.uses }}次使用</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const stats = [
  { icon: '👁️', bg: '#e0f7fa', num: '520万', trend: '+12.5%', label: '总粉丝数' },
  { icon: '▶️', bg: '#fce4ec', num: '8.9亿', trend: '+28.3%', label: '月播放量' },
  { icon: '❤️', bg: '#fff3e0', num: '6.8%', trend: '+3.1%', label: '平均互动率' },
  { icon: '📈', bg: '#e8f5e9', num: '3.2万', trend: '+8.7%', label: '新增粉丝/月' }
]

const topVideos = [
  { title: '产品开箱挑战 | 不到$10的护肤神器', views: '256万', likes: '18.2万', comments: '3.5k', shares: '8.2k' },
  { title: '素人改造第8期 | 欧美妆x日常通勤', views: '198万', likes: '15.6万', comments: '2.8k', shares: '6.5k' },
  { title: '打工人Vlog | 我的午间护肤routine', views: '165万', likes: '12.4万', comments: '1.9k', shares: '4.7k' },
  { title: '测评避坑 | 这些国货真的值得买', views: '142万', likes: '11.8万', comments: '2.3k', shares: '5.1k' },
  { title: '穿搭公式 | 小个子女生一周不重样', views: '128万', likes: '10.2万', comments: '1.6k', shares: '3.8k' },
  { title: '种草合集 | 夏日必备防晒全测评', views: '115万', likes: '9.6万', comments: '2.1k', shares: '4.2k' },
  { title: '挑战失败 | 100元改造出租屋', views: '98万', likes: '8.1万', comments: '3.2k', shares: '2.9k' },
  { title: '教程干货 | 零基础学做自媒体', views: '87万', likes: '7.3万', comments: '1.4k', shares: '5.6k' },
  { title: '开箱视频 | 最新款蓝牙耳机全面评测', views: '76万', likes: '6.5万', comments: '1.8k', shares: '2.3k' },
  { title: '化妆教程 | 黄皮逆袭冷白皮', views: '65万', likes: '5.8万', comments: '1.2k', shares: '3.1k' }
]

const hashtags = [
  { name: '美妆教程', views: '12.8亿', size: 18, opacity: 1 },
  { name: '穿搭灵感', views: '9.5亿', size: 16, opacity: 0.9 },
  { name: '开箱测评', views: '8.2亿', size: 15, opacity: 0.85 },
  { name: '护肤日常', views: '7.1亿', size: 14, opacity: 0.8 },
  { name: '生活Vlog', views: '6.5亿', size: 13, opacity: 0.75 },
  { name: '平价好物', views: '5.8亿', size: 12, opacity: 0.7 },
  { name: '跨境电商', views: '5.2亿', size: 16, opacity: 0.9 },
  { name: '素人改造', views: '4.6亿', size: 13, opacity: 0.75 },
  { name: '产品种草', views: '3.9亿', size: 11, opacity: 0.65 },
  { name: '健身塑形', views: '3.5亿', size: 12, opacity: 0.7 },
  { name: '家居好物', views: '3.1亿', size: 11, opacity: 0.65 },
  { name: '数码产品', views: '2.8亿', size: 10, opacity: 0.6 }
]

const topMusic = [
  { emoji: '🎵', name: 'Trending Beat 2026', artist: 'DJ Wave', uses: '128万' },
  { emoji: '🎵', name: 'Summer Vibes Remix', artist: 'Luna Park', uses: '105万' },
  { emoji: '🎵', name: 'Unboxing BGM', artist: 'Chill Studio', uses: '92万' },
  { emoji: '🎵', name: 'Feel Good Pop', artist: 'Star Track', uses: '87万' },
  { emoji: '🎵', name: 'Product Reveal', artist: 'Beat Maker', uses: '73万' },
  { emoji: '🎵', name: 'Glow Up Sound', artist: 'Neon Wave', uses: '68万' },
  { emoji: '🎵', name: 'Vlog Day', artist: 'Daily BGM', uses: '55万' }
]
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.brand-header { display: flex; align-items: center; justify-content: space-between; background: linear-gradient(135deg, #111, #1a1a2e); border-radius: 16px; padding: 24px 28px; margin-bottom: 20px; }
.bh-left { display: flex; align-items: center; gap: 16px; }
.bh-icon { width: 40px; height: 40px; flex-shrink: 0; }
.bh-title { color: #fff; font-size: 24px; margin: 0; }
.bh-sub { color: #888; font-size: 13px; margin: 4px 0 0; }

.stat-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 20px; }
.stat-card { background: #fff; border-radius: 14px; padding: 18px 20px; display: flex; align-items: center; gap: 14px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); }
.sc-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; }
.sc-body { display: flex; flex-direction: column; }
.sc-num { font-size: 22px; font-weight: 800; color: #1a1a1a; }
.sc-trend { font-size: 12px; font-weight: 500; }
.sc-trend.up { color: #10b981; }
.sc-trend.down { color: #ef4444; }
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
.row1 td { background: #fffbeb; }
.row1:hover td { background: #fffbeb; }
.rank { width: 28px; height: 28px; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; font-weight: 700; font-size: 13px; background: #f0f0f0; color: #888; }
.rank.rank0 { background: linear-gradient(135deg,#ff0050,#00f2ea); color: #fff; }
.rank.rank1 { background: #fce4ec; color: #ff0050; }
.rank.rank2 { background: #fff3e0; color: #f59e0b; }
.num { color: #333; font-weight: 500; font-variant-numeric: tabular-nums; }

.tag-cloud { display: flex; flex-wrap: wrap; gap: 10px 14px; }
.htag { cursor: pointer; color: #333; font-weight: 600; transition: all 0.2s; }
.htag:hover { color: #ff0050; }
.htag small { font-size: 11px; color: #aaa; font-weight: 400; margin-left: 4px; }

.music-list { display: flex; flex-direction: column; gap: 10px; }
.music-item { display: flex; align-items: center; gap: 12px; padding: 10px; border-radius: 10px; transition: background 0.15s; }
.music-item:hover { background: #fafafa; }
.mi-rank { width: 24px; font-size: 14px; font-weight: 700; color: #ccc; }
.mi-cover { font-size: 28px; }
.mi-info { flex: 1; display: flex; flex-direction: column; }
.mi-name { font-size: 13px; font-weight: 600; color: #333; }
.mi-artist { font-size: 11px; color: #aaa; }
.mi-uses { font-size: 12px; color: #666; }
</style>
