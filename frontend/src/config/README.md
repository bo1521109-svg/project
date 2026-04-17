# 导航配置文件使用说明

## 文件说明

### `navigation.js`
全局导航配置文件，定义了系统的所有导航菜单结构。

## 功能特性

1. **一级导航**：包含 7 个主要模块
   - TikTok 数据
   - 独立站数据
   - 内容制作
   - 社媒管理
   - 建站精灵
   - 客资管家
   - 出海生态

2. **管理员专属**：`role === 'admin'` 时追加"平台管理"

3. **二级导航**：每个一级项对应一个二级数组

4. **占位标识**：未开发模块标记 `disabled: true` 和 `placeholder: true`

## 数据结构

```javascript
{
  name: '导航名称',
  path: '/路由路径',
  icon: '图标名称',
  disabled: true,        // 是否禁用（未开发）
  placeholder: true,     // 是否为占位符
  roles: ['admin'],      // 允许访问的角色（可选）
  children: [            // 子导航
    {
      name: '子导航名称',
      path: '/子路由路径',
      disabled: false
    }
  ]
}
```

## 使用方法

### 1. 在组件中导入

```javascript
import { getFilteredNav, getAccessiblePaths } from '@/config/navigation.js'
```

### 2. 获取过滤后的导航

```javascript
// 在组件中
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()
const userRole = userStore.userInfo?.role || 'user'

// 获取过滤后的导航（一级+二级结构）
const navigation = getFilteredNav(userRole)
```

### 3. 渲染导航菜单

```vue
<template>
  <el-menu>
    <!-- 一级导航 -->
    <el-sub-menu 
      v-for="item in navigation" 
      :key="item.path"
      :index="item.path"
      :disabled="item.disabled"
    >
      <template #title>
        <el-icon><component :is="item.icon" /></el-icon>
        <span>{{ item.name }}</span>
        <el-tag v-if="item.placeholder" size="small" type="info">未开发</el-tag>
      </template>
      
      <!-- 二级导航 -->
      <el-menu-item
        v-for="child in item.children"
        :key="child.path"
        :index="child.path"
        :disabled="child.disabled"
        @click="handleMenuClick(child)"
      >
        {{ child.name }}
        <el-tag v-if="child.placeholder" size="small" type="info">未开发</el-tag>
      </el-menu-item>
    </el-sub-menu>
  </el-menu>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { getFilteredNav } from '@/config/navigation.js'

const router = useRouter()
const userStore = useUserStore()

// 获取导航
const navigation = computed(() => {
  const userRole = userStore.userInfo?.role || 'user'
  return getFilteredNav(userRole)
})

// 处理菜单点击
const handleMenuClick = (item) => {
  if (item.disabled) {
    ElMessage.info('该功能正在开发中，敬请期待')
    return
  }
  router.push(item.path)
}
</script>
```

### 4. 路由守卫中使用

```javascript
import { getAccessiblePaths } from '@/config/navigation.js'

router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  const userRole = userStore.userInfo?.role || 'user'
  
  // 获取用户可访问的路径
  const accessiblePaths = getAccessiblePaths(userRole)
  
  // 检查用户是否有权限访问
  if (!accessiblePaths.includes(to.path)) {
    next('/403') // 无权限
  } else {
    next()
  }
})
```

## 当前状态

### 已开发模块
- ✅ 独立站商品 (`/products`)
- ✅ 独立站店铺 (`/stores`)

### 未开发模块（占位）
- ⏳ TikTok 数据（全部）
- ⏳ 内容制作（全部）
- ⏳ 社媒管理（全部）
- ⏳ 建站精灵（全部）
- ⏳ 客资管家（全部）
- ⏳ 出海生态（全部）
- ⏳ 平台管理（全部）
- ⏳ 广告库

## 添加新模块

### 1. 添加到已有一级导航下

在 `navigationConfig` 中找到对应的一级导航，在 `children` 数组中添加：

```javascript
{
  name: '新功能',
  path: '/shopify/new-feature',
  disabled: false  // 已开发
}
```

### 2. 添加新的一级导航

在 `navigationConfig` 数组中添加：

```javascript
{
  name: '新模块',
  path: '/new-module',
  icon: 'Star',
  children: [
    {
      name: '子功能1',
      path: '/new-module/feature1',
      disabled: false
    }
  ]
}
```

### 3. 添加管理员专属功能

在 `adminNavigation.children` 中添加，或者在任意导航项中添加 `roles: ['admin']`：

```javascript
{
  name: '管理功能',
  path: '/admin/manage',
  roles: ['admin'],  // 仅管理员可见
  disabled: false
}
```

## 注意事项

1. **纯数据配置**：不写 UI 代码，只配置数据结构
2. **占位标识**：未开发模块必须标记 `disabled: true` 和 `placeholder: true`
3. **角色过滤**：通过 `getFilteredNav(userRole)` 自动过滤
4. **路径一致性**：确保 `path` 与路由配置一致
5. **图标名称**：使用 Element Plus 图标名称（如 `VideoPlay`, `ShoppingCart`）

## 测试

运行测试文件验证配置：

```bash
node src/config/navigation.test.js
```

## 输出示例

```javascript
// 普通用户
getFilteredNav('user')
// 返回 7 个一级导航（不含"平台管理"）

// 管理员
getFilteredNav('admin')
// 返回 8 个一级导航（含"平台管理"）

// 可访问路径
getAccessiblePaths('user')
// 返回 ['/products', '/stores']（仅已开发的路径）
```
