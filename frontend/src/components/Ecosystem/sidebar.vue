<template>
  <div class="ecosystem-sidebar">
    <!-- 上方：出海工作台按钮 -->
    <div class="sidebar-top">
      <div class="workbench-btn" @click="handleClick('/overseas/explore')">
        <el-icon class="workbench-icon"><Monitor /></el-icon>
        <span class="workbench-text">出海工作台</span>
      </div>
    </div>

    <!-- 下方：导航菜单 -->
    <div class="sidebar-bottom">
      <div class="sidebar-menu-wrapper">
        <el-menu
          :default-active="activeMenu"
          class="sidebar-menu"
          @select="handleMenuSelect"
        >
          <!-- 1. 市场洞察 -->
          <el-sub-menu index="markets">
            <template #title>
              <el-icon><TrendCharts /></el-icon>
              <span>市场洞察</span>
            </template>
            <el-menu-item index="/overseas/markets/overview">市场总览</el-menu-item>
            <el-menu-item index="/overseas/markets/compare">市场对比</el-menu-item>
            <el-menu-item index="/overseas/markets/hot-ranking">品类热度榜</el-menu-item>
          </el-sub-menu>

          <!-- 2. 商机发现 -->
          <el-sub-menu index="opportunities">
            <template #title>
              <el-icon><Opportunity /></el-icon>
              <span>商机发现</span>
            </template>
            <el-menu-item index="/overseas/opportunities/product-radar">爆品雷达</el-menu-item>
            <el-menu-item index="/overseas/opportunities/blue-ocean">蓝海品类</el-menu-item>
            <el-menu-item index="/overseas/opportunities/cross-platform">跨平台对比</el-menu-item>
          </el-sub-menu>

          <!-- 3. 趋势追踪 -->
          <el-menu-item index="/overseas/trends">
            <el-icon><MagicStick /></el-icon>
            <span>趋势追踪</span>
          </el-menu-item> 

          <!-- 分隔线 -->
          <div class="menu-divider"></div>

          <!-- 4. 生态服务 -->
          <el-menu-item index="/overseas/ecosystem">
            <el-icon><Connection /></el-icon>
            <span>生态服务</span>
          </el-menu-item>

          <!-- 5. 出海智库 -->
          <el-menu-item index="/ecosystem/knowledge-base">
            <el-icon><Reading /></el-icon>
            <span>出海智库</span>
          </el-menu-item>
        </el-menu>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  Monitor, TrendCharts, Opportunity,
  MagicStick, Connection, Reading
} from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()

/**
 * 根据当前路由自动高亮对应菜单项
 * 支持多级路径匹配（如 /overseas/markets/compare 匹配到 /overseas/markets/overview 同级）
 */
const activeMenu = computed(() => {
  const path = route.path
  // 精确匹配
  if (path.startsWith('/overseas/markets')) return '/overseas/markets/overview'
  if (path.startsWith('/overseas/opportunities')) return '/overseas/opportunities/product-radar'
  if (path.startsWith('/ecosystem')) return path
  return path
})

function handleMenuSelect(index) {
  router.push(index)
}

function handleClick(path) {
  router.push(path)
}
</script>

<style scoped>
.ecosystem-sidebar {
  width: 208px;
  height: 100%;
  display: flex;
  flex-direction: column;
  background: #fff;
  border-right: 1px solid #e8ecf1;
  overflow: hidden;
}

/* ====== 上方：工作台按钮 ====== */
.sidebar-top {
  padding: 16px;
  border-bottom: 1px solid #f0f0f0;
}
.workbench-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  height: 42px;
  background: linear-gradient(135deg, #409eff, #5372ff);
  border-radius: 10px;
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.25s;
  box-shadow: 0 4px 12px rgba(64,158,255,.2);
}
.workbench-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 18px rgba(64,158,255,.3);
}
.workbench-icon { font-size: 18px; }
.workbench-text { letter-spacing: 0.5px; }

/* ====== 下方：菜单 ====== */
.sidebar-bottom {
  flex: 1;
  overflow-y: auto;
  padding: 8px;
}
.sidebar-bottom::-webkit-scrollbar { width: 4px; }
.sidebar-bottom::-webkit-scrollbar-thumb { background: #e0e0e0; border-radius: 4px; }

.sidebar-menu {
  border-right: none !important;
  background: transparent;
}

.sidebar-menu .el-menu-item,
.sidebar-menu :deep(.el-sub-menu__title) {
  height: 40px;
  line-height: 40px;
  margin-bottom: 2px;
  border-radius: 8px;
  padding: 0 12px !important;
  font-size: 14px;
  transition: all 0.2s;
}

.sidebar-menu .el-menu-item:hover,
.sidebar-menu :deep(.el-sub-menu__title):hover {
  background-color: #f5f7fa !important;
  color: #409eff !important;
}

.sidebar-menu .el-menu-item.is-active {
  background: linear-gradient(135deg, #ecf5ff, #e8f4fd) !important;
  color: #409eff !important;
  font-weight: 600;
}

/* 子菜单内边距 */
.sidebar-menu :deep(.el-menu .el-menu-item) {
  padding-left: 48px !important;
  height: 36px;
  line-height: 36px;
  font-size: 13px;
}

/* 分隔线 */
.menu-divider {
  height: 1px;
  background: #f0f0f0;
  margin: 8px 12px;
}
</style>
