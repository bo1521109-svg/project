<template>
  <div class="admin-sidebar">
    <div class="sidebar-content">
      <el-menu
        :default-active="activeMenu"
        class="sidebar-menu"
        :unique-opened="true"
        @select="handleMenuSelect"
      >
        <!-- 爬虫管理 -->
        <el-sub-menu index="crawler">
          <template #title>
            <el-icon><Connection /></el-icon>
            <span>爬虫管理</span>
          </template>
          <el-menu-item index="/admin/crawler/tasks">爬虫任务列表</el-menu-item>
          <el-menu-item index="/admin/crawler/logs">爬虫日志</el-menu-item>
          <el-menu-item index="/admin/crawler/config">爬虫配置</el-menu-item>
        </el-sub-menu>

        <!-- 用户管理 -->
        <el-sub-menu index="users">
          <template #title>
            <el-icon><User /></el-icon>
            <span>用户管理</span>
          </template>
          <el-menu-item index="/admin/users">用户列表</el-menu-item>
          <el-menu-item index="/admin/permissions">角色权限</el-menu-item>
          <el-menu-item index="/admin/login-logs">登录日志</el-menu-item>
        </el-sub-menu>
      </el-menu>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { Connection, User } from '@element-plus/icons-vue'

const router = useRouter()
const activeMenu = ref('/admin/crawler/tasks')

// 处理菜单选择
const handleMenuSelect = (index) => {
  activeMenu.value = index
  router.push(index)
}
</script>

<style scoped>
.admin-sidebar {
  width: 100%;
  height: 100%;
  padding: 10px;
  display: flex;
  flex-direction: column;
  background: #f0f2f5;
  box-sizing: border-box;
}

.sidebar-content {
  flex: 1;
  background: #ffffff;
  border-radius: 12px;
  padding: 6px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  box-sizing: border-box;
  overflow-y: auto;
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
}

.sidebar-menu .el-sub-menu :deep(.el-sub-menu__title) {
  border-radius: 6px;
  height: 32px;
  line-height: 32px;
  padding: 0 12px !important;
}

.sidebar-menu .el-menu-item:hover,
.sidebar-menu .el-sub-menu :deep(.el-sub-menu__title):hover {
  background-color: #f5f7fa;
}

.sidebar-menu .el-menu-item.is-active {
  background-color: #ecf5ff;
  color: #409EFF;
}
</style>
