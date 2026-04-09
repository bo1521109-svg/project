<template>
  <el-container class="main-container">
    <!-- 侧边栏导航 -->
    <el-aside width="200px" class="sidebar">
      <div class="logo">
        <h2>数据平台</h2>
      </div>
      <el-menu
        :default-active="activeMenu"
        class="el-menu-vertical"
        router
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409EFF"
      >
        <el-menu-item index="/stores">
          <el-icon><Shop /></el-icon>
          <span>店铺管理</span>
        </el-menu-item>
        <el-menu-item index="/products">
          <el-icon><Goods /></el-icon>
          <span>商品列表</span>
        </el-menu-item>
        <el-menu-item index="/profile">
          <el-icon><User /></el-icon>
          <span>个人中心</span>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <!-- 主内容区 -->
    <el-container>
      <!-- 顶部导航栏 -->
      <el-header class="header">
        <div class="header-content">
          <span class="title">跨境电商独立站数据平台</span>
          <div class="user-info">
            <el-dropdown @command="handleCommand">
              <span class="user-name">
                {{ userStore.userInfo?.username || '用户' }}
                <el-icon class="el-icon--right"><arrow-down /></el-icon>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                  <el-dropdown-item command="logout">退出登录</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </div>
      </el-header>

      <!-- 内容区域 -->
      <el-main class="main-content">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Shop, Goods, User, ArrowDown } from '@element-plus/icons-vue'
import { useUserStore } from '../stores/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

// 当前激活的菜单项
const activeMenu = computed(() => route.path)

// 处理下拉菜单命令
const handleCommand = (command) => {
  if (command === 'logout') {
    // 退出登录
    userStore.logout()
    ElMessage.success('已退出登录')
    router.push('/login')
  } else if (command === 'profile') {
    // 跳转到个人中心
    router.push('/profile')
  }
}
</script>

<style scoped>
.main-container {
  height: 100vh;
}

.sidebar {
  background-color: #304156;
  overflow-x: hidden;
}

.logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #2b3a4b;
}

.logo h2 {
  color: #fff;
  font-size: 20px;
  margin: 0;
}

.el-menu-vertical {
  border-right: none;
}

.header {
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  padding: 0 20px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
}

.title {
  font-size: 18px;
  font-weight: 500;
  color: #303133;
}

.user-info {
  color: #606266;
}

.user-name {
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
}

.user-name:hover {
  color: #409EFF;
}

.main-content {
  background-color: #f0f2f5;
  padding: 20px;
}

/* 响应式：手机端导航可折叠 */
@media (max-width: 768px) {
  .sidebar {
    width: 64px !important;
  }
  
  .logo h2 {
    display: none;
  }
  
  .el-menu-item span {
    display: none;
  }
}
</style>
