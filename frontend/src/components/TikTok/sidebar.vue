<template>
  <div class="tiktok-sidebar">
    <!-- 上方区域：平台和国家选择 -->
    <div class="sidebar-top">
      <!-- 平台选择器 -->
      <el-dropdown trigger="click" @command="handlePlatformChange" class="full-width-dropdown" popper-class="sidebar-dropdown-popper">
        <div class="selector-item">
          <el-icon class="item-icon" v-if="currentPlatform === 'TikTok'"><TikTokIcon /></el-icon>
          <el-icon class="item-icon" v-else><ShopifyIcon /></el-icon>
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
            <el-dropdown-item command="独立站">
              <div class="dropdown-item-with-icon">
                <el-icon class="dropdown-icon"><ShopifyIcon /></el-icon>
                <span>独立站</span>
              </div>
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>

      <!-- 国家选择器 -->
      <el-dropdown trigger="click" @command="handleCountryChange" class="full-width-dropdown" popper-class="sidebar-dropdown-popper">
        <div class="selector-item">
          <span class="country-flag">{{ currentCountryFlag }}</span>
          <span class="item-text">{{ currentCountry }}</span>
          <el-icon class="arrow-icon"><ArrowDown /></el-icon>
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="美国">🇺🇸 美国</el-dropdown-item>
            <el-dropdown-item command="巴西">🇧🇷 巴西</el-dropdown-item>
            <el-dropdown-item command="泰国">🇹🇭 泰国</el-dropdown-item>
            <el-dropdown-item command="马来西亚">🇲🇾 马来西亚</el-dropdown-item>
            <el-dropdown-item command="印尼">🇮🇩 印尼</el-dropdown-item>
            <el-dropdown-item command="越南">🇻🇳 越南</el-dropdown-item>
            <el-dropdown-item command="菲律宾">🇵🇭 菲律宾</el-dropdown-item>
            <el-dropdown-item command="新加坡">🇸🇬 新加坡</el-dropdown-item>
            <el-dropdown-item command="墨西哥">🇲🇽 墨西哥</el-dropdown-item>
            <el-dropdown-item command="英国">🇬🇧 英国</el-dropdown-item>
            <el-dropdown-item command="德国">🇩🇪 德国</el-dropdown-item>
            <el-dropdown-item command="法国">🇫🇷 法国</el-dropdown-item>
            <el-dropdown-item command="意大利">🇮🇹 意大利</el-dropdown-item>
            <el-dropdown-item command="西班牙">🇪🇸 西班牙</el-dropdown-item>
            <el-dropdown-item command="日本">🇯🇵 日本</el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>

      <!-- 知识付费按钮 -->
      <div class="knowledge-btn" @click="handleKnowledgeClick">
        <el-icon class="knowledge-icon"><Reading /></el-icon>
        <span class="knowledge-text">知识付费</span>
      </div>

      <!-- 出海探索按钮 -->
      <div class="explore-btn" @click="handleExploreClick">
        <el-icon class="explore-icon"><Search /></el-icon>
        <span class="explore-text">出海探索</span>
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
            <el-menu-item index="/tiktok/category/overview">品类大盘</el-menu-item>
            <el-menu-item index="/tiktok/product/overview">商品大盘</el-menu-item>
            <el-menu-item index="/tiktok/store/overview">店铺大盘</el-menu-item>
          </el-sub-menu>

          <!-- 商品 -->
          <el-sub-menu index="products">
            <template #title>
              <el-icon><ShoppingBag /></el-icon>
              <span>商品</span>
            </template>
            <el-menu-item index="/tiktok/products">商品搜索</el-menu-item>
            <el-menu-item index="/tiktok/products/sales-rank">销量榜</el-menu-item>
            <el-menu-item index="/tiktok/products/surge-rank">热推榜</el-menu-item>
            <el-menu-item index="/tiktok/products/potential-new">新品榜</el-menu-item>
            <el-menu-item index="/tiktok/products/history-rank">历史同期榜</el-menu-item>
            <el-menu-item index="/tiktok/products/amazon-search">亚马逊搜索</el-menu-item>
            <el-menu-item index="/tiktok/products/tiktok-search">TikTok搜索</el-menu-item>
          </el-sub-menu>

          <!-- 店铺 -->
          <el-sub-menu index="stores">
            <template #title>
              <el-icon><Shop /></el-icon>
              <span>店铺</span>
            </template>
            <el-menu-item index="/tiktok/stores">店铺搜索</el-menu-item>
            <el-menu-item index="/tiktok/stores/best-sellers">销量榜</el-menu-item>
            <el-menu-item index="/tiktok/stores/surge-rank">热推榜</el-menu-item>
          </el-sub-menu>

          <!-- 达人 -->
          <el-sub-menu index="influencers">
            <template #title>
              <el-icon><User /></el-icon>
              <span>达人</span>
            </template>
            <el-menu-item index="/tiktok/influencers">达人搜索</el-menu-item>
            <el-menu-item index="/tiktok/influencers/sales-rank">带货达人榜</el-menu-item>
            <el-menu-item index="/tiktok/influencers/follower-rank">涨粉达人榜</el-menu-item>
            <el-menu-item index="/tiktok/influencers/agency-rank">达人机构榜</el-menu-item>
          </el-sub-menu>

          <!-- 内容 -->
          <el-sub-menu index="content">
            <template #title>
              <el-icon><VideoIcon /></el-icon>
              <span>内容</span>
            </template>
            <el-menu-item index="/tiktok/videos">视频搜索</el-menu-item>
            <el-menu-item index="/tiktok/videos/ai">AI视频</el-menu-item>
            <el-menu-item index="/tiktok/ads/search">广告搜索</el-menu-item>
            <el-menu-item index="/tiktok/live/search">直播搜索</el-menu-item>
          </el-sub-menu>
        </el-menu>

        <!-- 外贸 -->
        <el-menu
          :default-active="activeMenu"
          class="sidebar-menu"
          :unique-opened="true"
          @select="handleMenuSelect"
        >
          <el-sub-menu index="trade">
            <template #title>
              <el-icon><Ship /></el-icon>
              <span>外贸</span>
            </template>
            <el-menu-item index="/trade/region">区域</el-menu-item>
            <el-menu-item index="/trade/product">产品</el-menu-item>
          </el-sub-menu>
        </el-menu>

        <!-- 服务商 -->
        <el-menu
          :default-active="activeMenu"
          class="sidebar-menu"
          :unique-opened="true"
          @select="handleMenuSelect"
        >
          <el-sub-menu index="service-provider">
            <template #title>
              <el-icon><Service /></el-icon>
              <span>服务商</span>
            </template>
            <el-menu-item index="/service/logistics">国际物流</el-menu-item>
            <el-menu-item index="/service/warehouse">海外仓</el-menu-item>
            <el-menu-item index="/service/qualification">资质办理</el-menu-item>
            <el-menu-item index="/service/factory">海外工厂</el-menu-item>
            <el-menu-item index="/service/influencer">达人对接</el-menu-item>
          </el-sub-menu>
        </el-menu>

        <el-menu
          :default-active="activeMenu"
          class="sidebar-menu"
          :unique-opened="true"
          @select="handleMenuSelect"
        >
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
  VideoPlay,
  ArrowDown,
  Search,
  Histogram,
  ShoppingBag,
  Shop,
  User,
  VideoCamera,
  Picture,
  Star,
  CreditCard,
  Reading,
  Box,
  Service,
  Ship,
  Setting
} from '@element-plus/icons-vue'
import AdIcon from '../icons/AdIcon.vue'
import TikTokIcon from '../icons/TikTokIcon.vue'
import VideoIcon from '../icons/VideoIcon.vue'
import ShopifyIcon from '../icons/ShopifyIcon.vue'

const router = useRouter()
const activeMenu = ref('dashboard')

// 当前选中的平台
const currentPlatform = ref('TikTok')

// 当前选中的国家
const currentCountry = ref('美国')

// 国家与国旗的映射
const countryFlags = {
  '美国': '🇺🇸',
  '巴西': '🇧🇷',
  '泰国': '🇹🇭',
  '马来西亚': '🇲🇾',
  '印尼': '🇮🇩',
  '越南': '🇻🇳',
  '菲律宾': '🇵🇭',
  '新加坡': '🇸🇬',
  '墨西哥': '🇲🇽',
  '英国': '🇬🇧',
  '德国': '🇩🇪',
  '法国': '🇫🇷',
  '意大利': '🇮🇹',
  '西班牙': '🇪🇸',
  '日本': '🇯🇵'
}

// 当前国家的国旗
const currentCountryFlag = computed(() => {
  return countryFlags[currentCountry.value] || '🌍'
})

// 处理平台切换
const handlePlatformChange = (platform) => {
  currentPlatform.value = platform
  console.log('切换平台:', platform)
  
  // 切换到独立站时跳转到独立站店铺搜索
  if (platform === '独立站') {
    router.push('/shopify/stores/search')
  }
}

// 处理国家切换
const handleCountryChange = (country) => {
  currentCountry.value = country
  console.log('切换国家:', country)
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

// 处理知识付费按钮点击
const handleKnowledgeClick = () => {
  router.push('/knowledge')
}

// 处理出海探索按钮点击
const handleExploreClick = () => {
  router.push('/overseas/explore')
}
</script>

<style scoped>
.tiktok-sidebar {
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

.selector-item.no-dropdown {
  cursor: default;
}

.selector-item.no-dropdown:hover {
  background-color: transparent;
}

.item-icon {
  font-size: 16px;
  margin-right: 6px;
  color: #303133;
}

.country-flag {
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

/* 知识付费按钮 */
.knowledge-btn {
  display: flex;
  align-items: center;
  padding: 6px 10px;
  background: #f5f7fa;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s;
  box-sizing: border-box;
  min-height: 32px;
}

.knowledge-btn:hover {
  background: #e8eaed;
  transform: translateY(-1px);
}

.knowledge-icon {
  font-size: 16px;
  margin-right: 8px;
  color: #606266;
}

.knowledge-text {
  font-size: 13px;
  color: #303133;
  font-weight: 500;
}

/* 菜单项按钮样式（仿知识付费按钮） */
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

/* 出海探索按钮 */
.explore-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 10px 12px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s;
  gap: 6px;
  box-sizing: border-box;
}

.explore-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
  background: linear-gradient(135deg, #7b8ff0 0%, #8a5bb0 100%);
}

.explore-icon {
  font-size: 16px;
  color: #ffffff;
}

.explore-text {
  font-size: 13px;
  color: #ffffff;
  font-weight: 600;
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

.ai-tag {
  margin-left: 8px;
  font-size: 10px;
  padding: 0 6px;
  height: 18px;
  line-height: 18px;
}

.sub-item-text {
  font-size: 13px;
  color: #606266;
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

/* 下拉菜单宽度优化 */
:deep(.el-dropdown-menu) {
  min-width: 100% !important;
  width: 100% !important;
  border-radius: 12px !important;
  max-height: 300px;
  overflow-y: auto;
}

:deep(.el-dropdown-menu__item) {
  padding: 6px 16px;
  font-size: 13px;
  line-height: 1.3;
  border-radius: 6px;
  margin: 2px 6px;
  min-height: 28px;
  height: 28px;
}

:deep(.el-dropdown-menu__item:hover) {
  background-color: #f5f7fa;
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

/* 确保下拉菜单与触发器宽度一致 */
:deep(.el-popper) {
  width: 100% !important;
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
