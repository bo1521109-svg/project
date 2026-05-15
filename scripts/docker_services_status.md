# Docker 服务状态报告

**生成时间**: 2026-04-23

## 服务概览

所有 Docker 服务已成功启动并运行中！

### 服务列表

| 服务名称 | 容器名称 | 镜像 | 状态 | 端口映射 |
|---------|---------|------|------|---------|
| db | postgres_db | postgres:15 | ✅ Up 2 weeks (healthy) | 5432:5432 |
| web | fastapi_app | myproject-web | ✅ Up 30 hours | 8000:8000 |
| frontend | nginx_frontend | myproject-frontend | ✅ Up (刚重启) | 80:80 |

## 访问地址

### 前端应用
- **URL**: http://localhost
- **端口**: 80
- **状态**: ✅ 运行中
- **说明**: 新的纵向布局已部署

### 后端 API
- **URL**: http://localhost:8000
- **端口**: 8000
- **状态**: ✅ 运行中
- **文档**: http://localhost:8000/docs

### 数据库
- **主机**: localhost
- **端口**: 5432
- **数据库**: 根据 .env 配置
- **状态**: ✅ 健康运行

## 最近操作

1. ✅ 检查 Docker 和 Docker Compose 版本
   - Docker: v29.3.1
   - Docker Compose: v5.1.1

2. ✅ 检查服务运行状态
   - 所有服务正常运行

3. ✅ 重启前端服务
   - 应用新的纵向布局更改
   - 重启成功

## 服务日志

### 后端服务 (FastAPI)
- 最新日志显示 API 请求正常处理
- 数据库查询正常执行
- 用户认证功能正常

### 前端服务 (Nginx)
- 静态资源正常提供
- 路由正常工作
- 最近访问: /tiktok/product/overview

### 数据库服务 (PostgreSQL)
- 健康检查通过
- 连接正常

## 测试新布局

### 访问步骤
1. 打开浏览器访问: http://localhost
2. 使用测试账号登录
3. 查看新的纵向布局：
   - 左侧一级导航（80px）
   - 右侧二级导航（240px，可折叠）
   - 主内容区域

### 测试要点
- [ ] 登录功能
- [ ] 一级导航切换
- [ ] 选品模块平台切换（TikTok/独立站）
- [ ] 二级导航显示和折叠
- [ ] 路由跳转
- [ ] 权限控制（管理员/普通用户）

## 常用命令

### 查看服务状态
```bash
cd Myproject
docker compose ps
```

### 查看服务日志
```bash
# 查看所有服务日志
docker compose logs

# 查看特定服务日志
docker compose logs web
docker compose logs frontend
docker compose logs db

# 实时查看日志
docker compose logs -f
```

### 重启服务
```bash
# 重启所有服务
docker compose restart

# 重启特定服务
docker compose restart frontend
docker compose restart web
```

### 停止服务
```bash
docker compose stop
```

### 启动服务
```bash
docker compose up -d
```

### 重新构建并启动
```bash
docker compose up -d --build
```

## 故障排查

### 前端无法访问
1. 检查容器状态: `docker compose ps`
2. 查看日志: `docker compose logs frontend`
3. 重启服务: `docker compose restart frontend`

### 后端 API 错误
1. 查看日志: `docker compose logs web`
2. 检查数据库连接: `docker compose logs db`
3. 重启服务: `docker compose restart web`

### 数据库连接失败
1. 检查健康状态: `docker compose ps`
2. 查看日志: `docker compose logs db`
3. 检查 .env 配置

## 性能监控

### 查看资源使用
```bash
docker stats
```

### 查看容器详情
```bash
docker compose top
```

## 下一步

1. 在浏览器中测试新布局
2. 验证所有功能正常工作
3. 检查控制台是否有错误
4. 测试不同用户角色的权限

## 注意事项

- ⚠️ 前端服务已重启以应用新的布局更改
- ⚠️ 如果看不到新布局，请清除浏览器缓存（Ctrl+Shift+R 或 Cmd+Shift+R）
- ⚠️ 确保 .env 文件配置正确
- ⚠️ 数据库已运行 2 周，建议定期备份

---

**状态**: ✅ 所有服务正常运行  
**布局**: ✅ 新的纵向布局已部署  
**准备就绪**: ✅ 可以开始测试

