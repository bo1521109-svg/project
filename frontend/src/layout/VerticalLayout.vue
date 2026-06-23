<template>
  <div class="vertical-layout">
    <!-- 左侧一级导航 -->
    <aside class="primary-nav">
      <div class="nav-header">
        <div class="logo">
          <el-icon :size="20"><TrendCharts /></el-icon>
        </div>
      </div>
      
      <nav class="nav-items">
        <div
          v-for="item in primaryNav"
          :key="item.key"
          class="nav-item"
          :class="{ active: activeNav === item.key }"
          @click="handleNavClick(item)"
        >
          <el-icon :size="18">
            <component :is="item.icon" />
          </el-icon>
          <span class="nav-text">{{ item.name }}</span>
          
          <!-- 选品的下拉指示器 -->
          <el-icon v-if="item.hasDropdown" :size="10" class="dropdown-icon">
            <ArrowDown />
          </el-icon>
        </div>
        
        <!-- 福利按钮 - 仅普通用户显示，放在出海下面 -->
        <div 
          v-if="userStore.role !== 'admin'"
          class="nav-item qr-trigger" 
          @mouseenter="showQrCode = true" 
          @mouseleave="showQrCode = false"
        >
          <el-icon :size="18">
            <GiftIcon />
          </el-icon>
          <span class="nav-text">福利</span>
          
          <!-- 二维码弹出层 -->
          <transition name="qr-fade">
            <div v-if="showQrCode" class="qr-popup">
              <div class="qr-popup-content">
                <div class="qr-popup-header">
                  <el-icon class="gift-icon-large">
                    <GiftIcon />
                  </el-icon>
                  <span class="qr-title">免费领会员</span>
                </div>
                <div class="qr-image-wrapper">
                  <img src="/img_8448.jpg" alt="扫码添加专属顾问" class="qr-image" />
                </div>
                <div class="qr-popup-footer">
                  扫码添加专属顾问
                </div>
              </div>
            </div>
          </transition>
        </div>
      </nav>
      
      <div class="nav-footer">
        <div class="nav-item" @click="handleLogout">
          <el-icon :size="18"><SwitchButton /></el-icon>
          <span class="nav-text">退出</span>
        </div>
      </div>
    </aside>

    <!-- 右侧二级导航 + 内容区 -->
    <div class="content-wrapper">
      <!-- 二级导航 -->
      <aside class="secondary-nav">
        <!-- 动态加载的二级导航内容 -->
        <div class="secondary-nav-content">
          <component
            :is="currentSecondaryNav"
            v-if="currentSecondaryNav"
          />
        </div>
      </aside>

      <!-- 主内容区 -->
      <main class="main-content">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import {
  TrendCharts,
  Search,
  Edit,
  ChatDotRound,
  Monitor,
  User,
  Star,
  Setting,
  SwitchButton,
  ArrowDown
} from '@element-plus/icons-vue'

// 导入各个平台的侧边栏组件
import TikTokSidebar from '@/components/TikTok/sidebar.vue'
import ShopifySidebar from '@/components/Shopify/sidebar.vue'
import ContentSidebar from '@/components/Content/sidebar.vue'
import SocialSidebar from '@/components/Social/sidebar.vue'
import AdminSidebar from '@/components/Admin/sidebar.vue'
import WebsiteSidebar from '@/components/Website/sidebar.vue'
import EcosystemSidebar from '@/components/Ecosystem/sidebar.vue'
import GiftIcon from '@/components/icons/GiftIcon.vue'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

// 当前激活的一级导航
const activeNav = ref('selection')

// 选品模块选择的平台
const selectedPlatform = ref('tiktok')

// 控制二维码显示
const showQrCode = ref(false)

// 一级导航配置
const primaryNav = computed(() => {
  const nav = [
    { key: 'selection', name: '选品', icon: 'Search', hasDropdown: true },
    { key: 'content', name: '创作', icon: 'Edit' },
    { key: 'social', name: '社媒', icon: 'ChatDotRound' },
    { key: 'website', name: '建站', icon: 'Monitor' },
    { key: 'crm', name: '客资', icon: 'User', disabled: true },
    { key: 'ecosystem', name: '出海', icon: 'Star' }
  ]
  
  // 管理员添加平台管理
  if (userStore.role === 'admin') {
    nav.push({ key: 'admin', name: '平台', icon: 'Setting' })
  }
  
  return nav
})

// 当前显示的二级导航组件
const currentSecondaryNav = computed(() => {
  if (activeNav.value === 'selection') {
    return selectedPlatform.value === 'tiktok' ? TikTokSidebar : ShopifySidebar
  }
  
  const navMap = {
    content: ContentSidebar,
    social: SocialSidebar,
    website: WebsiteSidebar,
    ecosystem: EcosystemSidebar,
    admin: AdminSidebar
  }
  
  return navMap[activeNav.value] || null
})

// 处理一级导航点击
const handleNavClick = (item) => {
  if (item.disabled) {
    return
  }
  
  activeNav.value = item.key
  
  // 根据不同模块跳转到默认页面
  const defaultRoutes = {
    selection: selectedPlatform.value === 'tiktok' ? '/tiktok/category/overview' : '/shopify/stores/search',
    content: '/content/workbench',
    social: '/social/workbench',
    website: '/website',
    ecosystem: '/ecosystem',
    admin: '/admin/users'
  }
  
  if (defaultRoutes[item.key]) {
    router.push(defaultRoutes[item.key])
  }
}

// 处理平台切换
const handlePlatformChange = (platform) => {
  const defaultRoutes = {
    tiktok: '/tiktok/category/overview',
    shopify: '/shopify/stores/search'
  }
  
  router.push(defaultRoutes[platform])
}

// 退出登录
const handleLogout = () => {
  userStore.logout()
  router.push('/login')
}

// 根据当前路由自动设置激活的导航
watch(() => route.path, (newPath) => {
  if (newPath.startsWith('/tiktok') || newPath.startsWith('/shopify')) {
    activeNav.value = 'selection'
    selectedPlatform.value = newPath.startsWith('/tiktok') ? 'tiktok' : 'shopify'
  } else if (newPath.startsWith('/content')) {
    activeNav.value = 'content'
  } else if (newPath.startsWith('/social')) {
    activeNav.value = 'social'
  } else if (newPath.startsWith('/ecosystem')) {
    activeNav.value = 'ecosystem'
  } else if (newPath.startsWith('/admin')) {
    activeNav.value = 'admin'
  } else if (newPath.startsWith('/website')) {
    activeNav.value = 'website'
  }
}, { immediate: true })
</script>

<style scoped>
.vertical-layout {
  display: flex;
  height: 100vh;
  overflow: hidden;
}

/* 左侧一级导航 */
.primary-nav {
  width: 64px;
  background: #ffffff;
  display: flex;
  flex-direction: column;
  border-right: 1px solid #e4e7ed;
}

.primary-nav .nav-header {
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid #e4e7ed;
}

.primary-nav .nav-header .logo {
  color: #409eff;
}

.primary-nav .nav-items {
  flex: 1;
  padding: 12px 0;
  overflow-y: auto;
}

.primary-nav .nav-items::-webkit-scrollbar {
  width: 3px;
}

.primary-nav .nav-items::-webkit-scrollbar-thumb {
  background: #dcdfe6;
  border-radius: 2px;
}

.primary-nav .nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 8px 4px;
  margin: 3px 6px;
  cursor: pointer;
  border-radius: 6px;
  color: #606266;
  transition: all 0.3s;
  position: relative;
}

.primary-nav .nav-item:hover {
  background: #f5f7fa;
  color: #409eff;
}

.primary-nav .nav-item.active {
  background: #409eff;
  color: #fff;
}

.primary-nav .nav-item[disabled] {
  opacity: 0.4;
  cursor: not-allowed;
}

.primary-nav .nav-item .nav-text {
  font-size: 11px;
  margin-top: 3px;
  text-align: center;
}

.primary-nav .nav-item .dropdown-icon {
  position: absolute;
  top: 6px;
  right: 6px;
}

.primary-nav .nav-footer {
  padding: 8px 0;
  border-top: 1px solid #e4e7ed;
}

/* 二维码触发按钮 */
.primary-nav .qr-trigger {
  position: relative;
}

.primary-nav .qr-trigger:hover {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
}

/* 二维码弹出层 */
.qr-popup {
  position: fixed;
  left: 70px;
  bottom: auto;
  top: 50%;
  transform: translateY(-50%);
  z-index: 9999;
  pointer-events: none;
}

.qr-popup-content {
  background: linear-gradient(135deg, #e8eaf6 0%, #f3e5f5 100%);
  border-radius: 12px;
  padding: 16px;
  box-shadow: 0 8px 32px rgba(102, 126, 234, 0.3);
  min-width: 200px;
  max-width: 220px;
  pointer-events: auto;
}

.qr-popup-header {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  margin-bottom: 12px;
}

.qr-popup-header .gift-icon-large {
  font-size: 20px;
  color: #667eea;
}

.qr-popup-header .qr-title {
  font-size: 15px;
  font-weight: 600;
  color: #667eea;
}

.qr-image-wrapper {
  background: white;
  border-radius: 8px;
  padding: 8px;
  margin-bottom: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.qr-image {
  width: 100%;
  height: auto;
  display: block;
  border-radius: 6px;
}

.qr-popup-footer {
  text-align: center;
  font-size: 12px;
  color: #666;
  font-weight: 500;
}

/* 二维码弹出动画 */
.qr-fade-enter-active,
.qr-fade-leave-active {
  transition: all 0.3s ease;
}

.qr-fade-enter-from {
  opacity: 0;
  transform: translateX(-10px);
}

.qr-fade-leave-to {
  opacity: 0;
  transform: translateX(-10px);
}

/* 右侧内容区域 */
.content-wrapper {
  flex: 1;
  display: flex;
  overflow: hidden;
}

/* 二级导航 */
.secondary-nav {
  width: 240px;
  background: #ffffff;
  border-right: 1px solid #e4e7ed;
  display: flex;
  flex-direction: column;
  position: relative;
  margin-left: -1px;
}

.secondary-nav .secondary-nav-content {
  flex: 1;
  overflow-y: auto;
}

.secondary-nav .secondary-nav-content::-webkit-scrollbar {
  width: 6px;
}

.secondary-nav .secondary-nav-content::-webkit-scrollbar-thumb {
  background: #dcdfe6;
  border-radius: 3px;
}

/* 主内容区 */
.main-content {
  flex: 1;
  height: 100vh;
  overflow-y: auto;
  overflow-x: hidden;
  background: #f5f7fa;
  padding: 20px;
  margin: 0;
  box-sizing: border-box;
}

.main-content::-webkit-scrollbar {
  width: 8px;
}

.main-content::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

.main-content::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 4px;
}

.main-content::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}
</style>
