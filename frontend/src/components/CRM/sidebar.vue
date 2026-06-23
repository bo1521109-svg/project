<template>
  <div class="crm-sidebar">
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
          <el-menu-item index="/crm/overview">
            <el-icon><DataAnalysis /></el-icon>
            <span>客资概览</span>
          </el-menu-item>

          <el-menu-item index="/crm/customers">
            <el-icon><UserFilled /></el-icon>
            <span>客户管理</span>
          </el-menu-item>

          <el-menu-item index="/crm/follow-ups">
            <el-icon><Clock /></el-icon>
            <span>跟进记录</span>
          </el-menu-item>

          <el-menu-item index="/crm/analytics">
            <el-icon><TrendCharts /></el-icon>
            <span>客资分析</span>
          </el-menu-item>

          <el-menu-item index="/crm/tags">
            <el-icon><PriceTag /></el-icon>
            <span>标签管理</span>
          </el-menu-item>
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
  DataAnalysis,
  UserFilled,
  Clock,
  TrendCharts,
  PriceTag
} from '@element-plus/icons-vue'

const router = useRouter()
const activeMenu = ref('')

const handleWorkbenchClick = () => {
  router.push('/crm/overview')
}

const handleMenuSelect = (index) => {
  activeMenu.value = index
  router.push(index)
}
</script>

<style scoped>
.crm-sidebar {
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

/* 菜单包装器 */
.sidebar-menu-wrapper {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  padding-bottom: 6px;
}

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

.sidebar-menu .el-menu-item {
  border-radius: 6px;
  height: 32px;
  line-height: 32px;
  margin-bottom: 4px;
  padding: 0 12px !important;
  display: flex !important;
  align-items: center;
  justify-content: flex-start !important;
  font-size: 13px;
  color: #303133;
}

.sidebar-menu .el-menu-item:hover {
  background-color: #f5f7fa;
  color: #8b5cf6;
}

.sidebar-menu .el-menu-item.is-active {
  background-color: #ecf5ff;
  color: #409EFF;
}

.sidebar-menu .el-menu-item .el-icon {
  margin-right: 6px;
  font-size: 16px;
}
</style>

<style>
.sidebar-menu .el-menu-item {
  text-align: left !important;
  justify-content: flex-start !important;
}
</style>
