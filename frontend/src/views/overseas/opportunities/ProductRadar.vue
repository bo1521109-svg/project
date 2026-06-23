<template>
  <div class="product-radar">
    <!-- ====== 顶部标题 + 统计 ====== -->
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">爆品雷达 <span class="radar-dot"></span></h1>
        <p class="page-subtitle">跨平台爆品实时捕捉，发现下一个爆款</p>
      </div>
    </div>

    <!-- 统计行 -->
    <div class="stats-row">
      <div class="stat-card">
        <span class="stat-icon">🔥</span>
        <div class="stat-body">
          <span class="stat-num">{{ stats.total }}</span>
          <span class="stat-label">追踪爆品</span>
        </div>
      </div>
      <div class="stat-card">
        <span class="stat-icon">✨</span>
        <div class="stat-body">
          <span class="stat-num">+{{ stats.newToday }}</span>
          <span class="stat-label">今日新增</span>
        </div>
      </div>
      <div class="stat-card">
        <span class="stat-icon">📊</span>
        <div class="stat-body">
          <span class="stat-num">{{ stats.avgHeat }}</span>
          <span class="stat-label">平均热度</span>
        </div>
      </div>
      <div class="stat-card">
        <span class="stat-icon">🚀</span>
        <div class="stat-body">
          <span class="stat-num">+{{ stats.maxGrowth }}%</span>
          <span class="stat-label">最高增长率</span>
        </div>
      </div>
    </div>

    <!-- ====== 筛选栏 ====== -->
    <div class="filter-bar">
      <div class="filter-left">
        <el-input v-model="filters.keyword" placeholder="搜索商品名、店铺..." size="large" clearable class="search-input" @clear="fetchData" @keyup.enter="fetchData">
          <template #prefix><el-icon><Search /></el-icon></template>
        </el-input>
        <el-select v-model="filters.category" placeholder="全部品类" size="large" clearable class="filt-sel" @change="fetchData">
          <el-option v-for="c in categories" :key="c" :label="c" :value="c" />
        </el-select>
        <el-select v-model="filters.platform" placeholder="全部平台" size="large" clearable class="filt-sel" @change="fetchData">
          <el-option v-for="p in platforms" :key="p" :label="p" :value="p" />
        </el-select>
        <el-select v-model="filters.sortBy" size="large" class="filt-sel sort-sel" @change="fetchData">
          <el-option label="🔥 热度排序" value="popularityScore" />
          <el-option label="📈 增长率" value="growthRate" />
          <el-option label="💰 销量" value="weeklySales" />
          <el-option label="🆕 最新" value="newest" />
        </el-select>
      </div>
      <el-button size="large" type="primary" @click="fetchData">搜索</el-button>
    </div>

    <!-- ====== 爆品卡片网格 ====== -->
    <div class="product-grid" v-if="products.length">
      <div v-for="(p, idx) in products" :key="p.id" class="product-card" :style="{ animationDelay: idx * 0.04 + 's' }" @click="openDetail(p)">
        <!-- 图片 -->
        <div class="card-image-wrap">
          <img :src="p.imageUrl" :alt="p.name" class="card-image" @error="e => e.target.src='https://picsum.photos/seed/prod0/400/400'" />
        </div>
        <!-- 信息 -->
        <div class="card-body">
          <h4 class="card-name">{{ p.name }} <span class="plat-badge" :class="platClass(p.platform)">{{ p.platform }}</span></h4>
          <div class="card-price-row">
            <span class="card-price">${{ p.price }}</span>
            <span class="card-sales">周销 {{ fmtNum(p.weeklySales) }}</span>
          </div>
          <!-- 增长 + 热度 -->
          <div class="card-stats">
            <span class="card-growth" :class="p.growthRate >= 30 ? 'hot' : 'normal'">▲ +{{ p.growthRate }}%</span>
            <div class="card-heat">
              <div class="heat-bg"><div class="heat-fill" :style="{ width: p.popularityScore + '%' }" /></div>
              <span>{{ p.popularityScore }}</span>
            </div>
          </div>
          <!-- 店铺 + 国家 -->
          <div class="card-footer">
            <span class="card-shop">{{ p.shopName }}</span>
            <span class="card-country">{{ p.country }}</span>
          </div>
          <!-- 标签 -->
          <div class="card-tags">
            <span v-for="t in p.tags" :key="t" class="c-tag">{{ t }}</span>
          </div>
        </div>
      </div>
    </div>
    <div v-else class="empty-state"><el-empty description="未找到匹配的爆品" :image-size="100" /></div>

    <!-- ====== 分页 ====== -->
    <div class="pagination-wrap" v-if="total > pageSize">
      <el-pagination v-model:current-page="page" :page-size="pageSize" :total="total" layout="prev, pager, next" background @current-change="onPageChange" />
    </div>

    <!-- ====== 详情弹窗 ====== -->
    <el-dialog v-model="detailVisible" width="520px" class="detail-dialog" destroy-on-close>
      <template #header>
        <div class="dialog-hd">
          <h3>{{ detailProduct?.name }}</h3>
          <span class="plat-badge" :class="platClass(detailProduct?.platform)">{{ detailProduct?.platform }}</span>
        </div>
      </template>
      <template v-if="detailProduct">
        <div class="detail-grid">
          <div class="dg-item"><span class="dg-label">品类</span><span class="dg-value">{{ detailProduct.category }}</span></div>
          <div class="dg-item"><span class="dg-label">价格</span><span class="dg-value">${{ detailProduct.price }}</span></div>
          <div class="dg-item"><span class="dg-label">周销量</span><span class="dg-value">{{ fmtNum(detailProduct.weeklySales) }}</span></div>
          <div class="dg-item"><span class="dg-label">日销量</span><span class="dg-value">{{ fmtNum(detailProduct.dailySales || Math.floor(detailProduct.weeklySales/7)) }}</span></div>
          <div class="dg-item"><span class="dg-label">增长率</span><span class="dg-value green">+{{ detailProduct.growthRate }}%</span></div>
          <div class="dg-item"><span class="dg-label">转化率</span><span class="dg-value">{{ detailProduct.conversionRate || '--' }}%</span></div>
          <div class="dg-item"><span class="dg-label">店铺</span><span class="dg-value">{{ detailProduct.shopName }}</span></div>
          <div class="dg-item"><span class="dg-label">国家</span><span class="dg-value">{{ detailProduct.country }}</span></div>
          <div class="dg-item full"><span class="dg-label">标签</span><span class="dg-value"><span v-for="t in detailProduct.tags" :key="t" class="c-tag">{{ t }}</span></span></div>
        </div>
      </template>
      <template #footer><el-button @click="detailVisible=false">关闭</el-button></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Search } from '@element-plus/icons-vue'
import { getProductRadarStats, getProductRadarProducts } from '@/api/overseas'

const categories = ['服装','美妆','3C数码','家居','运动户外','食品','珠宝饰品','母婴','宠物','个护']
const platforms = ['TikTok','Shopify','Amazon']

const filters = ref({ keyword:'', category:'', platform:'', sortBy:'popularityScore' })
const page = ref(1)
const pageSize = 12
const total = ref(0)
const products = ref([])
const stats = ref({ total:50, newToday:12, avgHeat:87.5, maxGrowth:320 })

const detailVisible = ref(false)
const detailProduct = ref(null)

function fmtNum(n) { return n >= 10000 ? (n/10000).toFixed(1)+'w' : n >= 1000 ? (n/1000).toFixed(1)+'k' : String(n) }
function platClass(p) { return p === 'TikTok' ? 'tt' : p === 'Shopify' ? 'sp' : 'az' }

function fetchData() {
  page.value = 1
  loadData()
}
function onPageChange(p) { page.value = p; loadData() }
function openDetail(p) { detailProduct.value = p; detailVisible.value = true }

function loadData() {
  const params = { page: page.value, pageSize, ...filters.value }
  const result = getProductRadarProducts(params)
  products.value = result.items
  total.value = result.total
  stats.value = getProductRadarStats(filters.value)
}

onMounted(loadData)
</script>

<style scoped>
.product-radar { max-width:1440px; margin:0 auto; }

.page-header { margin-bottom:24px; }
.header-left { display:flex; flex-direction:column; gap:6px; }
.page-title { margin:0; font-size:28px; font-weight:700; color:#1A2A3A; display:flex; align-items:center; gap:8px; }
.radar-dot { width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#C9A96E,#ff6b35); box-shadow:0 0 12px rgba(201,169,110,.3); display:inline-block; animation:pulse 2s infinite; }
@keyframes pulse { 0%,100%{box-shadow:0 0 12px rgba(201,169,110,.3)} 50%{box-shadow:0 0 20px rgba(201,169,110,.6)} }
.page-subtitle { margin:0; font-size:14px; color:#8A9AA8; }

/* 统计行 */
.stats-row { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:24px; }
.stat-card { background:#fff; border-radius:14px; padding:16px 20px; display:flex; align-items:center; gap:14px; box-shadow:0 2px 12px rgba(0,0,0,0.04); }
.stat-icon { font-size:28px; }
.stat-body { display:flex; flex-direction:column; gap:2px; }
.stat-num { font-size:22px; font-weight:700; color:#1A2A3A; }
.stat-label { font-size:12px; color:#8A9AA8; }
@media (max-width:768px) { .stats-row { grid-template-columns:repeat(2,1fr); } }

/* 筛选栏 */
.filter-bar { display:flex; align-items:center; gap:12px; margin-bottom:24px; flex-wrap:wrap; }
.filter-left { display:flex; align-items:center; gap:10px; flex:1; flex-wrap:wrap; }
.search-input { width:240px; }
.search-input :deep(.el-input__wrapper){ border-radius:12px; }
.filt-sel { width:140px; }
.filt-sel :deep(.el-input__wrapper){ border-radius:12px; }

/* 商品网格 */
.product-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:20px; margin-bottom:28px; }
@media (max-width:1100px){ .product-grid { grid-template-columns:repeat(2,1fr); } }
@media (max-width:640px){ .product-grid { grid-template-columns:1fr; } }

.product-card {
  background:#fff; border-radius:16px; overflow:hidden;
  box-shadow:0 2px 12px rgba(0,0,0,0.04); cursor:pointer;
  transition:all .35s; animation:cardUp .5s ease backwards;
}
@keyframes cardUp { from{opacity:0;transform:translateY(16px)} to{opacity:1;transform:translateY(0)} }
.product-card:hover { transform:translateY(-4px); box-shadow:0 16px 40px rgba(0,0,0,0.08); }

.card-image-wrap { position:relative; height:200px; overflow:hidden; background:#f8f9fc; }
.card-image { width:100%; height:100%; object-fit:cover; transition:transform .5s; }
.product-card:hover .card-image { transform:scale(1.05); }
.plat-badge { display:inline-block; padding:2px 8px; border-radius:20px; font-size:10px; font-weight:600; color:#fff; vertical-align:middle; }
.plat-badge.tt { background:linear-gradient(135deg,#fe2c55,#ff4d6a); }
.plat-badge.sp { background:linear-gradient(135deg,#95bf47,#7ab648); }
.plat-badge.az { background:linear-gradient(135deg,#ff9900,#ffac33); }

.card-body { padding:16px 18px; }
.card-name { margin:0 0 10px; font-size:15px; font-weight:700; color:#1A2A3A; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
.card-price-row { display:flex; justify-content:space-between; margin-bottom:10px; }
.card-price { font-size:20px; font-weight:700; color:#F56C6C; }
.card-sales { font-size:12px; color:#909399; }

.card-stats { display:flex; justify-content:space-between; align-items:center; margin-bottom:10px; }
.card-growth { font-size:13px; font-weight:600; }
.card-growth.hot { color:#FF6B35; }
.card-growth.normal { color:#909399; }
.card-heat { display:flex; align-items:center; gap:6px; flex:1; max-width:120px; }
.heat-bg { flex:1; height:6px; background:#F0F2F5; border-radius:3px; overflow:hidden; }
.heat-fill { height:100%; background:linear-gradient(90deg,#ff6b35,#ff9a62); border-radius:3px; }
.card-heat span { font-size:11px; color:#909399; }

.card-footer { display:flex; justify-content:space-between; align-items:center; margin-bottom:8px; }
.card-shop { font-size:12px; color:#409EFF; font-weight:500; }
.card-country { font-size:11px; color:#B0BCC8; }

.card-tags { display:flex; gap:4px; flex-wrap:wrap; }
.c-tag { font-size:10px; padding:2px 8px; border-radius:6px; background:linear-gradient(135deg,#ECF5FF,#E8F4FD); color:#409EFF; font-weight:500; }

.empty-state { padding:60px 0; }
.pagination-wrap { display:flex; justify-content:center; padding:20px 0; }

/* 详情弹窗 */
.detail-dialog :deep(.el-dialog__body){ padding:0 20px 20px; }
.dialog-hd { display:flex; align-items:center; gap:12px; }
.dialog-hd h3 { margin:0; font-size:18px; font-weight:700; color:#1A2A3A; }
.detail-grid { display:grid; grid-template-columns:1fr 1fr; gap:10px; }
.dg-item { padding:10px 14px; background:#FAFBFC; border-radius:10px; display:flex; flex-direction:column; gap:4px; }
.dg-item.full { grid-column:1/-1; }
.dg-label { font-size:11px; color:#8A9AA8; }
.dg-value { font-size:14px; font-weight:600; color:#1A2A3A; display:flex; gap:6px; flex-wrap:wrap; align-items:center; }
.dg-value.green { color:#52C41A; }
</style>
