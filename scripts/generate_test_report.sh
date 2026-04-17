#!/bin/bash

# 生成测试报告
# 用途：将验证结果输出为文本报告

REPORT_FILE="test_report_$(date +%Y%m%d_%H%M%S).txt"

echo "正在生成测试报告..."
echo ""

# 执行验证脚本并保存输出
./devops_validation.sh > "$REPORT_FILE" 2>&1

# 添加额外信息
echo "" >> "$REPORT_FILE"
echo "=========================================" >> "$REPORT_FILE"
echo "           系统信息" >> "$REPORT_FILE"
echo "=========================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "生成时间: $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT_FILE"
echo "操作系统: $(uname -s)" >> "$REPORT_FILE"
echo "Docker 版本: $(docker --version)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 添加容器信息
echo "=========================================" >> "$REPORT_FILE"
echo "           容器信息" >> "$REPORT_FILE"
echo "=========================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" >> "$REPORT_FILE" 2>&1
echo "" >> "$REPORT_FILE"

# 添加文件统计
echo "=========================================" >> "$REPORT_FILE"
echo "           文件统计" >> "$REPORT_FILE"
echo "=========================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "路由配置行数: $(wc -l < ../frontend/src/router/index.js)" >> "$REPORT_FILE"
echo "导航配置行数: $(wc -l < ../frontend/src/config/navigation.js)" >> "$REPORT_FILE"
echo "HorizontalLayout 行数: $(wc -l < ../frontend/src/layout/HorizontalLayout.vue)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "测试报告已生成: $REPORT_FILE"
echo ""
echo "查看报告:"
echo "  cat $REPORT_FILE"
echo ""
