from typing import Dict, Optional, List
import httpx
import re
from urllib.parse import urlparse
from playwright.async_api import async_playwright
from app.crawler.base import BaseCrawler
from app.core.logging_config import logger


class ShopifyCrawler(BaseCrawler):
    """
    Shopify 专用爬虫（优化版）
    
    功能：
    1. 支持批量爬取 10+ 站点，目标 500+ 商品
    2. 自动提取类目信息
    3. 去重逻辑（基于 URL）
    4. 异常处理优化
    """
    
    async def crawl_store(self, url: str) -> Dict:
        """
        爬取店铺入口（重写父类方法）
        
        优化日志：记录"站点 URL"、"抓取商品数"、"失败原因"
        """
        logger.info(f"开始爬取站点: {url}")
        
        try:
            # 策略一：优先尝试 JSON API
            result = await self._fetch_via_api(url)
            
            if result and result.get("products"):
                product_count = len(result["products"])
                logger.info(f"✓ JSON API 成功 - 站点: {url}, 商品数: {product_count}")
                return {"success": True, "data": result, "method": "JSON API"}
            
            # 策略二：fallback 到 HTML 抓取
            logger.warning(f"JSON API 失败，fallback 到 HTML 抓取: {url}")
            result = await self._fetch_via_html(url)
            
            product_count = len(result.get("products", []))
            
            if product_count == 0:
                logger.warning(f"✗ HTML 抓取返回 0 商品 - 站点: {url}")
            else:
                logger.info(f"✓ HTML 抓取成功 - 站点: {url}, 商品数: {product_count}")
            
            return {"success": True, "data": result, "method": "HTML"}
            
        except Exception as e:
            logger.error(f"✗ 爬取失败 - 站点: {url}, 错误: {str(e)}")
            return {"success": False, "error": str(e), "data": {"products": []}}
    
    async def _fetch_via_api(self, url: str) -> Optional[Dict]:
        """
        策略一：尝试访问 Shopify JSON API
        
        优化：
        - 自动提取类目（从 URL 路径或页面包层）
        - 支持多种 API 端点格式
        """
        domain = self._extract_domain(url)
        
        # 尝试多个 API 端点
        api_urls = [
            f"https://{domain}/products.json",
            f"https://{domain}/collections/all/products.json",
            f"https://{domain}/collections/all.json"
        ]
        
        async with httpx.AsyncClient(headers=self.headers, timeout=30.0) as client:
            for api_url in api_urls:
                try:
                    response = await client.get(api_url)
                    if response.status_code == 200:
                        data = response.json()
                        
                        # 检查是否有 products 字段
                        if "products" in data and data["products"]:
                            products = self._parse_json_response(data, domain)
                            if products:
                                logger.info(f"✓ API 端点成功: {api_url}, 商品数: {len(products)}")
                                return {"products": products}
                        else:
                            logger.debug(f"API 端点 {api_url} 没有商品数据")
                            
                except Exception as e:
                    logger.debug(f"尝试 {api_url} 失败: {e}")
                    continue
        
        return None
    
    def _parse_json_response(self, data: Dict, domain: str) -> List[Dict]:
        """
        解析 Shopify JSON 响应
        
        优化：
        - 提取类目信息（从 URL 或 tags）
        - 去重逻辑（基于 URL）
        - 提取 available 状态（用于库存状态监控）
        """
        products = []
        seen_urls = set()
        
        # 处理 collections/all.json 格式
        if "products" in data:
            for item in data["products"]:
                # 构建完整 URL
                handle = item.get("handle", "")
                product_url = f"https://{domain}/products/{handle}"
                
                # 去重检查
                if product_url in seen_urls:
                    logger.debug(f"跳过重复商品: {product_url}")
                    continue
                seen_urls.add(product_url)
                
                # 提取类目
                category = self._extract_category_from_json(item)
                
                # 提取 available 状态（从 variants 中获取）
                is_available = self._extract_available(item)
                
                product = {
                    "title": item.get("title", ""),
                    "url": product_url,
                    "price": self._extract_price(item),
                    "currency": "USD",
                    "image_url": self._extract_image(item),
                    "category": category,
                    "is_available": is_available,  # 新增：库存状态
                }
                products.append(product)
        
        return products
    
    def _extract_category_from_json(self, item: Dict) -> Optional[str]:
        """
        从 JSON 数据提取类目
        
        优先级：
        1. product_type 字段
        2. tags 字段（取第一个）
        3. vendor 字段
        """
        # 优先使用 product_type
        if item.get("product_type"):
            return item["product_type"]
        
        # 其次使用 tags
        tags = item.get("tags", [])
        if tags and isinstance(tags, list):
            return tags[0]
        
        # 最后使用 vendor
        if item.get("vendor"):
            return item["vendor"]
        
        return None
    
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
    
    def _extract_stock(self, item: Dict) -> Optional[int]:
        """
        提取库存数量（已废弃）
        
        注意：Shopify 批量 API 不返回 inventory_quantity
        改用 _extract_available() 方法监控库存状态
        """
        return None
    
    def _extract_available(self, item: Dict) -> Optional[bool]:
        """
        提取库存状态（available 字段）
        
        从 variants 中提取 available 状态：
        - True: 有货
        - False: 无货
        - None: 无法确定
        
        如果有多个 variants，只要有一个有货就返回 True
        """
        try:
            variants = item.get("variants", [])
            if not variants:
                return None
            
            # 只要有一个 variant 有货，就认为商品有货
            for variant in variants:
                available = variant.get("available")
                if available is True:
                    return True
            
            # 所有 variants 都无货
            return False
            
        except Exception as e:
            logger.debug(f"提取 available 状态失败: {e}")
            return None
    
    def _extract_image(self, item: Dict) -> Optional[str]:
        """提取图片 URL"""
        images = item.get("images", [])
        if images:
            return images[0].get("src")
        return None
    
    async def _fetch_via_html(self, url: str) -> Dict:
        """
        策略二：Playwright 抓取 HTML 页面
        
        优化：
        - 从 URL 路径提取类目（如 /collections/necklaces）
        - 从页面包层提取类目名称
        - 去重逻辑
        """
        products = []
        seen_urls = set()
        domain = self._extract_domain(url)
        
        # 尝试从 URL 提取类目
        category_from_url = self._extract_category_from_url(url)
        
        async with async_playwright() as p:
            browser = await p.chromium.launch(headless=True)
            page = await browser.new_page(user_agent=self.headers["User-Agent"])
            
            try:
                # 访问商品列表页
                collections_url = f"https://{domain}/collections/all"
                await page.goto(collections_url, wait_until="networkidle", timeout=30000)
                
                # 解析商品列表
                product_elements = await page.query_selector_all(".product-item, .grid-product, .product-card")
                
                for element in product_elements:
                    try:
                        title_el = await element.query_selector(".product-title, h3, h4, .product__title")
                        price_el = await element.query_selector(".price, .product-price, .money")
                        image_el = await element.query_selector("img")
                        link_el = await element.query_selector("a")
                        
                        # 提取 URL
                        href = await link_el.get_attribute("href") if link_el else ""
                        if href and not href.startswith("http"):
                            href = f"https://{domain}{href}"
                        
                        # 去重检查
                        if href in seen_urls or not href:
                            continue
                        seen_urls.add(href)
                        
                        # 提取类目（优先使用 URL 中的类目）
                        category = category_from_url or self._extract_category_from_url(href)
                        
                        product = {
                            "title": await title_el.inner_text() if title_el else "",
                            "url": href,
                            "price": self._parse_price_text(await price_el.inner_text() if price_el else "0"),
                            "currency": "USD",
                            "image_url": await image_el.get_attribute("src") if image_el else "",
                            "category": category,
                            "sales_estimate": 0
                        }
                        products.append(product)
                    except Exception as e:
                        logger.debug(f"解析单个商品失败: {e}")
                        continue
                
            finally:
                await browser.close()
        
        return {"products": products}
    
    def _extract_category_from_url(self, url: str) -> Optional[str]:
        """
        从 URL 路径提取类目
        
        示例：
        - https://example.com/collections/necklaces -> "necklaces"
        - https://example.com/products/gold-ring -> None
        """
        try:
            path = urlparse(url).path
            match = re.search(r'/collections/([^/]+)', path)
            if match:
                category = match.group(1)
                # 美化类目名称（去掉连字符，首字母大写）
                return category.replace('-', ' ').title()
        except:
            pass
        return None
    
    def _extract_domain(self, url: str) -> str:
        """提取域名"""
        return url.replace("https://", "").replace("http://", "").split("/")[0]
    
    def _parse_price_text(self, text: str) -> float:
        """从文本中提取价格数字"""
        match = re.search(r'[\d,]+\.?\d*', text.replace(",", ""))
        if match:
            return float(match.group())
        return 0.0
    
    def _save_products(self, products: List[Dict], store_id: int):
        """
        保存商品到数据库（重写父类方法）
        
        优化：
        - 去重逻辑：基于 URL 唯一索引
        - 使用 merge() 实现 UPSERT，存在则更新，不存在则插入
        - URL 标准化处理（转小写、去除末尾斜杠、统一 https）
        - 库存状态监控：对比 last_available 和 is_available，检测状态变化
        """
        from app.models.product import Product
        from datetime import datetime
        
        saved_count = 0
        updated_count = 0
        skipped_count = 0
        status_changed_count = 0  # 状态变化计数
        
        for product_data in products:
            try:
                # URL 标准化处理
                url = product_data.get("url", "")
                url = url.lower().strip()  # 转小写，去除首尾空格
                url = url.rstrip('/')  # 去除末尾斜杠
                if url.startswith('http://'):
                    url = url.replace('http://', 'https://', 1)  # 统一使用 https
                
                if not url:
                    logger.warning(f"商品 URL 为空，跳过")
                    skipped_count += 1
                    continue
                
                # 获取当前 available 状态
                current_available = product_data.get("is_available")
                
                # 检查 URL 是否已存在
                existing = self.db.query(Product).filter(Product.url == url).first()
                
                if existing:
                    # 对比状态变化
                    if existing.is_available is not None and current_available is not None:
                        if existing.is_available != current_available:
                            # 状态发生变化（True -> False 或 False -> True）
                            status_changed_count += 1
                            existing.status_change_at = datetime.utcnow()
                            
                            # 记录状态变化日志
                            status_text = "有货 → 无货" if current_available is False else "无货 → 有货"
                            logger.info(f"🔔 商品状态变化: {existing.title} ({status_text})")
                    
                    # 更新现有商品
                    existing.title = product_data.get("title", existing.title)
                    existing.price = product_data.get("price", existing.price)
                    existing.currency = product_data.get("currency", existing.currency)
                    existing.image_url = product_data.get("image_url", existing.image_url)
                    existing.category = product_data.get("category", existing.category)
                    
                    # 更新库存状态
                    existing.last_available = existing.is_available  # 保存上次状态
                    existing.is_available = current_available  # 更新当前状态
                    
                    existing.captured_at = datetime.utcnow()
                    existing.updated_at = datetime.utcnow()
                    updated_count += 1
                    logger.debug(f"更新商品: {url}, 状态: {current_available}")
                else:
                    # 创建新商品（第一次爬取）
                    product = Product(
                        store_id=store_id,
                        title=product_data.get("title"),
                        url=url,
                        price=product_data.get("price"),
                        currency=product_data.get("currency", "USD"),
                        image_url=product_data.get("image_url"),
                        category=product_data.get("category"),
                        is_available=current_available,  # 当前状态
                        last_available=None,  # 第一次爬取，无上次状态
                        status_change_at=None,  # 第一次爬取，无状态变化
                        captured_at=datetime.utcnow()
                    )
                    
                    self.db.add(product)
                    saved_count += 1
                
            except Exception as e:
                logger.error(f"保存商品失败: {product_data.get('url')}, 错误: {e}")
                continue
        
        try:
            self.db.commit()
            logger.info(f"✓ 保存成功: 新增 {saved_count} 个, 更新 {updated_count} 个, 状态变化 {status_changed_count} 个, 跳过 {skipped_count} 个")
        except Exception as e:
            self.db.rollback()
            logger.error(f"✗ 数据库提交失败: {e}")
