<template>
  <div class="kb-page">
    <!-- ====== 顶部：标题 + 搜索 ====== -->
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">出海智库</h1>
        <p class="page-subtitle">出海百科 · 案例库 · 课程推荐 · 工具推荐</p>
      </div>
      <div class="header-right">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索标题、关键词..."
          clearable
          class="search-input"
        >
          <template #prefix><el-icon :size="14"><Search /></el-icon></template>
        </el-input>
      </div>
    </div>

    <!-- ====== 分类筛选标签 ====== -->
    <div class="cat-filter-bar">
      <button
        class="cfb-tab"
        :class="{ active: activeCategory === '' }"
        @click="activeCategory = ''"
      >
        <span class="cfb-icon">📚</span>全部
        <span class="cfb-count">{{ totalCount }}</span>
      </button>
      <button
        v-for="cat in catOptions"
        :key="cat.value"
        class="cfb-tab"
        :class="{ active: activeCategory === cat.value, ['cat-' + cat.value]: true }"
        @click="activeCategory = cat.value"
      >
        <span class="cfb-icon">{{ cat.icon }}</span>{{ cat.label }}
        <span class="cfb-count">{{ catCount(cat.value) }}</span>
      </button>
    </div>

    <!-- ====== 知识卡片网格 3 列 ====== -->
    <div class="article-grid" v-if="filteredArticles.length">
      <div
        v-for="(a, idx) in filteredArticles"
        :key="a.id"
        class="article-card"
        :style="{ animationDelay: idx * 0.04 + 's' }"
      >
        <!-- 封面图 -->
        <div class="ac-cover" @click="openDetail(a)">
          <img
            :src="a.coverImage"
            :alt="a.title"
            @error="e => e.target.src='https://picsum.photos/seed/fallback/600/340'"
          />
          <span class="ac-cat-tag" :class="'cat-' + a.category">{{ a.categoryName }}</span>
          <div class="ac-overlay">
            <span class="ac-overlay-text">查看内容 →</span>
          </div>
        </div>

        <!-- 卡片内容 -->
        <div class="ac-body">
          <h4 class="ac-title" @click="openDetail(a)">{{ a.title }}</h4>
          <p class="ac-summary">{{ a.summary }}</p>

          <!-- 标签 -->
          <div class="ac-tags">
            <span v-for="t in a.tags.slice(0, 3)" :key="t" class="ac-tag">{{ t }}</span>
          </div>

          <!-- 底部：阅读量 + 按钮 -->
          <div class="ac-footer">
            <span class="ac-meta">
              <span class="ac-reads">👁 {{ formatNum(a.readCount) }}</span>
              <span class="ac-date">{{ a.updatedAt }}</span>
            </span>
            <button class="ac-btn" @click.stop="openDetail(a)">查看内容</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 空状态 -->
    <div v-else class="empty-state">
      <span class="empty-icon">📚</span>
      <p class="empty-text">未找到相关文章</p>
      <p class="empty-hint">尝试更换搜索关键词或筛选分类</p>
    </div>

    <!-- ====== 文章详情弹窗 ====== -->
    <el-dialog
      v-model="detailVisible"
      :close-on-click-modal="true"
      width="700px"
      class="kb-detail-dialog"
      destroy-on-close
      top="5vh"
    >
      <template #header>
        <div class="kdd-header" v-if="detailArticle">
          <span class="kdd-cat-label" :class="'cat-' + detailArticle.category">{{ detailArticle.categoryName }}</span>
          <h2 class="kdd-title">{{ detailArticle.title }}</h2>
          <div class="kdd-meta">
            <span>👁 {{ formatNum(detailArticle.readCount) }} 阅读</span>
            <span>📅 {{ detailArticle.updatedAt }} 更新</span>
          </div>
        </div>
      </template>
      <template v-if="detailArticle">
        <div class="kdd-body">
          <img
            :src="detailArticle.coverImage"
            :alt="detailArticle.title"
            class="kdd-cover"
            @error="e => e.target.src='https://picsum.photos/seed/fallback2/700/380'"
          />
          <div class="kdd-content" v-html="detailArticle.fullContent" />
          <!-- 标签 -->
          <div class="kdd-tags">
            <span v-for="t in detailArticle.tags" :key="t" class="kdd-tag">{{ t }}</span>
          </div>
          <!-- 相关推荐 -->
          <div v-if="relatedArticles.length" class="kdd-related">
            <h4 class="kdd-rtitle">📖 相关推荐</h4>
            <div class="kdd-rlist">
              <div
                v-for="r in relatedArticles"
                :key="r.id"
                class="kdd-ritem"
                @click="switchArticle(r)"
              >
                <img :src="r.coverImage" class="kdd-rimg" @error="e => e.target.style.display='none'" />
                <div class="kdd-rinfo">
                  <span class="kdd-rcat" :class="'cat-' + r.category">{{ r.categoryName }}</span>
                  <span class="kdd-rtit">{{ r.title }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
/**
 * 出海智库页面
 *
 * 功能：
 * - 分类筛选（全部/百科/案例/课程/工具）带计数
 * - 搜索（按标题）
 * - 3 列知识卡片网格（封面图 + 分类标签 + 标题 + 摘要 + 查看内容按钮）
 * - 文章详情弹窗 + 相关推荐
 *
 * 数据来源：frontend/src/api/overseas.js → getKnowledgeData()
 */

import { ref, computed, nextTick } from 'vue'
import { Search } from '@element-plus/icons-vue'
import { getKnowledgeData, getRelatedKnowledgeArticles } from '@/api/overseas'

// ====== 分类 ======
const catOptions = [
  { value: 'encyclopedia', label: '出海百科', icon: '📖' },
  { value: 'case-study',  label: '成功案例', icon: '🏆' },
  { value: 'course',      label: '课程推荐', icon: '🎓' },
  { value: 'tool',        label: '工具推荐', icon: '🛠️' }
]

function catCount(val) {
  return getKnowledgeData({ category: val }).length
}
const totalCount = computed(() => getKnowledgeData().length)

// ====== 状态 ======
const searchKeyword = ref('')
const activeCategory = ref('')
const detailVisible = ref(false)
const detailArticle = ref(null)

// ====== 过滤 ======
const filteredArticles = computed(() =>
  getKnowledgeData({ category: activeCategory.value, keyword: searchKeyword.value })
)

// ====== 相关推荐 ======
const relatedArticles = computed(() => {
  if (!detailArticle.value) return []
  return getRelatedKnowledgeArticles(detailArticle.value.relatedArticles)
})

// ====== 详情 ======
function openDetail(article) {
  detailArticle.value = article
  detailVisible.value = true
}

function switchArticle(article) {
  detailVisible.value = false
  nextTick(() => openDetail(article))
}

// ====== 格式化 ======
function formatNum(n) {
  if (n >= 10000) return (n / 10000).toFixed(1) + '万'
  if (n >= 1000) return (n / 1000).toFixed(1) + 'K'
  return String(n)
}
</script>

<style scoped>
.kb-page {
  max-width: 1440px;
  margin: 0 auto;
  min-height: 100vh;
}

/* ====== 页面标题 ====== */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 24px;
  gap: 20px;
  flex-wrap: wrap;
}
.header-left { display: flex; flex-direction: column; gap: 6px; }
.page-title { margin: 0; font-size: 28px; font-weight: 700; color: #1A2A3A; letter-spacing: -0.3px; }
.page-subtitle { margin: 0; font-size: 14px; color: #8A9AA8; }
.header-right { flex-shrink: 0; }
.search-input { width: 300px; }

/* ====== 分类筛选标签 ====== */
.cat-filter-bar {
  display: flex; gap: 6px; margin-bottom: 24px;
  flex-wrap: wrap;
}
.cfb-tab {
  display: flex; align-items: center; gap: 6px;
  padding: 8px 16px; font-size: 13px; font-weight: 500;
  border: 1px solid #E8ECF1; border-radius: 10px;
  background: #fff; color: #4A5A6A;
  cursor: pointer; transition: all 0.2s; white-space: nowrap;
}
.cfb-tab:hover { border-color: #C9A96E; color: #C9A96E; }
.cfb-tab.active {
  background: #1A2A3A; color: #fff; border-color: #1A2A3A;
}
.cfb-icon { font-size: 14px; line-height: 1; }
.cfb-count {
  font-size: 10px; padding: 1px 6px; border-radius: 8px;
  background: #F5F6F8;
}
.cfb-tab.active .cfb-count {
  background: rgba(255,255,255,0.2);
}

/* ====== 文章网格 3 列 ====== */
.article-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 22px;
}
.article-card {
  background: #fff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0,0,0,0.03);
  transition: all 0.3s;
  animation: fadeUp 0.45s ease backwards;
}
.article-card:hover { transform: translateY(-4px); box-shadow: 0 12px 32px rgba(0,0,0,0.08); }
@keyframes fadeUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }

/* 封面 */
.ac-cover {
  position: relative;
  height: 180px;
  overflow: hidden;
  background: #F5F6F8;
  cursor: pointer;
}
.ac-cover img {
  width: 100%; height: 100%; object-fit: cover;
  transition: transform 0.4s;
}
.article-card:hover .ac-cover img { transform: scale(1.05); }

.ac-cat-tag {
  position: absolute; top: 12px; left: 12px;
  padding: 3px 10px; border-radius: 6px;
  font-size: 11px; font-weight: 600; color: #fff;
}
.cat-encyclopedia { background: rgba(64,158,255,0.85); }
.cat-case-study  { background: rgba(103,194,58,0.85); }
.cat-course       { background: rgba(167,139,250,0.85); }
.cat-tool         { background: rgba(230,162,60,0.85); }

/* 封面悬停遮罩 */
.ac-overlay {
  position: absolute; inset: 0;
  background: rgba(26,42,58,0.4);
  display: flex; align-items: center; justify-content: center;
  opacity: 0; transition: opacity 0.3s;
}
.article-card:hover .ac-overlay { opacity: 1; }
.ac-overlay-text { color: #fff; font-size: 14px; font-weight: 500; }

/* 卡片内容 */
.ac-body {
  padding: 16px 18px;
  display: flex; flex-direction: column; gap: 10px;
}
.ac-title {
  margin: 0; font-size: 15px; font-weight: 600; color: #1A2A3A;
  line-height: 1.5; cursor: pointer;
  display: -webkit-box; -webkit-line-clamp: 2; line-clamp: 2; -webkit-box-orient: vertical;
  overflow: hidden;
}
.ac-title:hover { color: #C9A96E; }
.ac-summary {
  margin: 0; font-size: 13px; color: #6B7B8D; line-height: 1.6;
  display: -webkit-box; -webkit-line-clamp: 2; line-clamp: 2; -webkit-box-orient: vertical;
  overflow: hidden;
}
.ac-tags { display: flex; gap: 6px; flex-wrap: wrap; }
.ac-tag {
  font-size: 10px; color: #8A9AA8; background: #F5F6F8;
  padding: 3px 8px; border-radius: 4px;
}
.ac-footer {
  display: flex; justify-content: space-between; align-items: center;
  padding-top: 10px; border-top: 1px solid #F0F2F5;
}
.ac-meta { display: flex; gap: 12px; }
.ac-reads, .ac-date { font-size: 11px; color: #B0BCC8; }
.ac-btn {
  padding: 4px 12px; font-size: 11px; font-weight: 500;
  color: #C9A96E; background: #FDF8F0;
  border: 1px solid #F5E6C8; border-radius: 6px;
  cursor: pointer; transition: all 0.2s; white-space: nowrap;
}
.ac-btn:hover { background: #C9A96E; color: #fff; border-color: #C9A96E; }

/* ====== 空状态 ====== */
.empty-state { text-align: center; padding: 80px 20px; }
.empty-icon { font-size: 48px; display: block; margin-bottom: 12px; opacity: 0.4; }
.empty-text { font-size: 15px; color: #B0BCC8; font-weight: 500; margin: 0 0 6px; }
.empty-hint { font-size: 13px; color: #D0D8E0; margin: 0; }

/* ====== 详情弹窗 ====== */
.kdd-header { display: flex; flex-direction: column; gap: 10px; }
.kdd-cat-label {
  font-size: 11px; font-weight: 600; color: #fff;
  padding: 3px 10px; border-radius: 4px; width: fit-content;
}
.kdd-title { margin: 0; font-size: 20px; font-weight: 700; color: #1A2A3A; line-height: 1.4; }
.kdd-meta { display: flex; gap: 20px; font-size: 12px; color: #8A9AA8; }
.kdd-body { display: flex; flex-direction: column; gap: 22px; }
.kdd-cover { width: 100%; border-radius: 12px; max-height: 340px; object-fit: cover; }

.kdd-content {
  font-size: 14px; color: #4A5A6A; line-height: 1.9;
}
.kdd-content :deep(h3) { font-size: 16px; color: #1A2A3A; margin: 20px 0 10px; font-weight: 600; }
.kdd-content :deep(h3:first-child) { margin-top: 0; }
.kdd-content :deep(p) { margin: 0 0 10px; }

/* 标签 */
.kdd-tags { display: flex; gap: 6px; flex-wrap: wrap; }
.kdd-tag {
  font-size: 11px; color: #C9A96E; background: #FDF8F0;
  padding: 3px 10px; border-radius: 6px;
}

/* 相关推荐 */
.kdd-related { padding-top: 16px; border-top: 1px solid #F0F2F5; }
.kdd-rtitle { margin: 0 0 12px; font-size: 15px; font-weight: 600; color: #1A2A3A; }
.kdd-rlist { display: flex; flex-direction: column; gap: 8px; }
.kdd-ritem {
  display: flex; align-items: center; gap: 12px;
  padding: 10px 14px; border-radius: 10px;
  background: #FAFBFC; cursor: pointer; transition: all 0.2s;
}
.kdd-ritem:hover { background: #F0F2F5; transform: translateX(4px); }
.kdd-rimg { width: 60px; height: 40px; border-radius: 6px; object-fit: cover; flex-shrink: 0; }
.kdd-rinfo { display: flex; flex-direction: column; gap: 3px; }
.kdd-rcat { font-size: 10px; font-weight: 600; padding: 1px 6px; border-radius: 3px; width: fit-content; }
.kdd-rcat.cat-encyclopedia { color: #409EFF; background: #ECF5FF; }
.kdd-rcat.cat-case-study  { color: #67C23A; background: #EDFCF2; }
.kdd-rcat.cat-course       { color: #A78BFA; background: #F0EBFF; }
.kdd-rcat.cat-tool         { color: #E6A23C; background: #FFF7E6; }
.kdd-rtit { font-size: 13px; color: #4A5A6A; font-weight: 500; }

/* ====== 响应式 ====== */
@media (max-width: 1100px) {
  .article-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 768px) {
  .article-grid { grid-template-columns: 1fr; }
  .page-header { flex-direction: column; align-items: flex-start; }
  .search-input { width: 100%; }
  .header-right { width: 100%; }
  .cat-filter-bar { gap: 4px; }
  .cfb-tab { padding: 6px 12px; font-size: 12px; }
}
</style>
