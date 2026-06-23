#!/bin/bash
# project-main 分支 Docker 启动脚本（使用预构建镜像）
# 容器命名 _main 后缀，端口与主工程隔离

set -e
cd "$(dirname "$0")"

echo "==================================="
echo "  project-main 容器启动"
echo "==================================="

# 停止并清理旧容器
echo "[1/3] 清理旧容器..."
docker stop postgres_db_main fastapi_app_main nginx_frontend_main 2>/dev/null || true
docker rm postgres_db_main fastapi_app_main nginx_frontend_main 2>/dev/null || true

# 拉取预构建镜像（如果本地没有）
echo "[2/3] 拉取镜像..."
docker pull heiheioi/myproject-web:latest &
docker pull heiheioi/myproject-frontend:latest &
docker pull postgres:15 &
wait

# 启动
echo "[3/3] 启动容器..."
docker-compose -p project-main up -d

echo ""
echo "==================================="
echo "  访问地址："
echo "  前端界面 : http://localhost:8080"
echo "  后端 API  : http://localhost:8001"
echo "  Swagger  : http://localhost:8001/docs"
echo "==================================="
echo ""
echo "查看日志: docker-compose -p project-main logs -f"
echo "查看状态: docker-compose -p project-main ps"
echo "停止项目: docker-compose -p project-main down"
