<template>
  <div class="influencer-filter">
    <!-- 顶部搜索栏 -->
    <div class="search-bar">
      <div class="search-row">
        <el-select v-model="searchType" size="default" class="search-type-select">
          <el-option label="达人昵称或ID" value="name-id" />
        </el-select>
        <div class="search-input-wrapper">
          <input
            v-model="searchKeyword"
            type="text"
            class="search-input"
            placeholder="请输入达人昵称或ID进行搜索"
            @keyup.enter="handleSearch"
          />
        </div>
        <button class="search-btn" @click="handleSearch">
          <el-icon :size="18"><Search /></el-icon>
        </button>
        <button class="manual-add-btn">
          <span>+ 手动收录</span>
          <el-icon :size="16"><QuestionFilled /></el-icon>
        </button>
      </div>
    </div>

    <div class="filter-body">
      <!-- 第一行：国家/地区 -->
      <div class="filter-row">
        <span class="filter-label">国家/地区：</span>
        <div class="tag-group">
          <span
            v-for="item in influencerCountryList"
            :key="item.value"
            class="tag-item pill-tag"
            :class="{ active: filters.country === item.value }"
            @click="selectFilter('country', item.value)"
          >{{ item.label }}</span>
        </div>
      </div>

      <!-- 第二至四行：达人分类（展开/收起） -->
      <div class="filter-row">
        <span class="filter-label">达人分类：</span>
        <div class="category-area">
          <div class="tag-group category-tag-group" :class="{ collapsed: !categoryExpanded }">
            <span
              v-for="item in displayedCategories"
              :key="item.value"
              class="tag-item rect-tag"
              :class="{ active: filters.creatorCategory === item.value }"
              @click="selectFilter('creatorCategory', item.value)"
            >{{ item.label }}</span>
          </div>
          <button
            v-if="influencerCategoryList.length > 12"
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

      <!-- 第五至六行：带货品类（复用商品搜索类目，hover触发级联下拉） -->
      <div class="filter-row">
        <span class="filter-label">带货品类：</span>
        <div class="category-area">
          <div class="tag-group category-tag-group" :class="{ collapsed: !productCategoryExpanded }">
            <div
              v-for="item in displayedProductCategories"
              :key="item.value"
              class="category-wrapper"
              @mouseenter="handleProductCategoryHover(item, $event)"
              @mouseleave="handleProductCategoryLeave"
            >
              <span
                class="tag-item rect-tag"
                :class="{ active: filters.productCategory === item.value }"
                @click="selectProductCategory(item.value)"
              >{{ item.label }}</span>
            </div>
          </div>
          <button
            v-if="productCategories.length > 12"
            class="toggle-btn"
            @click="productCategoryExpanded = !productCategoryExpanded"
          >
            {{ productCategoryExpanded ? '收起' : '展开' }}
            <el-icon :size="14" class="toggle-icon" :class="{ rotated: productCategoryExpanded }">
              <ArrowUp />
            </el-icon>
          </button>
        </div>
      </div>

      <!-- 带货品类二级类目下拉面板 -->
      <Teleport to="body">
        <div
          v-if="hoveredProductCategory && hoveredProductCategory.children && hoveredProductCategory.children.length > 0"
          class="category-dropdown-portal"
          :style="productDropdownStyle"
          @mouseenter="keepProductDropdownOpen = true; clearTimeout(productDropdownLeaveTimer)"
          @mouseleave="handleProductDropdownLeave"
        >
          <div
            v-for="subCat in hoveredProductCategory.children"
            :key="subCat.value"
            class="dropdown-item"
            :class="{
              'selected': filters.productSubCategory === subCat.value,
              'has-children': subCat.children && subCat.children.length > 0,
              'sub-hovered': subProductHoveredItem && subProductHoveredItem.value === subCat.value
            }"
            @click="selectProductSubCategory(hoveredProductCategory.value, subCat.value, subCat.children)"
            @mouseenter="handleProductSubCategoryHover(subCat, $event)"
          >
            <span class="dropdown-item-label">{{ subCat.label }}</span>
            <span v-if="subCat.children && subCat.children.length > 0" class="dropdown-item-arrow">&gt;</span>
          </div>
        </div>
      </Teleport>

      <!-- 带货品类三级类目下拉面板 -->
      <Teleport to="body">
        <div
          v-if="subProductHoveredItem && subProductHoveredItem.children && subProductHoveredItem.children.length > 0"
          class="third-level-panel"
          :style="productThirdLevelStyle"
          @mouseenter="handleProductThirdLevelEnter"
          @mouseleave="handleProductThirdLevelLeave"
        >
          <div
            v-for="thirdCat in subProductHoveredItem.children"
            :key="thirdCat.value"
            class="third-level-item"
            :class="{ 'selected': filters.productThirdCategory === thirdCat.value }"
            @click="selectProductThirdCategory(subProductHoveredItem.value, thirdCat.value)"
          >
            {{ thirdCat.label }}
          </div>
        </div>
      </Teleport>

      <!-- 第七行：带货方式 -->
      <div class="filter-row">
        <span class="filter-label">带货方式：</span>
        <div class="toggle-row">
          <label class="ios-switch">
            <input
              v-model="filters.onlyEcommerce"
              type="checkbox"
              class="ios-switch-input"
              @change="handleSearch"
            />
            <span class="ios-switch-slider"></span>
          </label>
          <span class="toggle-text">仅看带货达人</span>
        </div>
      </div>

      <!-- 第八行：达人筛选 -->
      <div class="filter-row">
        <span class="filter-label">达人筛选：</span>
        <div class="dropdown-group">
          <el-select v-model="filters.accountType" placeholder="账号类型" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.accountType" :key="opt.value" :label="'账号类型：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.contractStatus" placeholder="签约状态" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.contractStatus" :key="opt.value" :label="'签约状态：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.verificationType" placeholder="认证类型" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.verificationType" :key="opt.value" :label="'认证类型：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.contactInfo" placeholder="达人联系方式" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.contactInfo" :key="opt.value" :label="'达人联系方式：' + opt.label" :value="opt.value" />
          </el-select>
        </div>
      </div>

      <!-- 第九行：粉丝信息 -->
      <div class="filter-row">
        <span class="filter-label">粉丝信息：</span>
        <div class="dropdown-group">
          <el-select v-model="filters.fanCount" placeholder="粉丝数" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.fanCount" :key="opt.value" :label="'粉丝数：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.fanGender" placeholder="粉丝性别" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.fanGender" :key="opt.value" :label="'粉丝性别：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.fanAge" placeholder="粉丝年龄" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.fanAge" :key="opt.value" :label="'粉丝年龄：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.fanGrowth28d" placeholder="近28天涨粉数" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.fanGrowth28d" :key="opt.value" :label="'近28天涨粉数：' + opt.label" :value="opt.value" />
          </el-select>
        </div>
      </div>

      <!-- 第十行：数据筛选 -->
      <div class="filter-row">
        <span class="filter-label">数据筛选：</span>
        <div class="dropdown-group">
          <el-select v-model="filters.likeFanRatio" placeholder="赞粉比" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.likeFanRatio" :key="opt.value" :label="'赞粉比：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.engagementRate" placeholder="互动率" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.engagementRate" :key="opt.value" :label="'互动率：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.totalSales28d" placeholder="近28天总销量" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.totalSales28d" :key="opt.value" :label="'近28天总销量：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.videoSales28d" placeholder="近28天视频总销量" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.videoSales28d" :key="opt.value" :label="'近28天视频总销量：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.liveSales28d" placeholder="近28天直播总销量" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.liveSales28d" :key="opt.value" :label="'近28天直播总销量：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.avgVideoPlay28d" placeholder="近28天视频平均播放量" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.avgVideoPlay28d" :key="opt.value" :label="'近28天视频平均播放量：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.avgSalesVideoPlay28d" placeholder="近28天带货视频平均播放量" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.avgSalesVideoPlay28d" :key="opt.value" :label="'近28天带货视频平均播放量：' + opt.label" :value="opt.value" />
          </el-select>
          <el-select v-model="filters.firstVideoTime" placeholder="首次视频发布时间" size="default" class="filter-select" @change="handleSearch">
            <el-option v-for="opt in influencerFilterOptions.firstVideoTime" :key="opt.value" :label="'首次视频发布时间：' + opt.label" :value="opt.value" />
          </el-select>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
/*
 * TikTok达人搜索筛选组件
 * 十大模块：搜索栏、国家/地区、达人分类、带货品类、带货方式、达人筛选、粉丝信息、数据筛选
 * 通过 emit('search', params) 向父组件传递筛选参数
 */
import { ref, reactive, computed, nextTick } from 'vue'
import { Search, ArrowUp, QuestionFilled } from '@element-plus/icons-vue'
import { shopifyCategories } from '@/config/categories'
import { influencerCountryList, influencerCategoryList, influencerFilterOptions } from '@/data/influencerFilterData'

const emit = defineEmits(['search'])

// 搜索栏状态
const searchType = ref('name-id')
const searchKeyword = ref('')

// 展开/收起
const categoryExpanded = ref(true)
const productCategoryExpanded = ref(true)

// 带货品类hover级联下拉状态
const hoveredProductCategory = ref(null)
const productDropdownStyle = ref({})
const keepProductDropdownOpen = ref(false)
let productHoverTimer = null

const subProductHoveredItem = ref(null)
const productThirdLevelStyle = ref({})
const keepProductThirdLevelOpen = ref(false)
let productThirdLevelTimer = null
let productDropdownLeaveTimer = null

// 核心筛选状态
const filters = reactive({
  country: 'all',
  creatorCategory: 'all',
  productCategory: 'all',
  productSubCategory: 'all',
  productThirdCategory: 'all',
  onlyEcommerce: false,
  accountType: 'all',
  contractStatus: 'all',
  verificationType: 'all',
  contactInfo: 'all',
  fanCount: 'all',
  fanGender: 'all',
  fanAge: 'all',
  fanGrowth28d: 'all',
  likeFanRatio: 'all',
  engagementRate: 'all',
  totalSales28d: 'all',
  videoSales28d: 'all',
  liveSales28d: 'all',
  avgVideoPlay28d: 'all',
  avgSalesVideoPlay28d: 'all',
  firstVideoTime: 'all',
})

// 达人分类展开/收起
const displayedCategories = computed(() => {
  if (categoryExpanded.value) return influencerCategoryList
  return influencerCategoryList.slice(0, 12)
})

// 带货品类：复用商品搜索类目，排除POD定制、文化产品、虚拟商品、成人用品
const productCategories = computed(() => {
  const exclude = new Set(['POD定制', '文化产品', '虚拟商品', '成人用品'])
  return shopifyCategories.filter(c => c.value === 'all' || !exclude.has(c.label))
})

const displayedProductCategories = computed(() => {
  if (productCategoryExpanded.value) return productCategories.value
  return productCategories.value.slice(0, 12)
})

const selectFilter = (key, value) => {
  filters[key] = value
  if (key === 'productCategory') {
    filters.productSubCategory = 'all'
    filters.productThirdCategory = 'all'
  }
  handleSearch()
}

// 带货品类一级类目点击
const selectProductCategory = (value) => {
  filters.productCategory = value
  filters.productSubCategory = 'all'
  filters.productThirdCategory = 'all'
  handleSearch()
}

// 带货品类hover下拉：一级类目hover
const handleProductCategoryHover = (category, event) => {
  if (!category.children || category.children.length === 0) return
  clearTimeout(productHoverTimer)
  clearTimeout(productThirdLevelTimer)
  clearTimeout(productDropdownLeaveTimer)
  subProductHoveredItem.value = null
  keepProductThirdLevelOpen.value = false
  hoveredProductCategory.value = category
  const rect = event.currentTarget.getBoundingClientRect()
  productDropdownStyle.value = {
    position: 'fixed',
    top: `${rect.bottom + 8}px`,
    left: `${rect.left}px`,
    zIndex: 10001
  }
}

const handleProductCategoryLeave = () => {
  productHoverTimer = setTimeout(() => {
    if (!keepProductDropdownOpen.value) {
      hoveredProductCategory.value = null
    }
  }, 100)
}

// 带货品类hover下拉：二级类目hover
const handleProductSubCategoryHover = (subCat, event) => {
  if (!subCat.children || subCat.children.length === 0) {
    subProductHoveredItem.value = null
    return
  }
  clearTimeout(productThirdLevelTimer)
  subProductHoveredItem.value = subCat
  nextTick(() => {
    const dropdownEl = document.querySelector('.category-dropdown-portal')
    if (dropdownEl) {
      const rect = dropdownEl.getBoundingClientRect()
      productThirdLevelStyle.value = {
        position: 'fixed',
        top: `${rect.top}px`,
        left: `${rect.right}px`,
        zIndex: 10002
      }
    }
  })
}

const handleProductDropdownLeave = () => {
  keepProductDropdownOpen.value = false
  productDropdownLeaveTimer = setTimeout(() => {
    hoveredProductCategory.value = null
    subProductHoveredItem.value = null
    keepProductThirdLevelOpen.value = false
    clearTimeout(productThirdLevelTimer)
  }, 500)
}

const selectProductSubCategory = (parentValue, subValue, subChildren) => {
  filters.productCategory = parentValue
  filters.productSubCategory = subValue
  filters.productThirdCategory = 'all'
  clearTimeout(productThirdLevelTimer)
  clearTimeout(productDropdownLeaveTimer)
  handleSearch()
}

const selectProductThirdCategory = (subValue, thirdValue) => {
  filters.productCategory = thirdValue
  filters.productSubCategory = subValue
  filters.productThirdCategory = thirdValue
  clearTimeout(productThirdLevelTimer)
  clearTimeout(productDropdownLeaveTimer)
  handleSearch()
}

const handleProductThirdLevelEnter = () => {
  clearTimeout(productThirdLevelTimer)
  clearTimeout(productDropdownLeaveTimer)
  keepProductThirdLevelOpen.value = true
}

const handleProductThirdLevelLeave = () => {
  keepProductThirdLevelOpen.value = false
  productThirdLevelTimer = setTimeout(() => {
    subProductHoveredItem.value = null
  }, 400)
}

// 预留：后续联调时替换为真实API请求
const handleSearch = () => {
  const params = { keyword: searchKeyword.value, searchType: searchType.value, ...filters }
  console.log('达人搜索筛选参数:', params)
  emit('search', params)
}
</script>

<style scoped>
.influencer-filter { background: #fff; flex-shrink: 0; }

/* 搜索栏 */
.search-bar { padding: 16px 24px 0; }
.search-row { display: flex; align-items: center; gap: 8px; }
.search-type-select { width: 150px; flex-shrink: 0; }
.search-type-select :deep(.el-input__wrapper) { border-radius: 8px; }
.search-input-wrapper { flex: 1; height: 40px; border: 1px solid #d9d9d9; border-radius: 8px; overflow: hidden; background: #fff; transition: border-color 0.2s; }
.search-input-wrapper:focus-within { border-color: #7c4dff; }
.search-input { width: 100%; height: 100%; border: none; outline: none; padding: 0 12px; font-size: 14px; color: #262626; background: transparent; }
.search-input::placeholder { color: #8c8c8c; }
.search-btn { width: 40px; height: 40px; border: none; background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%); color: #fff; cursor: pointer; border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.search-btn:hover { opacity: 0.9; }
.manual-add-btn { display: flex; align-items: center; gap: 4px; padding: 0 16px; height: 40px; border: 1px solid #7c4dff; background: #fff; color: #7c4dff; border-radius: 20px; font-size: 14px; cursor: pointer; white-space: nowrap; flex-shrink: 0; }
.manual-add-btn:hover { background: #f5f0ff; }

/* 筛选主体 */
.filter-body { padding: 24px; }
.filter-row { display: flex; align-items: flex-start; margin-bottom: 20px; }
.filter-row:last-child { margin-bottom: 0; }
.filter-label { font-weight: 700; font-size: 14px; color: #262626; white-space: nowrap; padding-top: 6px; min-width: 84px; flex-shrink: 0; }

/* 标签组 */
.tag-group { display: flex; flex-wrap: wrap; gap: 12px; flex: 1; }
.tag-item { font-size: 14px; cursor: pointer; user-select: none; transition: all 0.2s; white-space: nowrap; }

.tag-item.pill-tag { padding: 8px 16px; border-radius: 16px; background: #fff; color: #262626; border: 1px solid #d9d9d9; }
.tag-item.pill-tag.active { background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%); color: #fff; border-color: transparent; }
.tag-item.pill-tag:hover:not(.active) { border-color: #7c4dff; color: #7c4dff; }

.tag-item.rect-tag { padding: 6px 12px; border-radius: 4px; background: #fff; color: #262626; border: none; }
.tag-item.rect-tag.active { background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%); color: #fff; }
.tag-item.rect-tag:hover:not(.active) { background: #f5f5f5; }

/* 展开/收起 */
.category-area { flex: 1; display: flex; align-items: flex-start; }
.category-tag-group { flex: 1; overflow: hidden; transition: max-height 0.3s ease; max-height: none; }
.category-tag-group.collapsed { max-height: 44px; }

.category-wrapper { position: relative; display: inline-block; }

.toggle-btn { display: flex; align-items: center; gap: 4px; border: none; background: none; color: #7c4dff; font-size: 14px; cursor: pointer; padding: 6px 8px; white-space: nowrap; flex-shrink: 0; align-self: flex-start; }
.toggle-icon { transition: transform 0.3s ease; font-size: 12px; }
.toggle-icon.rotated { transform: rotate(180deg); }

/* 带货方式开关 */
.toggle-row { display: flex; align-items: center; gap: 10px; padding-top: 2px; }
.toggle-text { font-size: 14px; color: #262626; }
.ios-switch { position: relative; display: inline-block; width: 44px; height: 26px; }
.ios-switch-input { opacity: 0; width: 0; height: 0; }
.ios-switch-slider { position: absolute; cursor: pointer; inset: 0; background: #d9d9d9; border-radius: 26px; transition: 0.3s; }
.ios-switch-slider::before { content: ''; position: absolute; height: 20px; width: 20px; left: 3px; bottom: 3px; background: #fff; border-radius: 50%; transition: 0.3s; box-shadow: 0 1px 3px rgba(0,0,0,0.2); }
.ios-switch-input:checked + .ios-switch-slider { background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%); }
.ios-switch-input:checked + .ios-switch-slider::before { transform: translateX(18px); }

/* 下拉框 */
.dropdown-group { display: flex; flex-wrap: wrap; gap: 12px; flex: 1; }
.filter-select { width: 170px; }
.filter-select :deep(.el-input__wrapper) { border-radius: 8px; box-shadow: 0 0 0 1px #d9d9d9; height: 32px; }
.filter-select :deep(.el-input__wrapper:hover) { box-shadow: 0 0 0 1px #7c4dff; }
.filter-select :deep(.el-input__inner) { font-size: 14px; color: #262626; height: 30px; line-height: 30px; }

/* 响应式 */
@media (max-width: 1440px) { .filter-select { width: 155px; } }
@media (max-width: 1024px) {
  .filter-row { flex-direction: column; align-items: stretch; }
  .filter-label { margin-bottom: 8px; min-width: auto; }
  .filter-select { width: 100%; }
  .search-row { flex-wrap: wrap; }
  .search-type-select { width: 130px; }
}
</style>

<style>
.category-dropdown-portal {
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  padding: 8px;
  min-width: 160px;
  max-width: 180px;
  max-height: 200px;
  overflow-y: auto;
}

.category-dropdown-portal::-webkit-scrollbar { width: 6px; }
.category-dropdown-portal::-webkit-scrollbar-track { background: #f1f1f1; border-radius: 3px; }
.category-dropdown-portal::-webkit-scrollbar-thumb { background: #ccc; border-radius: 3px; }
.category-dropdown-portal::-webkit-scrollbar-thumb:hover { background: #999; }

.dropdown-item {
  display: flex;
  align-items: center;
  padding: 10px 16px;
  cursor: pointer;
  border-radius: 8px;
  transition: all 0.2s;
  font-size: 14px;
  color: #333;
}

.dropdown-item-label { flex: 1; }
.dropdown-item-arrow { margin-left: 8px; color: #bbb; font-size: 12px; font-weight: bold; }
.dropdown-item:hover { background-color: #f5f5f5; }
.dropdown-item.selected { background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%); color: white; }
.dropdown-item.has-children:hover { background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%); color: white; }
.dropdown-item.sub-hovered { background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%); color: white; }

.third-level-panel {
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  padding: 8px;
  width: 160px;
  max-height: 200px;
  overflow-y: auto;
}

.third-level-panel::-webkit-scrollbar { width: 6px; }
.third-level-panel::-webkit-scrollbar-track { background: #f5f5f5; border-radius: 3px; }
.third-level-panel::-webkit-scrollbar-thumb { background: #d9d9d9; border-radius: 3px; }

.third-level-item {
  padding: 10px 16px;
  cursor: pointer;
  border-radius: 8px;
  transition: background-color 0.15s;
  font-size: 14px;
  color: #333;
}

.third-level-item:hover { background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%); color: white; }
.third-level-item.selected { background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%); color: white; }
</style>
