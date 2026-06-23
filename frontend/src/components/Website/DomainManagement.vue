<template>
  <div class="domain-management">
    <!-- 顶部操作栏 -->
    <div class="domain-toolbar">
      <div class="toolbar-left">
        <h3 class="toolbar-title">域名列表</h3>
        <span class="toolbar-count">{{ domains.length }} 个域名</span>
      </div>
      <el-button type="primary" @click="showAddDialog = true">
        <el-icon><Plus /></el-icon>
        添加域名
      </el-button>
    </div>

    <!-- 域名表格 -->
    <el-table :data="domains" class="domain-table" stripe>
      <!-- 域名 -->
      <el-table-column label="域名" min-width="220">
        <template #default="{ row }">
          <div class="domain-cell">
            <el-icon v-if="row.is_primary" class="star-icon" color="#e6a23c"><StarFilled /></el-icon>
            <span class="domain-name">{{ row.domain_name }}</span>
            <el-tag v-if="row.is_primary" size="small" type="warning" effect="plain">主域名</el-tag>
          </div>
        </template>
      </el-table-column>

      <!-- 状态 -->
      <el-table-column label="状态" width="120" align="center">
        <template #default="{ row }">
          <el-tag :type="statusType(row.status)" size="small" effect="dark">
            {{ statusLabel(row.status) }}
          </el-tag>
        </template>
      </el-table-column>

      <!-- 验证记录 -->
      <el-table-column label="TXT 验证记录" min-width="200">
        <template #default="{ row }">
          <code class="verification-code">{{ row.verification_record }}</code>
        </template>
      </el-table-column>

      <!-- 添加时间 -->
      <el-table-column label="添加时间" width="140">
        <template #default="{ row }">
          {{ formatTime(row.created_at) }}
        </template>
      </el-table-column>

      <!-- 操作 -->
      <el-table-column label="操作" width="220" align="center" fixed="right">
        <template #default="{ row }">
          <el-button
            v-if="row.status === 'pending'"
            size="small"
            type="primary"
            :loading="verifyingId === row.id"
            @click="handleVerify(row)"
          >
            验证
          </el-button>
          <el-button
            v-if="!row.is_primary"
            size="small"
            @click="handleSetPrimary(row)"
          >
            设为主域名
          </el-button>
          <el-button
            size="small"
            type="danger"
            @click="handleDelete(row)"
          >
            <el-icon><Delete /></el-icon>
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 空状态 -->
    <el-empty v-if="!domains.length" description="暂无绑定域名" />

    <!-- ====== 添加域名对话框 ====== -->
    <el-dialog
      v-model="showAddDialog"
      title="添加域名"
      width="480px"
      destroy-on-close
    >
      <el-form
        ref="formRef"
        :model="addForm"
        :rules="rules"
        label-position="top"
        @submit.prevent="handleAddDomain"
      >
        <el-form-item label="域名" prop="domainName">
          <el-input
            v-model="addForm.domainName"
            placeholder="例如：mydomain.com"
            size="large"
          >
            <template #prepend>https://</template>
          </el-input>
        </el-form-item>
        <p class="form-tip">
          添加域名后，请前往域名服务商添加以下 TXT 记录以完成验证。
        </p>
      </el-form>

      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="handleAddDomain">确认添加</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, StarFilled, Delete } from '@element-plus/icons-vue'
import { getDomains, addDomain, verifyDomain, setPrimary, deleteDomain } from '@/api/domain'

const props = defineProps({
  siteId: { type: [Number, String], required: true }
})

// ====== 域名列表 ======
const domains = ref([...getDomains(Number(props.siteId))])

// ====== 验证状态 ======
const verifyingId = ref(null)

// ====== 添加对话框 ======
const showAddDialog = ref(false)
const formRef = ref(null)
const addForm = reactive({ domainName: '' })

const rules = {
  domainName: [
    { required: true, message: '请输入域名', trigger: 'blur' },
    { pattern: /^[a-zA-Z0-9](-?[a-zA-Z0-9])*(\.[a-zA-Z0-9](-?[a-zA-Z0-9])*)+$/, message: '域名格式不正确，至少包含一个点', trigger: 'blur' }
  ]
}

// ====== 方法 ======

function statusType(status) {
  return { pending: 'info', verified: 'success', failed: 'danger' }[status] || 'info'
}

function statusLabel(status) {
  return { pending: '待验证', verified: '已验证', failed: '验证失败' }[status] || status
}

function formatTime(t) {
  if (!t) return '-'
  const d = new Date(t)
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')} ${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`
}

/** 添加域名 */
function handleAddDomain() {
  formRef.value?.validate(valid => {
    if (!valid) return
    const newDomain = addDomain(Number(props.siteId), addForm.domainName)
    domains.value.unshift({ ...newDomain })
    ElMessage.success('域名添加成功')
    showAddDialog.value = false
    addForm.domainName = ''
  })
}

/** 验证域名（模拟异步） */
async function handleVerify(row) {
  verifyingId.value = row.id
  const result = await verifyDomain(row.id)
  verifyingId.value = null
  ElMessage({ type: result.success ? 'success' : 'error', message: result.message })
  // 刷新列表以更新状态
  domains.value = [...getDomains(Number(props.siteId))]
}

/** 设置主域名 */
function handleSetPrimary(row) {
  setPrimary(row.id)
  domains.value = [...getDomains(Number(props.siteId))]
  ElMessage.success(`已将 "${row.domain_name}" 设为主域名`)
}

/** 删除域名 */
function handleDelete(row) {
  ElMessageBox.confirm(
    `确定删除域名 "${row.domain_name}" 吗？删除后不可恢复。`,
    '确认删除',
    { confirmButtonText: '删除', cancelButtonText: '取消', type: 'warning' }
  ).then(() => {
    deleteDomain(row.id)
    domains.value = [...getDomains(Number(props.siteId))]
    ElMessage.success('域名已删除')
  }).catch(() => {})
}
</script>

<style scoped>
.domain-management {
  padding: 8px 0;
}

/* 工具栏 */
.domain-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.toolbar-left {
  display: flex;
  align-items: baseline;
  gap: 10px;
}

.toolbar-title {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

.toolbar-count {
  font-size: 13px;
  color: #909399;
}

/* 表格 */
.domain-table {
  border-radius: 8px;
  overflow: hidden;
}

.domain-cell {
  display: flex;
  align-items: center;
  gap: 8px;
}

.star-icon {
  flex-shrink: 0;
}

.domain-name {
  font-weight: 500;
  color: #303133;
}

.verification-code {
  font-size: 12px;
  background: #f5f7fa;
  padding: 3px 8px;
  border-radius: 4px;
  color: #606266;
  font-family: 'Menlo', 'Consolas', monospace;
}

/* 表单提示 */
.form-tip {
  margin: -8px 0 0;
  font-size: 12px;
  color: #909399;
  line-height: 1.5;
}
</style>
