<template>
  <div class="page-container">
    <div class="page-header">
      <h2>📤 发布管理</h2>
      <div class="ph-right">
        <el-radio-group v-model="viewTab" size="small">
          <el-radio-button value="scheduled">预约中</el-radio-button>
          <el-radio-button value="draft">草稿箱</el-radio-button>
          <el-radio-button value="published">已发布</el-radio-button>
        </el-radio-group>
        <el-button type="primary" @click="showCreate=true">+ 新建发布</el-button>
      </div>
    </div>

    <!-- 统计行 -->
    <div class="stat-row">
      <div v-for="s in stats" :key="s.label" class="stat-card">
        <div class="sc-val">{{ s.num }}</div>
        <div class="sc-label">{{ s.label }}</div>
      </div>
    </div>

    <!-- 内容列表 -->
    <div class="section" v-if="viewTab==='scheduled'">
      <div class="section-header">📅 预约发布内容 ({{scheduled.length}})</div>
      <div class="post-list">
        <div v-for="p in scheduled" :key="p.id" class="pl-item">
          <div class="pl-platforms">
            <span v-for="pf in p.platforms" :key="pf" class="pl-pf" :class="pf">{{ pf }}</span>
          </div>
          <div class="pl-body">
            <div class="pl-title">{{ p.title }}</div>
            <div class="pl-desc">{{ p.desc }}</div>
            <div class="pl-tags"><span v-for="t in p.tags" :key="t" class="pl-tag">{{ t }}</span></div>
          </div>
          <div class="pl-time">
            <div class="plt-date">{{ p.date }}</div>
            <div class="plt-clock">{{ p.clock }}</div>
          </div>
          <div class="pl-actions">
            <el-button size="small" @click="delScheduled(p.id)" type="danger" link>取消</el-button>
            <el-button size="small" type="primary" link>编辑</el-button>
          </div>
        </div>
      </div>
    </div>

    <div class="section" v-if="viewTab==='draft'">
      <div class="section-header">📝 草稿箱 ({{drafts.length}})</div>
      <div class="draft-grid">
        <div v-for="d in drafts" :key="d.id" class="draft-card">
          <div class="dc-header">
            <span class="dc-cat" :style="{ background: d.catColor }">{{ d.category }}</span>
            <span class="dc-date">{{ d.updated }}</span>
          </div>
          <div class="dc-body">
            <div class="dc-title">{{ d.title }}</div>
            <div class="dc-text">{{ d.text }}</div>
          </div>
          <div class="dc-footer">
            <div class="dc-platforms">
              <span v-for="pf in d.platforms" :key="pf" class="dc-pf-tag">{{ pf }}</span>
            </div>
            <div class="dc-actions">
              <el-button size="small" type="primary" link>编辑</el-button>
              <el-button size="small" type="primary" link>发布</el-button>
              <el-button size="small" type="danger" link>删除</el-button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="section" v-if="viewTab==='published'">
      <div class="section-header">✅ 已发布内容 ({{published.length}})</div>
      <div class="table-wrap">
        <table>
          <thead><tr><th>平台</th><th>内容标题</th><th style="text-align:right">发布时间</th><th style="text-align:right">播放/触达</th><th style="text-align:right">互动</th><th style="text-align:right">互动率</th></tr></thead>
          <tbody>
            <tr v-for="p in published" :key="p.id">
              <td><span class="pub-pf" :class="p.platform">{{ p.platform }}</span></td>
              <td>{{ p.title }}</td>
              <td class="num">{{ p.time }}</td>
              <td class="num">{{ p.reach }}</td>
              <td class="num">{{ p.engagement }}</td>
              <td class="num"><span class="erate" :class="p.rateUp ? 'e-up' : 'e-down'">{{ p.rate }}</span></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 新建发布弹窗 -->
    <el-dialog v-model="showCreate" title="新建发布" width="620px" destroy-on-close>
      <div class="create-form">
        <div class="cf-row"><span class="cf-label">选择平台</span>
          <el-checkbox-group v-model="newPost.platforms">
            <el-checkbox v-for="pf in allPlatforms" :key="pf.value" :value="pf.value" :label="pf.label" />
          </el-checkbox-group>
        </div>
        <div class="cf-row"><span class="cf-label">内容标题</span><el-input v-model="newPost.title" placeholder="输入标题" /></div>
        <div class="cf-row"><span class="cf-label">内容描述</span><el-input v-model="newPost.desc" type="textarea" :rows="3" placeholder="输入描述文案..." /></div>
        <div class="cf-row"><span class="cf-label">标签</span><el-input v-model="newPost.tags" placeholder="逗号分隔，如：新品,夏季,促销" /></div>
        <div class="cf-row"><span class="cf-label">发布时间</span>
          <el-date-picker v-model="newPost.time" type="datetime" placeholder="选择日期时间" style="width:100%" />
        </div>
      </div>
      <template #footer>
        <el-button @click="showCreate=false">取消</el-button>
        <el-button @click="saveAsDraft" type="default">存草稿</el-button>
        <el-button @click="addScheduled" type="primary">预约发布</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref } from 'vue'
const viewTab = ref('scheduled')
const showCreate = ref(false)
const allPlatforms = [
  { value: 'tiktok', label: 'TikTok' },
  { value: 'youtube', label: 'YouTube' },
  { value: 'instagram', label: 'Instagram' },
  { value: 'facebook', label: 'Facebook' },
  { value: 'twitter', label: 'Twitter/X' },
  { value: 'pinterest', label: 'Pinterest' },
  { value: 'reddit', label: 'Reddit' }
]

const stats = [
  { num: 12, label: '预约中' },
  { num: 8, label: '草稿箱' },
  { num: 186, label: '已发布(本月)' },
  { num: '92.8%', label: '准时率' }
]

const scheduled = ref([
  { id: 1, platforms: ['tiktok','instagram'], title: '新品发布会精彩集锦', desc: '春季新品发布会现场实拍，3分钟精华剪辑版...', tags: ['新品发布','春季'], date: '6月8日', clock: '18:00' },
  { id: 2, platforms: ['youtube'], title: 'Complete Product Tutorial 2026', desc: 'Step-by-step guide for new users. Everything you need to know...', tags: ['教程'], date: '6月9日', clock: '10:00' },
  { id: 3, platforms: ['facebook','twitter','reddit'], title: '限时促销活动倒计时', desc: '最后48小时！全场8折优惠，错过等下次...', tags: ['促销','限时'], date: '6月10日', clock: '09:00' },
  { id: 4, platforms: ['twitter'], title: '行业趋势分析报告发布', desc: '最新跨境电商趋势报告出炉，5大关键洞察...', tags: ['行业报告'], date: '6月12日', clock: '14:00' }
])

const drafts = [
  { id: 1, category: '教程', catColor: '#e3f2fd', title: '5分钟学会使用XX产品', text: '从开箱到上手，完整操作指南...', platforms: ['TikTok','YouTube'], updated: '2天前' },
  { id: 2, category: '种草', catColor: '#fce4ec', title: '黄皮逆袭冷白皮，这款防晒真的绝', text: '实测一个月，效果惊人...', platforms: ['TikTok','Instagram'], updated: '3天前' },
  { id: 3, category: '测评', catColor: '#fff3e0', title: '同价位10款耳机横评', text: '音质、降噪、续航全面对比...', platforms: ['YouTube'], updated: '5天前' },
  { id: 4, category: '活动', catColor: '#f3e5f5', title: '夏日狂欢节活动预告', text: '全场低至5折，还有抽奖活动...', platforms: ['Facebook','Twitter'], updated: '1周前' },
  { id: 5, category: '日常', catColor: '#e8f5e9', title: '工作室日常Vlog', text: '带大家看看我们的一天...', platforms: ['TikTok','Instagram'], updated: '1周前' },
  { id: 6, category: '教程', catColor: '#e3f2fd', title: '跨境电商选品避坑指南', text: '6个新手常犯的错误和解决方案...', platforms: ['Reddit','Twitter'], updated: '2周前' }
]

const published = [
  { id: 1, platform: 'tiktok', title: '产品开箱挑战 | 不到$10的护肤神器', time: '6月5日 14:30', reach: '256万', engagement: '18.2万', rate: '7.1%', rateUp: true },
  { id: 2, platform: 'youtube', title: 'Ultimate Product Unboxing 2026', time: '6月5日 10:00', reach: '186万', engagement: '8.2万', rate: '4.4%', rateUp: true },
  { id: 3, platform: 'instagram', title: '3秒变装挑战第5弹', time: '6月4日 18:30', reach: '18万', engagement: '3.2万', rate: '17.8%', rateUp: true },
  { id: 4, platform: 'facebook', title: '限时优惠 | 全场满$50减$10', time: '6月4日 09:00', reach: '45万', engagement: '2.3万', rate: '5.1%', rateUp: true },
  { id: 5, platform: 'twitter', title: 'Customer satisfaction is our #1 priority', time: '6月3日 16:00', reach: '25万', engagement: '1.8万', rate: '7.2%', rateUp: true },
  { id: 6, platform: 'pinterest', title: '10 Must-Have Spring Outfits 2026', time: '6月3日 11:00', reach: '28万', engagement: '4.5万', rate: '16.1%', rateUp: true },
  { id: 7, platform: 'reddit', title: 'How I grew my Shopify store to $50K/month', time: '6月2日 09:30', reach: '18万', engagement: '2.8K', rate: '1.6%', rateUp: false }
]

const newPost = ref({
  platforms: [],
  title: '',
  desc: '',
  tags: '',
  time: null
})

function addScheduled() {
  if (!newPost.value.title) return
  scheduled.value.push({
    id: Date.now(),
    platforms: newPost.value.platforms,
    title: newPost.value.title,
    desc: newPost.value.desc,
    tags: newPost.value.tags ? newPost.value.tags.split(',') : [],
    date: newPost.value.time ? new Date(newPost.value.time).toLocaleDateString('zh-CN', { month:'long', day:'numeric' }) : '待定',
    clock: newPost.value.time ? new Date(newPost.value.time).toLocaleTimeString('zh-CN', { hour:'2-digit', minute:'2-digit' }) : '--:--'
  })
  showCreate.value = false
  newPost.value = { platforms:[], title:'', desc:'', tags:'', time:null }
}

function saveAsDraft() {
  if (!newPost.value.title) return
  drafts.unshift({
    id: Date.now(),
    category: '其他',
    catColor: '#f0f0f0',
    title: newPost.value.title,
    text: newPost.value.desc || '暂无描述',
    platforms: newPost.value.platforms.map(p => allPlatforms.find(x=>x.value===p)?.label || p),
    updated: '刚刚'
  })
  showCreate.value = false
  newPost.value = { platforms:[], title:'', desc:'', tags:'', time:null }
}

function delScheduled(id) {
  const idx = scheduled.value.findIndex(p => p.id === id)
  if (idx > -1) scheduled.value.splice(idx, 1)
}
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
.page-header h2 { font-size: 22px; font-weight: 800; color: #1a1a1a; margin: 0; }
.ph-right { display: flex; align-items: center; gap: 14px; }

.stat-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 20px; }
.stat-card { background: #fff; border-radius: 14px; padding: 12px 18px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); text-align: center; }
.sc-val { font-size: 24px; font-weight: 800; color: #1a1a1a; }
.sc-label { font-size: 12px; color: #999; margin-top: 3px; }

.section { background: #fff; border-radius: 14px; padding: 20px; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); }
.section-header { font-size: 16px; font-weight: 700; color: #1a1a1a; margin-bottom: 16px; }

.post-list { display: flex; flex-direction: column; }
.pl-item { display: flex; align-items: center; gap: 14px; padding: 16px 0; border-bottom: 1px solid #f5f5f5; }
.pl-item:last-child { border-bottom: none; }
.pl-platforms { display: flex; gap: 4px; flex-shrink: 0; }
.pl-pf { font-size: 9px; padding: 3px 8px; border-radius: 10px; font-weight: 700; text-transform: uppercase; color: #fff; }
.pl-pf.tiktok { background: #ff0050; }
.pl-pf.youtube { background: #ff0000; }
.pl-pf.instagram { background: #e1306c; }
.pl-pf.facebook { background: #1877f2; }
.pl-pf.twitter { background: #1d9bf0; }
.pl-pf.reddit { background: #ff4500; }
.pl-body { flex: 1; min-width: 0; }
.pl-title { font-size: 14px; font-weight: 600; color: #1a1a1a; margin-bottom: 4px; }
.pl-desc { font-size: 12px; color: #888; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-bottom: 6px; }
.pl-tags { display: flex; gap: 6px; }
.pl-tag { font-size: 10px; padding: 2px 8px; background: #f0f0f0; color: #888; border-radius: 4px; }
.pl-time { text-align: center; flex-shrink: 0; }
.plt-date { font-size: 13px; font-weight: 600; color: #333; }
.plt-clock { font-size: 12px; color: #1d9bf0; font-weight: 600; }
.pl-actions { flex-shrink: 0; display: flex; flex-direction: column; gap: 2px; }

.draft-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 14px; }
.draft-card { background: #fafafa; border-radius: 12px; padding: 16px; border: 1px solid #f0f0f0; transition: all 0.2s; display: flex; flex-direction: column; }
.draft-card:hover { border-color: #1d9bf0; box-shadow: 0 2px 8px rgba(29,155,240,0.08); }
.dc-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
.dc-cat { font-size: 10px; padding: 3px 10px; border-radius: 10px; font-weight: 600; color: #555; }
.dc-date { font-size: 11px; color: #bbb; }
.dc-body { flex: 1; }
.dc-title { font-size: 14px; font-weight: 700; color: #1a1a1a; margin-bottom: 6px; }
.dc-text { font-size: 12px; color: #888; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.dc-footer { display: flex; justify-content: space-between; align-items: center; margin-top: 12px; padding-top: 12px; border-top: 1px solid #f0f0f0; }
.dc-platforms { display: flex; gap: 4px; }
.dc-pf-tag { font-size: 10px; padding: 2px 8px; background: #e3f2fd; color: #1d9bf0; border-radius: 4px; font-weight: 500; }
.dc-actions { display: flex; gap: 2px; }

.table-wrap { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; }
thead th { text-align: left; padding: 10px 12px; font-size: 12px; color: #999; font-weight: 600; border-bottom: 2px solid #f0f0f0; }
tbody td { padding: 12px; font-size: 13px; color: #333; border-bottom: 1px solid #f5f5f5; }
tbody tr:hover { background: #fafafa; }
.pub-pf { font-size: 10px; padding: 3px 8px; border-radius: 10px; font-weight: 700; color: #fff; }
.pub-pf.tiktok { background: #ff0050; }
.pub-pf.youtube { background: #ff0000; }
.pub-pf.instagram { background: #e1306c; }
.pub-pf.facebook { background: #1877f2; }
.pub-pf.twitter { background: #1d9bf0; }
.pub-pf.pinterest { background: #e60023; }
.pub-pf.reddit { background: #ff4500; }
.num { text-align: right; font-weight: 500; font-variant-numeric: tabular-nums; }
.erate { font-weight: 600; }
.e-up { color: #10b981; }
.e-down { color: #ef4444; }

.create-form { display: flex; flex-direction: column; gap: 18px; }
.cf-row { display: flex; align-items: flex-start; gap: 12px; }
.cf-label { width: 70px; font-size: 13px; font-weight: 600; color: #333; padding-top: 6px; flex-shrink: 0; }
.cf-row > :not(.cf-label) { flex: 1; }
</style>
