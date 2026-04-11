#!/bin/bash
# 测试商品 API 是否返回 store_name 字段

echo "=========================================="
echo "测试商品 API - 检查 store_name 字段"
echo "=========================================="

# 1. 登录获取 token
echo -e "\n1. 登录..."
LOGIN_RESPONSE=$(curl -s -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test123"}')

TOKEN=$(echo $LOGIN_RESPONSE | python3 -c "import sys, json; print(json.load(sys.stdin)['access_token'])" 2>/dev/null)

if [ -z "$TOKEN" ]; then
  echo "❌ 登录失败"
  echo "$LOGIN_RESPONSE"
  exit 1
fi

echo "✅ 登录成功"

# 2. 获取商品列表
echo -e "\n2. 获取商品列表（前3个）..."
PRODUCTS_RESPONSE=$(curl -s -X GET "http://localhost:8000/api/v1/products/?limit=3" \
  -H "Authorization: Bearer $TOKEN")

# 3. 检查 store_name 字段
echo -e "\n3. 检查返回数据:\n"
echo "$PRODUCTS_RESPONSE" | python3 -c "
import sys, json

try:
    products = json.load(sys.stdin)
    print(f'✅ 成功获取 {len(products)} 个商品\n')
    
    for i, p in enumerate(products, 1):
        print(f'商品 {i}:')
        print(f'  ID: {p[\"id\"]}')
        print(f'  标题: {p[\"title\"][:40]}...')
        print(f'  store_id: {p[\"store_id\"]}')
        
        if 'store_name' in p:
            if p['store_name']:
                print(f'  store_name: {p[\"store_name\"]} ✅')
            else:
                print(f'  store_name: None ⚠️')
        else:
            print(f'  store_name: ❌ 字段不存在')
        print()
except Exception as e:
    print(f'❌ 解析失败: {e}')
    print(sys.stdin.read())
"

echo "=========================================="
