<template>
  <div class="template-card" :class="{ 'is-popular': template.popularity >= 90 }">
    <!-- 热门标记 -->
    <div v-if="template.popularity >= 90" class="hot-badge">
      <el-icon><StarFilled /></el-icon>
      <span>热门</span>
    </div>

    <!-- 收藏按钮 -->
    <button
      class="fav-btn"
      :class="{ collected: collected }"
      @click.stop="$emit('toggle-favorite', template)"
    >
      <el-icon :size="18">
        <StarFilled v-if="collected" />
        <Star v-else />
      </el-icon>
    </button>

    <!-- 图片区 -->
    <div class="card-image-wrap">
      <el-image
        :src="template.previewImage"
        fit="cover"
        class="card-image"
        :alt="template.name"
      >
        <template #placeholder>
          <div class="image-skeleton">
            <div class="skeleton-shimmer" />
          </div>
        </template>
        <template #error>
          <div class="image-skeleton">
            <el-icon :size="36"><PictureFilled /></el-icon>
          </div>
        </template>
      </el-image>

      <!-- 图片遮罩层 -->
      <div class="image-overlay">
        <el-button type="primary" size="default" round @click.stop="$emit('use', template)">
          <el-icon><Plus /></el-icon>
          立即使用
        </el-button>
        <el-button size="default" round class="btn-preview" @click.stop="$emit('preview', template)">
          <el-icon><View /></el-icon>
          预览
        </el-button>
      </div>

      <!-- 价格标签 -->
      <span class="price-badge" :class="{ free: template.isFree }">
        {{ template.isFree ? '免费' : template.price }}
      </span>
    </div>

    <!-- 信息区 -->
    <div class="card-body">
      <div class="card-header">
        <h4 class="card-title">{{ template.name }}</h4>
        <span class="card-category">{{ template.categoryLabel }}</span>
      </div>

      <p class="card-desc">{{ template.description }}</p>

      <!-- 功能标签 -->
      <div class="card-tags">
        <span
          v-for="tag in template.tags"
          :key="tag"
          class="tag-item"
        >{{ tag }}</span>
      </div>

      <!-- 底部统计 -->
      <div class="card-footer">
        <div class="card-stats">
          <span class="stat-item">
            <el-icon :size="13"><Download /></el-icon>
            {{ formatUsage(template.usageCount) }}
          </span>
          <span class="stat-item" v-if="template.popularity >= 80">
            <el-icon :size="13" color="#f56c6c"><TrendCharts /></el-icon>
            热门 {{ template.popularity }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { PictureFilled, View, StarFilled, Star, Download, TrendCharts, Plus } from '@element-plus/icons-vue'

defineProps({
  template: { type: Object, required: true },
  collected: { type: Boolean, default: false }
})

defineEmits(['preview', 'use', 'toggle-favorite'])

function formatUsage(count) {
  if (count >= 10000) return (count / 10000).toFixed(1) + 'w'
  if (count >= 1000) return (count / 1000).toFixed(1) + 'k'
  return String(count)
}
</script>

<style scoped>
.template-card {
  position: relative;
  background: #fff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04), 0 1px 2px rgba(0, 0, 0, 0.03);
  border: 1px solid rgba(0, 0, 0, 0.04);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.template-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08), 0 8px 16px rgba(0, 0, 0, 0.04);
  border-color: rgba(64, 158, 255, 0.15);
}

/* 热门角标 */
.hot-badge {
  position: absolute;
  top: 0;
  left: 0;
  z-index: 10;
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 5px 14px 5px 12px;
  background: linear-gradient(135deg, #ff6b6b, #ee5a24);
  color: #fff;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.5px;
  border-radius: 0 0 12px 0;
}

/* 收藏按钮 */
.fav-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  z-index: 11;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: none;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(4px);
  color: #909399;
  cursor: pointer;
  transition: all 0.25s;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
}
.fav-btn:hover { transform: scale(1.15); background: #fff; }
.fav-btn.collected { color: #f56c6c; background: rgba(245, 108, 108, 0.15); }
.fav-btn.collected:hover { background: rgba(245, 108, 108, 0.25); }

/* 图片 */
.card-image-wrap {
  position: relative;
  height: 200px;
  overflow: hidden;
  background: #f8f9fc;
}

.card-image {
  width: 100%;
  height: 100%;
  transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
}

.template-card:hover .card-image {
  transform: scale(1.06);
}

.image-skeleton {
  width: 100%;
  height: 200px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e7ed 100%);
  color: #c0c4cc;
}

/* 图片悬浮遮罩 */
.image-overlay {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.55) 0%, rgba(0, 0, 0, 0.15) 60%, transparent 100%);
  opacity: 0;
  transition: opacity 0.35s ease;
  flex-direction: column;
}

.template-card:hover .image-overlay {
  opacity: 1;
}

.image-overlay .btn-preview {
  background: rgba(255, 255, 255, 0.2) !important;
  border: 1px solid rgba(255, 255, 255, 0.3) !important;
  color: #fff !important;
  backdrop-filter: blur(8px);
}

.image-overlay .btn-preview:hover {
  background: rgba(255, 255, 255, 0.3) !important;
}

/* 价格 */
.price-badge {
  position: absolute;
  top: 12px;
  right: 50px;
  padding: 5px 14px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 700;
  background: rgba(245, 108, 108, 0.92);
  color: #fff;
  backdrop-filter: blur(8px);
  letter-spacing: 0.5px;
}

.price-badge.free {
  background: linear-gradient(135deg, #52c41a, #73d13d);
}

/* 主体 */
.card-body { padding: 18px 20px 16px; }

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  margin-bottom: 8px;
}

.card-title {
  margin: 0;
  font-size: 16px;
  font-weight: 700;
  color: #1a1a2e;
  letter-spacing: -0.2px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  flex: 1;
}

.card-category {
  font-size: 11px;
  color: #909399;
  background: #f5f7fa;
  padding: 3px 10px;
  border-radius: 10px;
  flex-shrink: 0;
}

.card-desc {
  margin: 0 0 12px;
  font-size: 13px;
  color: #6b7280;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* 标签 */
.card-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 14px;
}

.tag-item {
  font-size: 11px;
  padding: 3px 10px;
  border-radius: 6px;
  background: linear-gradient(135deg, #ecf5ff 0%, #e8f4fd 100%);
  color: #409eff;
  font-weight: 500;
}

/* 底部 */
.card-footer {
  padding-top: 12px;
  border-top: 1px solid #f0f0f0;
}

.card-stats {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  color: #909399;
}
</style>
