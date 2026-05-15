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
    5. 任务配置驱动：读取任务配置的"目标国家"和"目标类目"，自动打标
    """
    
    def __init__(self, db, task_config: dict = None):
        """
        初始化爬虫
        
        Args:
            db: 数据库会话
            task_config: 任务配置字典，包含：
                - target_country_code: 目标国家代码
                - target_category_code: 目标类目代码
                - platform_code: 平台代码
        """
        super().__init__(db)
        self.task_config = task_config or {}
        
        # 记录任务配置
        if self.task_config.get("target_country_code") or self.task_config.get("target_category_code"):
            logger.info(f"🏷️ 爬虫任务配置: 国家={self.task_config.get('target_country_code')}, "
                       f"类目={self.task_config.get('target_category_code')}")
    
    async def crawl_store(self, url: str) -> Dict:
        """
        爬取店铺入口（重写父类方法）
        
        优化日志：记录"站点 URL"、"抓取商品数"、"失败原因"
        """
        # 清理URL中的跟踪参数
        clean_url = self._clean_url(url)
        logger.info(f"开始爬取站点: {clean_url}")
        if clean_url != url:
            logger.info(f"URL已清理，原始URL: {url}")
        
        try:
            # 策略一：优先尝试 JSON API
            result = await self._fetch_via_api(clean_url)
            
            if result and result.get("products"):
                product_count = len(result["products"])
                logger.info(f"✓ JSON API 成功 - 站点: {clean_url}, 商品数: {product_count}")
                return {"success": True, "data": result, "method": "JSON API"}
            
            # 策略二：fallback 到 HTML 抓取
            logger.warning(f"JSON API 失败，fallback 到 HTML 抓取: {clean_url}")
            result = await self._fetch_via_html(clean_url)
            
            product_count = len(result.get("products", []))
            
            if product_count == 0:
                logger.warning(f"✗ HTML 抓取返回 0 商品 - 站点: {clean_url}")
                logger.warning(f"可能原因：1) 非Shopify站点 2) 反爬保护 3) 需要登录")
            else:
                logger.info(f"✓ HTML 抓取成功 - 站点: {clean_url}, 商品数: {product_count}")
            
            return {"success": True, "data": result, "method": "HTML"}
            
        except Exception as e:
            logger.error(f"✗ 爬取失败 - 站点: {clean_url}, 错误: {str(e)}")
            return {"success": False, "error": str(e), "data": {"products": []}}
    
    def _clean_url(self, url: str) -> str:
        """
        清理URL中的跟踪参数和无用参数
        
        保留的参数：无（清理所有查询参数）
        移除的参数：utm_*, gclid, fbclid, srsltid, gbraid, gad_*, tw_*, 等
        同时统一去除 www. 前缀（某些 Shopify 站点 www 和非 www 行为不同）
        """
        from urllib.parse import urlparse, urlunparse
        
        try:
            parsed = urlparse(url)
            
            # 去除 www. 前缀，统一 URL 格式
            netloc = parsed.netloc
            if netloc.startswith('www.'):
                netloc = netloc[4:]  # 去掉 'www.'
            
            # 重建URL，去掉所有查询参数和fragment
            clean_url = urlunparse((
                parsed.scheme or 'https',  # 默认使用 https
                netloc,
                parsed.path.rstrip('/'),  # 移除末尾斜杠
                '',  # params
                '',  # query (清空所有查询参数)
                ''   # fragment
            ))
            return clean_url
        except Exception as e:
            logger.warning(f"URL清理失败: {e}，使用原始URL")
            return url
    
    async def _fetch_via_api(self, url: str) -> Optional[Dict]:
        """
        策略一：尝试访问 Shopify JSON API
        
        优化：
        - 自动提取类目（从 URL 路径或页面包层）
        - 支持多种 API 端点格式
        - 自动去除 www. 前缀（某些站点 www 和非 www 行为不同）
        """
        domain = self._extract_domain(url)
        
        # 去除 www. 前缀
        if domain.startswith('www.'):
            domain = domain[4:]
        
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
        - 自动去除 www. 前缀
        """
        products = []
        seen_urls = set()
        domain = self._extract_domain(url)
        
        # 去除 www. 前缀
        if domain.startswith('www.'):
            domain = domain[4:]
        
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
        
        逻辑变更：
        - 商品已存在：执行 UPDATE，更新 is_available, price, captured_at
        - 如果 is_available 发生变化：更新 last_available 和 status_change_at
        - 商品不存在：执行 INSERT
        - URL 标准化处理（转小写、去除末尾斜杠、统一 https、去除 www.）
        - 自动打标：读取任务配置，自动填充 country_code, category_code, platform_code
        """
        from app.models.product import Product
        from datetime import datetime
        
        inserted_count = 0  # 新增商品数
        updated_count = 0   # 更新商品数
        
        # 从任务配置读取标准化字段
        target_country_code = self.task_config.get("target_country_code")
        target_category_code = self.task_config.get("target_category_code")
        platform_code = self.task_config.get("platform_code", "shopify")
        
        for product_data in products:
            try:
                # URL 标准化处理
                url = product_data.get("url", "")
                url = url.lower().strip()  # 转小写，去除首尾空格
                url = url.rstrip('/')  # 去除末尾斜杠
                if url.startswith('http://'):
                    url = url.replace('http://', 'https://', 1)  # 统一使用 https
                # 去除 www. 前缀，统一 URL 格式
                url = url.replace('https://www.', 'https://')
                
                if not url:
                    logger.warning(f"商品 URL 为空，跳过")
                    continue
                
                # 获取当前爬取的数据
                current_available = product_data.get("is_available")
                current_price = product_data.get("price")
                current_time = datetime.utcnow()
                
                # 检查商品是否已存在
                existing = self.db.query(Product).filter(Product.url == url).first()
                
                if existing:
                    # 商品已存在：执行 UPDATE
                    old_available = existing.is_available
                    
                    # 更新基础字段
                    existing.is_available = current_available
                    existing.price = current_price
                    existing.captured_at = current_time
                    
                    # 自动打标：如果任务配置了目标类目，则更新商品的类目代码
                    if target_category_code:
                        existing.category_code = target_category_code
                        existing.data_source = "task_config"
                    
                    # 检查库存状态是否发生变化
                    if old_available is not None and current_available is not None:
                        if old_available != current_available:
                            # 状态发生变化：更新 last_available 和 status_change_at
                            existing.last_available = old_available
                            existing.status_change_at = current_time
                            logger.info(f"✓ 库存状态变化: {existing.title[:30]}... | {old_available} → {current_available}")
                    
                    updated_count += 1
                    logger.debug(f"更新商品: {url}")
                    
                else:
                    # 商品不存在：执行 INSERT
                    # 自动打标：优先使用任务配置，如果未配置则使用兜底值（NULL）
                    product = Product(
                        store_id=store_id,
                        title=product_data.get("title"),
                        url=url,
                        price=current_price,
                        currency=product_data.get("currency", "USD"),
                        image_url=product_data.get("image_url"),
                        category=product_data.get("category"),  # 旧字段，兼容保留
                        category_code=target_category_code,  # 新字段：任务配置驱动
                        platform_code=platform_code,  # 新字段：任务配置驱动
                        is_available=current_available,  # 当前状态
                        last_available=current_available,  # 第一次爬取，last_available = is_available
                        status_change_at=None,  # 第一次爬取，无状态变化
                        captured_at=current_time,
                        data_source="task_config" if target_category_code else None  # 标记数据来源
                    )
                    
                    self.db.add(product)
                    inserted_count += 1
                    logger.debug(f"新增商品: {url}")
                
            except Exception as e:
                logger.error(f"保存商品失败: {product_data.get('url')}, 错误: {e}")
                continue
        
        try:
            self.db.commit()
            logger.info(f"✓ 保存成功: 新增 {inserted_count} 个, 更新 {updated_count} 个")
            
            # 打标统计
            if target_category_code:
                logger.info(f"🏷️ 自动打标: category_code={target_category_code}, 影响 {inserted_count + updated_count} 个商品")
            else:
                logger.info(f"⚠️ 未配置目标类目，商品 category_code 为 NULL")
                
        except Exception as e:
            self.db.rollback()
            logger.error(f"✗ 数据库提交失败: {e}")
