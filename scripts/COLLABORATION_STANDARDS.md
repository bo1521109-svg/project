# 数据库扩展 + 筛选功能改造 - 协作规范

**制定时间**: 2026-05-15  
**制定角色**: 技术负责人 / 架构师  
**适用范围**: 本次数据库扩展 + 筛选功能改造项目

---

## 【协作原则】

### 1. 方向先行
本次提示词只定业务方向，具体命名由技术按团队规范自由发挥

### 2. 对齐后置
技术完成后，把最终表名/字段名/接口路径同步给我，我来更新文档与后续提示词

### 3. 灰度验证
关键改动（如数据清洗）先跑 10% 数据验证，再全量推进

---

## 【执行流程】

### 1. 开发阶段

#### 后端：按提示词 1-3 实现，命名自由，但需记录"业务含义→实际命名"映射表

**示例映射表**:
```markdown
| 业务含义 | 实际命名 | 类型 | 说明 |
|---------|---------|------|------|
| 标准化国家 | country_code | 字段 | store 表，VARCHAR(10) |
| 标准化类目 | category_code | 字段 | product 表，VARCHAR(100) |
| 近7天销量 | sales_7d | 字段 | store/product 表，INTEGER |
| 总销量 | sales_total | 字段 | store/product 表，INTEGER |
| 国家字典表 | dict_country | 表 | 存储国家代码和名称 |
| 类目字典表 | dict_category | 表 | 存储类目代码和名称 |
| 平台字典表 | dict_platform | 表 | 存储平台代码和名称 |
| 店铺搜索接口 | /api/v1/shopify/stores/search | API | GET 请求 |
| 商品搜索接口 | /api/v1/shopify/products/search | API | GET 请求 |
```

#### 前端：按提示词 4 适配，筛选参数与后端协商确定，保持语义一致

**前端参数命名规范**:
```javascript
// ✅ 推荐：与后端字段名保持一致
const filters = {
  country_code: 'US',        // 对应后端 country_code
  category_code: 'beauty',   // 对应后端 category_code
  sales_7d_min: 100,         // 对应后端 sales_7d_min
  sales_7d_max: 10000,       // 对应后端 sales_7d_max
  sort_by: 'sales_total',    // 对应后端 sort_by
  sort_order: 'desc'         // 对应后端 sort_order
}

// ❌ 不推荐：前后端命名不一致
const filters = {
  countryCode: 'US',         // 驼峰命名，与后端不一致
  categoryId: 'beauty',      // 语义不一致
  minSales: 100              // 语义模糊
}
```

#### 测试：按验收标准写用例，不依赖具体命名，用业务语言描述预期结果

**测试用例示例**:
```markdown
### 测试用例 1: 国家筛选
- **业务描述**: 选择"美国"，应返回所有国家为美国的店铺
- **测试步骤**:
  1. 调用店铺搜索接口
  2. 传入参数：国家代码 = "US"
  3. 验证返回结果
- **预期结果**: 
  - 返回的所有店铺的国家代码都是 "US"
  - 返回结果数量 > 0（假设有美国店铺）
  - 响应时间 < 300ms

### 测试用例 2: 未支持参数兼容
- **业务描述**: 传入未支持的参数（如"评分"），应不报错，返回全量数据
- **测试步骤**:
  1. 调用商品搜索接口
  2. 传入参数：评分 = 4.5（未支持）
  3. 验证返回结果
- **预期结果**:
  - HTTP 状态码 = 200（不报错）
  - 返回全量数据（未过滤）
  - 响应中包含 filters_ignored 字段，值为 ["rating"]
```

---

### 2. 对齐阶段（开发完成后）

#### 技术输出"命名映射表"

**格式要求**:
```markdown
## 数据库字段映射

### store 表
| 业务含义 | 字段名 | 类型 | 说明 |
|---------|--------|------|------|
| 标准化国家 | country_code | VARCHAR(10) | 外键到 dict_country.code |
| 标准化平台 | platform_code | VARCHAR(50) | 外键到 dict_platform.code |
| 近7天销量 | sales_7d | INTEGER | 默认 0 |
| 总销量 | sales_total | INTEGER | 默认 0 |
| 任务配置-目标国家 | target_country_code | VARCHAR(10) | 外键到 dict_country.code |
| 任务配置-目标类目 | target_category_code | VARCHAR(100) | 外键到 dict_category.code |

### product 表
| 业务含义 | 字段名 | 类型 | 说明 |
|---------|--------|------|------|
| 标准化类目 | category_code | VARCHAR(100) | 外键到 dict_category.code |
| 标准化平台 | platform_code | VARCHAR(50) | 外键到 dict_platform.code |
| 近7天销量 | sales_7d | INTEGER | 默认 0 |
| 总销量 | sales_total | INTEGER | 默认 0 |

## API 接口映射

### 店铺搜索
- **路径**: `/api/v1/shopify/stores/search`
- **方法**: GET
- **参数**:
  | 业务含义 | 参数名 | 类型 | 说明 |
  |---------|--------|------|------|
  | 搜索关键词 | keyword | string | 可选 |
  | 国家代码 | country_code | string | 可选，如：US, GB |
  | 近7天销量最小值 | sales_7d_min | integer | 可选，≥0 |
  | 近7天销量最大值 | sales_7d_max | integer | 可选，≥0 |
  | 总销量最小值 | sales_total_min | integer | 可选，≥0 |
  | 总销量最大值 | sales_total_max | integer | 可选，≥0 |
  | 排序字段 | sort_by | string | 可选，sales_7d/sales_total |
  | 排序方向 | sort_order | string | 可选，asc/desc |

### 商品搜索
- **路径**: `/api/v1/shopify/products/search`
- **方法**: GET
- **参数**:
  | 业务含义 | 参数名 | 类型 | 说明 |
  |---------|--------|------|------|
  | 搜索关键词 | keyword | string | 可选 |
  | 店铺ID | store_id | integer | 可选 |
  | 国家代码 | country_code | string | 可选，通过店铺关联 |
  | 类目代码 | category_code | string | 可选，如：beauty |
  | 近7天销量最小值 | sales_7d_min | integer | 可选，≥0 |
  | 近7天销量最大值 | sales_7d_max | integer | 可选，≥0 |
  | 总销量最小值 | sales_total_min | integer | 可选，≥0 |
  | 总销量最大值 | sales_total_max | integer | 可选，≥0 |
  | 排序字段 | sort_by | string | 可选，sales_7d/sales_total |
  | 排序方向 | sort_order | string | 可选，asc/desc |
```

#### 我同步更新：文档/后续提示词/验收清单，确保后续协作无缝

**更新内容**:
1. 更新项目文档（README, 架构文档）
2. 更新后续提示词（使用实际命名）
3. 更新验收清单（使用实际命名）
4. 更新前端开发文档（参数说明）

---

### 3. 联调阶段

#### 用业务语言验收

**验收标准**（业务语言）:
```markdown
✅ 选"美国 + 美妆 + 销量≥1 万"，应返回 3 条结果
✅ 选未支持参数（如"评分≥4.5"），不报错，返回全量数据
✅ 排序切换响应 <300ms
✅ 分页切换无重复/遗漏数据
✅ Swagger 文档自动更新
```

#### 不依赖具体路径

**测试方式**:
```bash
# ❌ 不推荐：硬编码具体路径
curl http://localhost:8000/api/v1/shopify/stores/search?country_code=US

# ✅ 推荐：使用环境变量或配置文件
API_BASE_URL="http://localhost:8000/api/v1"
STORE_SEARCH_PATH="/shopify/stores/search"
curl "${API_BASE_URL}${STORE_SEARCH_PATH}?country_code=US"
```

**验收用例**（代替 `/api/v1/xxx/xxx`）:
```markdown
### 验收用例 1: 店铺搜索 - 国家筛选
- **接口**: 店铺搜索接口
- **参数**: 国家代码 = "US"
- **预期**: 返回所有美国店铺
- **验证**: 
  - 返回结果中所有店铺的国家代码都是 "US"
  - 响应时间 < 300ms

### 验收用例 2: 商品搜索 - 类目筛选
- **接口**: 商品搜索接口
- **参数**: 类目代码 = "beauty"
- **预期**: 返回所有美妆类商品
- **验证**:
  - 返回结果中所有商品的类目代码都是 "beauty"
  - 响应时间 < 300ms
```

---

## 【交付物】

### ✅ "业务字段→实际命名"映射表（开发完成后输出）

**已完成的映射表**:

#### 数据库字段映射

**store 表**:
| 业务含义 | 字段名 | 类型 | 说明 |
|---------|--------|------|------|
| 标准化国家 | country_code | VARCHAR(10) | 外键到 dict_country.code |
| 标准化平台 | platform_code | VARCHAR(50) | 外键到 dict_platform.code |
| 近7天销量 | sales_7d | INTEGER | 默认 0 |
| 总销量 | sales_total | INTEGER | 默认 0 |
| 数据来源标记 | data_source | VARCHAR(50) | 如：task_config, m004 |
| 任务配置-目标国家 | target_country_code | VARCHAR(10) | 外键到 dict_country.code |
| 任务配置-目标类目 | target_category_code | VARCHAR(100) | 外键到 dict_category.code |
| 是否人工复核 | is_manual_reviewed | BOOLEAN | 默认 false |

**product 表**:
| 业务含义 | 字段名 | 类型 | 说明 |
|---------|--------|------|------|
| 标准化类目 | category_code | VARCHAR(100) | 外键到 dict_category.code |
| 标准化平台 | platform_code | VARCHAR(50) | 外键到 dict_platform.code |
| 近7天销量 | sales_7d | INTEGER | 默认 0 |
| 总销量 | sales_total | INTEGER | 默认 0 |
| 数据来源标记 | data_source | VARCHAR(50) | 如：task_config, m004 |

**字典表**:
| 业务含义 | 表名 | 说明 |
|---------|------|------|
| 国家字典表 | dict_country | 存储国家代码和名称 |
| 类目字典表 | dict_category | 存储类目代码和名称（树形结构） |
| 平台字典表 | dict_platform | 存储平台代码和名称 |

#### API 接口映射

**店铺搜索**:
- **路径**: `/api/v1/shopify/stores/search`
- **方法**: GET
- **参数**:
  | 业务含义 | 参数名 | 类型 | 必填 | 说明 |
  |---------|--------|------|------|------|
  | 搜索关键词 | keyword | string | 否 | 店铺名称或 URL |
  | 国家代码 | country_code | string | 否 | 如：US, GB, DE |
  | 近7天销量最小值 | sales_7d_min | integer | 否 | ≥0 |
  | 近7天销量最大值 | sales_7d_max | integer | 否 | ≥0 |
  | 总销量最小值 | sales_total_min | integer | 否 | ≥0 |
  | 总销量最大值 | sales_total_max | integer | 否 | ≥0 |
  | 排序字段 | sort_by | string | 否 | sales_7d, sales_total |
  | 排序方向 | sort_order | string | 否 | asc, desc（默认 desc） |
  | 跳过条数 | skip | integer | 否 | ≥0（默认 0） |
  | 返回条数 | limit | integer | 否 | 1-500（默认 100） |

**商品搜索**:
- **路径**: `/api/v1/shopify/products/search`
- **方法**: GET
- **参数**:
  | 业务含义 | 参数名 | 类型 | 必填 | 说明 |
  |---------|--------|------|------|------|
  | 搜索关键词 | keyword | string | 否 | 商品标题 |
  | 店铺ID | store_id | integer | 否 | 筛选指定店铺的商品 |
  | 国家代码 | country_code | string | 否 | 通过店铺关联筛选 |
  | 类目代码 | category_code | string | 否 | 如：beauty, women-fashion |
  | 近7天销量最小值 | sales_7d_min | integer | 否 | ≥0 |
  | 近7天销量最大值 | sales_7d_max | integer | 否 | ≥0 |
  | 总销量最小值 | sales_total_min | integer | 否 | ≥0 |
  | 总销量最大值 | sales_total_max | integer | 否 | ≥0 |
  | 排序字段 | sort_by | string | 否 | sales_7d, sales_total |
  | 排序方向 | sort_order | string | 否 | asc, desc（默认 desc） |
  | 跳过条数 | skip | integer | 否 | ≥0（默认 0） |
  | 返回条数 | limit | integer | 否 | 1-500（默认 100） |

**响应格式**:
```json
{
  "data": [...],              // 店铺/商品列表
  "total": 100,               // 总条数
  "filters_applied": {        // 实际生效的筛选条件
    "country_code": "US",
    "category_code": "beauty",
    "sales_total_min": 10000
  },
  "filters_ignored": []       // 被忽略的参数
}
```

### ✅ 验收用例（含筛选/排序/分页/边界测试）

**验收用例清单**:

#### 1. 筛选功能测试

**用例 1.1: 国家筛选**
- **接口**: 店铺搜索
- **参数**: `country_code=US`
- **预期**: 返回所有美国店铺
- **验证**: 
  - 所有结果的 country_code = "US"
  - filters_applied 包含 "country_code": "US"
  - 响应时间 < 300ms

**用例 1.2: 类目筛选**
- **接口**: 商品搜索
- **参数**: `category_code=beauty`
- **预期**: 返回所有美妆类商品
- **验证**:
  - 所有结果的 category_code = "beauty"
  - filters_applied 包含 "category_code": "beauty"
  - 响应时间 < 300ms

**用例 1.3: 销量筛选**
- **接口**: 商品搜索
- **参数**: `sales_total_min=10000`
- **预期**: 返回总销量 ≥ 10000 的商品
- **验证**:
  - 所有结果的 sales_total ≥ 10000
  - filters_applied 包含 "sales_total_min": 10000
  - 响应时间 < 300ms

**用例 1.4: 组合筛选**
- **接口**: 商品搜索
- **参数**: `country_code=US&category_code=beauty&sales_total_min=10000`
- **预期**: 返回美国美妆类且总销量 ≥ 10000 的商品
- **验证**:
  - 所有结果满足所有条件
  - filters_applied 包含所有筛选条件
  - 响应时间 < 300ms

#### 2. 排序功能测试

**用例 2.1: 销量降序**
- **接口**: 商品搜索
- **参数**: `sort_by=sales_total&sort_order=desc`
- **预期**: 按总销量降序排列
- **验证**:
  - 结果按 sales_total 降序排列
  - filters_applied 包含排序参数
  - 响应时间 < 300ms

**用例 2.2: 销量升序**
- **接口**: 商品搜索
- **参数**: `sort_by=sales_total&sort_order=asc`
- **预期**: 按总销量升序排列
- **验证**:
  - 结果按 sales_total 升序排列
  - filters_applied 包含排序参数
  - 响应时间 < 300ms

#### 3. 分页功能测试

**用例 3.1: 第一页**
- **接口**: 商品搜索
- **参数**: `skip=0&limit=10`
- **预期**: 返回前 10 条
- **验证**:
  - 返回 10 条数据（假设总数 ≥ 10）
  - total 字段显示总条数
  - 响应时间 < 300ms

**用例 3.2: 第二页**
- **接口**: 商品搜索
- **参数**: `skip=10&limit=10`
- **预期**: 返回第 11-20 条
- **验证**:
  - 返回 10 条数据
  - 与第一页数据无重复
  - 响应时间 < 300ms

#### 4. 边界测试

**用例 4.1: 未支持参数**
- **接口**: 商品搜索
- **参数**: `rating=4.5&review_count=100`
- **预期**: 不报错，返回全量数据
- **验证**:
  - HTTP 状态码 = 200
  - filters_ignored = ["rating", "review_count"]
  - 返回全量数据（未过滤）
  - 响应时间 < 300ms

**用例 4.2: 空结果**
- **接口**: 商品搜索
- **参数**: `sales_total_min=999999999`
- **预期**: 返回空列表
- **验证**:
  - data = []
  - total = 0
  - HTTP 状态码 = 200
  - 响应时间 < 300ms

**用例 4.3: 无效参数值**
- **接口**: 商品搜索
- **参数**: `sales_total_min=-100`
- **预期**: 参数验证失败
- **验证**:
  - HTTP 状态码 = 422（参数验证错误）
  - 错误信息明确

### ✅ 首次联调录屏（含筛选/排序/分页/边界测试）

**录屏内容**:
1. 打开 Swagger 文档（http://localhost:8000/docs）
2. 测试店铺搜索 - 国家筛选
3. 测试商品搜索 - 类目筛选
4. 测试商品搜索 - 组合筛选
5. 测试商品搜索 - 排序功能
6. 测试商品搜索 - 分页功能
7. 测试商品搜索 - 未支持参数兼容
8. 查看日志输出（验证参数记录）

**录屏要求**:
- 清晰展示请求参数
- 清晰展示响应结果
- 清晰展示响应时间
- 清晰展示日志输出

---

## 【输出要求】

### 只描述协作流程与对齐机制，不指定具体命名规范

**本文档的定位**:
- ✅ 定义协作流程（开发 → 对齐 → 联调）
- ✅ 定义对齐机制（映射表、验收用例）
- ✅ 定义验收标准（业务语言描述）
- ❌ 不指定具体命名规范（由技术团队自由发挥）
- ❌ 不指定具体技术实现（由技术团队自由选择）

### 技术按团队现有规范执行，完成后同步给我对齐

**技术团队的自由度**:
- ✅ 自由选择字段命名（驼峰、下划线、大小写）
- ✅ 自由选择表命名（前缀、后缀、单复数）
- ✅ 自由选择 API 路径（RESTful、RPC、GraphQL）
- ✅ 自由选择技术栈（ORM、原生 SQL、存储过程）

**唯一要求**:
- ✅ 完成后提供"业务含义 → 实际命名"映射表
- ✅ 映射表格式清晰，易于理解
- ✅ 映射表包含所有新增/修改的字段、表、接口

---

## 【附录】

### 已完成的工作

1. **数据库扩展**:
   - ✅ 创建字典表（dict_country, dict_category, dict_platform）
   - ✅ 添加标准化字段（country_code, category_code, platform_code）
   - ✅ 添加销量字段（sales_7d, sales_total）
   - ✅ 添加任务配置字段（target_country_code, target_category_code）
   - ✅ 历史数据映射（迁移 004）

2. **爬虫任务配置驱动**:
   - ✅ 爬虫执行时读取任务配置
   - ✅ 自动打标店铺和商品数据
   - ✅ 数据来源标记（data_source）

3. **Shopify 搜索 API 改造**:
   - ✅ 店铺搜索支持多维度筛选
   - ✅ 商品搜索支持多维度筛选
   - ✅ 未支持参数平滑兼容
   - ✅ 返回元数据（total, filters_applied, filters_ignored）

### 相关文档

1. `scripts/task_config_driven_crawler_implementation.md` - 任务配置驱动爬虫
2. `scripts/shopify_search_api_enhancement.md` - 搜索 API 增强详细文档
3. `scripts/SHOPIFY_SEARCH_API_FINAL_SUMMARY.md` - 最终总结
4. `scripts/migration_004_execution_report.md` - 数据迁移报告
5. `scripts/COLLABORATION_STANDARDS.md` - 协作规范（本文档）

---

**制定完成时间**: 2026-05-15  
**制定人**: 技术负责人 / 架构师  
**下一步**: 前端团队按映射表适配界面
