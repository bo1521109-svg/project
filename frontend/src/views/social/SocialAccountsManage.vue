<template>
  <div class="page-container">
    <div class="page-header">
      <h2>🔗 智能账号管理</h2>
      <div class="ph-right">
        <el-input v-model="search" placeholder="搜索账号..." size="default" style="width:200px" clearable />
        <el-button type="primary" @click="showAdd=true">+ 绑定新账号</el-button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stat-row">
      <div v-for="s in stats" :key="s.label" class="stat-card">
        <span class="sc-num">{{ s.num }}</span>
        <span class="sc-label">{{ s.label }}</span>
      </div>
    </div>

    <!-- 账号卡片网格 -->
    <div class="account-grid">
      <div v-for="a in filteredAccounts" :key="a.id" class="account-card" :class="{ offline: a.status==='error' }">
        <!-- 头部 -->
        <div class="ac-header">
          <div class="ach-left">
            <svg class="ach-icon" viewBox="0 0 40 40" v-html="a.svg"></svg>
            <div>
              <div class="ach-name">{{ a.name }}</div>
              <div class="ach-account">{{ a.account }}</div>
            </div>
          </div>
          <div class="ach-status" :class="a.status">
            <span class="acs-dot"></span>
            {{ statusMap[a.status] }}
          </div>
        </div>
        <!-- 数据 -->
        <div class="ac-stats">
          <div class="acs-item">
            <span class="acsi-val">{{ a.followers }}</span>
            <span class="acsi-label">粉丝/好友</span>
          </div>
          <div class="acs-item">
            <span class="acsi-val">{{ a.thisMonth }}</span>
            <span class="acsi-label">本月内容</span>
          </div>
          <div class="acs-item">
            <span class="acsi-val">{{ a.avgEng }}</span>
            <span class="acsi-label">平均互动</span>
          </div>
          <div class="acs-item">
            <span class="acsi-val">{{ a.lastActive }}</span>
            <span class="acsi-label">最后活跃</span>
          </div>
        </div>
        <!-- 标签 -->
        <div class="ac-tags" v-if="a.tags">
          <el-tag v-for="t in a.tags" :key="t" size="small" type="info">{{ t }}</el-tag>
        </div>
        <!-- 操作 -->
        <div class="ac-actions">
          <el-button size="small" plain>数据详情</el-button>
          <el-button v-if="a.status==='connected'" size="small" type="primary" @click="refreshToken(a)">刷新Token</el-button>
          <el-button v-if="a.status==='error'" size="small" type="warning" @click="reconnect(a)">重新授权</el-button>
          <el-button size="small" type="danger" plain @click="delAccount(a)">解绑</el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const search = ref('')
const showAdd = ref(false)
const statusMap = { connected: '已连接', expired: '已过期', error: '异常' }

const stats = [
  { num: 9, label: '已绑定账号' },
  { num: '168.5万', label: '跨平台总粉丝' },
  { num: 7, label: '正常运行' },
  { num: 2, label: '需处理' }
]

const accounts = ref([
  {
    id: 1, name: 'TikTok', account: '@brand_official', status: 'connected',
    svg: '<circle cx="20" cy="20" r="18" fill="#000"/><path d="M22 12c.5 4.5 3 7 7.3 7.3v4.8c-1.3.2-2.7.3-4 .3-3.7 0-6-2.3-6-5.8V16h-3.3v-4h3.3V8.5c0-2.8 1.7-4.3 4.3-4.3 1 0 2 .2 3 .3V9c-.5-.1-1.2-.2-1.8-.2-1.7 0-2.5 1-2.5 3V12h4Z" fill="#00f2ea"/><circle cx="29.3" cy="19.3" r="3" fill="#ff0050"/>',
    followers: '52.1万', thisMonth: '45', avgEng: '6.8%', lastActive: '2小时前',
    account: '@brand_official_tiktok', tags: ['企业号','蓝V']
  },
  {
    id: 2, name: 'Instagram', account: '@brand_ig', status: 'connected',
    svg: '<circle cx="20" cy="20" r="18" fill="url(#ig)"/><defs><linearGradient id="ig" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stop-color="#f09433"/><stop offset="25%" stop-color="#e6683c"/><stop offset="50%" stop-color="#dc2743"/><stop offset="75%" stop-color="#cc2366"/><stop offset="100%" stop-color="#bc1888"/></linearGradient></defs><rect x="11" y="11" width="18" height="18" rx="5" fill="none" stroke="#fff" stroke-width="1.8"/><circle cx="20" cy="20" r="4.5" fill="none" stroke="#fff" stroke-width="1.8"/><circle cx="25.3" cy="14.7" r="1" fill="#fff"/>',
    followers: '28.5万', thisMonth: '32', avgEng: '5.2%', lastActive: '5小时前',
    account: '@brand_instagram', tags: ['企业号','购物功能']
  },
  {
    id: 3, name: 'Facebook', account: '@BrandPage', status: 'connected',
    svg: '<circle cx="20" cy="20" r="18" fill="#1877f2"/><path d="M25.5 26.3v-6.3h2l.4-2.8h-2.4v-1.8c0-.8.2-1.4 1.4-1.4h1.5V11.5c-.3 0-1.2-.1-2.3-.1-2.2 0-3.7 1.3-3.7 3.8v2.1h-2.5v2.8h2.5v6.3h3.1Z" fill="#fff"/>',
    followers: '35.6万', thisMonth: '28', avgEng: '3.2%', lastActive: '1小时前',
    account: '/BrandPage', tags: ['主页','广告账号']
  },
  {
    id: 4, name: 'YouTube', account: '@BrandChannel', status: 'connected',
    svg: '<rect x="4" y="9" width="32" height="22" rx="4" fill="#ff0000"/><path d="M17.5 18.5v-5l5 2.5-5 2.5Z" fill="#fff"/>',
    followers: '68.5万', thisMonth: '18', avgEng: '8.5%', lastActive: '昨天',
    account: '/BrandChannel', tags: ['品牌频道','合作']
  },
  {
    id: 5, name: 'Twitter/X', account: '@brand_x', status: 'connected',
    svg: '<circle cx="20" cy="20" r="18" fill="#15202b"/><path d="M27.6 10h2.2l-4.8 5.5 5.7 7.5h-4.5l-3.5-4.6-4 4.6H16.5l5.2-6-5.5-7h4.6l3.2 4.2 3.6-4.2Zm-.8 11.7h1.2L16.7 11.2h-1.4l11.5 10.5Z" fill="#fff"/>',
    followers: '12.8万', thisMonth: '56', avgEng: '4.1%', lastActive: '3小时前',
    account: '@brand_official_x', tags: ['品牌号']
  },
  {
    id: 6, name: 'Pinterest', account: '@brand_pin', status: 'connected',
    svg: '<circle cx="20" cy="20" r="18" fill="#e60023"/><path d="M20 10c-5.5 0-10 4.5-10 10 0 4.2 2.6 7.8 6.3 9.2-.1-.7-.2-1.9 0-2.7l1-4.2s-.2-.5-.2-1.3c0-1.3.7-2.2 1.7-2.2.8 0 1.2.6 1.2 1.3 0 .8-.5 2-.8 3.1-.2.9.5 1.7 1.4 1.7 1.7 0 2.8-2.2 2.8-4.8 0-1.9-1.3-3.4-3.8-3.4-2.8 0-4.5 2.1-4.5 4.4 0 .8.2 1.3.6 1.7.2.2.2.3.1.5l-.2.7c0 .2-.2.2-.4.2-1.5-.6-2.2-2.2-2.2-4 0-3 2.5-6.6 7.5-6.6 4 0 6.6 2.9 6.6 6 0 4.1-2.3 7.2-5.7 7.2-1.1 0-2.2-.6-2.5-1.3l-.7 2.8c-.2.9-.7 1.8-1.2 2.5 1 .3 2 .5 3.1.5 5.5 0 10-4.5 10-10s-4.5-10-10-10Z" fill="#fff"/>',
    followers: '3.8万', thisMonth: '24', avgEng: '2.8%', lastActive: '1天前',
    account: '/brand_pinterest', tags: ['商业账号']
  },
  {
    id: 7, name: 'Reddit', account: 'u/brand_reddit', status: 'connected',
    svg: '<circle cx="20" cy="20" r="18" fill="#ff4500"/><circle cx="20" cy="18" r="3" fill="#fff"/><ellipse cx="13" cy="17" rx="2" ry="1.8" fill="#fff"/><ellipse cx="27" cy="17" rx="2" ry="1.8" fill="#fff"/><path d="M14.5 23.5c1.5 2 4 2.5 5.5 2.5s4-.5 5.5-2.5" fill="none" stroke="#fff" stroke-width="1.5" stroke-linecap="round"/>',
    followers: '2.5万', thisMonth: '38', avgEng: '5.6%', lastActive: '6小时前',
    account: 'u/brand_official', tags: ['品牌号']
  },
  {
    id: 8, name: 'Line', account: 'brand_line', status: 'expired',
    svg: '<circle cx="20" cy="20" r="18" fill="#06c755"/><text x="20" y="26" text-anchor="middle" fill="#fff" font-size="14" font-weight="800" font-family="Arial">LINE</text>',
    followers: '1.2万', thisMonth: '0', avgEng: '--', lastActive: '3天前',
    account: '@brand_line', tags: ['企业号']
  },
  {
    id: 9, name: 'WhatsApp', account: '+8613800138000', status: 'error',
    svg: '<circle cx="20" cy="20" r="18" fill="#25d366"/><path d="M20 8c-6.3 0-11.4 5.1-11.4 11.4 0 2.2.6 4.3 1.8 6.1L8 32l6.8-2.2c1.6 1 3.4 1.5 5.2 1.5 6.3 0 11.4-5.1 11.4-11.4S26.3 8 20 8Z" fill="#fff"/><path d="M25.8 22.6c-.3-.1-1.7-.8-1.9-.9-.3-.1-.5-.1-.6.1-.2.3-.7.9-.9 1.1-.2.2-.3.2-.6.1-.3-.1-1.2-.4-2.3-1.4-.8-.8-1.4-1.7-1.6-2-.2-.3 0-.4.1-.6.1-.1.3-.3.4-.5.1-.2.2-.3.3-.5.1-.2 0-.4 0-.5-.1-.2-.6-1.5-.9-2.1-.2-.6-.5-.5-.6-.5h-.6c-.2 0-.5.1-.7.4-.3.3-1 1-1 2.4s1 2.8 1.2 3c.1.2 2 3.1 4.9 4.3.7.3 1.2.5 1.6.6.7.2 1.3.2 1.8.1.5-.1 1.7-.7 1.9-1.4.2-.7.2-1.2.2-1.4-.1-.1-.3-.2-.5-.3Z" fill="#25d366"/>',
    followers: '0.8万', thisMonth: '--', avgEng: '--', lastActive: '6天前',
    account: '13800138000', tags: ['Business API']
  }
])

const filteredAccounts = computed(() => {
  if (!search.value) return accounts.value
  const kw = search.value.toLowerCase()
  return accounts.value.filter(a => a.name.toLowerCase().includes(kw) || a.account.toLowerCase().includes(kw))
})

function refreshToken(acc) {
  ElMessage.success(`${acc.name} Token 已刷新，有效期延至 60 天后`)
}
function reconnect(acc) {
  acc.status = 'connected'
  ElMessage.success(`${acc.name} 已重新授权连接`)
}
function delAccount(acc) {
  ElMessage.warning(`模拟：${acc.name} 解绑请求已提交`)
}
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
.page-header h2 { font-size: 22px; font-weight: 800; color: #1a1a1a; margin: 0; }
.ph-right { display: flex; align-items: center; gap: 12px; }

.stat-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 20px; }
.stat-card { background: #fff; border-radius: 14px; padding: 12px 18px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); text-align: center; }
.sc-num { font-size: 24px; font-weight: 800; color: #1a1a1a; display: block; }
.sc-label { font-size: 12px; color: #999; margin-top: 3px; display: block; }

.account-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 16px; }
.account-card { background: #fff; border-radius: 14px; padding: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); display: flex; flex-direction: column; gap: 14px; transition: all 0.2s; }
.account-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.06); }
.account-card.offline { opacity: 0.65; }

.ac-header { display: flex; align-items: center; justify-content: space-between; }
.ach-left { display: flex; align-items: center; gap: 10px; }
.ach-icon { width: 38px; height: 38px; flex-shrink: 0; }
.ach-name { font-size: 15px; font-weight: 700; color: #1a1a1a; }
.ach-account { font-size: 11px; color: #aaa; margin-top: 2px; }

.ach-status { font-size: 11px; font-weight: 600; display: flex; align-items: center; gap: 5px; padding: 3px 10px; border-radius: 10px; }
.ach-status.connected { background: #e8f5e9; color: #2e7d32; }
.ach-status.expired { background: #fff8e1; color: #f57f17; }
.ach-status.error { background: #fce4ec; color: #c62828; }
.acs-dot { width: 6px; height: 6px; border-radius: 50%; display: inline-block; }
.connected .acs-dot { background: #4caf50; }
.expired .acs-dot { background: #ff9800; }
.error .acs-dot { background: #f44336; }

.ac-stats { display: grid; grid-template-columns: repeat(4,1fr); gap: 4px; background: #fafafa; border-radius: 10px; padding: 12px 10px; }
.acs-item { text-align: center; }
.acsi-val { font-size: 15px; font-weight: 700; color: #1a1a1a; display: block; }
.acsi-label { font-size: 10px; color: #aaa; margin-top: 2px; display: block; }

.ac-tags { display: flex; gap: 6px; flex-wrap: wrap; }
.ac-actions { display: flex; gap: 6px; padding-top: 4px; border-top: 1px solid #f5f5f5; }
</style>

