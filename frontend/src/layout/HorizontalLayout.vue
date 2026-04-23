<template>
  <el-container class="horizontal-layout">
    <!-- 顶部固定 Header -->
    <el-header class="top-header">
      <div class="header-content">
        <!-- Logo -->
        <div class="logo">
          <img src="/logo.svg" alt="Logo" class="logo-img" />
          <span class="logo-text">跨境电商数据平台</span>
        </div>

        <!-- 一级导航 -->
        <div class="nav-wrapper">
          <el-menu
            :default-active="activeFirstLevel"
            mode="horizontal"
            class="main-nav"
            @select="handleFirstLevelSelect"
          >
            <el-menu-item
              v-for="item in navigation"
              :key="item.path"
              :index="item.path"
              :disabled="item.disabled"
              @mouseenter="handleMouseEnter(item)"
              @mouseleave="handleMouseLeave"
              @click="handleFirstLevelClick(item)"
            >
              <span>{{ item.name }}</span>
            </el-menu-item>
          </el-menu>
        </div>

        <!-- 右侧用户区 -->
        <div class="user-area">
          <el-dropdown @command="handleUserCommand" trigger="click">
            <div class="user-info">
              <el-icon><User /></el-icon>
              <span class="username">{{ userStore.userInfo?.username || '用户' }}</span>
              <el-icon class="arrow"><ArrowDown /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">
                  <el-icon><User /></el-icon>
                  个人中心
                </el-dropdown-item>
                <el-dropdown-item command="upgrade">
                  <el-icon><Star /></el-icon>
                  升级会员
                </el-dropdown-item>
                <el-dropdown-item divided command="logout">
                  <el-icon><SwitchButton /></el-icon>
                  退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </el-header>

    <!-- 悬停展开的二级 Mega Menu -->
    <transition name="mega-menu">
      <div
        v-if="showMegaMenu && currentFirstLevel"
        class="mega-menu"
        @mouseenter="keepMegaMenuOpen"
        @mouseleave="closeMegaMenu"
      >
        <div class="mega-menu-content">
          <!-- 遍历每个大卡片 -->
          <div
            v-for="(section, index) in currentFirstLevel.children"
            :key="index"
            class="mega-menu-section"
          >
            <!-- 大卡片（点击跳转到该列第一个链接） -->
            <div 
              class="mega-card" 
              v-if="section.card"
              @click="handleCardClick(section)"
            >
              <div class="card-icon">
                <el-icon :size="32">
                  <component :is="section.card.icon || 'ShoppingCart'" />
                </el-icon>
              </div>
              <div class="card-content">
                <h3 class="card-title">{{ section.card.title }}</h3>
                <p class="card-desc">{{ section.card.desc }}</p>
              </div>
              <div class="card-arrow">
                <el-icon :size="20">
                  <ArrowRight />
                </el-icon>
              </div>
            </div>

            <!-- 下方小链接列表 -->
            <div class="mega-links" v-if="section.links && section.links.length > 0">
              <div
                v-for="link in section.links"
                :key="link.path"
                class="mega-link-item"
                :class="{ 'blank-slot': link.isBlank }"
                @click="!link.isBlank && handleLinkClick(link)"
              >
                <template v-if="link.isBlank">
                  <div class="blank-slot"></div>
                </template>
                <template v-else>
                  <span class="link-name">{{ link.name }}</span>
                </template>
              </div>
            </div>
          </div>
        </div>
      </div>
    </transition>

    <!-- 主内容区 -->
    <el-main class="main-content">
      <!-- 左侧边栏（TikTok数据时显示） -->
      <aside v-if="activeNav === 'tiktok'" class="left-sidebar">
        <TikTokSidebar />
      </aside>
      
      <!-- 左侧边栏（独立站数据时显示） -->
      <aside v-if="activeNav === 'shopify'" class="left-sidebar">
        <ShopifySidebar />
      </aside>
      
      <!-- 左侧边栏（内容创作时显示） -->
      <aside v-if="activeNav === 'content'" class="left-sidebar">
        <ContentSidebar />
      </aside>
      
      <!-- 左侧边栏（社媒管理时显示） -->
      <aside v-if="activeNav === 'social'" class="left-sidebar">
        <SocialSidebar />
      </aside>
      
      <!-- 右侧主内容区 -->
      <div class="content-wrapper" :class="{ 'with-sidebar': activeNav === 'tiktok' || activeNav === 'shopify' || activeNav === 'content' || activeNav === 'social' }">
        <router-view />
      </div>
    </el-main>
  </el-container>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  User,
  ArrowDown,
  ArrowRight,
  Star,
  SwitchButton,
  VideoPlay,
  ShoppingCart,
  Edit,
  ChatDotRound,
  Monitor,
  Ship,
  Setting,
  Histogram,
  Lightning,
  VideoCamera,
  Picture,
  FolderOpened,
  Globe,
  Lock,
  TrendCharts,
  Upload,
  Chat,
  Box,
  Connection,
  Reading
} from '@element-plus/icons-vue'
import { useUserStore } from '../stores/user'
import { getFilteredNav } from '../config/navigation.js'
import TikTokSidebar from '../components/TikTok/sidebar.vue'
import ShopifySidebar from '../components/Shopify/sidebar.vue'
import ContentSidebar from '../components/Content/sidebar.vue'
import SocialSidebar from '../components/Social/sidebar.vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

// 获取过滤后的导航（根据用户角色）
const navigation = computed(() => {
  const userRole = userStore.userInfo?.role || 'user'
  return getFilteredNav(userRole)
})

// 当前激活的一级导航
const activeFirstLevel = ref('')

// 计算当前激活的导航（用于判断是否显示侧边栏）
const activeNav = computed(() => {
  const path = route.path
  // TikTok数据相关路径
  if (path.includes('/tiktok') || 
      path.includes('/trade') || 
      path.includes('/service') || 
      path.includes('/my/') ||
      path.includes('/purchase') ||
      path.includes('/knowledge') ||
      path.includes('/overseas/explore')) {
    return 'tiktok'
  }
  // 独立站数据相关路径
  if (path.includes('/shopify')) {
    return 'shopify'
  }
  // 内容创作相关路径
  if (path.includes('/content')) {
    return 'content'
  }
  // 社媒管理相关路径
  if (path.includes('/social')) {
    return 'social'
  }
  return ''
})

// 当前悬停的一级导航项
const currentFirstLevel = ref(null)

// 是否显示 Mega Menu
const showMegaMenu = ref(false)

// Mega Menu 悬停定时器
let megaMenuTimer = null

// 根据当前路由设置激活的一级导航
watch(
  () => route.path,
  (newPath) => {
    // 查找当前路径属于哪个一级导航
    for (const item of navigation.value) {
      if (item.children) {
        const found = item.children.find(child => child.path === newPath)
        if (found) {
          activeFirstLevel.value = item.path
          return
        }
      }
      if (item.path === newPath) {
        activeFirstLevel.value = item.path
        return
      }
    }
  },
  { immediate: true }
)

// 处理一级导航选择（鼠标悬停）
const handleFirstLevelSelect = (index) => {
  const item = navigation.value.find(nav => nav.path === index)
  
  if (!item) return

  // 如果是禁用项，不展开
  if (item.disabled) {
    return
  }

  // 如果有子项，展开 Mega Menu
  if (item.children && item.children.length > 0) {
    currentFirstLevel.value = item
    showMegaMenu.value = true
    
    // 清除之前的定时器
    if (megaMenuTimer) {
      clearTimeout(megaMenuTimer)
    }
  } else {
    // 没有子项，直接跳转
    closeMegaMenu()
    if (!item.placeholder) {
      router.push(item.path)
    }
  }
}

// 监听一级导航项的鼠标进入事件
const handleMouseEnter = (item) => {
  if (item.disabled) return
  
  if (item.children && item.children.length > 0) {
    currentFirstLevel.value = item
    showMegaMenu.value = true
    
    if (megaMenuTimer) {
      clearTimeout(megaMenuTimer)
    }
  }
}

// 监听一级导航项的点击事件
const handleFirstLevelClick = (item) => {
  if (item.disabled) return
  
  // 点击时直接跳转到该一级导航的path
  if (item.path && !item.placeholder) {
    router.push(item.path)
    closeMegaMenu()
  }
}

// 监听一级导航项的鼠标离开事件
const handleMouseLeave = () => {
  closeMegaMenu()
}

// 保持 Mega Menu 打开
const keepMegaMenuOpen = () => {
  if (megaMenuTimer) {
    clearTimeout(megaMenuTimer)
  }
}

// 关闭 Mega Menu（延迟）
const closeMegaMenu = () => {
  megaMenuTimer = setTimeout(() => {
    showMegaMenu.value = false
    currentFirstLevel.value = null
  }, 200)
}

// 处理二级项点击
const handleSecondLevelClick = (child) => {
  if (child.disabled || child.placeholder) {
    ElMessageBox.alert('功能即将上线，敬请期待！', '提示', {
      confirmButtonText: '知道了',
      type: 'info'
    })
    return
  }

  // 跳转路由
  router.push(child.path)
  
  // 关闭 Mega Menu
  showMegaMenu.value = false
  currentFirstLevel.value = null
}

// 处理大卡片点击（跳转到该列第一个链接）
const handleCardClick = (section) => {
  if (!section.links || section.links.length === 0) {
    return
  }

  // 获取第一个链接
  const firstLink = section.links[0]
  
  // 跳转路由
  router.push(firstLink.path)
  
  // 关闭 Mega Menu
  showMegaMenu.value = false
  currentFirstLevel.value = null
}

// 处理小链接点击
const handleLinkClick = (link) => {
  console.log('点击链接:', link)
  
  // 检查链接是否有效
  if (!link.path) {
    console.error('链接路径为空')
    return
  }
  
  // 跳转路由
  router.push(link.path)
  
  // 关闭 Mega Menu
  showMegaMenu.value = false
  currentFirstLevel.value = null
}

// 处理用户下拉菜单命令
const handleUserCommand = (command) => {
  if (command === 'logout') {
    userStore.logout()
    ElMessage.success('已退出登录')
    router.push('/login')
  } else if (command === 'profile') {
    router.push('/profile')
  } else if (command === 'upgrade') {
    ElMessageBox.alert('小匠智能体，升级会员按钮', '升级会员', {
      confirmButtonText: '知道了',
      type: 'info'
    })
  }
}
</script>

<style scoped>
.horizontal-layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* 顶部 Header */
.top-header {
  height: 64px;
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  padding: 0;
  position: fixed;
  top: 0;
  width: 100%;
  z-index: 1000;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
  max-width: 100%;
  margin: 0 auto;
  padding: 0 20px;
}

/* Logo */
.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-right: 32px;
  flex-shrink: 0;
  min-width: 160px;
}

.logo-img {
  width: 28px;
  height: 28px;
  flex-shrink: 0;
}

.logo-text {
  font-size: 15px;
  font-weight: 600;
  color: #303133;
  white-space: nowrap;
}

/* 一级导航 */
.nav-wrapper {
  flex: 1;
  display: flex;
  align-items: center;
  overflow: visible;
}

.main-nav {
  flex: 1;
  border-bottom: none;
  background: transparent;
  display: flex;
  align-items: center;
  gap: 4px;
}

.main-nav .el-menu-item {
  height: 64px;
  line-height: 64px;
  border-bottom: 2px solid transparent;
  display: flex;
  align-items: center;
  padding: 0 16px;
  font-size: 14px;
  white-space: nowrap;
  flex-shrink: 0;
  color: #606266;
  font-weight: 400;
}

.main-nav .el-menu-item:hover {
  background-color: #f5f7fa;
  border-bottom-color: #409EFF;
  color: #409EFF;
}

.main-nav .el-menu-item.is-active {
  border-bottom-color: #409EFF;
  color: #409EFF;
  font-weight: 500;
}

.main-nav .el-menu-item.is-disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* 用户区域 */
.user-area {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-left: auto;
  flex-shrink: 0;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  cursor: pointer;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.user-info:hover {
  background-color: #f5f7fa;
}

.username {
  font-size: 14px;
  color: #606266;
}

.arrow {
  font-size: 12px;
  color: #909399;
}

/* Mega Menu */
.mega-menu {
  position: absolute;
  top: 64px;
  left: 0;
  width: 100%;
  background: #fff;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  z-index: 999;
  padding: 24px;
  box-sizing: border-box;
  transition: all 0.2s;
}

.mega-menu-container {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 16px;
  width: 100%;
}

.mega-menu-content {
  max-width: 1600px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 20px;
  width: 100%;
}

/* 大卡片区域 */
.mega-menu-section {
  display: flex;
  flex-direction: column;
  gap: 12px;
  min-width: 0;
}

.mega-card {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 14px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 10px;
  color: #fff;
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
  width: 100%;
  min-width: 0;
  box-sizing: border-box;
}

.mega-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(102, 126, 234, 0.3);
}

.card-icon {
  flex-shrink: 0;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 8px;
}

.card-content {
  flex: 1;
  min-width: 0;
}

.card-title {
  font-size: 15px;
  font-weight: 600;
  margin: 0 0 2px 0;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.card-desc {
  font-size: 12px;
  margin: 0;
  color: rgba(255, 255, 255, 0.9);
  line-height: 1.3;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.card-arrow {
  flex-shrink: 0;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: rgba(255, 255, 255, 0.8);
  transition: all 0.3s;
}

.mega-card:hover .card-arrow {
  color: #fff;
  transform: translateX(4px);
}

/* 小链接列表 */
.mega-links {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.mega-link-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 10px;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  background: #fff;
  min-width: 0;
}

.mega-link-item:hover {
  background: #f5f7fa;
}

.mega-link-item.blank-slot {
  height: 28px;
  cursor: default;
  background: transparent;
}

.mega-link-item.blank-slot:hover {
  background: transparent;
}

.link-name {
  font-size: 13px;
  color: #666;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Mega Menu 动画 */
.mega-menu-enter-active,
.mega-menu-leave-active {
  transition: opacity 0.25s ease;
}

.mega-menu-enter-from,
.mega-menu-leave-to {
  opacity: 0;
}

/* 主内容区 */
.main-content {
  flex: 1;
  background-color: #f0f2f5;
  padding: 20px;
  margin-top: 64px;
  min-height: calc(100vh - 64px);
}

/* 响应式优化：1440px 屏幕 */
@media (max-width: 1440px) {
  .main-nav {
    gap: 2px;
  }

  .main-nav .el-menu-item {
    padding: 0 10px;
    font-size: 13px;
  }

  .logo {
    margin-right: 24px;
  }
}

/* 响应式优化：1280px 屏幕 */
@media (max-width: 1280px) {
  .header-content {
    padding: 0 16px;
  }

  .main-nav {
    gap: 0;
  }

  .main-nav .el-menu-item {
    padding: 0 8px;
    font-size: 13px;
  }

  .logo {
    margin-right: 20px;
    min-width: 140px;
  }

  .logo-img {
    width: 24px;
    height: 24px;
  }

  .logo-text {
    font-size: 14px;
  }
}

/* 响应式：宽度 < 768px 时折叠为抽屉导航 */
@media (max-width: 768px) {
  .top-header {
    padding: 0;
  }

  .header-content {
    padding: 0 20px;
  }

  .logo-text {
    display: none;
  }

  .nav-wrapper {
    display: none;
  }

  .user-area {
    margin-left: auto;
  }

  .mega-menu {
    padding: 20px;
  }

  .mega-menu-content {
    grid-template-columns: repeat(2, 1fr);
  }
}

/* 小屏幕手机 */
@media (max-width: 480px) {
  .top-header {
    height: 56px;
  }

  .header-content {
    padding: 0 16px;
  }

  .logo-img {
    width: 24px;
    height: 24px;
  }

  .main-content {
    margin-top: 56px;
    padding: 16px;
  }

  .mega-menu {
    top: 56px;
    padding: 16px;
  }

  .mega-menu-content {
    grid-template-columns: 1fr;
  }

  .user-info {
    padding: 6px 12px;
  }

  .username {
    font-size: 12px;
  }
}

/* 侧边栏布局 */
.main-content {
  display: flex;
  padding: 0;
}

.left-sidebar {
  width: 200px;
  height: calc(100vh - 64px);
  position: fixed;
  left: 0;
  top: 64px;
  overflow-y: auto;
  background: #f0f2f5;
}

/* 隐藏左侧边栏滚动条 */
.left-sidebar::-webkit-scrollbar {
  display: none;
}

.left-sidebar {
  -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;  /* Firefox */
}

.content-wrapper {
  flex: 1;
  padding: 20px;
  background-color: #f0f2f5;
  min-height: calc(100vh - 64px);
}

.content-wrapper.with-sidebar {
  margin-left: 200px;
}
</style>
