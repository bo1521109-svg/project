<template>
  <div class="search-filter-section">
    <div class="search-area">
      <div class="search-wrapper">
        <el-input
          v-model="searchKeyword"
          placeholder="请输入商品名称或关键词搜索"
          class="search-input"
          clearable
          @keyup.enter="handleSearch"
        >
          <template #suffix>
            <el-icon class="search-icon" @click="handleSearch">
              <Search />
            </el-icon>
          </template>
        </el-input>
      </div>
    </div>

    <div class="filter-area">
      <div class="filter-row">
        <div class="filter-label">国家/地区：</div>
        <div class="filter-content">
          <div class="filter-tags filter-tags-country" :class="{ 'single-line': collapsedSections.country }">
            <el-tag
              v-for="country in countries"
              :key="country.value"
              :type="selectedCountry === country.value ? '' : 'info'"
              :effect="selectedCountry === country.value ? 'dark' : 'plain'"
              :class="{ 'tag-selected': selectedCountry === country.value }"
              @click="selectCountry(country.value)"
              class="filter-tag"
            >
              {{ country.label }}
            </el-tag>
          </div>
          <el-button
            v-if="showCountryToggle"
            link
            type="primary"
            @click="toggleSection('country')"
            class="toggle-btn"
          >
            {{ collapsedSections.country ? '展开' : '收起' }}
            <el-icon><ArrowDown v-if="collapsedSections.country" /><ArrowUp v-else /></el-icon>
          </el-button>
        </div>
      </div>

      <div class="filter-row">
        <div class="filter-label">类目：</div>
        <div class="filter-content">
          <div class="filter-tags filter-tags-category" :class="{ 'single-line': collapsedSections.category }">
            <div
              v-for="category in categories"
              :key="category.value"
              class="category-wrapper"
              @mouseenter="handleCategoryHover(category, $event)"
              @mouseleave="handleCategoryLeave"
            >
              <el-tag
                :type="selectedCategory === category.value ? '' : 'info'"
                :effect="selectedCategory === category.value ? 'dark' : 'plain'"
                :class="{ 'tag-selected': selectedCategory === category.value }"
                @click="selectCategory(category.value)"
                class="filter-tag"
              >
                {{ category.label }}
              </el-tag>
            </div>
          </div>
          <el-button
            v-if="showCategoryToggle"
            link
            type="primary"
            @click="toggleSection('category')"
            class="toggle-btn"
          >
            {{ collapsedSections.category ? '展开' : '收起' }}
            <el-icon><ArrowDown v-if="collapsedSections.category" /><ArrowUp v-else /></el-icon>
          </el-button>
        </div>
      </div>

      <Teleport to="body">
        <div
          v-if="hoveredCategory && hoveredCategory.children.length > 0"
          class="category-dropdown-portal"
          :style="dropdownStyle"
          @mouseenter="keepDropdownOpen = true; clearTimeout(dropdownLeaveTimer)"
          @mouseleave="handleDropdownLeave"
        >
          <div
            v-for="subCat in hoveredCategory.children"
            :key="subCat.value"
            class="dropdown-item"
            :class="{
              'selected': selectedSubCategory === subCat.value,
              'has-children': subCat.children && subCat.children.length > 0,
              'sub-hovered': subHoveredItem && subHoveredItem.value === subCat.value
            }"
            @click="selectSubCategory(hoveredCategory.value, subCat.value, subCat.children)"
            @mouseenter="handleSubCategoryHover(subCat, $event)"
          >
            <span class="dropdown-item-label">{{ subCat.label }}</span>
            <span v-if="subCat.children && subCat.children.length > 0" class="dropdown-item-arrow">&gt;</span>
          </div>
        </div>
      </Teleport>

      <Teleport to="body">
        <div
          v-if="subHoveredItem && subHoveredItem.children && subHoveredItem.children.length > 0"
          class="third-level-panel"
          :style="thirdLevelPanelStyle"
          @mouseenter="handleThirdLevelEnter"
          @mouseleave="handleThirdLevelLeave"
        >
          <div
            v-for="thirdCat in subHoveredItem.children"
            :key="thirdCat.value"
            class="third-level-item"
            :class="{ 'selected': selectedThirdCategory === thirdCat.value }"
            @click="selectThirdCategory(subHoveredItem.value, thirdCat.value)"
          >
            {{ thirdCat.label }}
          </div>
        </div>
      </Teleport>

      <div class="filter-row advanced-filters">
        <div class="filter-label">筛选条件：</div>
        <div class="filter-content">
          <div class="filter-selects">
            <el-popover
              :visible="ratingPopoverVisible"
              placement="bottom"
              :width="300"
              trigger="click"
              popper-class="custom-filter-popover"
            >
              <template #reference>
                <div class="custom-select-trigger" @click="ratingPopoverVisible = !ratingPopoverVisible">
                  <span class="select-label">商品评分：</span>
                  <span class="select-value">{{ getRatingLabel }}</span>
                  <el-icon class="select-arrow"><ArrowDown /></el-icon>
                </div>
              </template>
              <div class="filter-popover-content">
                <div class="filter-options">
                  <div
                    v-for="option in ratingOptions"
                    :key="option.value"
                    class="filter-option"
                    :class="{ 'is-selected': tempRating === option.value }"
                    @click="selectRatingOption(option)"
                  >
                    {{ option.label }}
                  </div>
                </div>
                <div class="filter-range-inputs">
                  <el-input v-model="tempRatingMin" placeholder="最小值" readonly />
                  <span class="range-separator">-</span>
                  <el-input v-model="tempRatingMax" placeholder="最大值" readonly />
                </div>
                <div class="filter-actions">
                  <el-button class="reset-btn" @click="resetRating">重置</el-button>
                  <el-button type="primary" class="confirm-btn" @click="confirmRating">确认</el-button>
                </div>
              </div>
            </el-popover>

            <el-popover
              :visible="sales7dPopoverVisible"
              placement="bottom"
              :width="300"
              trigger="click"
              popper-class="custom-filter-popover"
            >
              <template #reference>
                <div class="custom-select-trigger" @click="sales7dPopoverVisible = !sales7dPopoverVisible">
                  <span class="select-label">近7天销量：</span>
                  <span class="select-value">{{ getSales7dLabel }}</span>
                  <el-icon class="select-arrow"><ArrowDown /></el-icon>
                </div>
              </template>
              <div class="filter-popover-content">
                <div class="filter-options">
                  <div
                    v-for="option in sales7dOptions"
                    :key="option.value"
                    class="filter-option"
                    :class="{ 'is-selected': tempSales7d === option.value }"
                    @click="selectSales7dOption(option)"
                  >
                    {{ option.label }}
                  </div>
                </div>
                <div class="filter-range-inputs">
                  <el-input v-model="tempSales7dMin" placeholder="最小值" readonly />
                  <span class="range-separator">-</span>
                  <el-input v-model="tempSales7dMax" placeholder="最大值" readonly />
                </div>
                <div class="filter-actions">
                  <el-button class="reset-btn" @click="resetSales7d">重置</el-button>
                  <el-button type="primary" class="confirm-btn" @click="confirmSales7d">确认</el-button>
                </div>
              </div>
            </el-popover>

            <el-popover
              :visible="revenue7dPopoverVisible"
              placement="bottom"
              :width="300"
              trigger="click"
              popper-class="custom-filter-popover"
            >
              <template #reference>
                <div class="custom-select-trigger" @click="revenue7dPopoverVisible = !revenue7dPopoverVisible">
                  <span class="select-label">近7天销售额：</span>
                  <span class="select-value">{{ getRevenue7dLabel }}</span>
                  <el-icon class="select-arrow"><ArrowDown /></el-icon>
                </div>
              </template>
              <div class="filter-popover-content">
                <div class="filter-options">
                  <div
                    v-for="option in revenue7dOptions"
                    :key="option.value"
                    class="filter-option"
                    :class="{ 'is-selected': tempRevenue7d === option.value }"
                    @click="selectRevenue7dOption(option)"
                  >
                    {{ option.label }}
                  </div>
                </div>
                <div class="filter-range-inputs">
                  <el-input v-model="tempRevenue7dMin" placeholder="最小值" readonly />
                  <span class="range-separator">-</span>
                  <el-input v-model="tempRevenue7dMax" placeholder="最大值" readonly />
                </div>
                <div class="filter-actions">
                  <el-button class="reset-btn" @click="resetRevenue7d">重置</el-button>
                  <el-button type="primary" class="confirm-btn" @click="confirmRevenue7d">确认</el-button>
                </div>
              </div>
            </el-popover>

            <el-popover
              :visible="totalSalesPopoverVisible"
              placement="bottom"
              :width="300"
              trigger="click"
              popper-class="custom-filter-popover"
            >
              <template #reference>
                <div class="custom-select-trigger" @click="totalSalesPopoverVisible = !totalSalesPopoverVisible">
                  <span class="select-label">总销量：</span>
                  <span class="select-value">{{ getTotalSalesLabel }}</span>
                  <el-icon class="select-arrow"><ArrowDown /></el-icon>
                </div>
              </template>
              <div class="filter-popover-content">
                <div class="filter-options">
                  <div
                    v-for="option in totalSalesOptions"
                    :key="option.value"
                    class="filter-option"
                    :class="{ 'is-selected': tempTotalSales === option.value }"
                    @click="selectTotalSalesOption(option)"
                  >
                    {{ option.label }}
                  </div>
                </div>
                <div class="filter-range-inputs">
                  <el-input v-model="tempTotalSalesMin" placeholder="最小值" readonly />
                  <span class="range-separator">-</span>
                  <el-input v-model="tempTotalSalesMax" placeholder="最大值" readonly />
                </div>
                <div class="filter-actions">
                  <el-button class="reset-btn" @click="resetTotalSales">重置</el-button>
                  <el-button type="primary" class="confirm-btn" @click="confirmTotalSales">确认</el-button>
                </div>
              </div>
            </el-popover>

            <el-popover
              :visible="totalRevenuePopoverVisible"
              placement="bottom"
              :width="300"
              trigger="click"
              popper-class="custom-filter-popover"
            >
              <template #reference>
                <div class="custom-select-trigger" @click="totalRevenuePopoverVisible = !totalRevenuePopoverVisible">
                  <span class="select-label">总销售额：</span>
                  <span class="select-value">{{ getTotalRevenueLabel }}</span>
                  <el-icon class="select-arrow"><ArrowDown /></el-icon>
                </div>
              </template>
              <div class="filter-popover-content">
                <div class="filter-options">
                  <div
                    v-for="option in totalRevenueOptions"
                    :key="option.value"
                    class="filter-option"
                    :class="{ 'is-selected': tempTotalRevenue === option.value }"
                    @click="selectTotalRevenueOption(option)"
                  >
                    {{ option.label }}
                  </div>
                </div>
                <div class="filter-range-inputs">
                  <el-input v-model="tempTotalRevenueMin" placeholder="最小值" readonly />
                  <span class="range-separator">-</span>
                  <el-input v-model="tempTotalRevenueMax" placeholder="最大值" readonly />
                </div>
                <div class="filter-actions">
                  <el-button class="reset-btn" @click="resetTotalRevenue">重置</el-button>
                  <el-button type="primary" class="confirm-btn" @click="confirmTotalRevenue">确认</el-button>
                </div>
              </div>
            </el-popover>

            <el-popover
              :visible="influencerCountPopoverVisible"
              placement="bottom"
              :width="300"
              trigger="click"
              popper-class="custom-filter-popover"
            >
              <template #reference>
                <div class="custom-select-trigger" @click="influencerCountPopoverVisible = !influencerCountPopoverVisible">
                  <span class="select-label">带货达人数：</span>
                  <span class="select-value">{{ getInfluencerCountLabel }}</span>
                  <el-icon class="select-arrow"><ArrowDown /></el-icon>
                </div>
              </template>
              <div class="filter-popover-content">
                <div class="filter-options">
                  <div
                    v-for="option in influencerCountOptions"
                    :key="option.value"
                    class="filter-option"
                    :class="{ 'is-selected': tempInfluencerCount === option.value }"
                    @click="selectInfluencerCountOption(option)"
                  >
                    {{ option.label }}
                  </div>
                </div>
                <div class="filter-range-inputs">
                  <el-input v-model="tempInfluencerCountMin" placeholder="最小值" readonly />
                  <span class="range-separator">-</span>
                  <el-input v-model="tempInfluencerCountMax" placeholder="最大值" readonly />
                </div>
                <div class="filter-actions">
                  <el-button class="reset-btn" @click="resetInfluencerCount">重置</el-button>
                  <el-button type="primary" class="confirm-btn" @click="confirmInfluencerCount">确认</el-button>
                </div>
              </div>
            </el-popover>

            <el-popover
              :visible="newProductRatioPopoverVisible"
              placement="bottom"
              :width="300"
              trigger="click"
              popper-class="custom-filter-popover"
            >
              <template #reference>
                <div class="custom-select-trigger" @click="newProductRatioPopoverVisible = !newProductRatioPopoverVisible">
                  <span class="select-label">新品成交占比：</span>
                  <span class="select-value">{{ getNewProductRatioLabel }}</span>
                  <el-icon class="select-arrow"><ArrowDown /></el-icon>
                </div>
              </template>
              <div class="filter-popover-content">
                <div class="filter-options">
                  <div
                    v-for="option in newProductRatioOptions"
                    :key="option.value"
                    class="filter-option"
                    :class="{ 'is-selected': tempNewProductRatio === option.value }"
                    @click="selectNewProductRatioOption(option)"
                  >
                    {{ option.label }}
                  </div>
                </div>
                <div class="filter-range-inputs">
                  <el-input v-model="tempNewProductRatioMin" placeholder="最小值" readonly />
                  <span class="range-separator">-</span>
                  <el-input v-model="tempNewProductRatioMax" placeholder="最大值" readonly />
                </div>
                <div class="filter-actions">
                  <el-button class="reset-btn" @click="resetNewProductRatio">重置</el-button>
                  <el-button type="primary" class="confirm-btn" @click="confirmNewProductRatio">确认</el-button>
                </div>
              </div>
            </el-popover>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import { Search, ArrowDown, ArrowUp } from '@element-plus/icons-vue'
import { shopifyCategories } from '../../config/categories'

const emit = defineEmits(['search'])

const searchKeyword = ref('')

const collapsedSections = ref({
  country: true,
  category: true
})

const showCountryToggle = ref(false)
const showCategoryToggle = ref(false)

const selectedCountry = ref('all')
const selectedCategory = ref('all')
const selectedSubCategory = ref('')
const selectedThirdCategory = ref('')

const hoveredCategory = ref(null)
const dropdownStyle = ref({})
const keepDropdownOpen = ref(false)
let hoverTimer = null

const subHoveredItem = ref(null)
const thirdLevelPanelStyle = ref({})
const keepThirdLevelOpen = ref(false)
let thirdLevelTimer = null
let dropdownLeaveTimer = null

const ratingPopoverVisible = ref(false)
const sales7dPopoverVisible = ref(false)
const revenue7dPopoverVisible = ref(false)
const totalSalesPopoverVisible = ref(false)
const totalRevenuePopoverVisible = ref(false)
const influencerCountPopoverVisible = ref(false)
const newProductRatioPopoverVisible = ref(false)

const tempRating = ref('all')
const tempRatingMin = ref('')
const tempRatingMax = ref('')

const tempSales7d = ref('all')
const tempSales7dMin = ref('')
const tempSales7dMax = ref('')

const tempRevenue7d = ref('all')
const tempRevenue7dMin = ref('')
const tempRevenue7dMax = ref('')

const tempTotalSales = ref('all')
const tempTotalSalesMin = ref('')
const tempTotalSalesMax = ref('')

const tempTotalRevenue = ref('all')
const tempTotalRevenueMin = ref('')
const tempTotalRevenueMax = ref('')

const tempInfluencerCount = ref('all')
const tempInfluencerCountMin = ref('')
const tempInfluencerCountMax = ref('')

const tempNewProductRatio = ref('all')
const tempNewProductRatioMin = ref('')
const tempNewProductRatioMax = ref('')

const ratingOptions = [
  { label: '全部', value: 'all', min: '', max: '' },
  { label: '4.6-5.0', value: '4.6-5.0', min: '4.6', max: '5.0' },
  { label: '4.1-4.5', value: '4.1-4.5', min: '4.1', max: '4.5' },
  { label: '3.6-4.0', value: '3.6-4.0', min: '3.6', max: '4.0' },
  { label: '3.0-3.5', value: '3.0-3.5', min: '3.0', max: '3.5' },
  { label: '<3.0', value: '<3.0', min: '', max: '3.0' }
]

const sales7dOptions = [
  { label: '全部', value: 'all', min: '', max: '' },
  { label: '>10万', value: '>100000', min: '100000', max: '' },
  { label: '5万-10万', value: '50000-100000', min: '50000', max: '100000' },
  { label: '1万-5万', value: '10000-50000', min: '10000', max: '50000' },
  { label: '5000-9999', value: '5000-9999', min: '5000', max: '9999' },
  { label: '1000-4999', value: '1000-4999', min: '1000', max: '4999' },
  { label: '500-999', value: '500-999', min: '500', max: '999' },
  { label: '<500', value: '<500', min: '', max: '500' }
]

const revenue7dOptions = [
  { label: '全部', value: 'all', min: '', max: '' },
  { label: '>$10万', value: '>100000', min: '100000', max: '' },
  { label: '$5万-$10万', value: '50000-100000', min: '50000', max: '100000' },
  { label: '$1万-$5万', value: '10000-50000', min: '10000', max: '50000' },
  { label: '$5000-$9999', value: '5000-9999', min: '5000', max: '9999' },
  { label: '$1000-$4999', value: '1000-4999', min: '1000', max: '4999' },
  { label: '$500-$999', value: '500-999', min: '500', max: '999' },
  { label: '<$500', value: '<500', min: '', max: '500' }
]

const totalSalesOptions = [
  { label: '全部', value: 'all', min: '', max: '' },
  { label: '>100万', value: '>1000000', min: '1000000', max: '' },
  { label: '50万-100万', value: '500000-1000000', min: '500000', max: '1000000' },
  { label: '10万-50万', value: '100000-500000', min: '100000', max: '500000' },
  { label: '1万-10万', value: '10000-100000', min: '10000', max: '100000' },
  { label: '5000-1万', value: '5000-10000', min: '5000', max: '10000' },
  { label: '<5000', value: '<5000', min: '', max: '5000' }
]

const totalRevenueOptions = [
  { label: '全部', value: 'all', min: '', max: '' },
  { label: '>$100万', value: '>1000000', min: '1000000', max: '' },
  { label: '$50万-$100万', value: '500000-1000000', min: '500000', max: '1000000' },
  { label: '$10万-$50万', value: '100000-500000', min: '100000', max: '500000' },
  { label: '$5万-$10万', value: '50000-100000', min: '50000', max: '100000' },
  { label: '$1万-$5万', value: '10000-50000', min: '10000', max: '50000' },
  { label: '$5000-$9999', value: '5000-9999', min: '5000', max: '9999' },
  { label: '$1000-$4999', value: '1000-4999', min: '1000', max: '4999' },
  { label: '$500-$999', value: '500-999', min: '500', max: '999' },
  { label: '<$500', value: '<500', min: '', max: '500' }
]

const influencerCountOptions = [
  { label: '全部', value: 'all', min: '', max: '' },
  { label: '>1万', value: '>10000', min: '10000', max: '' },
  { label: '5000-1万', value: '5000-10000', min: '5000', max: '10000' },
  { label: '1000-4999', value: '1000-4999', min: '1000', max: '4999' },
  { label: '500-999', value: '500-999', min: '500', max: '999' },
  { label: '100-499', value: '100-499', min: '100', max: '499' }
]

const newProductRatioOptions = [
  { label: '全部', value: 'all', min: '', max: '' },
  { label: '>30%', value: '>30', min: '30', max: '' },
  { label: '21%-30%', value: '21-30', min: '21', max: '30' },
  { label: '11%-20%', value: '11-20', min: '11', max: '20' },
  { label: '<10%', value: '<10', min: '', max: '10' }
]

const selectRatingOption = (option) => {
  tempRating.value = option.value
  tempRatingMin.value = option.min
  tempRatingMax.value = option.max
}

const selectSales7dOption = (option) => {
  tempSales7d.value = option.value
  tempSales7dMin.value = option.min
  tempSales7dMax.value = option.max
}

const selectRevenue7dOption = (option) => {
  tempRevenue7d.value = option.value
  tempRevenue7dMin.value = option.min
  tempRevenue7dMax.value = option.max
}

const selectTotalSalesOption = (option) => {
  tempTotalSales.value = option.value
  tempTotalSalesMin.value = option.min
  tempTotalSalesMax.value = option.max
}

const selectTotalRevenueOption = (option) => {
  tempTotalRevenue.value = option.value
  tempTotalRevenueMin.value = option.min
  tempTotalRevenueMax.value = option.max
}

const selectInfluencerCountOption = (option) => {
  tempInfluencerCount.value = option.value
  tempInfluencerCountMin.value = option.min
  tempInfluencerCountMax.value = option.max
}

const selectNewProductRatioOption = (option) => {
  tempNewProductRatio.value = option.value
  tempNewProductRatioMin.value = option.min
  tempNewProductRatioMax.value = option.max
}

const resetRating = () => {
  tempRating.value = 'all'
  tempRatingMin.value = ''
  tempRatingMax.value = ''
}

const resetSales7d = () => {
  tempSales7d.value = 'all'
  tempSales7dMin.value = ''
  tempSales7dMax.value = ''
}

const resetRevenue7d = () => {
  tempRevenue7d.value = 'all'
  tempRevenue7dMin.value = ''
  tempRevenue7dMax.value = ''
}

const resetTotalSales = () => {
  tempTotalSales.value = 'all'
  tempTotalSalesMin.value = ''
  tempTotalSalesMax.value = ''
}

const resetTotalRevenue = () => {
  tempTotalRevenue.value = 'all'
  tempTotalRevenueMin.value = ''
  tempTotalRevenueMax.value = ''
}

const resetInfluencerCount = () => {
  tempInfluencerCount.value = 'all'
  tempInfluencerCountMin.value = ''
  tempInfluencerCountMax.value = ''
}

const resetNewProductRatio = () => {
  tempNewProductRatio.value = 'all'
  tempNewProductRatioMin.value = ''
  tempNewProductRatioMax.value = ''
}

const confirmRating = () => {
  filters.value.rating = tempRating.value
  ratingPopoverVisible.value = false
}

const confirmSales7d = () => {
  filters.value.sales7d = tempSales7d.value
  sales7dPopoverVisible.value = false
}

const confirmRevenue7d = () => {
  filters.value.revenue7d = tempRevenue7d.value
  revenue7dPopoverVisible.value = false
}

const confirmTotalSales = () => {
  filters.value.totalSales = tempTotalSales.value
  totalSalesPopoverVisible.value = false
}

const confirmTotalRevenue = () => {
  filters.value.totalRevenue = tempTotalRevenue.value
  totalRevenuePopoverVisible.value = false
}

const confirmInfluencerCount = () => {
  filters.value.influencerCount = tempInfluencerCount.value
  influencerCountPopoverVisible.value = false
}

const confirmNewProductRatio = () => {
  filters.value.newProductRatio = tempNewProductRatio.value
  newProductRatioPopoverVisible.value = false
}

const handleCategoryHover = (category, event) => {
  if (category.children.length === 0) return

  clearTimeout(hoverTimer)
  clearTimeout(thirdLevelTimer)
  clearTimeout(dropdownLeaveTimer)
  subHoveredItem.value = null
  keepThirdLevelOpen.value = false
  hoveredCategory.value = category

  const rect = event.currentTarget.getBoundingClientRect()
  dropdownStyle.value = {
    position: 'fixed',
    top: `${rect.bottom + 8}px`,
    left: `${rect.left}px`,
    zIndex: 10001
  }
}

const handleCategoryLeave = () => {
  hoverTimer = setTimeout(() => {
    if (!keepDropdownOpen.value) {
      hoveredCategory.value = null
    }
  }, 100)
}

const handleDropdownLeave = () => {
  keepDropdownOpen.value = false
  dropdownLeaveTimer = setTimeout(() => {
    hoveredCategory.value = null
    subHoveredItem.value = null
    keepThirdLevelOpen.value = false
    clearTimeout(thirdLevelTimer)
  }, 500)
}

const selectSubCategory = (parentValue, subValue, subChildren) => {
  selectedCategory.value = parentValue
  selectedSubCategory.value = subValue
  selectedThirdCategory.value = ''
  clearTimeout(thirdLevelTimer)
  clearTimeout(dropdownLeaveTimer)
}

const selectThirdCategory = (subValue, thirdValue) => {
  selectedCategory.value = thirdValue
  selectedSubCategory.value = subValue
  selectedThirdCategory.value = thirdValue
  clearTimeout(thirdLevelTimer)
  clearTimeout(dropdownLeaveTimer)
}

const handleSubCategoryHover = (subCat, event) => {
  if (!subCat.children || subCat.children.length === 0) {
    subHoveredItem.value = null
    return
  }
  clearTimeout(thirdLevelTimer)
  subHoveredItem.value = subCat
  nextTick(() => {
    const dropdownEl = document.querySelector('.category-dropdown-portal')
    if (dropdownEl) {
      const rect = dropdownEl.getBoundingClientRect()
      thirdLevelPanelStyle.value = {
        position: 'fixed',
        top: `${rect.top}px`,
        left: `${rect.right}px`,
        zIndex: 10002
      }
    }
  })
}

const handleThirdLevelEnter = () => {
  clearTimeout(thirdLevelTimer)
  clearTimeout(dropdownLeaveTimer)
  keepThirdLevelOpen.value = true
}

const handleThirdLevelLeave = () => {
  keepThirdLevelOpen.value = false
  thirdLevelTimer = setTimeout(() => {
    subHoveredItem.value = null
  }, 400)
}

const filters = ref({
  rating: 'all',
  sales7d: 'all',
  revenue7d: 'all',
  totalSales: 'all',
  totalRevenue: 'all',
  influencerCount: 'all',
  newProductRatio: 'all'
})

const countries = [
  { label: '全部', value: 'all' },
  { label: '美国', value: 'US' },
  { label: '印度尼西亚', value: 'ID' },
  { label: '英国', value: 'GB' },
  { label: '越南', value: 'VN' },
  { label: '泰国', value: 'TH' },
  { label: '马来西亚', value: 'MY' },
  { label: '菲律宾', value: 'PH' },
  { label: '西班牙', value: 'ES' },
  { label: '墨西哥', value: 'MX' },
  { label: '德国', value: 'DE' },
  { label: '法国', value: 'FR' },
  { label: '意大利', value: 'IT' },
  { label: '巴西', value: 'BR' },
  { label: '日本', value: 'JP' },
  { label: '新加坡', value: 'SG' }
]

const categories = computed(() => {
  const exclude = new Set(['POD定制', '文化产品', '虚拟商品', '成人用品'])
  return shopifyCategories.filter(c => c.value === 'all' || !exclude.has(c.label))
})

const toggleSection = (section) => {
  collapsedSections.value[section] = !collapsedSections.value[section]
}

const selectCountry = (value) => {
  selectedCountry.value = value
}

const selectCategory = (value) => {
  selectedCategory.value = value
  selectedSubCategory.value = ''
  selectedThirdCategory.value = ''
}

const getRatingLabel = computed(() => {
  const option = ratingOptions.find(opt => opt.value === filters.value.rating)
  return option ? option.label : '全部'
})

const getSales7dLabel = computed(() => {
  const option = sales7dOptions.find(opt => opt.value === filters.value.sales7d)
  return option ? option.label : '全部'
})

const getRevenue7dLabel = computed(() => {
  const option = revenue7dOptions.find(opt => opt.value === filters.value.revenue7d)
  return option ? option.label : '全部'
})

const getTotalSalesLabel = computed(() => {
  const option = totalSalesOptions.find(opt => opt.value === filters.value.totalSales)
  return option ? option.label : '全部'
})

const getTotalRevenueLabel = computed(() => {
  const option = totalRevenueOptions.find(opt => opt.value === filters.value.totalRevenue)
  return option ? option.label : '全部'
})

const getInfluencerCountLabel = computed(() => {
  const option = influencerCountOptions.find(opt => opt.value === filters.value.influencerCount)
  return option ? option.label : '全部'
})

const getNewProductRatioLabel = computed(() => {
  const option = newProductRatioOptions.find(opt => opt.value === filters.value.newProductRatio)
  return option ? option.label : '全部'
})

const buildFilterParams = () => {
  return {
    keyword: searchKeyword.value,
    country: selectedCountry.value,
    category: selectedCategory.value,
    subCategory: selectedSubCategory.value,
    thirdCategory: selectedThirdCategory.value,
    rating: filters.value.rating,
    sales7d: filters.value.sales7d,
    revenue7d: filters.value.revenue7d,
    totalSales: filters.value.totalSales,
    totalRevenue: filters.value.totalRevenue,
    influencerCount: filters.value.influencerCount,
    newProductRatio: filters.value.newProductRatio
  }
}

const handleSearch = () => {
  emit('search', buildFilterParams())
}

const checkOverflow = (className) => {
  nextTick(() => {
    const elements = document.querySelectorAll(`.${className}`)
    elements.forEach((el) => {
      const wasSingleLine = el.classList.contains('single-line')
      el.classList.remove('single-line')

      const scrollHeight = el.scrollHeight
      const clientHeight = 38

      if (className === 'filter-tags-country') {
        showCountryToggle.value = scrollHeight > clientHeight
        if (wasSingleLine) {
          el.classList.add('single-line')
        }
      } else if (className === 'filter-tags-category') {
        showCategoryToggle.value = scrollHeight > clientHeight
        if (wasSingleLine) {
          el.classList.add('single-line')
        }
      }
    })
  })
}

defineExpose({
  getFilterParams: buildFilterParams
})

onMounted(() => {
  checkOverflow('filter-tags-country')
  checkOverflow('filter-tags-category')

  window.addEventListener('resize', () => {
    checkOverflow('filter-tags-country')
    checkOverflow('filter-tags-category')
  })
})
</script>

<style scoped>
.search-filter-section {
  background: white;
  padding: 24px;
  border-radius: 0;
  margin-bottom: 0;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.search-area {
  margin-bottom: 24px;
}

.search-wrapper {
  display: flex;
  align-items: center;
}

.search-input {
  max-width: 600px;
  width: 100%;
}

.search-input :deep(.el-input__wrapper) {
  border-radius: 50px;
  padding: 8px 24px;
  box-shadow: 0 2px 12px rgba(124, 77, 255, 0.08);
  border: 2px solid #f0f0f0;
  transition: all 0.3s ease;
}

.search-input :deep(.el-input__wrapper):hover {
  border-color: #9b7ff7;
  box-shadow: 0 4px 16px rgba(124, 77, 255, 0.12);
}

.search-input :deep(.el-input__wrapper.is-focus) {
  border-color: #7c4dff;
  box-shadow: 0 4px 20px rgba(124, 77, 255, 0.2);
}

.search-input :deep(.el-input__inner) {
  font-size: 15px;
  color: #333;
}

.search-input :deep(.el-input__inner)::placeholder {
  color: #bbb;
}

.search-icon {
  font-size: 20px;
  color: #7c4dff;
  cursor: pointer;
  transition: all 0.2s;
}

.search-icon:hover {
  color: #6a3de8;
  transform: scale(1.1);
}

.filter-area {
}

.filter-row {
  display: flex;
  align-items: flex-start;
  margin-bottom: 16px;
  transition: all 0.3s ease;
}

.filter-row:last-child {
  margin-bottom: 0;
}

.filter-label {
  min-width: 100px;
  font-weight: 600;
  color: #000;
  padding-top: 6px;
  flex-shrink: 0;
}

.filter-content {
  flex: 1;
  display: flex;
  align-items: flex-start;
  gap: 12px;
  flex-wrap: wrap;
  overflow: visible;
}

.filter-tags {
  flex: 1;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  transition: all 0.3s ease;
  padding-top: 2px;
  min-width: 0;
  position: relative;
}

.filter-tags.single-line {
  max-height: 38px;
  overflow: hidden;
  position: relative;
}

.filter-tags.single-line::after {
  content: '';
  position: absolute;
  right: 0;
  top: 0;
  width: 80px;
  height: 38px;
  background: linear-gradient(to right, rgba(255,255,255,0), white 60%);
  pointer-events: none;
  z-index: 2;
}

.filter-tag {
  cursor: pointer;
  user-select: none;
  transition: all 0.2s;
  font-size: 15px;
  padding: 8px 16px;
  border: none;
  height: auto;
  flex-shrink: 0;
  background-color: transparent !important;
  color: #000 !important;
  border-radius: 20px;
}

.filter-tag:hover {
  transform: translateY(-2px);
  background-color: #f5f5f5 !important;
}

.filter-tag.tag-selected {
  background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%) !important;
  border: none;
  color: white !important;
  border-radius: 20px;
}

.filter-tag:deep(.el-tag) {
  border: none !important;
  background-color: transparent !important;
  border-radius: 20px !important;
}

.filter-tag:deep(.el-tag--info) {
  border: none !important;
  background-color: transparent !important;
  color: #000 !important;
  border-radius: 20px !important;
}

.filter-tag:deep(.el-tag--info):hover {
  background-color: transparent !important;
  color: #000 !important;
}

.filter-tag:deep(.el-tag.is-dark) {
  background-color: transparent !important;
  color: white !important;
  border-radius: 20px !important;
}

.category-wrapper {
  position: relative;
  display: inline-block;
}

.toggle-btn {
  flex-shrink: 0;
  padding: 4px 8px;
  color: #7c4dff;
  font-size: 14px;
  white-space: nowrap;
  align-self: flex-start;
  margin-top: 2px;
}

.filter-selects {
  flex: 1;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.custom-select-trigger {
  display: inline-flex;
  align-items: center;
  padding: 10px 20px;
  background-color: #ffffff;
  border: 1px solid #dcdfe6;
  border-radius: 50px !important;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  cursor: pointer;
  transition: all 0.3s ease;
  white-space: nowrap;
  gap: 4px;
  min-width: 150px;
}

.custom-select-trigger:hover {
  border-color: #c0c4cc;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.custom-select-trigger .select-label {
  font-size: 14px;
  color: #606266;
}

.custom-select-trigger .select-value {
  font-size: 14px;
  color: #303133;
  font-weight: 500;
}

.custom-select-trigger .select-arrow {
  font-size: 12px;
  color: #909399;
  margin-left: 4px;
}

.filter-popover-content {
  padding: 8px;
}

.filter-options {
  margin-bottom: 12px;
}

.filter-option {
  padding: 12px 16px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 15px;
  color: #303133;
  margin: 4px 0;
}

.filter-option:hover {
  background-color: #f5f5f5;
}

.filter-option.is-selected {
  background-color: #fef0f0;
  color: #303133;
  font-weight: 500;
}

.filter-range-inputs {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
  padding: 0 8px;
}

.filter-range-inputs .el-input {
  flex: 1;
}

.filter-range-inputs :deep(.el-input__wrapper) {
  border-radius: 8px;
  background-color: #f5f5f5;
  box-shadow: none;
  border: 1px solid #e5e5e5;
}

.filter-range-inputs :deep(.el-input__inner) {
  text-align: center;
  font-size: 14px;
  color: #303133;
}

.range-separator {
  color: #909399;
  font-size: 14px;
}

.filter-actions {
  display: flex;
  gap: 12px;
  padding-top: 12px;
  border-top: 1px solid #f0f0f0;
}

.reset-btn {
  flex: 1;
  border-radius: 50px;
  border: 2px solid #ff4d6d;
  color: #ff4d6d;
  background: #ffffff;
}

.reset-btn:hover {
  background: #fff5f7;
}

.confirm-btn {
  flex: 1;
  border-radius: 50px;
  background: linear-gradient(135deg, #ff4d6d, #ff6b88);
  border: none;
}

.custom-select {
  width: auto !important;
}

.custom-select :deep(.el-input__wrapper) {
  border-radius: 50px !important;
  padding: 10px 20px !important;
  background-color: #ffffff !important;
  border: 1px solid #dcdfe6 !important;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05) !important;
  cursor: pointer !important;
  transition: all 0.3s ease !important;
  min-width: 150px !important;
}

.custom-select :deep(.el-input__wrapper):hover {
  border-color: #c0c4cc !important;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1) !important;
}

.custom-select :deep(.el-input__inner) {
  display: none !important;
}

.select-full-label {
  font-size: 14px;
  color: #303133;
  white-space: nowrap;
  display: flex;
  align-items: center;
  gap: 4px;
}

@media (min-width: 1200px) {
  .filter-row {
    flex-direction: row;
  }
}

@media (max-width: 1199px) {
  .filter-row {
    flex-direction: column;
    align-items: stretch;
  }

  .filter-label {
    margin-bottom: 8px;
  }

  .filter-content {
    flex-direction: column;
  }

  .filter-tags {
    width: 100%;
  }

  .custom-select {
    width: 100%;
  }
}

@media (max-width: 768px) {
  .store-search-page {
    padding: 10px;
  }

  .search-filter-section {
    padding: 15px;
  }

  .search-area {
    margin-bottom: 16px;
    padding-bottom: 16px;
  }

  .filter-label {
    min-width: auto;
    width: 100%;
  }

  .search-input {
    max-width: 100%;
  }
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

.category-dropdown-portal::-webkit-scrollbar {
  width: 6px;
}

.category-dropdown-portal::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.category-dropdown-portal::-webkit-scrollbar-thumb {
  background: #ccc;
  border-radius: 3px;
}

.category-dropdown-portal::-webkit-scrollbar-thumb:hover {
  background: #999;
}

.dropdown-item {
  padding: 10px 16px;
  cursor: pointer;
  border-radius: 8px;
  transition: all 0.2s;
  font-size: 14px;
  color: #333;
}

.dropdown-item-label {
  flex: 1;
}

.dropdown-item-arrow {
  margin-left: 8px;
  color: #bbb;
  font-size: 12px;
  font-weight: bold;
}

.dropdown-item:hover {
  background-color: #f5f5f5;
}

.dropdown-item.selected {
  background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%);
  color: white;
}

.dropdown-item.has-children:hover {
  background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%);
  color: white;
}

.dropdown-item.sub-hovered {
  background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%);
  color: white;
}

.third-level-panel {
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  padding: 8px;
  width: 160px;
  max-height: 200px;
  overflow-y: auto;
}

.third-level-panel::-webkit-scrollbar {
  width: 6px;
}

.third-level-panel::-webkit-scrollbar-track {
  background: #f5f5f5;
  border-radius: 3px;
}

.third-level-panel::-webkit-scrollbar-thumb {
  background: #d9d9d9;
  border-radius: 3px;
}

.third-level-item {
  padding: 10px 16px;
  cursor: pointer;
  border-radius: 8px;
  transition: background-color 0.15s;
  font-size: 14px;
  color: #333;
}

.third-level-item:hover {
  background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%);
  color: white;
}

.third-level-item.selected {
  background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%);
  color: white;
}

.custom-filter-popover {
  padding: 0 !important;
}

.custom-select-dropdown {
  border-radius: 16px !important;
  padding: 12px !important;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15) !important;
  border: 1px solid #e5e5e5 !important;
}

.custom-select-dropdown .el-select-dropdown__item {
  border-radius: 8px !important;
  padding: 12px 16px !important;
  margin: 4px 0 !important;
  font-size: 15px !important;
  color: #303133 !important;
  transition: all 0.2s !important;
  background-color: #ffffff !important;
}

.custom-select-dropdown .el-select-dropdown__item:hover {
  background-color: #f5f5f5 !important;
}

.custom-select-dropdown .el-select-dropdown__item.is-selected {
  background-color: #fef0f0 !important;
  color: #303133 !important;
  font-weight: 500 !important;
}

.custom-select-dropdown .el-select-dropdown__item.is-hovering {
  background-color: #f5f5f5 !important;
}

.custom-select-dropdown .el-select-dropdown__item.is-selected.is-hovering {
  background-color: #fce4e4 !important;
}
</style>
