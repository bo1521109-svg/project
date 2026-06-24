<template>
  <div class="workbench-page">
    <h2 class="page-title">创作工作台</h2>

    <!-- 统计卡片 -->
    <div class="stat-cards">
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #667eea, #764ba2)">
          <el-icon :size="22"><Lightning /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">12,846</div>
          <div class="stat-label">创意素材库</div>
          <div class="stat-trend up">+18% <span>较上周</span></div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb, #f5576c)">
          <el-icon :size="22"><VideoCamera /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">3,421</div>
          <div class="stat-label">AI视频生成</div>
          <div class="stat-trend up">+32% <span>较上周</span></div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe, #00f2fe)">
          <el-icon :size="22"><Picture /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">8,920</div>
          <div class="stat-label">图片生成量</div>
          <div class="stat-trend up">+25% <span>较上周</span></div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: linear-gradient(135deg, #43e97b, #38f9d7)">
          <el-icon :size="22"><FolderOpened /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">2,156</div>
          <div class="stat-label">资料库素材</div>
          <div class="stat-trend up">+9% <span>较上周</span></div>
        </div>
      </div>
    </div>

    <!-- 快捷功能区 -->
    <div class="section">
      <h3 class="section-title">快捷功能</h3>
      <div class="feature-grid">
        <!-- 找创意 -->
        <div class="feature-card">
          <div class="card-header" style="background: linear-gradient(135deg, #667eea, #764ba2)">
            <el-icon :size="24"><Lightning /></el-icon>
            <span>找创意</span>
          </div>
          <div class="card-body">
            <div class="card-stat">
              <span class="card-stat-num">12,846</span>
              <span class="card-stat-label">素材总量</span>
            </div>
            <div class="card-links">
              <a class="card-link" @click="$router.push('/content/creative/natural-flow')">
                <el-icon><VideoPlay /></el-icon> 自然流/广告素材
              </a>
              <a class="card-link" @click="$router.push('/content/creative/viral-analysis')">
                <el-icon><TrendCharts /></el-icon> 爆款视频分析
              </a>
              <a class="card-link" @click="$router.push('/content/creative/selling-point')">
                <el-icon><Star /></el-icon> 视频卖点呈现
              </a>
            </div>
          </div>
        </div>

        <!-- AI视频 -->
        <div class="feature-card">
          <div class="card-header" style="background: linear-gradient(135deg, #f093fb, #f5576c)">
            <el-icon :size="24"><VideoCamera /></el-icon>
            <span>AI 视频</span>
          </div>
          <div class="card-body">
            <div class="card-stat">
              <span class="card-stat-num">3,421</span>
              <span class="card-stat-label">累计生成</span>
            </div>
            <div class="card-links">
              <a class="card-link" @click="$router.push('/content/ai-video/seedance')">
                <el-icon><MagicStick /></el-icon> Seedance2.0 / Sora2
              </a>
              <a class="card-link" @click="$router.push('/content/ai-video/auto-clip')">
                <el-icon><Scissor /></el-icon> 自动生成样片
              </a>
              <a class="card-link" @click="$router.push('/content/ai-video/clone')">
                <el-icon><CopyDocument /></el-icon> 一键克隆视频
              </a>
            </div>
          </div>
        </div>

        <!-- 去生图 -->
        <div class="feature-card">
          <div class="card-header" style="background: linear-gradient(135deg, #4facfe, #00f2fe)">
            <el-icon :size="24"><Picture /></el-icon>
            <span>去生图</span>
          </div>
          <div class="card-body">
            <div class="card-stat">
              <span class="card-stat-num">8,920</span>
              <span class="card-stat-label">累计生成</span>
            </div>
            <div class="card-links">
              <a class="card-link" @click="$router.push('/content/image-gen/product-main')">
                <el-icon><Goods /></el-icon> 妙做商品主图
              </a>
              <a class="card-link" @click="$router.push('/content/image-gen/model-swap')">
                <el-icon><Switch /></el-icon> 一键模特换衣
              </a>
              <a class="card-link" @click="$router.push('/content/image-gen/model-hold')">
                <el-icon><UserFilled /></el-icon> AI模特手持图
              </a>
            </div>
          </div>
        </div>

        <!-- 资料库 -->
        <div class="feature-card">
          <div class="card-header" style="background: linear-gradient(135deg, #43e97b, #38f9d7)">
            <el-icon :size="24"><FolderOpened /></el-icon>
            <span>资料库</span>
          </div>
          <div class="card-body">
            <div class="card-stat">
              <span class="card-stat-num">2,156</span>
              <span class="card-stat-label">素材总量</span>
            </div>
            <div class="card-links">
              <a class="card-link" @click="$router.push('/content/assets/my-product')">
                <el-icon><Goods /></el-icon> 我的产品
              </a>
              <a class="card-link" @click="$router.push('/content/assets/my-model')">
                <el-icon><UserFilled /></el-icon> 我的模特
              </a>
              <a class="card-link" @click="$router.push('/content/assets/my-material')">
                <el-icon><PictureFilled /></el-icon> 我的素材
              </a>
            </div>
          </div>
        </div>

        <!-- 我的 -->
        <div class="feature-card">
          <div class="card-header" style="background: linear-gradient(135deg, #fa709a, #fee140)">
            <el-icon :size="24"><Star /></el-icon>
            <span>我的</span>
          </div>
          <div class="card-body">
            <div class="card-stat">
              <span class="card-stat-num">156</span>
              <span class="card-stat-label">个人作品</span>
            </div>
            <div class="card-links">
              <a class="card-link" @click="$router.push('/my/favorites')">
                <el-icon><StarFilled /></el-icon> 我的收藏
              </a>
              <a class="card-link" @click="$router.push('/my/creations')">
                <el-icon><Edit /></el-icon> 我的创作
              </a>
              <a class="card-link" @click="$router.push('/purchase')">
                <el-icon><Wallet /></el-icon> 购买续费
              </a>
              <a class="card-link" @click="$router.push('/profile')">
                <el-icon><User /></el-icon> 账户中心
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 最近创作动态 -->
    <div class="section">
      <h3 class="section-title">最近创作动态</h3>
      <el-table :data="recentActivities" style="width: 100%" stripe>
        <el-table-column prop="time" label="时间" width="180" />
        <el-table-column prop="name" label="任务名称" min-width="200" />
        <el-table-column prop="module" label="所属模块" width="120">
          <template #default="{ row }">
            <el-tag :type="row.moduleType" size="small">{{ row.module }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.statusType" size="small">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="usage" label="使用次数" width="100" align="center" />
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import {
  Lightning, VideoCamera, Picture, FolderOpened, Star,
  VideoPlay, TrendCharts, MagicStick, Scissor, CopyDocument,
  Goods, Switch, UserFilled, PictureFilled, StarFilled,
  Edit, Wallet, User
} from '@element-plus/icons-vue'

const recentActivities = ref([
  { time: '2026-06-16 14:32', name: '夏季T恤爆款视频分析报告生成完成', module: '找创意', moduleType: 'primary', status: '已完成', statusType: 'success', usage: 128 },
  { time: '2026-06-16 13:15', name: '女士连衣裙AI视频生成（Seedance2.0）', module: 'AI视频', moduleType: 'danger', status: '生成中', statusType: 'warning', usage: 67 },
  { time: '2026-06-16 12:08', name: '运动鞋商品主图批量生成（12张）', module: '去生图', moduleType: '', status: '已完成', statusType: 'success', usage: 342 },
  { time: '2026-06-16 10:45', name: '男士西装模特换衣-模特A套装', module: '去生图', moduleType: '', status: '已完成', statusType: 'success', usage: 89 },
  { time: '2026-06-16 09:30', name: '新上传产品素材入库：春季新品系列', module: '资料库', moduleType: 'success', status: '已完成', statusType: 'success', usage: 45 },
  { time: '2026-06-16 08:12', name: '一键克隆视频模板：爆款广告风格', module: 'AI视频', moduleType: 'danger', status: '排队中', statusType: 'info', usage: 0 },
  { time: '2026-06-15 18:55', name: '收藏创意素材：海外博主家具展示合集', module: '我的', moduleType: 'warning', status: '已收藏', statusType: 'success', usage: 23 },
  { time: '2026-06-15 16:20', name: '自然流视频素材筛选：宠物用品类目', module: '找创意', moduleType: 'primary', status: '已完成', statusType: 'success', usage: 156 },
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
  cursor: default;
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
.stat-trend span { color: #909399; }

/* 区块 */
.section { margin-bottom: 28px; }
.section-title {
  font-size: 16px; font-weight: 600; color: #303133;
  margin: 0 0 16px; padding-left: 10px;
  border-left: 3px solid #409EFF;
}

/* 功能卡片网格 */
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
.card-link:hover {
  background: #f5f7fa; color: #409EFF;
}
.card-link .el-icon { font-size: 15px; }
</style>
