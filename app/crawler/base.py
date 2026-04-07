from abc import ABC, abstractmethod
from typing import List, Dict, Optional
import httpx
from sqlalchemy.orm import Session


class BaseCrawler(ABC):
    """
    爬虫基类 - 定义统一入口 crawl_store(url)
    
    策略：优先使用 API 接口，如果失败则 fallback 到 Playwright 抓取 HTML
    """
    
    def __init__(self, db: Session):
        self.db = db
        self.headers = {
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
        }
    
    async def crawl_store(self, url: str) -> Dict:
        """
        统一入口：爬取店铺数据
        
        Args:
            url: 店铺 URL
            
        Returns:
            包含店铺和商品数据的字典
        """
        # 策略一（优先）：尝试 JSON API
        try:
            data = await self._fetch_via_api(url)
            if data:
                return {"source": "api", "data": data}
        except Exception as e:
            print(f"API 接口失败: {e}，fallback 到 HTML 抓取")
        
        # 策略二（备选）：使用 Playwright 抓取 HTML
        try:
            data = await self._fetch_via_html(url)
            return {"source": "html", "data": data}
        except Exception as e:
            raise Exception(f"HTML 抓取也失败: {e}")
    
    @abstractmethod
    async def _fetch_via_api(self, url: str) -> Optional[Dict]:
        """
        策略一：通过 JSON API 获取数据（速度快，无需浏览器）
        子类必须实现此方法
        """
        pass
    
    @abstractmethod
    async def _fetch_via_html(self, url: str) -> Dict:
        """
        策略二：通过 Playwright 抓取 HTML 页面
        子类必须实现此方法
        """
        pass
    
    def _save_products(self, products: List[Dict], store_id: int):
        """
        数据保存：将抓取到的数据匹配到 Product 模型
        
        库存处理：如果 JSON 中有库存数据，存入 stock 字段（如果没有该字段则暂存到 raw_data）
        """
        from app.models.product import Product
        
        for product_data in products:
            # 检查商品是否已存在
            existing = self.db.query(Product).filter(
                Product.url == product_data.get("url")
            ).first()
            
            if existing:
                # 更新现有商品
                for key, value in product_data.items():
                    setattr(existing, key, value)
            else:
                # 创建新商品
                product = Product(
                    store_id=store_id,
                    title=product_data.get("title"),
                    url=product_data.get("url"),
                    price=product_data.get("price"),
                    currency=product_data.get("currency", "USD"),
                    image_url=product_data.get("image_url"),
                    sales_estimate=product_data.get("sales_estimate", 0)
                )
                self.db.add(product)
        
        self.db.commit()
