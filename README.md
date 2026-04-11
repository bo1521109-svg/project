# 跨境电商独立站数据平台

一个基于 FastAPI + Vue3 + PostgreSQL 的跨境电商独立站数据采集与分析平台，专注于 Shopify 店铺的商品数据爬取和库存状态监控。

## 🚀 功能特性

### 核心功能
- 🕷️ **Shopify 爬虫**：支持批量爬取 Shopify 独立站商品数据
- 📊 **库存监控**：基于 `available` 字段的库存状态监控（有货/无货）
- 🏷️ **类目提取**：自动提取商品类目信息
- 🔄 **去重逻辑**：基于 URL 的商品去重机制
- 📈 **数据分析**：商品价格、库存状态、爬取时间等多维度展示

### 技术亮点
- ✅ Docker 容器化部署
- ✅ 异步爬虫（Playwright + httpx）
- ✅ JWT 用户认证
- ✅ 邀请码注册系统
- ✅ 响应式前端界面

## 🛠️ 技术栈

### 后端
- **框架**：FastAPI 0.104.1
- **数据库**：PostgreSQL 15
- **ORM**：SQLAlchemy 2.0
- **爬虫**：Playwright + httpx
- **认证**：JWT (python-jose)

### 前端
- **框架**：Vue 3
- **UI 库**：Element Plus
- **构建工具**：Vite
- **HTTP 客户端**：Axios

### 部署
- **容器化**：Docker + Docker Compose
- **Web 服务器**：Nginx
- **ASGI 服务器**：Uvicorn

## 📦 项目结构

```
Myproject/
├── app/                          # 后端应用
│   ├── api/                      # API 路由
│   │   └── v1/
│   │       ├── auth.py          # 用户认证
│   │       ├── products.py      # 商品接口
│   │       └── stores.py        # 店铺接口
│   ├── core/                     # 核心配置
│   │   ├── config.py            # 应用配置
│   │   └── logging_config.py   # 日志配置
│   ├── crawler/                  # 爬虫模块
│   │   ├── base.py              # 基础爬虫类
│   │   └── spiders/
│   │       └── shopify.py       # Shopify 爬虫
│   ├── db/                       # 数据库
│   │   ├── base.py              # Base 模型
│   │   └── database.py          # 数据库连接
│   ├── models/                   # 数据模型
│   │   ├── product.py           # 商品模型
│   │   ├── store.py             # 店铺模型
│   │   └── user.py              # 用户模型
│   ├── schemas/                  # Pydantic Schema
│   └── main.py                   # 应用入口
├── frontend/                     # 前端应用
│   ├── src/
│   │   ├── views/               # 页面组件
│   │   ├── router/              # 路由配置
│   │   ├── stores/              # 状态管理
│   │   └── utils/               # 工具函数
│   └── index.html
├── docker-compose.yml            # Docker 编排
├── Dockerfile                    # 后端镜像
├── requirements.txt              # Python 依赖
└── README.md                     # 项目文档
```

## 🚀 快速开始

### 前置要求
- Docker 20.10+
- Docker Compose 2.0+

### 1. 克隆项目

```bash
git clone <your-repo-url>
cd Myproject
```

### 2. 配置环境变量

创建 `.env` 文件：

```bash
# 数据库配置
DB_USER=myuser
DB_PASSWORD=mypassword
DB_NAME=ecommerce_db
DATABASE_URL=postgresql://myuser:mypassword@db:5432/ecommerce_db

# 项目配置
PROJECT_NAME=跨境电商独立站数据平台

# 日志配置
LOG_LEVEL=INFO
```

### 3. 启动服务

```bash
docker-compose up -d
```

### 4. 访问应用

- **前端界面**：http://localhost
- **后端 API**：http://localhost:8000
- **API 文档**：http://localhost:8000/docs

### 5. 初始化数据

首次运行需要注册第一个用户（无需邀请码）：

```bash
# 访问前端注册页面
http://localhost/login
```

## 📖 使用指南

### 1. 用户注册与登录
- 第一个用户可直接注册（无需邀请码）
- 后续用户需要使用邀请码注册
- 登录后获得 JWT Token

### 2. 添加店铺
- 进入"店铺管理"页面
- 点击"添加店铺"
- 输入店铺名称和 URL（支持 Shopify 独立站）

### 3. 爬取商品
- 在店铺列表中点击"爬取"按钮
- 系统自动爬取商品数据
- 爬取完成后可在"商品列表"查看

### 4. 查看商品
- 进入"商品列表"页面
- 支持按店铺筛选
- 显示商品标题、价格、库存状态、爬取时间等信息
- 最新爬取的商品显示在最前面

## 🔧 核心功能说明

### 库存状态监控

系统采用基于 `available` 字段的库存状态监控方案：

- **有货**：`is_available = True`（绿色标签）
- **无货**：`is_available = False`（红色标签）
- **未知**：`is_available = NULL`（灰色标签）

**优势**：
- 快速稳定，避免 API 限流
- 适合批量爬取多个店铺
- 实时监控商品上下架状态

### 爬虫去重逻辑

- 基于商品 URL 的唯一索引
- URL 标准化处理（小写、去斜杠、统一 https）
- 商品已存在时跳过，避免重复插入

### 类目提取

自动提取商品类目，优先级：
1. `product_type` 字段
2. `tags` 字段（取第一个）
3. `vendor` 字段

## 🗄️ 数据库设计

### Product 表（商品表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER | 主键 |
| store_id | INTEGER | 店铺 ID（外键） |
| title | VARCHAR(500) | 商品标题 |
| url | VARCHAR(500) | 商品 URL（唯一索引） |
| price | FLOAT | 价格 |
| currency | VARCHAR(10) | 货币（默认 USD） |
| image_url | VARCHAR(500) | 图片链接 |
| category | VARCHAR(255) | 商品类目 |
| is_available | BOOLEAN | 当前是否有货 |
| last_available | BOOLEAN | 上次爬取时的状态 |
| status_change_at | TIMESTAMP | 状态变化时间 |
| captured_at | TIMESTAMP | 抓取时间 |
| created_at | TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | 更新时间 |

## 🐛 常见问题

### 1. 爬虫无法启动

**问题**：点击爬取按钮后无响应

**解决方案**：
- 检查 Docker 容器是否正常运行：`docker-compose ps`
- 查看后端日志：`docker-compose logs web`
- 确认 Playwright 浏览器已安装

### 2. 数据库连接失败

**问题**：后端无法连接数据库

**解决方案**：
- 检查 `.env` 文件中的数据库配置
- 确认数据库容器正常运行：`docker-compose ps db`
- 使用 `db` 作为主机名（Docker 网络）

### 3. 前端无法访问后端

**问题**：前端请求后端 API 失败

**解决方案**：
- 检查 Nginx 配置是否正确
- 确认后端服务运行在 8000 端口
- 查看浏览器控制台的网络请求

## 📝 开发计划

- [ ] 支持更多电商平台（WooCommerce、Magento）
- [ ] 商品价格历史追踪
- [ ] 邮件/Webhook 通知（库存变化提醒）
- [ ] 数据导出功能（CSV、Excel）
- [ ] 定时任务（自动爬取）
- [ ] 数据可视化（图表分析）

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支：`git checkout -b feature/your-feature`
3. 提交更改：`git commit -m 'Add some feature'`
4. 推送到分支：`git push origin feature/your-feature`
5. 提交 Pull Request

## 📄 许可证

MIT License

## 👨‍💻 作者

Your Name

## 🙏 致谢

感谢所有开源项目的贡献者！
