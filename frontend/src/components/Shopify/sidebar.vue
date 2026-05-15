<template>
  <div class="shopify-sidebar">
    <!-- 上方区域：平台和地区选择 -->
    <div class="sidebar-top">
      <!-- 平台选择器 -->
      <el-dropdown trigger="click" @command="handlePlatformChange" class="full-width-dropdown" popper-class="sidebar-dropdown-popper">
        <div class="selector-item">
          <el-icon class="item-icon" v-if="currentPlatformIconType === 'component' && currentPlatformIcon === 'shopify'"><ShopifyIcon /></el-icon>
          <el-icon class="item-icon" v-else-if="currentPlatformIconType === 'component' && currentPlatformIcon === 'tiktok'"><TikTokIcon /></el-icon>
          <span class="platform-emoji" v-else>{{ currentPlatformIcon }}</span>
          <span class="item-text">{{ currentPlatform }}</span>
          <el-icon class="arrow-icon"><ArrowDown /></el-icon>
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="TikTok">
              <div class="dropdown-item-with-icon">
                <el-icon class="dropdown-icon"><TikTokIcon /></el-icon>
                <span>TikTok</span>
              </div>
            </el-dropdown-item>
            <el-dropdown-item command="Shopify">
              <div class="dropdown-item-with-icon">
                <el-icon class="dropdown-icon"><ShopifyIcon /></el-icon>
                <span>Shopify</span>
              </div>
            </el-dropdown-item>
            <el-dropdown-item command="WordPress">
              <div class="dropdown-item-with-icon">
                <span class="platform-emoji">🌐</span>
                <span>WordPress</span>
              </div>
            </el-dropdown-item>
            <el-dropdown-item command="shopline">
              <div class="dropdown-item-with-icon">
                <span class="platform-emoji">🛍️</span>
                <span>shopline</span>
              </div>
            </el-dropdown-item>
            <el-dropdown-item command="Shoplazza/店匠">
              <div class="dropdown-item-with-icon">
                <span class="platform-emoji">🏪</span>
                <span>Shoplazza/店匠</span>
              </div>
            </el-dropdown-item>
            <el-dropdown-item command="Shoppy">
              <div class="dropdown-item-with-icon">
                <span class="platform-emoji">🛒</span>
                <span>Shoppy</span>
              </div>
            </el-dropdown-item>
            <el-dropdown-item command="Shopoem">
              <div class="dropdown-item-with-icon">
                <span class="platform-emoji">💼</span>
                <span>Shopoem</span>
              </div>
            </el-dropdown-item>
            <el-dropdown-item command="Shopbase">
              <div class="dropdown-item-with-icon">
                <span class="platform-emoji">🏬</span>
                <span>Shopbase</span>
              </div>
            </el-dropdown-item>
            <el-dropdown-item command="Ueeshop">
              <div class="dropdown-item-with-icon">
                <span class="platform-emoji">🏢</span>
                <span>Ueeshop</span>
              </div>
            </el-dropdown-item>
            <el-dropdown-item command="BigCommerce">
              <div class="dropdown-item-with-icon">
                <span class="platform-emoji">🏭</span>
                <span>BigCommerce</span>
              </div>
            </el-dropdown-item>
            <el-dropdown-item command="WooCommerce">
              <div class="dropdown-item-with-icon">
                <span class="platform-emoji">🔧</span>
                <span>WooCommerce</span>
              </div>
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>

      <!-- 地区选择器 -->
      <el-dropdown trigger="click" @command="handleRegionChange" class="full-width-dropdown" popper-class="sidebar-dropdown-popper">
        <div class="selector-item">
          <span class="region-flag">{{ currentRegionFlag }}</span>
          <span class="item-text">{{ currentRegion }}</span>
          <el-icon class="arrow-icon"><ArrowDown /></el-icon>
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="欧美">🌍 欧美</el-dropdown-item>
            <el-dropdown-item command="拉美">🌎 拉美</el-dropdown-item>
            <el-dropdown-item command="中东">🕌 中东</el-dropdown-item>
            <el-dropdown-item command="东亚">🏯 东亚</el-dropdown-item>
            <el-dropdown-item command="中亚">🏔️ 中亚</el-dropdown-item>
            <el-dropdown-item command="东南亚">🌴 东南亚</el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>

      <!-- 工作台按钮 -->
      <div class="workbench-btn" @click="handleWorkbenchClick">
        <el-icon class="workbench-icon"><Monitor /></el-icon>
        <span class="workbench-text">工作台</span>
      </div>
    </div>

    <!-- 中间间隙 -->
    <div class="sidebar-gap"></div>

    <!-- 下方区域：导航菜单 -->
    <div class="sidebar-bottom">
      <div class="sidebar-menu-wrapper">
        <el-menu
          :default-active="activeMenu"
          class="sidebar-menu"
          :unique-opened="true"
          @select="handleMenuSelect"
        >
          <!-- 数据大盘 -->
          <el-sub-menu index="dashboard">
            <template #title>
              <el-icon><Histogram /></el-icon>
              <span>数据大盘</span>
            </template>
            <el-menu-item index="/shopify/category/overview">品类大盘</el-menu-item>
            <el-menu-item index="/shopify/product/overview">商品大盘</el-menu-item>
            <el-menu-item index="/shopify/store/overview">店铺大盘</el-menu-item>
            <el-menu-item index="/shopify/ai-report">AI报告</el-menu-item>
          </el-sub-menu>

          <!-- 商品 -->
          <el-sub-menu index="products">
            <template #title>
              <el-icon><ShoppingBag /></el-icon>
              <span>商品</span>
            </template>
            <el-menu-item index="/shopify/products">商品搜索</el-menu-item>
            <el-menu-item index="/shopify/products/sales-rank">销量榜</el-menu-item>
            <el-menu-item index="/shopify/products/surge-rank">热推榜</el-menu-item>
            <el-menu-item index="/shopify/products/potential-new">新品榜</el-menu-item>
            <el-menu-item index="shopify-products-history">历史同期榜</el-menu-item>
          </el-sub-menu>

          <!-- 店铺 -->
          <el-sub-menu index="stores">
            <template #title>
              <el-icon><Shop /></el-icon>
              <span>店铺</span>
            </template>
            <el-menu-item index="/shopify/stores/search">店铺搜索</el-menu-item>
            <el-menu-item index="/shopify/stores/best-sellers">销量榜</el-menu-item>
            <el-menu-item index="/shopify/stores/surge-rank">热推榜</el-menu-item>
          </el-sub-menu>

          <!-- 视频 -->
          <el-sub-menu index="videos">
            <template #title>
              <el-icon><VideoIcon /></el-icon>
              <span>视频</span>
            </template>
            <el-menu-item index="/shopify/videos/hot">热门视频</el-menu-item>
            <el-menu-item index="/shopify/videos/ai">AI话题</el-menu-item>
          </el-sub-menu>

          <!-- 广告 -->
          <el-sub-menu index="ads">
            <template #title>
              <el-icon><AdIcon /></el-icon>
              <span>广告</span>
            </template>
            <el-menu-item index="/shopify/ads/library">广告搜索</el-menu-item>
          </el-sub-menu>

          <!-- 我的 -->
          <el-sub-menu index="my">
            <template #title>
              <el-icon><Star /></el-icon>
              <span>我的</span>
            </template>
            <el-menu-item index="/my/favorites">我的收藏</el-menu-item>
            <el-menu-item index="/my/creations">我的创作</el-menu-item>
            <el-menu-item index="/purchase">购买续费</el-menu-item>
            <el-menu-item index="/profile">账户中心</el-menu-item>
          </el-sub-menu>
        </el-menu>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import {
  ArrowDown,
  Histogram,
  ShoppingBag,
  Shop,
  CreditCard,
  Setting,
  Monitor,
  Star
} from '@element-plus/icons-vue'
import AdIcon from '../icons/AdIcon.vue'
import VideoIcon from '../icons/VideoIcon.vue'
import ShopifyIcon from '../icons/ShopifyIcon.vue'
import TikTokIcon from '../icons/TikTokIcon.vue'

const router = useRouter()
const activeMenu = ref('dashboard')

// 当前选中的平台
const currentPlatform = ref('Shopify')

// 当前选中的地区
const currentRegion = ref('欧美')

// 平台与图标的映射
const platformIcons = {
  'Shopify': 'shopify',
  'TikTok': 'tiktok',
  'WordPress': '🌐',
  'shopline': '🛍️',
  'Shoplazza/店匠': '🏪',
  'Shoppy': '🛒',
  'Shopoem': '💼',
  'Shopbase': '🏬',
  'Ueeshop': '🏢',
  'BigCommerce': '🏭',
  'WooCommerce': '🔧'
}

// 当前平台的图标类型
const currentPlatformIconType = computed(() => {
  return platformIcons[currentPlatform.value] === 'shopify' ? 'component' : 'emoji'
})

// 当前平台的图标
const currentPlatformIcon = computed(() => {
  return platformIcons[currentPlatform.value] || '🛍️'
})

// 地区与图标的映射
const regionFlags = {
  '欧美': '🌍',
  '拉美': '🌎',
  '中东': '🕌',
  '东亚': '🏯',
  '中亚': '🏔️',
  '东南亚': '🌴'
}

// 当前地区的图标
const currentRegionFlag = computed(() => {
  return regionFlags[currentRegion.value] || '🌍'
})

// 处理平台切换
const handlePlatformChange = (platform) => {
  currentPlatform.value = platform
  console.log('切换平台:', platform)
  
  // 切换到TikTok时跳转到TikTok品类大盘
  if (platform === 'TikTok') {
    router.push('/tiktok/category/overview')
  }
}

// 处理地区切换
const handleRegionChange = (region) => {
  currentRegion.value = region
  console.log('切换地区:', region)
}

// 处理工作台点击
const handleWorkbenchClick = () => {
  router.push('/shopify/workbench')
}

// 处理菜单选择
const handleMenuSelect = (index) => {
  activeMenu.value = index
  
  // 如果index以'/'开头，说明是可复用的路由路径，直接跳转
  if (index.startsWith('/')) {
    router.push(index)
  } else {
    // 否则是暂未实现的功能，暂不跳转
    console.log('菜单项暂未实现:', index)
  }
}
</script>

<style scoped>
.shopify-sidebar {
  width: 100%;
  height: 100%;
  padding: 0;
  display: flex;
  flex-direction: column;
  background: #ffffff;
  box-sizing: border-box;
}

/* 上方区域 */
.sidebar-top {
  background: #ffffff;
  border-radius: 0;
  padding: 10px;
  box-shadow: none;
  display: flex;
  flex-direction: column;
  gap: 8px;
  box-sizing: border-box;
  border-bottom: 1px solid #e4e7ed;
}

/* 下拉框占满宽度 */
.full-width-dropdown {
  width: 100%;
  display: block;
}

.selector-item {
  display: flex;
  align-items: center;
  padding: 6px 10px;
  border-radius: 10px;
  cursor: pointer;
  transition: background-color 0.2s;
  box-sizing: border-box;
  min-height: 32px;
  width: 100%;
}

.selector-item:hover {
  background-color: #f5f7fa;
  transform: translateY(-1px);
}

.item-icon {
  font-size: 16px;
  margin-right: 6px;
  color: #303133;
}

.platform-emoji {
  font-size: 16px;
  margin-right: 6px;
}

.region-flag {
  font-size: 16px;
  margin-right: 6px;
}

.item-text {
  flex: 1;
  font-size: 13px;
  color: #303133;
  font-weight: 500;
}

.arrow-icon {
  font-size: 12px;
  color: #909399;
}

/* 菜单项按钮样式 */
.menu-item-btn {
  display: flex;
  align-items: center;
  padding: 6px 16px;
  background: #ffffff;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  box-sizing: border-box;
  min-height: 32px;
  margin-bottom: 4px;
}

.menu-item-btn:hover {
  background: #f5f7fa;
  transform: translateY(-1px);
}

.menu-item-btn:hover .menu-item-icon {
  color: #8b5cf6;
}

.menu-item-btn:hover .menu-item-text {
  color: #8b5cf6;
}

.menu-item-icon {
  font-size: 16px;
  margin-right: 6px;
  color: #606266;
  transition: color 0.2s;
}

.menu-item-text {
  font-size: 13px;
  color: #303133;
  font-weight: 400;
  transition: color 0.2s;
}

/* 中间间隙 */
.sidebar-gap {
  height: 0;
  flex-shrink: 0;
}

/* 下方区域 */
.sidebar-bottom {
  flex: 1;
  background: #ffffff;
  border-radius: 0;
  padding: 6px;
  box-shadow: none;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

/* 菜单包装器 - 可滚动区域 */
.sidebar-menu-wrapper {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  padding-bottom: 6px;
}

/* 隐藏菜单包装器的滚动条 */
.sidebar-menu-wrapper::-webkit-scrollbar {
  display: none;
}

.sidebar-menu-wrapper {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

.sidebar-menu {
  border: none;
  background: transparent;
}

.sidebar-menu .el-menu-item,
.sidebar-menu .el-sub-menu {
  margin-bottom: 4px;
}

.sidebar-menu .el-menu-item {
  border-radius: 6px;
  height: 32px;
  line-height: 32px;
  padding: 0 12px !important;
  display: flex !important;
  align-items: center;
  justify-content: flex-start !important;
}

.sidebar-menu .el-menu-item .el-icon {
  margin-right: 6px;
  flex-shrink: 0;
}

.sidebar-menu .el-menu-item span {
  flex: 1;
  text-align: left !important;
}

.sidebar-menu .el-sub-menu :deep(.el-sub-menu__title) {
  border-radius: 6px;
  height: 32px;
  line-height: 32px;
  padding: 0 12px !important;
  display: flex !important;
  align-items: center;
  justify-content: flex-start !important;
}

.sidebar-menu .el-sub-menu :deep(.el-sub-menu__title .el-icon) {
  margin-right: 6px;
  font-size: 16px;
  color: #606266;
  transition: color 0.2s;
}

.sidebar-menu .el-sub-menu :deep(.el-sub-menu__title span) {
  flex: 1;
  text-align: left !important;
  font-size: 13px;
  color: #303133;
  font-weight: 400;
  transition: color 0.2s;
}

.sidebar-menu .el-menu-item:hover,
.sidebar-menu .el-sub-menu :deep(.el-sub-menu__title):hover {
  background-color: #f5f7fa;
}

.sidebar-menu .el-menu-item:hover,
.sidebar-menu .el-sub-menu :deep(.el-sub-menu__title):hover span {
  color: #8b5cf6;
}

.sidebar-menu .el-menu-item:hover .el-icon,
.sidebar-menu .el-sub-menu :deep(.el-sub-menu__title):hover .el-icon {
  color: #8b5cf6;
}

.sidebar-menu .el-menu-item.is-active {
  background-color: #ecf5ff;
  color: #409EFF;
}

/* 二级菜单项样式 */
.sidebar-menu .el-menu-item {
  padding-left: 40px !important;
}

.sidebar-menu .el-sub-menu .el-menu-item {
  min-height: 32px;
  height: 32px;
  line-height: 32px;
  font-size: 12px;
}

.sidebar-menu .el-sub-menu .el-menu-item:hover {
  background-color: #f5f7fa;
  color: #8b5cf6;
}

/* 工作台按钮样式 */
.workbench-btn {
  display: flex;
  align-items: center;
  padding: 6px 10px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-sizing: border-box;
  min-height: 32px;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
}

.workbench-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.workbench-icon {
  font-size: 16px;
  margin-right: 6px;
  color: #ffffff;
}

.workbench-text {
  flex: 1;
  font-size: 13px;
  color: #ffffff;
  font-weight: 500;
}

/* 下拉菜单项图标样式 */
.dropdown-item-with-icon {
  display: flex;
  align-items: center;
  gap: 8px;
}

.dropdown-icon {
  font-size: 16px;
  flex-shrink: 0;
}

.platform-emoji {
  font-size: 16px;
  flex-shrink: 0;
  width: 16px;
  height: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>

<style>
/* 全局样式：控制侧边栏下拉菜单宽度 */
.sidebar-dropdown-popper {
  width: 160px !important;
}

.sidebar-dropdown-popper .el-dropdown-menu {
  width: 100% !important;
  border-radius: 10px !important;
}

/* 强制菜单项居左对齐 */
.sidebar-menu .el-menu-item {
  text-align: left !important;
  justify-content: flex-start !important;
}

.sidebar-menu .el-menu-item > * {
  text-align: left !important;
}

.sidebar-menu .el-sub-menu__title {
  text-align: left !important;
  justify-content: flex-start !important;
}

.sidebar-menu .el-sub-menu__title > * {
  text-align: left !important;
}
</style>
