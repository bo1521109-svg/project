#!/usr/bin/env python3
"""
删除 Products.vue 中重复的第二个筛选区域
"""

print("📖 读取 Products.vue...")
with open('frontend/src/views/Products.vue', 'r', encoding='utf-8') as f:
    lines = f.readlines()

print(f"📊 原文件共 {len(lines)} 行")

# 找到第二个筛选区域的开始和结束
# 开始：<!-- 店铺筛选区域（从 StoreSearch 复制） -->
# 结束：</div> 后面紧跟 <!-- 商品列表区域（原有内容） -->

start_line = None
end_line = None

for i, line in enumerate(lines):
    if '<!-- 店铺筛选区域（从 StoreSearch 复制） -->' in line:
        start_line = i
        print(f"✓ 找到第二个筛选区域开始位置：第 {i+1} 行")
    
    # 找到第二个 "<!-- 商品列表区域（原有内容） -->"
    if start_line is not None and end_line is None:
        if '<!-- 商品列表区域（原有内容） -->' in line and i > start_line + 10:
            end_line = i
            print(f"✓ 找到第二个筛选区域结束位置：第 {i+1} 行")
            break

if start_line is not None and end_line is not None:
    # 删除从 start_line 到 end_line-1 的所有行
    # 保留第一个 "<!-- 商品列表区域（原有内容） -->" 注释
    new_lines = lines[:start_line] + lines[end_line:]
    
    print(f"\n🗑️  删除第 {start_line+1} 行到第 {end_line} 行（共 {end_line - start_line} 行）")
    print(f"📊 新文件共 {len(new_lines)} 行")
    
    # 保存修改后的文件
    with open('frontend/src/views/Products.vue', 'w', encoding='utf-8') as f:
        f.writelines(new_lines)
    
    print("\n✅ 成功删除重复的筛选区域！")
    print(f"📉 文件从 {len(lines)} 行减少到 {len(new_lines)} 行")
else:
    print("\n❌ 未找到重复的筛选区域")
