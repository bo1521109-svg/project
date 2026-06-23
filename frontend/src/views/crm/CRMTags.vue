<template>
  <div class="crm-tags">
    <div class="page-header">
      <h2 class="page-title">标签管理</h2>
      <el-button type="primary" :icon="Plus" @click="showCreateDialog = true">添加标签</el-button>
    </div>

    <!-- 标签统计 -->
    <div class="tag-stats">
      <span class="ts-total">共 {{ tags.length }} 个标签</span>
      <span class="ts-usage">覆盖 {{ totalTagUsage.toLocaleString() }} 个客户</span>
    </div>

    <!-- 标签网格 -->
    <div class="tag-grid">
      <div class="tag-card" v-for="tag in tags" :key="tag.id">
        <div class="tag-color" :style="{ background: tag.color }"></div>
        <div class="tag-body">
          <div class="tag-name">{{ tag.name }}</div>
          <div class="tag-count">{{ tag.customer_count }} 位客户</div>
        </div>
        <div class="tag-actions">
          <el-button text size="small" :icon="Edit" @click="editTag(tag)">编辑</el-button>
          <el-button text size="small" type="danger" :icon="Delete" @click="deleteTag(tag)">删除</el-button>
        </div>
      </div>
    </div>

    <!-- 颜色预设选择 -->
    <div class="color-presets" style="margin-top: 20px;">
      <h3 style="font-size: 14px; margin-bottom: 8px; color: #606266;">常用颜色</h3>
      <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <div
          v-for="c in presetColors"
          :key="c"
          class="color-block"
          :style="{ background: c }"
          :class="{ selected: createForm.color === c }"
          @click="createForm.color = c"
        ></div>
      </div>
    </div>

    <!-- 添加/编辑对话框 -->
    <el-dialog v-model="showCreateDialog" :title="editingTag ? '编辑标签' : '添加标签'" width="420px">
      <el-form :model="createForm" label-width="80px">
        <el-form-item label="标签名称" required>
          <el-input v-model="createForm.name" placeholder="请输入标签名称" />
        </el-form-item>
        <el-form-item label="标签颜色">
          <div class="color-row">
            <div class="color-preview" :style="{ background: createForm.color }"></div>
            <el-input v-model="createForm.color" placeholder="#409EFF" style="width: 120px" />
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreateDialog = false; editingTag = null">取消</el-button>
        <el-button type="primary" @click="handleSave">{{ editingTag ? '保存' : '添加' }}</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Plus, Edit, Delete } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const tags = ref([
  { id: 1, name: '高意向', color: '#F56C6C', customer_count: 423 },
  { id: 2, name: 'VIP客户', color: '#E6A23C', customer_count: 156 },
  { id: 3, name: '批发', color: '#409EFF', customer_count: 345 },
  { id: 4, name: '样品申请', color: '#67C23A', customer_count: 278 },
  { id: 5, name: '询价', color: '#909399', customer_count: 412 },
  { id: 6, name: 'OEM', color: '#8B5CF6', customer_count: 189 },
  { id: 7, name: '代理', color: '#06B6D4', customer_count: 234 },
  { id: 8, name: '比价', color: '#F97316', customer_count: 298 },
  { id: 9, name: '零售', color: '#14B8A6', customer_count: 567 },
  { id: 10, name: '长期合作', color: '#EC4899', customer_count: 189 },
  { id: 11, name: '中东市场', color: '#D4A574', customer_count: 86 },
  { id: 12, name: '北非市场', color: '#6B7280', customer_count: 45 },
  { id: 13, name: '认证需求', color: '#3B82F6', customer_count: 67 },
  { id: 14, name: '品牌代理', color: '#7C3AED', customer_count: 98 },
  { id: 15, name: '分销商', color: '#059669', customer_count: 134 },
])

const presetColors = [
  '#F56C6C', '#E6A23C', '#409EFF', '#67C23A', '#909399',
  '#8B5CF6', '#06B6D4', '#F97316', '#14B8A6', '#EC4899',
  '#D4A574', '#6B7280', '#3B82F6', '#7C3AED', '#059669',
  '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
]

const totalTagUsage = computed(() => tags.value.reduce((sum, t) => sum + t.customer_count, 0))

// 创建/编辑
const showCreateDialog = ref(false)
const editingTag = ref(null)
const createForm = ref({ name: '', color: '#409EFF' })

function editTag(tag) {
  editingTag.value = tag
  createForm.value = { name: tag.name, color: tag.color }
  showCreateDialog.value = true
}

function handleSave() {
  if (!createForm.value.name) {
    ElMessage.warning('请输入标签名称')
    return
  }
  if (editingTag.value) {
    editingTag.value.name = createForm.value.name
    editingTag.value.color = createForm.value.color
    ElMessage.success('标签更新成功')
  } else {
    tags.value.push({
      id: Date.now(),
      name: createForm.value.name,
      color: createForm.value.color,
      customer_count: 0,
    })
    ElMessage.success('标签添加成功')
  }
  showCreateDialog.value = false
  editingTag.value = null
  createForm.value = { name: '', color: '#409EFF' }
}

function deleteTag(tag) {
  ElMessageBox.confirm(`确定要删除标签"${tag.name}"吗？删除后该标签将从所有客户上移除。`, '确认删除', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  }).then(() => {
    tags.value = tags.value.filter(t => t.id !== tag.id)
    ElMessage.success('标签已删除')
  }).catch(() => {})
}
</script>

<style scoped>
.crm-tags { max-width: 1200px; }

.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.page-title { font-size: 20px; font-weight: 700; color: #303133; margin: 0; }

.tag-stats {
  display: flex; gap: 24px; background: #fff; padding: 12px 20px; border-radius: 10px;
  margin-bottom: 16px; box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}
.ts-total { font-size: 13px; color: #303133; font-weight: 500; }
.ts-usage { font-size: 13px; color: #909399; }

/* 标签网格 */
.tag-grid {
  display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px;
}
@media (max-width: 900px) { .tag-grid { grid-template-columns: repeat(2, 1fr); } }

.tag-card {
  background: #fff; border-radius: 10px; padding: 14px 16px;
  display: flex; align-items: center; gap: 12px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
  transition: all 0.3s;
}
.tag-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }

.tag-color { width: 44px; height: 44px; border-radius: 10px; flex-shrink: 0; }
.tag-body { flex: 1; }
.tag-name { font-size: 14px; font-weight: 600; color: #303133; }
.tag-count { font-size: 12px; color: #909399; margin-top: 2px; }
.tag-actions { display: flex; gap: 4px; flex-shrink: 0; opacity: 0; transition: opacity 0.2s; }
.tag-card:hover .tag-actions { opacity: 1; }

/* 颜色选择 */
.color-presets {
  background: #fff; border-radius: 10px; padding: 14px 18px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}
.color-block {
  width: 28px; height: 28px; border-radius: 6px; cursor: pointer;
  border: 2px solid transparent; transition: all 0.2s;
}
.color-block:hover { transform: scale(1.15); }
.color-block.selected { border-color: #303133; box-shadow: 0 0 0 2px rgba(0,0,0,0.1); }

.color-row { display: flex; align-items: center; gap: 10px; }
.color-preview { width: 32px; height: 32px; border-radius: 6px; flex-shrink: 0; }
</style>
