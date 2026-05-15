# 局域网访问修复总结

## 修复时间
2026-05-06

## 问题
局域网设备无法访问 http://192.168.110.161，显示"无法连接到服务器"错误。

## 根本原因
1. nginx的 `server_name` 配置为 `localhost`，限制了只能接受localhost的请求
2. Docker端口绑定未明确指定 `0.0.0.0`，可能只监听localhost

## 修复内容

### 文件修改

1. **frontend/nginx.conf**
   - 将 `server_name localhost;` 改为 `server_name _;`
   - 这样nginx会接受所有域名和IP的请求

2. **docker-compose.yml**
   - 前端端口: `"80:80"` → `"0.0.0.0:80:80"`
   - 后端端口: `"8000:8000"` → `"0.0.0.0:8000:8000"`
   - 明确绑定到所有网络接口

### 新增文件

1. **restart_services.sh** - 服务重启脚本
2. **NETWORK_ACCESS_FIX.md** - 详细修复文档

## 执行步骤

用户需要执行以下命令来应用修复：

```bash
cd Myproject

# 停止现有服务
docker compose down

# 重新构建前端（因为nginx.conf改变了）
docker compose build frontend

# 启动服务
docker compose up -d

# 验证
docker compose ps
```

## 验证方法

1. 本地测试: `curl http://localhost`
2. 局域网测试: 从其他设备访问 `http://192.168.110.161`
3. 检查端口: `netstat -an | grep :80` 应该显示 `0.0.0.0:80`

## 注意事项

如果修复后仍无法访问，可能需要：
1. 检查macOS防火墙设置
2. 确认80端口未被其他程序占用
3. 检查Docker Desktop的网络设置
4. 查看容器日志: `docker compose logs frontend`

## 相关文档
- NETWORK_ACCESS_FIX.md - 完整的故障排查指南
- restart_services.sh - 自动化重启脚本
