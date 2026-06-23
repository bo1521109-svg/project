<template>
  <div class="crawler-logs">
    <div class="page-header">
      <h2 class="page-title">爬虫日志</h2>
      <p class="page-desc">查看和管理所有爬虫任务的运行日志详情</p>
    </div>

    <!-- 统计卡片 -->
    <div class="stat-cards">
      <div class="stat-card" v-for="stat in stats" :key="stat.label">
        <div class="stat-icon" :style="{ background: stat.bg }">
          <el-icon :size="20"><component :is="stat.icon" /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ stat.value }}</div>
          <div class="stat-label">{{ stat.label }}</div>
        </div>
      </div>
    </div>

    <!-- 筛选栏 -->
    <div class="filter-bar">
      <div class="filter-left">
        <el-select v-model="filters.task" placeholder="选择任务" clearable style="width: 180px">
          <el-option
            v-for="t in taskOptions"
            :key="t.value"
            :label="t.label"
            :value="t.value"
          />
        </el-select>
        <el-select v-model="filters.level" placeholder="日志级别" clearable style="width: 130px">
          <el-option label="全部级别" value="" />
          <el-option label="INFO" value="INFO" />
          <el-option label="WARNING" value="WARNING" />
          <el-option label="ERROR" value="ERROR" />
          <el-option label="DEBUG" value="DEBUG" />
        </el-select>
        <el-select v-model="filters.period" placeholder="时间范围" style="width: 130px">
          <el-option label="今天" value="today" />
          <el-option label="近3天" value="3days" />
          <el-option label="近7天" value="7days" />
          <el-option label="近30天" value="30days" />
          <el-option label="全部" value="all" />
        </el-select>
      </div>
      <div class="filter-right">
        <el-input
          v-model="filters.keyword"
          placeholder="搜索日志内容..."
          :prefix-icon="Search"
          clearable
          style="width: 240px"
        />
        <el-button :icon="RefreshRight" circle @click="fetchLogs" />
      </div>
    </div>

    <!-- 日志表格 -->
    <div class="table-card" v-loading="loading">
      <el-table
        :data="filteredLogs"
        style="width: 100%"
        :default-sort="{ prop: 'time', order: 'descending' }"
        max-height="600"
        highlight-current-row
      >
        <el-table-column type="expand">
          <template #default="{ row }">
            <div class="log-detail">
              <div class="detail-section">
                <h5>请求详情</h5>
                <div class="detail-grid">
                  <div class="detail-item">
                    <span class="detail-label">请求URL：</span>
                    <span class="detail-value mono">{{ row.requestUrl }}</span>
                  </div>
                  <div class="detail-item">
                    <span class="detail-label">请求方法：</span>
                    <el-tag size="small" type="info">{{ row.method }}</el-tag>
                  </div>
                  <div class="detail-item">
                    <span class="detail-label">状态码：</span>
                    <el-tag size="small" :type="row.statusCode < 400 ? 'success' : 'danger'">{{ row.statusCode }}</el-tag>
                  </div>
                  <div class="detail-item">
                    <span class="detail-label">响应时间：</span>
                    <span class="detail-value">{{ row.responseTime }}ms</span>
                  </div>
                  <div class="detail-item">
                    <span class="detail-label">数据条数：</span>
                    <span class="detail-value">{{ row.dataCount }}条</span>
                  </div>
                  <div class="detail-item">
                    <span class="detail-label">代理IP：</span>
                    <span class="detail-value mono">{{ row.proxyIp }}</span>
                  </div>
                </div>
              </div>
              <div class="detail-section" v-if="row.errorMessage">
                <h5 class="error-title">错误信息</h5>
                <pre class="error-block">{{ row.errorMessage }}</pre>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="时间" prop="time" width="170" sortable>
          <template #default="{ row }">
            <span class="time-text">{{ row.time }}</span>
          </template>
        </el-table-column>

        <el-table-column label="任务名称" prop="taskName" min-width="180" show-overflow-tooltip />

        <el-table-column label="级别" width="90" align="center">
          <template #default="{ row }">
            <el-tag :type="levelTagType(row.level)" size="small" effect="dark">{{ row.level }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column label="摘要" prop="message" min-width="280" show-overflow-tooltip />

        <el-table-column label="耗时" width="90" align="center">
          <template #default="{ row }">
            <span class="duration" :class="{ 'duration-slow': row.responseTime > 3000 }">
              {{ row.responseTime }}ms
            </span>
          </template>
        </el-table-column>

        <el-table-column label="数据量" width="80" align="center">
          <template #default="{ row }">
            <span class="data-count" v-if="row.dataCount > 0">{{ row.dataCount }}</span>
            <span class="no-data" v-else>-</span>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 分页 -->
    <div class="pagination-wrapper">
      <el-pagination
        v-model:current-page="currentPage"
        :page-size="pageSize"
        :total="filteredLogs.length"
        layout="total, prev, pager, next, sizes"
        :page-sizes="[10, 20, 50, 100]"
        background
      />
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Search, RefreshRight, DataAnalysis, WarningFilled, CircleCloseFilled, VideoCamera } from '@element-plus/icons-vue'

const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(20)

const stats = [
  { label: '今日日志', value: '1,286', icon: DataAnalysis, bg: 'linear-gradient(135deg, #667eea, #764ba2)' },
  { label: '错误日志', value: 23, icon: CircleCloseFilled, bg: 'linear-gradient(135deg, #f5576c, #f093fb)' },
  { label: '警告日志', value: 47, icon: WarningFilled, bg: 'linear-gradient(135deg, #f6d365, #fda085)' },
  { label: '活跃任务', value: 8, icon: VideoCamera, bg: 'linear-gradient(135deg, #4facfe, #00f2fe)' },
]

const filters = ref({
  task: '',
  level: '',
  period: 'today',
  keyword: '',
})

const taskOptions = [
  { label: 'Shopify店铺搜索', value: 'shopify_store' },
  { label: 'Shopify产品采集', value: 'shopify_product' },
  { label: 'TikTok达人搜索', value: 'tiktok_influencer' },
  { label: 'TikTok视频采集', value: 'tiktok_video' },
  { label: 'TikTok广告采集', value: 'tiktok_ad' },
  { label: 'TikTok店铺采集', value: 'tiktok_store' },
  { label: '1688商品导入', value: '1688_import' },
  { label: '佣金商品监控', value: 'affiliate_monitor' },
]

const logs = ref([
  { id: 1, time: '2026-06-16 14:32:15', taskName: 'Shopify店铺搜索·美妆品类', level: 'INFO', message: '成功爬取第5页数据，获取店铺列表30条', requestUrl: 'https://xxx.myshopify.com/collections/beauty?page=5', method: 'GET', statusCode: 200, responseTime: 1250, dataCount: 30, proxyIp: '192.168.1.101:8080', errorMessage: '' },
  { id: 2, time: '2026-06-16 14:30:02', taskName: 'TikTok达人搜索·美区', level: 'INFO', message: '达人列表采集完成，共获取200条达人数据', requestUrl: 'https://www.tiktok.com/api/influencer/search?region=US', method: 'POST', statusCode: 200, responseTime: 3200, dataCount: 200, proxyIp: '192.168.1.102:8080', errorMessage: '' },
  { id: 3, time: '2026-06-16 14:28:47', taskName: 'Shopify产品采集·电子品类', level: 'WARNING', message: '请求频率过高，触发限流，等待60秒后重试', requestUrl: 'https://xxx.myshopify.com/products.json?limit=250', method: 'GET', statusCode: 429, responseTime: 450, dataCount: 0, proxyIp: '192.168.1.101:8080', errorMessage: 'HTTP 429: Too Many Requests\nRetry-After: 60s\nRate limit exceeded for shop xxx.myshopify.com' },
  { id: 4, time: '2026-06-16 14:25:33', taskName: 'TikTok视频采集·服装品类', level: 'ERROR', message: '代理连接超时，任务自动暂停', requestUrl: 'https://www.tiktok.com/api/video/feed?category=fashion', method: 'GET', statusCode: 0, responseTime: 15000, dataCount: 0, proxyIp: '192.168.1.105:8080', errorMessage: 'ProxyError: Connection to 192.168.1.105:8080 timed out after 15000ms\nStack: at ProxyPool.getProxy (proxy.js:45)\n  at Crawler.fetch (fetcher.js:128)\n  at TikTokCrawler.crawl (tiktok.js:89)' },
  { id: 5, time: '2026-06-16 14:22:10', taskName: '1688商品导入·家居用品', level: 'INFO', message: '商品详情页解析成功，导入商品82条', requestUrl: 'https://detail.1688.com/offer/xxxxx.html', method: 'GET', statusCode: 200, responseTime: 2800, dataCount: 82, proxyIp: '192.168.1.103:8080', errorMessage: '' },
  { id: 6, time: '2026-06-16 14:20:05', taskName: 'TikTok广告采集·全品类', level: 'INFO', message: '广告素材库爬取完成，获取最新广告120条', requestUrl: 'https://ads.tiktok.com/api/creative/search', method: 'POST', statusCode: 200, responseTime: 4500, dataCount: 120, proxyIp: '192.168.1.102:8080', errorMessage: '' },
  { id: 7, time: '2026-06-16 14:18:32', taskName: '佣商品监控·Amazon', level: 'ERROR', message: '页面结构变更，选择器匹配失败', requestUrl: 'https://www.amazon.com/dp/B0XXXXXXX', method: 'GET', statusCode: 200, responseTime: 2100, dataCount: 0, proxyIp: '192.168.1.104:8080', errorMessage: 'ParseError: Selector ".product-price" not found on page\nPossible page structure change detected\nPage hash: a1b2c3d4 (previously: e5f6g7h8)' },
  { id: 8, time: '2026-06-16 14:15:28', taskName: 'Shopify店铺搜索·宠物用品', level: 'WARNING', message: '部分店铺信息不完整，已跳过15条记录', requestUrl: 'https://xxx.myshopify.com/collections/pets', method: 'GET', statusCode: 200, responseTime: 1800, dataCount: 45, proxyIp: '192.168.1.101:8080', errorMessage: '' },
  { id: 9, time: '2026-06-16 14:12:44', taskName: 'TikTok店铺采集·东南亚', level: 'INFO', message: '店铺评分及销量数据采集完成', requestUrl: 'https://www.tiktok.com/api/shop/info?region=SEA', method: 'GET', statusCode: 200, responseTime: 5600, dataCount: 150, proxyIp: '192.168.1.102:8080', errorMessage: '' },
  { id: 10, time: '2026-06-16 14:10:01', taskName: 'TikTok达人搜索·英区', level: 'INFO', message: '英区达人搜索任务启动，使用关键词: beauty, fashion', requestUrl: 'https://www.tiktok.com/api/influencer/search?region=UK', method: 'POST', statusCode: 200, responseTime: 800, dataCount: 0, proxyIp: '192.168.1.105:8080', errorMessage: '' },
  { id: 11, time: '2026-06-16 14:05:17', taskName: 'Shopify产品采集·运动户外', level: 'WARNING', message: '反爬验证触发，已自动切换代理IP并重试成功', requestUrl: 'https://xxx.myshopify.com/products.json?limit=250', method: 'GET', statusCode: 200, responseTime: 8500, dataCount: 250, proxyIp: '192.168.1.106:8080', errorMessage: '' },
  { id: 12, time: '2026-06-16 14:02:39', taskName: '1688商品导入·数码配件', level: 'INFO', message: '数码配件品类商品导入完成，成功导入156条', requestUrl: 'https://detail.1688.com/offer/yyyyy.html', method: 'GET', statusCode: 200, responseTime: 3500, dataCount: 156, proxyIp: '192.168.1.103:8080', errorMessage: '' },
  { id: 13, time: '2026-06-16 13:58:55', taskName: 'TikTok视频采集·美妆品类', level: 'INFO', message: '视频数据及互动指标采集完成，获取180条', requestUrl: 'https://www.tiktok.com/api/video/feed?category=beauty', method: 'GET', statusCode: 200, responseTime: 4200, dataCount: 180, proxyIp: '192.168.1.102:8080', errorMessage: '' },
  { id: 14, time: '2026-06-16 13:55:20', taskName: 'TikTok广告采集·电子品类', level: 'ERROR', message: 'API认证令牌过期，需要重新登录', requestUrl: 'https://ads.tiktok.com/api/creative/search', method: 'POST', statusCode: 401, responseTime: 320, dataCount: 0, proxyIp: '192.168.1.102:8080', errorMessage: 'AuthError: Token expired at 2026-06-16T13:00:00Z\nAction: Please refresh the access token in Crawler Settings' },
  { id: 15, time: '2026-06-16 13:50:33', taskName: '佣金商品监控·全平台', level: 'INFO', message: '定时监控任务执行完成，发现5个商品佣金率变更', requestUrl: 'https://api.affiliate.com/products/monitor', method: 'POST', statusCode: 200, responseTime: 6200, dataCount: 5, proxyIp: '192.168.1.104:8080', errorMessage: '' },
])

const filteredLogs = computed(() => {
  let result = logs.value
  if (filters.value.task) {
    result = result.filter(l => l.taskName.includes(taskOptions.find(t => t.value === filters.value.task)?.label || ''))
  }
  if (filters.value.level) {
    result = result.filter(l => l.level === filters.value.level)
  }
  if (filters.value.keyword) {
    const kw = filters.value.keyword.toLowerCase()
    result = result.filter(l =>
      l.message.toLowerCase().includes(kw) ||
      l.taskName.toLowerCase().includes(kw) ||
      l.requestUrl.toLowerCase().includes(kw)
    )
  }
  return result
})

const levelTagType = (level) => {
  const map = { 'INFO': 'info', 'WARNING': 'warning', 'ERROR': 'danger', 'DEBUG': '' }
  return map[level] || 'info'
}

const fetchLogs = () => {
  loading.value = true
  setTimeout(() => { loading.value = false }, 500)
}
</script>

<style scoped>
.crawler-logs {
  padding: 24px;
  max-width: 1500px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 24px;
}

.page-title {
  font-size: 22px;
  font-weight: 700;
  color: #1a1a2e;
  margin: 0 0 4px;
}

.page-desc {
  font-size: 13px;
  color: #909399;
  margin: 0;
}

/* 统计卡片 */
.stat-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}

.stat-card {
  background: #fff;
  border-radius: 10px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 14px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.06);
  transition: transform 0.2s, box-shadow 0.2s;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #1a1a2e;
  line-height: 1;
}

.stat-label {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}

/* 筛选栏 */
.filter-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
  gap: 12px;
  flex-wrap: wrap;
}

.filter-left {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.filter-right {
  display: flex;
  align-items: center;
  gap: 8px;
}

/* 表格卡片 */
.table-card {
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.06);
  overflow: hidden;
  margin-bottom: 20px;
}

.time-text {
  font-size: 13px;
  color: #606266;
  font-family: 'SF Mono', Monaco, monospace;
}

.duration {
  font-size: 13px;
  color: #67c23a;
  font-weight: 500;
}

.duration-slow {
  color: #e6a23c;
}

.data-count {
  font-size: 13px;
  color: #409eff;
  font-weight: 500;
}

.no-data {
  color: #c0c4cc;
}

/* 展开详情 */
.log-detail {
  padding: 16px 24px;
  background: #fafbfc;
}

.detail-section {
  margin-bottom: 16px;
}

.detail-section:last-child {
  margin-bottom: 0;
}

.detail-section h5 {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
  margin: 0 0 10px;
  padding-bottom: 8px;
  border-bottom: 1px solid #ebeef5;
}

.error-title {
  color: #f56c6c !important;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px 20px;
}

.detail-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
}

.detail-label {
  color: #909399;
  flex-shrink: 0;
}

.detail-value {
  color: #303133;
}

.mono {
  font-family: 'SF Mono', Monaco, monospace;
  font-size: 12px;
  color: #606266;
}

.error-block {
  background: #fef0f0;
  color: #f56c6c;
  padding: 12px 16px;
  border-radius: 6px;
  font-size: 12px;
  font-family: 'SF Mono', Monaco, monospace;
  line-height: 1.6;
  margin: 0;
  white-space: pre-wrap;
  word-break: break-all;
}

/* 分页 */
.pagination-wrapper {
  display: flex;
  justify-content: flex-end;
}

@media (max-width: 1200px) {
  .stat-cards { grid-template-columns: repeat(2, 1fr); }
  .detail-grid { grid-template-columns: repeat(2, 1fr); }
}
</style>
