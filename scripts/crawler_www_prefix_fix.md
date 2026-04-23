# Shopify 爬虫 WWW 前缀修复

## 修复日期
2026-04-21

## 问题描述

### 现象
部分 Shopify 店铺爬取返回 0 个商品，但实际店铺有大量商品数据。

### 根本原因
某些 Shopify 站点的 www 和非 www 版本行为不同：
- `https://www.blueland.com/products.json` → 返回 404
- `https://blueland.com/products.json` → 返回 200，正常返回商品数据

数据库中存储的 URL 如果包含 www 前缀，爬虫会访问失败的端点。

### 影响范围
所有使用 www 前缀的 Shopify 店铺都可能受影响。

## 解决方案

### 修改文件
`app/crawler/spiders/shopify.py`

### 具体改动

#### 1. `_clean_url()` 方法
```python
# 修改前：保留原始 netloc
clean_url = urlunparse((
    parsed.scheme,
    parsed.netloc,  # 保留 www
    parsed.path.rstrip('/'),
    '', '', ''
))

# 修改后：统一去除 www 前缀
netloc = parsed.netloc
if netloc.startswith('www.'):
    netloc = netloc[4:]  # 去掉 'www.'

clean_url = urlunparse((
    parsed.scheme or 'https',
    netloc,  # 使用去除 www 后的域名
    parsed.path.rstrip('/'),
    '', '', ''
))
```

#### 2. `_fetch_via_api()` 方法
```python
# 新增：去除 www 前缀
domain = self._extract_domain(url)
if domain.startswith('www.'):
    domain = domain[4:]
```

#### 3. `_fetch_via_html()` 方法
```python
# 新增：去除 www 前缀
domain = self._extract_domain(url)
if domain.startswith('www.'):
    domain = domain[4:]
```

## 技术细节

### URL 标准化策略
1. 去除所有查询参数（utm_*, gclid, fbclid 等）
2. 去除 fragment（#部分）
3. 去除末尾斜杠
4. 统一去除 www 前缀
5. 默认使用 https 协议

### 为什么要去除 www
- Shopify 平台的某些站点只在非 www 域名上提供 JSON API
- www 和非 www 可能指向不同的服务器配置
- 统一使用非 www 版本可以提高爬取成功率

## 验证方法

### 测试 Shopify 平台
```bash
# 测试非 www 版本
curl -I "https://blueland.com/products.json"
# 应返回：HTTP/2 200

# 测试 www 版本
curl -I "https://www.blueland.com/products.json"
# 可能返回：HTTP/2 404
```

### 验证是否为 Shopify
访问 `域名/products.json`：
- 返回 JSON 格式商品列表 → 标准 Shopify 平台
- 返回 404 或 HTML → 非标准 Shopify 或需要特殊处理

## 部署步骤

1. 修改 `app/crawler/spiders/shopify.py`
2. 重启后端容器：
   ```bash
   docker compose restart web
   ```
3. 在平台管理页面重新爬取受影响的店铺

## 测试结果

### 修复前
- blueland.com：0 个商品（失败）

### 修复后
- 爬虫会自动将 `https://www.blueland.com` 转换为 `https://blueland.com`
- 成功访问 `/products.json` API
- 正常获取商品数据

## 相关问题

### 其他失败店铺
1. **yeti.com**：反爬虫保护（PerimeterX）- 暂不处理
2. **vuoriclothing.com**：非标准 Shopify - 需要专门处理
3. **transpa.rent**：待测试

### 后续优化建议
1. 添加 Shopify 平台验证功能（在添加店铺时自动检测）
2. 对于非标准 Shopify 站点，开发专门的爬取策略
3. 增加爬取日志，记录失败原因便于排查

## 影响评估

### 正面影响
- 提高了爬取成功率
- 统一了 URL 格式，减少重复数据
- 自动处理 www 前缀问题

### 潜在风险
- 极少数只支持 www 版本的站点可能受影响（概率极低）
- 如遇到此类情况，可以在代码中添加特殊处理逻辑

## 总结

通过统一去除 www 前缀，解决了部分 Shopify 店铺因域名配置差异导致的爬取失败问题。这是一个简单但有效的修复，提高了爬虫的兼容性和稳定性。
