<template>
  <div class="tk-ad-filter">
    <div class="search-bar">
      <div class="search-input-wrapper">
        <input
          v-model="searchKeyword"
          type="text"
          class="search-input"
          placeholder="输入广告关键词或品牌名称搜索"
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
            v-for="item in tkAdCountryList"
            :key="item.value"
            class="tag-item pill-tag"
            :class="{ active: filters.country === item.value }"
            @click="selectFilter('country', item.value)"
          >{{ item.label }}</span>
        </div>
      </div>

      <!-- 广告类型 -->
      <div class="filter-row">
        <span class="filter-label">广告类型：</span>
        <div class="tag-group">
          <span
            v-for="item in tkAdTypeList"
            :key="item.value"
            class="tag-item rect-tag"
            :class="{ active: filters.adType === item.value }"
            @click="selectFilter('adType', item.value)"
          >{{ item.label }}</span>
        </div>
      </div>

      <!-- 行业分类 -->
      <div class="filter-row">
        <span class="filter-label">行业分类：</span>
        <div class="tag-group">
          <span
            v-for="item in tkAdIndustryList"
            :key="item.value"
            class="tag-item rect-tag"
            :class="{ active: filters.industry === item.value }"
            @click="selectFilter('industry', item.value)"
          >{{ item.label }}</span>
        </div>
      </div>

      <!-- 广告指标筛选 -->
      <div class="filter-row dropdowns-row">
        <span class="filter-label">广告指标：</span>
        <div class="dropdown-group">
          <el-select v-model="filters.impressions" placeholder="曝光量" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in tkAdFilterOptions.impressions" :key="opt.value" :label="'曝光量：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.ctr" placeholder="点击率" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in tkAdFilterOptions.ctr" :key="opt.value" :label="'点击率：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.cvr" placeholder="转化率" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in tkAdFilterOptions.cvr" :key="opt.value" :label="'转化率：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.engagementRate" placeholder="互动率" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in tkAdFilterOptions.engagementRate" :key="opt.value" :label="'互动率：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.duration" placeholder="投放时间" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in tkAdFilterOptions.duration" :key="opt.value" :label="'投放时间：' + opt.label" :value="opt.value" />
          </el-select>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
/*
 * TikTok广告搜索筛选组件
 * 五行筛选：搜索框、国家/地区、广告类型、行业分类、广告指标下拉框
 */
import { ref, reactive } from 'vue'
import { Search } from '@element-plus/icons-vue'
import { tkAdCountryList, tkAdTypeList, tkAdIndustryList, tkAdFilterOptions } from '@/data/tkAdFilterData'

const emit = defineEmits(['search'])

const searchKeyword = ref('')

const filters = reactive({
  country: 'all',
  adType: 'all',
  industry: 'all',
  impressions: 'all',
  ctr: 'all',
  cvr: 'all',
  engagementRate: 'all',
  duration: 'all',
})

const selectFilter = (key, value) => { filters[key] = value; handleSearch() }

const handleSearch = () => {
  emit('search', { keyword: searchKeyword.value, ...filters })
}
</script>

<style scoped>
.tk-ad-filter { background: #fff; flex-shrink: 0; }

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
