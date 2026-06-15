<template>
  <div class="social-sidebar">
    <!-- 上方区域：工作台按钮 -->
    <div class="sidebar-top">
      <div class="workbench-btn" @click="handleWorkbenchClick">
        <el-icon class="workbench-icon"><Monitor /></el-icon>
        <span class="workbench-text">工作台</span>
      </div>
    </div>

    <!-- 下方区域：导航菜单 -->
    <div class="sidebar-bottom">
      <div class="sidebar-menu-wrapper">
        <el-menu
          :default-active="activeMenu"
          class="sidebar-menu"
          :unique-opened="true"
          @select="handleMenuSelect"
        >
          <!-- 社媒平台 -->
          <el-sub-menu index="platforms">
            <template #title>
              <el-icon><Connection /></el-icon>
              <span>社媒平台</span>
            </template>
            <el-menu-item index="/social/platforms/tiktok">TikTok</el-menu-item>
            <el-menu-item index="/social/platforms/facebook">Facebook</el-menu-item>
            <el-menu-item index="/social/platforms/instagram">Instagram</el-menu-item>
            <el-menu-item index="/social/platforms/twitter">Twitter/X</el-menu-item>
            <el-menu-item index="/social/platforms/youtube">YouTube</el-menu-item>
            <el-menu-item index="/social/platforms/pinterest">Pinterest</el-menu-item>
            <el-menu-item index="/social/platforms/reddit">Reddit</el-menu-item>
          </el-sub-menu>

          <!-- 私域 -->
          <el-sub-menu index="private">
            <template #title>
              <el-icon><Lock /></el-icon>
              <span>私域</span>
            </template>
            <el-menu-item index="/social/private/whatsapp">What's App</el-menu-item>
            <el-menu-item index="/social/private/line">Line</el-menu-item>
          </el-sub-menu>

          <!-- 数据看板 -->
          <el-sub-menu index="dashboard">
            <template #title>
              <el-icon><TrendCharts /></el-icon>
              <span>数据看板</span>
            </template>
            <el-menu-item index="/social/dashboard/overview">总览数据视频</el-menu-item>
          </el-sub-menu>

          <!-- 发布管理 -->
          <el-sub-menu index="publish">
            <template #title>
              <el-icon><Upload /></el-icon>
              <span>发布管理</span>
            </template>
            <el-menu-item index="/social/publish/manage">管理发布视频</el-menu-item>
          </el-sub-menu>

          <!-- 互动管理 -->
          <el-sub-menu index="interaction">
            <template #title>
              <el-icon><ChatDotRound /></el-icon>
              <span>互动管理</span>
            </template>
            <el-menu-item index="/social/interaction/comments">管理评论互动</el-menu-item>
            <el-menu-item index="/social/interaction/direct-messages">管理私信互动</el-menu-item>
          </el-sub-menu>

          <!-- 账号管理 -->
          <el-sub-menu index="accounts">
            <template #title>
              <el-icon><User /></el-icon>
              <span>账号管理</span>
            </template>
            <el-menu-item index="/social/accounts/manage">管理社媒账号</el-menu-item>
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
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import {
  Monitor,
  Connection,
  Lock,
  TrendCharts,
  Upload,
  ChatDotRound,
  User,
  Star
} from '@element-plus/icons-vue'

const router = useRouter()
const activeMenu = ref('')

// 处理工作台点击
const handleWorkbenchClick = () => {
  router.push('/social/workbench')
  console.log('跳转到社媒管理工作台')
}

// 处理菜单选择
const handleMenuSelect = (index) => {
  activeMenu.value = index
  router.push(index)
}
</script>

<style scoped>
.social-sidebar {
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
  padding: 8px 10px;
  border-bottom: 1px solid #e4e7ed;
  flex-shrink: 0;
}

/* 工作台按钮 */
.workbench-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 8px 12px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.3s;
  gap: 6px;
  box-sizing: border-box;
}

.workbench-btn:hover {
  background: linear-gradient(135deg, #7b8ff0 0%, #8a5bb0 100%);
}

.workbench-icon {
  font-size: 15px;
  color: #ffffff;
}

.workbench-text {
  font-size: 13px;
  color: #ffffff;
  font-weight: 600;
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

/* 菜单样式 */
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
  min-height: 32px;
  height: 32px;
  line-height: 32px;
  font-size: 12px;
}

.sidebar-menu .el-sub-menu .el-menu-item:hover {
  background-color: #f5f7fa;
  color: #8b5cf6;
}

</style>

<style>
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
