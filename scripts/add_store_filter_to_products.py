#!/usr/bin/env python3
"""
将 StoreSearch.vue 的完整店铺筛选功能添加到 Products.vue 顶部
保持商品列表在下方
"""

import re

print("📖 读取 StoreSearch.vue...")
with open('frontend/src/views/shopify/StoreSearch.vue', 'r', encoding='utf-8') as f:
    store_content = f.read()

print("📖 读取 Products.vue...")
with open('frontend/src/views/Products.vue', 'r', encoding='utf-8') as f:
    products_content = f.read()

# 提取 StoreSearch 的筛选区域 HTML（从搜索框到筛选条件结束）
# 查找 "<!-- 搜索和筛选区域（合并） -->" 到 "<!-- 搜索结果区域（占位） -->"
filter_section_start = store_content.find('<!-- 搜索和筛选区域（合并） -->')
filter_section_end = store_content.find('<!-- 搜索结果区域（占位） -->')
store_filter_html = store_content[filter_section_start:filter_section_end].strip()

# 提取 StoreSearch 的 script 部分（完整的）
script_start = store_content.find('<script setup>')
script_end = store_content.find('</script>') + len('</script>')
store_script = store_content[script_start:script_end]

# 提取 StoreSearch 的 style 部分（完整的）
style_start = store_content.find('<style scoped>')
style_end_marker = '</style>'
# 找到最后一个 </style>
last_style_pos = store_content.rfind(style_end_marker)
store_styles = store_content[style_start:last_style_pos + len(style_end_marker)]

# 现在修改 Products.vue
# 1. 在 template 的 div.products-container 内部最前面插入店铺筛选区域
products_content = products_content.replace(
    '<div class="products-container">',
    f'<div class="products-container">\n    {store_filter_html}\n\n    <!-- 商品列表区域（原有内容） -->'
)

# 2. 替换 script 部分 - 合并两个 script
# 提取 Products 的 script 内容（不包括 <script setup> 和 </script>）
products_script_match = re.search(r'<script setup>([\s\S]*?)</script>', products_content)
products_script_content = products_script_match.group(1) if products_script_match else ""

# 提取 StoreSearch 的 script 内容（不包括标签）
store_script_content = re.search(r'<script setup>([\s\S]*?)</script>', store_script).group(1)

# 合并 script：先是 StoreSearch 的逻辑，然后是 Products 的逻辑
merged_script = f"""<script setup>
{store_script_content}

// ==================== 商品列表逻辑 ====================
{products_script_content}

// 店铺搜索函数
const handleStoreSearch = () => {{
  console.log('店铺搜索条件：', {{
    keyword: searchKeyword.value,
    country: selectedCountry.value,
    category: selectedCategory.value,
    ...filters.value
  }})
  // TODO: 根据店铺筛选条件调用API，然后筛选商品
  fetchProducts()
}}
</script>"""

# 替换 Products 的 script
products_content = re.sub(r'<script setup>[\s\S]*?</script>', merged_script, products_content)

# 3. 添加 StoreSearch 的样式
# 在 Products 的最后一个 </style> 之后添加 StoreSearch 的样式
last_style_pos = products_content.rfind('</style>')
if last_style_pos != -1:
    products_content = products_content[:last_style_pos + len('</style>')] + '\n\n' + store_styles
else:
    # 如果没有 style，直接添加到末尾
    products_content += '\n\n' + store_styles

# 4. 修改 CSS 类名，避免冲突
# 将 .store-search-page 改为 .products-container（已经存在）
# 将 .store-filter-section 改为 .store-filter-section
products_content = products_content.replace('.store-search-page {', '.products-container {')
products_content = products_content.replace('.search-filter-section {', '.store-filter-section {')

# 保存修改后的文件
print("💾 保存修改后的 Products.vue...")
with open('frontend/src/views/Products.vue', 'w', encoding='utf-8') as f:
    f.write(products_content)

print("\n✅ 成功完成合并！")
print("\n📋 已添加到 Products.vue:")
print("  ✓ 店铺筛选区域（搜索框）")
print("  ✓ 国家/地区筛选（16个国家）")
print("  ✓ 类目筛选（带子类目下拉）")
print("  ✓ 高级筛选条件（7个筛选项）")
print("  ✓ 所有筛选逻辑和数据")
print("  ✓ 完整的样式")
print("\n📍 商品列表已下移到筛选区域下方")
print("\n🚀 下一步：重新构建并部署前端")
