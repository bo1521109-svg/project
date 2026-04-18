# TikTok数据模块 - 导航与接口复用需求分析（基于现有横向导航）

**角色**: 资深系统架构师与技术产品经理  
**任务**: 针对当前【横向导航中已有的TikTok数据模块】的导航与接口复用需求，输出纯文本架构对齐方案  
**范围**: 仅处理横向导航中已存在的菜单项，未开发模块暂不处理  
**日期**: 2026-04-17

---

## 1. 路由-接口映射矩阵

### 1.1 TikTok 大盘模块

| 菜单名称 | 前端路由路径 | 复用/新建API路径 | 数据来源(独立/占位) | 权限要求 | 占位标记 |
|---------|------------|----------------|------------------|---------|---------|
| 品类大盘 | `/tiktok/category/overview` | `GET /api/v1/category_overview` | 新建 | user | ✅ |
| 商品大盘 | `/tiktok/product/overview` | `GET /api/v1/product_overview` | 新建 | user | ✅ |
| 店铺大盘 | `/tiktok/store/overview` | `GET /api/v1/store_overview` | 新建 | user | ✅ |
| AI 报告 | `/tiktok/ai-report` | `GET /api/v1/ai_report` | 新建 | user | ✅ |

**说明**: 大盘模块为TikTok独有功能，需新建专属接口

---

### 1.2 选爆品模块

| 菜单名称 | 前端路由路径 | 复用/新建API路径 | 数据来源(独立/占位) | 权限要求 | 占位标记 |
|---------|------------|----------------|------------------|---------|---------|
| 商品搜索 | `/tiktok/products` | `GET /api/v1/product_search?platform=tiktok` | 复用+参数 | user | ✅ |
| 商品销量榜 | `/tiktok/products/sales-rank` | `GET /api/v1/product_sales_rank?platform=tiktok` | 复用+参数 | user | ✅ |
| 商品飙升榜 | `/tiktok/products/surge-rank` | `GET /api/v1/product_surge_rank?platform=tiktok` | 复用+参数 | user | ✅ |
| 潜力新品榜 | `/tiktok/products/potential-new` | `GET /api/v1/product_potential_new?platform=tiktok` | 复用+参数 | user | ✅ |

**复用策略**: 
- 复用独立站的商品相关接口
- 通过`platform=tiktok`参数区分数据源
- 后端根据platform参数调用不同的数据服务

---

### 1.3 盯爆店模块

| 菜单名称 | 前端路由路径 | 复用/新建API路径 | 数据来源(独立/占位) | 权限要求 | 占位标记 |
|---------|------------|----------------|------------------|---------|---------|
| 店铺搜索 | `/tiktok/stores` | `GET /api/v1/store_search?platform=tiktok` | 复用+参数 | user | ✅ |
| 店铺爆卖榜 | `/tiktok/stores/best-sellers` | `GET /api/v1/store_best_sellers?platform=tiktok` | 复用+参数 | user | ✅ |
| 店铺飙升榜 | `/tiktok/stores/surge-rank` | `GET /api/v1/store_surge_rank?platform=tiktok` | 复用+参数 | user | ✅ |

**复用策略**: 
- 复用独立站的店铺相关接口
- 通过`platform=tiktok`参数区分数据源

---

### 1.4 找视频模块

| 菜单名称 | 前端路由路径 | 复用/新建API路径 | 数据来源(独立/占位) | 权限要求 | 占位标记 |
|---------|------------|----------------|------------------|---------|---------|
| 视频搜索 | `/tiktok/videos` | `GET /api/v1/tk_video_search` | 新建 | user | ✅ |
| AI 爆款 | `/tiktok/videos/ai` | `GET /api/v1/tk_video_ai` | 新建 | user | ✅ |
| 广告搜索 | `/tiktok/videos/ads` | `GET /api/v1/tk_video_ads` | 新建 | user | ✅ |

**说明**: 视频模块为TikTok独有功能，需新建专属接口

---

### 1.5 选达人模块

| 菜单名称 | 前端路由路径 | 复用/新建API路径 | 数据来源(独立/占位) | 权限要求 | 占位标记 |
|---------|------------|----------------|------------------|---------|---------|
| 达人搜索 | `/tiktok/influencers` | `GET /api/v1/tk_inf_search` | 新建 | user | ✅ |
| 带货达人榜 | `/tiktok/influencers/sales-rank` | `GET /api/v1/tk_inf_sales_rank` | 新建 | user | ✅ |
| 涨粉达人榜 | `/tiktok/influencers/follower-rank` | `GET /api/v1/tk_inf_follower_rank` | 新建 | user | ✅ |
| 达人机构榜 | `/tiktok/influencers/agency-rank` | `GET /api/v1/tk_inf_agency_rank` | 新建 | user | ✅ |

**说明**: 达人模块为TikTok独有功能，需新建专属接口

---

## 2. 接口复用策略总结

### 2.1 可复用接口清单

| 原接口路径 | 复用场景 | 新增参数 | 说明 |
|-----------|---------|---------|------|
| `GET /api/v1/product_search` | TikTok商品搜索 | `platform=tiktok` | 通用商品搜索接口 |
| `GET /api/v1/product_sales_rank` | TikTok商品销量榜 | `platform=tiktok` | 通用销量榜接口 |
| `GET /api/v1/product_surge_rank` | TikTok商品飙升榜 | `platform=tiktok` | 通用飙升榜接口 |
| `GET /api/v1/product_potential_new` | TikTok潜力新品榜 | `platform=tiktok` | 通用新品榜接口 |
| `GET /api/v1/store_search` | TikTok店铺搜索 | `platform=tiktok` | 通用店铺搜索接口 |
| `GET /api/v1/store_best_sellers` | TikTok店铺爆卖榜 | `platform=tiktok` | 通用爆卖榜接口 |
| `GET /api/v1/store_surge_rank` | TikTok店铺飙升榜 | `platform=tiktok` | 通用飙升榜接口 |

**复用原则**:
- 商品和店铺相关功能在独立站和TikTok之间逻辑相似，可复用
- 通过`platform`参数区分数据源
- 后端根据platform参数路由到不同的数据服务

### 2.2 需新建接口清单

| 新接口路径 | 功能说明 | 原因 |
|-----------|---------|------|
| `GET /api/v1/category_overview` | 品类大盘 | TikTok独有功能 |
| `GET /api/v1/product_overview` | 商品大盘 | TikTok独有功能 |
| `GET /api/v1/store_overview` | 店铺大盘 | TikTok独有功能 |
| `GET /api/v1/ai_report` | AI报告 | TikTok独有功能 |
| `GET /api/v1/tk_video_search` | 视频搜索 | TikTok独有功能 |
| `GET /api/v1/tk_video_ai` | AI爆款视频 | TikTok独有功能 |
| `GET /api/v1/tk_video_ads` | 广告搜索 | TikTok独有功能 |
| `GET /api/v1/tk_inf_search` | 达人搜索 | TikTok独有功能 |
| `GET /api/v1/tk_inf_sales_rank` | 带货达人榜 | TikTok独有功能 |
| `GET /api/v1/tk_inf_follower_rank` | 涨粉达人榜 | TikTok独有功能 |
| `GET /api/v1/tk_inf_agency_rank` | 达人机构榜 | TikTok独有功能 |

---

## 3. 交互与状态流转说明

### 3.1 横向导航与Mega Menu的联动机制

```
用户操作流程:
┌─────────────────────────────────────────────────────────────┐
│ 1. 用户点击顶部"TikTok 数据"                                   │
│    ↓                                                         │
│ 2. 触发 handleFirstLevelSelect('/tiktok')                    │
│    ↓                                                         │
│ 3. 展开Mega Menu，显示5个大卡片                               │
│    - TikTok 大盘                                             │
│    - 选爆品                                                  │
│    - 盯爆店                                                  │
│    - 找视频                                                  │
│    - 选达人                                                  │
│    ↓                                                         │
│ 4. 用户点击大卡片（如"选爆品"）                               │
│    ↓                                                         │
│ 5. 跳转到该卡片第一个链接: /tiktok/products                   │
│    ↓                                                         │
│ 6. 或用户点击小链接（如"商品销量榜"）                          │
│    ↓                                                         │
│ 7. 跳转到: /tiktok/products/sales-rank                       │
│    ↓                                                         │
│ 8. 关闭Mega Menu                                             │
│    ↓                                                         │
│ 9. 显示左侧TikTok侧边栏                                       │
│    ↓                                                         │
│ 10. 加载对应页面，调用API获取数据                             │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 左侧侧边栏与横向导航的同步机制

```
同步状态机:
┌─────────────────────────────────────────────────────────────┐
│ 场景1: 从横向导航进入TikTok模块                                │
│ ├─ 顶部导航高亮"TikTok 数据"                                  │
│ ├─ 显示左侧TikTok侧边栏                                       │
│ ├─ 侧边栏根据当前路由高亮对应菜单项                            │
│ └─ 内容区加载对应页面                                         │
│                                                              │
│ 场景2: 在左侧侧边栏切换菜单                                    │
│ ├─ 顶部导航保持高亮"TikTok 数据"                              │
│ ├─ 侧边栏更新高亮状态                                         │
│ ├─ 手风琴展开对应一级菜单                                     │
│ ├─ 路由更新                                                  │
│ └─ 内容区刷新                                                │
│                                                              │
│ 场景3: 切换平台选择器（独立站 ↔ TikTok）                       │
│ ├─ 更新 currentPlatform 状态                                 │
│ ├─ 切换图标显示（Shopify ↔ TikTok）                          │
│ ├─ 保持当前菜单位置                                           │
│ ├─ API请求自动添加platform参数                               │
│ └─ 数据根据平台过滤显示                                       │
└─────────────────────────────────────────────────────────────┘
```

### 3.3 API调用与参数传递流程

```
API调用流程:
┌─────────────────────────────────────────────────────────────┐
│ 1. 用户访问 /tiktok/products/sales-rank                      │
│    ↓                                                         │
│ 2. 组件挂载，读取当前平台状态                                 │
│    - currentPlatform = 'TikTok'                              │
│    ↓                                                         │
│ 3. 构建API请求                                               │
│    - URL: /api/v1/product_sales_rank                         │
│    - Params: { platform: 'tiktok' }                          │
│    - Headers: { Authorization: 'Bearer <token>' }            │
│    ↓                                                         │
│ 4. 发送请求                                                  │
│    ↓                                                         │
│ 5. 后端接收请求                                              │
│    - 验证Token                                               │
│    - 检查权限                                                │
│    - 读取platform参数                                        │
│    ↓                                                         │
│ 6. 根据platform路由到对应数据服务                             │
│    - platform=tiktok → TikTok数据服务                        │
│    - platform=shopify → Shopify数据服务                      │
│    ↓                                                         │
│ 7. 返回数据                                                  │
│    - 格式: { code: 200, data: [...], message: 'success' }   │
│    ↓                                                         │
│ 8. 前端渲染数据                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. 潜在冲突与风险清单

### 4.1 技术风险

| 风险类型 | 具体描述 | 影响范围 | 规避方案 | 回滚预案 |
|---------|---------|---------|---------|---------|
| 路由冲突 | TikTok路由与独立站路由命名冲突 | 前端路由系统 | 使用`/tiktok`前缀隔离 | 回退到独立路由配置 |
| 参数传递失败 | platform参数未正确传递到后端 | API调用 | 请求拦截器统一添加参数 | 临时硬编码platform值 |
| 接口响应格式不一致 | TikTok接口与独立站接口返回格式不同 | 数据渲染 | 统一响应格式规范 | 前端适配器转换格式 |
| 侧边栏状态混乱 | 切换平台后侧边栏状态未更新 | 用户体验 | 监听platform变化，重置状态 | 刷新页面重置 |

### 4.2 业务风险

| 风险类型 | 具体描述 | 影响范围 | 规避方案 | 回滚预案 |
|---------|---------|---------|---------|---------|
| 数据源缺失 | TikTok数据接口未就绪 | 功能可用性 | 使用Mock数据占位 | 隐藏未就绪功能 |
| 平台参数错误 | 用户手动修改URL参数导致数据错误 | 数据准确性 | 后端校验platform参数 | 返回错误提示 |
| 权限配置错误 | TikTok功能权限配置不当 | 安全性 | 前后端双重权限校验 | 紧急下线功能 |

---

## 5. 分步实施与验收计划

### 阶段A: 配置核对（验收标准：映射矩阵无冲突，路径100%对齐Swagger）

**时间**: 第1天  
**负责人**: 后端架构师 + 前端技术负责人

**任务清单**:
1. ✅ 审查现有Swagger文档，确认可复用接口
2. ✅ 标记需要新建的TikTok专属接口
3. ✅ 生成完整的路由-接口映射表
4. ✅ 确定platform参数传递规范

**验收标准**:
- ✅ 映射表覆盖所有19个菜单项
- ✅ 明确标记7个复用接口和11个新建接口
- ✅ platform参数规范文档完成
- ✅ 团队评审通过

**交付物**:
- 路由-接口映射矩阵
- 接口复用方案文档
- platform参数规范

---

### 阶段B: 路由确定（验收标准：点击菜单可跳转，URL参数正确，无404）

**时间**: 第2天  
**负责人**: 前端开发团队

**任务清单**:
1. ✅ 在`router/index.js`中添加所有TikTok路由
2. ✅ 配置路由守卫
3. ✅ 创建占位页面组件
4. ✅ 测试所有路由跳转

**验收标准**:
- ✅ 点击任意菜单项可正常跳转
- ✅ URL正确
- ✅ 无404错误
- ✅ 侧边栏与路由同步

**交付物**:
- 完整的路由配置文件
- 路由测试报告

---

### 阶段C: 接口联调（验收标准：请求头带Token，响应格式统一，platform参数正确传递）

**时间**: 第3-4天  
**负责人**: 全栈开发团队

**任务清单**:
1. ✅ 后端实现所有占位接口
2. ✅ 配置platform参数处理逻辑
3. ✅ 前端封装API请求方法
4. ✅ 实现请求拦截器（添加platform参数）
5. ✅ 测试所有接口调用

**验收标准**:
- ✅ 所有请求正确携带platform参数
- ✅ 响应格式统一
- ✅ 复用接口根据platform返回不同数据
- ✅ 错误处理完善

**交付物**:
- API请求封装代码
- 接口测试报告

---

### 阶段D: 样式与交互对齐（验收标准：侧边栏与横向导航联动正常）

**时间**: 第5天  
**负责人**: 前端UI开发

**任务清单**:
1. ✅ 优化Mega Menu与侧边栏的联动
2. ✅ 实现平台切换器功能
3. ✅ 调整响应式布局
4. ✅ 跨浏览器测试

**验收标准**:
- ✅ Mega Menu与侧边栏联动流畅
- ✅ 平台切换器正常工作
- ✅ 移动端显示正常
- ✅ 全浏览器兼容

**交付物**:
- 样式优化代码
- 交互测试报告

---

### 阶段E: 异常处理（验收标准：断网/无权限/接口500时有友好提示）

**时间**: 第6天  
**负责人**: 测试工程师 + 前端开发

**任务清单**:
1. ✅ 实现全局错误捕获
2. ✅ 添加友好错误提示
3. ✅ 测试各种异常场景

**验收标准**:
- ✅ 所有异常场景有友好提示
- ✅ 不出现白屏
- ✅ 错误信息清晰

**交付物**:
- 错误处理代码
- 异常测试报告

---

## 6. 总结

本文档针对横向导航中已有的TikTok数据模块，提供了完整的接口复用方案：

1. **路由-接口映射**：19个菜单项的完整映射
2. **复用策略**：7个可复用接口，11个需新建接口
3. **交互流程**：横向导航、Mega Menu、侧边栏的联动机制
4. **风险清单**：7项潜在风险及规避方案
5. **实施计划**：5个阶段，6天完成

**核心复用原则**：
- 商品和店铺功能通过platform参数复用
- TikTok独有功能（大盘、视频、达人）新建接口
- 统一响应格式，简化前端处理

---

**文档版本**: v2.0  
**创建日期**: 2026-04-17  
**维护人**: 系统架构师团队
