<template>
  <div class="my-creations">
    <div class="page-header">
      <h2 class="page-title">我的创作</h2>
      <p class="page-desc">管理您通过AI工具生成的所有创作内容</p>
    </div>

    <!-- 统计卡片 -->
    <div class="stat-cards">
      <div class="stat-card" v-for="stat in stats" :key="stat.label">
        <div class="stat-icon" :style="{ background: stat.bg }">
          <el-icon :size="20"><component :is="stat.icon" /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ stat.value }}</div>
          <div class="stat-label">{{ stat.label }}</div>
        </div>
      </div>
    </div>

    <!-- 筛选栏 -->
    <div class="filter-bar">
      <el-segmented v-model="activeTab" :options="tabs" size="default" />
      <div class="filter-actions">
        <el-select v-model="sortBy" placeholder="排序方式" size="default" style="width: 130px">
          <el-option label="最新优先" value="newest" />
          <el-option label="最早优先" value="oldest" />
          <el-option label="名称排序" value="name" />
        </el-select>
        <el-button type="primary" :icon="Plus">新建创作</el-button>
      </div>
    </div>

    <!-- 创作列表 -->
    <div class="creations-table" v-loading="loading">
      <el-table
        :data="filteredCreations"
        style="width: 100%"
        row-class-name="creation-row"
        @row-click="handleRowClick"
      >
        <el-table-column label="创作内容" min-width="280">
          <template #default="{ row }">
            <div class="creation-info">
              <div class="creation-thumb" :style="{ background: row.bgColor }">
                <el-icon :size="20"><component :is="row.icon" /></el-icon>
              </div>
              <div class="creation-detail">
                <div class="creation-name">{{ row.name }}</div>
                <div class="creation-type">{{ row.type }}</div>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="创建时间" width="150">
          <template #default="{ row }">
            <span class="time-text">{{ row.createTime }}</span>
          </template>
        </el-table-column>

        <el-table-column label="尺寸/时长" width="120">
          <template #default="{ row }">
            <span class="spec-text">{{ row.spec }}</span>
          </template>
        </el-table-column>

        <el-table-column label="状态" width="110">
          <template #default="{ row }">
            <el-tag
              :type="statusType(row.status)"
              size="small"
              effect="plain"
            >{{ row.status }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column label="使用次数" width="100" align="center">
          <template #default="{ row }">
            <span class="usage-count">{{ row.usageCount }}次</span>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <div class="row-actions" @click.stop>
              <el-button type="primary" link size="small" :icon="View">预览</el-button>
              <el-button type="primary" link size="small" :icon="Download">下载</el-button>
              <el-dropdown trigger="click">
                <el-button type="primary" link size="small" :icon="MoreFilled" />
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item :icon="Edit">重命名</el-dropdown-item>
                    <el-dropdown-item :icon="CopyDocument">复制</el-dropdown-item>
                    <el-dropdown-item :icon="Share">分享</el-dropdown-item>
                    <el-dropdown-item :icon="Delete" divided>删除</el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 空状态 -->
    <el-empty v-if="!loading && filteredCreations.length === 0" description="暂无创作内容，点击新建开始创作" />

    <!-- 分页 -->
    <div class="pagination-wrapper" v-if="filteredCreations.length > 0">
      <el-pagination
        v-model:current-page="currentPage"
        :page-size="pageSize"
        :total="filteredCreations.length"
        layout="total, prev, pager, next"
        background
        small
      />
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import {
  Plus,
  VideoCamera,
  PictureFilled,
  MagicStick,
  Timer,
  View,
  Download,
  MoreFilled,
  Edit,
  CopyDocument,
  Share,
  Delete
} from '@element-plus/icons-vue'

const loading = ref(false)
const activeTab = ref('全部')
const sortBy = ref('newest')
const currentPage = ref(1)
const pageSize = ref(10)

const tabs = ['全部', 'AI视频', '商品主图', '模特换衣', '手持图', '视频克隆']

const stats = [
  { label: '总创作数', value: 156, icon: MagicStick, bg: 'linear-gradient(135deg, #667eea, #764ba2)' },
  { label: '本月新增', value: 34, icon: Plus, bg: 'linear-gradient(135deg, #f093fb, #f5576c)' },
  { label: '已下载', value: 89, icon: Download, bg: 'linear-gradient(135deg, #4facfe, #00f2fe)' },
  { label: '生成中', value: 3, icon: Timer, bg: 'linear-gradient(135deg, #f6d365, #fda085)' },
]

const creations = ref([
  { id: 1, name: '夏季连衣裙模特展示视频', type: 'AI视频·Seedance', icon: VideoCamera, createTime: '2026-06-15 14:30', spec: '1080×1920 / 15s', status: '已完成', usageCount: 12, bgColor: 'linear-gradient(135deg, #a18cd1, #fbc2eb)' },
  { id: 2, name: '蓝牙耳机白色背景主图', type: '商品主图·妙做主图', icon: PictureFilled, createTime: '2026-06-15 10:15', spec: '800×800', status: '已完成', usageCount: 8, bgColor: 'linear-gradient(135deg, #fad0c4, #ffd1ff)' },
  { id: 3, name: '运动鞋模特上脚效果', type: '模特换衣·一键换衣', icon: MagicStick, createTime: '2026-06-14 16:45', spec: '1200×1600', status: '已完成', usageCount: 5, bgColor: 'linear-gradient(135deg, #a1c4fd, #c2e9fb)' },
  { id: 4, name: '瑜伽服AI模特手持图', type: '手持图·AI手持', icon: MagicStick, createTime: '2026-06-14 09:20', spec: '1200×1600', status: '已完成', usageCount: 3, bgColor: 'linear-gradient(135deg, #ffecd2, #fcb69f)' },
  { id: 5, name: '口红种草口播视频克隆', type: '视频克隆·一键克隆', icon: VideoCamera, createTime: '2026-06-13 18:00', spec: '1080×1920 / 30s', status: '生成中', usageCount: 0, bgColor: 'linear-gradient(135deg, #89f7fe, #66a6ff)' },
  { id: 6, name: '智能手表场景主图', type: '商品主图·妙做主图', icon: PictureFilled, createTime: '2026-06-13 11:30', spec: '800×800', status: '已完成', usageCount: 15, bgColor: 'linear-gradient(135deg, #d4fc79, #96e6a1)' },
  { id: 7, name: '碎花裙模特试穿效果', type: '模特换衣·一键换衣', icon: MagicStick, createTime: '2026-06-12 15:20', spec: '1200×1600', status: '已完成', usageCount: 7, bgColor: 'linear-gradient(135deg, #fccb90, #d57eeb)' },
  { id: 8, name: '宠物窝垫产品视频', type: 'AI视频·Seedance', icon: VideoCamera, createTime: '2026-06-12 08:45', spec: '1080×1920 / 20s', status: '已完成', usageCount: 4, bgColor: 'linear-gradient(135deg, #e0c3fc, #8ec5fc)' },
  { id: 9, name: '咖啡机户外场景图', type: '手持图·AI手持', icon: MagicStick, createTime: '2026-06-11 14:00', spec: '1200×1600', status: '失败', usageCount: 0, bgColor: 'linear-gradient(135deg, #f5576c, #f093fb)' },
  { id: 10, name: 'T恤图案设计主图', type: '商品主图·妙做主图', icon: PictureFilled, createTime: '2026-06-11 09:30', spec: '800×800', status: '已完成', usageCount: 9, bgColor: 'linear-gradient(135deg, #4facfe, #00f2fe)' },
  { id: 11, name: '护肤品牌宣传短视频', type: 'AI视频·Seedance', icon: VideoCamera, createTime: '2026-06-10 17:15', spec: '1920×1080 / 45s', status: '生成中', usageCount: 0, bgColor: 'linear-gradient(135deg, #fa709a, #fee140)' },
  { id: 12, name: '眼镜框模特佩戴图', type: '模特换衣·一键换衣', icon: MagicStick, createTime: '2026-06-10 11:00', spec: '1200×1600', status: '已完成', usageCount: 6, bgColor: 'linear-gradient(135deg, #30cfd0, #330867)' },
])

const filteredCreations = computed(() => {
  let items = creations.value
  if (activeTab.value !== '全部') {
    const typeMap = {
      'AI视频': 'AI视频',
      '商品主图': '商品主图',
      '模特换衣': '模特换衣',
      '手持图': '手持图',
      '视频克隆': '视频克隆',
    }
    items = items.filter(i => i.type.includes(typeMap[activeTab.value] || activeTab.value))
  }
  if (sortBy.value === 'newest') {
    items = [...items].sort((a, b) => b.id - a.id)
  } else if (sortBy.value === 'oldest') {
    items = [...items].sort((a, b) => a.id - b.id)
  } else if (sortBy.value === 'name') {
    items = [...items].sort((a, b) => a.name.localeCompare(b.name))
  }
  return items
})

const statusType = (status) => {
  const map = { '已完成': 'success', '生成中': 'warning', '失败': 'danger' }
  return map[status] || 'info'
}

const handleRowClick = (row) => {
  console.log('查看创作详情:', row.name)
}
</script>

<style scoped>
.my-creations {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 24px;
}

.page-title {
  font-size: 22px;
  font-weight: 700;
  color: #1a1a2e;
  margin: 0 0 4px;
}

.page-desc {
  font-size: 13px;
  color: #909399;
  margin: 0;
}

/* 统计卡片 */
.stat-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}

.stat-card {
  background: #fff;
  border-radius: 10px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 14px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.06);
  transition: transform 0.2s, box-shadow 0.2s;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #1a1a2e;
  line-height: 1;
}

.stat-label {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}

/* 筛选栏 */
.filter-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
  gap: 16px;
  flex-wrap: wrap;
}

.filter-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

/* 表格 */
.creations-table {
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.06);
  overflow: hidden;
  margin-bottom: 20px;
}

:deep(.creation-row) {
  cursor: pointer;
}

.creation-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.creation-thumb {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}

.creation-name {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
}

.creation-type {
  font-size: 12px;
  color: #909399;
  margin-top: 2px;
}

.time-text,
.spec-text {
  font-size: 13px;
  color: #606266;
}

.usage-count {
  font-size: 13px;
  color: #409eff;
  font-weight: 500;
}

.row-actions {
  display: flex;
  align-items: center;
  gap: 4px;
}

/* 分页 */
.pagination-wrapper {
  display: flex;
  justify-content: flex-end;
}

@media (max-width: 1200px) {
  .stat-cards { grid-template-columns: repeat(2, 1fr); }
}
</style>
