<template>
  <div class="domain-page">
    <!-- Hero 头部 -->
    <div class="hero-section">
      <div class="hero-bg-shapes">
        <span class="shape shape-1" />
        <span class="shape shape-2" />
      </div>
      <div class="hero-content">
        <div class="hero-text">
          <h1 class="hero-title">域名管理<span class="hero-dot" /></h1>
          <p class="hero-subtitle">管理你的站点域名，绑定自定义域名提升品牌形象</p>
          <div class="hero-stats">
            <div class="hero-stat">
              <span class="stat-num">{{ totalDomains }}</span>
              <span class="stat-text">域名总数</span>
            </div>
            <div class="hero-divider"></div>
            <div class="hero-stat">
              <span class="stat-num">{{ verifiedCount }}</span>
              <span class="stat-text">已验证</span>
            </div>
            <div class="hero-divider"></div>
            <div class="hero-stat">
              <span class="stat-num">{{ pendingCount }}</span>
              <span class="stat-text">待验证</span>
            </div>
          </div>
        </div>
        <div class="hero-actions">
          <el-button type="primary" size="large" round @click="showAddDialog = true">
            <el-icon><Plus /></el-icon>
            添加域名
          </el-button>
        </div>
      </div>
    </div>

    <!-- 站点筛选 -->
    <div class="filter-bar">
      <div class="filter-label">选择站点：</div>
      <el-select v-model="selectedSiteId" placeholder="全部站点" clearable style="width: 240px" @change="handleSiteChange">
        <el-option v-for="site in sites" :key="site.id" :label="site.name" :value="site.id" />
      </el-select>
    </div>

    <!-- 域名卡片列表 -->
    <div v-if="filteredDomains.length" class="domain-grid">
      <div v-for="(domain, idx) in filteredDomains" :key="domain.id" class="domain-card" :style="{ animationDelay: idx * 0.05 + 's' }">
        <!-- 顶部状态条 -->
        <div class="card-status-bar" :class="statusBarClass(domain.status)"></div>
        
        <!-- 主内容 -->
        <div class="card-body">
          <div class="card-header">
            <div class="domain-name-wrap">
              <el-icon v-if="domain.is_primary" class="star-icon" color="#e6a23c"><StarFilled /></el-icon>
              <h4 class="domain-name">{{ domain.domain_name }}</h4>
            </div>
            <el-tag :type="statusType(domain.status)" size="small" effect="dark">
              {{ statusLabel(domain.status) }}
            </el-tag>
          </div>
          
          <div class="card-meta">
            <span class="meta-item">
              <el-icon><Monitor /></el-icon>
              {{ getSiteName(domain.site_id) }}
            </span>
            <span class="meta-item">
              <el-icon><Clock /></el-icon>
              {{ formatTime(domain.created_at) }}
            </span>
          </div>

          <!-- 验证记录 -->
          <div class="verification-box">
            <span class="v-label">TXT 记录：</span>
            <code class="v-code">{{ domain.verification_record }}</code>
          </div>
        </div>

        <!-- 操作按钮 -->
        <div class="card-actions">
          <el-button v-if="domain.status === 'pending'" type="primary" size="small" :loading="verifyingId === domain.id" @click="handleVerify(domain)">
            验证
          </el-button>
          <el-button v-if="!domain.is_primary" size="small" @click="handleSetPrimary(domain)">
            设为主域名
          </el-button>
          <el-button size="small" type="danger" @click="handleDelete(domain)">
            <el-icon><Delete /></el-icon>
          </el-button>
        </div>
      </div>
    </div>

    <!-- 空状态 -->
    <div v-else class="empty-state">
      <el-icon :size="48"><Link /></el-icon>
      <h3>暂无域名</h3>
      <p>点击右上角「添加域名」开始绑定你的第一个域名</p>
    </div>

    <!-- 添加域名对话框 -->
    <el-dialog v-model="showAddDialog" title="添加域名" width="520px" destroy-on-close>
      <el-form ref="formRef" :model="addForm" :rules="rules" label-position="top">
        <el-form-item label="选择站点" prop="siteId">
          <el-select v-model="addForm.siteId" placeholder="选择要绑定域名的站点" style="width: 100%">
            <el-option v-for="site in sites" :key="site.id" :label="site.name" :value="site.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="域名" prop="domainName">
          <el-input v-model="addForm.domainName" placeholder="例如：mydomain.com">
            <template #prepend>https://</template>
          </el-input>
        </el-form-item>
        <div class="form-tip">
          <p>添加域名后，请前往域名服务商添加以下 TXT 记录以完成验证：</p>
          <code class="tip-code">TXT @ {{ mockTxtRecord }}</code>
        </div>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="handleAdd">确认添加</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, StarFilled, Delete, Monitor, Clock, Link } from '@element-plus/icons-vue'
import { mockDomains, getDomains, addDomain, verifyDomain, setPrimary, deleteDomain } from '@/api/domain'

// ====== 站点数据（伪数据） ======
const sites = ref([
  { id: 1, name: 'FashionVibe 时尚馆' },
  { id: 2, name: 'TechGadget Pro' },
  { id: 3, name: 'HomeLiving 居家生活馆' },
  { id: 4, name: 'BeautyGlow 美妆坊' }
])

// ====== 域名数据 ======
const allDomains = ref([...mockDomains])
const selectedSiteId = ref('')
const verifyingId = ref(null)

// ====== 筛选后的域名 ======
const filteredDomains = computed(() => {
  if (!selectedSiteId.value) return allDomains.value
  return allDomains.value.filter(d => d.site_id === selectedSiteId.value)
})

// ====== 统计数据 ======
const totalDomains = computed(() => allDomains.value.length)
const verifiedCount = computed(() => allDomains.value.filter(d => d.status === 'verified').length)
const pendingCount = computed(() => allDomains.value.filter(d => d.status === 'pending').length)

// ====== 添加对话框 ======
const showAddDialog = ref(false)
const formRef = ref(null)
const addForm = reactive({ siteId: '', domainName: '' })
const mockTxtRecord = 'site-verify-xxxxxx'

const rules = {
  siteId: [{ required: true, message: '请选择站点', trigger: 'change' }],
  domainName: [
    { required: true, message: '请输入域名', trigger: 'blur' },
    { pattern: /^[a-zA-Z0-9](-?[a-zA-Z0-9])*(\.[a-zA-Z0-9](-?[a-zA-Z0-9])*)+$/, message: '域名格式不正确', trigger: 'blur' }
  ]
}

// ====== 方法 ======
function statusType(status) {
  return { pending: 'info', verified: 'success', failed: 'danger' }[status] || 'info'
}

function statusLabel(status) {
  return { pending: '待验证', verified: '已验证', failed: '验证失败' }[status] || status
}

function statusBarClass(status) {
  return { pending: 'bar-pending', verified: 'bar-verified', failed: 'bar-failed' }[status]
}

function getSiteName(siteId) {
  const site = sites.value.find(s => s.id === siteId)
  return site ? site.name : '未知站点'
}

function formatTime(t) {
  if (!t) return '-'
  const d = new Date(t)
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

function handleSiteChange() {
  // 筛选变化时自动刷新
}

function handleAdd() {
  formRef.value?.validate(valid => {
    if (!valid) return
    const newDomain = addDomain(Number(addForm.siteId), addForm.domainName)
    allDomains.value.unshift({ ...newDomain })
    ElMessage.success('域名添加成功')
    showAddDialog.value = false
    addForm.siteId = ''
    addForm.domainName = ''
  })
}

async function handleVerify(domain) {
  verifyingId.value = domain.id
  const result = await verifyDomain(domain.id)
  verifyingId.value = null
  ElMessage({ type: result.success ? 'success' : 'error', message: result.message })
  // 刷新
  const idx = allDomains.value.findIndex(d => d.id === domain.id)
  if (idx > -1) {
    const updated = mockDomains.find(d => d.id === domain.id)
    if (updated) allDomains.value[idx] = { ...updated }
  }
}

function handleSetPrimary(domain) {
  setPrimary(domain.id)
  // 刷新所有域名状态
  allDomains.value = allDomains.value.map(d => ({
    ...d,
    is_primary: d.site_id === domain.site_id ? d.id === domain.id : d.is_primary
  }))
  ElMessage.success(`已将 "${domain.domain_name}" 设为主域名`)
}

function handleDelete(domain) {
  ElMessageBox.confirm(
    `确定删除域名 "${domain.domain_name}" 吗？`,
    '确认删除',
    { confirmButtonText: '删除', cancelButtonText: '取消', type: 'warning' }
  ).then(() => {
    deleteDomain(domain.id)
    allDomains.value = allDomains.value.filter(d => d.id !== domain.id)
    ElMessage.success('域名已删除')
  }).catch(() => {})
}
</script>

<style scoped>
.domain-page { max-width: 1200px; margin: 0 auto; }

/* ===== Hero ===== */
.hero-section {
  position: relative;
  background: linear-gradient(135deg, #e8f4fd 0%, #f0f7ff 40%, #f5f9fc 100%);
  border-radius: 20px;
  padding: 36px 40px;
  margin-bottom: 24px;
  overflow: hidden;
}
.hero-bg-shapes { position: absolute; inset: 0; pointer-events: none; }
.shape { position: absolute; border-radius: 50%; opacity: 0.1; }
.shape-1 { width: 260px; height: 260px; background: radial-gradient(circle, #409eff, transparent); top: -60px; right: -40px; }
.shape-2 { width: 180px; height: 180px; background: radial-gradient(circle, #a78bfa, transparent); bottom: -30px; left: 15%; }

.hero-content { position: relative; z-index: 1; display: flex; justify-content: space-between; align-items: flex-start; }
.hero-title { margin: 0; font-size: 36px; font-weight: 800; color: #1a1a2e; display: flex; align-items: center; gap: 8px; }
.hero-dot { width: 10px; height: 10px; border-radius: 50%; background: linear-gradient(135deg, #409eff, #a78bfa); display: inline-block; }
.hero-subtitle { margin: 8px 0 0; font-size: 15px; color: #6b7280; }
.hero-stats { display: flex; align-items: center; gap: 24px; margin-top: 20px; }
.hero-stat { display: flex; flex-direction: column; gap: 2px; }
.stat-num { font-size: 28px; font-weight: 800; color: #1a1a2e; }
.stat-text { font-size: 13px; color: #909399; }
.hero-divider { width: 1px; height: 36px; background: #e4e7ed; }
.hero-actions { flex-shrink: 0; }

/* ===== 筛选栏 ===== */
.filter-bar { display: flex; align-items: center; gap: 10px; margin-bottom: 20px; background: #fff; padding: 14px 18px; border-radius: 12px; border: 1px solid #ebeef5; }
.filter-label { font-size: 14px; color: #606266; font-weight: 500; }

/* ===== 域名网格 ===== */
.domain-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; }
@media (max-width: 900px) { .domain-grid { grid-template-columns: 1fr; } }

.domain-card {
  background: #fff;
  border-radius: 14px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0,0,0,.04);
  border: 1px solid rgba(0,0,0,.04);
  animation: fadeInUp 0.5s ease backwards;
}
@keyframes fadeInUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }

.card-status-bar { height: 4px; }
.bar-pending { background: linear-gradient(90deg, #909399, #c0c4cc); }
.bar-verified { background: linear-gradient(90deg, #52c41a, #73d13d); }
.bar-failed { background: linear-gradient(90deg, #f56c6c, #f89898); }

.card-body { padding: 18px 20px 14px; }
.card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
.domain-name-wrap { display: flex; align-items: center; gap: 8px; }
.star-icon { flex-shrink: 0; }
.domain-name { margin: 0; font-size: 16px; font-weight: 700; color: #1a1a2e; }

.card-meta { display: flex; gap: 16px; margin-bottom: 12px; }
.meta-item { display: flex; align-items: center; gap: 4px; font-size: 12px; color: #909399; }

.verification-box { background: #f8f9fa; border-radius: 8px; padding: 10px 12px; display: flex; gap: 8px; align-items: center; }
.v-label { font-size: 12px; color: #909399; flex-shrink: 0; }
.v-code { font-size: 12px; background: #fff; padding: 2px 8px; border-radius: 4px; color: #606266; font-family: monospace; }

.card-actions { display: flex; gap: 8px; padding: 0 20px 16px; }

/* ===== 空状态 ===== */
.empty-state { display: flex; flex-direction: column; align-items: center; padding: 80px 20px; color: #c0c4cc; }
.empty-state h3 { margin: 16px 0 4px; color: #606266; font-weight: 500; }
.empty-state p { margin: 0; color: #909399; font-size: 13px; }

/* ===== 表单提示 ===== */
.form-tip { margin-top: 8px; padding: 12px; background: #f8f9fa; border-radius: 8px; }
.form-tip p { margin: 0 0 8px; font-size: 12px; color: #909399; }
.tip-code { display: block; font-size: 13px; background: #fff; padding: 8px 12px; border-radius: 6px; color: #409eff; font-family: monospace; border: 1px dashed #c4cdff; }
</style>
