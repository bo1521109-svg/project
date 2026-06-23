<template>
  <div class="crm-customers">
    <div class="page-header">
      <h2 class="page-title">客户管理</h2>
      <el-button type="primary" :icon="Plus" @click="showCreateDialog = true">添加客户</el-button>
    </div>

    <!-- 筛选栏 -->
    <div class="filter-bar">
      <el-input v-model="search" placeholder="搜索客户名称 / 邮箱 / 电话" clearable :prefix-icon="Search" style="width: 280px" size="default" />
      <el-select v-model="filterStatus" placeholder="客户状态" clearable style="width: 130px" size="default">
        <el-option label="潜在客户" value="potential" />
        <el-option label="已联系" value="contacted" />
        <el-option label="洽谈中" value="negotiating" />
        <el-option label="已成交" value="contracted" />
      </el-select>
      <el-select v-model="filterSource" placeholder="来源渠道" clearable style="width: 130px" size="default">
        <el-option label="独立站" value="独立站" />
        <el-option label="TikTok" value="TikTok" />
        <el-option label="Instagram" value="Instagram" />
        <el-option label="Facebook" value="Facebook" />
        <el-option label="WhatsApp" value="WhatsApp" />
      </el-select>
      <el-select v-model="filterTag" placeholder="标签" clearable style="width: 130px" size="default">
        <el-option v-for="t in allTags" :key="t" :label="t" :value="t" />
      </el-select>
      <div class="filter-stats">
        <span class="fs-count">共 {{ filteredCustomers.length }} 位客户</span>
      </div>
    </div>

    <!-- 客户卡片列表 -->
    <div class="customer-grid">
      <div class="customer-card" v-for="customer in filteredCustomers" :key="customer.id" @click="selectCustomer(customer)">
        <div class="cc-header">
          <div class="cc-avatar" :style="{ background: avatarColor(customer.id) }">
            {{ customer.name.charAt(0) }}
          </div>
          <div class="cc-name-row">
            <span class="cc-name">{{ customer.name }}</span>
            <el-tag :type="statusTagType(customer.status)" size="small">{{ customer.status_label }}</el-tag>
          </div>
        </div>
        <div class="cc-body">
          <div class="cc-info-row">
            <span class="cc-label">邮箱</span>
            <span class="cc-value">{{ customer.email }}</span>
          </div>
          <div class="cc-info-row">
            <span class="cc-label">电话</span>
            <span class="cc-value">{{ customer.phone }}</span>
          </div>
          <div class="cc-info-row">
            <span class="cc-label">国家</span>
            <span class="cc-value">{{ customer.country }} <el-tag size="small" :type="sourceTagType(customer.source)">{{ customer.source }}</el-tag></span>
          </div>
          <div class="cc-tags">
            <el-tag v-for="tag in customer.tags" :key="tag" size="small" effect="plain" round>{{ tag }}</el-tag>
          </div>
        </div>
        <div class="cc-footer">
          <span class="cc-date">{{ customer.last_contact }}</span>
          <el-button text type="primary" size="small" @click.stop="selectCustomer(customer)">详情</el-button>
        </div>
      </div>
    </div>

    <!-- 客户详情抽屉 -->
    <el-drawer v-model="drawerVisible" :title="selectedCustomer?.name || '客户详情'" size="480px">
      <template v-if="selectedCustomer">
        <div class="drawer-section">
          <h4>基本信息</h4>
          <div class="drawer-grid">
            <div class="dg-item"><span class="dg-label">邮箱</span><span class="dg-val">{{ selectedCustomer.email }}</span></div>
            <div class="dg-item"><span class="dg-label">电话</span><span class="dg-val">{{ selectedCustomer.phone }}</span></div>
            <div class="dg-item"><span class="dg-label">国家</span><span class="dg-val">{{ selectedCustomer.country }}</span></div>
            <div class="dg-item"><span class="dg-label">来源</span><span class="dg-val"><el-tag size="small">{{ selectedCustomer.source_tag }}</el-tag></span></div>
            <div class="dg-item"><span class="dg-label">状态</span><span class="dg-val"><el-tag :type="statusTagType(selectedCustomer.status)" size="small">{{ selectedCustomer.status_label }}</el-tag></span></div>
            <div class="dg-item"><span class="dg-label">感兴趣产品</span><span class="dg-val">{{ selectedCustomer.interest }}</span></div>
            <div class="dg-item"><span class="dg-label">预算范围</span><span class="dg-val">{{ selectedCustomer.budget }}</span></div>
            <div class="dg-item"><span class="dg-label">订单数</span><span class="dg-val">{{ selectedCustomer.orders }}</span></div>
            <div class="dg-item"><span class="dg-label">消费总额</span><span class="dg-val">${{ selectedCustomer.total_spent.toLocaleString() }}</span></div>
            <div class="dg-item"><span class="dg-label">创建时间</span><span class="dg-val">{{ selectedCustomer.created_at }}</span></div>
            <div class="dg-item"><span class="dg-label">最近联系</span><span class="dg-val">{{ selectedCustomer.last_contact }}</span></div>
          </div>
        </div>
        <div class="drawer-section">
          <h4>客户标签</h4>
          <el-tag v-for="tag in selectedCustomer.tags" :key="tag" style="margin-right: 6px; margin-bottom: 6px;" effect="plain" round>{{ tag }}</el-tag>
        </div>
        <div class="drawer-section">
          <h4>备注</h4>
          <p class="drawer-notes">{{ selectedCustomer.notes }}</p>
        </div>
        <div class="drawer-section">
          <h4>跟进记录</h4>
          <el-timeline>
            <el-timeline-item
              v-for="fu in customerFollowUps"
              :key="fu.id"
              :timestamp="fu.created_at"
              placement="top"
            >
              <div class="timeline-content">
                <el-tag size="small" effect="plain">{{ fu.type }}</el-tag>
                <span class="tl-staff">{{ fu.staff }}</span>
                <p class="tl-text">{{ fu.content }}</p>
              </div>
            </el-timeline-item>
          </el-timeline>
          <el-empty v-if="!customerFollowUps.length" description="暂无跟进记录" :image-size="60" />
        </div>
      </template>
    </el-drawer>

    <!-- 添加客户对话框 -->
    <el-dialog v-model="showCreateDialog" title="添加客户" width="500px">
      <el-form :model="createForm" label-width="90px">
        <el-form-item label="客户名称" required><el-input v-model="createForm.name" placeholder="请输入客户名称" /></el-form-item>
        <el-form-item label="邮箱"><el-input v-model="createForm.email" placeholder="请输入邮箱" /></el-form-item>
        <el-form-item label="电话"><el-input v-model="createForm.phone" placeholder="请输入电话" /></el-form-item>
        <el-form-item label="国家"><el-input v-model="createForm.country" placeholder="请输入国家" /></el-form-item>
        <el-form-item label="来源渠道">
          <el-select v-model="createForm.source" style="width: 100%">
            <el-option label="独立站" value="独立站" />
            <el-option label="TikTok" value="TikTok" />
            <el-option label="Instagram" value="Instagram" />
            <el-option label="Facebook" value="Facebook" />
            <el-option label="WhatsApp" value="WhatsApp" />
          </el-select>
        </el-form-item>
        <el-form-item label="感兴趣产品"><el-input v-model="createForm.interest" placeholder="请输入感兴趣的产品" /></el-form-item>
        <el-form-item label="备注"><el-input v-model="createForm.notes" type="textarea" :rows="3" placeholder="请输入备注" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreateDialog = false">取消</el-button>
        <el-button type="primary" @click="handleCreateCustomer">确认添加</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Plus, Search } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'

// 搜索与筛选
const search = ref('')
const filterStatus = ref('')
const filterSource = ref('')
const filterTag = ref('')

const allTags = ['高意向', 'VIP客户', '批发', '样品申请', '询价', 'OEM', '代理', '比价', '零售', '长期合作', '中东市场', '北非市场', '认证需求', '品牌代理', '分销商', 'B2B批发', '低意向']

// 客户列表
const customers = ref([
  { id: 1, name: 'Carlos Mendes', email: 'carlos@email.com.br', phone: '+55 11 99999-8888', country: '巴西', source: 'TikTok', source_tag: 'TikTok视频评论区', status: 'potential', status_label: '潜在客户', interest: '蓝牙耳机', tags: ['高意向', '询价'], budget: '$5,000-10,000', notes: '对ANC降噪功能特别感兴趣，需要样品测试', created_at: '2026-05-28 10:15', last_contact: '2026-06-03 14:00', orders: 0, total_spent: 0 },
  { id: 2, name: 'Emma Wilson', email: 'emma.w@email.com', phone: '+1 415 555-0123', country: '美国', source: '独立站', source_tag: '独立站询盘表单', status: 'negotiating', status_label: '洽谈中', interest: '智能手表', tags: ['B2B批发', '高意向'], budget: '$50,000+', notes: '批发客户，月需求量500台以上', created_at: '2026-05-25 09:30', last_contact: '2026-06-03 11:20', orders: 2, total_spent: 18500 },
  { id: 3, name: '田中 健一', email: 'tanaka@email.jp', phone: '+81 90-1234-5678', country: '日本', source: 'Instagram', source_tag: 'Instagram DM', status: 'potential', status_label: '潜在客户', interest: '美容仪器', tags: ['样品申请', '分销商'], budget: '$20,000-30,000', notes: '日本地区分销商，有线下实体店渠道', created_at: '2026-05-22 14:45', last_contact: '2026-06-02 16:30', orders: 0, total_spent: 0 },
  { id: 4, name: 'Priya Kapoor', email: 'priya.k@email.in', phone: '+91 98765-43210', country: '印度', source: 'Facebook', source_tag: 'Facebook广告', status: 'contacted', status_label: '已联系', interest: '充电器/数据线', tags: ['低意向', '比价'], budget: '$1,000-3,000', notes: '多家比价中，对MOQ有顾虑', created_at: '2026-05-20 11:00', last_contact: '2026-06-01 10:00', orders: 0, total_spent: 0 },
  { id: 5, name: 'Michael Brown', email: 'michael.b@email.co.uk', phone: '+44 20 7946 0123', country: '英国', source: '独立站', source_tag: 'Google搜索', status: 'contracted', status_label: '已成交', interest: '无线充电器', tags: ['VIP客户', '长期合作'], budget: '$100,000+', notes: '长期合作客户，每月稳定下单', created_at: '2026-04-15 08:20', last_contact: '2026-06-03 09:15', orders: 15, total_spent: 125800 },
  { id: 6, name: 'Ahmed Rashid', email: 'ahmed.r@email.ae', phone: '+971 50 123 4567', country: '阿联酋', source: 'WhatsApp', source_tag: 'WhatsApp群组', status: 'negotiating', status_label: '洽谈中', interest: '手机配件全系列', tags: ['中东市场', '高意向'], budget: '$30,000-50,000', notes: '迪拜电子产品批发商', created_at: '2026-05-18 13:30', last_contact: '2026-06-03 15:45', orders: 1, total_spent: 8500 },
  { id: 7, name: 'Sophie Laurent', email: 'sophie.l@email.fr', phone: '+33 6 12 34 56 78', country: '法国', source: 'Instagram', source_tag: 'KOL推荐', status: 'contacted', status_label: '已联系', interest: '护肤品', tags: ['询价', '样品申请'], budget: '$5,000-8,000', notes: '法国本土美妆博主推荐来的客户', created_at: '2026-06-01 10:00', last_contact: '2026-06-02 14:30', orders: 0, total_spent: 0 },
  { id: 8, name: 'Robert Kim', email: 'robert.k@email.kr', phone: '+82 10-1234-5678', country: '韩国', source: 'TikTok', source_tag: 'TikTok直播', status: 'potential', status_label: '潜在客户', interest: '耳机/音箱', tags: ['高意向', '品牌代理'], budget: '$15,000-25,000', notes: '有电商运营经验', created_at: '2026-05-30 16:20', last_contact: '2026-06-03 10:00', orders: 0, total_spent: 0 },
  { id: 9, name: 'Maria Garcia', email: 'maria.g@email.mx', phone: '+52 55 1234 5678', country: '墨西哥', source: 'Facebook', source_tag: 'Facebook群组', status: 'contacted', status_label: '已联系', interest: '家居用品', tags: ['低意向', '零售'], budget: '$2,000-5,000', notes: '小型零售店主', created_at: '2026-05-28 09:00', last_contact: '2026-06-01 11:00', orders: 0, total_spent: 0 },
  { id: 10, name: 'David Chen', email: 'david.c@email.sg', phone: '+65 9123 4567', country: '新加坡', source: '独立站', source_tag: 'Referral推荐', status: 'contracted', status_label: '已成交', interest: '智能家居', tags: ['VIP客户', '长期合作'], budget: '$200,000+', notes: '东南亚最大客户', created_at: '2026-03-10 10:00', last_contact: '2026-06-03 08:00', orders: 28, total_spent: 268500 },
  { id: 11, name: 'Anna Fischer', email: 'anna.f@email.de', phone: '+49 30 12345678', country: '德国', source: '独立站', source_tag: 'B2B平台', status: 'negotiating', status_label: '洽谈中', interest: '太阳能充电器', tags: ['认证需求', 'OEM'], budget: '$40,000-60,000', notes: '需要CE/RoHS认证', created_at: '2026-05-15 14:00', last_contact: '2026-06-02 17:00', orders: 0, total_spent: 0 },
  { id: 12, name: 'Omar Hassan', email: 'omar.h@email.eg', phone: '+20 10 1234 5678', country: '埃及', source: 'WhatsApp', source_tag: 'WhatsApp Business', status: 'potential', status_label: '潜在客户', interest: '手机配件', tags: ['北非市场', '批发'], budget: '$10,000-15,000', notes: '北非地区批发商', created_at: '2026-06-02 12:30', last_contact: '2026-06-03 12:00', orders: 0, total_spent: 0 },
])

// 筛选后
const filteredCustomers = computed(() => {
  let list = customers.value
  if (search.value) {
    const kw = search.value.toLowerCase()
    list = list.filter(c => c.name.toLowerCase().includes(kw) || c.email.toLowerCase().includes(kw) || c.phone.includes(kw))
  }
  if (filterStatus.value) list = list.filter(c => c.status === filterStatus.value)
  if (filterSource.value) list = list.filter(c => c.source === filterSource.value)
  if (filterTag.value) list = list.filter(c => c.tags.includes(filterTag.value))
  return list
})

// 详情抽屉
const drawerVisible = ref(false)
const selectedCustomer = ref(null)
const customerFollowUps = ref([])

function selectCustomer(customer) {
  selectedCustomer.value = customer
  // 生成模拟跟进记录
  customerFollowUps.value = [
    { id: 1, type: '首次联系', content: `客户通过${customer.source_tag}首次联系`, created_at: customer.created_at, staff: '张三' },
  ]
  if (customer.status !== 'potential') {
    customerFollowUps.value.unshift({
      id: 2, type: '跟进沟通', content: customer.notes, created_at: customer.last_contact, staff: '张三'
    })
  }
  drawerVisible.value = true
}

// 添加客户
const showCreateDialog = ref(false)
const createForm = ref({ name: '', email: '', phone: '', country: '', source: '独立站', interest: '', notes: '' })

function handleCreateCustomer() {
  if (!createForm.value.name) {
    ElMessage.warning('请输入客户名称')
    return
  }
  customers.value.unshift({
    ...createForm.value,
    id: Date.now(),
    source_tag: createForm.value.source,
    status: 'potential',
    status_label: '潜在客户',
    tags: [],
    budget: '',
    orders: 0,
    total_spent: 0,
    created_at: new Date().toLocaleString(),
    last_contact: new Date().toLocaleString(),
  })
  ElMessage.success('客户添加成功')
  showCreateDialog.value = false
  createForm.value = { name: '', email: '', phone: '', country: '', source: '独立站', interest: '', notes: '' }
}

function statusTagType(status) {
  const map = { potential: 'info', contacted: 'warning', negotiating: '', contracted: 'success' }
  return map[status] || 'info'
}

function sourceTagType(source) {
  const map = { '独立站': 'success', 'TikTok': '', 'Instagram': 'danger', 'Facebook': 'primary', 'WhatsApp': 'success' }
  return map[source] || 'info'
}

function avatarColor(id) {
  const colors = ['#667eea', '#f5576c', '#4facfe', '#f093fb', '#fa709a', '#43e97b', '#a18cd1', '#ffecd2']
  return colors[id % colors.length]
}
</script>

<style scoped>
.crm-customers { max-width: 1500px; }

.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.page-title { font-size: 20px; font-weight: 700; color: #303133; margin: 0; }

/* 筛选栏 */
.filter-bar {
  display: flex; gap: 12px; align-items: center;
  background: #fff; padding: 14px 18px; border-radius: 10px;
  margin-bottom: 16px; flex-wrap: wrap;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}
.filter-stats { margin-left: auto; }
.fs-count { font-size: 13px; color: #909399; }

/* 客户卡片网格 */
.customer-grid {
  display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px;
}
@media (max-width: 1200px) { .customer-grid { grid-template-columns: repeat(2, 1fr); } }

.customer-card {
  background: #fff; border-radius: 10px; padding: 16px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
  cursor: pointer; transition: all 0.3s;
}
.customer-card:hover { transform: translateY(-2px); box-shadow: 0 4px 16px rgba(245, 87, 108, 0.15); }

.cc-header { display: flex; align-items: center; gap: 12px; margin-bottom: 12px; }
.cc-avatar {
  width: 40px; height: 40px; border-radius: 10px;
  display: flex; align-items: center; justify-content: center;
  color: #fff; font-size: 16px; font-weight: 600; flex-shrink: 0;
}
.cc-name-row { display: flex; flex-direction: column; gap: 4px; }
.cc-name { font-size: 15px; font-weight: 600; color: #303133; }

.cc-body { display: flex; flex-direction: column; gap: 6px; margin-bottom: 12px; }
.cc-info-row { display: flex; align-items: center; gap: 8px; font-size: 13px; }
.cc-label { color: #909399; min-width: 36px; }
.cc-value { color: #606266; display: flex; align-items: center; gap: 6px; }
.cc-tags { display: flex; gap: 4px; flex-wrap: wrap; margin-top: 4px; }

.cc-footer { display: flex; justify-content: space-between; align-items: center; padding-top: 10px; border-top: 1px solid #f0f0f0; }
.cc-date { font-size: 12px; color: #c0c4cc; }

/* 抽屉 */
.drawer-section { margin-bottom: 20px; }
.drawer-section h4 { font-size: 14px; font-weight: 600; color: #303133; margin: 0 0 10px 0; padding-bottom: 8px; border-bottom: 1px solid #f0f0f0; }
.drawer-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
.dg-item { display: flex; flex-direction: column; gap: 2px; }
.dg-label { font-size: 12px; color: #909399; }
.dg-val { font-size: 13px; color: #303133; }
.drawer-notes { font-size: 13px; color: #606266; line-height: 1.6; margin: 0; padding: 8px 12px; background: #fafafa; border-radius: 6px; }

.timeline-content { display: flex; flex-direction: column; gap: 4px; }
.tl-staff { font-size: 12px; color: #909399; }
.tl-text { font-size: 13px; color: #606266; margin: 0; line-height: 1.5; }
</style>
