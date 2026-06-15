<template>
  <div class="page-container">
    <div class="page-header">
      <h2>💬 智能评论回复</h2>
      <div class="ph-right">
        <el-select v-model="filterPlatform" size="default" style="width:120px" placeholder="全部平台">
          <el-option label="全部平台" value="all" />
          <el-option label="TikTok" value="tiktok" />
          <el-option label="Instagram" value="instagram" />
          <el-option label="Facebook" value="facebook" />
          <el-option label="YouTube" value="youtube" />
        </el-select>
        <el-radio-group v-model="filterSentiment" size="small">
          <el-radio-button value="all">全部</el-radio-button>
          <el-radio-button value="positive">正面</el-radio-button>
          <el-radio-button value="neutral">中立</el-radio-button>
          <el-radio-button value="negative">负面</el-radio-button>
        </el-radio-group>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stat-row">
      <div v-for="s in stats" :key="s.label" class="stat-card">
        <span class="sc-num">{{ s.num }}</span>
        <span class="sc-label">{{ s.label }}</span>
      </div>
    </div>

    <!-- 评论列表 -->
    <div class="section">
      <div class="section-header">📨 待处理评论 ({{ filteredComments.length }})</div>
      <div class="comment-list">
        <div v-for="c in filteredComments" :key="c.id" class="comment-item" :class="{ expanded: c.id === expandedId }">
          <div class="ci-main" @click="c.id === expandedId ? (expandedId = null) : (expandedId = c.id)">
            <span class="ci-platform" :class="c.platform">{{ platformLabel[c.platform] }}</span>
            <span class="ci-sent" :class="c.sentiment">{{ sentLabel[c.sentiment] }}</span>
            <div class="ci-body">
              <div class="ci-user">{{ c.user }}</div>
              <div class="ci-text">{{ c.text }}</div>
              <div class="ci-meta">
                <span>{{ c.time }}</span>
                <span>· {{ c.post }}</span>
                <span>· 点赞 {{ c.likes }}</span>
              </div>
            </div>
            <div class="ci-status">
              <span :class="'status-dot '+c.status"></span>
              <span>{{ statusLabel[c.status] }}</span>
            </div>
          </div>

          <!-- 展开区域：AI建议回复 -->
          <div v-if="c.id === expandedId" class="ci-expand">
            <div class="ce-header">🤖 AI 建议回复</div>
            <div class="ce-suggestions">
              <div v-for="(s,si) in c.suggestions" :key="si" class="ce-card" :class="{ selected: c.selectedIdx === si }" @click="c.selectedIdx = si">
                <div class="cec-text">{{ s }}</div>
                <div class="cec-actions">
                  <el-button size="small" type="primary" @click.stop="quickReply(c, s)">发送回复</el-button>
                  <el-button size="small" @click.stop="customReply(c)">手动编辑</el-button>
                </div>
              </div>
            </div>
            <div class="ce-custom" v-if="c.customReply">
              <el-input v-model="c.customReply" type="textarea" :rows="2" placeholder="手动输入回复..." />
              <div class="cec-btns">
                <el-button size="small" @click="c.customReply=''">取消</el-button>
                <el-button size="small" type="primary" @click="submitCustom(c)">确认发送</el-button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const filterPlatform = ref('all')
const filterSentiment = ref('all')
const expandedId = ref(null)

const platformLabel = { tiktok: 'TikTok', instagram: 'Instagram', facebook: 'Facebook', youtube: 'YouTube' }
const sentLabel = { positive: '正面', neutral: '中立', negative: '负面' }
const statusLabel = { pending: '待处理', replied: '已回复', ignored: '已忽略' }

const stats = [
  { num: '128', label: '待处理' },
  { num: '1,856', label: '今日新增' },
  { num: '92.3%', label: '回复率' },
  { num: '4.2min', label: '平均响应' }
]

const comments = ref([
  {
    id: 1, platform: 'tiktok', sentiment: 'positive', user: '@时尚达人Lily', text: '这个产品真的太棒了！用了两周皮肤明显变好，必须回购！❤️', time: '2分钟前', post: '产品开箱挑战', likes: 128, status: 'pending', selectedIdx: 0,
    suggestions: ['感谢您的支持！很高兴产品让您满意，我们会继续努力做好产品 💪', '谢谢分享使用体验！如果方便的话可以at我们曝光哦，我们会送您一份小礼物 🎁', '感谢反馈！请问您最喜欢哪个功效呢？我们正在做用户调研~']
  },
  {
    id: 2, platform: 'instagram', sentiment: 'neutral', user: '@alex_tech', text: 'The product works fine but the packaging could be better. Arrived a bit dented.', time: '8分钟前', post: 'Reel新品展示', likes: 56, status: 'pending', selectedIdx: 0,
    suggestions: ['Thank you for your honest feedback! We have forwarded the packaging concern to our team. Improvements are on the way 📦', 'We appreciate your review! Could you DM us your order number? We would like to make it right for you.', 'Thanks Alex! We are actually rolling out new eco-friendly packaging next month. Stay tuned!']
  },
  {
    id: 3, platform: 'youtube', sentiment: 'positive', user: 'TechReviewPro', text: 'Best budget gadget of 2026. Been using it for a month and the battery life is insane! Great work guys.', time: '15分钟前', post: 'Ultimate Product Tutorial', likes: 342, status: 'pending', selectedIdx: 0,
    suggestions: ['Wow, thank you for the detailed review! We are thrilled you are enjoying the battery life 🔋', 'Thanks TechReviewPro! Would love to send you our newest model for a comparison review. DM us!', 'Appreciate the shoutout! We put a lot of work into optimizing the battery. Glad it shows 🙏']
  },
  {
    id: 4, platform: 'facebook', sentiment: 'negative', user: 'Mike Thompson', text: 'Ordered 2 weeks ago, still no tracking update. Customer service not responding to emails. Very disappointed.', time: '22分钟前', post: '限时优惠帖子', likes: 89, status: 'pending', selectedIdx: 1,
    suggestions: ['We sincerely apologize for the delay. Please DM us your order number and we will look into it immediately.', 'So sorry for the experience, Mike. This is not the standard we hold ourselves to. We will prioritize your case right away.', 'Apologies! Please contact us at support@brand.com with your order ID and we will escalate this to our logistics team ASAP.']
  },
  {
    id: 5, platform: 'tiktok', sentiment: 'neutral', user: '@小陈不熬夜', text: '请问有适合油性皮肤的产品吗？看了好几个视频都没有提到肤质适用', time: '30分钟前', post: '素人改造第8期', likes: 45, status: 'pending', selectedIdx: 0,
    suggestions: ['您好！我们产品系列中有专为油性皮肤设计的控油套装，稍后私信您详细介绍哦~', '感谢关注！油性皮肤推荐我们的清爽控油系列，您可以点击主页链接查看详情', '有的哦！我们即将发布油性皮肤专属产品线，关注我们不错过上新信息 🔔']
  },
  {
    id: 6, platform: 'instagram', sentiment: 'positive', user: '@bella_style', text: 'Just received my order! The color is even better in person 😍 Love the packaging too!', time: '45分钟前', post: '产品主图', likes: 203, status: 'replied', selectedIdx: 0,
    suggestions: ['So glad you love it, Bella! Tag us in your photos - we would love to feature you on our page 📸', 'Thank you for sharing! Enjoy your new purchase 💖']
  }
])

const filteredComments = computed(() => {
  return comments.value.filter(c => {
    if (filterPlatform.value !== 'all' && c.platform !== filterPlatform.value) return false
    if (filterSentiment.value !== 'all' && c.sentiment !== filterSentiment.value) return false
    return true
  })
})

function quickReply(c, text) {
  const idx = comments.value.findIndex(x => x.id === c.id)
  if (idx > -1) {
    comments.value[idx].status = 'replied'
    comments.value[idx].customReply = undefined
  }
  expandedId.value = null
}

function customReply(c) {
  c.customReply = c.selectedIdx !== undefined ? c.suggestions[c.selectedIdx] : ''
}

function submitCustom(c) {
  c.status = 'replied'
  expandedId.value = null
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

.section { background: #fff; border-radius: 14px; padding: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.03); }
.section-header { font-size: 16px; font-weight: 700; color: #1a1a1a; margin-bottom: 16px; }

.comment-list { display: flex; flex-direction: column; }
.comment-item { border-bottom: 1px solid #f5f5f5; }
.comment-item:last-child { border-bottom: none; }
.comment-item.expanded { background: #fafbff; margin: 0 -20px; padding: 0 20px; }

.ci-main { display: flex; align-items: center; gap: 12px; padding: 14px 0; cursor: pointer; }
.ci-platform { font-size: 10px; padding: 2px 8px; border-radius: 8px; font-weight: 700; color: #fff; flex-shrink: 0; }
.ci-platform.tiktok { background: #ff0050; }
.ci-platform.instagram { background: #e1306c; }
.ci-platform.facebook { background: #1877f2; }
.ci-platform.youtube { background: #ff0000; }
.ci-sent { font-size: 9px; padding: 2px 7px; border-radius: 8px; font-weight: 600; flex-shrink: 0; }
.ci-sent.positive { background: #e8f5e9; color: #2e7d32; }
.ci-sent.neutral { background: #fafafa; color: #888; }
.ci-sent.negative { background: #fce4ec; color: #c62828; }
.ci-body { flex: 1; min-width: 0; }
.ci-user { font-size: 13px; font-weight: 600; color: #1a1a1a; margin-bottom: 3px; }
.ci-text { font-size: 13px; color: #555; line-height: 1.4; }
.ci-meta { font-size: 11px; color: #bbb; margin-top: 4px; }
.ci-status { flex-shrink: 0; display: flex; align-items: center; gap: 5px; }
.status-dot { width: 7px; height: 7px; border-radius: 50%; display: inline-block; }
.status-dot.pending { background: #f59e0b; }
.status-dot.replied { background: #10b981; }
.status-dot.ignored { background: #ccc; }
.ci-status > span:last-child { font-size: 11px; color: #888; }

.ci-expand { padding: 0 0 16px; }
.ce-header { font-size: 13px; font-weight: 600; color: #7c4dff; margin-bottom: 10px; }
.ce-suggestions { display: flex; flex-direction: column; gap: 8px; margin-bottom: 10px; }
.ce-card { background: #f8f9ff; border: 1px solid #f0f0f0; border-radius: 10px; padding: 12px 14px; transition: all 0.2s; cursor: pointer; }
.ce-card:hover { border-color: #c4b5fd; }
.ce-card.selected { border-color: #7c4dff; background: #f5f3ff; }
.cec-text { font-size: 13px; color: #333; line-height: 1.5; margin-bottom: 8px; }
.cec-actions { display: flex; gap: 8px; justify-content: flex-end; }
.ce-custom { display: flex; flex-direction: column; gap: 8px; margin-top: 8px; }
.cec-btns { display: flex; gap: 8px; justify-content: flex-end; }
</style>
