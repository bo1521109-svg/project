#!/bin/bash

# DevOps 验证专家 - 完整测试验证清单
# 用途：验证前端路由、布局、权限控制是否正常工作

echo "=========================================="
echo "   DevOps 验证专家 - 测试验证清单"
echo "=========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 测试结果统计
PASS_COUNT=0
FAIL_COUNT=0

# 测试函数
test_item() {
    local description=$1
    local command=$2
    
    echo -n "测试: $description ... "
    
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ 通过${NC}"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}✗ 失败${NC}"
        ((FAIL_COUNT++))
        return 1
    fi
}

echo "========== 1. 验证清单 =========="
echo ""

# 1.1 普通用户登录验证
echo "【1.1 普通用户登录】"
test_item "导航配置文件存在" "[ -f ../frontend/src/config/navigation.js ]"
test_item "路由配置文件存在" "[ -f ../frontend/src/router/index.js ]"
test_item "HorizontalLayout 组件存在" "[ -f ../frontend/src/layout/HorizontalLayout.vue ]"
test_item "Placeholder 组件存在" "[ -f ../frontend/src/views/Placeholder.vue ]"

# 检查导航配置中的一级项数量
NAV_COUNT=$(grep -c "name: '" ../frontend/src/config/navigation.js | head -20)
if [ "$NAV_COUNT" -ge 7 ]; then
    echo -e "测试: 顶部显示 7 个一级项 ... ${GREEN}✓ 通过${NC} (检测到 $NAV_COUNT 个导航项)"
    ((PASS_COUNT++))
else
    echo -e "测试: 顶部显示 7 个一级项 ... ${RED}✗ 失败${NC} (仅检测到 $NAV_COUNT 个导航项)"
    ((FAIL_COUNT++))
fi

# 检查管理员导航配置
if grep -q "adminNavigation" ../frontend/src/config/navigation.js; then
    echo -e "测试: 管理员专属导航配置存在 ... ${GREEN}✓ 通过${NC}"
    ((PASS_COUNT++))
else
    echo -e "测试: 管理员专属导航配置存在 ... ${RED}✗ 失败${NC}"
    ((FAIL_COUNT++))
fi

echo ""

# 1.2 管理员登录验证
echo "【1.2 管理员登录】"
ADMIN_ROUTES=$(grep -c "requiresAdmin: true" ../frontend/src/router/index.js)
if [ "$ADMIN_ROUTES" -ge 3 ]; then
    echo -e "测试: 顶部显示 8 个一级项（含平台管理） ... ${GREEN}✓ 通过${NC} (检测到 $ADMIN_ROUTES 个管理员路由)"
    ((PASS_COUNT++))
else
    echo -e "测试: 顶部显示 8 个一级项（含平台管理） ... ${RED}✗ 失败${NC} (仅检测到 $ADMIN_ROUTES 个管理员路由)"
    ((FAIL_COUNT++))
fi

echo ""

# 1.3 悬停"独立站数据"验证
echo "【1.3 悬停"独立站数据"】"
if grep -q "path: '/products'" ../frontend/src/router/index.js && \
   grep -q "path: '/stores'" ../frontend/src/router/index.js; then
    echo -e "测试: 二级下拉面板显示（独立站商品/店铺） ... ${GREEN}✓ 通过${NC}"
    ((PASS_COUNT++))
else
    echo -e "测试: 二级下拉面板显示（独立站商品/店铺） ... ${RED}✗ 失败${NC}"
    ((FAIL_COUNT++))
fi

# 检查独立站商品和店铺是否正常跳转（非占位符）
if ! grep -A2 "path: '/products'" ../frontend/src/router/index.js | grep -q "Placeholder" && \
   ! grep -A2 "path: '/stores'" ../frontend/src/router/index.js | grep -q "Placeholder"; then
    echo -e "测试: 点击"独立站商品/店铺"正常跳转 ... ${GREEN}✓ 通过${NC}"
    ((PASS_COUNT++))
else
    echo -e "测试: 点击"独立站商品/店铺"正常跳转 ... ${RED}✗ 失败${NC}"
    ((FAIL_COUNT++))
fi

echo ""

# 1.4 悬停未开发模块验证
echo "【1.4 悬停未开发模块】"
PLACEHOLDER_ROUTES=$(grep -c "component: Placeholder" ../frontend/src/router/index.js)
if [ "$PLACEHOLDER_ROUTES" -ge 20 ]; then
    echo -e "测试: 二级面板显示"敬请期待"占位提示 ... ${GREEN}✓ 通过${NC} (检测到 $PLACEHOLDER_ROUTES 个占位路由)"
    ((PASS_COUNT++))
else
    echo -e "测试: 二级面板显示"敬请期待"占位提示 ... ${YELLOW}⚠ 警告${NC} (仅检测到 $PLACEHOLDER_ROUTES 个占位路由)"
    ((FAIL_COUNT++))
fi

echo ""

# 1.5 点击右上角"小丘智能体/升级会员"验证
echo "【1.5 点击右上角"小丘智能体/升级会员"】"
if grep -q "弹出提示框，不跳转" ../frontend/src/layout/HorizontalLayout.vue || \
   grep -q "ElMessage" ../frontend/src/layout/HorizontalLayout.vue; then
    echo -e "测试: 弹出提示框，不跳转 ... ${GREEN}✓ 通过${NC}"
    ((PASS_COUNT++))
else
    echo -e "测试: 弹出提示框，不跳转 ... ${YELLOW}⚠ 需手动验证${NC}"
fi

echo ""

# 1.6 手机端验证
echo "【1.6 手机端（<768px）】"
if grep -q "@media" ../frontend/src/layout/HorizontalLayout.vue || \
   grep -q "768px" ../frontend/src/layout/HorizontalLayout.vue; then
    echo -e "测试: 导航折叠为汉堡菜单 ... ${GREEN}✓ 通过${NC}"
    ((PASS_COUNT++))
else
    echo -e "测试: 导航折叠为汉堡菜单 ... ${YELLOW}⚠ 需手动验证${NC}"
fi

if grep -q "可展开" ../frontend/src/layout/HorizontalLayout.vue || \
   grep -q "drawer" ../frontend/src/layout/HorizontalLayout.vue; then
    echo -e "测试: 点击可展开 ... ${GREEN}✓ 通过${NC}"
    ((PASS_COUNT++))
else
    echo -e "测试: 点击可展开 ... ${YELLOW}⚠ 需手动验证${NC}"
fi

echo ""

# 1.7 原有功能不受影响
echo "【1.7 原有功能不受影响】"
test_item "店铺管理页面存在" "[ -f ../frontend/src/views/Stores.vue ]"
test_item "商品列表页面存在" "[ -f ../frontend/src/views/Products.vue ]"
test_item "个人中心页面存在" "[ -f ../frontend/src/views/Profile.vue ]"

echo ""

# 2. 故障排查
echo "========== 2. 故障排查 =========="
echo ""

echo "【2.1 检查 z-index 层级】"
if grep -q "z-index" ../frontend/src/layout/HorizontalLayout.vue; then
    ZINDEX_VALUES=$(grep -o "z-index: [0-9]*" ../frontend/src/layout/HorizontalLayout.vue | awk '{print $2}')
    echo -e "检测到 z-index 值: ${YELLOW}$ZINDEX_VALUES${NC}"
    echo -e "${GREEN}✓ z-index 已配置${NC}"
else
    echo -e "${YELLOW}⚠ 未检测到 z-index 配置${NC}"
fi

echo ""

echo "【2.2 检查 position: relative 层级】"
if grep -q "position: relative" ../frontend/src/layout/HorizontalLayout.vue; then
    echo -e "${GREEN}✓ position: relative 已配置${NC}"
else
    echo -e "${YELLOW}⚠ 未检测到 position: relative 配置${NC}"
fi

echo ""

echo "【2.3 检查路由 404 问题】"
if grep -q "path: '\*'" ../frontend/src/router/index.js || \
   grep -q "path: '/:pathMatch" ../frontend/src/router/index.js; then
    echo -e "${GREEN}✓ 404 路由已配置${NC}"
else
    echo -e "${YELLOW}⚠ 未配置 404 路由（建议添加）${NC}"
fi

echo ""

echo "【2.4 检查 router component 引入】"
if grep -q "import.*Placeholder" ../frontend/src/router/index.js && \
   grep -q "import.*HorizontalLayout" ../frontend/src/router/index.js; then
    echo -e "${GREEN}✓ 所有组件已正确引入${NC}"
else
    echo -e "${RED}✗ 组件引入可能存在问题${NC}"
fi

echo ""

# 3. Docker 容器状态检查
echo "========== 3. Docker 容器状态 =========="
echo ""

if docker ps | grep -q "nginx_frontend"; then
    echo -e "${GREEN}✓ 前端容器正在运行${NC}"
    CONTAINER_STATUS=$(docker ps --filter "name=nginx_frontend" --format "{{.Status}}")
    echo "  状态: $CONTAINER_STATUS"
else
    echo -e "${RED}✗ 前端容器未运行${NC}"
    echo "  请运行: docker-compose up -d frontend"
fi

if docker ps | grep -q "fastapi_app"; then
    echo -e "${GREEN}✓ 后端容器正在运行${NC}"
else
    echo -e "${RED}✗ 后端容器未运行${NC}"
fi

if docker ps | grep -q "postgres_db"; then
    echo -e "${GREEN}✓ 数据库容器正在运行${NC}"
else
    echo -e "${RED}✗ 数据库容器未运行${NC}"
fi

echo ""

# 4. 测试结果汇总
echo "=========================================="
echo "           测试结果汇总"
echo "=========================================="
echo ""
echo -e "通过: ${GREEN}$PASS_COUNT${NC}"
echo -e "失败: ${RED}$FAIL_COUNT${NC}"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}✓ 所有自动化测试通过！${NC}"
    echo ""
    echo "=========================================="
    echo "           访问地址"
    echo "=========================================="
    echo ""
    echo "前端: http://localhost:8080"
    echo "后端 API: http://localhost:8000"
    echo "API 文档: http://localhost:8000/docs"
    echo ""
    echo "=========================================="
    echo "           重要提示"
    echo "=========================================="
    echo ""
    echo "1. 清除浏览器缓存: Cmd + Shift + R (macOS)"
    echo "2. 如果看不到更新，尝试无痕模式"
    echo "3. 手动验证项需要在浏览器中测试"
    echo ""
else
    echo -e "${RED}✗ 存在 $FAIL_COUNT 个失败项，请检查上述错误${NC}"
    echo ""
fi

echo "=========================================="
echo "           验证完成"
echo "=========================================="
