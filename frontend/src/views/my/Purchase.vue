<template>
  <div class="purchase-page">
    <div class="page-header">
      <h2 class="page-title">购买续费</h2>
      <p class="page-desc">选择合适的套餐，解锁全部功能，助力跨境业务增长</p>
    </div>

    <!-- 当前套餐状态 -->
    <div class="current-plan" v-if="currentPlan">
      <div class="plan-status">
        <div class="status-left">
          <el-icon :size="24" class="crown-icon"><Present /></el-icon>
          <div>
            <div class="plan-name">当前套餐：{{ currentPlan.name }}</div>
            <div class="plan-expire">
              到期时间：{{ currentPlan.expireDate }}
              <el-tag :type="daysLeft > 30 ? 'success' : daysLeft > 7 ? 'warning' : 'danger'" size="small" style="margin-left: 8px">
                剩余 {{ daysLeft }} 天
              </el-tag>
            </div>
          </div>
        </div>
      </div>
      <!-- 使用进度 -->
      <div class="usage-overview">
        <div class="usage-item" v-for="usage in usages" :key="usage.label">
          <div class="usage-label">
            <span>{{ usage.label }}</span>
            <span class="usage-value">{{ usage.used }}/{{ usage.total }}</span>
          </div>
          <el-progress
            :percentage="usage.percent"
            :color="usage.color"
            :stroke-width="8"
          />
        </div>
      </div>
    </div>

    <!-- 套餐卡片 -->
    <div class="plans-section">
      <h3 class="section-title">选择套餐</h3>
      <div class="billing-toggle">
        <el-segmented v-model="billingCycle" :options="billingOptions" size="default" />
      </div>

      <div class="plans-grid">
        <div
          class="plan-card"
          :class="{ 'plan-recommended': plan.recommended, 'plan-current': plan.id === currentPlan.id }"
          v-for="plan in plans"
          :key="plan.id"
        >
          <div class="plan-ribbon" v-if="plan.recommended">推荐</div>
          <div class="plan-header">
            <h4 class="plan-name">{{ plan.name }}</h4>
            <p class="plan-desc">{{ plan.description }}</p>
            <div class="plan-price">
              <span class="price-symbol">$</span>
              <span class="price-value">{{ billingCycle === 'yearly' ? plan.yearlyPrice : plan.monthlyPrice }}</span>
              <span class="price-period">/{{ billingCycle === 'yearly' ? '年' : '月' }}</span>
            </div>
            <div class="price-original" v-if="billingCycle === 'monthly' && plan.yearlyPrice < plan.monthlyPrice * 12">
              年付仅 ${{ plan.yearlyPrice }}/年（省 {{ Math.round((1 - plan.yearlyPrice / (plan.monthlyPrice * 12)) * 100) }}%）
            </div>
          </div>

          <div class="plan-features">
            <div
              class="feature-item"
              v-for="feature in plan.features"
              :key="feature.text"
            >
              <el-icon :size="14" :color="feature.included ? '#67c23a' : '#c0c4cc'">
                <component :is="feature.included ? 'Check' : 'Close'" />
              </el-icon>
              <span :class="{ 'feature-excluded': !feature.included }">{{ feature.text }}</span>
              <el-tooltip
                v-if="feature.tip"
                :content="feature.tip"
                placement="top"
              >
                <el-icon :size="14" class="feature-tip"><QuestionFilled /></el-icon>
              </el-tooltip>
            </div>
          </div>

          <div class="plan-footer">
            <el-button
              :type="plan.recommended ? 'primary' : 'default'"
              :disabled="plan.id === currentPlan.id"
              size="large"
              round
              class="buy-btn"
              @click="handleBuy(plan)"
            >
              {{ plan.id === currentPlan.id ? '当前套餐' : plan.recommended ? '立即订阅' : '选择套餐' }}
            </el-button>
          </div>
        </div>
      </div>
    </div>

    <!-- 常见问题 -->
    <div class="faq-section">
      <h3 class="section-title">常见问题</h3>
      <el-collapse>
        <el-collapse-item v-for="faq in faqs" :key="faq.id" :title="faq.question">
          <p class="faq-answer">{{ faq.answer }}</p>
        </el-collapse-item>
      </el-collapse>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import {
  Present,
  Check,
  Close,
  QuestionFilled
} from '@element-plus/icons-vue'

const billingCycle = ref('yearly')
const billingOptions = [
  { label: '按年付费（更优惠）', value: 'yearly' },
  { label: '按月付费', value: 'monthly' },
]

const currentPlan = ref({
  id: 'pro',
  name: '专业版',
  expireDate: '2026-09-15',
})

const daysLeft = computed(() => {
  const now = new Date()
  const expire = new Date(currentPlan.value.expireDate)
  return Math.ceil((expire - now) / (1000 * 60 * 60 * 24))
})

const usages = ref([
  { label: 'AI视频生成', used: 45, total: 100, percent: 45, color: '#667eea' },
  { label: '商品主图生成', used: 78, total: 200, percent: 39, color: '#4facfe' },
  { label: '模特换衣次数', used: 23, total: 50, percent: 46, color: '#f093fb' },
  { label: '客资管理数', used: 156, total: 500, percent: 31, color: '#43e97b' },
])

const plans = ref([
  {
    id: 'free',
    name: '免费版',
    description: '适合个人试用体验',
    monthlyPrice: 0,
    yearlyPrice: 0,
    recommended: false,
    features: [
      { text: 'AI视频生成 5次/月', included: true },
      { text: '商品主图 10张/月', included: true },
      { text: '模特换衣 3次/月', included: true },
      { text: '素材库 100MB', included: true },
      { text: '选品数据查询', included: true, tip: '每日限50次查询' },
      { text: '爆款视频分析', included: false },
      { text: '客资管理', included: false },
      { text: '达人对接', included: false },
      { text: '专属客服支持', included: false },
      { text: 'API接口调用', included: false },
    ],
  },
  {
    id: 'pro',
    name: '专业版',
    description: '适合中小卖家日常运营',
    monthlyPrice: 29,
    yearlyPrice: 199,
    recommended: true,
    features: [
      { text: 'AI视频生成 100次/月', included: true },
      { text: '商品主图 200张/月', included: true },
      { text: '模特换衣 50次/月', included: true },
      { text: '素材库 10GB', included: true },
      { text: '选品数据查询（无限制）', included: true },
      { text: '爆款视频分析', included: true },
      { text: '客资管理 500人', included: true },
      { text: '达人对接 10次/月', included: true },
      { text: '专属客服支持', included: true },
      { text: 'API接口调用', included: false, tip: '企业版专属功能' },
    ],
  },
  {
    id: 'enterprise',
    name: '企业版',
    description: '适合团队协作与规模化运营',
    monthlyPrice: 99,
    yearlyPrice: 799,
    recommended: false,
    features: [
      { text: 'AI视频生成 500次/月', included: true },
      { text: '商品主图 1000张/月', included: true },
      { text: '模特换衣 200次/月', included: true },
      { text: '素材库 100GB', included: true },
      { text: '选品数据查询（无限制）', included: true },
      { text: '爆款视频分析', included: true },
      { text: '客资管理（无限制）', included: true },
      { text: '达人对接（无限制）', included: true },
      { text: '7×24小时专属客服', included: true },
      { text: 'API接口调用', included: true, tip: '支持自定义集成开发' },
    ],
  },
])

const faqs = ref([
  { id: 1, question: '如何升级或降级套餐？', answer: '在套餐选择区域点击目标套餐的"选择套餐"按钮即可。升级立即生效，已付费用按剩余天数折算抵扣。降级将于当前周期结束后生效。' },
  { id: 2, question: '支持哪些支付方式？', answer: '目前支持信用卡（Visa/Mastercard）、PayPal、以及支付宝国际版。企业版客户可选择银行转账方式。' },
  { id: 3, question: '可以随时取消订阅吗？', answer: '当然可以。取消后您在已付费周期内仍可正常使用所有功能，到期后自动降级为免费版，不会产生额外费用。' },
  { id: 4, question: '免费版有什么限制？', answer: '免费版每月提供有限的AI生成次数和素材存储空间，部分高级功能（如爆款视频分析、客资管理）不可用，适合体验平台核心功能。' },
  { id: 5, question: '如何获取发票？', answer: '订阅成功后，可以在账户中心→订单记录中申请开具电子发票，支持增值税普通发票和专用发票，通常1-3个工作日发送至您的邮箱。' },
])

const handleBuy = (plan) => {
  console.log('购买套餐:', plan.name, billingCycle.value)
}
</script>

<style scoped>
.purchase-page {
  padding: 24px;
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 24px;
  text-align: center;
}

.page-title {
  font-size: 26px;
  font-weight: 700;
  color: #1a1a2e;
  margin: 0 0 6px;
}

.page-desc {
  font-size: 14px;
  color: #909399;
  margin: 0;
}

/* 当前套餐 */
.current-plan {
  background: #fff;
  border-radius: 12px;
  padding: 24px;
  margin-bottom: 32px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.06);
}

.plan-status {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}

.status-left {
  display: flex;
  align-items: center;
  gap: 14px;
}

.crown-icon {
  color: #e6a23c;
}

.plan-name {
  font-size: 16px;
  font-weight: 600;
  color: #1a1a2e;
}

.plan-expire {
  font-size: 13px;
  color: #909399;
  margin-top: 4px;
}

.usage-overview {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.usage-item {
  flex: 1;
}

.usage-label {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #606266;
  margin-bottom: 6px;
}

.usage-value {
  color: #303133;
  font-weight: 500;
}

/* 套餐区域 */
.plans-section {
  margin-bottom: 40px;
}

.section-title {
  font-size: 18px;
  font-weight: 600;
  color: #1a1a2e;
  margin: 0 0 20px;
}

.billing-toggle {
  display: flex;
  justify-content: center;
  margin-bottom: 28px;
}

.plans-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.plan-card {
  background: #fff;
  border-radius: 14px;
  padding: 28px 24px 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
  position: relative;
  transition: transform 0.3s, box-shadow 0.3s;
  display: flex;
  flex-direction: column;
}

.plan-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

.plan-recommended {
  border: 2px solid #667eea;
}

.plan-current {
  background: #fafafa;
}

.plan-ribbon {
  position: absolute;
  top: 12px;
  right: -6px;
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: #fff;
  font-size: 12px;
  font-weight: 600;
  padding: 4px 14px;
  border-radius: 4px;
}

.plan-ribbon::after {
  content: '';
  position: absolute;
  bottom: -6px;
  right: 0;
  border: 3px solid #764ba2;
  border-bottom-color: transparent;
  border-left-color: transparent;
}

.plan-header {
  text-align: center;
  margin-bottom: 24px;
}

.plan-name {
  font-size: 20px;
  font-weight: 700;
  color: #1a1a2e;
  margin: 0 0 6px;
}

.plan-desc {
  font-size: 13px;
  color: #909399;
  margin: 0 0 16px;
}

.plan-price {
  display: flex;
  align-items: baseline;
  justify-content: center;
  gap: 2px;
}

.price-symbol {
  font-size: 18px;
  font-weight: 600;
  color: #1a1a2e;
}

.price-value {
  font-size: 40px;
  font-weight: 800;
  color: #1a1a2e;
  line-height: 1;
}

.price-period {
  font-size: 14px;
  color: #909399;
}

.price-original {
  font-size: 12px;
  color: #67c23a;
  margin-top: 6px;
}

/* 功能列表 */
.plan-features {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 24px;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: #303133;
}

.feature-excluded {
  color: #c0c4cc;
}

.feature-tip {
  color: #c0c4cc;
  cursor: help;
  margin-left: 2px;
}

/* 购买按钮 */
.plan-footer {
  text-align: center;
}

.buy-btn {
  width: 100%;
}

/* 常见问题 */
.faq-section {
  background: #fff;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.06);
}

.faq-answer {
  color: #606266;
  font-size: 14px;
  line-height: 1.8;
  margin: 0;
}

@media (max-width: 1000px) {
  .plans-grid { grid-template-columns: 1fr; max-width: 400px; margin: 0 auto; }
  .usage-overview { grid-template-columns: repeat(2, 1fr); }
}
</style>
