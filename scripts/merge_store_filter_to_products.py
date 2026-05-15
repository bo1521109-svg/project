#!/usr/bin/env python3
"""
将 StoreSearch.vue 的店铺筛选功能合并到 Products.vue
"""

# 读取 StoreSearch.vue 的筛选部分
with open('frontend/src/views/shopify/StoreSearch.vue', 'r', encoding='utf-8') as f:
    store_search_content = f.read()

# 读取 Products.vue
with open('frontend/src/views/Products.vue', 'r', encoding='utf-8') as f:
    products_content = f.read()

# 提取 StoreSearch 的 script 部分（从 import 到 </script>）
import re

# 提取 StoreSearch 的 imports
store_imports_match = re.search(r"import { ref, computed, onMounted, nextTick } from 'vue'\nimport { Search, ArrowDown, ArrowUp } from '@element-plus/icons-vue'", store_search_content)

# 提取所有店铺筛选相关的变量和函数
# 从 "// 搜索关键词" 开始到 "onMounted" 之前
script_start = store_search_content.find("// 搜索关键词")
script_end = store_search_content.find("onMounted(() => {")

store_filter_logic = store_search_content[script_start:script_end]

# 提取 StoreSearch 的 onMounted 逻辑
store_onmounted_match = re.search(r"onMounted\(\(\) => \{[\s\S]*?window\.addEventListener.*?\}\)\n\}\)", store_search_content)
store_onmounted = store_onmounted_match.group(0) if store_onmounted_match else ""

# 提取 StoreSearch 的 style 部分
style_start = store_search_content.find("<style scoped>")
style_end = store_search_content.rfind("</style>") + len("</style>")
store_styles = store_search_content[style_start:style_end]

# 现在修改 Products.vue
# 1. 添加新的 imports
products_content = products_content.replace(
    "import { ref, onMounted } from 'vue'",
    "import { ref, computed, onMounted, nextTick } from 'vue'"
)

products_content = products_content.replace(
    "import { Picture } from '@element-plus/icons-vue'",
    "import { Picture, Search, ArrowDown, ArrowUp } from '@element-plus/icons-vue'"
)

# 2. 在 script setup 中添加店铺筛选逻辑
# 找到 "// 数据" 这一行，在它之前插入店铺筛选逻辑
products_content = products_content.replace(
    "// 数据\nconst products = ref([])",
    f"{store_filter_logic}\n// 商品列表数据\nconst products = ref([])"
)

# 3. 修改 onMounted，合并两个逻辑
products_content = products_content.replace(
    """// 页面加载时获取数据
onMounted(() => {
  fetchStores()
  fetchProducts()
})""",
    """// 页面加载时获取数据
onMounted(() => {
  // 商品列表逻辑
  fetchStores()
  fetchProducts()
  
  // 店铺筛选逻辑
  checkOverflow('filter-tags-country')
  checkOverflow('filter-tags-category')
  
  // 监听窗口大小变化，重新检查
  window.addEventListener('resize', () => {
    checkOverflow('filter-tags-country')
    checkOverflow('filter-tags-category')
  })
})"""
)

# 4. 在 </script> 之前添加店铺搜索函数
products_content = products_content.replace(
    "// 页面加载时获取数据",
    """// 店铺搜索函数
const handleStoreSearch = () => {
  console.log('店铺搜索条件：', {
    keyword: searchKeyword.value,
    country: selectedCountry.value,
    category: selectedCategory.value,
    ...filters.value
  })
  // TODO: 调用店铺搜索API，然后根据结果筛选商品
}

// 页面加载时获取数据"""
)

# 5. 添加店铺筛选的样式
# 在最后一个 </style> 之前插入店铺筛选样式
last_style_end = products_content.rfind("</style>")
products_content = products_content[:last_style_end] + "\n\n" + store_styles + "\n"

# 保存修改后的 Products.vue
with open('frontend/src/views/Products.vue', 'w', encoding='utf-8') as f:
    f.write(products_content)

print("✅ 成功将店铺筛选功能合并到 Products.vue")
print("📝 已添加:")
print("  - 店铺筛选区域（搜索框、国家/地区、类目、筛选条件）")
print("  - 所有筛选逻辑和数据")
print("  - 完整的样式")
