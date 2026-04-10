"""
测试库存提取功能
检查 Shopify API 返回的数据结构
"""
import httpx
import json
import asyncio


async def test_coconutbowls_api():
    """测试 coconutbowls 店铺的 API"""
    domain = "coconutbowls.com"
    
    # 尝试多个 API 端点
    api_urls = [
        f"https://{domain}/products.json",
        f"https://{domain}/collections/all/products.json",
        f"https://{domain}/products/starter-set-1.json",  # 单个商品详情
    ]
    
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    }
    
    async with httpx.AsyncClient(headers=headers, timeout=30.0) as client:
        for api_url in api_urls:
            try:
                print(f"\n{'='*60}")
                print(f"测试 API: {api_url}")
                print(f"{'='*60}")
                
                response = await client.get(api_url)
                if response.status_code == 200:
                    data = response.json()
                    
                    # 处理单个商品详情 API
                    if "product" in data:
                        print(f"✓ 成功获取单个商品详情")
                        product = data["product"]
                        
                        # 检查 variants 中的库存字段
                        if "variants" in product:
                            print(f"\nVariants 数量: {len(product['variants'])}")
                            for i, variant in enumerate(product['variants'][:3]):
                                print(f"\nVariant {i+1}:")
                                print(f"  - id: {variant.get('id')}")
                                print(f"  - title: {variant.get('title')}")
                                print(f"  - price: {variant.get('price')}")
                                print(f"  - inventory_quantity: {variant.get('inventory_quantity')}")
                                print(f"  - available: {variant.get('available')}")
                                print(f"  - inventory_management: {variant.get('inventory_management')}")
                                print(f"  - inventory_policy: {variant.get('inventory_policy')}")
                        continue
                    
                    if "products" in data and data["products"]:
                        print(f"✓ 成功获取 {len(data['products'])} 个商品")
                        
                        # 打印第一个商品的完整数据结构
                        first_product = data["products"][0]
                        print(f"\n第一个商品数据结构:")
                        print(json.dumps(first_product, indent=2, ensure_ascii=False))
                        
                        # 检查 variants 中的库存字段
                        if "variants" in first_product:
                            print(f"\n\nVariants 数量: {len(first_product['variants'])}")
                            for i, variant in enumerate(first_product['variants'][:3]):  # 只看前3个
                                print(f"\nVariant {i+1}:")
                                print(f"  - id: {variant.get('id')}")
                                print(f"  - title: {variant.get('title')}")
                                print(f"  - price: {variant.get('price')}")
                                print(f"  - inventory_quantity: {variant.get('inventory_quantity')}")
                                print(f"  - available: {variant.get('available')}")
                                print(f"  - inventory_management: {variant.get('inventory_management')}")
                                print(f"  - inventory_policy: {variant.get('inventory_policy')}")
                        
                        continue
                    else:
                        print(f"✗ API 返回数据但没有 products 字段")
                else:
                    print(f"✗ HTTP {response.status_code}")
                    
            except Exception as e:
                print(f"✗ 请求失败: {e}")


if __name__ == "__main__":
    asyncio.run(test_coconutbowls_api())
