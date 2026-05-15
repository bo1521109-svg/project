<template>
  <div class="products-container">
    <!-- 搜索和筛选区域（合并） -->
    <div class="search-filter-section">
      <!-- 搜索框 -->
      <div class="search-area">
        <div class="search-wrapper">
          <el-input
            v-model="searchKeyword"
            placeholder="请输入店铺或品牌名称关键词搜索"
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

      <!-- 筛选区域 -->
      <div class="filter-area">
        <!-- 国家/地区 -->
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

        <!-- 类目 -->
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
        
        <!-- 下拉菜单 - 使用 Teleport 渲染到 body -->
        <Teleport to="body">
          <div
            v-if="hoveredCategory && hoveredCategory.children.length > 0"
            class="category-dropdown-portal"
            :style="dropdownStyle"
            @mouseenter="keepDropdownOpen = true"
            @mouseleave="handleDropdownLeave"
          >
            <div
              v-for="subCat in hoveredCategory.children"
              :key="subCat.value"
              class="dropdown-item"
              :class="{ 'selected': selectedSubCategory === subCat.value }"
              @click="selectSubCategory(hoveredCategory.value, subCat.value)"
            >
              {{ subCat.label }}
            </div>
          </div>
        </Teleport>

        <!-- 筛选条件 -->
        <div class="filter-row advanced-filters">
          <div class="filter-label">筛选条件：</div>
          <div class="filter-content">
            <div class="filter-selects">
              <!-- 店铺评分 -->
              <el-popover
                :visible="ratingPopoverVisible"
                placement="bottom"
                :width="300"
                trigger="click"
                popper-class="custom-filter-popover"
              >
                <template #reference>
                  <div class="custom-select-trigger" @click="ratingPopoverVisible = !ratingPopoverVisible">
                    <span class="select-label">店铺评分：</span>
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

              <!-- 近7天销量 -->
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

              <!-- 近7天销售额 -->
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

              <!-- 总销量 -->
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

              <!-- 总销售额 -->
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

              <!-- 带货达人数 -->
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

              <!-- 新品成交占比 -->
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

    <!-- 商品列表区域（原有内容） -->
    <!-- 商品列表区域（原有内容） -->
    <el-card>
      <template #header>
        <div class="card-header">
          <span>商品列表</span>
          <el-select 
            v-model="selectedStoreId" 
            placeholder="按店铺筛选" 
            clearable
            @change="fetchProducts"
            style="width: 200px"
          >
            <el-option
              v-for="store in stores"
              :key="store.id"
              :label="store.name"
              :value="store.id"
            />
          </el-select>
        </div>
      </template>

      <!-- 商品列表表格 -->
      <div class="table-container">
        <el-table :data="products" style="width: 100%" v-loading="loading">
          <el-table-column label="图片" width="80" class-name="mobile-image">
            <template #default="{ row }">
              <el-image
                :src="row.image_url"
                fit="cover"
                style="width: 60px; height: 60px"
                :preview-src-list="[row.image_url]"
              >
                <template #error>
                  <div class="image-slot">
                    <el-icon><Picture /></el-icon>
                  </div>
                </template>
              </el-image>
            </template>
          </el-table-column>
          <el-table-column prop="title" label="商品标题" min-width="150" show-overflow-tooltip />
          <el-table-column label="爬取时间" width="160" class-name="mobile-simple">
            <template #default="{ row }">
              <span style="font-size: 12px;">{{ formatDateTime(row.captured_at) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="价格" width="100" class-name="mobile-simple">
            <template #default="{ row }">
              {{ row.currency }} {{ formatPrice(row.price) }}
            </template>
          </el-table-column>
          <el-table-column label="库存状态" width="100">
            <template #default="{ row }">
              <el-tag v-if="row.is_available === true" type="success" size="small">有货</el-tag>
              <el-tag v-else-if="row.is_available === false" type="danger" size="small">无货</el-tag>
              <el-tag v-else type="info" size="small">未知</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="store_name" label="店铺名称" width="150" class-name="mobile-hide" show-overflow-tooltip />
          <el-table-column label="操作" width="120" fixed="right" class-name="mobile-simple">
            <template #default="{ row }">
              <el-button 
                type="primary" 
                size="small" 
                link
                @click="openUrl(row.url)"
              >
                详情
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :total="total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="fetchProducts"
          @current-change="fetchProducts"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>

import { ref, computed, onMounted, nextTick } from 'vue'
import { Search, ArrowDown, ArrowUp, Picture } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import request from '../utils/request'

// ==================== 店铺筛选逻辑 ====================

// 搜索关键词
const searchKeyword = ref('')

// 折叠状态（默认收起）
const collapsedSections = ref({
  country: true,
  category: true
})

// 是否显示展开/收起按钮
const showCountryToggle = ref(false)
const showCategoryToggle = ref(false)

// 选中的筛选项
const selectedCountry = ref('all')
const selectedCategory = ref('all')
const selectedSubCategory = ref('') // 子类目

// 下拉菜单相关
const hoveredCategory = ref(null)
const dropdownStyle = ref({})
const keepDropdownOpen = ref(false)
let hoverTimer = null

// Popover 可见性控制
const ratingPopoverVisible = ref(false)
const sales7dPopoverVisible = ref(false)
const revenue7dPopoverVisible = ref(false)
const totalSalesPopoverVisible = ref(false)
const totalRevenuePopoverVisible = ref(false)
const influencerCountPopoverVisible = ref(false)
const newProductRatioPopoverVisible = ref(false)

// 临时选择值（用于确认前的预览）
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

// 评分选项
const ratingOptions = [
  { label: '全部', value: 'all', min: '', max: '' },
  { label: '4.6-5.0', value: '4.6-5.0', min: '4.6', max: '5.0' },
  { label: '4.1-4.5', value: '4.1-4.5', min: '4.1', max: '4.5' },
  { label: '3.6-4.0', value: '3.6-4.0', min: '3.6', max: '4.0' },
  { label: '3.0-3.5', value: '3.0-3.5', min: '3.0', max: '3.5' },
  { label: '<3.0', value: '<3.0', min: '', max: '3.0' }
]

// 近7天销量选项
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

// 近7天销售额选项
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

// 总销量选项
const totalSalesOptions = [
  { label: '全部', value: 'all', min: '', max: '' },
  { label: '>100万', value: '>1000000', min: '1000000', max: '' },
  { label: '50万-100万', value: '500000-1000000', min: '500000', max: '1000000' },
  { label: '10万-50万', value: '100000-500000', min: '100000', max: '500000' },
  { label: '1万-10万', value: '10000-100000', min: '10000', max: '100000' },
  { label: '5000-1万', value: '5000-10000', min: '5000', max: '10000' },
  { label: '<5000', value: '<5000', min: '', max: '5000' }
]

// 总销售额选项
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

// 带货达人数选项
const influencerCountOptions = [
  { label: '全部', value: 'all', min: '', max: '' },
  { label: '>1万', value: '>10000', min: '10000', max: '' },
  { label: '5000-1万', value: '5000-10000', min: '5000', max: '10000' },
  { label: '1000-4999', value: '1000-4999', min: '1000', max: '4999' },
  { label: '500-999', value: '500-999', min: '500', max: '999' },
  { label: '100-499', value: '100-499', min: '100', max: '499' }
]

// 新品成交占比选项
const newProductRatioOptions = [
  { label: '全部', value: 'all', min: '', max: '' },
  { label: '>30%', value: '>30', min: '30', max: '' },
  { label: '21%-30%', value: '21-30', min: '21', max: '30' },
  { label: '11%-20%', value: '11-20', min: '11', max: '20' },
  { label: '<10%', value: '<10', min: '', max: '10' }
]

// 选择评分选项
const selectRatingOption = (option) => {
  tempRating.value = option.value
  tempRatingMin.value = option.min
  tempRatingMax.value = option.max
}

// 选择近7天销量选项
const selectSales7dOption = (option) => {
  tempSales7d.value = option.value
  tempSales7dMin.value = option.min
  tempSales7dMax.value = option.max
}

// 选择近7天销售额选项
const selectRevenue7dOption = (option) => {
  tempRevenue7d.value = option.value
  tempRevenue7dMin.value = option.min
  tempRevenue7dMax.value = option.max
}

// 选择总销量选项
const selectTotalSalesOption = (option) => {
  tempTotalSales.value = option.value
  tempTotalSalesMin.value = option.min
  tempTotalSalesMax.value = option.max
}

// 选择总销售额选项
const selectTotalRevenueOption = (option) => {
  tempTotalRevenue.value = option.value
  tempTotalRevenueMin.value = option.min
  tempTotalRevenueMax.value = option.max
}

// 选择带货达人数选项
const selectInfluencerCountOption = (option) => {
  tempInfluencerCount.value = option.value
  tempInfluencerCountMin.value = option.min
  tempInfluencerCountMax.value = option.max
}

// 选择新品成交占比选项
const selectNewProductRatioOption = (option) => {
  tempNewProductRatio.value = option.value
  tempNewProductRatioMin.value = option.min
  tempNewProductRatioMax.value = option.max
}

// 重置评分
const resetRating = () => {
  tempRating.value = 'all'
  tempRatingMin.value = ''
  tempRatingMax.value = ''
}

// 重置近7天销量
const resetSales7d = () => {
  tempSales7d.value = 'all'
  tempSales7dMin.value = ''
  tempSales7dMax.value = ''
}

// 重置近7天销售额
const resetRevenue7d = () => {
  tempRevenue7d.value = 'all'
  tempRevenue7dMin.value = ''
  tempRevenue7dMax.value = ''
}

// 重置总销量
const resetTotalSales = () => {
  tempTotalSales.value = 'all'
  tempTotalSalesMin.value = ''
  tempTotalSalesMax.value = ''
}

// 重置总销售额
const resetTotalRevenue = () => {
  tempTotalRevenue.value = 'all'
  tempTotalRevenueMin.value = ''
  tempTotalRevenueMax.value = ''
}

// 重置带货达人数
const resetInfluencerCount = () => {
  tempInfluencerCount.value = 'all'
  tempInfluencerCountMin.value = ''
  tempInfluencerCountMax.value = ''
}

// 重置新品成交占比
const resetNewProductRatio = () => {
  tempNewProductRatio.value = 'all'
  tempNewProductRatioMin.value = ''
  tempNewProductRatioMax.value = ''
}

// 确认评分
const confirmRating = () => {
  filters.value.rating = tempRating.value
  ratingPopoverVisible.value = false
}

// 确认近7天销量
const confirmSales7d = () => {
  filters.value.sales7d = tempSales7d.value
  sales7dPopoverVisible.value = false
}

// 确认近7天销售额
const confirmRevenue7d = () => {
  filters.value.revenue7d = tempRevenue7d.value
  revenue7dPopoverVisible.value = false
}

// 确认总销量
const confirmTotalSales = () => {
  filters.value.totalSales = tempTotalSales.value
  totalSalesPopoverVisible.value = false
}

// 确认总销售额
const confirmTotalRevenue = () => {
  filters.value.totalRevenue = tempTotalRevenue.value
  totalRevenuePopoverVisible.value = false
}

// 确认带货达人数
const confirmInfluencerCount = () => {
  filters.value.influencerCount = tempInfluencerCount.value
  influencerCountPopoverVisible.value = false
}

// 确认新品成交占比
const confirmNewProductRatio = () => {
  filters.value.newProductRatio = tempNewProductRatio.value
  newProductRatioPopoverVisible.value = false
}

// 处理类目 hover
const handleCategoryHover = (category, event) => {
  if (category.children.length === 0) return
  
  clearTimeout(hoverTimer)
  hoveredCategory.value = category
  
  // 计算下拉菜单位置
  const rect = event.currentTarget.getBoundingClientRect()
  dropdownStyle.value = {
    position: 'fixed',
    top: `${rect.bottom + 8}px`,
    left: `${rect.left}px`,
    zIndex: 10001
  }
}

// 处理类目 leave
const handleCategoryLeave = () => {
  hoverTimer = setTimeout(() => {
    if (!keepDropdownOpen.value) {
      hoveredCategory.value = null
    }
  }, 100)
}

// 处理下拉菜单 leave
const handleDropdownLeave = () => {
  keepDropdownOpen.value = false
  hoveredCategory.value = null
}

// 选择子类目
const selectSubCategory = (parentValue, subValue) => {
  selectedCategory.value = parentValue
  selectedSubCategory.value = subValue
  hoveredCategory.value = null
  keepDropdownOpen.value = false
}

// 高级筛选条件
const filters = ref({
  rating: 'all',
  sales7d: 'all',
  revenue7d: 'all',
  totalSales: 'all',
  totalRevenue: 'all',
  influencerCount: 'all',
  newProductRatio: 'all'
})

// 国家/地区选项
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

// 类目选项（带子类目）
const categories = [
  { 
    label: '全部', 
    value: 'all',
    children: []
  },
  { 
    label: '美妆个护', 
    value: 'beauty',
    children: [
      { label: '美妆', value: 'beauty-makeup' },
      { label: '美容护肤', value: 'beauty-skincare' },
      { label: '头部护理与造型', value: 'beauty-hair' },
      { label: '手足及指甲护理', value: 'beauty-nail' },
      { label: '洗浴与身体护理', value: 'beauty-bath' },
      { label: '男士护理', value: 'beauty-men' },
      { label: '美容、个护电器', value: 'beauty-appliance' },
      { label: '眼镜耳朵护理', value: 'beauty-eye-ear' },
      { label: '鼻子口腔护理', value: 'beauty-nose-mouth' },
      { label: '女性私密处护理', value: 'beauty-women-private' },
      { label: '特殊个护', value: 'beauty-special' },
      { label: '香水', value: 'beauty-perfume' }
    ]
  },
  { 
    label: '女装与女士内衣', 
    value: 'women-fashion',
    children: [
      { label: '女士上装', value: 'women-tops' },
      { label: '女士下装', value: 'women-bottoms' },
      { label: '女士连衣裙', value: 'women-dresses' },
      { label: '女士特殊服饰', value: 'women-special' },
      { label: '女士套装与连体衣', value: 'women-suits' },
      { label: '女士内衣', value: 'women-underwear' },
      { label: '女士睡衣和家居服', value: 'women-sleepwear' }
    ]
  },
  { 
    label: '保健', 
    value: 'health',
    children: [
      { label: '保健食品', value: 'health-food' },
      { label: '医疗保健', value: 'health-medical' },
      { label: '非处方药物与疗法', value: 'health-otc' },
      { label: '另类医疗', value: 'health-alternative' },
      { label: '情趣用品', value: 'health-adult' }
    ]
  },
  { 
    label: '时尚配件', 
    value: 'fashion-accessories',
    children: [
      { label: '假发', value: 'accessories-wigs' },
      { label: '服装布料', value: 'accessories-fabric' },
      { label: '服饰配件', value: 'accessories-clothing' },
      { label: '眼镜', value: 'accessories-glasses' },
      { label: '手表与配件', value: 'accessories-watches' },
      { label: '平价饰品', value: 'accessories-jewelry' },
      { label: '发饰', value: 'accessories-hair' }
    ]
  },
  { 
    label: '运动与户外', 
    value: 'sports',
    children: [
      { label: '运动服饰', value: 'sports-clothing' },
      { label: '运动鞋', value: 'sports-shoes' },
      { label: '运动与户外配件', value: 'sports-accessories' },
      { label: '球类运动设备', value: 'sports-ball' },
      { label: '水上运动设备', value: 'sports-water' },
      { label: '冬季运动设备', value: 'sports-winter' },
      { label: '露营与徒步设备', value: 'sports-camping' },
      { label: '健身设备', value: 'sports-fitness' },
      { label: '休闲与室外休闲设备', value: 'sports-leisure' },
      { label: '球迷周边', value: 'sports-fan' },
      { label: '泳装&冲浪服&潜水服', value: 'sports-swimwear' }
    ]
  },
  { 
    label: '手机与数码', 
    value: 'electronics',
    children: [
      { label: '手机配件', value: 'electronics-phone-accessories' },
      { label: '摄影摄像', value: 'electronics-camera' },
      { label: '影音设备', value: 'electronics-audio-video' },
      { label: '游戏设备', value: 'electronics-gaming' },
      { label: '智能及穿戴设备', value: 'electronics-wearable' },
      { label: '电子教育设备', value: 'electronics-education' },
      { label: '通用配件', value: 'electronics-accessories' },
      { label: '平板电脑配件', value: 'electronics-tablet-accessories' },
      { label: '手机与平板', value: 'electronics-phone-tablet' }
    ]
  },
  { 
    label: '居家日用', 
    value: 'home',
    children: [
      { label: '家居收纳', value: 'home-storage' },
      { label: '浴室用品', value: 'home-bathroom' },
      { label: '装饰', value: 'home-decoration' },
      { label: '家庭护理用品', value: 'home-care' },
      { label: '洗衣工具', value: 'home-laundry' },
      { label: '节庆及派对用品', value: 'home-party' },
      { label: '家居日用', value: 'home-daily' }
    ]
  },
  { 
    label: '食品饮料', 
    value: 'food',
    children: [
      { label: '奶与乳制品', value: 'food-dairy' },
      { label: '饮料', value: 'food-beverage' },
      { label: '即食食品', value: 'food-instant' },
      { label: '主食与烹饪调味', value: 'food-staple' },
      { label: '烘焙用品', value: 'food-baking' },
      { label: '零食', value: 'food-snack' },
      { label: '生鲜冷冻食品', value: 'food-fresh' },
      { label: '酒', value: 'food-alcohol' }
    ]
  },
  { 
    label: '汽车与摩托车', 
    value: 'automotive',
    children: [
      { label: '摩托车零部件', value: 'automotive-motorcycle-parts' },
      { label: '汽车电子产品', value: 'automotive-electronics' },
      { label: '外部配件', value: 'automotive-exterior' },
      { label: '内部配件', value: 'automotive-interior' },
      { label: '汽车修理工具', value: 'automotive-tools' },
      { label: '汽车灯', value: 'automotive-lights' },
      { label: '沙滩车、房车、游艇设备', value: 'automotive-recreational' },
      { label: '洗车及保养', value: 'automotive-care' },
      { label: '摩托车配件', value: 'automotive-motorcycle-accessories' },
      { label: '汽车零部件', value: 'automotive-car-parts' },
      { label: '摩托车', value: 'automotive-motorcycle' }
    ]
  },
  { 
    label: '男装与男士内衣', 
    value: 'men-fashion',
    children: [
      { label: '男士上装', value: 'men-tops' },
      { label: '男士下装', value: 'men-bottoms' },
      { label: '男士特殊服饰', value: 'men-special' },
      { label: '男士内衣', value: 'men-underwear' },
      { label: '男士睡衣和家居服', value: 'men-sleepwear' },
      { label: '男士套装与连体衣', value: 'men-suits' }
    ]
  },
  { 
    label: '收藏品', 
    value: 'collectibles',
    children: [
      { label: '当代文化收藏', value: 'collectibles-culture' },
      { label: '收藏卡片及配件', value: 'collectibles-cards' },
      { label: '运动收藏品', value: 'collectibles-sports' },
      { label: '收藏钱币', value: 'collectibles-coins' },
      { label: '娱乐收藏', value: 'collectibles-entertainment' }
    ]
  },
  { 
    label: '玩具和爱好', 
    value: 'toys',
    children: [
      { label: '娃娃与毛绒玩具', value: 'toys-dolls' },
      { label: '益智玩具', value: 'toys-educational' },
      { label: '运动与户外玩具', value: 'toys-outdoor' },
      { label: '电动与遥控玩具', value: 'toys-rc' },
      { label: '棋盘娱乐', value: 'toys-board-games' },
      { label: '传统与创新玩具', value: 'toys-traditional' },
      { label: '乐器与配件', value: 'toys-instruments' },
      { label: 'DIY爱好', value: 'toys-diy' }
    ]
  },
  { 
    label: '厨房用品', 
    value: 'kitchen',
    children: [
      { label: '咖啡用具与茶用具', value: 'kitchen-coffee-tea' },
      { label: '刀具 刀具', value: 'kitchen-knives' },
      { label: '烧烤用具', value: 'kitchen-bbq' },
      { label: '酒具', value: 'kitchen-bar' },
      { label: '烘焙用具', value: 'kitchen-baking' },
      { label: '烹饪工具', value: 'kitchen-cooking' },
      { label: '餐具', value: 'kitchen-tableware' },
      { label: '饮具', value: 'kitchen-drinkware' },
      { label: '厨房器具', value: 'kitchen-appliances' }
    ]
  },
  { 
    label: '家装建材', 
    value: 'home-improvement',
    children: [
      { label: '太阳能与风能设备', value: 'home-improvement-solar' },
      { label: '灯具和照明设备', value: 'home-improvement-lighting' },
      { label: '电气设备及用品', value: 'home-improvement-electrical' },
      { label: '厨房设备', value: 'home-improvement-kitchen' },
      { label: '家庭智能系统', value: 'home-improvement-smart' },
      { label: '建筑用品', value: 'home-improvement-construction' },
      { label: '浴室设备', value: 'home-improvement-bathroom' },
      { label: '安防劳保用品', value: 'home-improvement-safety' },
      { label: '花园用品', value: 'home-improvement-garden' }
    ]
  },
  { 
    label: '电脑办公', 
    value: 'office',
    children: [
      { label: '电脑整机', value: 'office-computers' },
      { label: '电脑 & 笔记本电脑组件', value: 'office-components' },
      { label: '外设产品与配件', value: 'office-peripherals' },
      { label: '数据储存与软件', value: 'office-storage' },
      { label: '网络组件', value: 'office-network' },
      { label: '办公设备', value: 'office-equipment' },
      { label: '办公文具用品', value: 'office-supplies' }
    ]
  },
  { 
    label: '箱包', 
    value: 'bags',
    children: [
      { label: '女包', value: 'bags-women' },
      { label: '男包', value: 'bags-men' },
      { label: '旅行箱包', value: 'bags-travel' },
      { label: '功能箱包', value: 'bags-functional' },
      { label: '箱包配件', value: 'bags-accessories' }
    ]
  },
  { 
    label: '鞋靴', 
    value: 'shoes',
    children: [
      { label: '女鞋', value: 'shoes-women' },
      { label: '男鞋', value: 'shoes-men' },
      { label: '鞋靴配件', value: 'shoes-accessories' }
    ]
  },
  { 
    label: '五金工具', 
    value: 'tools',
    children: [
      { label: '电动工具', value: 'tools-power' },
      { label: '手动工具', value: 'tools-hand' },
      { label: '测量工具', value: 'tools-measuring' },
      { label: '园林工具', value: 'tools-garden' },
      { label: '焊接工具', value: 'tools-welding' },
      { label: '工具收纳', value: 'tools-storage' },
      { label: '五金', value: 'tools-hardware' },
      { label: '泵及管件设施', value: 'tools-plumbing' }
    ]
  },
  { 
    label: '家纺布艺', 
    value: 'textiles',
    children: [
      { label: '床上用品', value: 'textiles-bedding' },
      { label: '居家布艺', value: 'textiles-home-fabric' },
      { label: '布料与手工工具', value: 'textiles-fabric-tools' }
    ]
  },
  { 
    label: '家电', 
    value: 'appliances',
    children: [
      { label: '厨房家电', value: 'appliances-kitchen' },
      { label: '生活家电', value: 'appliances-living' },
      { label: '大家电', value: 'appliances-major' },
      { label: '商用电器', value: 'appliances-commercial' }
    ]
  },
  { 
    label: '宠物用品', 
    value: 'pet',
    children: [
      { label: '猫狗食品', value: 'pet-food' },
      { label: '猫狗家具', value: 'pet-furniture' },
      { label: '猫狗服饰', value: 'pet-clothing' },
      { label: '猫狗如厕用品', value: 'pet-toilet' },
      { label: '猫狗清洁美容', value: 'pet-grooming' },
      { label: '猫狗健康护理', value: 'pet-health' },
      { label: '猫狗配件', value: 'pet-accessories' },
      { label: '水族用品', value: 'pet-aquarium' },
      { label: '爬行两栖用品', value: 'pet-reptile' },
      { label: '鸟用品', value: 'pet-bird' },
      { label: '小宠用品', value: 'pet-small' },
      { label: '农场动物与家禽用品', value: 'pet-farm' }
    ]
  },
  { 
    label: '珠宝与仿生首饰', 
    value: 'jewelry',
    children: [
      { label: '铂&K金', value: 'jewelry-platinum-gold' },
      { label: '黄金', value: 'jewelry-gold' },
      { label: '银', value: 'jewelry-silver' },
      { label: '钻石', value: 'jewelry-diamond' },
      { label: '天然水晶', value: 'jewelry-natural-crystal' },
      { label: '非天然水晶', value: 'jewelry-synthetic-crystal' },
      { label: '玉石', value: 'jewelry-jade' },
      { label: '天然红蓝绿宝石', value: 'jewelry-natural-gemstone' },
      { label: '天然小众宝石', value: 'jewelry-rare-gemstone' },
      { label: '人造宝石', value: 'jewelry-synthetic-gemstone' },
      { label: '珍珠', value: 'jewelry-pearl' },
      { label: '琥珀', value: 'jewelry-amber' },
      { label: '蜜蜡', value: 'jewelry-beeswax' }
    ]
  },
  { 
    label: '图书杂志音像', 
    value: 'books',
    children: [
      { label: '人文社科', value: 'books-humanities' },
      { label: '杂志与报纸', value: 'books-magazines' },
      { label: '文学与艺术', value: 'books-literature' },
      { label: '经济与管理', value: 'books-business' },
      { label: '儿童与婴幼儿图书', value: 'books-children' },
      { label: '生活与爱好', value: 'books-lifestyle' },
      { label: '科技', value: 'books-technology' },
      { label: '教育', value: 'books-education' },
      { label: '影视&音乐', value: 'books-media' }
    ]
  },
  { 
    label: '母婴用品', 
    value: 'baby',
    children: [
      { label: '婴儿服饰与鞋', value: 'baby-clothing' },
      { label: '婴儿外出用品', value: 'baby-outdoor' },
      { label: '哺育用品', value: 'baby-feeding' },
      { label: '婴儿家具', value: 'baby-furniture' },
      { label: '婴儿安全防护用品', value: 'baby-safety' },
      { label: '婴儿玩具', value: 'baby-toys' },
      { label: '婴儿护理与健康', value: 'baby-care' },
      { label: '奶粉与婴儿食品', value: 'baby-food' },
      { label: '孕产用品', value: 'baby-maternity' },
      { label: '婴儿时尚配件', value: 'baby-accessories' }
    ]
  },
  { 
    label: '家具', 
    value: 'furniture',
    children: [
      { label: '家具辅料', value: 'furniture-accessories' },
      { label: '室内家具', value: 'furniture-indoor' },
      { label: '室外家具', value: 'furniture-outdoor' },
      { label: '儿童家具', value: 'furniture-children' },
      { label: '商用家具', value: 'furniture-commercial' }
    ]
  },
  { 
    label: '儿童时尚', 
    value: 'kids-fashion',
    children: [
      { label: '男童服饰', value: 'kids-boys-clothing' },
      { label: '女童服饰', value: 'kids-girls-clothing' },
      { label: '男童鞋', value: 'kids-boys-shoes' },
      { label: '女童鞋', value: 'kids-girls-shoes' },
      { label: '儿童时尚配件', value: 'kids-accessories' }
    ]
  },
  { 
    label: '穆斯林时尚', 
    value: 'muslim-fashion',
    children: [
      { label: '面纱', value: 'muslim-veil' },
      { label: '女士穆斯林服饰', value: 'muslim-women-clothing' },
      { label: '男士穆斯林服装', value: 'muslim-men-clothing' },
      { label: '外套', value: 'muslim-outerwear' },
      { label: '儿童穆斯林服装', value: 'muslim-children-clothing' },
      { label: '穆斯林配饰', value: 'muslim-accessories' },
      { label: '祈祷用品', value: 'muslim-prayer' },
      { label: '穆斯林运动服饰', value: 'muslim-sportswear' },
      { label: '乌姆罗', value: 'muslim-umrah' }
    ]
  },
  { 
    label: '二手', 
    value: 'second-hand',
    children: [
      { label: '收藏交易卡', value: 'second-hand-trading-cards' },
      { label: '时尚配饰', value: 'second-hand-fashion-accessories' },
      { label: '包', value: 'second-hand-bags' },
      { label: '鞋类', value: 'second-hand-shoes' },
      { label: '男士服装', value: 'second-hand-men-clothing' },
      { label: '女士服装', value: 'second-hand-women-clothing' },
      { label: '翻新手机和电子产品', value: 'second-hand-electronics' },
      { label: '行李箱和旅行用品', value: 'second-hand-luggage' },
      { label: '手表', value: 'second-hand-watches' }
    ]
  },
  { 
    label: '虚拟商品', 
    value: 'virtual',
    children: [
      { label: '电信', value: 'virtual-telecom' }
    ]
  },
  { 
    label: 'POD定制', 
    value: 'pod-custom',
    children: []
  },
  { 
    label: '成人用品', 
    value: 'adult-products',
    children: []
  },
  { 
    label: '文化', 
    value: 'culture',
    children: []
  }
]

// 切换折叠状态
const toggleSection = (section) => {
  collapsedSections.value[section] = !collapsedSections.value[section]
}

// 选择国家
const selectCountry = (value) => {
  selectedCountry.value = value
  // 重置到第一页并执行搜索
  currentPage.value = 1
  fetchProducts()
}

// 选择类目
const selectCategory = (value) => {
  selectedCategory.value = value
  // 重置到第一页并执行搜索
  currentPage.value = 1
  fetchProducts()
}

// 搜索
const handleSearch = () => {
  console.log('搜索条件：', {
    keyword: searchKeyword.value,
    country: selectedCountry.value,
    category: selectedCategory.value,
    ...filters.value
  })
  // 重置到第一页并执行搜索
  currentPage.value = 1
  fetchProducts()
}

// 获取各个筛选项的显示标签
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

// 检查内容是否溢出（超过一行）
const checkOverflow = (className) => {
  nextTick(() => {
    const elements = document.querySelectorAll(`.${className}`)
    elements.forEach((el) => {
      // 临时移除单行限制以获取真实高度
      const wasSingleLine = el.classList.contains('single-line')
      el.classList.remove('single-line')
      
      // 获取内容的真实高度
      const scrollHeight = el.scrollHeight
      const clientHeight = 38 // 单行高度38px
      
      // 如果内容高度超过单行，显示展开/收起按钮
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

// 页面加载后检查是否需要显示展开/收起按钮
onMounted(() => {
  checkOverflow('filter-tags-country')
  checkOverflow('filter-tags-category')
  
  // 监听窗口大小变化，重新检查
  window.addEventListener('resize', () => {
    checkOverflow('filter-tags-country')
    checkOverflow('filter-tags-category')
  })
})


// ==================== 商品列表逻辑 ====================

// 数据
const products = ref([])
const stores = ref([])
const loading = ref(false)
const selectedStoreId = ref(null)
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)

// 获取店铺列表（用于筛选）
const fetchStores = async () => {
  try {
    const response = await request.get('/v1/admin/crawler/tasks')
    stores.value = response.data
  } catch (error) {
    console.error('获取店铺列表失败', error)
  }
}

// 获取商品列表
const fetchProducts = async () => {
  loading.value = true
  try {
    const params = {
      skip: (currentPage.value - 1) * pageSize.value,
      limit: pageSize.value
    }
    
    // 如果选择了店铺，添加筛选参数
    if (selectedStoreId.value) {
      params.store_id = selectedStoreId.value
    }
    
    // 添加国家筛选（排除"全部"和空值）
    if (selectedCountry.value && selectedCountry.value !== '' && selectedCountry.value !== 'all') {
      params.country_code = selectedCountry.value
    }
    
    // 添加类目筛选（排除"全部"和空值）
    if (selectedCategory.value && selectedCategory.value !== 'all' && selectedCategory.value !== '') {
      params.category_code = selectedCategory.value
    }
    
    // 添加关键词搜索
    if (searchKeyword.value && searchKeyword.value.trim() !== '') {
      params.keyword = searchKeyword.value.trim()
    }

    // 使用新的搜索 API
    const response = await request.get('/v1/shopify/products/search', { params })
    
    // 处理响应数据
    if (response.data.data) {
      // 新 API 返回格式：{ data: [...], total: 100, filters_applied: {...} }
      products.value = response.data.data
      total.value = response.data.total || 0
    } else {
      // 兼容旧格式
      products.value = response.data.items || response.data
      total.value = response.data.total || products.value.length
    }
  } catch (error) {
    ElMessage.error('获取商品列表失败：' + (error.response?.data?.detail || error.message))
  } finally {
    loading.value = false
  }
}

// 格式化价格（保留2位小数）
const formatPrice = (price) => {
  if (!price) return '0.00'
  return parseFloat(price).toFixed(2)
}

// 格式化日期（完整格式）
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleString('zh-CN')
}

// 格式化日期时间（简洁格式：月-日 时:分）
const formatDateTime = (dateStr) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  return `${month}-${day} ${hours}:${minutes}`
}

// 打开商品链接
const openUrl = (url) => {
  if (url) {
    window.open(url, '_blank')
  }
}

// 页面加载时获取数据
onMounted(() => {
  fetchStores()
  fetchProducts()
})


// 店铺搜索函数
const handleStoreSearch = () => {
  console.log('商品搜索条件：', {
    keyword: searchKeyword.value,
    country: selectedCountry.value,
    category: selectedCategory.value,
    ...filters.value
  })
  // 重置到第一页并执行搜索
  currentPage.value = 1
  fetchProducts()
}
</script>

<style scoped>
.products-container {
  padding: 20px;
  height: 100%;
  box-sizing: border-box;
}

.products-container .el-card {
  height: 100%;
  display: flex;
  flex-direction: column;
  border-radius: 8px;
}

.products-container :deep(.el-card__body) {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

.products-container :deep(.el-card__body)::-webkit-scrollbar {
  width: 6px;
}

.products-container :deep(.el-card__body)::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.products-container :deep(.el-card__body)::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.products-container :deep(.el-card__body)::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.table-container {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

:deep(.el-table) {
  min-width: 600px !important; /* 表格最小宽度，允许横向滚动 */
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  color: #909399;
  font-size: 30px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* 移动端优化 */
@media (max-width: 768px) {
  .products-container {
    padding: 10px;
  }

  .card-header {
    flex-direction: column;
    gap: 10px;
    align-items: stretch;
  }

  .card-header .el-select {
    width: 100% !important;
  }

  /* 隐藏部分列 */
  :deep(.mobile-hide) {
    display: none !important;
  }

  /* 分页组件简化 */
  .pagination :deep(.el-pagination) {
    justify-content: center;
  }

  .pagination :deep(.el-pagination__sizes),
  .pagination :deep(.el-pagination__jump) {
    display: none;
  }
}

/* 小屏幕手机优化 (<430px) */
@media (max-width: 430px) {
  :deep(.el-table) {
    min-width: 600px !important; /* 保持最小宽度，允许横向滚动 */
  }

  /* 图片列固定宽度 80px */
  :deep(.mobile-image) {
    width: 80px !important;
  }

  :deep(.mobile-image .cell) {
    padding: 5px !important;
  }

  /* 商品标题列设置 min-width: 150px，使用省略号 */
  :deep(.el-table__body-wrapper .el-table__body tbody tr td:nth-child(2)) {
    min-width: 150px !important;
  }

  :deep(.el-table__body-wrapper .el-table__body tbody tr td:nth-child(2) .cell) {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  /* 价格列固定宽度 100px */
  :deep(.el-table__body-wrapper .el-table__body tbody tr td:nth-child(3)) {
    width: 100px !important;
  }

  /* 简化操作列 */
  :deep(.mobile-simple .cell) {
    padding: 5px !important;
  }

  /* 隐藏"店铺ID"和"销售预估"列 */
  :deep(.mobile-hide) {
    display: none !important;
  }
}
</style>

<style scoped>
.products-container {
  padding: 0;
  background: #f5f7fa;
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: auto;
}

/* 搜索和筛选区域（合并） */
.store-filter-section {
  background: white;
  padding: 24px;
  border-radius: 0;
  margin-bottom: 0;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

/* 搜索框区域 */
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

/* 筛选区域 */
.filter-area {
  /* 无需额外样式 */
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

/* 单行模式：限制高度，超出隐藏 */
.filter-tags.single-line {
  max-height: 38px;
  overflow: hidden;
  position: relative;
}

/* 添加渐变遮罩效果，让折叠更自然 */
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

/* 覆盖 Element Plus 默认样式 */
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

/* 类目包装器 */
.category-wrapper {
  position: relative;
  display: inline-block;
}

/* 下拉菜单 Portal 样式 */
.category-dropdown-portal {
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  padding: 8px;
  min-width: 160px;
  max-width: 180px;
  max-height: 200px; /* 调整为200px，确保只显示5个完整项目 */
  overflow-y: auto; /* 添加滚动条 */
}

/* 自定义滚动条样式 */
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

.dropdown-item:hover {
  background-color: #f5f5f5;
}

.dropdown-item.selected {
  background: linear-gradient(135deg, #7c4dff 0%, #9b7ff7 100%);
  color: white;
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

.toggle-btn:hover {
  color: #6a3de8;
  background: transparent;
}

.toggle-btn:deep(.el-button) {
  border: none;
  background: transparent;
}

.toggle-btn:deep(.el-button:hover) {
  background: transparent;
  border: none;
}

/* 高级筛选 */
.filter-selects {
  flex: 1;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

/* 自定义触发器（胶囊按钮） */
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

/* Popover 内容 */
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

/* 标准 select 样式 */
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

.custom-select :deep(.el-input__prefix) {
  margin: 0 !important;
}

.custom-select :deep(.el-input__suffix) {
  margin-left: 8px !important;
}

.select-full-label {
  font-size: 14px;
  color: #303133;
  white-space: nowrap;
  display: flex;
  align-items: center;
  gap: 4px;
}

/* 搜索结果区域 */
.results-section {
  background: white;
  padding: 20px;
  border-radius: 0;
  box-shadow: none;
  flex: 1;
  min-height: 400px;
}

/* 响应式布局 - 大屏（全屏） */
@media (min-width: 1200px) {
  .filter-row {
    flex-direction: row;
  }
}

/* 响应式布局 - 小屏（半屏） */
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

/* 移动端优化 */
@media (max-width: 768px) {
  .products-container {
    padding: 10px;
  }

  .store-filter-section {
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
/* 全局下拉菜单样式 - 不使用 scoped */
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