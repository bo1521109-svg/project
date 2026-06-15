<template>
  <div class="page-container">
    <div class="brand-header">
      <div class="bh-left">
        <svg class="bh-icon" viewBox="0 0 40 40" fill="none"><circle cx="20" cy="20" r="18" fill="#25d366"/><path d="M20 8c-6.3 0-11.4 5.1-11.4 11.4 0 2.2.6 4.3 1.8 6.1L8 32l6.8-2.2c1.6 1 3.4 1.5 5.2 1.5 6.3 0 11.4-5.1 11.4-11.4S26.3 8 20 8Z" fill="#fff"/><path d="M25.8 22.6c-.28-.14-1.68-.83-1.94-.92-.26-.1-.45-.14-.64.14-.19.28-.73.92-.9 1.1-.16.2-.33.22-.6.07-.28-.14-1.2-.44-2.28-1.4-.84-.75-1.4-1.67-1.57-1.96-.17-.28-.02-.43.12-.57.13-.13.28-.33.42-.5.14-.17.19-.28.28-.48.1-.2.05-.37-.02-.52-.07-.15-.64-1.54-.88-2.1-.23-.55-.47-.48-.64-.49h-.55c-.19 0-.5.07-.75.36-.26.29-1 .98-1 2.38s1.03 2.76 1.17 2.95c.14.2 2.02 3.08 4.9 4.32.68.3 1.22.47 1.64.6.68.22 1.3.19 1.8.12.55-.07 1.68-.68 1.92-1.35.24-.66.24-1.23.17-1.35-.07-.13-.26-.2-.54-.35Z" fill="#25d366"/></svg>
        <div>
          <h2 class="bh-title">WhatsApp</h2>
          <p class="bh-sub">商业消息管理与客户营销平台</p>
        </div>
      </div>
      <div class="bh-actions">
        <el-button plain style="color:#fff;border-color:rgba(255,255,255,0.5)">API设置</el-button>
        <el-button type="primary" style="background:#fff;color:#25d366">发送广播</el-button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stat-row">
      <div v-for="s in stats" :key="s.label" class="stat-card">
        <div class="sc-icon" :style="{ background: s.bg }">{{ s.icon }}</div>
        <div class="sc-body">
          <div class="sc-num">{{ s.num }}<span class="sc-trend up"> {{ s.trend }}</span></div>
          <div class="sc-label">{{ s.label }}</div>
        </div>
      </div>
    </div>

    <!-- 商务对话 & 目录浏览 -->
    <div class="two-col">
      <div class="section half">
        <div class="section-header">💬 商务对话</div>
        <div class="chat-list">
          <div v-for="c in chats" :key="c.id" class="chat-item" :class="{ unread: c.unread }">
            <div class="ci-avatar" :style="{ background: c.avatarColor }">{{ c.avatar }}</div>
            <div class="ci-body">
              <div class="ci-top">
                <span class="ci-name">{{ c.name }}</span>
                <span class="ci-tag" :style="{ background: c.tagColor }">{{ c.tag }}</span>
                <span class="ci-time">{{ c.time }}</span>
              </div>
              <div class="ci-msg">{{ c.msg }}</div>
            </div>
            <span v-if="c.unread" class="ci-badge">{{ c.unreadCount }}</span>
          </div>
        </div>
      </div>

      <div class="section half">
        <div class="section-header">🛍️ 目录商品浏览TOP10</div>
        <div class="table-wrap">
          <table class="mini-table">
            <thead><tr><th>商品</th><th style="text-align:right">浏览</th><th style="text-align:right">询价</th><th style="text-align:right">转化</th></tr></thead>
            <tbody>
              <tr v-for="p in products" :key="p.name">
                <td>
                  <div class="prod-info">
                    <span class="prod-emoji">{{ p.emoji }}</span>
                    <span class="prod-name">{{ p.name }}</span>
                  </div>
                </td>
                <td class="num">{{ p.views }}</td>
                <td class="num">{{ p.inquiries }}</td>
                <td class="num"><span class="conv-rate" :style="{ color: p.convColor }">{{ p.conversion }}</span></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- 消息模板 & 广播历史 -->
    <div class="two-col">
      <div class="section half">
        <div class="section-header">📨 消息模板 (WhatsApp Business API)</div>
        <div class="tpl-list">
          <div v-for="t in templates" :key="t.name" class="tpl-item">
            <div class="tpl-icon">{{ t.icon }}</div>
            <div class="tpl-info">
              <div class="tpl-name">{{ t.name }}</div>
              <div class="tpl-desc">{{ t.desc }}</div>
            </div>
            <span class="tpl-status" :class="t.status">{{ statusMap[t.status] }}</span>
          </div>
        </div>
      </div>

      <div class="section half">
        <div class="section-header">📢 广播消息历史</div>
        <div class="broadcast-list">
          <div v-for="b in broadcasts" :key="b.id" class="br-item">
            <div class="br-header">
              <span class="br-name">{{ b.name }}</span>
              <span class="br-date">{{ b.date }}</span>
            </div>
            <div class="br-text">{{ b.text }}</div>
            <div class="br-stats">
              <span>📤 发送: {{ b.sent }}</span>
              <span>✅ 已读: {{ b.read }}</span>
              <span>🔗 点击: {{ b.clicked }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const statusMap = { approved: '已通过', pending: '审核中', rejected: '已拒绝' }

const stats = [
  { icon: '📱', bg: '#e8f5e9', num: '8,950', trend: '+12.5%', label: '联系方式数' },
  { icon: '💬', bg: '#e3f2fd', num: '4,821', trend: '+22.3%', label: '今日对话' },
  { icon: '📋', bg: '#fff3e0', num: '45.2%', trend: '+8.7%', label: '目录转化率' },
  { icon: '⏱', bg: '#fce4ec', num: '1.5min', trend: '-0.8min', label: '首次响应' }
]

const chats = [
  { avatar: '🇺🇸', avatarColor: '#e3f2fd', name: 'Sarah Johnson', tag: '新客', tagColor: '#e8f5e9', time: '刚刚', msg: 'Do you ship to Canada? Interested in bulk order.', unread: true, unreadCount: 3 },
  { avatar: '🇧🇷', avatarColor: '#fff3e0', name: 'Carlos Silva', tag: 'VIP', tagColor: '#fce4ec', time: '2分钟前', msg: 'Same order as last time, 50 units please.', unread: true, unreadCount: 1 },
  { avatar: '🇩🇪', avatarColor: '#ede7f6', name: 'Anna Müller', tag: '回头客', tagColor: '#e3f2fd', time: '8分钟前', msg: 'Received the package, quality is excellent!', unread: false },
  { avatar: '🇯🇵', avatarColor: '#fce4ec', name: '田中太郎', tag: '询价', tagColor: '#fff3e0', time: '15分钟前', msg: '商品の詳細情報を教えてください。', unread: false },
  { avatar: '🇲🇽', avatarColor: '#e0f2f1', name: 'Maria Garcia', tag: '待付', tagColor: '#ffe0e0', time: '1小时前', msg: 'Payment sent, please confirm order #2606.', unread: false }
]

const products = [
  { emoji: '👗', name: '夏季连衣裙（3色可选）', views: '3,256', inquiries: '428', conversion: '13.1%', convColor: '#25d366' },
  { emoji: '👟', name: '运动鞋轻量透气款', views: '2,891', inquiries: '356', conversion: '12.3%', convColor: '#25d366' },
  { emoji: '👜', name: '真皮手工斜挎包', views: '2,345', inquiries: '289', conversion: '12.3%', convColor: '#25d366' },
  { emoji: '⌚', name: '智能手表旗舰版', views: '1,986', inquiries: '412', conversion: '20.7%', convColor: '#25d366' },
  { emoji: '💄', name: '保湿口红套装', views: '1,753', inquiries: '198', conversion: '11.3%', convColor: '#aaa' },
  { emoji: '📱', name: '无线蓝牙耳机', views: '1,625', inquiries: '245', conversion: '15.1%', convColor: '#25d366' },
  { emoji: '🧴', name: '有机护肤精华液', views: '1,482', inquiries: '178', conversion: '12.0%', convColor: '#25d366' },
  { emoji: '🧸', name: '毛绒公仔限量版', views: '1,235', inquiries: '89', conversion: '7.2%', convColor: '#aaa' }
]

const templates = [
  { icon: '📦', name: '订单确认', desc: '含订单号、金额、预计送达日期', status: 'approved' },
  { icon: '🚚', name: '发货通知', desc: '含物流公司、运单号、追踪链接', status: 'approved' },
  { icon: '💳', name: '支付提醒', desc: '提醒未支付订单，含支付链接', status: 'approved' },
  { icon: '🎉', name: '促销广播', desc: '新品上市/限时折扣通知', status: 'pending' },
  { icon: '⭐', name: '好评邀请', desc: '收货后邀请客户留好评', status: 'approved' },
  { icon: '🔄', name: '补货通知', desc: '缺货商品到货后主动通知', status: 'pending' }
]

const broadcasts = [
  { name: '新品上市通知', date: '6月5日 14:30', text: '🎉 Spring Collection is here! Check our catalog for the latest arrivals. Limited time 15% off with code WA15.', sent: '2,350', read: '1,892', clicked: '456' },
  { name: '限时促销提醒', date: '6月3日 10:00', text: '⚡ Flash Sale: 25% off all items for the next 48 hours! Don\'t miss out. Shop now:', sent: '3,120', read: '2,568', clicked: '821' },
  { name: '节日祝福', date: '6月1日 09:00', text: '🌸 Happy June! As a valued customer, enjoy an exclusive 10% discount on your next purchase. Use code JUNE10.', sent: '4,580', read: '3,245', clicked: '632' }
]
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.brand-header { display: flex; align-items: center; justify-content: space-between; background: linear-gradient(135deg, #075e54, #128c7e); border-radius: 16px; padding: 24px 28px; margin-bottom: 20px; }
.bh-left { display: flex; align-items: center; gap: 16px; }
.bh-icon { width: 40px; height: 40px; flex-shrink: 0; }
.bh-title { color: #fff; font-size: 24px; margin: 0; }
.bh-sub { color: rgba(255,255,255,0.75); font-size: 13px; margin: 4px 0 0; }
.bh-actions { display: flex; gap: 10px; }

.stat-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 20px; }
.stat-card { background: #fff; border-radius: 14px; padding: 18px 20px; display: flex; align-items: center; gap: 14px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); }
.sc-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; }
.sc-body { display: flex; flex-direction: column; }
.sc-num { font-size: 22px; font-weight: 800; color: #1a1a1a; }
.sc-trend { font-size: 12px; font-weight: 500; }
.sc-trend.up { color: #10b981; }
.sc-label { font-size: 12px; color: #999; margin-top: 2px; }

.section { background: #fff; border-radius: 14px; padding: 20px; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); }
.section-header { font-size: 16px; font-weight: 700; color: #1a1a1a; margin-bottom: 16px; }
.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.half { margin-bottom: 0; }

.chat-list { display: flex; flex-direction: column; }
.chat-item { display: flex; align-items: center; gap: 12px; padding: 12px 0; border-bottom: 1px solid #f5f5f5; cursor: pointer; }
.chat-item:last-child { border-bottom: none; }
.chat-item:hover,
.chat-item.unread { background: #f0fdf4; margin: 0 -20px; padding-left: 20px; padding-right: 20px; }
.ci-avatar { width: 42px; height: 42px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
.ci-body { flex: 1; min-width: 0; }
.ci-top { display: flex; align-items: center; gap: 6px; margin-bottom: 3px; }
.ci-name { font-size: 13px; font-weight: 600; color: #1a1a1a; }
.ci-tag { font-size: 9px; padding: 1px 6px; border-radius: 3px; color: #555; }
.ci-time { font-size: 11px; color: #bbb; margin-left: auto; }
.ci-msg { font-size: 12px; color: #888; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.ci-badge { min-width: 20px; height: 20px; border-radius: 10px; background: #25d366; color: #fff; font-size: 11px; font-weight: 700; display: flex; align-items: center; justify-content: center; flex-shrink: 0; padding: 0 5px; }

.table-wrap { overflow-x: auto; }
.mini-table { width: 100%; border-collapse: collapse; }
.mini-table th { text-align: left; padding: 8px 10px; font-size: 11px; color: #999; font-weight: 600; border-bottom: 2px solid #f0f0f0; }
.mini-table td { padding: 10px; font-size: 12px; color: #333; border-bottom: 1px solid #f5f5f5; }
.mini-table tbody tr:hover { background: #fafafa; }
.prod-info { display: flex; align-items: center; gap: 6px; }
.prod-emoji { font-size: 18px; }
.prod-name { font-size: 12px; }
.num { text-align: right; font-weight: 500; font-variant-numeric: tabular-nums; }
.conv-rate { font-weight: 600; }

.tpl-list { display: flex; flex-direction: column; gap: 10px; }
.tpl-item { display: flex; align-items: center; gap: 12px; padding: 12px; background: #fafafa; border-radius: 10px; }
.tpl-icon { font-size: 24px; }
.tpl-info { flex: 1; }
.tpl-name { font-size: 13px; font-weight: 600; color: #333; }
.tpl-desc { font-size: 11px; color: #aaa; margin-top: 2px; }
.tpl-status { font-size: 11px; padding: 3px 10px; border-radius: 10px; font-weight: 600; }
.tpl-status.approved { background: #e8f5e9; color: #2e7d32; }
.tpl-status.pending { background: #fff8e1; color: #f57f17; }
.tpl-status.rejected { background: #fce4ec; color: #c62828; }

.broadcast-list { display: flex; flex-direction: column; gap: 12px; }
.br-item { background: #fafafa; border-radius: 10px; padding: 14px; }
.br-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; }
.br-name { font-size: 13px; font-weight: 600; color: #1a1a1a; }
.br-date { font-size: 11px; color: #aaa; }
.br-text { font-size: 12px; color: #666; line-height: 1.5; margin-bottom: 8px; }
.br-stats { display: flex; gap: 16px; font-size: 11px; color: #999; }
</style>
