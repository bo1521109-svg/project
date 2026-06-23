<template>
  <div class="crm-followups">
    <div class="page-header">
      <h2 class="page-title">跟进记录</h2>
      <el-button type="primary" :icon="Plus" @click="showCreateDialog = true">添加跟进</el-button>
    </div>

    <!-- 统计 -->
    <div class="stats-row">
      <div class="stat-item" v-for="s in stats" :key="s.label">
        <div class="stat-num" :style="{ color: s.color }">{{ s.value }}</div>
        <div class="stat-text">{{ s.label }}</div>
      </div>
    </div>

    <!-- 筛选 -->
    <div class="filter-bar">
      <el-input v-model="searchText" placeholder="搜索客户名" clearable :prefix-icon="Search" style="width: 220px" size="default" />
      <el-select v-model="filterStatus" placeholder="状态" clearable style="width: 110px" size="default">
        <el-option label="已完成" value="completed" /><el-option label="待跟进" value="pending" />
      </el-select>
      <el-select v-model="filterType" placeholder="跟进类型" clearable style="width: 130px" size="default">
        <el-option label="电话回访" value="电话回访" /><el-option label="邮件跟进" value="邮件跟进" />
        <el-option label="WhatsApp消息" value="WhatsApp消息" /><el-option label="视频会议" value="视频会议" />
        <el-option label="样品寄送" value="样品寄送" /><el-option label="合同签署" value="合同签署" />
      </el-select>
      <el-select v-model="filterStaff" placeholder="跟进人" clearable style="width: 110px" size="default">
        <el-option label="张三" value="张三" /><el-option label="李四" value="李四" /><el-option label="王五" value="王五" />
      </el-select>
      <span class="filter-count">共 {{ filteredFollowUps.length }} 条记录</span>
    </div>

    <!-- 跟进列表 -->
    <div class="followup-cards">
      <div class="fu-card" v-for="fu in filteredFollowUps" :key="fu.id">
        <div class="fu-card-left">
          <div class="fu-icon" :class="fu.type_icon">
            <el-icon :size="18"><component :is="typeIcon(fu.type_icon)" /></el-icon>
          </div>
          <div class="fu-card-info">
            <div class="fu-card-title">
              <span class="fu-customer-name">{{ fu.customer_name }}</span>
              <el-tag size="small">{{ fu.type }}</el-tag>
              <el-tag size="small" :type="fu.status === 'completed' ? 'success' : 'warning'" effect="plain">{{ fu.status_label }}</el-tag>
            </div>
            <div class="fu-card-content">{{ fu.content }}</div>
            <div class="fu-card-meta">
              <span>{{ fu.staff }} · {{ fu.created_at }}</span>
              <span v-if="fu.next_follow_up" class="fu-next">下次: {{ fu.next_follow_up }}</span>
            </div>
          </div>
        </div>
        <div class="fu-card-right">
          <el-button text type="primary" size="small">详情</el-button>
        </div>
      </div>
    </div>

    <!-- 添加跟进对话框 -->
    <el-dialog v-model="showCreateDialog" title="添加跟进记录" width="500px">
      <el-form :model="createForm" label-width="90px">
        <el-form-item label="客户" required>
          <el-select v-model="createForm.customer_name" filterable style="width: 100%" placeholder="选择客户">
            <el-option v-for="c in customerNames" :key="c" :label="c" :value="c" />
          </el-select>
        </el-form-item>
        <el-form-item label="跟进类型" required>
          <el-select v-model="createForm.type" style="width: 100%">
            <el-option label="电话回访" value="电话回访" /><el-option label="邮件跟进" value="邮件跟进" />
            <el-option label="WhatsApp消息" value="WhatsApp消息" /><el-option label="视频会议" value="视频会议" />
            <el-option label="样品寄送" value="样品寄送" /><el-option label="合同签署" value="合同签署" />
          </el-select>
        </el-form-item>
        <el-form-item label="跟进内容" required><el-input v-model="createForm.content" type="textarea" :rows="4" /></el-form-item>
        <el-form-item label="跟进人">
          <el-select v-model="createForm.staff" style="width: 100%">
            <el-option label="张三" value="张三" /><el-option label="李四" value="李四" /><el-option label="王五" value="王五" />
          </el-select>
        </el-form-item>
        <el-form-item label="下次跟进"><el-date-picker v-model="createForm.next_follow_up" type="datetime" style="width: 100%" placeholder="选择时间" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreateDialog = false">取消</el-button>
        <el-button type="primary" @click="handleCreate">确认添加</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Plus, Search, Phone, Message, VideoCamera, ChatDotRound, Box, Document } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'

const searchText = ref('')
const filterStatus = ref('')
const filterType = ref('')
const filterStaff = ref('')

const customerNames = [
  'Michael Brown', 'Sophie Laurent', 'Carlos Mendes', 'Ahmed Rashid',
  'Anna Fischer', 'Priya Kapoor', 'Omar Hassan', '田中 健一',
  'Robert Kim', 'Emma Wilson', 'David Chen', 'Maria Garcia'
]

const followUps = ref([
  { id: 1, customer_name: 'Michael Brown', type: '电话回访', type_icon: 'phone', content: '确认下月订单数量和交期，客户对产品质量很满意', status: 'completed', status_label: '已完成', staff: '张三', created_at: '2026-06-03 10:00', next_follow_up: null },
  { id: 2, customer_name: 'Sophie Laurent', type: '邮件跟进', type_icon: 'email', content: '发送了全套产品资料和报价，客户表示需要时间评估', status: 'completed', status_label: '已完成', staff: '李四', created_at: '2026-06-03 09:30', next_follow_up: '2026-06-05 10:00' },
  { id: 3, customer_name: 'Carlos Mendes', type: 'WhatsApp消息', type_icon: 'whatsapp', content: '样品已发出，提供物流单号，客户确认收到后会测试', status: 'completed', status_label: '已完成', staff: '张三', created_at: '2026-06-03 14:00', next_follow_up: '2026-06-10 10:00' },
  { id: 4, customer_name: 'Ahmed Rashid', type: '视频会议', type_icon: 'video', content: '远程产品演示，客户对手机配件系列很感兴趣', status: 'completed', status_label: '已完成', staff: '王五', created_at: '2026-06-03 08:00', next_follow_up: '2026-06-04 10:00' },
  { id: 5, customer_name: 'Anna Fischer', type: '邮件跟进', type_icon: 'email', content: '提供CE/RoHS认证文件和OEM报价方案', status: 'completed', status_label: '已完成', staff: '李四', created_at: '2026-06-02 17:00', next_follow_up: '2026-06-05 14:00' },
  { id: 6, customer_name: 'Priya Kapoor', type: '电话回访', type_icon: 'phone', content: '跟进之前报价，客户仍在多家比价中', status: 'pending', status_label: '待跟进', staff: '张三', created_at: '2026-06-02 11:00', next_follow_up: '2026-06-04 15:00' },
  { id: 7, customer_name: 'Omar Hassan', type: 'WhatsApp消息', type_icon: 'whatsapp', content: '发送北非市场成功案例和产品价格表', status: 'pending', status_label: '待跟进', staff: '王五', created_at: '2026-06-03 12:00', next_follow_up: '2026-06-06 10:00' },
  { id: 8, customer_name: '田中 健一', type: '邮件跟进', type_icon: 'email', content: '提供日本市场定制化方案和物流支持说明', status: 'completed', status_label: '已完成', staff: '李四', created_at: '2026-06-01 16:00', next_follow_up: '2026-06-04 09:00' },
  { id: 9, customer_name: 'Robert Kim', type: '电话回访', type_icon: 'phone', content: '介绍品牌代理政策和韩国市场支持方案', status: 'completed', status_label: '已完成', staff: '张三', created_at: '2026-06-02 15:00', next_follow_up: '2026-06-06 14:00' },
  { id: 10, customer_name: 'Emma Wilson', type: '视频会议', type_icon: 'video', content: '讨论批发价格和长期合作协议细节', status: 'pending', status_label: '待跟进', staff: '王五', created_at: '2026-06-02 16:30', next_follow_up: '2026-06-04 10:00' },
  { id: 11, customer_name: 'Michael Brown', type: '样品寄送', type_icon: 'parcel', content: '新款无线充电器样品寄出，附赠产品手册', status: 'completed', status_label: '已完成', staff: '李四', created_at: '2026-06-01 10:00', next_follow_up: '2026-06-07 10:00' },
  { id: 12, customer_name: 'David Chen', type: '合同签署', type_icon: 'document', content: '签署年度框架协议续约，维持原有优惠条款', status: 'completed', status_label: '已完成', staff: '王五', created_at: '2026-06-01 14:00', next_follow_up: null },
])

const filteredFollowUps = computed(() => {
  let list = followUps.value
  if (searchText.value) {
    const kw = searchText.value.toLowerCase()
    list = list.filter(f => f.customer_name.toLowerCase().includes(kw))
  }
  if (filterStatus.value) list = list.filter(f => f.status === filterStatus.value)
  if (filterType.value) list = list.filter(f => f.type === filterType.value)
  if (filterStaff.value) list = list.filter(f => f.staff === filterStaff.value)
  return list
})

const stats = computed(() => {
  const total = followUps.value.length
  const completed = followUps.value.filter(f => f.status === 'completed').length
  const pending = followUps.value.filter(f => f.status === 'pending').length
  return [
    { label: '总记录', value: total, color: '#303133' },
    { label: '已完成', value: completed, color: '#67C23A' },
    { label: '待跟进', value: pending, color: '#E6A23C' },
    { label: '今日新增', value: 4, color: '#f5576c' },
  ]
})

function typeIcon(type) {
  const map = { phone: Phone, email: Message, whatsapp: ChatDotRound, video: VideoCamera, parcel: Box, document: Document }
  return map[type] || Message
}

// 添加跟进
const showCreateDialog = ref(false)
const createForm = ref({ customer_name: '', type: '', content: '', staff: '张三', next_follow_up: null })

function handleCreate() {
  if (!createForm.value.customer_name || !createForm.value.type || !createForm.value.content) {
    ElMessage.warning('请填写完整信息')
    return
  }
  followUps.value.unshift({
    id: Date.now(),
    customer_name: createForm.value.customer_name,
    type: createForm.value.type,
    type_icon: createForm.value.type === '电话回访' ? 'phone' : createForm.value.type === '邮件跟进' ? 'email' : createForm.value.type === 'WhatsApp消息' ? 'whatsapp' : createForm.value.type === '视频会议' ? 'video' : createForm.value.type === '样品寄送' ? 'parcel' : 'document',
    content: createForm.value.content,
    status: 'completed',
    status_label: '已完成',
    staff: createForm.value.staff,
    created_at: new Date().toLocaleString(),
    next_follow_up: createForm.value.next_follow_up ? new Date(createForm.value.next_follow_up).toLocaleString() : null,
  })
  ElMessage.success('跟进记录添加成功')
  showCreateDialog.value = false
  createForm.value = { customer_name: '', type: '', content: '', staff: '张三', next_follow_up: null }
}
</script>

<style scoped>
.crm-followups { max-width: 1200px; }

.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.page-title { font-size: 20px; font-weight: 700; color: #303133; margin: 0; }

.stats-row {
  display: flex; gap: 40px; background: #fff; padding: 16px 24px;
  border-radius: 10px; margin-bottom: 16px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}
.stat-item { text-align: center; }
.stat-num { font-size: 22px; font-weight: 700; }
.stat-text { font-size: 12px; color: #909399; margin-top: 2px; }

.filter-bar {
  display: flex; gap: 12px; align-items: center;
  background: #fff; padding: 12px 18px; border-radius: 10px; margin-bottom: 16px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}
.filter-count { margin-left: auto; font-size: 13px; color: #909399; }

.followup-cards { display: flex; flex-direction: column; gap: 10px; }

.fu-card {
  background: #fff; border-radius: 10px; padding: 16px 20px;
  display: flex; justify-content: space-between; align-items: flex-start;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06); transition: all 0.3s;
}
.fu-card:hover { box-shadow: 0 2px 10px rgba(0,0,0,0.1); }

.fu-card-left { display: flex; gap: 14px; flex: 1; }
.fu-icon {
  width: 40px; height: 40px; border-radius: 10px;
  display: flex; align-items: center; justify-content: center;
  color: #fff; flex-shrink: 0;
}
.fu-icon.phone { background: linear-gradient(135deg, #667eea, #764ba2); }
.fu-icon.email { background: linear-gradient(135deg, #f093fb, #f5576c); }
.fu-icon.whatsapp { background: linear-gradient(135deg, #25D366, #128C7E); }
.fu-icon.video { background: linear-gradient(135deg, #4facfe, #00f2fe); }
.fu-icon.parcel { background: linear-gradient(135deg, #fa709a, #fee140); }
.fu-icon.document { background: linear-gradient(135deg, #a18cd1, #fbc2eb); }

.fu-card-info { flex: 1; }
.fu-card-title { display: flex; align-items: center; gap: 8px; margin-bottom: 6px; }
.fu-customer-name { font-size: 14px; font-weight: 600; color: #303133; }
.fu-card-content { font-size: 13px; color: #606266; line-height: 1.5; margin-bottom: 6px; }
.fu-card-meta { font-size: 12px; color: #c0c4cc; display: flex; gap: 16px; }
.fu-next { color: #f5576c; }
.fu-card-right { display: flex; align-items: center; flex-shrink: 0; }
</style>
