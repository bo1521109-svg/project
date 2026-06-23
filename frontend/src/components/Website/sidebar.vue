<template>
  <div class="website-sidebar">
    <!-- 顶部标题 -->
    <div class="sidebar-header">
      <div class="header-icon">
        <el-icon :size="20"><Monitor /></el-icon>
      </div>
      <span class="header-title">建站精灵</span>
    </div>

    <!-- 菜单 -->
    <div class="sidebar-nav">
      <router-link
        v-for="item in menuItems"
        :key="item.path"
        :to="item.path"
        class="nav-item"
        :class="{ active: isActive(item.path) }"
      >
        <el-icon :size="17"><component :is="item.icon" /></el-icon>
        <span>{{ item.label }}</span>
        <span v-if="item.badge" class="badge">{{ item.badge }}</span>
      </router-link>
    </div>
  </div>
</template>

<script setup>
import { markRaw } from 'vue'
import { useRoute } from 'vue-router'
import { Monitor, Plus, FolderOpened, Link } from '@element-plus/icons-vue'

const route = useRoute()

const menuItems = [
  { path: '/website/my-sites', label: '我的网站', icon: markRaw(Monitor) },
  { path: '/website/create', label: '创建站点', icon: markRaw(Plus) },
  { path: '/website/templates', label: '模板库', icon: markRaw(FolderOpened) },
  { path: '/website/domains', label: '域名管理', icon: markRaw(Link) }
]

function isActive(path) {
  if (path === '/website/templates') return route.path === '/website/templates'
  if (path === '/website/create') return route.path === '/website/create'
  if (path === '/website/domains') return route.path === '/website/domains'
  return route.path === '/website/my-sites' || route.path === '/website'
}
</script>

<style scoped>
.website-sidebar {
  width: 100%;
  height: 100%;
  background: #ffffff;
}

.sidebar-header {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 16px 16px 14px;
  border-bottom: 1px solid #ebeef5;
}

.header-icon {
  width: 36px; height: 36px;
  border-radius: 10px;
  background: linear-gradient(135deg, #409eff, #66b1ff);
  display: flex; align-items: center; justify-content: center;
  color: #fff;
}

.header-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

.sidebar-nav {
  padding: 10px 10px;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 14px;
  margin-bottom: 2px;
  border-radius: 8px;
  text-decoration: none;
  color: #606266;
  font-size: 14px;
  font-weight: 500;
  transition: all .2s;
}

.nav-item:hover {
  background-color: #f5f7fa;
  color: #303133;
}

.nav-item.active {
  background-color: #ecf5ff;
  color: #409eff;
}

.badge {
  margin-left: auto;
  font-size: 10px;
  font-weight: 700;
  padding: 2px 7px;
  border-radius: 6px;
  background: linear-gradient(135deg, #f56c6c, #ee5a24);
  color: #fff;
}
</style>
