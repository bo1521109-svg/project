<template>
  <div class="site-preview">
    <!-- ====== 顶部工具栏 ====== -->
    <div class="preview-toolbar">
      <div class="toolbar-left">
        <el-button text @click="goBack">
          <el-icon><ArrowLeft /></el-icon>
          返回
        </el-button>
        <span class="toolbar-divider"></span>
        <div class="toolbar-info">
          <el-icon :size="18" color="#409eff"><Monitor /></el-icon>
          <span class="toolbar-site-name">{{ site?.name || '站点预览' }}</span>
          <el-tag v-if="site" :type="statusTagType" size="small" effect="plain">
            {{ statusLabel }}
          </el-tag>
        </div>
      </div>
      <div class="toolbar-right">
        <el-tag type="info" effect="plain" size="small" class="preview-badge">
          <el-icon style="margin-right: 4px"><View /></el-icon>
          预览模式
        </el-tag>
        <el-button size="small" @click="goToDetail">
          <el-icon><Setting /></el-icon>
          编辑站点
        </el-button>
      </div>
    </div>

    <!-- ====== 加载中 ====== -->
    <div v-if="loading" class="preview-loading">
      <el-skeleton :rows="8" animated />
    </div>

    <!-- ====== 站点不存在 ====== -->
    <el-empty v-else-if="!site" description="站点不存在" />

    <!-- ====== 预览主体 ====== -->
    <div v-else class="preview-body">
      <div class="preview-device-frame">
        <!-- 浏览器模拟顶部 -->
        <div class="browser-bar">
          <div class="browser-dots">
            <span class="browser-dot dot-red"></span>
            <span class="browser-dot dot-yellow"></span>
            <span class="browser-dot dot-green"></span>
          </div>
          <div class="browser-url">
            <el-icon :size="14" color="#67c23a"><Lock /></el-icon>
            <span>{{ site.domain || 'preview.local' }}</span>
          </div>
          <div style="width: 68px" />
        </div>

        <!-- 占位：导航栏 -->
        <div class="mock-nav">
          <div class="mock-nav-brand">{{ site.name }}</div>
          <div class="mock-nav-links">
            <span v-for="link in mockNavLinks" :key="link.label" class="mock-nav-item">{{ link.label }}</span>
          </div>
          <div class="mock-nav-action">
            <span class="mock-nav-btn">立即购买</span>
          </div>
        </div>

        <!-- 占位：Hero Banner -->
        <div class="mock-hero" :style="{ background: heroGradient }">
          <div class="mock-hero-content">
            <h1 class="mock-hero-title">{{ site.name }}</h1>
            <p class="mock-hero-subtitle">发现精选好物，尽在 {{ site.name }} — {{ industryLabel }}</p>
            <span class="mock-hero-btn">探索更多</span>
          </div>
        </div>

        <!-- 占位：商品展示 -->
        <div class="mock-products-section">
          <h2 class="mock-section-title">热门商品</h2>
          <div class="mock-products-grid">
            <div v-for="(product, idx) in mockProducts" :key="idx" class="mock-product-card">
              <div class="mock-product-img" :style="{ background: product.color }">
                <el-icon :size="32" color="rgba(255,255,255,0.5)"><Box /></el-icon>
              </div>
              <div class="mock-product-info">
                <span class="mock-product-name">{{ product.name }}</span>
                <span class="mock-product-price">{{ product.price }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 占位：特性区 -->
        <div class="mock-features">
          <div v-for="f in mockFeatures" :key="f.icon" class="mock-feature-item">
            <el-icon :size="24" :color="f.iconColor" style="margin-bottom: 8px">
              <Van v-if="f.icon === 'van'" />
              <Service v-else-if="f.icon === 'service'" />
              <RefreshRight v-else />
            </el-icon>
            <span class="mock-feature-title">{{ f.title }}</span>
            <span class="mock-feature-desc">{{ f.desc }}</span>
          </div>
        </div>

        <!-- 占位：页脚 -->
        <div class="mock-footer">
          <div class="mock-footer-content">
            <div class="mock-footer-brand">{{ site.name }}</div>
            <div class="mock-footer-links">
              <span>关于我们</span>
              <span>联系我们</span>
              <span>隐私政策</span>
              <span>服务条款</span>
            </div>
          </div>
          <div class="mock-footer-bottom">
            © {{ new Date().getFullYear() }} {{ site.name }}. All rights reserved. (预览演示)
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  ArrowLeft, Monitor, View, Lock, Setting,
  Box, Van, Service, RefreshRight
} from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()

// ====== Mock 站点数据 ======
const mockSites = [
  { id: 1, name: 'FashionVibe 时尚馆', domain: 'fashionvibe.com', industry: '服装', template_name: '时尚精品', status: 'published', visits: 28450, orders: 1234, conversion_rate: 4.3, avg_order_value: 89.5, created_at: '2026-01-15T08:00:00Z' },
  { id: 2, name: 'TechGadget Pro', domain: 'techgadget.shop', industry: '数码', template_name: '科技极简', status: 'published', visits: 56780, orders: 2890, conversion_rate: 5.1, avg_order_value: 156.0, created_at: '2026-02-20T10:00:00Z' },
  { id: 3, name: 'HomeLiving 居家生活馆', domain: 'homeliving.store', industry: '家居', template_name: '温馨家居', status: 'draft', visits: 0, orders: 0, conversion_rate: 0, avg_order_value: 0, created_at: '2026-04-05T09:15:00Z' },
  { id: 4, name: 'BeautyGlow 美妆坊', domain: 'beautyglow.com', industry: '美妆', template_name: '时尚精品', status: 'published', visits: 12340, orders: 567, conversion_rate: 4.6, avg_order_value: 65.0, created_at: '2026-03-10T11:30:00Z' },
  { id: 5, name: 'PetPals 宠物乐园', domain: 'petpals.shop', industry: '宠物', template_name: '可爱风格', status: 'paused', visits: 8900, orders: 345, conversion_rate: 3.9, avg_order_value: 52.0, created_at: '2026-02-01T14:00:00Z' },
  { id: 6, name: 'SportMax 运动装备', domain: 'sportmax.store', industry: '运动', template_name: '运动活力', status: 'published', visits: 34560, orders: 1678, conversion_rate: 4.8, avg_order_value: 120.0, created_at: '2026-01-28T07:45:00Z' },
  { id: 7, name: 'BabyJoy 母婴优选', domain: 'babyjoy.com', industry: '母婴', template_name: '温馨家居', status: 'draft', visits: 0, orders: 0, conversion_rate: 0, avg_order_value: 0, created_at: '2026-05-18T16:30:00Z' },
  { id: 8, name: 'GreenLeaf 有机食品', domain: 'greenleaf.farm', industry: '食品', template_name: '自然生态', status: 'published', visits: 19800, orders: 912, conversion_rate: 4.6, avg_order_value: 78.0, created_at: '2026-03-22T13:00:00Z' }
]

// ====== 状态 ======
const loading = ref(true)
const site = ref(null)

// 行业中文名映射
const industryLabel = computed(() => {
  const map = { 服装: '时尚穿搭', 数码: '科技好物', 家居: '生活好物', 美妆: '美妆护肤', 宠物: '萌宠好物', 运动: '运动装备', 母婴: '母婴好物', 食品: '健康美食', 教育: '知识好物', 珠宝: '精美饰品', 其他: '精选好物' }
  return map[site.value?.industry] || '精选好物'
})

// 状态映射
const statusLabel = computed(() => {
  const map = { draft: '草稿', published: '已发布', paused: '已暂停', archived: '已下线' }
  return map[site.value?.status] || site.value?.status
})
const statusTagType = computed(() => {
  const map = { draft: 'info', published: 'success', paused: 'warning', archived: 'danger' }
  return map[site.value?.status] || 'info'
})

// 按行业设置 Hero 渐变色
const heroGradient = computed(() => {
  const gradients = {
    服装: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
    数码: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
    家居: 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
    美妆: 'linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%)',
    宠物: 'linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%)',
    运动: 'linear-gradient(135deg, #fccb90 0%, #d57eeb 100%)',
    母婴: 'linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%)',
    食品: 'linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)',
    教育: 'linear-gradient(135deg, #d299c2 0%, #fef9d7 100%)',
    珠宝: 'linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%)'
  }
  return gradients[site.value?.industry] || 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
})

// Mock 导航链接
const mockNavLinks = [
  { label: '首页' },
  { label: '全部商品' },
  { label: '新品上市' },
  { label: '限时特惠' },
  { label: '关于我们' }
]

// Mock 商品
const mockProducts = [
  { name: '精选商品 A', price: '¥199.00', color: 'linear-gradient(135deg, #667eea, #764ba2)' },
  { name: '热门商品 B', price: '¥299.00', color: 'linear-gradient(135deg, #f093fb, #f5576c)' },
  { name: '推荐商品 C', price: '¥159.00', color: 'linear-gradient(135deg, #4facfe, #00f2fe)' },
  { name: '性价比 D', price: '¥89.00', color: 'linear-gradient(135deg, #84fab0, #8fd3f4)' }
]

// Mock 特性
const mockFeatures = [
  { icon: 'van', title: '全球包邮', desc: '满 $50 免运费', iconColor: '#409eff' },
  { icon: 'service', title: '售后无忧', desc: '7 天无理由退换', iconColor: '#67c23a' },
  { icon: 'refresh', title: '极速退款', desc: '确认后 24h 到账', iconColor: '#e6a23c' }
]

// ====== 加载数据 ======
const id = Number(route.params.id)
const found = mockSites.find(s => s.id === id)
site.value = found || null
loading.value = false

// ====== 方法 ======
function goBack() {
  router.push(`/website/${id}`)
}
function goToDetail() {
  router.push(`/website/${id}`)
}
</script>

<style scoped>
.site-preview {
  min-height: 100vh;
  background: #f0f2f5;
}

/* ====== 顶部工具栏 ====== */
.preview-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 56px;
  padding: 0 24px;
  background: #fff;
  border-bottom: 1px solid #e8ecf1;
  position: sticky;
  top: 0;
  z-index: 100;
}
.toolbar-left {
  display: flex;
  align-items: center;
  gap: 12px;
}
.toolbar-divider {
  width: 1px;
  height: 24px;
  background: #e8ecf1;
}
.toolbar-info {
  display: flex;
  align-items: center;
  gap: 8px;
}
.toolbar-site-name {
  font-size: 15px;
  font-weight: 600;
  color: #303133;
}
.toolbar-right {
  display: flex;
  align-items: center;
  gap: 12px;
}
.preview-badge .el-icon {
  vertical-align: middle;
}

/* ====== 加载中 ====== */
.preview-loading {
  max-width: 1200px;
  margin: 40px auto;
  padding: 40px;
  background: #fff;
  border-radius: 12px;
}

/* ====== 预览框架 ====== */
.preview-body {
  display: flex;
  justify-content: center;
  padding: 24px 16px;
}
.preview-device-frame {
  width: 100%;
  max-width: 1200px;
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 40px rgba(0, 0, 0, 0.08);
}

/* ====== 浏览器顶栏 ====== */
.browser-bar {
  display: flex;
  align-items: center;
  height: 40px;
  padding: 0 16px;
  background: #f5f5f5;
  border-bottom: 1px solid #e0e0e0;
  gap: 12px;
}
.browser-dots {
  display: flex;
  gap: 6px;
}
.browser-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
}
.dot-red { background: #ff5f57; }
.dot-yellow { background: #febc2e; }
.dot-green { background: #28c840; }
.browser-url {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  height: 26px;
  background: #fff;
  border-radius: 4px;
  font-size: 12px;
  color: #606266;
  border: 1px solid #e0e0e0;
}

/* ====== Mock 导航 ====== */
.mock-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 60px;
  padding: 0 40px;
  border-bottom: 1px solid #f0f0f0;
}
.mock-nav-brand {
  font-size: 18px;
  font-weight: 700;
  color: #303133;
}
.mock-nav-links {
  display: flex;
  gap: 24px;
}
.mock-nav-item {
  font-size: 14px;
  color: #606266;
  cursor: default;
}
.mock-nav-action {
  flex-shrink: 0;
}
.mock-nav-btn {
  display: inline-block;
  padding: 6px 20px;
  background: linear-gradient(135deg, #409eff, #5372ff);
  color: #fff;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 500;
}

/* ====== Mock Hero ====== */
.mock-hero {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 320px;
  color: #fff;
  text-align: center;
}
.mock-hero-content {
  max-width: 600px;
  padding: 40px 20px;
}
.mock-hero-title {
  margin: 0 0 12px;
  font-size: 36px;
  font-weight: 800;
  letter-spacing: -0.5px;
}
.mock-hero-subtitle {
  margin: 0 0 28px;
  font-size: 16px;
  opacity: 0.9;
  line-height: 1.6;
}
.mock-hero-btn {
  display: inline-block;
  padding: 10px 32px;
  background: rgba(255, 255, 255, 0.2);
  border: 2px solid rgba(255, 255, 255, 0.4);
  border-radius: 24px;
  font-size: 15px;
  font-weight: 600;
  cursor: default;
  backdrop-filter: blur(4px);
}

/* ====== Mock 商品 ====== */
.mock-products-section {
  padding: 40px;
}
.mock-section-title {
  margin: 0 0 24px;
  font-size: 20px;
  font-weight: 700;
  color: #303133;
}
.mock-products-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}
.mock-product-card {
  background: #fafafa;
  border-radius: 12px;
  overflow: hidden;
  border: 1px solid #f0f0f0;
  transition: transform 0.2s;
}
.mock-product-card:hover {
  transform: translateY(-4px);
}
.mock-product-img {
  height: 180px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.mock-product-info {
  padding: 12px 16px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.mock-product-name {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}
.mock-product-price {
  font-size: 16px;
  font-weight: 700;
  color: #f56c6c;
}

/* ====== Mock 特性 ====== */
.mock-features {
  display: flex;
  justify-content: center;
  gap: 80px;
  padding: 40px;
  background: #fafbfc;
  border-top: 1px solid #f0f0f0;
}
.mock-feature-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}
.mock-feature-title {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}
.mock-feature-desc {
  font-size: 12px;
  color: #909399;
  margin-top: 2px;
}

/* ====== Mock 页脚 ====== */
.mock-footer {
  background: #1a1a2e;
  color: #fff;
}
.mock-footer-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 32px 40px;
}
.mock-footer-brand {
  font-size: 16px;
  font-weight: 700;
}
.mock-footer-links {
  display: flex;
  gap: 24px;
}
.mock-footer-links span {
  font-size: 13px;
  opacity: 0.7;
  cursor: default;
}
.mock-footer-links span:hover {
  opacity: 1;
}
.mock-footer-bottom {
  text-align: center;
  padding: 16px;
  font-size: 12px;
  opacity: 0.5;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

/* ====== 响应式 ====== */
@media (max-width: 768px) {
  .mock-products-grid { grid-template-columns: repeat(2, 1fr); }
  .mock-nav-links { display: none; }
  .mock-features { gap: 24px; flex-wrap: wrap; }
  .mock-footer-content { flex-direction: column; gap: 16px; }
}
</style>
