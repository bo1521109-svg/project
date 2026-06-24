<template>
  <div class="workbench-page">
    <h2 class="page-title">社媒工作台</h2>

    <!-- 统计卡片 -->
    <div class="stat-cards">
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #667eea, #764ba2)">
          <el-icon :size="22"><Connection /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">28</div>
          <div class="stat-label">绑定账号</div>
          <div class="stat-trend up">+3 <span>本月新增</span></div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb, #f5576c)">
          <el-icon :size="22"><Upload /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">47</div>
          <div class="stat-label">本月发布</div>
          <div class="stat-trend up">+15% <span>较上月</span></div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe, #00f2fe)">
          <el-icon :size="22"><ChatDotRound /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">1,286</div>
          <div class="stat-label">未读互动</div>
          <div class="stat-trend down">-8% <span>较上周</span></div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #43e97b, #38f9d7)">
          <el-icon :size="22"><User /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">89,420</div>
          <div class="stat-label">总粉丝数</div>
          <div class="stat-trend up">+22% <span>较上月</span></div>
        </div>
      </div>
    </div>

    <!-- 快捷功能区 -->
    <div class="section">
      <h3 class="section-title">核心功能</h3>
      <div class="feature-grid">
        <!-- 社媒平台 -->
        <div class="feature-card">
          <div class="card-header" style="background: linear-gradient(135deg, #667eea, #764ba2)">
            <el-icon :size="24"><Connection /></el-icon>
            <span>社媒平台</span>
            <el-tag size="small" effect="plain" style="margin-left: auto; color: #fff; border-color: rgba(255,255,255,0.5)">7 平台</el-tag>
          </div>
          <div class="card-body">
            <div class="platform-grid">
              <a class="platform-item" @click="$router.push('/social/platforms/tiktok')">
                <span class="platform-dot" style="background:#000"></span> TikTok
              </a>
              <a class="platform-item" @click="$router.push('/social/platforms/facebook')">
                <span class="platform-dot" style="background:#1877f2"></span> Facebook
              </a>
              <a class="platform-item" @click="$router.push('/social/platforms/instagram')">
                <span class="platform-dot" style="background:#e4405f"></span> Instagram
              </a>
              <a class="platform-item" @click="$router.push('/social/platforms/twitter')">
                <span class="platform-dot" style="background:#1da1f2"></span> Twitter/X
              </a>
              <a class="platform-item" @click="$router.push('/social/platforms/youtube')">
                <span class="platform-dot" style="background:#ff0000"></span> YouTube
              </a>
              <a class="platform-item" @click="$router.push('/social/platforms/pinterest')">
                <span class="platform-dot" style="background:#e60023"></span> Pinterest
              </a>
              <a class="platform-item" @click="$router.push('/social/platforms/reddit')">
                <span class="platform-dot" style="background:#ff4500"></span> Reddit
              </a>
            </div>
          </div>
        </div>

        <!-- 私域 -->
        <div class="feature-card">
          <div class="card-header" style="background: linear-gradient(135deg, #f093fb, #f5576c)">
            <el-icon :size="24"><Lock /></el-icon>
            <span>私域</span>
          </div>
          <div class="card-body">
            <div class="card-stat">
              <span class="card-stat-num">3,852</span>
              <span class="card-stat-label">私域联系人</span>
            </div>
            <div class="card-links">
              <a class="card-link" @click="$router.push('/social/private/whatsapp')">
                <el-icon><ChatDotSquare /></el-icon>
                <div>
                  <div class="link-title">What's App</div>
                  <div class="link-desc">2,341 联系人 · 今日活跃 128</div>
                </div>
              </a>
              <a class="card-link" @click="$router.push('/social/private/line')">
                <el-icon><ChatLineSquare /></el-icon>
                <div>
                  <div class="link-title">Line</div>
                  <div class="link-desc">1,511 联系人 · 今日活跃 86</div>
                </div>
              </a>
            </div>
          </div>
        </div>

        <!-- 数据看板 -->
        <div class="feature-card">
          <div class="card-header" style="background: linear-gradient(135deg, #4facfe, #00f2fe)">
            <el-icon :size="24"><TrendCharts /></el-icon>
            <span>数据看板</span>
          </div>
          <div class="card-body">
            <div class="mini-stats">
              <div class="mini-stat">
                <span class="mini-val">892K</span>
                <span class="mini-label">本月曝光</span>
              </div>
              <div class="mini-stat">
                <span class="mini-val">4.2%</span>
                <span class="mini-label">互动率</span>
              </div>
              <div class="mini-stat">
                <span class="mini-val">1.8%</span>
                <span class="mini-label">转化率</span>
              </div>
            </div>
            <div class="card-links" style="margin-top: 12px">
              <a class="card-link" @click="$router.push('/social/dashboard/overview')">
                <el-icon><DataAnalysis /></el-icon> 查看完整数据看板
              </a>
            </div>
          </div>
        </div>

        <!-- 发布管理 -->
        <div class="feature-card">
          <div class="card-header" style="background: linear-gradient(135deg, #43e97b, #38f9d7)">
            <el-icon :size="24"><Upload /></el-icon>
            <span>发布管理</span>
          </div>
          <div class="card-body">
            <div class="card-stat">
              <span class="card-stat-num">47</span>
              <span class="card-stat-label">本月已发布</span>
            </div>
            <div class="publish-queue">
              <div class="queue-item">
                <span class="queue-dot pending"></span>
                <span class="queue-name">待发布</span>
                <span class="queue-count">12</span>
              </div>
              <div class="queue-item">
                <span class="queue-dot reviewing"></span>
                <span class="queue-name">审核中</span>
                <span class="queue-count">3</span>
              </div>
              <div class="queue-item">
                <span class="queue-dot scheduled"></span>
                <span class="queue-name">已排期</span>
                <span class="queue-count">8</span>
              </div>
            </div>
            <div class="card-links" style="margin-top: 12px">
              <a class="card-link" @click="$router.push('/social/publish/manage')">
                <el-icon><Calendar /></el-icon> 管理发布预约
              </a>
            </div>
          </div>
        </div>

        <!-- 互动管理 -->
        <div class="feature-card">
          <div class="card-header" style="background: linear-gradient(135deg, #fa709a, #fee140)">
            <el-icon :size="24"><ChatDotRound /></el-icon>
            <span>互动管理</span>
          </div>
          <div class="card-body">
            <div class="card-stat">
              <span class="card-stat-num">1,286</span>
              <span class="card-stat-label">待处理互动</span>
            </div>
            <div class="card-links">
              <a class="card-link" @click="$router.push('/social/interaction/comments')">
                <el-icon><ChatLineSquare /></el-icon>
                <div>
                  <div class="link-title">评论互动</div>
                  <div class="link-desc">892 条待回复 · 12 条待审核</div>
                </div>
              </a>
              <a class="card-link" @click="$router.push('/social/interaction/direct-messages')">
                <el-icon><Message /></el-icon>
                <div>
                  <div class="link-title">私信互动</div>
                  <div class="link-desc">394 条未读 · 来自 6 平台</div>
                </div>
              </a>
            </div>
          </div>
        </div>

        <!-- 账号管理 -->
        <div class="feature-card">
          <div class="card-header" style="background: linear-gradient(135deg, #a18cd1, #fbc2eb)">
            <el-icon :size="24"><User /></el-icon>
            <span>账号管理</span>
          </div>
          <div class="card-body">
            <div class="card-stat">
              <span class="card-stat-num">28</span>
              <span class="card-stat-label">绑定账号</span>
            </div>
            <div class="account-breakdown">
              <div class="ab-item"><span class="ab-platform">TikTok</span><span class="ab-count">5</span></div>
              <div class="ab-item"><span class="ab-platform">Facebook</span><span class="ab-count">4</span></div>
              <div class="ab-item"><span class="ab-platform">Instagram</span><span class="ab-count">6</span></div>
              <div class="ab-item"><span class="ab-platform">YouTube</span><span class="ab-count">3</span></div>
              <div class="ab-item"><span class="ab-platform">其他</span><span class="ab-count">10</span></div>
            </div>
            <div class="card-links" style="margin-top: 12px">
              <a class="card-link" @click="$router.push('/social/accounts/manage')">
                <el-icon><Setting /></el-icon> 管理社媒账号
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 最近发布动态 -->
    <div class="section">
      <h3 class="section-title">最近发布动态</h3>
      <el-table :data="recentPosts" style="width: 100%" stripe>
        <el-table-column prop="time" label="发布时间" width="170" />
        <el-table-column prop="title" label="内容标题" min-width="220" />
        <el-table-column prop="platform" label="平台" width="120">
          <template #default="{ row }">
            <el-tag :type="row.platformType" size="small">{{ row.platform }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="type" label="类型" width="90">
          <template #default="{ row }">
            <el-tag size="small" effect="plain">{{ row.type }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.statusType" size="small">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="engagement" label="互动量" width="100" align="center" />
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import {
  Connection, Upload, ChatDotRound, User, Lock, TrendCharts,
  ChatDotSquare, ChatLineSquare, DataAnalysis, Calendar,
  Message, Setting
} from '@element-plus/icons-vue'

const recentPosts = ref([
  { time: '2026-06-16 15:30', title: 'Summer Collection 2026 - Lookbook Teaser', platform: 'Instagram', platformType: 'danger', type: 'Reel', status: '已发布', statusType: 'success', engagement: '2.4K' },
  { time: '2026-06-16 14:00', title: 'How to style our new denim jacket | Tutorial', platform: 'TikTok', platformType: '', type: '视频', status: '已发布', statusType: 'success', engagement: '8.7K' },
  { time: '2026-06-16 11:20', title: 'Flash Sale Alert - 50% off selected items!', platform: 'Facebook', platformType: 'primary', type: '帖子', status: '已发布', statusType: 'success', engagement: '1.2K' },
  { time: '2026-06-16 09:00', title: 'Behind the scenes: Product photoshoot day', platform: 'YouTube', platformType: 'danger', type: 'Shorts', status: '审核中', statusType: 'warning', engagement: '-' },
  { time: '2026-06-15 20:00', title: 'Customer review compilation - Best of June', platform: 'TikTok', platformType: '', type: '视频', status: '已发布', statusType: 'success', engagement: '15.3K' },
  { time: '2026-06-15 17:30', title: 'New arrivals: Eco-friendly accessories line', platform: 'Pinterest', platformType: 'danger', type: 'Pin', status: '已排期', statusType: 'info', engagement: '-' },
  { time: '2026-06-15 14:00', title: 'AMA Session: Our founder answers your questions', platform: 'Reddit', platformType: 'warning', type: '帖子', status: '已发布', statusType: 'success', engagement: '3.1K' },
  { time: '2026-06-15 10:00', title: 'Win free products - Summer Giveaway!', platform: 'Instagram', platformType: 'danger', type: 'Stories', status: '已发布', statusType: 'success', engagement: '5.6K' },
])
</script>

<style scoped>
.workbench-page {
  max-width: 1400px;
}
.page-title {
  font-size: 20px;
  font-weight: 600;
  color: #303133;
  margin: 0 0 20px;
}

/* 统计卡片 */
.stat-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 28px;
}
.stat-card {
  background: #fff;
  border-radius: 10px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
  transition: box-shadow 0.3s;
}
.stat-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.1); }
.stat-icon {
  width: 48px; height: 48px;
  border-radius: 10px;
  display: flex; align-items: center; justify-content: center;
  color: #fff; flex-shrink: 0;
}
.stat-value { font-size: 22px; font-weight: 700; color: #303133; }
.stat-label { font-size: 13px; color: #909399; margin-top: 2px; }
.stat-trend { font-size: 12px; margin-top: 4px; }
.stat-trend.up { color: #67c23a; }
.stat-trend.down { color: #f56c6c; }
.stat-trend span { color: #909399; }

/* 区块 */
.section { margin-bottom: 28px; }
.section-title {
  font-size: 16px; font-weight: 600; color: #303133;
  margin: 0 0 16px; padding-left: 10px;
  border-left: 3px solid #409EFF;
}

/* 功能卡片 */
.feature-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}
.feature-card {
  background: #fff;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
  transition: box-shadow 0.3s, transform 0.2s;
}
.feature-card:hover {
  box-shadow: 0 4px 20px rgba(0,0,0,0.1);
  transform: translateY(-2px);
}
.card-header {
  display: flex; align-items: center; gap: 10px;
  padding: 14px 18px; color: #fff;
  font-size: 16px; font-weight: 600;
}
.card-body { padding: 16px 18px 18px; }
.card-stat {
  display: flex; align-items: baseline; gap: 8px;
  margin-bottom: 14px;
}
.card-stat-num { font-size: 24px; font-weight: 700; color: #303133; }
.card-stat-label { font-size: 12px; color: #909399; }
.card-links { display: flex; flex-direction: column; gap: 6px; }
.card-link {
  display: flex; align-items: center; gap: 8px;
  padding: 8px 12px; border-radius: 6px;
  font-size: 13px; color: #606266; cursor: pointer;
  transition: all 0.2s; text-decoration: none;
}
.card-link:hover { background: #f5f7fa; color: #409EFF; }
.card-link .el-icon { font-size: 15px; flex-shrink: 0; }

.link-title { font-size: 13px; font-weight: 500; color: #303133; }
.link-desc { font-size: 11px; color: #909399; margin-top: 2px; }

/* 平台网格 */
.platform-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
}
.platform-item {
  display: flex; align-items: center; gap: 6px;
  padding: 6px 8px; border-radius: 6px;
  font-size: 12px; color: #606266; cursor: pointer;
  transition: all 0.2s; text-decoration: none;
  background: #f5f7fa;
}
.platform-item:hover { background: #ecf5ff; color: #409EFF; }
.platform-dot {
  width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0;
}

/* 迷你统计 */
.mini-stats {
  display: grid; grid-template-columns: repeat(3, 1fr);
  gap: 12px; text-align: center;
}
.mini-stat {
  padding: 10px 6px; background: #f5f7fa;
  border-radius: 8px;
}
.mini-val { font-size: 16px; font-weight: 700; color: #303133; display: block; }
.mini-label { font-size: 11px; color: #909399; margin-top: 4px; display: block; }

/* 发布队列 */
.publish-queue { display: flex; flex-direction: column; gap: 8px; }
.queue-item {
  display: flex; align-items: center; gap: 10px;
  padding: 8px 12px; background: #f5f7fa;
  border-radius: 6px; font-size: 13px;
}
.queue-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
.queue-dot.pending { background: #e6a23c; }
.queue-dot.reviewing { background: #409EFF; }
.queue-dot.scheduled { background: #67c23a; }
.queue-name { color: #606266; flex: 1; }
.queue-count { font-weight: 600; color: #303133; }

/* 账号分布 */
.account-breakdown { display: flex; flex-direction: column; gap: 6px; }
.ab-item {
  display: flex; justify-content: space-between; align-items: center;
  padding: 6px 10px; background: #f5f7fa;
  border-radius: 4px; font-size: 12px;
}
.ab-platform { color: #606266; }
.ab-count { font-weight: 600; color: #303133; }
</style>
