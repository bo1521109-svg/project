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
            <el-dropdown-item command="独立站">
              <div class="dropdown-item-with-icon">
                <el-icon class="dropdown-icon"><ShopifyIcon /></el-icon>
                <span>独立站</span>
              </div>
            </el-dropdown-item>
            <el-dropdown-item command="TikTok">
              <div class="dropdown-item-with-icon">
                <el-icon class="dropdown-icon"><TikTokIcon /></el-icon>
                <span>TikTok</span>
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
      <div class="knowledge-btn">
        <el-icon class="knowledge-icon"><Reading /></el-icon>
        <span class="knowledge-text">知识付费</span>
      </div>

      <!-- 出海探索按钮 -->
      <div class="explore-btn">
        <el-icon class="explore-icon"><Search /></el-icon>
        <span class="explore-text">出海探索</span>
      </div>
    </div>

    <!-- 中间间隙 -->
    <div class="sidebar-gap"></div>

    <!-- 下方区域：导航菜单 -->
    <div class="sidebar-bottom">
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
          <el-menu-item index="dashboard-category">品类大盘</el-menu-item>
          <el-menu-item index="dashboard-product">商品大盘</el-menu-item>
          <el-menu-item index="dashboard-store">店铺大盘</el-menu-item>
        </el-sub-menu>

        <!-- 商品 -->
        <el-sub-menu index="products">
          <template #title>
            <el-icon><ShoppingBag /></el-icon>
            <span>商品</span>
          </template>
          <el-menu-item index="products-search">商品搜索</el-menu-item>
          <el-menu-item index="products-sales-rank">销量榜</el-menu-item>
          <el-menu-item index="products-hot-rank">热推榜</el-menu-item>
          <el-menu-item index="products-new-rank">新品榜</el-menu-item>
          <el-menu-item index="products-history">历史同期榜</el-menu-item>
          <el-menu-item index="products-amazon-search">亚马逊搜索</el-menu-item>
          <el-menu-item index="products-tiktok-search">TikTok搜索</el-menu-item>
        </el-sub-menu>

        <!-- 店铺 -->
        <el-sub-menu index="stores">
          <template #title>
            <el-icon><Shop /></el-icon>
            <span>店铺</span>
          </template>
          <el-menu-item index="stores-search">店铺搜索</el-menu-item>
          <el-menu-item index="stores-sales-rank">销量榜</el-menu-item>
          <el-menu-item index="stores-hot-rank">热推榜</el-menu-item>
        </el-sub-menu>

        <!-- 达人 -->
        <el-sub-menu index="influencers">
          <template #title>
            <el-icon><User /></el-icon>
            <span>达人</span>
          </template>
          <el-menu-item index="influencers-search">达人搜索</el-menu-item>
          <el-menu-item index="influencers-sales-rank">带货达人榜</el-menu-item>
          <el-menu-item index="influencers-follower-rank">涨粉达人榜</el-menu-item>
          <el-menu-item index="influencers-agency-rank">达人机构榜</el-menu-item>
        </el-sub-menu>

        <!-- 视频 -->
        <el-sub-menu index="videos">
          <template #title>
            <el-icon><VideoIcon /></el-icon>
            <span>视频</span>
          </template>
          <el-menu-item index="videos-hot">热门视频</el-menu-item>
          <el-menu-item index="videos-ai">AI视频</el-menu-item>
        </el-sub-menu>

        <!-- 广告 -->
        <el-sub-menu index="ads">
          <template #title>
            <el-icon><AdIcon /></el-icon>
            <span>广告</span>
          </template>
          <el-menu-item index="ads-search">广告搜索</el-menu-item>
        </el-sub-menu>

        <!-- 直播 -->
        <el-sub-menu index="live">
          <template #title>
            <el-icon><VideoCamera /></el-icon>
            <span>直播</span>
          </template>
          <el-menu-item index="live-search">直播搜索</el-menu-item>
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
          <el-menu-item index="trade-region">区域</el-menu-item>
          <el-menu-item index="trade-product">产品</el-menu-item>
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
          <el-menu-item index="service-logistics">国际物流</el-menu-item>
          <el-menu-item index="service-warehouse">海外仓</el-menu-item>
          <el-menu-item index="service-qualification">资质办理</el-menu-item>
          <el-menu-item index="service-factory">海外工厂</el-menu-item>
          <el-menu-item index="service-influencer">达人对接</el-menu-item>
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
          <el-menu-item index="my-favorites">我的收藏</el-menu-item>
          <el-menu-item index="my-creations">我的创作</el-menu-item>
        </el-sub-menu>
      </el-menu>

      <!-- 购买续费 -->
      <div class="menu-item-btn" @click="handleMenuSelect('purchase')">
        <el-icon class="menu-item-icon"><CreditCard /></el-icon>
        <span class="menu-item-text">购买续费</span>
      </div>

      <!-- 账户中心 -->
      <div class="menu-item-btn" @click="handleMenuSelect('account')">
        <el-icon class="menu-item-icon"><Setting /></el-icon>
        <span class="menu-item-text">账户中心</span>
      </div>

      <!-- 底部图片 -->
      <div class="sidebar-image">
        <img src="/img_8448.jpg" alt="底部图片" />
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
}

// 处理国家切换
const handleCountryChange = (country) => {
  currentCountry.value = country
  console.log('切换国家:', country)
}

// 处理菜单选择
const handleMenuSelect = (index) => {
  activeMenu.value = index
  // 根据菜单项跳转到对应路由
  // router.push(`/tiktok/${index}`)
}
</script>

<style scoped>
.tiktok-sidebar {
  width: 100%;
  height: 100%;
  padding: 12px;
  display: flex;
  flex-direction: column;
  background: #f0f2f5;
  box-sizing: border-box;
}

/* 上方区域 */
.sidebar-top {
  background: #ffffff;
  border-radius: 16px;
  padding: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  display: flex;
  flex-direction: column;
  gap: 10px;
  box-sizing: border-box;
}

/* 下拉框占满宽度 */
.full-width-dropdown {
  width: 100%;
  display: block;
}

.selector-item {
  display: flex;
  align-items: center;
  padding: 8px 12px;
  border-radius: 12px;
  cursor: pointer;
  transition: background-color 0.2s;
  box-sizing: border-box;
  min-height: 36px;
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
  font-size: 18px;
  margin-right: 8px;
  color: #303133;
}

.country-flag {
  font-size: 18px;
  margin-right: 8px;
}

.item-text {
  flex: 1;
  font-size: 14px;
  color: #303133;
  font-weight: 500;
}

.arrow-icon {
  font-size: 14px;
  color: #909399;
}

/* 知识付费按钮 */
.knowledge-btn {
  display: flex;
  align-items: center;
  padding: 8px 12px;
  background: #f5f7fa;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s;
  box-sizing: border-box;
  min-height: 36px;
}

.knowledge-btn:hover {
  background: #e8eaed;
  transform: translateY(-1px);
}

.knowledge-icon {
  font-size: 20px;
  margin-right: 10px;
  color: #606266;
}

.knowledge-text {
  font-size: 14px;
  color: #303133;
  font-weight: 500;
}

/* 菜单项按钮样式（仿知识付费按钮） */
.menu-item-btn {
  display: flex;
  align-items: center;
  padding: 8px 20px;
  background: #ffffff;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  box-sizing: border-box;
  min-height: 36px;
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
  font-size: 18px;
  margin-right: 8px;
  color: #606266;
  transition: color 0.2s;
}

.menu-item-text {
  font-size: 14px;
  color: #303133;
  font-weight: 400;
  transition: color 0.2s;
}

/* 出海探索按钮 */
.explore-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 12px 16px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s;
  gap: 8px;
  box-sizing: border-box;
}

.explore-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
  background: linear-gradient(135deg, #7b8ff0 0%, #8a5bb0 100%);
}

.explore-icon {
  font-size: 18px;
  color: #ffffff;
}

.explore-text {
  font-size: 14px;
  color: #ffffff;
  font-weight: 600;
}

/* 中间间隙 */
.sidebar-gap {
  height: 12px;
  flex-shrink: 0;
}

/* 下方区域 */
.sidebar-bottom {
  flex: 1;
  background: #ffffff;
  border-radius: 16px;
  padding: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  overflow-y: auto;
  box-sizing: border-box;
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
  height: 36px;
  line-height: 36px;
  padding: 0 16px !important;
  display: flex !important;
  align-items: center;
  justify-content: flex-start !important;
}

.sidebar-menu .el-menu-item .el-icon {
  margin-right: 8px;
  flex-shrink: 0;
}

.sidebar-menu .el-menu-item span {
  flex: 1;
  text-align: left !important;
}

.sidebar-menu .el-sub-menu :deep(.el-sub-menu__title) {
  border-radius: 6px;
  height: 36px;
  line-height: 36px;
  padding: 0 16px !important;
  display: flex !important;
  align-items: center;
  justify-content: flex-start !important;
}

.sidebar-menu .el-sub-menu :deep(.el-sub-menu__title .el-icon) {
  margin-right: 8px;
  font-size: 18px;
  color: #606266;
  transition: color 0.2s;
}

.sidebar-menu .el-sub-menu :deep(.el-sub-menu__title span) {
  flex: 1;
  text-align: left !important;
  font-size: 14px;
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
  padding-left: 48px !important;
}

.sidebar-menu .el-sub-menu .el-menu-item {
  min-height: 36px;
  height: 36px;
  line-height: 36px;
}

.sidebar-menu .el-sub-menu .el-menu-item:hover {
  background-color: #f5f7fa;
  color: #8b5cf6;
}

/* 隐藏滚动条 */
.sidebar-bottom::-webkit-scrollbar {
  display: none;
}

.sidebar-bottom {
  -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;  /* Firefox */
}

/* 底部图片样式 */
.sidebar-image {
  margin-top: 12px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.sidebar-image img {
  width: 100%;
  height: auto;
  display: block;
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
  width: 192px !important;
}

.sidebar-dropdown-popper .el-dropdown-menu {
  width: 100% !important;
  border-radius: 12px !important;
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
