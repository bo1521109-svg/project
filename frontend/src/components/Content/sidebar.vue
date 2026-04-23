<template>
  <div class="content-sidebar">
    <!-- 工作台按钮 -->
    <div class="workbench-btn" @click="handleWorkbenchClick">
      <el-icon class="workbench-icon"><Monitor /></el-icon>
      <span class="workbench-text">工作台</span>
    </div>

    <!-- 中间间隙 -->
    <div class="sidebar-gap"></div>

    <!-- 下方区域：导航菜单 + 底部图片 -->
    <div class="sidebar-bottom">
      <!-- 菜单包装器 - 可滚动区域 -->
      <div class="sidebar-menu-wrapper">
        <el-menu
          :default-active="activeMenu"
          class="sidebar-menu"
          :unique-opened="true"
          @select="handleMenuSelect"
        >
          <!-- 找创意 -->
          <el-sub-menu index="creative">
            <template #title>
              <el-icon><Lightning /></el-icon>
              <span>找创意</span>
            </template>
            <el-menu-item index="/content/creative/natural-flow">自然流/广告素材</el-menu-item>
            <el-menu-item index="/content/creative/viral-analysis">爆款视频分析</el-menu-item>
            <el-menu-item index="/content/creative/selling-point">视频卖点呈现</el-menu-item>
          </el-sub-menu>

          <!-- AI视频 -->
          <el-sub-menu index="ai-video">
            <template #title>
              <el-icon><VideoCamera /></el-icon>
              <span>AI视频</span>
            </template>
            <el-menu-item index="/content/ai-video/seedance">Seedance2.0/Sora2</el-menu-item>
            <el-menu-item index="/content/ai-video/auto-clip">自动生成样片</el-menu-item>
            <el-menu-item index="/content/ai-video/clone">一键克隆视频</el-menu-item>
          </el-sub-menu>

          <!-- 去生图 -->
          <el-sub-menu index="image-gen">
            <template #title>
              <el-icon><Picture /></el-icon>
              <span>去生图</span>
            </template>
            <el-menu-item index="/content/image-gen/product-main">妙做商品主图</el-menu-item>
            <el-menu-item index="/content/image-gen/model-swap">一键模特换衣</el-menu-item>
            <el-menu-item index="/content/image-gen/model-hold">AI模特手持图</el-menu-item>
          </el-sub-menu>

          <!-- 资料库 -->
          <el-sub-menu index="assets">
            <template #title>
              <el-icon><FolderOpened /></el-icon>
              <span>资料库</span>
            </template>
            <el-menu-item index="/content/assets/my-product">我的产品</el-menu-item>
            <el-menu-item index="/content/assets/my-model">我的模特</el-menu-item>
            <el-menu-item index="/content/assets/my-material">我的素材</el-menu-item>
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

      <!-- 底部图片 - 固定在底部 -->
      <div class="sidebar-image">
        <img src="/img_8448.jpg" alt="底部图片" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import {
  Monitor,
  Lightning,
  VideoCamera,
  Picture,
  FolderOpened,
  Star
} from '@element-plus/icons-vue'

const router = useRouter()
const activeMenu = ref('')

// 处理工作台点击
const handleWorkbenchClick = () => {
  router.push('/content/workbench')
  console.log('跳转到内容创作工作台')
}

// 处理菜单选择
const handleMenuSelect = (index) => {
  activeMenu.value = index
  router.push(index)
}
</script>

<style scoped>
.content-sidebar {
  width: 100%;
  height: 100%;
  padding: 10px;
  display: flex;
  flex-direction: column;
  background: #f0f2f5;
  box-sizing: border-box;
}

/* 工作台按钮 */
.workbench-btn {
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
  flex-shrink: 0;
}

.workbench-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
  background: linear-gradient(135deg, #7b8ff0 0%, #8a5bb0 100%);
}

.workbench-icon {
  font-size: 16px;
  color: #ffffff;
}

.workbench-text {
  font-size: 13px;
  color: #ffffff;
  font-weight: 600;
}

/* 中间间隙 */
.sidebar-gap {
  height: 10px;
  flex-shrink: 0;
}

/* 下方区域 */
.sidebar-bottom {
  flex: 1;
  background: #ffffff;
  border-radius: 12px;
  padding: 6px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
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

/* 底部图片样式 - 固定在底部 */
.sidebar-image {
  margin-top: 10px;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  flex-shrink: 0;
}

.sidebar-image img {
  width: 100%;
  height: auto;
  display: block;
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
