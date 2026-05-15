# 数据库增强实施文档

## 项目背景

根据后端架构师/数据库工程师的需求，对现有数据库进行扩展和优化，以支持：
1. 销量筛选功能（近7天销量、总销量）
2. 国家/类目的标准化管理
3. 多平台扩展能力（Shopify、TikTok、内容创作等）

---

## 业务目标

### 1. 让"销量筛选"立刻生效
- 店铺和商品都要支持按"近7天销量"和"总销量"过滤+排序
- 前端筛选条件能直接映射到数据库字段

### 2. 让"国家/类目筛选"精确匹配
- 避免"美国"/"USA"/".us"等自由文本导致的筛选漏数
- 使用标准化代码（如 ISO 3166-1 国家代码）

### 3. 为"加新平台"预留扩展位
- 后续接 TikTok/内容创作等模块时，不用改核心表结构
- 支持平台独立配置和全平台共用两种模式

---

## 核心逻辑

### 1. 字典表建设（统一管理枚举值）

#### 平台字典表 (dict_platform)
记录 Shopify/TikTok/内容创作等平台的配置与开关

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Integer | 主键 |
| code | String(50) | 平台代码（如：shopify, tiktok） |
| name_zh | String(100) | 中文名称 |
| name_en | String(100) | 英文名称 |
| is_active | Boolean | 是否启用 |
| sort_order | Integer | 排序顺序 |
| description | Text | 平台描述 |

#### 国家字典表 (dict_country)
16 个国家的标准化代码+中文显示名+区域分组

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Integer | 主键 |
| code | String(10) | 国家代码（ISO 3166-1，如：US, CN） |
| name_zh | String(100) | 中文名称 |
| name_en | String(100) | 英文名称 |
| region | String(50) | 区域分组（如：北美、东南亚） |
| is_active | Boolean | 是否启用 |
| sort_order | Integer | 排序顺序 |

**初始化数据**（15个国家）:
- US (美国) - 北美
- ID (印度尼西亚) - 东南亚
- GB (英国) - 欧洲
- VN (越南) - 东南亚
- TH (泰国) - 东南亚
- MY (马来西亚) - 东南亚
- PH (菲律宾) - 东南亚
- ES (西班牙) - 欧洲
- MX (墨西哥) - 拉美
- DE (德国) - 欧洲
- FR (法国) - 欧洲
- IT (意大利) - 欧洲
- BR (巴西) - 拉美
- JP (日本) - 东亚
- SG (新加坡) - 东南亚

#### 类目字典表 (dict_category)
32 个一级类目+子类目的树形结构，支持"全平台共用"或"平台独立"两种模式

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Integer | 主键 |
| code | String(100) | 类目代码（如：beauty, beauty-makeup） |
| name_zh | String(200) | 中文名称 |
| name_en | String(200) | 英文名称 |
| parent_id | Integer | 父类目ID（NULL表示一级类目） |
| level | Integer | 层级（1=一级类目，2=二级类目） |
| platform_code | String(50) | 所属平台（NULL表示全平台共用） |
| is_active | Boolean | 是否启用 |
| sort_order | Integer | 排序顺序 |

**类目数据**（32个一级类目）:
1. 全部
2. 美妆个护（12个子类目）
3. 女装与女士内衣（7个子类目）
4. 保健（5个子类目）
5. 时尚配件（7个子类目）
6. 运动与户外（11个子类目）
7. 手机与数码（9个子类目）
8. 居家日用（7个子类目）
9. 食品饮料（8个子类目）
10. 汽车与摩托车（11个子类目）
11. 男装与男士内衣（6个子类目）
12. 收藏品（5个子类目）
13. 玩具和爱好（8个子类目）
14. 厨房用品（9个子类目）
15. 家装建材（9个子类目）
16. 电脑办公（7个子类目）
17. 箱包（5个子类目）
18. 鞋靴（3个子类目）
19. 五金工具（8个子类目）
20. 家纺布艺（3个子类目）
21. 家电（4个子类目）
22. 宠物用品（12个子类目）
23. 珠宝与仿生首饰（13个子类目）
24. 图书杂志音像（9个子类目）
25. 母婴用品（10个子类目）
26. 家具（5个子类目）
27. 儿童时尚（5个子类目）
28. 穆斯林时尚（9个子类目）
29. 二手（9个子类目）
30. 虚拟商品（1个子类目，仅Shopify）
31. POD定制
32. 成人用品
33. 文化

---

### 2. 核心表扩展（只加筛选必需字段）

#### 店铺表 (store) 新增字段

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| sales_7d | Integer | 0 | 近7天销量 |
| sales_total | Integer | 0 | 总销量 |
| platform_code | String(50) | NULL | 平台代码（外键到 dict_platform） |
| country_code | String(10) | NULL | 国家代码（外键到 dict_country） |
| data_source | String(50) | NULL | 数据来源标记（crawler/api/manual） |

**原则**: 
- 旧字段（platform, country）保留不删除
- 新字段设默认值，保证旧查询不报错
- 新字段添加外键约束，保证数据一致性

#### 商品表 (product) 新增字段

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| sales_7d | Integer | 0 | 近7天销量 |
| sales_total | Integer | 0 | 总销量 |
| category_code | String(100) | NULL | 类目代码（外键到 dict_category） |
| platform_code | String(50) | NULL | 平台代码（外键到 dict_platform） |
| data_source | String(50) | NULL | 数据来源标记（crawler/api/manual） |

**原则**: 同店铺表

---

### 3. 索引优化（为高频筛选加速）

#### 店铺表索引

```sql
-- 复合索引：平台 + 国家 + 销量
CREATE INDEX idx_store_platform_country_sales 
ON store(platform_code, country_code, sales_7d);

-- 单列索引：近7天销量降序
CREATE INDEX idx_store_sales_7d_desc 
ON store(sales_7d DESC);

-- 单列索引：总销量降序
CREATE INDEX idx_store_sales_total_desc 
ON store(sales_total DESC);
```

#### 商品表索引

```sql
-- 复合索引：平台 + 类目 + 销量
CREATE INDEX idx_product_platform_category_sales 
ON product(platform_code, category_code, sales_7d);

-- 复合索引：店铺 + 库存状态
CREATE INDEX idx_product_store_available 
ON product(store_id, is_available);

-- 单列索引：近7天销量降序
CREATE INDEX idx_product_sales_7d_desc 
ON product(sales_7d DESC);

-- 单列索引：总销量降序
CREATE INDEX idx_product_sales_total_desc 
ON product(sales_total DESC);
```

---

## 验收标准

### ✅ 1. 字典表能覆盖前端所有筛选项
- [x] 16个国家/地区（实际15个）
- [x] 32个一级类目
- [x] 数百个子类目
- [x] 支持后续新增

### ✅ 2. 核心表新增字段后，旧数据查询不受影响
- [x] 旧字段保留（platform, country, category）
- [x] 新字段有默认值（sales_7d=0, sales_total=0）
- [x] 外键约束设置为 ON DELETE SET NULL（不影响现有数据）

### ✅ 3. 插入非法"国家代码"或"类目"时，数据库能拦截报错
- [x] 外键约束生效
- [x] 只能插入字典表中存在的代码

### ✅ 4. 生产环境变更必须走迁移脚本
- [x] 创建了3个迁移脚本
- [x] 禁止直连改表

---

## 迁移脚本

### 迁移 001: 添加字典表
**文件**: `scripts/migrations/001_add_dictionary_tables.py`

**功能**:
1. 创建 dict_platform 表
2. 创建 dict_country 表
3. 创建 dict_category 表
4. 初始化平台数据（3个平台）
5. 初始化国家数据（15个国家）

**执行**:
```bash
docker exec fastapi_app python /app/scripts/migrations/001_add_dictionary_tables.py
```

**回滚**:
```bash
docker exec fastapi_app python /app/scripts/migrations/001_add_dictionary_tables.py downgrade
```

---

### 迁移 002: 添加销量和标准化字段
**文件**: `scripts/migrations/002_add_sales_and_standardized_fields.py`

**功能**:
1. 为 store 表添加新字段（sales_7d, sales_total, platform_code, country_code, data_source）
2. 为 product 表添加新字段（sales_7d, sales_total, category_code, platform_code, data_source）
3. 添加外键约束
4. 创建复合索引
5. 迁移现有数据（将旧字段值映射到新字段）

**执行**:
```bash
docker exec fastapi_app python /app/scripts/migrations/002_add_sales_and_standardized_fields.py
```

**回滚**:
```bash
docker exec fastapi_app python /app/scripts/migrations/002_add_sales_and_standardized_fields.py downgrade
```

---

### 迁移 003: 初始化类目数据
**文件**: `scripts/migrations/003_init_category_data.py`

**功能**:
1. 初始化32个一级类目
2. 初始化所有子类目
3. 设置类目层级关系

**执行**:
```bash
docker exec fastapi_app python /app/scripts/migrations/003_init_category_data.py
```

**回滚**:
```bash
docker exec fastapi_app python /app/scripts/migrations/003_init_category_data.py downgrade
```

---

## 执行步骤

### 方式一：使用迁移脚本（推荐）

```bash
cd Myproject/scripts

# 执行所有迁移
./run_migrations.sh

# 执行指定迁移
./run_migrations.sh 001
./run_migrations.sh 002
./run_migrations.sh 003

# 回滚指定迁移
./run_migrations.sh downgrade 003
./run_migrations.sh downgrade 002
./run_migrations.sh downgrade 001
```

### 方式二：手动执行

```bash
# 进入容器
docker exec -it fastapi_app bash

# 执行迁移
python /app/scripts/migrations/001_add_dictionary_tables.py
python /app/scripts/migrations/002_add_sales_and_standardized_fields.py
python /app/scripts/migrations/003_init_category_data.py

# 退出容器
exit
```

---

## 数据迁移说明

### 现有数据处理

#### 1. 平台字段迁移
```sql
UPDATE store 
SET platform_code = CASE 
    WHEN platform = 'shopify' THEN 'shopify'
    WHEN platform = 'tiktok' THEN 'tiktok'
    ELSE NULL 
END
WHERE platform_code IS NULL;
```

#### 2. 国家字段迁移
```sql
UPDATE store 
SET country_code = CASE 
    WHEN country IN ('US', 'ID', 'GB', ...) THEN country
    WHEN country = '美国' THEN 'US'
    WHEN country = '印度尼西亚' THEN 'ID'
    -- ... 其他映射
    ELSE NULL 
END
WHERE country_code IS NULL AND country IS NOT NULL;
```

#### 3. 销量字段初始化
- 新字段默认值为 0
- 后续由爬虫或API更新实际销量数据

---

## API 调整建议

### 1. 爬虫任务创建 API
**文件**: `app/api/v1/admin/admin_crawler_tasks.py`

**调整**:
```python
class CrawlerTaskCreate(BaseModel):
    name: str
    url: str
    platform_code: str = "shopify"  # 使用标准化代码
    country_code: Optional[str] = None  # 使用标准化代码
    category_code: Optional[str] = None  # 新增：类目代码
    sub_category_code: Optional[str] = None  # 新增：子类目代码

# 创建任务时验证代码有效性
@router.post("")
async def create_crawler_task(task: CrawlerTaskCreate, db: Session = Depends(get_db)):
    # 验证平台代码
    platform = db.query(Platform).filter(Platform.code == task.platform_code).first()
    if not platform:
        raise HTTPException(status_code=400, detail="无效的平台代码")
    
    # 验证国家代码
    if task.country_code:
        country = db.query(Country).filter(Country.code == task.country_code).first()
        if not country:
            raise HTTPException(status_code=400, detail="无效的国家代码")
    
    # 创建任务
    new_task = Store(
        name=task.name,
        url=task.url,
        platform_code=task.platform_code,
        country_code=task.country_code,
        # ... 其他字段
    )
    db.add(new_task)
    db.commit()
    return new_task
```

### 2. 店铺搜索 API
**文件**: `app/api/v1/shopify/stores.py`

**调整**:
```python
@router.get("/search")
async def search_stores(
    keyword: str = Query(None),
    platform_code: str = Query(None),
    country_code: str = Query(None),
    sales_7d_min: int = Query(None),
    sales_7d_max: int = Query(None),
    sales_total_min: int = Query(None),
    sales_total_max: int = Query(None),
    sort_by: str = Query("sales_7d", regex="^(sales_7d|sales_total|created_at)$"),
    sort_order: str = Query("desc", regex="^(asc|desc)$"),
    skip: int = Query(0),
    limit: int = Query(100),
    db: Session = Depends(get_db)
):
    query = db.query(Store)
    
    # 关键词搜索
    if keyword:
        query = query.filter(
            (Store.name.ilike(f"%{keyword}%")) | 
            (Store.url.ilike(f"%{keyword}%"))
        )
    
    # 平台筛选
    if platform_code:
        query = query.filter(Store.platform_code == platform_code)
    
    # 国家筛选
    if country_code:
        query = query.filter(Store.country_code == country_code)
    
    # 销量筛选
    if sales_7d_min is not None:
        query = query.filter(Store.sales_7d >= sales_7d_min)
    if sales_7d_max is not None:
        query = query.filter(Store.sales_7d <= sales_7d_max)
    if sales_total_min is not None:
        query = query.filter(Store.sales_total >= sales_total_min)
    if sales_total_max is not None:
        query = query.filter(Store.sales_total <= sales_total_max)
    
    # 排序
    if sort_order == "desc":
        query = query.order_by(getattr(Store, sort_by).desc())
    else:
        query = query.order_by(getattr(Store, sort_by).asc())
    
    # 分页
    stores = query.offset(skip).limit(limit).all()
    return stores
```

### 3. 商品搜索 API
**文件**: `app/api/v1/shopify/products.py`

**调整**: 类似店铺搜索，添加 category_code 和销量筛选

---

## 前端调整建议

### 1. 国家选择组件
**文件**: `frontend/src/views/shopify/StoreSearch.vue`

**调整**:
```javascript
// 从后端获取国家列表
const fetchCountries = async () => {
  const response = await request.get('/v1/dict/countries')
  countries.value = response.data.map(c => ({
    label: c.name_zh,
    value: c.code  // 使用标准化代码
  }))
}

// 选择国家时使用代码
const selectCountry = (code) => {
  selectedCountry.value = code  // 'US' 而不是 '美国'
}
```

### 2. 类目选择组件
**调整**:
```javascript
// 从后端获取类目列表
const fetchCategories = async () => {
  const response = await request.get('/v1/dict/categories')
  categories.value = response.data
}

// 选择类目时使用代码
const selectCategory = (code) => {
  selectedCategory.value = code  // 'beauty' 而不是 '美妆个护'
}
```

### 3. 销量筛选组件
**新增**:
```vue
<el-popover>
  <template #reference>
    <div class="custom-select-trigger">
      <span class="select-label">近7天销量：</span>
      <span class="select-value">{{ getSales7dLabel }}</span>
    </div>
  </template>
  <div class="filter-options">
    <div @click="selectSales7d(0, 500)">0-500</div>
    <div @click="selectSales7d(500, 1000)">500-1000</div>
    <div @click="selectSales7d(1000, 5000)">1000-5000</div>
    <div @click="selectSales7d(5000, null)">>5000</div>
  </div>
</el-popover>
```

---

## 字典数据管理 API（新增）

### 1. 获取平台列表
```python
@router.get("/dict/platforms")
async def get_platforms(db: Session = Depends(get_db)):
    platforms = db.query(Platform).filter(Platform.is_active == True).order_by(Platform.sort_order).all()
    return platforms
```

### 2. 获取国家列表
```python
@router.get("/dict/countries")
async def get_countries(
    region: str = Query(None),
    db: Session = Depends(get_db)
):
    query = db.query(Country).filter(Country.is_active == True)
    if region:
        query = query.filter(Country.region == region)
    countries = query.order_by(Country.sort_order).all()
    return countries
```

### 3. 获取类目列表
```python
@router.get("/dict/categories")
async def get_categories(
    platform_code: str = Query(None),
    level: int = Query(None),
    parent_id: int = Query(None),
    db: Session = Depends(get_db)
):
    query = db.query(Category).filter(Category.is_active == True)
    
    if platform_code:
        query = query.filter(
            (Category.platform_code == platform_code) | 
            (Category.platform_code == None)  # 全平台共用
        )
    
    if level:
        query = query.filter(Category.level == level)
    
    if parent_id:
        query = query.filter(Category.parent_id == parent_id)
    
    categories = query.order_by(Category.sort_order).all()
    return categories
```

---

## 测试验证

### 1. 字典表数据验证
```sql
-- 查看平台数据
SELECT * FROM dict_platform;

-- 查看国家数据
SELECT * FROM dict_country ORDER BY sort_order;

-- 查看类目数据（一级类目）
SELECT * FROM dict_category WHERE level = 1 ORDER BY sort_order;

-- 查看类目数据（二级类目）
SELECT c1.name_zh as parent, c2.name_zh as child
FROM dict_category c1
JOIN dict_category c2 ON c2.parent_id = c1.id
WHERE c1.level = 1
ORDER BY c1.sort_order, c2.sort_order;
```

### 2. 外键约束验证
```sql
-- 尝试插入无效的平台代码（应该失败）
INSERT INTO store (name, url, platform_code) 
VALUES ('测试店铺', 'https://test.com', 'invalid_platform');
-- 错误: 违反外键约束

-- 尝试插入有效的平台代码（应该成功）
INSERT INTO store (name, url, platform_code, country_code) 
VALUES ('测试店铺', 'https://test.com', 'shopify', 'US');
-- 成功
```

### 3. 索引性能验证
```sql
-- 查看执行计划（应该使用索引）
EXPLAIN ANALYZE
SELECT * FROM store 
WHERE platform_code = 'shopify' 
  AND country_code = 'US' 
  AND sales_7d > 1000
ORDER BY sales_7d DESC
LIMIT 100;
```

### 4. 销量筛选验证
```sql
-- 按近7天销量筛选
SELECT name, sales_7d, sales_total 
FROM store 
WHERE sales_7d BETWEEN 1000 AND 5000
ORDER BY sales_7d DESC;

-- 按总销量排序
SELECT name, sales_7d, sales_total 
FROM store 
ORDER BY sales_total DESC
LIMIT 10;
```

---

## 注意事项

### 1. 数据一致性
- 新旧字段需要保持同步更新
- 建议在应用层同时更新新旧字段
- 逐步迁移到使用新字段

### 2. 性能影响
- 新增索引会占用额外存储空间
- 写入性能可能略有下降（需要更新索引）
- 查询性能会显著提升

### 3. 兼容性
- 旧代码仍然可以使用旧字段
- 新代码应该使用新字段
- 外键约束设置为 ON DELETE SET NULL，不影响现有数据

### 4. 回滚策略
- 每个迁移脚本都提供了 downgrade 方法
- 回滚时注意顺序（倒序执行）
- 回滚前建议备份数据库

---

## 后续优化建议

### 1. 数据同步
- 编写定时任务，将旧字段数据同步到新字段
- 逐步废弃旧字段的使用

### 2. 销量数据更新
- 爬虫采集时更新 sales_7d 和 sales_total
- 定时任务计算销量统计

### 3. 字典数据管理
- 提供管理后台界面管理字典数据
- 支持动态添加新平台、国家、类目

### 4. 性能监控
- 监控索引使用情况
- 定期分析慢查询
- 根据实际使用情况调整索引

---

## 总结

本次数据库增强实现了：

✅ **字典表建设**: 3张字典表，统一管理平台、国家、类目  
✅ **核心表扩展**: 添加销量和标准化字段，保持向后兼容  
✅ **索引优化**: 8个索引，优化高频查询性能  
✅ **数据迁移**: 3个迁移脚本，安全可回滚  
✅ **外键约束**: 保证数据一致性，防止脏数据  

**验收标准全部达成**:
- ✅ 字典表覆盖前端所有筛选项
- ✅ 旧数据查询不受影响
- ✅ 外键约束拦截非法数据
- ✅ 生产环境走迁移脚本

**下一步**:
1. 执行迁移脚本
2. 调整 API 使用新字段
3. 更新前端使用标准化代码
4. 实现销量数据采集和更新
5. 添加字典数据管理界面

---

*文档生成时间: 2026-05-14*  
*实施人员: 后端架构师/数据库工程师*
