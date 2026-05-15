# 数据库架构完整总结

## 项目数据库概览

**数据库类型**: PostgreSQL 15  
**ORM 框架**: SQLAlchemy  
**数据库名称**: ecommerce_db  
**部署方式**: Docker 容器化部署  

---

## 一、数据库连接配置

### 1.1 连接信息
```
数据库类型: PostgreSQL
版本: 15
主机: db (Docker 服务名)
端口: 5432
用户名: myuser
密码: mypassword
数据库名: ecommerce_db
```

### 1.2 连接字符串
```
postgresql://myuser:mypassword@db:5432/ecommerce_db
```

**重要说明**: 
- 主机名使用 `db` 而不是 `localhost`，因为在 Docker 网络中需要使用服务名进行容器间通信
- 连接字符串通过环境变量 `DATABASE_URL` 配置

### 1.3 配置文件位置
- **环境变量**: `Myproject/.env`
- **数据库配置**: `Myproject/app/db/database.py`
- **Docker 配置**: `Myproject/docker-compose.yml`
- **应用配置**: `Myproject/app/core/config.py`

---

## 二、数据库表结构

### 2.1 用户表 (users)

**表名**: `users`  
**用途**: 存储用户账号信息和权限管理

#### 字段定义

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | Integer | PRIMARY KEY, INDEX | 用户ID（主键） |
| username | String(50) | UNIQUE, NOT NULL, INDEX | 用户名（唯一） |
| password_hash | String(255) | NOT NULL | 密码哈希（加密存储） |
| role | String(20) | NOT NULL, DEFAULT='user' | 用户角色（user/admin） |
| phone | String(20) | NULLABLE | 手机号（可选） |
| invitation_code | String(20) | UNIQUE, NOT NULL, INDEX | 邀请码（唯一，自动生成） |
| invited_by | Integer | FOREIGN KEY → users.id | 邀请人ID（外键） |
| created_at | DateTime(TZ) | DEFAULT=now() | 创建时间 |

#### 索引
- PRIMARY KEY: `id`
- UNIQUE INDEX: `username`, `invitation_code`
- INDEX: `username`, `invitation_code`

#### 外键关系
- `invited_by` → `users.id` (自引用，邀请关系)

#### 业务逻辑
- **用户注册**: 自动生成唯一邀请码
- **角色管理**: 支持普通用户(user)和管理员(admin)
- **邀请系统**: 记录用户邀请关系链

---

### 2.2 登录日志表 (login_logs)

**表名**: `login_logs`  
**用途**: 记录用户登录历史，用于安全审计

#### 字段定义

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | Integer | PRIMARY KEY, INDEX | 日志ID（主键） |
| user_id | Integer | FOREIGN KEY → users.id, NOT NULL | 用户ID（外键） |
| login_at | DateTime(TZ) | DEFAULT=now() | 登录时间 |
| ip_address | String(45) | NULLABLE | IP地址（支持IPv6） |

#### 索引
- PRIMARY KEY: `id`
- INDEX: `id`

#### 外键关系
- `user_id` → `users.id`

#### 业务逻辑
- **登录记录**: 每次用户登录自动记录
- **IP 追踪**: 记录登录来源 IP（支持 IPv4 和 IPv6）
- **安全审计**: 管理员可查看登录历史

---

### 2.3 店铺表 (store)

**表名**: `store`  
**用途**: 存储独立站/店铺信息和爬虫任务配置

#### 字段定义

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | Integer | PRIMARY KEY, INDEX | 主键 |
| name | String(255) | NOT NULL | 店铺名称 |
| url | String(500) | UNIQUE, NOT NULL | 店铺URL（唯一索引） |
| platform | String(50) | DEFAULT='shopify' | 平台类型（默认 shopify） |
| country | String(100) | NULLABLE | 国家/地区 |
| status | String(20) | DEFAULT='active' | 状态（active/paused/error） |
| is_crawling | Boolean | DEFAULT=False | 是否正在爬取 |
| last_crawl_at | DateTime | NULLABLE | 最后爬取时间 |
| created_at | DateTime | DEFAULT=utcnow() | 创建时间 |
| updated_at | DateTime | DEFAULT=utcnow(), ONUPDATE | 更新时间 |

#### 索引
- PRIMARY KEY: `id`
- UNIQUE INDEX: `url`
- INDEX: `id`

#### 关系
- **一对多**: `store` → `products` (一个店铺有多个商品)

#### 业务逻辑
- **爬虫任务**: 每个店铺对应一个爬虫任务
- **状态管理**: 
  - `active`: 正常运行
  - `paused`: 暂停爬取
  - `error`: 爬取出错
- **并发控制**: `is_crawling` 防止重复爬取
- **平台支持**: 目前主要支持 Shopify，可扩展到 TikTok 等

---

### 2.4 商品表 (product)

**表名**: `product`  
**用途**: 存储商品详细信息和库存状态监控

#### 字段定义

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | Integer | PRIMARY KEY, INDEX | 主键 |
| store_id | Integer | FOREIGN KEY → store.id, NOT NULL | 店铺ID（外键） |
| title | String(500) | NOT NULL | 商品标题 |
| url | String(500) | UNIQUE, NOT NULL | 商品URL（唯一索引） |
| price | Float | NULLABLE | 价格 |
| currency | String(10) | DEFAULT='USD' | 货币单位 |
| image_url | String(500) | NULLABLE | 商品图片链接 |
| category | String(255) | NULLABLE | 商品类目 |
| is_available | Boolean | NULLABLE | 当前是否有货 |
| last_available | Boolean | NULLABLE | 上次爬取时的库存状态 |
| status_change_at | DateTime | NULLABLE | 状态变化时间 |
| last_stock | Integer | NULLABLE | 上次库存数（已废弃） |
| sales_estimate | Integer | DEFAULT=0 | 预估销量（已废弃） |
| captured_at | DateTime | NULLABLE | 抓取时间 |
| created_at | DateTime | DEFAULT=utcnow() | 创建时间 |
| updated_at | DateTime | DEFAULT=utcnow(), ONUPDATE | 更新时间 |

#### 索引
- PRIMARY KEY: `id`
- UNIQUE INDEX: `url`
- INDEX: `id`

#### 外键关系
- `store_id` → `store.id`

#### 关系
- **多对一**: `products` → `store` (多个商品属于一个店铺)

#### 业务逻辑

##### 库存状态监控（当前方案）
- **is_available**: 当前是否有货（True=有货，False=无货）
- **last_available**: 上次爬取时的状态
- **status_change_at**: 状态变化时间（从有货变无货，或反之）

**监控逻辑**:
```python
if is_available != last_available:
    # 状态发生变化
    status_change_at = now()
    last_available = is_available
```

##### 销量估算（已废弃）
- **last_stock**: 上次库存数
- **sales_estimate**: 预估销量（昨日库存 - 今日库存）

**注意**: 销量估算方案已废弃，改用库存状态监控

---

## 三、数据库关系图

```
┌─────────────────┐
│     users       │
│─────────────────│
│ id (PK)         │◄──┐
│ username        │   │
│ password_hash   │   │
│ role            │   │
│ invitation_code │   │
│ invited_by (FK) │───┘ (自引用)
│ created_at      │
└─────────────────┘
        │
        │ 1:N
        ▼
┌─────────────────┐
│  login_logs     │
│─────────────────│
│ id (PK)         │
│ user_id (FK)    │
│ login_at        │
│ ip_address      │
└─────────────────┘


┌─────────────────┐
│     store       │
│─────────────────│
│ id (PK)         │
│ name            │
│ url (UNIQUE)    │
│ platform        │
│ country         │
│ status          │
│ is_crawling     │
│ last_crawl_at   │
│ created_at      │
│ updated_at      │
└─────────────────┘
        │
        │ 1:N
        ▼
┌─────────────────┐
│    product      │
│─────────────────│
│ id (PK)         │
│ store_id (FK)   │
│ title           │
│ url (UNIQUE)    │
│ price           │
│ currency        │
│ image_url       │
│ category        │
│ is_available    │
│ last_available  │
│ status_change_at│
│ captured_at     │
│ created_at      │
│ updated_at      │
└─────────────────┘
```

---

## 四、数据库会话管理

### 4.1 引擎配置
```python
from sqlalchemy import create_engine

DATABASE_URL = "postgresql://myuser:mypassword@db:5432/ecommerce_db"
engine = create_engine(DATABASE_URL, echo=True)
```

**配置说明**:
- `echo=True`: 打印 SQL 语句（开发环境）
- 连接池: 使用 SQLAlchemy 默认连接池

### 4.2 会话工厂
```python
from sqlalchemy.orm import sessionmaker

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)
```

**配置说明**:
- `autocommit=False`: 手动提交事务
- `autoflush=False`: 手动刷新会话

### 4.3 依赖注入
```python
def get_db():
    """
    FastAPI 依赖函数，用于注入数据库会话
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

**使用示例**:
```python
@router.get("/stores")
async def get_stores(db: Session = Depends(get_db)):
    stores = db.query(Store).all()
    return stores
```

---

## 五、数据库初始化

### 5.1 自动创建表
```python
# app/main.py
from app.db.base import Base
from app.db.database import engine

# 应用启动时自动创建所有表
Base.metadata.create_all(bind=engine)
```

### 5.2 表创建顺序
1. `users` (无依赖)
2. `login_logs` (依赖 users)
3. `store` (无依赖)
4. `product` (依赖 store)

### 5.3 Docker 健康检查
```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U myuser -d ecommerce_db"]
  interval: 10s
  timeout: 5s
  retries: 5
```

**说明**: FastAPI 应用等待数据库健康检查通过后才启动

---

## 六、API 端点与数据库操作

### 6.1 用户认证相关

#### POST /api/v1/auth/register
**操作**: 创建新用户
```python
new_user = User(
    username=username,
    password_hash=hashed_password,
    invitation_code=generate_code(),
    invited_by=inviter_id
)
db.add(new_user)
db.commit()
```

#### POST /api/v1/auth/login
**操作**: 验证用户并记录登录日志
```python
user = db.query(User).filter(User.username == username).first()
log = LoginLog(user_id=user.id, ip_address=client_ip)
db.add(log)
db.commit()
```

### 6.2 爬虫任务管理

#### GET /api/v1/admin/crawler/tasks
**操作**: 查询所有爬虫任务
```python
tasks = db.query(Store).all()
```

#### POST /api/v1/admin/crawler/tasks
**操作**: 创建新爬虫任务
```python
new_task = Store(
    name=name,
    url=url,
    platform=platform,
    country=country,
    status="active"
)
db.add(new_task)
db.commit()
```

#### POST /api/v1/admin/crawler/tasks/{task_id}/crawl
**操作**: 启动爬虫任务
```python
task = db.query(Store).filter(Store.id == task_id).first()
task.is_crawling = True
db.commit()
# 后台任务执行爬取
```

#### DELETE /api/v1/admin/crawler/tasks/{task_id}
**操作**: 删除爬虫任务（级联删除商品）
```python
task = db.query(Store).filter(Store.id == task_id).first()
db.delete(task)  # 自动删除关联的所有商品
db.commit()
```

### 6.3 店铺查询

#### GET /api/v1/shopify/stores/search
**操作**: 模糊搜索店铺
```python
stores = db.query(Store).filter(
    (Store.name.ilike(f"%{keyword}%")) | 
    (Store.url.ilike(f"%{keyword}%"))
).offset(skip).limit(limit).all()
```

### 6.4 商品查询

#### GET /api/v1/shopify/products
**操作**: 查询商品列表
```python
products = db.query(Product).filter(
    Product.store_id == store_id
).all()
```

---

## 七、爬虫数据流程

### 7.1 爬取流程

```
1. 用户创建爬虫任务
   ↓
2. 插入 store 表
   ↓
3. 用户启动爬取
   ↓
4. 更新 store.is_crawling = True
   ↓
5. 爬虫抓取商品数据
   ↓
6. 插入/更新 product 表
   ↓
7. 更新 store.last_crawl_at
   ↓
8. 更新 store.is_crawling = False
```

### 7.2 商品数据更新逻辑

```python
# 查找现有商品
existing_product = db.query(Product).filter(
    Product.url == product_url
).first()

if existing_product:
    # 更新现有商品
    existing_product.price = new_price
    existing_product.is_available = new_availability
    
    # 检测状态变化
    if existing_product.is_available != existing_product.last_available:
        existing_product.status_change_at = datetime.now()
        existing_product.last_available = existing_product.is_available
    
    existing_product.updated_at = datetime.now()
else:
    # 创建新商品
    new_product = Product(
        store_id=store_id,
        title=title,
        url=url,
        price=price,
        is_available=True,
        last_available=True
    )
    db.add(new_product)

db.commit()
```

### 7.3 库存状态监控

**监控目标**: 追踪商品从有货到无货（或反之）的状态变化

**实现方式**:
1. 每次爬取时记录 `is_available` 状态
2. 与 `last_available` 比较
3. 如果状态改变，更新 `status_change_at`
4. 更新 `last_available` 为当前状态

**应用场景**:
- 补货提醒
- 销售趋势分析
- 热门商品识别

---

## 八、数据持久化

### 8.1 Docker Volume
```yaml
volumes:
  postgres_data:
```

**挂载位置**: `/var/lib/postgresql/data`

**说明**: 
- 数据持久化到 Docker Volume
- 容器重启不会丢失数据
- 删除容器不会删除数据

### 8.2 数据备份建议

#### 手动备份
```bash
# 导出数据库
docker exec postgres_db pg_dump -U myuser ecommerce_db > backup.sql

# 恢复数据库
docker exec -i postgres_db psql -U myuser ecommerce_db < backup.sql
```

#### 定时备份脚本
```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker exec postgres_db pg_dump -U myuser ecommerce_db > backup_$DATE.sql
```

---

## 九、数据库性能优化

### 9.1 已实现的优化

#### 索引优化
- **主键索引**: 所有表的 `id` 字段
- **唯一索引**: `users.username`, `users.invitation_code`, `store.url`, `product.url`
- **外键索引**: 自动创建外键索引

#### 查询优化
- 使用 `ilike` 进行模糊搜索
- 使用 `offset` 和 `limit` 分页
- 使用 `filter` 而不是 `filter_by` 提高灵活性

### 9.2 优化建议

#### 添加复合索引
```python
# 商品表：按店铺和类目查询
Index('idx_product_store_category', Product.store_id, Product.category)

# 商品表：按店铺和库存状态查询
Index('idx_product_store_available', Product.store_id, Product.is_available)

# 登录日志：按用户和时间查询
Index('idx_loginlog_user_time', LoginLog.user_id, LoginLog.login_at)
```

#### 查询优化
```python
# 使用 select_related 减少查询次数
from sqlalchemy.orm import joinedload

products = db.query(Product).options(
    joinedload(Product.store)
).all()
```

#### 批量操作
```python
# 批量插入
db.bulk_insert_mappings(Product, product_list)
db.commit()

# 批量更新
db.bulk_update_mappings(Product, update_list)
db.commit()
```

---

## 十、数据统计

### 10.1 当前数据规模（估算）

| 表名 | 预估记录数 | 说明 |
|------|-----------|------|
| users | 10-1000 | 用户数量 |
| login_logs | 100-10000 | 登录记录 |
| store | 10-100 | 爬虫任务数 |
| product | 1000-100000 | 商品数量 |

### 10.2 数据增长预测

**假设**:
- 每个店铺平均 1000 个商品
- 每天爬取 10 个店铺
- 每个用户平均每天登录 2 次

**月增长**:
- store: +300 条
- product: +300,000 条
- login_logs: +1,800 条（假设 30 个活跃用户）

### 10.3 存储空间估算

**单条记录大小**:
- users: ~200 bytes
- login_logs: ~100 bytes
- store: ~500 bytes
- product: ~1 KB

**总存储空间**（100个店铺，10万商品）:
- users: 200 KB
- login_logs: 1 MB
- store: 50 KB
- product: 100 MB
- **总计**: ~101 MB

---

## 十一、安全性

### 11.1 密码安全
- 使用 bcrypt 哈希算法
- 密码哈希存储在 `password_hash` 字段
- 不存储明文密码

### 11.2 SQL 注入防护
- 使用 SQLAlchemy ORM
- 参数化查询
- 自动转义特殊字符

### 11.3 访问控制
- JWT Token 认证
- 角色权限管理（user/admin）
- API 端点权限验证

### 11.4 数据库连接安全
- 密码通过环境变量配置
- Docker 网络隔离
- 数据库端口仅在必要时暴露

---

## 十二、监控与日志

### 12.1 SQL 日志
```python
# 开发环境：打印所有 SQL 语句
engine = create_engine(DATABASE_URL, echo=True)

# 生产环境：关闭 SQL 日志
engine = create_engine(DATABASE_URL, echo=False)
```

### 12.2 应用日志
- 登录日志记录在 `login_logs` 表
- 爬虫任务状态记录在 `store.status`
- 应用日志输出到 `/app/logs`

### 12.3 监控指标建议
- 数据库连接数
- 查询响应时间
- 表记录数增长
- 磁盘空间使用

---

## 十三、迁移与扩展

### 13.1 数据库迁移工具

**推荐使用 Alembic**:
```bash
# 安装
pip install alembic

# 初始化
alembic init alembic

# 创建迁移
alembic revision --autogenerate -m "Add new column"

# 执行迁移
alembic upgrade head
```

### 13.2 扩展建议

#### 新增表建议
1. **订单表** (orders): 记录用户订单
2. **收藏表** (favorites): 用户收藏的商品
3. **价格历史表** (price_history): 商品价格变化历史
4. **分类表** (categories): 商品分类管理
5. **标签表** (tags): 商品标签系统

#### 字段扩展建议
- `store` 表: 添加 `category`, `sub_category` 字段（已在前端实现）
- `product` 表: 添加 `rating`, `reviews_count` 字段
- `users` 表: 添加 `email`, `avatar` 字段

---

## 十四、故障排查

### 14.1 常见问题

#### 连接失败
```
错误: could not connect to server
解决: 检查 DATABASE_URL 中的主机名是否为 'db'
```

#### 表不存在
```
错误: relation "users" does not exist
解决: 确保 Base.metadata.create_all(bind=engine) 已执行
```

#### 外键约束错误
```
错误: violates foreign key constraint
解决: 确保外键引用的记录存在
```

### 14.2 调试命令

```bash
# 进入数据库容器
docker exec -it postgres_db psql -U myuser -d ecommerce_db

# 查看所有表
\dt

# 查看表结构
\d users

# 查看表数据
SELECT * FROM users;

# 查看外键关系
\d+ product

# 退出
\q
```

---

## 十五、总结

### 15.1 数据库特点
✅ **简洁高效**: 4张核心表，关系清晰  
✅ **扩展性强**: 易于添加新表和字段  
✅ **安全可靠**: 密码加密、SQL注入防护  
✅ **容器化部署**: Docker 一键启动  
✅ **ORM 支持**: SQLAlchemy 简化开发  

### 15.2 核心功能
- 用户认证与权限管理
- 爬虫任务管理
- 店铺数据存储
- 商品信息追踪
- 库存状态监控
- 登录日志审计

### 15.3 技术栈
- **数据库**: PostgreSQL 15
- **ORM**: SQLAlchemy
- **Web 框架**: FastAPI
- **容器化**: Docker + Docker Compose
- **语言**: Python 3.11+

---

*文档生成时间: 2026-05-14*  
*数据库版本: PostgreSQL 15*  
*ORM 版本: SQLAlchemy 2.x*
