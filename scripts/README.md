# Scripts 目录

本目录存放项目的测试脚本和工具脚本。

## 📁 目录说明

### 测试脚本（test_*.py）
用于测试各个功能模块的脚本，开发调试时使用。

- `test_api_crawl.sh` - API 爬取测试脚本
- `test_api_products.py` - 商品 API 测试
- `test_availability_tracking.py` - 库存状态监控测试
- `test_coconutbowls_api.py` - Coconut Bowls 店铺 API 测试
- `test_crawl.py` - 基础爬虫测试
- `test_crawl_store5.py` - 店铺5爬取测试
- `test_crawl_store5_new.py` - 店铺5新版爬虫测试
- `test_crawl_store6.py` - 店铺6爬取测试
- `test_save_store6.py` - 店铺6数据保存测试
- `test_stock_extraction.py` - 库存提取测试
- `test_store_name_api.py` - 店铺名称 API 测试

### 工具脚本
- `check_stores.py` - 检查店铺数据

## 🚀 使用方法

在 Docker 容器中运行测试脚本：

```bash
# 进入项目目录
cd Myproject

# 运行测试脚本
docker-compose exec web python scripts/test_xxx.py
```

## ⚠️ 注意事项

- 这些脚本仅用于开发和测试
- 不要在生产环境中运行
- 已执行过的数据库迁移脚本已被删除
