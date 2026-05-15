#!/bin/bash

echo "停止现有容器..."
docker compose down

echo "重新构建前端镜像..."
docker compose build frontend

echo "启动所有服务..."
docker compose up -d

echo "等待服务启动..."
sleep 5

echo "检查服务状态..."
docker compose ps

echo ""
echo "服务已重启！"
echo "本地访问: http://localhost"
echo "局域网访问: http://192.168.110.161 (或你的实际IP)"
echo ""
echo "如果局域网仍无法访问，请检查："
echo "1. 防火墙设置 (macOS: 系统偏好设置 > 安全性与隐私 > 防火墙)"
echo "2. 确保80端口未被其他程序占用"
echo "3. 使用 'docker compose logs frontend' 查看日志"
