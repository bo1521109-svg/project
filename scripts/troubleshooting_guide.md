# DevOps 故障排查指南

## 常见问题及解决方案

### 问题 1: 二级下拉不显示

**症状**: 悬停一级导航时，二级面板不出现

**可能原因**:
- z-index 层级冲突
- position: relative 未设置
- CSS 样式被覆盖

**解决方案**:
```bash
# 1. 检查 HorizontalLayout.vue 中的 z-index 配置
grep -n "z-index" ../frontend/src/layout/HorizontalLayout.vue

# 2. 确保二级面板的 z-index 高于其他元素
# 建议值: header z-index: 1000, submenu z-index: 999

# 3. 检查浏览器开发者工具中的元素层级
# 打开浏览器 -> F12 -> Elements -> 检查 .submenu-panel 元素
```

---

### 问题 2: 路由跳转 404

**症状**: 点击导航项后显示空白页或 404

**可能原因**:
- 路由路径配置错误
- 组件未正确引入
- router 中的 component 拼写错误

**解决方案**:
```bash
# 1. 检查路由配置
cat ../frontend/src/router/index.js | grep -A3 "path: '/products'"

# 2. 验证组件引入
grep "import.*Products" ../frontend/src/router/index.js

# 3. 检查路由路径是否与导航配置一致
diff <(grep "path:" ../frontend/src/config/navigation.js | awk '{print $2}') \
     <(grep "path:" ../frontend/src/router/index.js | awk '{print $2}')

# 4. 重建前端容器
cd ../
docker-compose up -d --build frontend
```

---

### 问题 3: 管理员看不到"平台管理"

**症状**: 管理员登录后，顶部只显示 7 个一级项

**可能原因**:
- userStore 中的 role 字段未正确设置
- getFilteredNav() 函数未正确调用
- 后端返回的用户信息缺少 role 字段

**解决方案**:
```bash
# 1. 检查后端 API 返回的用户信息
curl -X GET "http://localhost:8000/api/v1/auth/me" \
     -H "Authorization: Bearer YOUR_TOKEN"

# 2. 检查 userStore 中的 role 字段
cat ../frontend/src/stores/user.js | grep -A5 "role"

# 3. 在浏览器控制台检查
# 打开浏览器 -> F12 -> Console -> 输入:
# useUserStore().user.role

# 4. 如果 role 为 undefined，需要修改后端返回数据
```

---

### 问题 4: 占位页面不显示

**症状**: 点击未开发模块后，页面空白

**可能原因**:
- Placeholder.vue 组件未正确引入
- 路由配置中 component 拼写错误
- Element Plus 图标未安装

**解决方案**:
```bash
# 1. 检查 Placeholder 组件是否存在
ls -la ../frontend/src/views/Placeholder.vue

# 2. 检查路由引入
grep "import.*Placeholder" ../frontend/src/router/index.js

# 3. 检查 Element Plus 图标是否安装
cd ../frontend
npm list @element-plus/icons-vue

# 4. 如果未安装，执行安装
npm install @element-plus/icons-vue

# 5. 重建容器
cd ../
docker-compose up -d --build frontend
```

---

### 问题 5: 手机端导航不折叠

**症状**: 在小屏幕设备上，导航仍然横向显示

**可能原因**:
- 响应式 CSS 未生效
- @media 查询条件错误
- viewport meta 标签缺失

**解决方案**:
```bash
# 1. 检查 HorizontalLayout.vue 中的 @media 查询
grep -A10 "@media" ../frontend/src/layout/HorizontalLayout.vue

# 2. 检查 index.html 中的 viewport 设置
cat ../frontend/index.html | grep viewport

# 3. 在浏览器中测试响应式
# 打开浏览器 -> F12 -> Toggle device toolbar (Cmd + Shift + M)
# 选择 iPhone 或 iPad 设备进行测试
```

---

### 问题 6: 原有功能（店铺管理/商品列表）无法访问

**症状**: 点击"独立站店铺"或"独立站商品"后无响应

**可能原因**:
- 路由配置被覆盖
- 组件路径错误
- 后端 API 不可用

**解决方案**:
```bash
# 1. 检查路由配置
grep -A5 "path: '/stores'" ../frontend/src/router/index.js
grep -A5 "path: '/products'" ../frontend/src/router/index.js

# 2. 确认组件未被 Placeholder 替换
grep -B2 -A2 "component: Stores" ../frontend/src/router/index.js

# 3. 测试后端 API
curl http://localhost:8000/api/v1/stores
curl http://localhost:8000/api/v1/products

# 4. 检查后端容器日志
docker logs fastapi_app --tail 50
```

---

## 快速诊断命令

### 一键检查所有配置
```bash
cd scripts
./devops_validation.sh
```

### 查看容器日志
```bash
# 前端日志
docker logs nginx_frontend --tail 100

# 后端日志
docker logs fastapi_app --tail 100

# 数据库日志
docker logs postgres_db --tail 100
```

### 重建所有容器
```bash
cd Myproject
docker-compose down
docker-compose up -d --build
```

### 清除浏览器缓存
- macOS: `Cmd + Shift + R`
- Windows: `Ctrl + Shift + R`
- 或使用无痕模式: `Cmd + Shift + N` (Chrome)

---

## 验证步骤清单

### 普通用户登录验证
- [ ] 顶部显示 7 个一级项（TikTok 数据、独立站数据、内容制作、社媒管理、建站精灵、客资管家、出海生态）
- [ ] 悬停"独立站数据"，显示二级面板（独立站商品、独立站店铺、广告库）
- [ ] 点击"独立站商品"，正常跳转到商品列表页
- [ ] 点击"独立站店铺"，正常跳转到店铺管理页
- [ ] 悬停未开发模块（如"TikTok 数据"），二级面板显示"敬请期待"
- [ ] 点击未开发模块的二级项，跳转到占位页面

### 管理员登录验证
- [ ] 顶部显示 8 个一级项（包含"平台管理"）
- [ ] 悬停"平台管理"，显示二级面板（用户管理、权限管理、系统设置）
- [ ] 点击"用户管理"，跳转到占位页面（管理员专属）

### 响应式验证
- [ ] 浏览器宽度 < 768px 时，导航折叠为汉堡菜单
- [ ] 点击汉堡菜单，展开导航列表
- [ ] 手机端可正常访问所有功能

### 权限控制验证
- [ ] 普通用户无法访问 `/admin/*` 路径
- [ ] 访问管理员路径时，自动重定向到首页
- [ ] 未登录用户访问任何页面，重定向到登录页

---

## 联系支持

如果以上方案无法解决问题，请提供以下信息：

1. 错误截图
2. 浏览器控制台错误信息（F12 -> Console）
3. Docker 容器日志（`docker logs <container_name>`）
4. 操作系统和浏览器版本
5. 执行 `./devops_validation.sh` 的输出结果
