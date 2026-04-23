# 爬虫管理功能迁移总结

## 改动概述

根据提示词要求，将爬虫管理功能从独立站数据模块迁移到平台管理模块，实现了以下改动：

---

## 1. 前端改动

### 1.1 新增页面
创建了 `frontend/src/views/admin/CrawlerTasks.vue` 页面，用于管理爬虫任务。

**页面功能：**
- 显示爬虫任务列表（ID、任务名称、目标网址、平台、状态、最后爬取时间）
- 添加新的爬虫任务
- 启动爬虫任务
- 删除爬虫任务
- 响应式设计，支持移动端

**API 端点：**
- `GET /api/v1/admin/crawler/tasks` - 获取爬虫任务列表
- `POST /api/v1/admin/crawler/tasks` - 创建爬虫任务
- `POST /api/v1/admin/crawler/tasks/{task_id}/crawl` - 启动爬虫
- `DELETE /api/v1/admin/crawler/tasks/{task_id}` - 删除爬虫任务

### 1.2 路由配置更新
修改了 `frontend/src/router/index.js`：

```javascript
{
  path: '/admin/crawler/tasks',
  name: 'AdminCrawlerTasks',
  component: () => import('../views/admin/CrawlerTasks.vue'),
  meta: { title: '爬虫任务列表', requiresAuth: true, requiresAdmin: true }
}
```

**改动说明：**
- 将原来的 `Placeholder` 组件替换为实际的 `CrawlerTasks` 组件
- 使用动态导入（懒加载）优化性能
- 保持管理员权限验证（`requiresAdmin: true`）

### 1.3 原有店铺管理页面
`frontend/src/views/Stores.vue` 保持不变，继续用于独立站数据的店铺管理功能。

---

## 2. 后端改动

### 2.1 新增 API 文件
创建了 `app/api/v1/admin/admin_crawler_tasks.py`，实现爬虫任务管理的所有接口。

**接口列表：**

| 方法 | 路径 | 功能 | 说明 |
|------|------|------|------|
| GET | `/api/v1/admin/crawler/tasks` | 获取爬虫任务列表 | 返回所有爬虫任务 |
| POST | `/api/v1/admin/crawler/tasks` | 创建爬虫任务 | 需要提供任务名称、URL等信息 |
| GET | `/api/v1/admin/crawler/tasks/{task_id}` | 获取单个任务详情 | 返回指定任务的详细信息 |
| POST | `/api/v1/admin/crawler/tasks/{task_id}/crawl` | 启动爬虫任务 | 触发爬虫执行 |
| DELETE | `/api/v1/admin/crawler/tasks/{task_id}` | 删除爬虫任务 | 删除指定任务及其数据 |

**数据模型：**

```python
class CrawlerTaskCreate(BaseModel):
    """创建爬虫任务的请求模型"""
    name: str
    url: str
    platform: str = "shopify"
    country: str = None

class CrawlerTaskResponse(BaseModel):
    """爬虫任务响应模型"""
    id: int
    name: str
    url: str
    platform: str
    country: str = None
    status: str
    last_crawl_at: datetime = None
    is_crawling: bool = False
```

### 2.2 更新 Admin 模块路由
修改了 `app/api/v1/admin/__init__.py`，添加爬虫任务路由：

```python
from . import (
    admin_login_logs,
    admin_permissions,
    admin_users,
    admin_crawler_tasks  # 新增
)

router.include_router(
    admin_crawler_tasks.router, 
    prefix="/crawler/tasks", 
    tags=["平台管理 爬虫任务"]
)
```

### 2.3 数据库复用
爬虫任务管理复用了现有的 `Store` 模型（`app/models/store.py`），无需创建新表。

**字段映射：**
- `name` - 任务名称
- `url` - 目标网址
- `platform` - 平台类型
- `country` - 国家
- `status` - 任务状态
- `last_crawl_at` - 最后爬取时间
- `is_crawling` - 是否正在爬取

---

## 3. 路由结构对比

### 3.1 迁移前
```
/api/v1/stores/                    # 店铺管理（混合了爬虫功能）
├── GET  /                         # 获取店铺列表
├── POST /                         # 创建店铺
├── POST /{store_id}/crawl         # 启动爬虫
└── DELETE /{store_id}             # 删除店铺
```

### 3.2 迁移后
```
# 独立站数据模块（保持原有功能）
/api/v1/shopify/stores/            # 店铺管理
├── GET  /                         # 获取店铺列表
├── POST /                         # 创建店铺
└── DELETE /{store_id}             # 删除店铺

# 平台管理模块（新增爬虫管理）
/api/v1/admin/crawler/tasks/       # 爬虫任务管理
├── GET  /                         # 获取爬虫任务列表
├── POST /                         # 创建爬虫任务
├── GET  /{task_id}                # 获取任务详情
├── POST /{task_id}/crawl          # 启动爬虫
└── DELETE /{task_id}              # 删除爬虫任务
```

---

## 4. 权限控制

### 4.1 前端路由守卫
爬虫任务管理页面需要管理员权限：

```javascript
meta: { 
  title: '爬虫任务列表', 
  requiresAuth: true,      // 需要登录
  requiresAdmin: true      // 需要管理员权限
}
```

### 4.2 后端权限验证
所有爬虫任务管理接口都在 `/api/v1/admin/` 路径下，由路由守卫统一验证管理员权限。

---

## 5. 功能对比

| 功能 | 独立站数据 - 店铺管理 | 平台管理 - 爬虫任务 |
|------|---------------------|-------------------|
| 访问路径 | `/stores` | `/admin/crawler/tasks` |
| 权限要求 | 普通用户 | 管理员 |
| 主要用途 | 业务数据管理 | 系统运维管理 |
| API 前缀 | `/api/v1/shopify/stores` | `/api/v1/admin/crawler/tasks` |
| 数据模型 | Store | Store（复用） |

---

## 6. 测试建议

### 6.1 前端测试
1. 以管理员身份登录
2. 访问 `/admin/crawler/tasks` 页面
3. 测试添加爬虫任务
4. 测试启动爬虫任务
5. 测试删除爬虫任务
6. 验证非管理员无法访问

### 6.2 后端测试
访问 API 文档：`http://localhost:8000/docs`

测试以下接口：
- `GET /api/v1/admin/crawler/tasks` - 获取任务列表
- `POST /api/v1/admin/crawler/tasks` - 创建任务
- `POST /api/v1/admin/crawler/tasks/{task_id}/crawl` - 启动爬虫
- `DELETE /api/v1/admin/crawler/tasks/{task_id}` - 删除任务

---

## 7. 文件清单

### 新增文件
- `frontend/src/views/admin/CrawlerTasks.vue` - 爬虫任务管理页面
- `app/api/v1/admin/admin_crawler_tasks.py` - 爬虫任务管理 API

### 修改文件
- `frontend/src/router/index.js` - 更新路由配置
- `app/api/v1/admin/__init__.py` - 添加爬虫任务路由

### 保持不变
- `frontend/src/views/Stores.vue` - 独立站店铺管理页面
- `app/models/store.py` - Store 数据模型

---

## 8. 部署说明

### 8.1 前端部署
```bash
docker compose build frontend
docker compose up -d frontend
```

### 8.2 后端部署
```bash
docker compose restart web
```

### 8.3 验证部署
1. 检查容器状态：`docker compose ps`
2. 查看后端日志：`docker compose logs web --tail 50`
3. 访问 API 文档：`http://localhost:8000/docs`
4. 访问前端页面：`http://localhost/admin/crawler/tasks`

---

## 9. 注意事项

1. **权限验证**：爬虫任务管理功能仅限管理员访问
2. **数据复用**：使用现有 Store 模型，无需数据迁移
3. **API 路径**：新的爬虫管理 API 在 `/api/v1/admin/crawler/tasks` 下
4. **前端路由**：管理员访问 `/admin/crawler/tasks` 页面
5. **向后兼容**：原有的店铺管理功能保持不变

---

## 10. 下一步优化建议

1. **实现真实爬虫逻辑**：当前只是更新状态，需要集成实际的爬虫引擎
2. **添加爬虫日志**：记录爬虫执行过程和结果
3. **添加爬虫配置**：支持自定义爬虫参数（频率、深度等）
4. **添加任务调度**：支持定时自动执行爬虫任务
5. **添加数据统计**：展示爬虫任务的执行统计和成功率
6. **添加错误处理**：完善爬虫失败时的重试和告警机制

---

## 11. 改动总结

✅ **完成的工作：**
- 创建了独立的爬虫任务管理页面
- 实现了完整的爬虫任务 CRUD 接口
- 将爬虫管理功能从独立站模块迁移到平台管理模块
- 保持了原有店铺管理功能的完整性
- 实现了管理员权限控制
- 前后端容器已成功构建和重启

✅ **架构优化：**
- 职责分离：业务数据管理 vs 系统运维管理
- 权限分级：普通用户 vs 管理员
- 模块化：独立的 API 路由和前端页面

✅ **用户体验：**
- 管理员可以在专门的页面管理爬虫任务
- 普通用户继续使用店铺管理功能
- 界面保持一致性，操作流程相同
