<template>
  <div class="page-container">
    <div class="brand-header">
      <div class="bh-left">
        <svg class="bh-icon" viewBox="0 0 40 40" fill="none"><circle cx="20" cy="20" r="18" fill="#06c755"/><text x="20" y="26" text-anchor="middle" fill="#fff" font-size="16" font-weight="800" font-family="Arial">LINE</text></svg>
        <div>
          <h2 class="bh-title">Line</h2>
          <p class="bh-sub">私域消息管理与客户沟通平台</p>
        </div>
      </div>
      <div class="bh-actions">
        <el-button plain style="color:#fff;border-color:rgba(255,255,255,0.5)">自动回复设置</el-button>
        <el-button type="primary" style="background:#fff;color:#06c755">同步数据</el-button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stat-row">
      <div v-for="s in stats" :key="s.label" class="stat-card">
        <div class="sc-icon" :style="{ background: s.bg }">{{ s.icon }}</div>
        <div class="sc-body">
          <div class="sc-num">{{ s.num }}<span class="sc-trend" :class="s.trendUp ? 'up' : 'down'"> {{ s.trend }}</span></div>
          <div class="sc-label">{{ s.label }}</div>
        </div>
      </div>
    </div>

    <!-- 最近对话 & 富菜单分析 -->
    <div class="two-col">
      <div class="section half">
        <div class="section-header">💬 最近对话</div>
        <div class="chat-list">
          <div v-for="c in chats" :key="c.id" class="chat-item" :class="{ unread: c.unread }">
            <div class="ci-avatar" :style="{ background: c.avatarColor }">{{ c.avatar }}</div>
            <div class="ci-body">
              <div class="ci-top">
                <span class="ci-name">{{ c.name }}</span>
                <span class="ci-time">{{ c.time }}</span>
              </div>
              <div class="ci-msg">{{ c.msg }}</div>
            </div>
            <span v-if="c.unread" class="ci-badge">{{ c.unreadCount }}</span>
          </div>
        </div>
      </div>

      <div class="section half">
        <div class="section-header">📋 富菜单(连我)点击统计</div>
        <div class="menu-stats">
          <div v-for="m in menuItems" :key="m.name" class="menu-item">
            <div class="mi-icon">{{ m.icon }}</div>
            <div class="mi-body">
              <div class="mi-name">{{ m.name }}</div>
              <div class="mi-bar"><div class="mi-fill" :style="{ width: m.pct+'%', background: m.color }"></div></div>
            </div>
            <div class="mi-ctr"><span class="mi-clicks">{{ m.clicks }}</span><span class="mi-rate">{{ m.pct }}%</span></div>
          </div>
        </div>
      </div>
    </div>

    <!-- 消息模板 -->
    <div class="section">
      <div class="section-header">📨 快捷消息模板</div>
      <div class="template-grid">
        <div v-for="t in templates" :key="t.title" class="tpl-card">
          <div class="tpl-badge" :style="{ background: t.badgeColor }">{{ t.badge }}</div>
          <div class="tpl-title">{{ t.title }}</div>
          <div class="tpl-text">{{ t.text }}</div>
          <div class="tpl-footer">
            <span class="tpl-used">已使用 {{ t.used }}次</span>
            <el-button size="small" type="primary" link>编辑</el-button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const stats = [
  { icon: '👥', bg: '#e8f5e9', num: '12,580', trend: '+8.2%', trendUp: true, label: '好友总数' },
  { icon: '💬', bg: '#e3f2fd', num: '3,256', trend: '+15.6%', trendUp: true, label: '今日消息' },
  { icon: '📋', bg: '#fff3e0', num: '68.5%', trend: '+5.3%', trendUp: true, label: '菜单点击率' },
  { icon: '⏱', bg: '#fce4ec', num: '2.8s', trend: '-0.3s', trendUp: false, label: '平均响应时间' }
]

const chats = [
  { avatar: '👩', avatarColor: '#fce4ec', name: '李小姐', time: '刚刚', msg: '请问这款产品什么时候补货？', unread: true, unreadCount: 2 },
  { avatar: '👨', avatarColor: '#e3f2fd', name: '王先生', time: '5分钟前', msg: '订单号 #20260601158 物流查询', unread: true, unreadCount: 1 },
  { avatar: '👩‍🦰', avatarColor: '#f3e5f5', name: '张太太', time: '12分钟前', msg: '已收到换货，非常感谢！', unread: false },
  { avatar: '🧑', avatarColor: '#fff3e0', name: '陈同学', time: '25分钟前', msg: '学生有折扣吗？', unread: false },
  { avatar: '👨‍🦱', avatarColor: '#e0f2f1', name: '刘老板', time: '1小时前', msg: '批量采购报价单发我一下', unread: false },
  { avatar: '👩‍💼', avatarColor: '#ede7f6', name: '赵经理', time: '2小时前', msg: '合作方案已确认，请安排', unread: false }
]

const menuItems = [
  { icon: '🛍️', name: '最新商品', clicks: '2,856', pct: 32, color: '#06c755' },
  { icon: '🎫', name: '优惠券', clicks: '2,145', pct: 24, color: '#42b883' },
  { icon: '📦', name: '订单查询', clicks: '1,862', pct: 21, color: '#5c6bc0' },
  { icon: '💬', name: '人工客服', clicks: '1,245', pct: 14, color: '#ffa726' },
  { icon: '⭐', name: '会员中心', clicks: '802', pct: 9, color: '#ec407a' }
]

const templates = [
  { badge: '问候', badgeColor: '#e8f5e9', title: '欢迎语', text: '您好！欢迎关注XX品牌官方账号 👋 回复数字获取服务：①最新商品 ②订单查询 ③优惠活动 ④人工客服', used: 1256 },
  { badge: '订单', badgeColor: '#e3f2fd', title: '订单确认', text: '您的订单 #ORDER_ID 已确认 📦 预计3-5个工作日送达。回复"物流"查询配送进度。感谢您的购买！', used: 985 },
  { badge: '售后', badgeColor: '#fce4ec', title: '退货指引', text: '您好，申请退货请按以下步骤：1️⃣ 保持商品完好 2️⃣ 回复"退货"获取地址 3️⃣ 寄回后回复单号。退款在收到商品后24小时内处理', used: 654 },
  { badge: '活动', badgeColor: '#fff3e0', title: '活动通知', text: '🎉 限时优惠！全场满$50减$10，使用优惠码 LINE10 立即下单享折扣。活动截止至本周日，错过等下次！', used: 432 },
  { badge: '会员', badgeColor: '#f3e5f5', title: '会员升级', text: '恭喜您升级为金牌会员！🥇 享受专属折扣、优先发货、生日礼物等权益。点击菜单"会员中心"查看详情。', used: 321 },
  { badge: '日常', badgeColor: '#e0f2f1', title: '节假日祝福', text: '🎊 节日快乐！感谢您一直以来的支持。为表感谢，专属优惠券已发放至您的账户，请在"优惠券"菜单中查收。', used: 289 }
]
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.brand-header { display: flex; align-items: center; justify-content: space-between; background: linear-gradient(135deg, #06c755, #00b348); border-radius: 16px; padding: 24px 28px; margin-bottom: 20px; }
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
.sc-trend.down { color: #10b981; }
.sc-label { font-size: 12px; color: #999; margin-top: 2px; }

.section { background: #fff; border-radius: 14px; padding: 20px; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); }
.section-header { font-size: 16px; font-weight: 700; color: #1a1a1a; margin-bottom: 16px; }
.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.half { margin-bottom: 0; }

.chat-list { display: flex; flex-direction: column; }
.chat-item { display: flex; align-items: center; gap: 12px; padding: 12px 0; border-bottom: 1px solid #f5f5f5; cursor: pointer; transition: background 0.15s; }
.chat-item:hover { background: #fafafa; margin: 0 -20px; padding-left: 20px; padding-right: 20px; }
.chat-item:last-child { border-bottom: none; }
.chat-item.unread { background: #f0fff4; margin: 0 -20px; padding-left: 20px; padding-right: 20px; }
.ci-avatar { width: 42px; height: 42px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; flex-shrink: 0; }
.ci-body { flex: 1; min-width: 0; }
.ci-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 3px; }
.ci-name { font-size: 13px; font-weight: 600; color: #1a1a1a; }
.ci-time { font-size: 11px; color: #bbb; }
.ci-msg { font-size: 12px; color: #888; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.ci-badge { width: 20px; height: 20px; border-radius: 50%; background: #06c755; color: #fff; font-size: 11px; font-weight: 700; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }

.menu-stats { display: flex; flex-direction: column; gap: 14px; }
.menu-item { display: flex; align-items: center; gap: 10px; }
.mi-icon { font-size: 22px; width: 34px; text-align: center; }
.mi-body { flex: 1; display: flex; flex-direction: column; gap: 4px; }
.mi-name { font-size: 13px; color: #333; font-weight: 500; }
.mi-bar { height: 6px; background: #f0f0f0; border-radius: 3px; overflow: hidden; }
.mi-fill { height: 100%; border-radius: 3px; }
.mi-ctr { text-align: right; display: flex; flex-direction: column; }
.mi-clicks { font-size: 13px; font-weight: 600; color: #333; }
.mi-rate { font-size: 10px; color: #aaa; }

.template-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 14px; }
.tpl-card { background: #fafafa; border-radius: 12px; padding: 16px; border: 1px solid #f0f0f0; transition: all 0.2s; display: flex; flex-direction: column; }
.tpl-card:hover { border-color: #06c755; box-shadow: 0 2px 8px rgba(6,199,85,0.08); }
.tpl-badge { display: inline-block; font-size: 10px; padding: 3px 10px; border-radius: 10px; color: #555; font-weight: 600; margin-bottom: 8px; align-self: flex-start; }
.tpl-title { font-size: 14px; font-weight: 700; color: #1a1a1a; margin-bottom: 6px; }
.tpl-text { font-size: 12px; color: #666; line-height: 1.5; flex: 1; margin-bottom: 10px; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
.tpl-footer { display: flex; justify-content: space-between; align-items: center; }
.tpl-used { font-size: 11px; color: #aaa; }
</style>
