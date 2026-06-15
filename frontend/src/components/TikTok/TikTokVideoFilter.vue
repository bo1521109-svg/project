<template>
  <div class="tk-video-filter">
    <div class="search-bar">
      <div class="search-input-wrapper">
        <input
          v-model="searchKeyword"
          type="text"
          class="search-input"
          placeholder="输入视频关键词或达人名称搜索"
          @keyup.enter="handleSearch"
        />
        <button class="search-btn" @click="handleSearch">
          <el-icon :size="18"><Search /></el-icon>
        </button>
      </div>
    </div>

    <div class="filter-body">
      <!-- 国家/地区 -->
      <div class="filter-row">
        <span class="filter-label">国家/地区：</span>
        <div class="tag-group">
          <span
            v-for="item in tkVideoCountryList"
            :key="item.value"
            class="tag-item pill-tag"
            :class="{ active: filters.country === item.value }"
            @click="selectFilter('country', item.value)"
          >{{ item.label }}</span>
        </div>
      </div>

      <!-- 视频分类，支持展开/收起 -->
      <div class="filter-row">
        <span class="filter-label">视频分类：</span>
        <div class="category-area">
          <div class="tag-group category-tag-group" :class="{ collapsed: !categoryExpanded }">
            <span
              v-for="item in displayedCategories"
              :key="item.value"
              class="tag-item rect-tag"
              :class="{ active: filters.category === item.value }"
              @click="selectFilter('category', item.value)"
            >{{ item.label }}</span>
          </div>
          <button
            v-if="tkVideoCategoryList.length > 12"
            class="toggle-btn"
            @click="categoryExpanded = !categoryExpanded"
          >
            {{ categoryExpanded ? '收起' : '展开' }}
            <el-icon :size="14" class="toggle-icon" :class="{ rotated: categoryExpanded }">
              <ArrowUp />
            </el-icon>
          </button>
        </div>
      </div>

      <!-- 视频指标筛选 -->
      <div class="filter-row dropdowns-row">
        <span class="filter-label">视频指标：</span>
        <div class="dropdown-group">
          <el-select v-model="filters.playCount" placeholder="播放量" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in tkVideoFilterOptions.playCount" :key="opt.value" :label="'播放量：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.likeCount" placeholder="点赞数" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in tkVideoFilterOptions.likeCount" :key="opt.value" :label="'点赞数：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.commentCount" placeholder="评论数" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in tkVideoFilterOptions.commentCount" :key="opt.value" :label="'评论数：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.shareCount" placeholder="分享数" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in tkVideoFilterOptions.shareCount" :key="opt.value" :label="'分享数：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.engagementRate" placeholder="互动率" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in tkVideoFilterOptions.engagementRate" :key="opt.value" :label="'互动率：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.duration" placeholder="视频时长" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in tkVideoFilterOptions.duration" :key="opt.value" :label="'视频时长：' + opt.label" :value="opt.value" />
          </el-select>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
/*
 * TikTok视频搜索筛选组件
 * 四行筛选：搜索框、国家/地区、视频分类（展开/收起）、视频指标下拉框
 */
import { ref, reactive, computed } from 'vue'
import { Search, ArrowUp } from '@element-plus/icons-vue'
import { tkVideoCountryList, tkVideoCategoryList, tkVideoFilterOptions } from '@/data/tkVideoFilterData'

const emit = defineEmits(['search'])

const searchKeyword = ref('')
const categoryExpanded = ref(false)

const filters = reactive({
  country: 'all',
  category: 'all',
  playCount: 'all',
  likeCount: 'all',
  commentCount: 'all',
  shareCount: 'all',
  engagementRate: 'all',
  duration: 'all',
})

const displayedCategories = computed(() => {
  if (categoryExpanded.value) return tkVideoCategoryList
  return tkVideoCategoryList.slice(0, 12)
})

const selectFilter = (key, value) => { filters[key] = value; handleSearch() }

const handleSearch = () => {
  emit('search', { keyword: searchKeyword.value, ...filters })
}
</script>

<style scoped>
.tk-video-filter { background: #fff; flex-shrink: 0; }

.search-bar { padding: 16px 24px 0; }
.search-input-wrapper { display: flex; align-items: center; height: 48px; border: 1px solid #d9d9d9; border-radius: 24px; overflow: hidden; background: #fff; transition: border-color 0.2s; }
.search-input-wrapper:focus-within { border-color: #7c4dff; }
.search-input { flex: 1; height: 100%; border: none; outline: none; padding: 0 20px; font-size: 14px; color: #262626; background: transparent; }
.search-input::placeholder { color: #8c8c8c; }
.search-btn { width: 56px; height: 48px; border: none; background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%); color: #fff; cursor: pointer; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.search-btn:hover { opacity: 0.9; }

.filter-body { padding: 24px; }
.filter-row { display: flex; align-items: flex-start; margin-bottom: 20px; }
.filter-row:last-child { margin-bottom: 0; }
.filter-label { font-weight: 700; font-size: 14px; color: #262626; white-space: nowrap; padding-top: 6px; min-width: 84px; flex-shrink: 0; }

.tag-group { display: flex; flex-wrap: wrap; gap: 12px; flex: 1; }
.tag-item { font-size: 14px; cursor: pointer; user-select: none; transition: all 0.2s; white-space: nowrap; }

.tag-item.pill-tag { padding: 8px 16px; border-radius: 16px; background: #fff; color: #262626; border: 1px solid #d9d9d9; }
.tag-item.pill-tag.active { background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%); color: #fff; border-color: transparent; }
.tag-item.pill-tag:hover:not(.active) { border-color: #7c4dff; color: #7c4dff; }

.tag-item.rect-tag { padding: 6px 12px; border-radius: 4px; background: #fff; color: #262626; border: none; }
.tag-item.rect-tag.active { background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%); color: #fff; }
.tag-item.rect-tag:hover:not(.active) { background: #f5f5f5; }

.category-area { flex: 1; display: flex; align-items: flex-start; }
.category-tag-group { flex: 1; overflow: hidden; transition: max-height 0.3s ease; max-height: none; }
.category-tag-group.collapsed { max-height: 44px; }

.toggle-btn { display: flex; align-items: center; gap: 4px; border: none; background: none; color: #7c4dff; font-size: 14px; cursor: pointer; padding: 6px 8px; white-space: nowrap; flex-shrink: 0; align-self: flex-start; }
.toggle-icon { transition: transform 0.3s ease; font-size: 12px; }
.toggle-icon.rotated { transform: rotate(180deg); }

.dropdown-group { display: flex; flex-wrap: wrap; gap: 12px; flex: 1; }
.filter-select { width: 170px; }
.filter-select :deep(.el-input__wrapper) { border-radius: 8px; box-shadow: 0 0 0 1px #d9d9d9; }
.filter-select :deep(.el-input__wrapper:hover) { box-shadow: 0 0 0 1px #7c4dff; }
.filter-select :deep(.el-input__inner) { font-size: 14px; color: #262626; }

@media (max-width: 1440px) { .filter-select { width: 155px; } }
@media (max-width: 1024px) {
  .filter-row { flex-direction: column; align-items: stretch; }
  .filter-label { margin-bottom: 8px; min-width: auto; }
  .filter-select { width: 100%; }
}
</style>
