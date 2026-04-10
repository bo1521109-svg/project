"""
测试商品 API 是否返回 is_available 字段
"""
import httpx
import json


def test_products_api():
    """测试商品 API"""
    # 先登录获取 token
    login_data = {
        "username": "testuser",
        "password": "testpass123"
    }
    
    with httpx.Client(base_url="http://localhost:8000") as client:
        # 登录
        response = client.post("/api/v1/auth/login", data=login_data)
        if response.status_code != 200:
            print(f"登录失败: {response.status_code}")
            return
        
        token = response.json()["access_token"]
        headers = {"Authorization": f"Bearer {token}"}
        
        # 获取店铺 6 的商品
        response = client.get("/api/v1/products/", params={"store_id": 6, "limit": 5}, headers=headers)
        
        if response.status_code == 200:
            products = response.json()
            print(f"✓ 成功获取 {len(products)} 个商品\n")
            
            for product in products:
                print(f"商品: {product['title']}")
                print(f"  - is_available: {product.get('is_available')}")
                print(f"  - last_available: {product.get('last_available')}")
                print(f"  - status_change_at: {product.get('status_change_at')}")
                print()
        else:
            print(f"✗ 请求失败: {response.status_code}")
            print(response.text)


if __name__ == "__main__":
    test_products_api()
