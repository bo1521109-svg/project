#!/bin/bash

# 社媒管理 API 接口测试脚本
# 测试所有 12 个社媒管理接口是否正常工作

echo "=========================================="
echo "社媒管理 API 接口测试"
echo "=========================================="
echo ""

BASE_URL="http://localhost:8000/api/v1"
PASS_COUNT=0
FAIL_COUNT=0

# 测试函数
test_api() {
    local name=$1
    local url=$2
    
    echo -n "测试 $name ... "
    
    response=$(curl -s "$url")
    code=$(echo "$response" | python3 -c "import sys, json; print(json.load(sys.stdin).get('code', 0))" 2>/dev/null)
    placeholder=$(echo "$response" | python3 -c "import sys, json; print(json.load(sys.stdin).get('placeholder', False))" 2>/dev/null)
    
    if [ "$code" = "200" ] && [ "$placeholder" = "True" ]; then
        echo "✅ 通过"
        ((PASS_COUNT++))
    else
        echo "❌ 失败"
        echo "   响应: $response"
        ((FAIL_COUNT++))
    fi
}

echo "A. 社媒平台组（4 个接口）"
echo "-------------------------------------------"
test_api "Facebook 平台" "$BASE_URL/social/platforms/fb"
test_api "Instagram 平台" "$BASE_URL/social/platforms/ins"
test_api "Google 平台" "$BASE_URL/social/platforms/google"
test_api "YouTube 平台" "$BASE_URL/social/platforms/youtube"
echo ""

echo "B. 私域组（3 个接口）"
echo "-------------------------------------------"
test_api "Line 私域" "$BASE_URL/social/private/line"
test_api "微信私域" "$BASE_URL/social/private/wechat"
test_api "WhatsApp 私域" "$BASE_URL/social/private/whatsapp"
echo ""

echo "C. 数据看板组（1 个接口）"
echo "-------------------------------------------"
test_api "数据看板概览" "$BASE_URL/social/dashboard/overview"
echo ""

echo "D. 发布管理组（1 个接口）"
echo "-------------------------------------------"
test_api "发布管理" "$BASE_URL/social/publish/manage"
echo ""

echo "E. 互动管理组（2 个接口）"
echo "-------------------------------------------"
test_api "评论管理" "$BASE_URL/social/interaction/comments"
test_api "私信管理" "$BASE_URL/social/interaction/direct-messages"
echo ""

echo "F. 账号管理组（1 个接口）"
echo "-------------------------------------------"
test_api "账号管理" "$BASE_URL/social/accounts/manage"
echo ""

echo "=========================================="
echo "测试结果汇总"
echo "=========================================="
echo "✅ 通过: $PASS_COUNT 个"
echo "❌ 失败: $FAIL_COUNT 个"
echo "总计: $((PASS_COUNT + FAIL_COUNT)) 个接口"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo "🎉 所有接口测试通过！"
    exit 0
else
    echo "⚠️  部分接口测试失败，请检查日志"
    exit 1
fi
