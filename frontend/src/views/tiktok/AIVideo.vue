<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">AI 视频</h2>
      <div class="header-actions">
        <el-input v-model="search" placeholder="搜索AI视频..." prefix-icon="Search" clearable class="search-inline" />
        <div class="pill-group">
          <span class="pill" :class="{ active: sortBy === 'hot' }" @click="sortBy = 'hot'">热门</span>
          <span class="pill" :class="{ active: sortBy === 'new' }" @click="sortBy = 'new'">最新</span>
          <span class="pill" :class="{ active: sortBy === 'trending' }" @click="sortBy = 'trending'">飙升</span>
        </div>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-row">
      <div class="stat-card">
        <div class="sc-icon" style="background:#f0f0ff;"><el-icon><VideoPlay /></el-icon></div>
        <div class="sc-info">
          <div class="sc-val">12.8万</div>
          <div class="sc-label">AI生成视频总数</div>
        </div>
        <div class="sc-trend up">+23.5%</div>
      </div>
      <div class="stat-card">
        <div class="sc-icon" style="background:#f0fff4;"><el-icon><View /></el-icon></div>
        <div class="sc-info">
          <div class="sc-val">2.3亿</div>
          <div class="sc-label">总播放量</div>
        </div>
        <div class="sc-trend up">+18.2%</div>
      </div>
      <div class="stat-card">
        <div class="sc-icon" style="background:#fff7f0;"><el-icon><Star /></el-icon></div>
        <div class="sc-info">
          <div class="sc-val">890万</div>
          <div class="sc-label">总互动量</div>
        </div>
        <div class="sc-trend up">+31.7%</div>
      </div>
      <div class="stat-card">
        <div class="sc-icon" style="background:#f5f0ff;"><el-icon><TrendCharts /></el-icon></div>
        <div class="sc-info">
          <div class="sc-val">6.8%</div>
          <div class="sc-label">平均互动率</div>
        </div>
        <div class="sc-trend up">+1.2%</div>
      </div>
    </div>

    <!-- 热门AI工具 -->
    <div class="tools-section">
      <h3 class="section-title">热门 AI 工具话题</h3>
      <div class="tools-scroll">
        <div class="tool-card" v-for="t in tools" :key="t.name">
          <span class="tool-rank" :class="'rank-' + t.rank" v-if="t.rank <= 3">{{ t.rank }}</span>
          <span class="tool-emoji">{{ t.emoji }}</span>
          <div class="tool-info">
            <div class="tool-name">{{ t.name }}</div>
            <div class="tool-videos">{{ t.videos }} 个视频</div>
          </div>
          <div class="tool-growth">
            <span class="growth-up">+{{ t.growth }}%</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 视频列表 -->
    <div class="video-section">
      <h3 class="section-title">AI 生成热门视频</h3>
      <div class="video-grid">
        <div class="video-card" v-for="(v, i) in videos" :key="i">
          <div class="vc-thumb" :style="{ background: v.bg }">
            <span class="vc-emoji">{{ v.emoji }}</span>
            <div class="vc-duration">{{ v.duration }}</div>
            <div class="vc-rank" v-if="i < 3">{{ i + 1 }}</div>
          </div>
          <div class="vc-body">
            <div class="vc-title">{{ v.title }}</div>
            <div class="vc-tool">{{ v.tool }}</div>
            <div class="vc-stats">
              <div class="vcs-item">
                <span class="vcs-val">{{ v.plays }}</span>
                <span class="vcs-label">播放</span>
              </div>
              <div class="vcs-item">
                <span class="vcs-val">{{ v.likes }}</span>
                <span class="vcs-label">点赞</span>
              </div>
              <div class="vcs-item">
                <span class="vcs-val">{{ v.comments }}</span>
                <span class="vcs-label">评论</span>
              </div>
              <div class="vcs-item">
                <span class="vcs-val">{{ v.shares }}</span>
                <span class="vcs-label">分享</span>
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

const search = ref('')
const sortBy = ref('hot')

const tools = [
  { rank: 1, name: 'Sora', emoji: '🎬', videos: 15600, growth: 156 },
  { rank: 2, name: 'Runway Gen-3', emoji: '🚀', videos: 12300, growth: 98 },
  { rank: 3, name: 'Pika Labs', emoji: '✨', videos: 8900, growth: 67 },
  { rank: 4, name: 'Kling', emoji: '🎯', videos: 7200, growth: 45 },
  { rank: 5, name: 'Hailuo AI', emoji: '🌊', videos: 5400, growth: 32 },
  { rank: 6, name: 'Dream Machine', emoji: '💭', videos: 4100, growth: 28 }
]

const videos = ref([
  { title: 'Sora生成：赛博朋克城市夜景，霓虹灯下的东京街头', tool: 'Sora', duration: '0:28', bg: '#1a1a2e', emoji: '🌃', plays: '56.2万', likes: '4.8万', comments: '2.1k', shares: '3.5k' },
  { title: 'AI生成超写实美食广告，看完直接下单', tool: 'Runway', duration: '0:15', bg: '#2d1b0e', emoji: '🍔', plays: '89.1万', likes: '7.2万', comments: '3.8k', shares: '5.6k' },
  { title: 'Midjourney+Kling制作动漫风格产品展示', tool: 'Kling', duration: '0:22', bg: '#1a0a2e', emoji: '🎨', plays: '34.5万', likes: '3.1万', comments: '1.5k', shares: '2.1k' },
  { title: 'Pika一键生成电商产品视频，效果惊艳', tool: 'Pika', duration: '0:18', bg: '#0a1a2e', emoji: '📦', plays: '67.8万', likes: '5.6万', comments: '2.9k', shares: '4.2k' },
  { title: 'Hailuo AI生成自然风光大片，画面太美了', tool: 'Hailuo', duration: '0:35', bg: '#1a2e0a', emoji: '🏔️', plays: '45.3万', likes: '3.9万', comments: '1.8k', shares: '2.8k' },
  { title: 'AI视频制作教程：从0到1用Sora做带货视频', tool: 'Sora', duration: '0:42', bg: '#2e0a1a', emoji: '📚', plays: '123万', likes: '9.5万', comments: '5.2k', shares: '8.1k' },
  { title: 'Runway Gen-3生成3D卡通角色，效果炸裂', tool: 'Runway', duration: '0:20', bg: '#0a2e2e', emoji: '🤖', plays: '78.9万', likes: '6.7万', comments: '3.3k', shares: '4.9k' },
  { title: 'AI复活老照片变视频，感动千万网友', tool: 'Dream Machine', duration: '0:25', bg: '#2e2e0a', emoji: '📷', plays: '256万', likes: '18.2万', comments: '8.5k', shares: '12.3k' },
  { title: '跨境电商必看：AI生成多语言产品视频', tool: 'Pika', duration: '0:30', bg: '#1a1a2e', emoji: '🌍', plays: '42.1万', likes: '3.5万', comments: '1.7k', shares: '2.4k' },
  { title: 'Sora最新功能：文字生成超长连贯视频', tool: 'Sora', duration: '1:02', bg: '#0a0a2e', emoji: '🎥', plays: '189万', likes: '14.5万', comments: '7.1k', shares: '10.8k' },
  { title: 'AI视频+AI配音，一人搞定整个视频团队', tool: 'Runway', duration: '0:38', bg: '#2e0a0a', emoji: '🎤', plays: '56.7万', likes: '4.9万', comments: '2.4k', shares: '3.1k' },
  { title: '用AI把产品图片变成3D旋转展示视频', tool: 'Kling', duration: '0:16', bg: '#0a2e1a', emoji: '🔄', plays: '34.8万', likes: '2.8万', comments: '1.2k', shares: '1.9k' }
])
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.page-title { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0; }
.header-actions { display: flex; align-items: center; gap: 16px; }
.pill-group { display: flex; background: #fff; border-radius: 10px; padding: 3px; border: 1px solid #e5e7eb; }
.pill { padding: 6px 16px; border-radius: 8px; font-size: 13px; cursor: pointer; color: #666; transition: all 0.2s; }
.pill.active { background: linear-gradient(135deg, #7c4dff, #9b7ff7); color: #fff; }
.search-inline { width: 200px; }

.stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; margin-bottom: 20px; }
.stat-card { display: flex; align-items: center; gap: 14px; background: #fff; padding: 16px 20px; border-radius: 14px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
.sc-icon { width: 44px; height: 44px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: #555; flex-shrink: 0; }
.sc-info { flex: 1; }
.sc-val { font-size: 20px; font-weight: 700; color: #1a1a1a; }
.sc-label { font-size: 11px; color: #999; }
.sc-trend { font-size: 12px; font-weight: 600; padding: 2px 8px; border-radius: 6px; }
.sc-trend.up { color: #16a34a; background: #f0fdf4; }

.tools-section { margin-bottom: 20px; }
.section-title { font-size: 16px; font-weight: 700; color: #1a1a1a; margin: 0 0 12px; }
.tools-scroll { display: flex; gap: 12px; }
.tool-card { display: flex; align-items: center; gap: 10px; background: #fff; padding: 12px 16px; border-radius: 12px; min-width: 200px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); transition: all 0.2s; cursor: pointer; }
.tool-card:hover { transform: translateY(-2px); box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
.tool-rank { width: 22px; height: 22px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700; color: #fff; }
.tool-rank.rank-1 { background: linear-gradient(135deg, #ffd700, #ffb800); }
.tool-rank.rank-2 { background: linear-gradient(135deg, #c0c0c0, #a0a0a0); }
.tool-rank.rank-3 { background: linear-gradient(135deg, #cd7f32, #b8702a); }
.tool-emoji { font-size: 24px; }
.tool-info { flex: 1; }
.tool-name { font-size: 13px; font-weight: 600; color: #333; }
.tool-videos { font-size: 11px; color: #999; }
.tool-growth {  }
.growth-up { font-size: 12px; font-weight: 600; color: #16a34a; }

.video-section {  }
.video-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; }
.video-card { background: #fff; border-radius: 16px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.04); transition: all 0.2s; cursor: pointer; }
.video-card:hover { transform: translateY(-4px); box-shadow: 0 8px 25px rgba(0,0,0,0.08); }
.vc-thumb { height: 150px; display: flex; align-items: center; justify-content: center; position: relative; }
.vc-emoji { font-size: 48px; }
.vc-duration { position: absolute; bottom: 8px; right: 8px; font-size: 11px; padding: 2px 6px; background: rgba(0,0,0,0.6); color: #fff; border-radius: 4px; backdrop-filter: blur(4px); }
.vc-rank { position: absolute; top: 8px; left: 8px; width: 24px; height: 24px; background: linear-gradient(135deg, #ffd700, #ff8c00); color: #fff; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700; }
.vc-body { padding: 14px; }
.vc-title { font-size: 13px; font-weight: 600; color: #1a1a1a; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: 6px; }
.vc-tool { font-size: 11px; color: #7c4dff; font-weight: 500; margin-bottom: 10px; }
.vc-stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 4px; }
.vcs-item { text-align: center; }
.vcs-val { font-size: 13px; font-weight: 700; color: #333; display: block; }
.vcs-label { font-size: 10px; color: #bbb; }
</style>
