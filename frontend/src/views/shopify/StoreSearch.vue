<template>
  <div class="store-search-page">
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

        <!-- 店铺类型 -->
        <div class="filter-row">
          <div class="filter-label">店铺类型：</div>
          <div class="filter-content">
            <div class="filter-tags">
              <el-tag
                v-for="type in storeTypes"
                :key="type.value"
                :type="selectedStoreType === type.value ? '' : 'info'"
                :effect="selectedStoreType === type.value ? 'dark' : 'plain'"
                :class="{ 'tag-selected': selectedStoreType === type.value }"
                @click="selectStoreType(type.value)"
                class="filter-tag"
              >
                {{ type.label }}
              </el-tag>
            </div>
          </div>
        </div>

        <!-- 店铺定位 -->
        <div class="filter-row">
          <div class="filter-label">店铺定位：</div>
          <div class="filter-content">
            <div class="filter-tags">
              <el-tag
                v-for="position in storePositions"
                :key="position.value"
                :type="selectedStorePosition === position.value ? '' : 'info'"
                :effect="selectedStorePosition === position.value ? 'dark' : 'plain'"
                :class="{ 'tag-selected': selectedStorePosition === position.value }"
                @click="selectStorePosition(position.value)"
                class="filter-tag"
              >
                {{ position.label }}
              </el-tag>
            </div>
          </div>
        </div>

        <!-- 筛选条件 -->
        <div class="filter-row advanced-filters">
          <div class="filter-label">筛选条件：</div>
          <div class="filter-content">
            <div class="filter-selects">
              <div class="filter-select-item">
                <span class="select-label">店铺评分：</span>
                <el-select v-model="filters.rating" placeholder="全部" size="small">
                  <el-option label="全部" value="all" />
                  <el-option label="4.5分以上" value="4.5" />
                  <el-option label="4.0分以上" value="4.0" />
                  <el-option label="3.5分以上" value="3.5" />
                </el-select>
              </div>

              <div class="filter-select-item">
                <span class="select-label">近7天销量：</span>
                <el-select v-model="filters.sales7d" placeholder="全部" size="small">
                  <el-option label="全部" value="all" />
                  <el-option label="1000+件" value="1000" />
                  <el-option label="5000+件" value="5000" />
                  <el-option label="10000+件" value="10000" />
                </el-select>
              </div>

              <div class="filter-select-item">
                <span class="select-label">近7天销售额：</span>
                <el-select v-model="filters.revenue7d" placeholder="全部" size="small">
                  <el-option label="全部" value="all" />
                  <el-option label="$10K+" value="10000" />
                  <el-option label="$50K+" value="50000" />
                  <el-option label="$100K+" value="100000" />
                </el-select>
              </div>

              <div class="filter-select-item">
                <span class="select-label">总销量：</span>
                <el-select v-model="filters.totalSales" placeholder="全部" size="small">
                  <el-option label="全部" value="all" />
                  <el-option label="10000+件" value="10000" />
                  <el-option label="50000+件" value="50000" />
                  <el-option label="100000+件" value="100000" />
                </el-select>
              </div>

              <div class="filter-select-item">
                <span class="select-label">总销售额：</span>
                <el-select v-model="filters.totalRevenue" placeholder="全部" size="small">
                  <el-option label="全部" value="all" />
                  <el-option label="$100K+" value="100000" />
                  <el-option label="$500K+" value="500000" />
                  <el-option label="$1M+" value="1000000" />
                </el-select>
              </div>

              <div class="filter-select-item">
                <span class="select-label">带货达人数：</span>
                <el-select v-model="filters.influencerCount" placeholder="全部" size="small">
                  <el-option label="全部" value="all" />
                  <el-option label="10+人" value="10" />
                  <el-option label="50+人" value="50" />
                  <el-option label="100+人" value="100" />
                </el-select>
              </div>

              <div class="filter-select-item">
                <span class="select-label">新品成交占比：</span>
                <el-select v-model="filters.newProductRatio" placeholder="全部" size="small">
                  <el-option label="全部" value="all" />
                  <el-option label="30%以上" value="30" />
                  <el-option label="50%以上" value="50" />
                  <el-option label="70%以上" value="70" />
                </el-select>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 搜索结果区域（占位） -->
    <div class="results-section">
      <el-empty description="请输入搜索条件并点击搜索按钮" />
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import { Search, ArrowDown, ArrowUp } from '@element-plus/icons-vue'

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
const selectedStoreType = ref('all')
const selectedStorePosition = ref('all')

// 下拉菜单相关
const hoveredCategory = ref(null)
const dropdownStyle = ref({})
const keepDropdownOpen = ref(false)
let hoverTimer = null

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
    children: []
  },
  { 
    label: '家电', 
    value: 'appliances',
    children: []
  },
  { 
    label: '宠物用品', 
    value: 'pet',
    children: []
  },
  { 
    label: '珠宝与仿生首饰', 
    value: 'jewelry',
    children: []
  },
  { 
    label: '图书杂志音像', 
    value: 'books',
    children: []
  },
  { 
    label: '母婴用品', 
    value: 'baby',
    children: []
  },
  { 
    label: '家具', 
    value: 'furniture',
    children: []
  },
  { 
    label: '儿童时尚', 
    value: 'kids-fashion',
    children: []
  },
  { 
    label: '穆斯林时尚', 
    value: 'muslim-fashion',
    children: []
  },
  { 
    label: '二手', 
    value: 'second-hand',
    children: []
  },
  { 
    label: '虚拟商品', 
    value: 'virtual',
    children: []
  }
]

// 店铺类型
const storeTypes = [
  { label: '全部', value: 'all' },
  { label: '跨境店', value: 'cross-border' },
  { label: '本土店', value: 'local' }
]

// 店铺定位
const storePositions = [
  { label: '全部', value: 'all' },
  { label: '品牌', value: 'brand' },
  { label: '零售商', value: 'retailer' }
]

// 切换折叠状态
const toggleSection = (section) => {
  collapsedSections.value[section] = !collapsedSections.value[section]
}

// 选择国家
const selectCountry = (value) => {
  selectedCountry.value = value
}

// 选择类目
const selectCategory = (value) => {
  selectedCategory.value = value
}

// 选择店铺类型
const selectStoreType = (value) => {
  selectedStoreType.value = value
}

// 选择店铺定位
const selectStorePosition = (value) => {
  selectedStorePosition.value = value
}

// 搜索
const handleSearch = () => {
  console.log('搜索条件：', {
    keyword: searchKeyword.value,
    country: selectedCountry.value,
    category: selectedCategory.value,
    storeType: selectedStoreType.value,
    storePosition: selectedStorePosition.value,
    ...filters.value
  })
  // TODO: 调用搜索API
}

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
</script>

<style scoped>
.store-search-page {
  padding: 20px;
  background: #f5f7fa;
  min-height: 100vh;
}

/* 搜索和筛选区域（合并） */
.search-filter-section {
  background: white;
  padding: 24px;
  border-radius: 12px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
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
  gap: 12px;
}

.filter-select-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.select-label {
  font-size: 14px;
  color: #666;
  white-space: nowrap;
}

.filter-select-item :deep(.el-select) {
  width: 140px;
}

/* 搜索结果区域 */
.results-section {
  background: white;
  padding: 40px 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
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

  .filter-select-item {
    width: 100%;
  }

  .filter-select-item :deep(.el-select) {
    flex: 1;
  }
}

/* 移动端优化 */
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
