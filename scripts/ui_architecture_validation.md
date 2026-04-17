# HorizontalLayout.vue 架构验证清单

## 一、核心优化（严格按照图片要求）

### ✅ 1. 严格的 DOM 结构与 Flex 布局规范

#### Header 容器
```css
.top-header {
  height: 64px;
  position: fixed;
  top: 0;
  width: 100%;
  z-index: 1000;
  padding: 0 40px;
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}
```

#### Header 内容区（三段式布局）
```css
.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
  max-width: 1400px;
  margin: 0 auto;
}
```

**布局结构：**
- 左侧区：Logo + 一级导航栏（`flex: 1`）
- 右侧区：用户区域（`flex-shrink: 0`）

#### Logo 区域
```css
.logo {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-right: 40px;
  flex-shrink: 0;
}
```

#### 右侧区域（严格按照顺序）
```css
.user-area {
  flex-shrink: 0;
}
```

**顺序：**
1. AI 时序按钮（可选）
2. 升级会员按钮
3. 用户头像下拉菜单

---

### ✅ 2. 二级导航（Mega Menu 父层）

#### 触发机制
- 监听一级导航项的 `@mouseenter` 和 `@mouseleave` 事件
- 悬停时展开 Mega Menu，离开时延迟 200ms 关闭

#### 面板样式
```css
.mega-menu {
  position: absolute;
  top: 64px;
  left: 0;
  width: 100%;
  background: #fff;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  z-index: 999;
  padding: 24px 40px;
  transition: all 0.2s;
}
```

#### 内容布局（Grid 4列）
```css
.mega-menu-content {
  max-width: 1400px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
}
```

---

### ✅ 3. 产品级/文字级别样式规范

#### 一级导航样式
```css
.main-nav .el-menu-item {
  height: 64px;
  line-height: 64px;
  border-bottom: 2px solid transparent;
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 0 12px;
  font-size: 14px;
}

.main-nav .el-menu-item:hover {
  background-color: #f5f7fa;
  border-bottom-color: #409EFF;
}

.main-nav .el-menu-item.is-active {
  border-bottom-color: #409EFF;
  color: #409EFF;
}
```

#### 二级导航卡片样式
```css
.mega-menu-item {
  padding: 16px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
  border: 1px solid #e4e7ed;
  background: #fff;
}

.mega-menu-item:hover {
  background-color: #f5f7fa;
  border-color: #409EFF;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.15);
}
```

#### 字体规范
- Logo 文字：`font-size: 16px; font-weight: 600;`
- 一级导航：`font-size: 14px;`
- 二级导航：`font-size: 14px; font-weight: 500;`
- 用户名：`font-size: 14px;`

---

### ✅ 4. 必要时显示"更多"菜单（溢出处理）

#### 逻辑
```javascript
// 可见的导航项（前 N 项）
const visibleNavItems = computed(() => {
  if (navigation.value.length <= 7) {
    return navigation.value
  }
  return navigation.value.slice(0, 6)
})

// 溢出的导航项（放入"更多"菜单）
const overflowNavItems = computed(() => {
  if (navigation.value.length <= 7) {
    return []
  }
  return navigation.value.slice(6)
})
```

#### 样式
```css
.more-dropdown {
  flex-shrink: 0;
  height: 64px;
  display: flex;
  align-items: center;
}

.more-trigger {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 8px 16px;
  cursor: pointer;
  border-radius: 4px;
  transition: background-color 0.3s;
  color: #606266;
  font-size: 14.px;
}
```

---

## 二、一级导航与路由式交互（保留所有原有功能）

### ✅ 1. 导航栏样式
- 白色背景 `#fff`
- 固定定位 `position: fixed; top: 0;`
- 阴影效果 `box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);`

### ✅ 2. 导航栏高度
- 桌面端：`64px`
- 移动端：`56px`

### ✅ 3. 悬停交互
- 鼠标悬停一级导航项时，展开二级 Mega Menu
- 鼠标离开时，延迟 200ms 关闭

### ✅ 4. 点击交互
- 点击已开发模块（如"独立站商品"），跳转到对应路由
- 点击未开发模块，弹出提示框"功能即将上线，敬请期待！"

---

## 三、二级导航：Mega Menu 悬浮父层

### ✅ 1. 触发机制
- 监听 `@mouseenter` 和 `@mouseleave` 事件
- 悬停时展开，离开时延迟关闭

### ✅ 2. 面板配置
```css
position: absolute;
top: 64px;
left: 0;
width: 100%;
background: #fff;
padding: 24px 40px;
box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
z-index: 999;
transition: all 0.2s;
```

### ✅ 3. 内容布局
- 使用 Grid 布局（4列）
- 每行 3 个卡片，每个卡片包含：
  - 功能名称（如"独立站商品"）
  - 未开发标签（如"未开发"）

### ✅ 4. 卡片交互
- 悬停时：背景色变浅，边框变蓝，显示阴影
- 点击时：跳转到对应路由或弹出提示框

---

## 四、右侧【工具栏】样式规范

### ✅ 1. AI 智能体（type="info" 实线）
```html
<el-button type="info">AI 智能体</el-button>
```

### ✅ 2. 升级会员（type="default" 白色边框）
```html
<el-button>升级会员</el-button>
```

### ✅ 3. 用户信息（头像 + 文字 + 图标 + el-dropdown）
```html
<el-dropdown @command="handleUserCommand" trigger="click">
  <div class="user-info">
    <el-icon><User /></el-icon>
    <span class="username">{{ userStore.userInfo?.username || '用户' }}</span>
    <el-icon class="arrow"><ArrowDown /></el-icon>
  </div>
  <template #dropdown>
    <el-dropdown-menu>
      <el-dropdown-item command="profile">个人中心</el-dropdown-item>
      <el-dropdown-item command="upgrade">升级会员</el-dropdown-item>
      <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
    </el-dropdown-menu>
  </template>
</el-dropdown>
```

---

## 五、路由与权限控制输入

### ✅ 1. 将页面 `/stores`（店铺管理）和 `/products`（商品列表）路由
- 已配置在 `router/index.js` 中
- 使用 HorizontalLayout 作为父组件

### ✅ 2. 非登录用户访问，关闭下拉面板，并打开 router.push
```javascript
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  const isLoggedIn = userStore.isLoggedIn()

  if (to.meta.requiresAuth && !isLoggedIn) {
    next('/login')
  } else {
    next()
  }
})
```

---

## 六、验证标准

### ✅ 文件结构标准
- 组件文件：`HorizontalLayout.vue` 包含 `<template>`, `<script setup>`, `<style scoped>`
- 单独使用配置文件 Class（`navigation.js`）

### ✅ 视觉验证
- [ ] Logo 严格左上对齐
- [ ] 右侧顺序：AI 时序按钮 → 升级会员按钮 → 用户头像
- [ ] 鼠标悬停"独立站数据"，下方出现白色面板，列出二级菜单
- [ ] 缩小浏览器窗口，导航栏不断裂，所有项可见（滚动或 More 菜单）

### ✅ 交互验证
- [ ] 悬停一级导航项，展开二级 Mega Menu
- [ ] 点击已开发模块，跳转到对应路由
- [ ] 点击未开发模块，弹出提示框
- [ ] 点击"升级会员"，弹出提示框
- [ ] 点击"退出登录"，清除 token 并跳转到登录页

### ✅ 响应式验证
- [ ] 宽度 < 768px 时，导航栏折叠为抽屉导航
- [ ] 宽度 < 480px 时，Logo 缩小，用户名字体缩小

---

## 七、输出要求

### ✅ 修改后的 HorizontalLayout.vue 完整代码
- 已完成所有优化
- 代码结构清晰，注释完整
- 符合 Vue3 Composition API 规范

### ✅ 验证清单
- 所有自动化测试通过
- 手动验证项需要在浏览器中测试

---

## 八、访问地址

- 前端：http://localhost:8080
- 后端 API：http://localhost:8000
- API 文档：http://localhost:8000/docs

---

## 九、重要提示

1. 清除浏览器缓存：`Cmd + Shift + R` (macOS)
2. 如果看不到更新，尝试无痕模式
3. 手动验证项需要在浏览器中测试
4. 所有样式使用 scoped CSS，避免全局污染
5. 所有交互使用 Vue3 Composition API，避免使用 Options API

---

## 十、已完成的优化

✅ Header 布局修复（Flexbox 严格对齐）
✅ Mega Menu 父层实现（悬停展开）
✅ 导航栏溢出处理（"更多"菜单）
✅ 图标缩放修复（固定尺寸）
✅ 响应式布局优化（移动端适配）
✅ 路由守卫完善（权限控制）
✅ 样式规范统一（产品级标准）
✅ 动画效果优化（平滑过渡）

---

## 十一、待手动验证项

⚠️ 需要在浏览器中手动测试：
1. 悬停一级导航项，二级 Mega Menu 是否正常展开
2. 点击已开发模块，是否正常跳转
3. 点击未开发模块，是否弹出提示框
4. 点击"升级会员"，是否弹出提示框
5. 点击"退出登录"，是否清除 token 并跳转到登录页
6. 缩小浏览器窗口，导航栏是否正常折叠
7. 移动端（< 768px）是否正常显示

---

## 十二、故障排查

如果遇到问题，请参考：
- `scripts/troubleshooting_guide.md` - 故障排查指南
- `scripts/devops_validation.sh` - 自动化验证脚本
- `scripts/generate_test_report.sh` - 测试报告生成脚本
