# 竖向侧边栏到横向导航的API复用映射

**目标**: 将竖向侧边栏中可复用的菜单项，直接复用横向导航已有的路由和API接口

---

## 可复用菜单项映射表

| 竖向侧边栏菜单 | 横向导航对应菜单 | 复用路由路径 | 复用API接口 | 状态 |
|--------------|----------------|------------|-----------|------|
| 数据大盘 > 品类大盘 | TikTok大盘 > 品类大盘 | `/tiktok/category/overview` | `GET /api/v1/category_overview` | ✅ 可复用 |
| 数据大盘 > 商品大盘 | TikTok大盘 > 商品大盘 | `/tiktok/product/overview` | `GET /api/v1/product_overview` | ✅ 可复用 |
| 数据大盘 > 店铺大盘 | TikTok大盘 > 店铺大盘 | `/tiktok/store/overview` | `GET /api/v1/store_overview` | ✅ 可复用 |
| 商品 > 商品搜索 | 选爆品 > 商品搜索 | `/tiktok/products` | `GET /api/v1/product_search` | ✅ 可复用 |
| 商品 > 销量榜 | 选爆品 > 商品销量榜 | `/tiktok/products/sales-rank` | `GET /api/v1/product_sales_rank` | ✅ 可复用 |
| 商品 > 新品榜 | 选爆品 > 潜力新品榜 | `/tiktok/products/potential-new` | `GET /api/v1/product_potential_new` | ✅ 可复用 |
| 店铺 > 店铺搜索 | 盯爆店 > 店铺搜索 | `/tiktok/stores` | `GET /api/v1/store_search` | ✅ 可复用 |
| 店铺 > 销量榜 | 盯爆店 > 店铺爆卖榜 | `/tiktok/stores/best-sellers` | `GET /api/v1/store_best_sellers` | ✅ 可复用 |
| 达人 > 达人搜索 | 选达人 > 达人搜索 | `/tiktok/influencers` | `GET /api/v1/tk_inf_search` | ✅ 可复用 |
| 达人 > 带货达人榜 | 选达人 > 带货达人榜 | `/tiktok/influencers/sales-rank` | `GET /api/v1/tk_inf_sales_rank` | ✅ 可复用 |
| 达人 > 涨粉达人榜 | 选达人 > 涨粉达人榜 | `/tiktok/influencers/follower-rank` | `GET /api/v1/tk_inf_follower_rank` | ✅ 可复用 |
| 达人 > 达人机构榜 | 选达人 > 达人机构榜 | `/tiktok/influencers/agency-rank` | `GET /api/v1/tk_inf_agency_rank` | ✅ 可复用 |
| 视频 > AI视频 | 找视频 > AI爆款 | `/tiktok/videos/ai` | `GET /api/v1/tk_video_ai` | ✅ 可复用 |
| 广告 > 广告搜索 | 找视频 > 广告搜索 | `/tiktok/videos/ads` | `GET /api/v1/tk_video_ads` | ✅ 可复用 |

**总计**: 14个菜单项可直接复用

---

## 暂不处理的菜单项（无对应横向接口）

| 竖向侧边栏菜单 | 原因 | 状态 |
|--------------|------|------|
| 商品 > 热推榜 | 横向无对应接口 | ⏸️ 暂不处理 |
| 商品 > 历史同期榜 | 横向无对应接口 | ⏸️ 暂不处理 |
| 商品 > 亚马逊搜索 | 横向无对应接口 | ⏸️ 暂不处理 |
| 商品 > TikTok搜索 | 横向无对应接口 | ⏸️ 暂不处理 |
| 店铺 > 热推榜 | 横向无对应接口 | ⏸️ 暂不处理 |
| 视频 > 热门视频 | 横向无对应接口 | ⏸️ 暂不处理 |
| 直播 > 直播搜索 | 横向无对应接口 | ⏸️ 暂不处理 |
| 外贸 | 非TikTok数据模块 | ⏸️ 暂不处理 |
| 服务商 | 非TikTok数据模块 | ⏸️ 暂不处理 |
| 我的 | 非TikTok数据模块 | ⏸️ 暂不处理 |
| 购买续费 | 非TikTok数据模块 | ⏸️ 暂不处理 |
| 账户中心 | 非TikTok数据模块 | ⏸️ 暂不处理 |

---

## 实施方案

### 步骤1: 更新sidebar组件的菜单索引

将可复用的菜单项的`index`值改为对应的横向路由路径，这样点击时会自动跳转到正确的路由。

### 步骤2: 更新handleMenuSelect方法

确保点击菜单项时正确跳转到对应路由。

### 步骤3: 测试验证

逐个测试14个可复用菜单项，确保：
- 点击后正确跳转
- 页面正常加载
- API接口正常调用
- 数据正常显示

---

**文档版本**: v1.0  
**创建日期**: 2026-04-17  
**状态**: 待实施
