<template>
  <div class="site-list-page">
    <!-- ====== Hero 头部 ====== -->
    <div class="hero-section">
      <div class="hero-bg-shapes">
        <span class="shape shape-1"></span>
        <span class="shape shape-2"></span>
        <span class="shape shape-3"></span>
      </div>
      <div class="hero-content">
        <div class="hero-text">
          <h1 class="hero-title">我的站点<span class="hero-dot"></span></h1>
          <p class="hero-subtitle">管理你的独立站，追踪数据增长</p>
          <div class="hero-stats">
            <div class="hero-stat">
              <span class="stat-num">{{ activeSites.length }}</span>
              <span class="stat-text">站点总数</span>
            </div>
            <div class="hero-divider"></div>
            <div class="hero-stat hero-stat-clickable" :class="{ 'stat-active': statusFilter === 'published' }" @click="filterByStatus('published')">
              <span class="stat-num">{{ publishedCount }}</span>
              <span class="stat-text">已发布</span>
            </div>
            <div class="hero-divider"></div>
            <div class="hero-stat hero-stat-clickable" :class="{ 'stat-active': statusFilter === 'draft' }" @click="filterByStatus('draft')">
              <span class="stat-num">{{ draftCount }}</span>
              <span class="stat-text">草稿</span>
            </div>
            <div class="hero-divider"></div>
            <div class="hero-stat hero-stat-clickable" :class="{ 'stat-active': statusFilter === 'paused' }" @click="filterByStatus('paused')">
              <span class="stat-num">{{ pausedCount }}</span>
              <span class="stat-text">已暂停</span>
            </div>
          </div>
        </div>
        <div class="hero-actions">
          <el-button type="primary" size="large" round @click="goToCreate">
            <el-icon><Plus /></el-icon>
            创建新站点
          </el-button>
        </div>
      </div>
    </div>

    <!-- ====== 搜索 + 筛选 ====== -->
    <div class="toolbar">
      <div class="search-wrap">
        <el-icon class="search-icon"><Search /></el-icon>
        <input
          v-model="searchQuery"
          type="text"
          placeholder="搜索站点名称..."
          class="search-field"
          @input="handleSearch"
        />
        <el-icon v-if="searchQuery" class="search-clear" @click="searchQuery = ''; handleSearch()"><CircleClose /></el-icon>
      </div>

      <div class="toolbar-filters">
        <button
          v-for="f in statusFilters"
          :key="f.key"
          class="filter-chip"
          :class="{ active: statusFilter === f.key }"
          @click="statusFilter = statusFilter === f.key ? '' : f.key; handleFilter()"
        >
          <span v-if="f.dotClass" class="chip-dot" :class="f.dotClass" />
          <el-icon v-else-if="f.key === 'trash'" :size="14"><Delete /></el-icon>
          {{ f.label }}
          <span v-if="f.key && f.key !== 'trash' && statusFilter !== f.key" class="chip-count">{{ countByStatus(f.key) }}</span>
          <span v-if="f.key === 'trash' && statusFilter !== 'trash'" class="chip-count">{{ trashCount }}</span>
        </button>
      </div>
    </div>

    <!-- ====== 站点卡片网格（正常视图） ====== -->
    <template v-if="statusFilter !== 'trash'">
      <div v-if="paginatedSites.length" class="site-grid">
        <div v-for="(site, idx) in paginatedSites" :key="site.id" class="grid-item" :style="{ animationDelay: idx * 0.05 + 's' }">
          <div class="site-card" @click="goToDetail(site.id)">
            <!-- 顶部状态条 -->
            <div class="card-top-bar" :class="statusBarClass(site.status)" />

            <!-- 图标区 -->
            <div class="card-icon-wrap" :class="statusIconClass(site.status)">
              <el-icon :size="26"><Monitor /></el-icon>
            </div>

            <!-- 信息区 -->
            <div class="card-body">
              <div class="card-header">
                <h3 class="card-name">{{ site.name }}</h3>
                <span class="card-status" :class="statusTextClass(site.status)">{{ statusLabel(site.status) }}</span>
              </div>
              <p class="card-domain">{{ site.domain || '未绑定域名' }}</p>

              <!-- 标签 -->
              <div class="card-tags">
                <span v-if="site.template_name" class="tag-item">{{ site.template_name }}</span>
                <span v-if="site.industry" class="tag-item tag-industry">{{ site.industry }}</span>
              </div>

              <!-- 数据统计 -->
              <div class="card-stats">
                <div class="stat-block">
                  <span class="stat-val">{{ formatNumber(site.visits) }}</span>
                  <span class="stat-lbl">访问量</span>
                </div>
                <div class="stat-divider" />
                <div class="stat-block">
                  <span class="stat-val">{{ formatNumber(site.orders) }}</span>
                  <span class="stat-lbl">订单数</span>
                </div>
                <div class="stat-divider" />
                <div class="stat-block">
                  <span class="stat-val">{{ site.conversion_rate }}%</span>
                  <span class="stat-lbl">转化率</span>
                </div>
              </div>
            </div>

            <!-- 悬浮操作层 -->
            <div class="card-overlay">
              <el-button size="default" round class="overlay-btn" @click.stop="goToPreview(site)">
                <el-icon><View /></el-icon>
                预览
              </el-button>
              <el-button size="default" round class="overlay-btn" @click.stop="handleClone(site)">
                <el-icon><CopyDocument /></el-icon>
                复制
              </el-button>
              <el-button
                v-if="site.status !== 'published' && site.status !== 'archived'"
                size="default" round class="overlay-btn overlay-publish"
                @click.stop="handlePublish(site)"
              >
                <el-icon><CaretRight /></el-icon>
                发布
              </el-button>
              <el-button
                v-if="site.status === 'archived'"
                size="default" round class="overlay-btn overlay-publish"
                @click.stop="handlePublish(site)"
              >
                <el-icon><CaretRight /></el-icon>
                重新发布
              </el-button>
              <el-dropdown trigger="click" @command="(cmd) => handleMoreAction(cmd, site)">
                <el-button size="default" round class="overlay-btn">
                  <el-icon><MoreFilled /></el-icon>
                  更多
                </el-button>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="edit">
                      <el-icon><Edit /></el-icon> 编辑
                    </el-dropdown-item>
                    <el-dropdown-item command="config">
                      <el-icon><Setting /></el-icon> 配置
                    </el-dropdown-item>
                    <el-dropdown-item v-if="site.status === 'published'" command="pause">
                      <el-icon><VideoPause /></el-icon> 暂停
                    </el-dropdown-item>
                    <el-dropdown-item command="delete" divided>
                      <el-icon><Delete /></el-icon> 删除
                    </el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>
          </div>

          <p class="card-footer-text">创建于 {{ formatTime(site.created_at) }}</p>
        </div>
      </div>

      <!-- 空状态 -->
      <div v-else class="empty-state">
        <el-empty :image-size="180" description=" " />
        <h3>暂无站点数据</h3>
        <p>开始你的第一个独立站吧</p>
        <el-button type="primary" size="large" round @click="goToCreate" style="margin-top: 20px;">
          <el-icon><Plus /></el-icon>
          创建你的第一个站点
        </el-button>
      </div>

      <!-- 分页 -->
      <div v-if="filteredSites.length > pageSize" class="pagination-wrap">
        <el-pagination v-model:current-page="currentPage" :page-size="pageSize" :total="filteredSites.length" layout="prev, pager, next" background />
      </div>
    </template>

    <!-- ====== 回收站视图 ====== -->
    <template v-if="statusFilter === 'trash'">
      <div v-if="trashSites.length" class="site-grid">
        <div v-for="(site, idx) in trashSites" :key="site.id" class="grid-item" :style="{ animationDelay: idx * 0.05 + 's' }">
          <div class="site-card">
            <!-- 顶部状态条 -->
            <div class="card-top-bar bar-deleted" />

            <!-- 图标区 -->
            <div class="card-icon-wrap icon-deleted">
              <el-icon :size="26"><Delete /></el-icon>
            </div>

            <!-- 信息区 -->
            <div class="card-body">
              <div class="card-header">
                <h3 class="card-name">{{ site.name }}</h3>
                <span class="card-status txt-deleted">回收站中</span>
              </div>
              <p class="card-domain">{{ site.domain || '未绑定域名' }}</p>

              <div class="card-tags">
                <span v-if="site.template_name" class="tag-item">{{ site.template_name }}</span>
                <span v-if="site.industry" class="tag-item tag-industry">{{ site.industry }}</span>
              </div>

              <div class="deleted-notice">
                <el-icon><InfoFilled /></el-icon>
                <span>此站点已在回收站中</span>
              </div>
            </div>

            <!-- 回收站操作层 -->
            <div class="card-overlay">
              <el-button size="default" round class="overlay-btn overlay-publish" @click.stop="handleRestore(site)">
                <el-icon><Refresh /></el-icon>
                恢复
              </el-button>
              <el-button size="default" round class="overlay-btn overlay-danger" @click.stop="handlePermanentDelete(site)">
                <el-icon><Delete /></el-icon>
                永久删除
              </el-button>
            </div>
          </div>
          <p class="card-footer-text">删除于 {{ formatTime(site.updated_at) }}</p>
        </div>
      </div>

      <!-- 回收站空状态 -->
      <div v-else class="empty-state">
        <el-icon :size="48"><Delete /></el-icon>
        <h3>回收站为空</h3>
        <p>删除的站点会进入回收站，您可以在这里恢复或永久删除</p>
      </div>
    </template>

    <!-- ====== 复制站点对话框 ====== -->
    <el-dialog
      v-model="showCloneDialog"
      title="复制站点"
      width="420px"
      :close-on-click-modal="false"
      @close="cloneForm.name = ''"
    >
      <el-form :model="cloneForm" :rules="cloneRules" label-width="0">
        <el-form-item prop="name">
          <el-input
            v-model="cloneForm.name"
            placeholder="请输入新站点名称"
            size="large"
            clearable
            autofocus
          />
        </el-form-item>
      </el-form>
      <div v-if="cloneSource" class="clone-info">
        <p>将基于「<strong>{{ cloneSource.name }}</strong>」创建副本</p>
        <p class="clone-detail">模板：{{ cloneSource.template_name }} ｜ 行业：{{ cloneSource.industry }}</p>
      </div>
      <template #footer>
        <el-button @click="showCloneDialog = false">取消</el-button>
        <el-button type="primary" @click="handleCloneConfirm">确认复制</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Search, Monitor, Edit, Setting, Delete, CaretRight, VideoPause, CircleClose, View, Refresh, InfoFilled, CopyDocument, MoreFilled } from '@element-plus/icons-vue'

const router = useRouter()

const mockSites = [
  { id: 1, name: 'FashionVibe 时尚馆', domain: 'fashionvibe.com', industry: '服装', template_id: 1, template_name: '时尚精品', status: 'published', visits: 28450, orders: 1234, conversion_rate: 4.3, avg_order_value: 89.5, created_at: '2026-01-15T08:00:00Z' },
  { id: 2, name: 'TechGadget Pro', domain: 'techgadget.shop', industry: '数码', template_id: 2, template_name: '科技极简', status: 'published', visits: 56780, orders: 2890, conversion_rate: 5.1, avg_order_value: 156.0, created_at: '2026-02-20T10:00:00Z' },
  { id: 3, name: 'HomeLiving 居家生活馆', domain: 'homeliving.store', industry: '家居', template_id: 3, template_name: '温馨家居', status: 'draft', visits: 0, orders: 0, conversion_rate: 0, avg_order_value: 0, created_at: '2026-04-05T09:15:00Z' },
  { id: 4, name: 'BeautyGlow 美妆坊', domain: 'beautyglow.com', industry: '美妆', template_id: 1, template_name: '时尚精品', status: 'published', visits: 12340, orders: 567, conversion_rate: 4.6, avg_order_value: 65.0, created_at: '2026-03-10T11:30:00Z' },
  { id: 5, name: 'PetPals 宠物乐园', domain: 'petpals.shop', industry: '宠物', template_id: 4, template_name: '可爱风格', status: 'paused', visits: 8900, orders: 345, conversion_rate: 3.9, avg_order_value: 52.0, created_at: '2026-02-01T14:00:00Z' },
  { id: 6, name: 'SportMax 运动装备', domain: 'sportmax.store', industry: '运动', template_id: 5, template_name: '运动活力', status: 'published', visits: 34560, orders: 1678, conversion_rate: 4.8, avg_order_value: 120.0, created_at: '2026-01-28T07:45:00Z' },
  { id: 7, name: 'BabyJoy 母婴优选', domain: 'babyjoy.com', industry: '母婴', template_id: 3, template_name: '温馨家居', status: 'draft', visits: 0, orders: 0, conversion_rate: 0, avg_order_value: 0, created_at: '2026-05-18T16:30:00Z' },
  { id: 8, name: 'GreenLeaf 有机食品', domain: 'greenleaf.farm', industry: '食品', template_id: 6, template_name: '自然生态', status: 'published', visits: 19800, orders: 912, conversion_rate: 4.6, avg_order_value: 78.0, created_at: '2026-03-22T13:00:00Z' },
  { id: 9, name: 'BookNook 书中屋', domain: 'booknook.shop', industry: '教育', template_id: 2, template_name: '科技极简', status: 'paused', visits: 4500, orders: 189, conversion_rate: 4.2, avg_order_value: 35.0, created_at: '2026-04-12T10:00:00Z' },
  { id: 10, name: 'JewelryCraft 手工饰品', domain: 'jewelrycraft.com', industry: '珠宝', template_id: 1, template_name: '时尚精品', status: 'published', visits: 9200, orders: 445, conversion_rate: 4.8, avg_order_value: 200.0, created_at: '2026-02-14T09:00:00Z' },
  { id: 11, name: 'ArtSpace 艺术空间', domain: 'artspace.shop', industry: '家居', template_id: 6, template_name: '自然生态', status: 'archived', visits: 3200, orders: 128, conversion_rate: 4.0, avg_order_value: 45.0, created_at: '2026-05-01T10:00:00Z', updated_at: '2026-05-20T14:00:00Z' },
  { id: 12, name: 'CoffeeHub 咖啡驿站', domain: 'coffeehub.store', industry: '食品', template_id: 6, template_name: '自然生态', status: 'deleted', visits: 1500, orders: 67, conversion_rate: 4.5, avg_order_value: 28.0, created_at: '2026-04-10T08:00:00Z', updated_at: '2026-06-01T11:00:00Z' }
]

const statusFilters = [
  { key: '', label: '全部', dotClass: '' },
  { key: 'published', label: '已发布', dotClass: 'dot-green' },
  { key: 'draft', label: '草稿', dotClass: 'dot-gray' },
  { key: 'paused', label: '已暂停', dotClass: 'dot-orange' },
  { key: 'archived', label: '已下线', dotClass: 'dot-red' },
  { key: 'trash', label: '回收站', dotClass: '' }
]

const sites = ref(mockSites)
const searchQuery = ref('')
const statusFilter = ref('')
const currentPage = ref(1)
const pageSize = 9

// 克隆站点
const showCloneDialog = ref(false)
const cloneSource = ref(null)
const cloneForm = reactive({ name: '' })
const cloneRules = {
  name: [
    { required: true, message: '请输入新站点名称', trigger: 'blur' },
    { min: 2, max: 50, message: '名称长度 2-50 个字符', trigger: 'blur' }
  ]
}

// 排除 deleted 的活跃站点
const activeSites = computed(() => sites.value.filter(s => s.status !== 'deleted'))
const trashSites = computed(() => sites.value.filter(s => s.status === 'deleted'))
const trashCount = computed(() => trashSites.value.length)

const publishedCount = computed(() => activeSites.value.filter(s => s.status === 'published').length)
const draftCount = computed(() => activeSites.value.filter(s => s.status === 'draft').length)
const pausedCount = computed(() => activeSites.value.filter(s => s.status === 'paused').length)

const filteredSites = computed(() => {
  let list = [...activeSites.value]
  if (searchQuery.value) { const q = searchQuery.value.toLowerCase(); list = list.filter(s => s.name.toLowerCase().includes(q)) }
  if (statusFilter.value) list = list.filter(s => s.status === statusFilter.value)
  return list
})

const paginatedSites = computed(() => filteredSites.value.slice((currentPage.value - 1) * pageSize, currentPage.value * pageSize))

// ====== 辅助函数 ======
function countByStatus(s) { return activeSites.value.filter(item => item.status === s).length }
function handleSearch() { currentPage.value = 1 }
function handleFilter() { currentPage.value = 1 }
function filterByStatus(status) { statusFilter.value = statusFilter.value === status ? '' : status; handleFilter() }
function goToCreate() { router.push('/website/create') }
function goToDetail(id) { router.push(`/website/${id}`) }
function goToEdit(id) { router.push(`/website/${id}?tab=settings`) }

/** 更多操作下拉菜单 */
function handleMoreAction(cmd, site) {
  if (cmd === 'edit') goToEdit(site.id)
  else if (cmd === 'config') goToDetail(site.id)
  else if (cmd === 'pause') handlePause(site)
  else if (cmd === 'delete') handleSoftDelete(site)
}

/** 预览站点 — 新窗口打开预览页 */
function goToPreview(site) {
  window.open(`/website/${site.id}/preview`, '_blank')
}

/** 发布站点 */
function handlePublish(site) {
  if (site.status === 'archived') {
    site.status = 'published'
    ElMessage.success(`"${site.name}" 已重新发布`)
  } else {
    site.status = 'published'
    ElMessage.success(`"${site.name}" 已发布`)
  }
}

/** 暂停站点 */
function handlePause(site) {
  site.status = 'paused'
  ElMessage.success(`"${site.name}" 已暂停`)
}

/** 软删除 — 输入站点名称确认 */
function handleSoftDelete(site) {
  ElMessageBox.prompt(
    `确定删除 "${site.name}"？请输入站点名称以确认操作：`,
    '确认删除',
    {
      confirmButtonText: '确认删除',
      cancelButtonText: '取消',
      inputPattern: new RegExp(`^${escapeRegex(site.name)}$`),
      inputErrorMessage: `请输入 "${site.name}" 以确认`,
      type: 'warning'
    }
  ).then(({ value }) => {
    if (value === site.name) {
      site.status = 'deleted'
      site.updated_at = new Date().toISOString()
      ElMessage.success(`"${site.name}" 已移入回收站`)
    }
  }).catch(() => {})
}

/** 从回收站恢复 */
function handleRestore(site) {
  ElMessageBox.confirm(
    `确定恢复站点 "${site.name}" 吗？恢复后状态将变为草稿。`,
    '确认恢复',
    { confirmButtonText: '恢复', cancelButtonText: '取消', type: 'info' }
  ).then(() => {
    site.status = 'draft'
    site.updated_at = new Date().toISOString()
    ElMessage.success(`"${site.name}" 已恢复`)
  }).catch(() => {})
}

/** 永久删除 */
function handlePermanentDelete(site) {
  ElMessageBox.confirm(
    `确定永久删除 "${site.name}"？此操作不可恢复！`,
    '警告',
    { confirmButtonText: '永久删除', cancelButtonText: '取消', type: 'error', confirmButtonClass: 'el-button--danger' }
  ).then(() => {
    sites.value = sites.value.filter(s => s.id !== site.id)
    ElMessage.success(`"${site.name}" 已永久删除`)
  }).catch(() => {})
}

/** 打开克隆对话框 */
function handleClone(site) {
  cloneSource.value = site
  cloneForm.name = site.name + ' 副本'
  showCloneDialog.value = true
}

/** 确认克隆 */
function handleCloneConfirm() {
  if (!cloneForm.name.trim()) {
    ElMessage.warning('请输入站点名称')
    return
  }
  const source = cloneSource.value
  if (!source) return
  const maxId = Math.max(...sites.value.map(s => s.id), 0)
  const newSite = {
    id: maxId + 1,
    name: cloneForm.name.trim(),
    domain: source.domain ? `${source.domain.split('.')[0]}-new.${source.domain.split('.').slice(1).join('.')}` : '',
    industry: source.industry,
    template_id: source.template_id,
    template_name: source.template_name,
    status: 'draft',
    visits: 0, orders: 0, conversion_rate: 0, avg_order_value: 0,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  }
  sites.value.unshift(newSite)
  showCloneDialog.value = false
  cloneForm.name = ''
  ElMessage.success(`已成功复制站点「${newSite.name}」`)
}

/** 转义正则特殊字符 */
function escapeRegex(str) {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
}

// ====== 状态映射 ======
function statusLabel(s) {
  return { draft: '草稿', published: '已发布', paused: '已暂停', archived: '已下线', deleted: '回收站中' }[s] || s
}
function statusBarClass(s) {
  return { draft: 'bar-draft', published: 'bar-published', paused: 'bar-paused', archived: 'bar-archived' }[s]
}
function statusIconClass(s) {
  return { draft: 'icon-draft', published: 'icon-published', paused: 'icon-paused', archived: 'icon-archived' }[s]
}
function statusTextClass(s) {
  return { draft: 'txt-draft', published: 'txt-published', paused: 'txt-paused', archived: 'txt-archived' }[s]
}
function formatNumber(n) {
  if (!n) return '0'; if (n >= 10000) return (n / 10000).toFixed(1) + 'w'; if (n >= 1000) return (n / 1000).toFixed(1) + 'k'; return String(n)
}
function formatTime(t) {
  if (!t) return '-'; const d = new Date(t); return `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`
}
</script>

<style scoped>
.site-list-page { max-width: 1440px; margin: 0 auto; }

/* ================== Hero ================== */
.hero-section {
  position: relative;
  background: linear-gradient(135deg, #e8f4fd 0%, #f0f7ff 40%, #f5f9fc 100%);
  border-radius: 24px;
  padding: 44px 48px;
  margin-bottom: 28px;
  overflow: hidden;
}
.hero-bg-shapes { position: absolute; inset: 0; pointer-events: none; }
.shape { position: absolute; border-radius: 50%; opacity: 0.12; }
.shape-1 { width: 320px; height: 320px; background: radial-gradient(circle, #409eff, transparent); top: -80px; right: -40px; }
.shape-2 { width: 200px; height: 200px; background: radial-gradient(circle, #a78bfa, transparent); bottom: -40px; left: 20%; }
.shape-3 { width: 160px; height: 160px; background: radial-gradient(circle, #f59e0b, transparent); top: 40%; left: -40px; }
.hero-content { position: relative; z-index: 1; display: flex; justify-content: space-between; align-items: flex-start; }
.hero-title { margin: 0; font-size: 42px; font-weight: 800; color: #1a1a2e; letter-spacing: -0.5px; display: flex; align-items: center; gap: 8px; }
.hero-dot { display: inline-block; width: 10px; height: 10px; border-radius: 50%; background: linear-gradient(135deg, #409eff, #a78bfa); box-shadow: 0 0 8px rgba(64,158,255,.2); }
.hero-subtitle { margin: 10px 0 0; font-size: 16px; color: #6b7280; }
.hero-stats { display: flex; align-items: center; gap: 28px; margin-top: 24px; }
.hero-stat { display: flex; flex-direction: column; gap: 2px; }
.hero-stat-clickable { cursor: pointer; transition: transform .2s; }
.hero-stat-clickable:hover { transform: translateY(-2px); }
.hero-stat-clickable:hover .stat-num { color: #409eff; }
.hero-stat-clickable.stat-active .stat-num { color: #409eff; }
.hero-stat-clickable.stat-active .stat-text { color: #409eff; font-weight: 600; }
.stat-num { font-size: 28px; font-weight: 800; color: #1a1a2e; transition: color .2s; }.stat-text { font-size: 13px; color: #909399; }
.hero-divider { width: 1px; height: 40px; background: #e4e7ed; }
.hero-actions { flex-shrink: 0; }

/* ================== Toolbar ================== */
.toolbar { display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-bottom: 24px; flex-wrap: wrap; }
.search-wrap { display: flex; align-items: center; gap: 10px; background: #fff; border: 2px solid #e8ecf1; border-radius: 14px; padding: 0 18px; height: 46px; width: 340px; transition: border-color .25s, box-shadow .25s; }
.search-wrap:focus-within { border-color: #409eff; box-shadow: 0 0 0 4px rgba(64,158,255,.08); }
.search-icon { color: #909399; font-size: 18px; }
.search-field { flex: 1; border: none; outline: none; font-size: 14px; background: transparent; }
.search-field::placeholder { color: #c0c4cc; }
.search-clear { color: #c0c4cc; cursor: pointer; }
.search-clear:hover { color: #909399; }
.toolbar-filters { display: flex; gap: 6px; }
.filter-chip { display: flex; align-items: center; gap: 6px; padding: 8px 16px; border: 1.5px solid #e8ecf1; border-radius: 10px; background: #fff; font-size: 13px; color: #606266; cursor: pointer; transition: all .25s; font-weight: 500; }
.filter-chip:hover { border-color: #c4cdff; color: #409eff; }
.filter-chip.active { background: linear-gradient(135deg, #409eff, #5372ff); border-color: transparent; color: #fff; box-shadow: 0 4px 12px rgba(64,158,255,.25); }
.chip-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
.dot-green { background: #67c23a; }
.dot-gray { background: #909399; }
.dot-orange { background: #e6a23c; }
.chip-count { font-size: 11px; background: #f0f0f0; padding: 1px 8px; border-radius: 10px; }

/* ================== 网格 ================== */
.site-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
@media (max-width: 1080px) { .site-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 680px) { .site-grid { grid-template-columns: 1fr; } }
.grid-item { animation: fadeInUp 0.5s ease backwards; }
@keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

/* ================== 卡片 ================== */
.site-card {
  position: relative;
  background: #fff;
  border-radius: 18px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0,0,0,.04);
  border: 1px solid rgba(0,0,0,.04);
  cursor: pointer;
  transition: all .4s cubic-bezier(.4,0,.2,1);
}
.site-card:hover { transform: translateY(-6px); box-shadow: 0 20px 40px rgba(0,0,0,.08); border-color: rgba(64,158,255,.12); }
.card-top-bar { height: 5px; }
.bar-draft { background: linear-gradient(90deg, #909399, #c0c4cc); }
.bar-published { background: linear-gradient(90deg, #52c41a, #73d13d); }
.bar-paused { background: linear-gradient(90deg, #e6a23c, #f9d717); }

.card-icon-wrap {
  margin: 24px auto 0;
  width: 58px; height: 58px; border-radius: 16px;
  display: flex; align-items: center; justify-content: center; color: #fff;
}
.icon-draft { background: #909399; }
.icon-published { background: linear-gradient(135deg, #52c41a, #73d13d); }
.icon-paused { background: linear-gradient(135deg, #e6a23c, #f9d717); }

.card-body { padding: 16px 22px 20px; text-align: center; }
.card-header { display: flex; justify-content: center; align-items: center; gap: 8px; margin-bottom: 6px; }
.card-name { margin: 0; font-size: 17px; font-weight: 700; color: #1a1a2e; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 200px; }
.card-status { font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 8px; flex-shrink: 0; }
.txt-draft { background: #f5f7fa; color: #909399; }
.txt-published { background: #edfcf2; color: #52c41a; }
.txt-paused { background: #fff8e6; color: #e6a23c; }
.card-domain { margin: 4px 0 10px; font-size: 13px; color: #909399; }
.card-tags { display: flex; justify-content: center; gap: 6px; margin-bottom: 16px; flex-wrap: wrap; }
.tag-item { font-size: 11px; padding: 3px 10px; border-radius: 6px; background: linear-gradient(135deg, #ecf5ff, #e8f4fd); color: #409eff; font-weight: 500; }
.tag-industry { background: linear-gradient(135deg, #fef0f0, #fde8e8); color: #f56c6c; }

.card-stats { display: flex; justify-content: center; align-items: center; gap: 0; background: #fafbfc; border-radius: 12px; padding: 12px 0; }
.stat-block { flex: 1; display: flex; flex-direction: column; gap: 2px; }
.stat-val { font-size: 18px; font-weight: 700; color: #1a1a2e; }
.stat-lbl { font-size: 11px; color: #909399; }
.stat-divider { width: 1px; height: 28px; background: #e8ecf1; }

/* 悬浮操作层 */
.card-overlay {
  position: absolute; inset: 0;
  display: flex; align-items: center; justify-content: center; gap: 8px;
  background: rgba(15,12,41,.75); backdrop-filter: blur(8px);
  opacity: 0; transition: opacity .35s ease; flex-wrap: wrap; padding: 20px;
}
.site-card:hover .card-overlay { opacity: 1; }
.overlay-btn { background: rgba(255,255,255,.15) !important; border: 1px solid rgba(255,255,255,.2) !important; color: #fff !important; }
.overlay-btn:hover { background: rgba(255,255,255,.25) !important; }
.overlay-publish { background: rgba(64,158,255,.3) !important; border-color: rgba(64,158,255,.4) !important; }
.overlay-warn { background: rgba(230,162,60,.3) !important; border-color: rgba(230,162,60,.4) !important; }
.overlay-danger { background: rgba(245,108,108,.3) !important; border-color: rgba(245,108,108,.4) !important; }

/* 下拉菜单按钮在悬浮层中的适配 */
.card-overlay .el-dropdown { display: inline-flex; }
.card-overlay .el-dropdown .overlay-btn { border-color: rgba(255,255,255,.2) !important; }
.card-overlay .el-dropdown-menu__item { font-size: 13px; display: flex; align-items: center; gap: 6px; }
.card-overlay .el-dropdown-menu__item .el-icon { margin-right: 4px; font-size: 15px; }

.card-footer-text { text-align: center; font-size: 12px; color: #c0c4cc; margin: 10px 0 0; }

/* ================== 其他 ================== */
.empty-state { display: flex; flex-direction: column; align-items: center; padding: 80px 20px; color: #c0c4cc; }
.empty-state h3 { margin: 16px 0 4px; color: #606266; font-weight: 500; }
.empty-state p { margin: 0; color: #909399; font-size: 13px; }
.empty-state :deep(.el-empty) { margin-bottom: 0; }
.pagination-wrap { display: flex; justify-content: center; margin-top: 40px; padding: 16px 0; }

/* 已下线状态 */
.bar-archived { background: linear-gradient(90deg, #f56c6c, #f89898); }
.icon-archived { background: linear-gradient(135deg, #f56c6c, #f89898); }
.txt-archived { background: #fef0f0; color: #f56c6c; }

/* 回收站状态卡片 */
.bar-deleted { background: linear-gradient(90deg, #909399, #c0c4cc); }
.icon-deleted { background: #909399; }
.txt-deleted { background: #f5f7fa; color: #909399; }
.deleted-notice { display: flex; align-items: center; justify-content: center; gap: 6px; font-size: 12px; color: #909399; padding: 8px 0; }

/* 克隆弹窗 */
.clone-info { margin-top: -8px; padding: 12px 16px; background: #f5f7fa; border-radius: 8px; font-size: 13px; color: #606266; }
.clone-info p { margin: 0 0 4px; }
.clone-detail { font-size: 12px; color: #909399; }
</style>
