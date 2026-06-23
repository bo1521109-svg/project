<template>
  <div class="template-library" ref="pageRef">
    <!-- ====== 顶部 Hero 区 ====== -->
    <div class="hero-section">
      <div class="hero-bg-shapes">
        <span class="shape shape-1" />
        <span class="shape shape-2" />
        <span class="shape shape-3" />
      </div>
      <div class="hero-content">
        <div class="hero-text">
          <h1 class="hero-title">
            模板库
            <span class="hero-dot" />
          </h1>
          <p class="hero-subtitle">从专业模板开始，让建站快人一步</p>

          <div class="hero-stats">
            <div class="hero-stat">
              <span class="stat-num">{{ templates.length }}+</span>
              <span class="stat-text">精选模板</span>
            </div>
            <div class="hero-divider" />
            <div class="hero-stat">
              <span class="stat-num">{{ categories.length - 1 }}</span>
              <span class="stat-text">行业分类</span>
            </div>
            <div class="hero-divider" />
            <div class="hero-stat">
              <span class="stat-num">2.4w+</span>
              <span class="stat-text">商家选择</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ====== 搜索 + 排序 + 结果数 ====== -->
    <div class="toolbar">
      <div class="toolbar-left">
        <div class="search-wrap">
          <el-icon class="search-icon"><Search /></el-icon>
          <input
            v-model="searchQuery"
            type="text"
            placeholder="搜索模板名称、分类..."
            class="search-field"
          />
          <el-icon
            v-if="searchQuery"
            class="search-clear"
            @click="searchQuery = ''; debouncedSearch()"
          >
            <CircleClose />
          </el-icon>
        </div>

        <!-- 排序下拉 -->
        <el-select v-model="sortBy" class="sort-select" size="large" @change="handleSortChange">
          <el-option
            v-for="opt in sortOptions"
            :key="opt.value"
            :label="opt.label"
            :value="opt.value"
          />
        </el-select>
      </div>

      <div class="toolbar-right">
        <span class="sort-label">结果：</span>
        <span class="sort-count">{{ filteredTemplates.length }} 个模板</span>
      </div>
    </div>

    <!-- 分类标签 -->
    <div class="category-bar">
      <button
        v-for="cat in categories"
        :key="cat.key"
        class="cat-btn"
        :class="{ active: activeCategory === cat.key }"
        @click="switchCategory(cat.key)"
      >
        <span class="cat-icon" v-html="cat.icon" />
        <span class="cat-label">{{ cat.label }}</span>
        <span v-if="cat.key === 'favorite' && collectedIds.length" class="cat-count">{{ collectedIds.length }}</span>
      </button>
    </div>

    <!-- ====== 模板网格 ====== -->
    <div v-if="paginatedTemplates.length" class="template-grid">
      <div
        v-for="(tpl, idx) in paginatedTemplates"
        :key="tpl.id"
        class="grid-item"
        :style="{ animationDelay: idx * 0.04 + 's' }"
      >
        <TemplateCard
          :template="tpl"
          :collected="collectedIds.includes(tpl.id)"
          @preview="handlePreview"
          @use="handleUseTemplate"
          @toggle-favorite="toggleFavorite"
        />
      </div>
    </div>

    <!-- 空状态 -->
    <div v-else class="empty-state">
      <el-empty :image-size="160" description=" ">
        <template #image>
          <el-icon :size="64" color="#c0c4cc"><FolderOpened /></el-icon>
        </template>
        <h3>{{ searchQuery ? '未找到相关模板' : '暂无模板数据' }}</h3>
        <p>{{ searchQuery ? '试试其他关键词或调整筛选条件' : '模板数据加载中，请稍候...' }}</p>
      </el-empty>
    </div>

    <!-- ====== 分页 ====== -->
    <div v-if="filteredTemplates.length > pageSize" class="pagination-wrap">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[8, 16, 24]"
        :total="filteredTemplates.length"
        layout="total, sizes, prev, pager, next"
        background
        @size-change="handlePageSizeChange"
        @current-change="handlePageChange"
      />
    </div>
    <div v-else-if="filteredTemplates.length" class="pagination-wrap pagination-light">
      <span class="pagination-total">共 {{ filteredTemplates.length }} 个模板</span>
    </div>

    <!-- ====== 模板详情弹窗 ====== -->
    <el-dialog
      v-model="detailVisible"
      width="800px"
      destroy-on-close
      class="detail-dialog"
      top="5vh"
    >
      <template #header>
        <div class="dialog-header">
          <div class="dialog-title-row">
            <h3>{{ detailTemplate?.name }}</h3>
            <el-tag
              :type="detailTemplate?.isFree ? 'success' : 'danger'"
              effect="dark"
              size="small"
            >
              {{ detailTemplate?.isFree ? '免费' : detailTemplate?.price }}
            </el-tag>
          </div>
          <p class="dialog-subtitle">{{ detailTemplate?.categoryLabel }} 分类</p>
        </div>
      </template>

      <template v-if="detailTemplate">
        <div class="detail-layout">
          <!-- 左侧：大图 -->
          <div class="detail-image-wrap">
            <el-image
              :src="detailTemplate.previewImage"
              fit="cover"
              class="detail-main-image"
            >
              <template #placeholder>
                <div class="image-placeholder"><el-icon :size="36"><PictureFilled /></el-icon></div>
              </template>
            </el-image>
            <div class="detail-image-actions">
              <el-button
                type="primary"
                size="large"
                round
                @click="handleUseFromDetail"
              >
                <el-icon><Plus /></el-icon>
                使用此模板
              </el-button>
              <el-button
                size="large"
                round
                :class="{ 'fav-active': collectedIds.includes(detailTemplate.id) }"
                @click="toggleFavorite(detailTemplate)"
              >
                <el-icon><StarFilled v-if="collectedIds.includes(detailTemplate.id)" /><Star v-else /></el-icon>
                {{ collectedIds.includes(detailTemplate.id) ? '已收藏' : '收藏' }}
              </el-button>
            </div>
          </div>

          <!-- 右侧：详情 -->
          <div class="detail-info">
            <div class="detail-meta">
              <div class="meta-row">
                <span class="meta-label">使用次数</span>
                <span class="meta-value">{{ detailTemplate.usageCount.toLocaleString() }}</span>
              </div>
              <div class="meta-row">
                <span class="meta-label">热度评分</span>
                <span class="meta-value">
                  <el-rate
                    :model-value="Math.round(detailTemplate.popularity / 20)"
                    disabled
                    show-score
                    score-template="{value}"
                    size="small"
                  />
                  <span class="score-num">{{ detailTemplate.popularity }}/100</span>
                </span>
              </div>
              <div class="meta-row">
                <span class="meta-label">价格</span>
                <span class="meta-value" :class="{ 'text-green': detailTemplate.isFree }">
                  {{ detailTemplate.isFree ? '免费' : detailTemplate.price }}
                </span>
              </div>
            </div>

            <div class="detail-section">
              <h4>模板描述</h4>
              <p>{{ detailTemplate.description }}</p>
            </div>

            <div class="detail-section">
              <h4>技术特性</h4>
              <div class="tag-list">
                <span v-for="tag in detailTemplate.tags" :key="tag" class="detail-tag">
                  {{ tag }}
                </span>
              </div>
            </div>

            <div class="detail-section">
              <h4>特色功能</h4>
              <ul class="feature-list">
                <li v-for="(f, i) in detailTemplate.features" :key="i">
                  <el-icon :size="14" color="#67c23a"><Check /></el-icon>
                  {{ f }}
                </li>
              </ul>
            </div>
          </div>
        </div>
      </template>

      <template #footer>
        <el-button size="large" @click="detailVisible = false">关闭</el-button>
        <el-button size="large" type="primary" @click="handleUseFromDetail">
          使用此模板建站
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  Search, CircleClose, FolderOpened, PictureFilled,
  View, StarFilled, Star, Plus, Check
} from '@element-plus/icons-vue'
import { mockTemplates } from '@/api/template'
import TemplateCard from '@/components/Website/TemplateCard.vue'

const router = useRouter()

// ====== 引用 ======
const pageRef = ref(null)

// ====== 分类（含图标 + 收藏选项） ======
const categories = [
  { key: 'all', label: '全部', icon: '✦' },
  { key: 'fashion', label: '时尚', icon: '👗' },
  { key: 'tech', label: '科技', icon: '💻' },
  { key: 'home', label: '家居', icon: '🏠' },
  { key: 'food', label: '食品餐饮', icon: '🍽️' },
  { key: 'sport', label: '运动户外', icon: '⚽' },
  { key: 'baby', label: '母婴童装', icon: '👶' },
  { key: 'beauty', label: '美妆个护', icon: '💄' },
  { key: 'edu', label: '教育培训', icon: '📚' },
  { key: 'favorite', label: '我的收藏', icon: '❤️' }
]

// ====== 排序选项 ======
const sortOptions = [
  { value: 'popularity', label: '热度最高' },
  { value: 'usage', label: '使用最多' },
  { value: 'newest', label: '最新上线' },
  { value: 'price', label: '价格低到高' }
]

// ====== 状态 ======
const templates = ref(mockTemplates.map(t => ({ ...t, sortOrder: t.id })))
const searchQuery = ref('')
const activeCategory = ref('all')
const sortBy = ref('popularity')
const currentPage = ref(1)
const pageSize = ref(8)

// 收藏状态（从 localStorage 恢复）
const STORAGE_KEY = 'template_favorites'
const collectedIds = ref(loadCollectedIds())

// 详情弹窗
const detailVisible = ref(false)
const detailTemplate = ref(null)

// ====== 搜索防抖 ======
let searchTimer = null
watch(searchQuery, () => {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {
    currentPage.value = 1
  }, 500)
})

function debouncedSearch() {
  clearTimeout(searchTimer)
  currentPage.value = 1
}

// ====== localStorage 读写 ======
function loadCollectedIds() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? JSON.parse(raw) : []
  } catch {
    return []
  }
}

function saveCollectedIds() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(collectedIds.value))
}

// ====== 收藏切换 ======
function toggleFavorite(tpl) {
  const idx = collectedIds.value.indexOf(tpl.id)
  if (idx > -1) {
    collectedIds.value.splice(idx, 1)
    ElMessage({ message: `已取消收藏「${tpl.name}」`, type: 'info', duration: 1500 })
  } else {
    collectedIds.value.push(tpl.id)
    ElMessage({ message: `已收藏「${tpl.name}」`, type: 'success', duration: 1500 })
  }
  saveCollectedIds()
}

// ====== 过滤 + 排序 + 分页 ======
const filteredTemplates = computed(() => {
  let list = [...templates.value]

  // 1. 分类过滤
  if (activeCategory.value !== 'all') {
    if (activeCategory.value === 'favorite') {
      list = list.filter(t => collectedIds.value.includes(t.id))
    } else {
      list = list.filter(t => t.category === activeCategory.value)
    }
  }

  // 2. 搜索过滤
  if (searchQuery.value.trim()) {
    const q = searchQuery.value.toLowerCase()
    list = list.filter(
      t => t.name.toLowerCase().includes(q)
        || t.description.toLowerCase().includes(q)
        || t.categoryLabel.includes(searchQuery.value)
    )
  }

  // 3. 排序
  switch (sortBy.value) {
    case 'popularity':
      list.sort((a, b) => b.popularity - a.popularity)
      break
    case 'usage':
      list.sort((a, b) => b.usageCount - a.usageCount)
      break
    case 'newest':
      list.sort((a, b) => b.id - a.id)
      break
    case 'price':
      list.sort((a, b) => {
        if (a.isFree && !b.isFree) return -1
        if (!a.isFree && b.isFree) return 1
        // 付费模板按价格字符串比较（简单处理：免费在前）
        return 0
      })
      break
  }

  return list
})

const paginatedTemplates = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  return filteredTemplates.value.slice(start, start + pageSize.value)
})

// ====== 方法 ======
function handleSortChange() {
  currentPage.value = 1
}

function handlePageSizeChange() {
  currentPage.value = 1
}

function handlePageChange() {
  // 页面滚动到模板网格区域
  const gridEl = pageRef.value?.querySelector('.template-grid') || pageRef.value?.querySelector('.empty-state')
  if (gridEl) gridEl.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

function switchCategory(key) {
  activeCategory.value = key
  currentPage.value = 1
  // 页面滚动到分类栏位置
  const catBar = pageRef.value?.querySelector('.category-bar')
  if (catBar) catBar.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
}

function handlePreview(tpl) {
  detailTemplate.value = tpl
  detailVisible.value = true
}

function handleUseTemplate(tpl) {
  router.push(`/website/create?templateId=${tpl.id}`)
}

function handleUseFromDetail() {
  if (detailTemplate.value) {
    router.push(`/website/create?templateId=${detailTemplate.value.id}`)
    detailVisible.value = false
  }
}
</script>

<style scoped>
.template-library { max-width: 1440px; margin: 0 auto; }

/* ==================== Hero ==================== */
.hero-section {
  position: relative;
  background: linear-gradient(135deg, #e8f4fd 0%, #f0f7ff 40%, #f5f9fc 100%);
  border-radius: 24px;
  padding: 48px 52px;
  margin-bottom: 32px;
  overflow: hidden;
}
.hero-bg-shapes { position: absolute; inset: 0; pointer-events: none; }
.shape { position: absolute; border-radius: 50%; opacity: 0.1; }
.shape-1 { width: 320px; height: 320px; background: radial-gradient(circle, #409eff, transparent); top: -80px; right: -40px; }
.shape-2 { width: 200px; height: 200px; background: radial-gradient(circle, #a78bfa, transparent); bottom: -40px; left: 20%; }
.shape-3 { width: 160px; height: 160px; background: radial-gradient(circle, #f59e0b, transparent); top: 40%; left: -40px; }
.hero-content { position: relative; z-index: 1; }
.hero-title { margin: 0; font-size: 42px; font-weight: 800; color: #1a1a2e; letter-spacing: -0.5px; line-height: 1.1; display: flex; align-items: center; gap: 8px; }
.hero-dot { display: inline-block; width: 10px; height: 10px; border-radius: 50%; background: linear-gradient(135deg, #409eff, #a78bfa); box-shadow: 0 0 8px rgba(64,158,255,.2); }
.hero-subtitle { margin: 12px 0 0; font-size: 16px; color: #6b7280; }
.hero-stats { display: flex; align-items: center; gap: 32px; margin-top: 28px; }
.hero-stat { display: flex; flex-direction: column; gap: 2px; }
.stat-num { font-size: 28px; font-weight: 800; color: #1a1a2e; }
.stat-text { font-size: 13px; color: #909399; }
.hero-divider { width: 1px; height: 40px; background: #e4e7ed; }

/* ==================== Toolbar ==================== */
.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
  gap: 16px;
}
.toolbar-left { display: flex; align-items: center; gap: 12px; flex: 1; }
.search-wrap {
  display: flex; align-items: center; gap: 10px;
  background: #fff; border: 2px solid #e8ecf1; border-radius: 14px;
  padding: 0 18px; height: 48px; width: 320px;
  transition: border-color 0.25s, box-shadow 0.25s;
}
.search-wrap:focus-within { border-color: #409eff; box-shadow: 0 0 0 4px rgba(64,158,255,.08); }
.search-icon { color: #909399; font-size: 18px; flex-shrink: 0; }
.search-field { flex: 1; border: none; outline: none; font-size: 14px; color: #303133; background: transparent; }
.search-field::placeholder { color: #c0c4cc; }
.search-clear { color: #c0c4cc; cursor: pointer; flex-shrink: 0; }
.search-clear:hover { color: #909399; }

.sort-select { width: 160px; }
.sort-select :deep(.el-input__wrapper) { border-radius: 12px; box-shadow: 0 0 0 1.5px #e8ecf1 inset; }
.sort-select :deep(.el-input__wrapper:hover) { box-shadow: 0 0 0 1.5px #c4cdff inset; }
.sort-select :deep(.el-input__inner) { font-size: 13px; font-weight: 500; }

.toolbar-right { flex-shrink: 0; display: flex; align-items: center; gap: 8px; }
.sort-label { font-size: 13px; color: #909399; }
.sort-count { font-size: 14px; font-weight: 600; color: #303133; background: #f5f7fa; padding: 4px 14px; border-radius: 8px; }

/* ==================== 分类栏 ==================== */
.category-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 28px;
}
.cat-btn {
  display: flex; align-items: center; gap: 6px;
  padding: 8px 18px; border: 1.5px solid #e8ecf1; border-radius: 12px;
  background: #fff; color: #606266; font-size: 13px; font-weight: 500;
  cursor: pointer; transition: all 0.25s;
}
.cat-btn:hover { border-color: #c4cdff; color: #409eff; background: #fafbff; }
.cat-btn.active { background: linear-gradient(135deg, #409eff, #5372ff); border-color: transparent; color: #fff; box-shadow: 0 4px 16px rgba(64,158,255,.25); }
.cat-icon { font-size: 16px; line-height: 1; }
.cat-count {
  font-size: 10px; background: rgba(255,255,255,.3);
  padding: 1px 7px; border-radius: 10px; margin-left: 2px;
}
.cat-btn.active .cat-count { background: rgba(255,255,255,.3); }

/* ==================== 网格 ==================== */
.template-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; }
.grid-item { animation: fadeInUp 0.5s ease backwards; }
@keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
@media (max-width: 1280px) { .template-grid { grid-template-columns: repeat(3, 1fr); } }
@media (max-width: 960px)  { .template-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 640px)  { .template-grid { grid-template-columns: 1fr; } }

/* ==================== 空状态 ==================== */
.empty-state { display: flex; flex-direction: column; align-items: center; padding: 80px 20px; }
.empty-state h3 { margin: 16px 0 4px; color: #606266; font-size: 16px; font-weight: 500; }
.empty-state p { margin: 0; color: #909399; font-size: 13px; }

/* ==================== 分页 ==================== */
.pagination-wrap { display: flex; justify-content: center; margin-top: 48px; padding: 20px 0; }
.pagination-light { margin-top: 24px; padding: 12px 0; }
.pagination-total { font-size: 13px; color: #909399; }

/* ==================== 详情弹窗 ==================== */
.detail-dialog :deep(.el-dialog__body) { padding: 0 20px 20px; }
.dialog-header { padding: 4px 0; }
.dialog-title-row { display: flex; align-items: center; gap: 12px; }
.dialog-title-row h3 { margin: 0; font-size: 20px; font-weight: 700; color: #1a1a2e; }
.dialog-subtitle { margin: 4px 0 0; font-size: 13px; color: #909399; }

.detail-layout { display: flex; gap: 28px; }

.detail-image-wrap { width: 380px; flex-shrink: 0; }
.detail-main-image { width: 100%; height: 240px; border-radius: 14px; object-fit: cover; background: #f8f9fc; }
.image-placeholder { width: 100%; height: 240px; display: flex; align-items: center; justify-content: center; background: #f5f7fa; color: #c0c4cc; border-radius: 14px; }
.detail-image-actions { display: flex; gap: 10px; margin-top: 16px; }
.detail-image-actions .el-button { flex: 1; }
.detail-image-actions .fav-active { color: #f56c6c; border-color: #f56c6c !important; }

.detail-info { flex: 1; display: flex; flex-direction: column; gap: 20px; }
.detail-meta { background: #fafbfc; border-radius: 12px; padding: 16px 20px; }
.meta-row { display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid #f0f0f0; }
.meta-row:last-child { border-bottom: none; }
.meta-label { font-size: 13px; color: #909399; }
.meta-value { font-size: 13px; color: #303133; font-weight: 600; display: flex; align-items: center; gap: 8px; }
.text-green { color: #67c23a; }
.score-num { font-size: 12px; color: #909399; font-weight: 400; }
.detail-section h4 { margin: 0 0 10px; font-size: 14px; font-weight: 700; color: #1a1a2e; }
.detail-section p { margin: 0; font-size: 13px; color: #606266; line-height: 1.7; }

.tag-list { display: flex; flex-wrap: wrap; gap: 8px; }
.detail-tag { padding: 5px 14px; background: linear-gradient(135deg, #ecf5ff, #e8f4fd); color: #409eff; border-radius: 8px; font-size: 12px; font-weight: 500; }

.feature-list { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 8px; }
.feature-list li { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #303133; }
</style>
