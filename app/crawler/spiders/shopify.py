from typing import Dict, Optional, List
import httpx
from playwright.async_api import async_playwright
from app.crawler.base import BaseCrawler


class ShopifyCrawler(BaseCrawler):
    """
    Shopify 专用爬虫
    
    仅针对独立站（Shopify），严禁编写任何 TikTok 爬虫代码
    """
    
    async def _fetch_via_api(self, url: str) -> Optional[Dict]:
        """
        策略一（优先）：尝试访问 Shopify JSON API
        
        - 访问 https://{domain}/collections/all.json 或 /products.json
        - 如果成功（200 OK），解析 JSON 获取商品标题、价格、图片，库存数量
        - 优点：速度快，无需浏览器
        """
        # 提取域名
        domain = url.replace("https://", "").replace("http://", "").split("/")[0]
        
        # 尝试 collections/all.json
        api_urls = [
            f"https://{domain}/collections/all.json",
            f"https://{domain}/products.json"
        ]
        
        async with httpx.AsyncClient(headers=self.headers, timeout=30.0) as client:
            for api_url in api_urls:
                try:
                    response = await client.get(api_url)
                    if response.status_code == 200:
                        data = response.json()
                        products = self._parse_json_response(data)
                        return {"products": products}
                except Exception as e:
                    print(f"尝试 {api_url} 失败: {e}")
                    continue
        
        return None
    
    def _parse_json_response(self, data: Dict) -> List[Dict]:
        """
        解析 Shopify JSON 响应，提取商品信息
        """
        products = []
        
        # 处理 collections/all.json 格式
        if "products" in data:
            for item in data["products"]:
                product = {
                    "title": item.get("title"),
                    "url": f"https://{item.get('handle')}",
                    "price": self._extract_price(item),
                    "currency": "USD",  # Shopify 默认
                    "image_url": self._extract_image(item),
                    "sales_estimate": 0  # JSON 中通常没有销量数据
                }
                products.append(product)
        
        return products
    
    def _extract_price(self, item: Dict) -> float:
        """提取价格"""
        try:
            variants = item.get("variants", [])
            if variants:
                price_str = variants[0].get("price", "0")
                return float(price_str)
        except:
            pass
        return 0.0
    
    def _extract_image(self, item: Dict) -> Optional[str]:
        """提取图片 URL"""
        images = item.get("images", [])
        if images:
            return images[0].get("src")
        return None
    
    async def _fetch_via_html(self, url: str) -> Dict:
        """
        策略二（备选）：如果 JSON 接口 404 或被禁，fallback 到 Playwright 抓取 HTML 页面
        
        - 模拟浏览器访问 /collections/all 页面
        - 解析 HTML 获取商品基础信息
        """
        products = []
        
        async with async_playwright() as p:
            browser = await p.chromium.launch(headless=True)
            page = await browser.new_page(user_agent=self.headers["User-Agent"])
            
            try:
                # 访问商品列表页
                domain = url.replace("https://", "").replace("http://", "").split("/")[0]
                collections_url = f"https://{domain}/collections/all"
                
                await page.goto(collections_url, wait_until="networkidle", timeout=30000)
                
                # 解析商品列表（根据 Shopify 常见 HTML 结构）
                product_elements = await page.query_selector_all(".product-item, .grid-product")
                
                for element in product_elements:
                    try:
                        title_el = await element.query_selector(".product-title, h3, h4")
                        price_el = await element.query_selector(".price, .product-price")
                        image_el = await element.query_selector("img")
                        link_el = await element.query_selector("a")
                        
                        product = {
                            "title": await title_el.inner_text() if title_el else "",
                            "url": await link_el.get_attribute("href") if link_el else "",
                            "price": self._parse_price_text(await price_el.inner_text() if price_el else "0"),
                            "currency": "USD",
                            "image_url": await image_el.get_attribute("src") if image_el else "",
                            "sales_estimate": 0
                        }
                        products.append(product)
                    except Exception as e:
                        print(f"解析单个商品失败: {e}")
                        continue
                
            finally:
                await browser.close()
        
        return {"products": products}
    
    def _parse_price_text(self, text: str) -> float:
        """从文本中提取价格数字"""
        import re
        match = re.search(r'[\d,]+\.?\d*', text.replace(",", ""))
        if match:
            return float(match.group())
        return 0.0
