<template>
  <div class="hot-video-filter">
    <div class="search-bar">
      <div class="search-input-wrapper">
        <input
          type="text"
          class="search-input"
          placeholder="热门视频"
          readonly
        />
        <button class="search-btn">
          <el-icon :size="18"><Search /></el-icon>
        </button>
      </div>
    </div>

    <div class="filter-body">
      <!-- 国家/地区筛选 -->
      <div class="filter-row country-row">
        <span class="filter-label">国家/地区：</span>
        <div class="tag-group">
          <span
            v-for="country in countryList"
            :key="country.value"
            class="tag-item country-tag"
            :class="{ active: selectedCountry === country.value }"
            @click="selectCountry(country.value)"
          >{{ country.label }}</span>
        </div>
      </div>

      <!-- 达人分类筛选（支持展开/收起） -->
      <div class="filter-row category-row">
        <span class="filter-label">达人分类：</span>
        <div class="category-area">
          <div class="tag-group category-tag-group" :class="{ collapsed: !categoryExpanded }">
            <span
              v-for="cat in displayedCategories"
              :key="cat.value"
              class="tag-item category-tag"
              :class="{ active: selectedCategory === cat.value }"
              @click="selectCategory(cat.value)"
            >{{ cat.label }}</span>
          </div>
          <button
            v-if="creatorCategoryList.length > 12"
            class="toggle-btn"
            @click="toggleCategoryExpand"
          >
            {{ categoryExpanded ? '收起' : '展开' }}
            <el-icon :size="14" class="toggle-icon" :class="{ rotated: categoryExpanded }">
              <ArrowUp />
            </el-icon>
          </button>
        </div>
      </div>

      <!-- 筛选条件下拉框 -->
      <div class="filter-row filter-conditions-row">
        <span class="filter-label">筛选条件：</span>
        <div class="dropdown-group">
          <el-select
            v-model="selectedFollowerCount"
            placeholder="达人粉丝数"
            size="default"
            class="filter-select"
            @change="onFilterChange"
          >
            <el-option
              v-for="opt in filterOptions.followerCount"
              :key="opt.value"
              :label="getSelectLabel('达人粉丝数', opt.label)"
              :value="opt.value"
            />
          </el-select>
          <el-select
            v-model="selectedPlayCount"
            placeholder="播放量"
            size="default"
            class="filter-select"
            @change="onFilterChange"
          >
            <el-option
              v-for="opt in filterOptions.playCount"
              :key="opt.value"
              :label="getSelectLabel('播放量', opt.label)"
              :value="opt.value"
            />
          </el-select>
          <el-select
            v-model="selectedLikeCount"
            placeholder="点赞数"
            size="default"
            class="filter-select"
            @change="onFilterChange"
          >
            <el-option
              v-for="opt in filterOptions.likeCount"
              :key="opt.value"
              :label="getSelectLabel('点赞数', opt.label)"
              :value="opt.value"
            />
          </el-select>
          <el-select
            v-model="selectedEngagementRate"
            placeholder="互动率"
            size="default"
            class="filter-select"
            @change="onFilterChange"
          >
            <el-option
              v-for="opt in filterOptions.engagementRate"
              :key="opt.value"
              :label="getSelectLabel('互动率', opt.label)"
              :value="opt.value"
            />
          </el-select>
          <el-select
            v-model="selectedWithProduct"
            placeholder="是否带货"
            size="default"
            class="filter-select"
            @change="onFilterChange"
          >
            <el-option
              v-for="opt in filterOptions.withProduct"
              :key="opt.value"
              :label="getSelectLabel('是否带货', opt.label)"
              :value="opt.value"
            />
          </el-select>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
/*
 * Shopify热门视频筛选组件
 * 三大模块：国家/地区、达人分类（展开/收起）、筛选条件下拉框
 * 预留 emit('filter-change', params) 供后续联调使用
 */
import { ref, computed } from 'vue'
import { Search, ArrowUp } from '@element-plus/icons-vue'
import { countryList, creatorCategoryList, filterOptions } from '@/data/hotVideoData'

const emit = defineEmits(['filter-change'])

const selectedCountry = ref('all')
const selectedCategory = ref('all')
const categoryExpanded = ref(false)

const selectedFollowerCount = ref('')
const selectedPlayCount = ref('')
const selectedLikeCount = ref('')
const selectedEngagementRate = ref('')
const selectedWithProduct = ref('')

// 收起时只显示前12个，展开时显示全部
const displayedCategories = computed(() => {
  if (categoryExpanded.value) return creatorCategoryList
  return creatorCategoryList.slice(0, 12)
})

const selectCountry = (value) => {
  selectedCountry.value = value
  emitFilterChange()
}

const selectCategory = (value) => {
  selectedCategory.value = value
  emitFilterChange()
}

const toggleCategoryExpand = () => {
  categoryExpanded.value = !categoryExpanded.value
}

const getSelectLabel = (prefix, label) => {
  return prefix + '：' + label
}

// 预留：后续联调时在此组装参数并触发真实数据请求
const onFilterChange = () => {
  emitFilterChange()
}

const emitFilterChange = () => {
  const params = {
    country: selectedCountry.value,
    category: selectedCategory.value,
    followerCount: selectedFollowerCount.value || 'all',
    playCount: selectedPlayCount.value || 'all',
    likeCount: selectedLikeCount.value || 'all',
    engagementRate: selectedEngagementRate.value || 'all',
    withProduct: selectedWithProduct.value || 'all',
  }
  // TODO: 后续联调时替换为真实API请求
  console.log('筛选参数:', params)
  emit('filter-change', params)
}
</script>

<style scoped>
.hot-video-filter {
  background: #fff;
  flex-shrink: 0;
}

/* 搜索栏 */
.search-bar {
  padding: 16px 24px 0;
}

.search-input-wrapper {
  display: flex;
  align-items: center;
  height: 48px;
  border: 1px solid #d9d9d9;
  border-radius: 24px;
  overflow: hidden;
  background: #fff;
}

.search-input {
  flex: 1;
  height: 100%;
  border: none;
  outline: none;
  padding: 0 20px;
  font-size: 14px;
  color: #8c8c8c;
  background: transparent;
}

.search-btn {
  width: 56px;
  height: 48px;
  border: none;
  background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%);
  color: #fff;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

/* 筛选主体 */
.filter-body {
  padding: 24px;
}

.filter-row {
  display: flex;
  align-items: flex-start;
  margin-bottom: 20px;
}

.filter-row:last-child {
  margin-bottom: 0;
}

.filter-label {
  font-weight: 700;
  font-size: 14px;
  color: #262626;
  white-space: nowrap;
  padding-top: 6px;
  min-width: 84px;
  flex-shrink: 0;
}

/* 国家/地区标签 */
.tag-group {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  flex: 1;
}

.tag-item {
  font-size: 14px;
  cursor: pointer;
  user-select: none;
  transition: all 0.2s;
}

.tag-item.country-tag {
  padding: 8px 16px;
  border-radius: 16px;
  background: #fff;
  color: #262626;
  border: 1px solid #d9d9d9;
}

.tag-item.country-tag.active {
  background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%);
  color: #fff;
  border-color: transparent;
}

.tag-item.country-tag:hover:not(.active) {
  border-color: #7c4dff;
  color: #7c4dff;
}

/* 达人分类标签 */
.category-row {
  align-items: flex-start;
}

.category-area {
  flex: 1;
  display: flex;
  align-items: flex-start;
}

.category-tag-group {
  flex: 1;
  overflow: hidden;
  transition: max-height 0.3s ease;
  max-height: none;
}

.category-tag-group.collapsed {
  max-height: 44px;
}

.tag-item.category-tag {
  padding: 6px 12px;
  border-radius: 4px;
  background: #fff;
  color: #262626;
  border: none;
}

.tag-item.category-tag.active {
  background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%);
  color: #fff;
}

.tag-item.category-tag:hover:not(.active) {
  background: #f5f5f5;
}

/* 展开/收起按钮 */
.toggle-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  border: none;
  background: none;
  color: #7c4dff;
  font-size: 14px;
  cursor: pointer;
  padding: 6px 8px;
  white-space: nowrap;
  flex-shrink: 0;
  align-self: flex-start;
}

.toggle-icon {
  transition: transform 0.3s ease;
  font-size: 12px;
}

.toggle-icon.rotated {
  transform: rotate(180deg);
}

/* 筛选条件下拉框 */
.filter-conditions-row {
  padding-top: 4px;
}

.dropdown-group {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  flex: 1;
}

.filter-select {
  width: 170px;
}

.filter-select :deep(.el-input__wrapper) {
  border-radius: 8px;
  box-shadow: 0 0 0 1px #d9d9d9;
}

.filter-select :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #7c4dff;
}

.filter-select :deep(.el-input__inner) {
  font-size: 14px;
  color: #262626;
}

/* 响应式 */
@media (max-width: 1440px) {
  .filter-select {
    width: 155px;
  }
}

@media (max-width: 1024px) {
  .filter-row {
    flex-direction: column;
    align-items: stretch;
  }

  .filter-label {
    margin-bottom: 8px;
    min-width: auto;
  }

  .filter-select {
    width: 100%;
  }
}
</style>
