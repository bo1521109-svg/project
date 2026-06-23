<template>
  <div class="ecosystem-page">
    <!-- ====== 顶部：页面标题区 ====== -->
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">生态服务</h1>
        <p class="page-subtitle">连接优质服务商 · 加速出海增长</p>
      </div>
      <div class="header-right">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索服务名称、类别..."
          clearable
          class="search-input"
          @input="onSearchDebounce"
          @clear="activeCategoryId = ''"
        >
          <template #prefix><el-icon :size="14"><Search /></el-icon></template>
        </el-input>
      </div>
    </div>

    <!-- ====== 第一部分：服务分类快捷导航 ====== -->
    <div class="section">
      <div class="category-grid">
        <div
          v-for="cat in categories"
          :key="cat.id"
          class="cat-card"
          :class="{ active: activeCategoryId === cat.id }"
          @click="onCategoryClick(cat.id)"
        >
          <span class="cat-icon">{{ cat.icon }}</span>
          <div class="cat-info">
            <span class="cat-name">{{ cat.name }}</span>
            <span class="cat-count">{{ cat.count }} 家</span>
          </div>
        </div>
      </div>
    </div>

    <!-- ====== 第二部分：精选推荐 ====== -->
    <div class="section" v-if="featuredProviders.length">
      <div class="section-header">
        <h2 class="section-title">精选推荐</h2>
        <span class="section-badge">平台严选服务商</span>
      </div>
      <div class="featured-scroll">
        <div
          v-for="p in featuredProviders"
          :key="p.id"
          class="featured-card"
          @click="openDetail(p)"
        >
          <!-- 头部：Logo + 名称 -->
          <div class="fc-head">
            <span class="fc-logo">{{ p.logo }}</span>
            <div class="fc-title-row">
              <h4 class="fc-name">{{ p.name }}</h4>
              <span v-if="p.verified" class="verified-tag">官方合作</span>
            </div>
          </div>
          <!-- 评分 -->
          <div class="fc-rating">
            <span class="stars" v-html="renderStars(p.rating)" />
            <span class="rating-score">{{ p.rating }}</span>
            <span class="rating-count">({{ p.reviewCount }})</span>
          </div>
          <!-- 描述 -->
          <p class="fc-desc">{{ p.description }}</p>
          <!-- 标签 -->
          <div class="fc-tags">
            <span v-for="t in p.tags" :key="t" class="fc-tag">{{ t }}</span>
          </div>
          <!-- 按钮 -->
          <el-button class="fc-btn" size="small" @click.stop="openConnect(p)">查看详情</el-button>
        </div>
      </div>
    </div>

    <!-- ====== 第三部分：全部服务商列表 ====== -->
    <div class="section">
      <div class="section-header">
        <h2 class="section-title">全部服务商</h2>
        <el-select v-model="sortBy" size="small" class="sort-select" @change="onSortChange">
          <el-option label="推荐优先" value="recommended" />
          <el-option label="评分最高" value="rating" />
          <el-option label="合作最多" value="cooperation" />
        </el-select>
      </div>

      <!-- 简约筛选条 -->
      <div class="provider-filter-bar">
        <button
          class="pfb-tab"
          :class="{ active: activeCategoryId === '' }"
          @click="onCategoryClick('')"
        >全部</button>
        <button
          v-for="cat in categories"
          :key="cat.id"
          class="pfb-tab"
          :class="{ active: activeCategoryId === cat.id }"
          @click="onCategoryClick(cat.id)"
        >
          <span class="pfb-icon">{{ cat.icon }}</span>
          <span>{{ cat.name }}</span>
        </button>
      </div>

      <!-- 服务商列表（简约行式卡片） -->
      <div class="provider-list" v-if="filteredProviders.length">
        <div
          v-for="p in filteredProviders"
          :key="p.id"
          class="provider-row"
          @click="openDetail(p)"
        >
          <div class="pr-row-left">
            <span class="pr-row-logo">{{ p.logo }}</span>
            <div class="pr-row-info">
              <div class="pr-row-name-line">
                <span class="pr-row-name">{{ p.name }}</span>
                <span v-if="p.verified" class="pr-row-badge">认证</span>
              </div>
              <div class="pr-row-meta">
                <span class="pr-row-cat">{{ p.category }}</span>
                <span class="pr-row-divider">·</span>
                <span class="stars-inline" v-html="renderStars(p.rating)" />
                <span class="pr-row-rating">{{ p.rating }}</span>
                <span class="pr-row-divider">·</span>
                <span class="pr-row-reviews">{{ p.reviewCount }} 评价</span>
              </div>
            </div>
          </div>
          <div class="pr-row-right">
            <p class="pr-row-desc">{{ p.description }}</p>
            <button class="pr-row-btn" @click.stop="openConnect(p)">连接</button>
          </div>
        </div>
      </div>
      <div v-else class="empty-providers">
        <span class="empty-icon">🔍</span>
        <p class="empty-text">未找到匹配的服务商</p>
        <p class="empty-hint">尝试调整筛选条件或搜索关键词</p>
      </div>
    </div>

    <!-- ====== 第四部分：生态动态 ====== -->
    <div class="section" v-if="news.length">
      <div class="section-header">
        <h2 class="section-title">生态动态</h2>
        <span class="section-hint">服务商最新资讯</span>
      </div>
      <div class="news-scroll">
        <div v-for="item in news" :key="item.id" class="news-card">
          <span class="news-tag" :class="'tag-' + item.tag">{{ item.tag }}</span>
          <p class="news-title">{{ item.title }}</p>
          <div class="news-footer">
            <span class="news-provider">{{ item.providerName }}</span>
            <span class="news-time">{{ item.time }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- ====== 连接弹窗 ====== -->
    <el-dialog
      v-model="connectVisible"
      title="立即连接"
      width="420px"
      class="connect-dialog"
      destroy-on-close
    >
      <template v-if="connectProvider">
        <div class="connect-body">
          <div class="conn-provider">
            <span class="conn-logo">{{ connectProvider.logo }}</span>
            <div>
              <span class="conn-name">{{ connectProvider.name }}</span>
              <span class="conn-cat">{{ connectProvider.category }}</span>
            </div>
          </div>
          <div class="conn-divider" />
          <p class="conn-intro">请通过以下方式联系我们，快速开启合作：</p>
          <div class="conn-items">
            <div class="conn-item" v-if="connectProvider.contact.email">
              <span class="conn-label">📧 邮箱</span>
              <span class="conn-value">{{ connectProvider.contact.email }}</span>
            </div>
            <div class="conn-item" v-if="connectProvider.contact.website">
              <span class="conn-label">🌍 官网</span>
              <span class="conn-value">{{ connectProvider.contact.website }}</span>
            </div>
            <div class="conn-item" v-if="connectProvider.contact.wechat">
              <span class="conn-label">💬 微信</span>
              <span class="conn-value">{{ connectProvider.contact.wechat }}</span>
            </div>
          </div>
        </div>
      </template>
      <template #footer>
        <el-button @click="connectVisible = false">关闭</el-button>
        <el-button type="primary" @click="connectVisible = false">已记录，稍后联系</el-button>
      </template>
    </el-dialog>

    <!-- ====== 详情弹窗 ====== -->
    <el-dialog
      v-model="detailVisible"
      width="520px"
      class="detail-dialog"
      destroy-on-close
    >
      <template #header>
        <div class="detail-dialog-header" v-if="detailProvider">
          <span class="dd-logo">{{ detailProvider.logo }}</span>
          <div>
            <span class="dd-name">{{ detailProvider.name }}</span>
            <div class="dd-meta">
              <span class="dd-cat">{{ detailProvider.category }}</span>
              <span v-if="detailProvider.verified" class="dd-verified">✓ 官方合作</span>
            </div>
          </div>
        </div>
      </template>
      <template v-if="detailProvider">
        <div class="dd-body">
          <!-- 评分 -->
          <div class="dd-rating-row">
            <span class="dd-stars" v-html="renderStars(detailProvider.rating)" />
            <span class="dd-rating">{{ detailProvider.rating }}</span>
            <span class="dd-reviews">({{ detailProvider.reviewCount }} 评价)</span>
            <span class="dd-coop">· {{ detailProvider.cooperationCount }} 次合作</span>
          </div>
          <!-- 完整描述 -->
          <div class="dd-section">
            <h4 class="dd-section-title">服务介绍</h4>
            <p class="dd-desc">{{ detailProvider.fullDescription }}</p>
          </div>
          <!-- 标签 -->
          <div class="dd-section">
            <h4 class="dd-section-title">服务标签</h4>
            <div class="dd-tags">
              <span v-for="t in detailProvider.tags" :key="t" class="dd-tag">{{ t }}</span>
            </div>
          </div>
          <!-- 基本信息 -->
          <div class="dd-section">
            <h4 class="dd-section-title">基本信息</h4>
            <div class="dd-info-grid">
              <span class="dd-info-item"><b>成立年份</b> {{ detailProvider.established }} 年</span>
              <span class="dd-info-item"><b>合作次数</b> {{ detailProvider.cooperationCount }}+</span>
              <span class="dd-info-item"><b>评分</b> {{ detailProvider.rating }}/5.0</span>
              <span class="dd-info-item"><b>评价数</b> {{ detailProvider.reviewCount }} 条</span>
            </div>
          </div>
        </div>
      </template>
      <template #footer>
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button type="primary" @click="detailVisible = false; openConnect(detailProvider)">立即连接</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
/**
 * 生态服务页面
 *
 * 功能：
 * - 8 个分类快捷导航
 * - 精选推荐（横向滚动）
 * - 全部服务商（分类筛选 + 搜索 + 排序 + 3列卡片网格）
 * - 生态动态（横向滚动）
 * - 连接弹窗 + 详情弹窗
 *
 * 数据来源：frontend/src/api/overseas.js → getEcosystemData()
 */

import { ref, computed } from 'vue'
import { Search } from '@element-plus/icons-vue'
import { getEcosystemData, getEcosystemProviders } from '@/api/overseas'

// ====== 数据 ======
const { categories, providers, featuredProviders, news } = getEcosystemData()

// ====== 状态 ======
const searchKeyword = ref('')
const activeCategoryId = ref('')
const sortBy = ref('recommended')

const connectVisible = ref(false)
const connectProvider = ref(null)

const detailVisible = ref(false)
const detailProvider = ref(null)

// ====== 过滤后的服务商 ======
const filteredProviders = computed(() =>
  getEcosystemProviders({
    categoryId: activeCategoryId.value,
    keyword: searchKeyword.value,
    sortBy: sortBy.value
  })
)

// ====== 分类点击 ======
function onCategoryClick(catId) {
  activeCategoryId.value = activeCategoryId.value === catId ? '' : catId
}

// ====== 搜索防抖 ======
let searchTimer = null
function onSearchDebounce() {
  if (searchTimer) clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {}, 200)
}

// ====== 排序切换 ======
function onSortChange() {}

// ====== 打开连接弹窗 ======
function openConnect(provider) {
  connectProvider.value = provider
  connectVisible.value = true
}

// ====== 打开详情弹窗 ======
function openDetail(provider) {
  detailProvider.value = provider
  detailVisible.value = true
}

// ====== 渲染星级 ======
function renderStars(rating) {
  const full = Math.floor(rating)
  const half = rating - full >= 0.5 && rating - full < 1 ? 1 : 0
  const empty = 5 - full - half
  return (
    '<span class="star full">' + '★'.repeat(full) + '</span>' +
    (half ? '<span class="star half">★</span>' : '') +
    '<span class="star empty">' + '★'.repeat(empty) + '</span>'
  )
}
</script>

<style scoped>
.ecosystem-page {
  max-width: 1440px;
  margin: 0 auto;
  min-height: 100vh;
}

/* ====== 页面标题 ====== */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 32px;
  gap: 20px;
  flex-wrap: wrap;
}
.header-left { display: flex; flex-direction: column; gap: 6px; }
.page-title { margin: 0; font-size: 28px; font-weight: 700; color: #1A2A3A; letter-spacing: -0.3px; }
.page-subtitle { margin: 0; font-size: 14px; color: #8A9AA8; }
.header-right { flex-shrink: 0; }
.search-input { width: 300px; }

/* ====== 章节 ====== */
.section { margin-bottom: 40px; }
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 18px;
  flex-wrap: wrap;
  gap: 12px;
}
.section-title {
  margin: 0; font-size: 18px; font-weight: 600; color: #1A2A3A;
  display: flex; align-items: center; gap: 10px;
}
.section-badge {
  font-size: 11px; color: #C9A96E; background: #FDF8F0;
  padding: 3px 10px; border-radius: 10px; font-weight: 500;
}
.section-hint { font-size: 12px; color: #B0BCC8; }

/* ====== 分类导航 2×4 ====== */
.category-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}
.cat-card {
  display: flex;
  align-items: center;
  gap: 16px;
  background: #fff;
  border-radius: 14px;
  padding: 20px 22px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.03);
  cursor: pointer;
  transition: all 0.25s;
  border: 1.5px solid transparent;
}
.cat-card:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,0.06); border-color: #E8ECF1; }
.cat-card.active { border-color: #C9A96E; background: #FDF8F0; }
.cat-icon { font-size: 32px; line-height: 1; flex-shrink: 0; }
.cat-info { display: flex; flex-direction: column; gap: 2px; }
.cat-name { font-size: 14px; font-weight: 600; color: #1A2A3A; }
.cat-count { font-size: 11px; color: #8A9AA8; }

/* ====== 精选推荐横向滚动 ====== */
.featured-scroll {
  display: flex;
  gap: 18px;
  overflow-x: auto;
  padding-bottom: 6px;
  scrollbar-width: thin;
  scrollbar-color: #E8ECF1 transparent;
}
.featured-scroll::-webkit-scrollbar { height: 6px; }
.featured-scroll::-webkit-scrollbar-thumb { background: #E8ECF1; border-radius: 3px; }

.featured-card {
  flex: 0 0 310px;
  background: #fff;
  border-radius: 16px;
  padding: 22px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.04);
  display: flex; flex-direction: column; gap: 12px;
  cursor: pointer;
  transition: all 0.3s;
  border: 1px solid transparent;
}
.featured-card:hover { transform: translateY(-4px); box-shadow: 0 12px 32px rgba(0,0,0,0.08); border-color: #E8ECF1; }

.fc-head { display: flex; align-items: center; gap: 12px; }
.fc-logo { font-size: 36px; line-height: 1; }
.fc-title-row { display: flex; flex-direction: column; gap: 3px; flex: 1; min-width: 0; }
.fc-name { margin: 0; font-size: 15px; font-weight: 600; color: #1A2A3A; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.verified-tag {
  font-size: 10px; color: #C9A96E; background: #FDF8F0;
  padding: 1px 6px; border-radius: 4px; width: fit-content;
}

.fc-rating { display: flex; align-items: center; gap: 6px; }
.rating-score { font-size: 14px; font-weight: 700; color: #C9A96E; }
.rating-count { font-size: 12px; color: #B0BCC8; }

.fc-desc { margin: 0; font-size: 13px; color: #4A5A6A; line-height: 1.5; }
.fc-tags { display: flex; gap: 6px; flex-wrap: wrap; }
.fc-tag {
  font-size: 10px; color: #5CB87A; background: #EDFCF2;
  padding: 2px 8px; border-radius: 4px;
}
.fc-btn { align-self: flex-start; }

/* ====== 筛选条（简约） ====== */
.provider-filter-bar {
  display: flex; gap: 6px; flex-wrap: nowrap; overflow-x: auto;
  padding-bottom: 8px; margin-bottom: 20px;
  scrollbar-width: none;
}
.provider-filter-bar::-webkit-scrollbar { display: none; }
.pfb-tab {
  display: flex; align-items: center; gap: 5px;
  padding: 8px 16px; font-size: 13px;
  border: none; border-radius: 22px;
  background: #F5F6F8; color: #4A5A6A;
  cursor: pointer; transition: all 0.2s;
  white-space: nowrap; font-weight: 500;
}
.pfb-tab:hover { background: #ECF5FF; color: #409EFF; }
.pfb-tab.active { background: #1A2A3A; color: #fff; }
.pfb-icon { font-size: 15px; line-height: 1; }
.sort-select { width: 120px; }

/* ====== 服务商列表（行式卡片） ====== */
.provider-list {
  display: flex; flex-direction: column; gap: 10px;
}
.provider-row {
  display: flex; align-items: center; gap: 24px;
  background: #fff; border-radius: 12px; padding: 18px 24px;
  cursor: pointer; transition: all 0.25s;
  border: 1px solid transparent;
  box-shadow: 0 1px 4px rgba(0,0,0,0.02);
}
.provider-row:hover {
  border-color: #E2E8F0;
  box-shadow: 0 4px 20px rgba(0,0,0,0.05);
  transform: translateX(4px);
}

.pr-row-left { display: flex; align-items: center; gap: 16px; flex-shrink: 0; min-width: 240px; }
.pr-row-logo { font-size: 36px; line-height: 1; flex-shrink: 0; }
.pr-row-info { display: flex; flex-direction: column; gap: 4px; min-width: 0; }
.pr-row-name-line { display: flex; align-items: center; gap: 8px; }
.pr-row-name { font-size: 15px; font-weight: 600; color: #1A2A3A; white-space: nowrap; }
.pr-row-badge {
  font-size: 10px; color: #C9A96E; background: #FDF8F0;
  padding: 2px 6px; border-radius: 3px; font-weight: 600;
}
.pr-row-meta { display: flex; align-items: center; gap: 6px; }
.pr-row-cat { font-size: 12px; color: #8A9AA8; }
.pr-row-divider { color: #D0D8E0; font-size: 11px; }
.stars-inline { display: inline-flex; }
.pr-row-rating { font-size: 13px; font-weight: 700; color: #C9A96E; }
.pr-row-reviews { font-size: 12px; color: #B0BCC8; }

.pr-row-right { display: flex; align-items: center; gap: 20px; flex: 1; min-width: 0; }
.pr-row-desc {
  margin: 0; font-size: 13px; color: #6B7B8D; line-height: 1.5;
  flex: 1; min-width: 0;
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.pr-row-btn {
  padding: 7px 20px; border: none; border-radius: 8px;
  font-size: 13px; font-weight: 600; cursor: pointer; flex-shrink: 0;
  background: #1A2A3A; color: #fff;
  transition: all 0.2s;
}
.pr-row-btn:hover { background: #C9A96E; }

/* ====== 空状态 ====== */
.empty-providers { text-align: center; padding: 60px 20px; }
.empty-icon { font-size: 40px; display: block; margin-bottom: 12px; opacity: 0.5; }
.empty-text { font-size: 14px; color: #B0BCC8; font-weight: 500; margin: 0 0 6px; }
.empty-hint { font-size: 12px; color: #D0D8E0; margin: 0; }

/* ====== 星级 ====== */
:deep(.star) { font-size: 14px; }
:deep(.star.full) { color: #C9A96E; }
:deep(.star.half) { color: #C9A96E; opacity: 0.5; }
:deep(.star.empty) { color: #E8ECF1; }

/* ====== 生态动态横向滚动 ====== */
.news-scroll {
  display: flex;
  gap: 16px;
  overflow-x: auto;
  padding-bottom: 6px;
  scrollbar-width: thin;
  scrollbar-color: #E8ECF1 transparent;
}
.news-scroll::-webkit-scrollbar { height: 6px; }
.news-scroll::-webkit-scrollbar-thumb { background: #E8ECF1; border-radius: 3px; }

.news-card {
  flex: 0 0 280px;
  background: #fff;
  border-radius: 14px;
  padding: 18px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.03);
  transition: all 0.25s;
  cursor: pointer;
  display: flex; flex-direction: column; gap: 10px;
}
.news-card:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(0,0,0,0.06); }

.news-tag {
  font-size: 10px; font-weight: 600; padding: 2px 8px; border-radius: 4px;
  width: fit-content;
}
.tag-新品 { background: #EDFCF2; color: #5CB87A; }
.tag-公告 { background: #ECF5FF; color: #409EFF; }
.tag-活动 { background: #FFF7E6; color: #E6A23C; }
.tag-案例 { background: #FDF8F0; color: #C9A96E; }
.tag-政策 { background: #FFF0F0; color: #F56C6C; }
.tag-报告 { background: #EDE7F6; color: #A78BFA; }

.news-title { margin: 0; font-size: 13px; color: #4A5A6A; line-height: 1.5; flex: 1; }
.news-footer { display: flex; justify-content: space-between; }
.news-provider { font-size: 11px; color: #8A9AA8; }
.news-time { font-size: 11px; color: #B0BCC8; }

/* ====== 连接弹窗 ====== */
.connect-body { display: flex; flex-direction: column; gap: 16px; }
.conn-provider { display: flex; align-items: center; gap: 12px; }
.conn-logo { font-size: 36px; }
.conn-name { font-size: 16px; font-weight: 600; color: #1A2A3A; display: block; }
.conn-cat { font-size: 12px; color: #8A9AA8; }
.conn-divider { border-top: 1px solid #F0F2F5; }
.conn-intro { margin: 0; font-size: 13px; color: #4A5A6A; }
.conn-items { display: flex; flex-direction: column; gap: 10px; }
.conn-item {
  display: flex; align-items: center; gap: 10px;
  background: #FAFBFC; border-radius: 10px; padding: 12px 14px;
}
.conn-label { font-size: 13px; color: #8A9AA8; flex-shrink: 0; }
.conn-value { font-size: 13px; color: #1A2A3A; font-weight: 500; word-break: break-all; }

/* ====== 详情弹窗 ====== */
.detail-dialog-header { display: flex; align-items: center; gap: 14px; }
.dd-logo { font-size: 40px; line-height: 1; }
.dd-name { font-size: 17px; font-weight: 600; color: #1A2A3A; display: block; }
.dd-meta { display: flex; gap: 8px; align-items: center; margin-top: 3px; }
.dd-cat { font-size: 11px; color: #5CB87A; background: #EDFCF2; padding: 2px 8px; border-radius: 4px; }
.dd-verified { font-size: 11px; color: #C9A96E; background: #FDF8F0; padding: 2px 8px; border-radius: 4px; }

.dd-body { display: flex; flex-direction: column; gap: 20px; }
.dd-rating-row { display: flex; align-items: center; gap: 6px; }
.dd-rating { font-size: 15px; font-weight: 700; color: #C9A96E; }
.dd-reviews { font-size: 12px; color: #B0BCC8; }
.dd-coop { font-size: 12px; color: #8A9AA8; }

.dd-section { display: flex; flex-direction: column; gap: 8px; }
.dd-section-title { margin: 0; font-size: 13px; font-weight: 600; color: #4A5A6A; }
.dd-desc { margin: 0; font-size: 13px; color: #4A5A6A; line-height: 1.8; }
.dd-tags { display: flex; gap: 6px; flex-wrap: wrap; }
.dd-tag {
  font-size: 11px; background: #F5F6F8; color: #4A5A6A;
  padding: 3px 10px; border-radius: 6px;
}
.dd-info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 8px;
}
.dd-info-item {
  font-size: 12px;
  color: #4A5A6A;
  background: #FAFBFC;
  border-radius: 8px;
  padding: 10px 12px;
}
.dd-info-item :deep(b) { color: #1A2A3A; }

/* ====== 响应式 ====== */
@media (max-width: 1100px) {
  .category-grid { grid-template-columns: repeat(4, 1fr); }
  .provider-row { flex-direction: column; align-items: flex-start; gap: 12px; }
  .pr-row-left { min-width: auto; width: 100%; }
  .pr-row-right { width: 100%; }
  .pr-row-desc { white-space: normal; }
}
@media (max-width: 768px) {
  .category-grid { grid-template-columns: repeat(2, 1fr); }
  .page-header { flex-direction: column; align-items: flex-start; }
  .search-input { width: 100%; }
  .header-right { width: 100%; }
}
</style>
