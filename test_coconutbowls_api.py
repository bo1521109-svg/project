#!/usr/bin/env python3
"""测试 coconutbowls API"""
import asyncio
import httpx
import json

async def test():
    url = "https://www.coconutbowls.com"
    
    # 测试不同的 API 端点
    endpoints = [
        "/collections/all.json",
        "/products.json",
        "/collections/all/products.json"
    ]
    
    headers = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
    }
    
    async with httpx.AsyncClient(headers=headers, timeout=30.0) as client:
        for endpoint in endpoints:
            full_url = url + endpoint
            print(f"\n{'='*60}")
            print(f"测试: {full_url}")
            print('='*60)
            
            try:
                response = await client.get(full_url)
                print(f"状态码: {response.status_code}")
                
                if response.status_code == 200:
                    data = response.json()
                    print(f"数据类型: {type(data)}")
                    print(f"数据键: {data.keys() if isinstance(data, dict) else 'N/A'}")
                    
                    # 检查商品数据
                    if "products" in data:
                        products = data["products"]
                        print(f"✅ 找到 products 字段，数量: {len(products)}")
                        if products:
                            print(f"第一个商品: {products[0].get('title', 'N/A')}")
                    else:
                        print(f"⚠️ 没有 products 字段")
                        print(f"完整数据: {json.dumps(data, indent=2)[:500]}")
                else:
                    print(f"❌ 请求失败")
                    
            except Exception as e:
                print(f"❌ 错误: {e}")

if __name__ == "__main__":
    asyncio.run(test())
