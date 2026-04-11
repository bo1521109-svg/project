#!/bin/bash
# 测试爬虫 API 接口

# 先获取 token（使用你的用户名和密码）
echo "=== 1. 登录获取 Token ==="
TOKEN_RESPONSE=$(curl -s -X POST "http://localhost/api/v1/auth/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=xiaxia&password=123456")

echo "登录响应: $TOKEN_RESPONSE"

TOKEN=$(echo $TOKEN_RESPONSE | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "❌ 获取 Token 失败"
  exit 1
fi

echo "✅ Token: ${TOKEN:0:20}..."
echo ""

# 触发店铺 5 的爬取
echo "=== 2. 触发店铺 5 爬取 ==="
curl -X POST "http://localhost/api/v1/stores/5/crawl" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json"

echo ""
echo ""

# 等待 3 秒
echo "=== 3. 等待 3 秒 ==="
sleep 3

# 查看店铺状态
echo "=== 4. 查看店铺 5 状态 ==="
curl -s "http://localhost/api/v1/stores/5" \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool

echo ""
