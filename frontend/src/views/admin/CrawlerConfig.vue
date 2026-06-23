<template>
  <div class="crawler-config">
    <div class="page-header">
      <h2 class="page-title">爬虫配置</h2>
      <p class="page-desc">管理爬虫任务的全局配置、代理池、请求策略与反爬规则</p>
    </div>

    <div class="config-grid">
      <!-- 代理池配置 -->
      <el-card class="config-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <div class="card-title-row">
              <el-icon :size="18" color="#667eea"><Connection /></el-icon>
              <span>代理池配置</span>
            </div>
            <el-switch v-model="config.proxy.enabled" active-text="启用" />
          </div>
        </template>
        <el-form label-width="110px" label-position="left" size="default">
          <el-form-item label="代理模式">
            <el-radio-group v-model="config.proxy.mode">
              <el-radio value="dynamic">动态代理池</el-radio>
              <el-radio value="static">静态IP代理</el-radio>
              <el-radio value="residential">住宅代理</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="代理服务器">
            <el-input v-model="config.proxy.host" placeholder="proxy.example.com" />
          </el-form-item>
          <el-form-item label="端口">
            <el-input-number v-model="config.proxy.port" :min="1" :max="65535" />
          </el-form-item>
          <el-form-item label="最大并发数">
            <el-slider v-model="config.proxy.maxConcurrency" :min="1" :max="50" show-input />
          </el-form-item>
          <el-form-item label="代理切换阈值">
            <el-input-number v-model="config.proxy.switchThreshold" :min="1" :max="20" /> 次失败后切换
          </el-form-item>
          <el-form-item label="代理超时时间">
            <el-input-number v-model="config.proxy.timeout" :min="1" :max="60" /> 秒
          </el-form-item>
        </el-form>
      </el-card>

      <!-- 请求策略 -->
      <el-card class="config-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <div class="card-title-row">
              <el-icon :size="18" color="#4facfe"><SetUp /></el-icon>
              <span>请求策略</span>
            </div>
          </div>
        </template>
        <el-form label-width="110px" label-position="left" size="default">
          <el-form-item label="默认User-Agent">
            <el-select v-model="config.request.userAgent" style="width: 100%">
              <el-option label="Chrome 126 / Windows" value="chrome_win" />
              <el-option label="Chrome 126 / Mac" value="chrome_mac" />
              <el-option label="Firefox 127 / Windows" value="firefox_win" />
              <el-option label="Safari 17 / Mac" value="safari_mac" />
              <el-option label="随机轮换" value="random" />
            </el-select>
          </el-form-item>
          <el-form-item label="请求间隔">
            <el-input-number v-model="config.request.requestInterval" :min="0.1" :max="30" :step="0.1" :precision="1" /> 秒
          </el-form-item>
          <el-form-item label="重试次数">
            <el-input-number v-model="config.request.retryCount" :min="0" :max="10" />
          </el-form-item>
          <el-form-item label="重试间隔">
            <el-input-number v-model="config.request.retryInterval" :min="1" :max="120" /> 秒
          </el-form-item>
          <el-form-item label="并发爬虫数">
            <el-slider v-model="config.request.concurrency" :min="1" :max="20" show-input />
          </el-form-item>
          <el-form-item label="启用Cookie">
            <el-switch v-model="config.request.useCookies" />
          </el-form-item>
          <el-form-item label="启用JavaScript">
            <el-switch v-model="config.request.useJavaScript" />
          </el-form-item>
        </el-form>
      </el-card>

      <!-- 反爬策略 -->
      <el-card class="config-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <div class="card-title-row">
              <el-icon :size="18" color="#f6d365"><WarningFilled /></el-icon>
              <span>反爬策略</span>
            </div>
          </div>
        </template>
        <el-form label-width="120px" label-position="left" size="default">
          <el-form-item label="自动验证码识别">
            <el-switch v-model="config.antiCrawl.autoCaptcha" />
          </el-form-item>
          <el-form-item label="验证码服务">
            <el-select v-model="config.antiCrawl.captchaService" :disabled="!config.antiCrawl.autoCaptcha" style="width: 100%">
              <el-option label="2Captcha" value="2captcha" />
              <el-option label="Anti-Captcha" value="anticaptcha" />
              <el-option label="CapSolver" value="capsolver" />
            </el-select>
          </el-form-item>
          <el-form-item label="API Key">
            <el-input v-model="config.antiCrawl.captchaApiKey" :disabled="!config.antiCrawl.autoCaptcha" type="password" show-password placeholder="输入验证码服务API Key" />
          </el-form-item>
          <el-divider />
          <el-form-item label="自动切换代理">
            <el-switch v-model="config.antiCrawl.autoSwitchProxy" />
          </el-form-item>
          <el-form-item label="Referer伪装">
            <el-switch v-model="config.antiCrawl.refererSpoof" />
          </el-form-item>
          <el-form-item label="请求头随机化">
            <el-switch v-model="config.antiCrawl.headerRandomize" />
          </el-form-item>
          <el-form-item label="限流自动降速">
            <el-switch v-model="config.antiCrawl.autoThrottle" />
          </el-form-item>
          <el-form-item label="Cloudflare绕过">
            <el-switch v-model="config.antiCrawl.cloudflareBypass" />
          </el-form-item>
        </el-form>
      </el-card>

      <!-- 存储与通知 -->
      <el-card class="config-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <div class="card-title-row">
              <el-icon :size="18" color="#43e97b"><Bell /></el-icon>
              <span>存储与通知</span>
            </div>
          </div>
        </template>
        <el-form label-width="110px" label-position="left" size="default">
          <el-form-item label="日志保留天数">
            <el-input-number v-model="config.storage.logRetentionDays" :min="1" :max="365" /> 天
          </el-form-item>
          <el-form-item label="数据存储路径">
            <el-input v-model="config.storage.dataPath" placeholder="/data/crawler" />
          </el-form-item>
          <el-form-item label="自动清理">
            <el-switch v-model="config.storage.autoCleanup" />
          </el-form-item>
          <el-divider />
          <el-form-item label="错误通知">
            <el-switch v-model="config.notification.errorAlert" />
          </el-form-item>
          <el-form-item label="通知方式">
            <el-checkbox-group v-model="config.notification.channels" :disabled="!config.notification.errorAlert">
              <el-checkbox label="email" value="email">邮件</el-checkbox>
              <el-checkbox label="webhook" value="webhook">Webhook</el-checkbox>
              <el-checkbox label="sms" value="sms">短信</el-checkbox>
            </el-checkbox-group>
          </el-form-item>
          <el-form-item label="Webhook URL" v-if="config.notification.channels.includes('webhook')">
            <el-input v-model="config.notification.webhookUrl" placeholder="https://hooks.example.com/crawler-alert" />
          </el-form-item>
          <el-form-item label="通知邮箱" v-if="config.notification.channels.includes('email')">
            <el-input v-model="config.notification.email" placeholder="admin@example.com" />
          </el-form-item>
          <el-form-item label="每日汇总报告">
            <el-switch v-model="config.notification.dailyReport" />
          </el-form-item>
        </el-form>
      </el-card>

      <!-- IP黑名单 -->
      <el-card class="config-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <div class="card-title-row">
              <el-icon :size="18" color="#f5576c"><Remove /></el-icon>
              <span>IP黑名单</span>
            </div>
            <el-button type="primary" size="small" :icon="Plus" @click="showAddBlacklist = true">添加</el-button>
          </div>
        </template>
        <div class="blacklist-content">
          <el-table :data="config.blacklist" size="small" max-height="280">
            <el-table-column prop="ip" label="IP地址" />
            <el-table-column prop="reason" label="拉黑原因" show-overflow-tooltip />
            <el-table-column prop="time" label="添加时间" width="140" />
            <el-table-column label="操作" width="70" align="center">
              <template #default="{ $index }">
                <el-button type="danger" link size="small" @click="removeBlacklist($index)">移除</el-button>
              </template>
            </el-table-column>
          </el-table>
          <el-empty v-if="config.blacklist.length === 0" description="暂无黑名单IP" :image-size="60" />
        </div>
      </el-card>

      <!-- Cookie池 -->
      <el-card class="config-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <div class="card-title-row">
              <el-icon :size="18" color="#e6a23c"><Key /></el-icon>
              <span>Cookie池</span>
            </div>
            <el-button type="primary" size="small" :icon="Plus" @click="showAddCookie = true">添加</el-button>
          </div>
        </template>
        <div class="cookie-content">
          <div class="cookie-item" v-for="(cookie, idx) in config.cookies" :key="idx">
            <div class="cookie-info">
              <span class="cookie-platform">
                <el-tag size="small" type="primary">{{ cookie.platform }}</el-tag>
              </span>
              <span class="cookie-account">{{ cookie.account }}</span>
              <span class="cookie-status">
                <el-tag size="small" :type="cookie.valid ? 'success' : 'danger'">{{ cookie.valid ? '有效' : '过期' }}</el-tag>
              </span>
            </div>
            <div class="cookie-actions">
              <span class="cookie-expire">过期: {{ cookie.expireTime }}</span>
              <el-button type="danger" link size="small" :icon="Delete" @click="removeCookie(idx)" />
            </div>
          </div>
          <el-empty v-if="config.cookies.length === 0" description="暂无Cookie记录" :image-size="60" />
        </div>
      </el-card>
    </div>

    <!-- 底部操作 -->
    <div class="config-footer">
      <el-button @click="resetConfig">恢复默认</el-button>
      <el-button type="primary" @click="saveConfig" :loading="saving">保存配置</el-button>
    </div>

    <!-- 添加黑名单弹窗 -->
    <el-dialog v-model="showAddBlacklist" title="添加黑名单IP" width="400px">
      <el-form label-width="80px" size="default">
        <el-form-item label="IP地址">
          <el-input v-model="newBlacklist.ip" placeholder="192.168.1.1" />
        </el-form-item>
        <el-form-item label="拉黑原因">
          <el-input v-model="newBlacklist.reason" placeholder="如：频繁403、恶意请求" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddBlacklist = false">取消</el-button>
        <el-button type="primary" @click="addBlacklist">确认添加</el-button>
      </template>
    </el-dialog>

    <!-- 添加Cookie弹窗 -->
    <el-dialog v-model="showAddCookie" title="添加Cookie" width="450px">
      <el-form label-width="80px" size="default">
        <el-form-item label="平台">
          <el-select v-model="newCookie.platform" style="width: 100%">
            <el-option label="Shopify" value="Shopify" />
            <el-option label="TikTok" value="TikTok" />
            <el-option label="1688" value="1688" />
            <el-option label="Amazon" value="Amazon" />
          </el-select>
        </el-form-item>
        <el-form-item label="账号">
          <el-input v-model="newCookie.account" placeholder="account@example.com" />
        </el-form-item>
        <el-form-item label="Cookie值">
          <el-input v-model="newCookie.value" type="textarea" :rows="3" placeholder="粘贴Cookie字符串" />
        </el-form-item>
        <el-form-item label="过期时间">
          <el-date-picker v-model="newCookie.expireTime" type="datetime" placeholder="选择过期时间" style="width: 100%" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddCookie = false">取消</el-button>
        <el-button type="primary" @click="addCookie">确认添加</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import {
  Connection,
  SetUp,
  WarningFilled,
  Bell,
  Remove,
  Key,
  Plus,
  Delete
} from '@element-plus/icons-vue'

const saving = ref(false)
const showAddBlacklist = ref(false)
const showAddCookie = ref(false)

const config = reactive({
  proxy: {
    enabled: true,
    mode: 'dynamic',
    host: 'proxy-pool.internal.com',
    port: 8080,
    maxConcurrency: 10,
    switchThreshold: 5,
    timeout: 15,
  },
  request: {
    userAgent: 'chrome_win',
    requestInterval: 2.0,
    retryCount: 3,
    retryInterval: 10,
    concurrency: 5,
    useCookies: true,
    useJavaScript: false,
  },
  antiCrawl: {
    autoCaptcha: true,
    captchaService: '2captcha',
    captchaApiKey: 'sk-xxxxxxxxxxxxxxxx',
    autoSwitchProxy: true,
    refererSpoof: true,
    headerRandomize: true,
    autoThrottle: true,
    cloudflareBypass: false,
  },
  storage: {
    logRetentionDays: 30,
    dataPath: '/data/crawler',
    autoCleanup: true,
  },
  notification: {
    errorAlert: true,
    channels: ['email', 'webhook'],
    webhookUrl: 'https://hooks.slack.com/services/xxx/yyy/zzz',
    email: 'devops@example.com',
    dailyReport: true,
  },
  blacklist: [
    { ip: '203.0.113.45', reason: '连续返回403，疑似封IP', time: '2026-06-15' },
    { ip: '198.51.100.23', reason: '请求频率过高被限流', time: '2026-06-14' },
    { ip: '192.0.2.88', reason: '返回虚假数据，已确认', time: '2026-06-12' },
  ],
  cookies: [
    { platform: 'Shopify', account: 'buyer01@example.com', valid: true, expireTime: '2026-07-15' },
    { platform: 'TikTok', account: 'creator_asia@example.com', valid: true, expireTime: '2026-07-01' },
    { platform: '1688', account: 'importer@example.com', valid: false, expireTime: '2026-06-01' },
    { platform: 'Amazon', account: 'marketplace@example.com', valid: true, expireTime: '2026-08-20' },
  ],
})

const newBlacklist = reactive({ ip: '', reason: '' })
const newCookie = reactive({
  platform: '',
  account: '',
  value: '',
  expireTime: null,
})

const addBlacklist = () => {
  if (newBlacklist.ip) {
    config.blacklist.unshift({
      ip: newBlacklist.ip,
      reason: newBlacklist.reason || '手动添加',
      time: new Date().toISOString().slice(0, 10),
    })
    newBlacklist.ip = ''
    newBlacklist.reason = ''
    showAddBlacklist.value = false
  }
}

const removeBlacklist = (index) => {
  config.blacklist.splice(index, 1)
}

const addCookie = () => {
  if (newCookie.platform && newCookie.account) {
    config.cookies.unshift({
      platform: newCookie.platform,
      account: newCookie.account,
      valid: true,
      expireTime: newCookie.expireTime ? new Date(newCookie.expireTime).toISOString().slice(0, 10) : '2026-07-16',
    })
    Object.assign(newCookie, { platform: '', account: '', value: '', expireTime: null })
    showAddCookie.value = false
  }
}

const removeCookie = (index) => {
  config.cookies.splice(index, 1)
}

const saveConfig = () => {
  saving.value = true
  setTimeout(() => {
    saving.value = false
    ElMessage.success('爬虫配置保存成功')
  }, 800)
}

const resetConfig = () => {
  console.log('恢复默认配置')
}
</script>

<style scoped>
.crawler-config {
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

/* 配置网格 */
.config-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  margin-bottom: 24px;
}

.config-card {
  border-radius: 10px;
}

.config-card :deep(.el-card__header) {
  padding: 16px 20px;
  border-bottom: 1px solid #ebeef5;
}

.config-card :deep(.el-card__body) {
  padding: 20px;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.card-title-row {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
  font-weight: 600;
  color: #303133;
}

/* 黑名单 */
.blacklist-content {
  min-height: 120px;
}

/* Cookie池 */
.cookie-content {
  min-height: 120px;
}

.cookie-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 0;
  border-bottom: 1px solid #f2f3f5;
}

.cookie-item:last-child {
  border-bottom: none;
}

.cookie-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.cookie-account {
  font-size: 13px;
  color: #303133;
}

.cookie-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.cookie-expire {
  font-size: 12px;
  color: #909399;
}

/* 底部 */
.config-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 20px;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.06);
}

@media (max-width: 1200px) {
  .config-grid {
    grid-template-columns: 1fr;
  }
}
</style>
