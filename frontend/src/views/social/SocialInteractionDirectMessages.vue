<template>
  <div class="page-container">
    <div class="page-header">
      <h2>📩 智能私信回复</h2>
      <div class="ph-right">
        <el-select v-model="filterPlatform" size="default" style="width:120px" placeholder="全部平台">
          <el-option label="全部平台" value="all" />
          <el-option label="Line" value="line" />
          <el-option label="WhatsApp" value="whatsapp" />
          <el-option label="Instagram" value="instagram" />
          <el-option label="Facebook" value="facebook" />
        </el-select>
        <el-tag v-if="aiMode" type="success" size="small">AI Auto-Reply: ON</el-tag>
        <el-switch v-model="aiMode" active-text="AI" size="small" />
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stat-row">
      <div v-for="s in stats" :key="s.label" class="stat-card">
        <span class="sc-num">{{ s.num }}</span>
        <span class="sc-label">{{ s.label }}</span>
        <span v-if="s.trend" class="sc-trend up">{{ s.trend }}</span>
      </div>
    </div>

    <!-- 双栏：对话列表 + 对话详情 -->
    <div class="chat-layout">
      <!-- 左侧：对话列表 -->
      <div class="chat-panel list-panel">
        <div class="cp-header">对话列表 ({{ filteredChats.length }})</div>
        <div class="cp-search"><el-input v-model="search" placeholder="搜索联系人..." size="small" clearable /></div>
        <div class="cp-list">
          <div v-for="c in filteredChats" :key="c.id" class="cp-item" :class="{ active: c.id === activeChat?.id, unread: c.unread }" @click="openChat(c)">
            <div class="cpi-avatar" :style="{ background: c.avatarColor }">{{ c.avatar }}</div>
            <div class="cpi-body">
              <div class="cpi-top">
                <span class="cpi-name">{{ c.name }}</span>
                <span class="cpi-time">{{ c.time }}</span>
              </div>
              <div class="cpi-preview">{{ c.preview }}</div>
            </div>
            <div class="cpi-right">
              <span class="cpi-pf" :class="c.platform">{{ platformLabel[c.platform] }}</span>
              <span v-if="c.unread" class="cpi-badge">{{ c.unread }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧：对话详情 -->
      <div class="chat-panel detail-panel">
        <template v-if="activeChat">
          <div class="dp-header">
            <div class="dph-info">
              <div class="dpi-avatar" :style="{ background: activeChat.avatarColor }">{{ activeChat.avatar }}</div>
              <div>
                <div class="dpi-name">{{ activeChat.name }}</div>
                <div class="dpi-meta">{{ activeChat.platformLabel }} · {{ activeChat.location }} · {{ activeChat.orders }}笔订单</div>
              </div>
            </div>
            <div class="dph-tags">
              <el-tag v-for="t in activeChat.tags" :key="t" size="small" type="info">{{ t }}</el-tag>
            </div>
          </div>

          <div class="dp-messages">
            <div v-for="(m,mi) in activeChat.messages" :key="mi" class="msg" :class="{ mine: m.mine }">
              <div v-if="!m.mine" class="msg-avatar" :style="{ background: activeChat.avatarColor }">{{ activeChat.avatar }}</div>
              <div class="msg-bubble" :class="{ mine: m.mine }">
                <div class="msg-text">{{ m.text }}</div>
                <div class="msg-time">{{ m.time }}</div>
              </div>
            </div>
          </div>

          <!-- AI 建议 & 回复框 -->
          <div class="dp-reply">
            <div v-if="aiMode && aiSuggestions.length" class="dpr-ai">
              <div class="dpr-ai-label">🤖 AI 快捷回复</div>
              <div class="dpr-ai-chips">
                <span v-for="(s,si) in aiSuggestions" :key="si" class="dpr-chip" @click="sendAI(s)">{{ s.substring(0, 30) }}...</span>
              </div>
            </div>
            <div class="dpr-input-row">
              <el-input v-model="replyText" placeholder="输入回复..." @keyup.enter="send" />
              <el-button type="primary" @click="send">发送</el-button>
            </div>
          </div>
        </template>

        <div v-else class="dp-empty">
          <span style="font-size:48px">💬</span>
          <p>选择一个对话开始处理</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const filterPlatform = ref('all')
const aiMode = ref(true)
const search = ref('')
const activeChat = ref(null)
const replyText = ref('')
const aiSuggestions = ref([])

const platformLabel = { line: 'LINE', whatsapp: 'WA', instagram: 'IG DM', facebook: 'FB Msg' }

const stats = [
  { num: 42, label: '待回复', trend: '+8' },
  { num: 586, label: '今日对话', trend: '+12%' },
  { num: '1.2min', label: '平均响应' },
  { num: '85%', label: 'AI自动回复率' }
]

const chatUsers = ref([
  { id: 1, avatar: 'VIP', avatarColor: '#fce4ec', name: 'Emily Chen', platform: 'line', platformLabel: 'LINE', location: '台北', orders: 12, tags: ['VIP客户','回头客'], time: '刚刚', preview: '上次订的货还有吗？我要追加...', unread: 3,
    messages: [
      { mine: false, text: '你好，上次订的那批夏季连衣裙还有货吗？我们店卖得很好，想追加订单。', time: '10:32' },
      { mine: true, text: '您好Emily！有的哦，目前库存充足。请问您这次需要多少件？', time: '10:35' },
      { mine: false, text: '上次订了200件，这次可能要300件。另外有没有新款？想一起看看。', time: '刚刚' }
    ] },
  { id: 2, avatar: '新', avatarColor: '#e3f2fd', name: '田中 健太', platform: 'line', platformLabel: 'LINE', location: '东京', orders: 2, tags: ['日本市场','新客户'], time: '5分钟前', preview: '初めまして、商品について質問があります...', unread: 1,
    messages: [
      { mine: false, text: '初めまして、そちらの商品について質問があります。国際発送は可能ですか？', time: '09:15' },
      { mine: true, text: 'こんにちは！はい、日本への国際発送も対応しております。どの商品が気になりますか？', time: '09:20' },
      { mine: false, text: 'スマートウォッチの最新モデルです。関税はいくらくらいかかりますか？', time: '09:22' }
    ] },
  { id: 3, avatar: '分', avatarColor: '#fff3e0', name: 'Budi Santoso', platform: 'whatsapp', platformLabel: 'WA', location: '雅加达', orders: 8, tags: ['分销商','东南亚'], time: '12分钟前', preview: 'Bro, I need wholesale price for...', unread: 2,
    messages: [
      { mine: false, text: 'Bro, I need wholesale price for 500 units. Can you give best deal?', time: '昨天 18:30' },
      { mine: true, text: 'Hi Budi! For 500 units we can offer 25% off retail. Let me send you the wholesale price list.', time: '昨天 18:35' },
      { mine: false, text: 'OK send me. Also I need fast shipping to Jakarta.', time: '昨天 18:40' },
      { mine: false, text: 'Hello, are you there? Need confirm ASAP.', time: '12分钟前' }
    ] },
  { id: 4, avatar: '客', avatarColor: '#e8f5e9', name: 'Sarah Williams', platform: 'facebook', platformLabel: 'FB Msg', location: '伦敦', orders: 5, tags: ['欧洲客户'], time: '1小时前', preview: 'Hi, I would like to return...', unread: 0,
    messages: [
      { mine: false, text: 'Hi, I would like to return a product I ordered. The size is wrong.', time: '昨天 14:20' },
      { mine: true, text: 'Of course Sarah! What is your order number? We will process the return right away.', time: '昨天 14:25' },
      { mine: false, text: 'Order #UK-2026-0589. Thank you so much for the quick reply!', time: '昨天 14:30' }
    ] },
  { id: 5, avatar: '询', avatarColor: '#f3e5f5', name: 'Carlos Mendez', platform: 'instagram', platformLabel: 'IG DM', location: '墨西哥城', orders: 1, tags: ['拉美','新客'], time: '2小时前', preview: 'Hola! ¿Envían a México?', unread: 0,
    messages: [
      { mine: false, text: 'Hola! ¿Envían a México? Me gustan mucho sus productos.', time: '昨天 10:00' },
      { mine: true, text: 'Sí, enviamos a México! El envío toma 7-10 días hábiles. El costo es de $15 USD.', time: '昨天 10:05' }
    ] },
  { id: 6, avatar: '合', avatarColor: '#ede7f6', name: 'Pierre Dubois', platform: 'whatsapp', platformLabel: 'WA', location: '巴黎', orders: 15, tags: ['法国','合作方'], time: '3小时前', preview: 'Bonjour, the samples arrived...', unread: 0,
    messages: [
      { mine: false, text: 'Bonjour, the samples arrived today. Quality is excellent! We want to proceed with the partnership.', time: '2天前 09:00' },
      { mine: true, text: 'Excellent news Pierre! I will send over the contract for review. When can we schedule a call?', time: '2天前 09:30' }
    ] }
])

function openChat(c) {
  c.unread = 0
  activeChat.value = c
  // Generate AI suggestions based on context
  if (c.platform === 'line' && c.tags.includes('VIP客户')) {
    aiSuggestions.value = ['好的，300件没问题！新款已经做好产品图册，马上发给您查看~', '感谢再次选购！为您准备了VIP专属折扣，300件可享额外5%优惠', '夏季连衣裙新款系列刚刚上架，我整理好发您，颜色和款式更丰富哦']
  } else if (c.platform === 'whatsapp') {
    aiSuggestions.value = ['Sure! Sending the wholesale price list now. Please check your email in 5 minutes.', 'Got it. Shipping to Jakarta takes 5-7 days. I will confirm the total cost with express shipping.', 'Hi Budi, sorry for the delay! Let me prepare the invoice with the wholesale pricing right now.']
  } else {
    aiSuggestions.value = ['感谢您的咨询！我们会在24小时内为您处理，请耐心等待。', '您好，已收到您的消息，客服专员会尽快回复您。', '好的，已记录您的需求，我们会第一时间处理并反馈。']
  }
}

function sendAI(text) {
  if (!activeChat.value) return
  activeChat.value.messages.push({ mine: true, text, time: new Date().toLocaleTimeString('zh-CN', { hour:'2-digit', minute:'2-digit' }) })
  aiSuggestions.value = []
}

function send() {
  if (!replyText.value.trim() || !activeChat.value) return
  activeChat.value.messages.push({ mine: true, text: replyText.value, time: new Date().toLocaleTimeString('zh-CN', { hour:'2-digit', minute:'2-digit' }) })
  replyText.value = ''
}

const filteredChats = computed(() => {
  return chatUsers.value.filter(c => {
    if (filterPlatform.value !== 'all' && c.platform !== filterPlatform.value) return false
    if (search.value && !c.name.includes(search.value) && !c.preview.includes(search.value)) return false
    return true
  })
})
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
.page-header h2 { font-size: 22px; font-weight: 800; color: #1a1a1a; margin: 0; }
.ph-right { display: flex; align-items: center; gap: 12px; }

.stat-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 20px; }
.stat-card { background: #fff; border-radius: 14px; padding: 12px 18px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); text-align: center; position: relative; }
.sc-num { font-size: 24px; font-weight: 800; color: #1a1a1a; display: block; }
.sc-label { font-size: 12px; color: #999; margin-top: 3px; display: block; }
.sc-trend { font-size: 11px; font-weight: 600; }
.sc-trend.up { color: #10b981; }

.chat-layout { display: grid; grid-template-columns: 340px 1fr; gap: 16px; height: calc(100vh - 280px); }
.chat-panel { background: #fff; border-radius: 14px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); display: flex; flex-direction: column; overflow: hidden; }
.cp-header { font-size: 15px; font-weight: 700; padding: 16px 16px 12px; border-bottom: 1px solid #f0f0f0; }
.cp-search { padding: 0 16px 10px; }

.cp-list { flex: 1; overflow-y: auto; }
.cp-item { display: flex; align-items: center; gap: 10px; padding: 12px 16px; cursor: pointer; border-left: 3px solid transparent; transition: all 0.15s; }
.cp-item:hover { background: #fafafa; }
.cp-item.active { background: #f5f3ff; border-left-color: #7c4dff; }
.cp-item.unread { background: #fafbff; }
.cpi-avatar { width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 700; color: #555; flex-shrink: 0; }
.cpi-body { flex: 1; min-width: 0; }
.cpi-top { display: flex; justify-content: space-between; margin-bottom: 2px; }
.cpi-name { font-size: 13px; font-weight: 600; color: #1a1a1a; }
.cpi-time { font-size: 10px; color: #bbb; }
.cpi-preview { font-size: 12px; color: #888; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.cpi-right { display: flex; flex-direction: column; align-items: flex-end; gap: 4px; flex-shrink: 0; }
.cpi-pf { font-size: 9px; padding: 1px 6px; border-radius: 6px; font-weight: 700; color: #fff; }
.cpi-pf.line { background: #06c755; }
.cpi-pf.whatsapp { background: #25d366; }
.cpi-pf.instagram { background: #e1306c; }
.cpi-pf.facebook { background: #1877f2; }
.cpi-badge { width: 18px; height: 18px; border-radius: 50%; background: #ef4444; color: #fff; font-size: 10px; font-weight: 700; display: flex; align-items: center; justify-content: center; }

.dp-empty { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #bbb; }
.dp-empty p { margin-top: 12px; font-size: 14px; }

.dp-header { padding: 14px 16px; border-bottom: 1px solid #f0f0f0; display: flex; justify-content: space-between; align-items: center; }
.dph-info { display: flex; align-items: center; gap: 10px; }
.dpi-avatar { width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; color: #555; }
.dpi-name { font-size: 14px; font-weight: 600; color: #1a1a1a; }
.dpi-meta { font-size: 11px; color: #aaa; }
.dph-tags { display: flex; gap: 6px; }

.dp-messages { flex: 1; overflow-y: auto; padding: 16px; display: flex; flex-direction: column; gap: 12px; }
.msg { display: flex; gap: 8px; max-width: 75%; }
.msg.mine { align-self: flex-end; }
.msg-avatar { width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 11px; font-weight: 700; color: #555; flex-shrink: 0; }
.msg-bubble { background: #f0f0f0; border-radius: 12px; padding: 10px 14px; }
.msg-bubble.mine { background: linear-gradient(135deg, #667eea, #764ba2); }
.msg-bubble.mine .msg-text { color: #fff; }
.msg-text { font-size: 13px; line-height: 1.5; color: #333; }
.msg-time { font-size: 10px; color: #bbb; margin-top: 3px; text-align: right; }
.msg-bubble.mine .msg-time { color: rgba(255,255,255,0.6); }

.dp-reply { border-top: 1px solid #f0f0f0; padding: 12px 16px; }
.dpr-ai { margin-bottom: 8px; }
.dpr-ai-label { font-size: 11px; color: #7c4dff; font-weight: 600; margin-bottom: 6px; }
.dpr-ai-chips { display: flex; gap: 6px; flex-wrap: wrap; }
.dpr-chip { font-size: 11px; padding: 4px 10px; background: #f5f3ff; color: #7c4dff; border: 1px solid #e8e0ff; border-radius: 12px; cursor: pointer; transition: all 0.15s; white-space: nowrap; }
.dpr-chip:hover { background: #ede0ff; }
.dpr-input-row { display: flex; gap: 8px; }
</style>
