#!/bin/bash

# 验证导航配置脚本
# 用途：检查前端路由是否正确配置

echo "========== 导航配置验证 =========="
echo ""

# 检查路由文件是否存在
if [ -f "../frontend/src/router/index.js" ]; then
    echo "✓ 路由配置文件存在"
else
    echo "✗ 路由配置文件不存在"
    exit 1
fi

# 检查导航配置文件是否存在
if [ -f "../frontend/src/config/navigation.js" ]; then
    echo "✓ 导航配置文件存在"
else
    echo "✗ 导航配置文件不存在"
    exit 1
fi

# 检查占位页面是否存在
if [ -f "../frontend/src/views/Placeholder.vue" ]; then
    echo "✓ 占位页面组件存在"
else
    echo "✗ 占位页面组件不存在"
    exit 1
fi

echo ""
echo "========== 路由统计 =========="
echo ""

# 统计路由数量
TOTAL_ROUTES=$(grep -c "path:" ../frontend/src/router/index.js)
PLACEHOLDER_ROUTES=$(grep -c "component: Placeholder" ../frontend/src/router/index.js)
ADMIN_ROUTES=$(grep -c "requiresAdmin: true" ../frontend/src/router/index.js)

echo "总路由数量: $TOTAL_ROUTES"
echo "占位路由数量: $PLACEHOLDER_ROUTES"
echo "管理员专属路由: $ADMIN_ROUTES"

echo ""
echo "========== 前端容器状态 =========="
echo ""

# 检查前端容器是否运行
if docker ps | grep -q "nginx_frontend"; then
    echo "✓ 前端容器正在运行"
    echo ""
    echo "访问地址: http://localhost:8080"
    echo ""
    echo "提示: 如果看不到更新，请清除浏览器缓存（Cmd + Shift + R）"
else
    echo "✗ 前端容器未运行"
    echo "请运行: docker-compose up -d frontend"
fi

echo ""
echo "========== 验证完成 =========="
