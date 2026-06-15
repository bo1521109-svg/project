<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">自然流 / 广告素材</h2>
      <div class="header-actions">
        <div class="pill-group">
          <span class="pill" :class="{ active: tab === 'all' }" @click="tab = 'all'">全部</span>
          <span class="pill" :class="{ active: tab === 'natural' }" @click="tab = 'natural'">自然流</span>
          <span class="pill" :class="{ active: tab === 'ads' }" @click="tab = 'ads'">广告素材</span>
        </div>
        <el-input v-model="search" placeholder="搜索素材..." prefix-icon="Search" clearable class="search-inline" />
      </div>
    </div>
    <div class="carousel-wrapper">
      <div class="carousel-track" :style="{ transform: `translateX(-${currentPage * 100}%)` }">
        <div class="carousel-page" v-for="(page, pi) in pages" :key="pi">
          <div class="carousel-page-inner">
            <div class="reel-card" v-for="(v, vi) in page" :key="vi" :style="{ background: v.bg }">
              <div class="reel-body">
                <span class="reel-emoji">{{ v.emoji }}</span>
                <div class="reel-info">
                  <div class="reel-type" :class="v.type === '自然流' ? 'natural' : 'ads'">{{ v.type }}</div>
                  <div class="reel-title">{{ v.title }}</div>
                  <div class="reel-meta">
                    <span class="meta-tag">{{ v.source }}</span>
                    <span class="meta-tag">{{ v.duration }}</span>
                  </div>
                </div>
              </div>
              <div class="reel-stats">
                <div class="reel-stat">
                  <div class="rs-val">{{ v.plays }}</div>
                  <div class="rs-label">播放</div>
                </div>
                <div class="reel-stat">
                  <div class="rs-val">{{ v.likes }}</div>
                  <div class="rs-label">点赞</div>
                </div>
                <div class="reel-stat">
                  <div class="rs-val">{{ v.comments }}</div>
                  <div class="rs-label">评论</div>
                </div>
                <div class="reel-stat">
                  <div class="rs-val">{{ v.shares }}</div>
                  <div class="rs-label">分享</div>
                </div>
              </div>
              <div class="reel-footer">
                <div class="reel-bar">
                  <div class="reel-bar-fill" :style="{ width: v.engagement + '%' }"></div>
                </div>
                <span class="reel-engage">互动率 {{ v.engagement }}%</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- 左右箭头 -->
      <button
        class="carousel-arrow carousel-arrow-left"
        :class="{ disabled: currentPage === 0 }"
        @click="prevPage"
      >
        <el-icon><ArrowLeft /></el-icon>
      </button>
      <button
        class="carousel-arrow carousel-arrow-right"
        :class="{ disabled: currentPage === pages.length - 1 }"
        @click="nextPage"
      >
        <el-icon><ArrowRight /></el-icon>
      </button>
    </div>
    <div class="carousel-dots">
      <span
        v-for="(_, pi) in pages"
        :key="pi"
        class="dot"
        :class="{ active: pi === currentPage }"
        @click="goToPage(pi)"
      ></span>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { ArrowLeft, ArrowRight } from '@element-plus/icons-vue'

const tab = ref('all')
const search = ref('')
const currentPage = ref(0)
const cardsPerPage = 4
let autoTimer = null

const videos = ref([
  { emoji: '💄', bg: '#fef2f2', type: '自然流', title: '国货口红试色合集，平价替代大牌实测对比', source: 'TikTok美区', duration: '28s', plays: '85.2万', likes: '6.8万', comments: '3.2k', shares: '5.1k', engagement: 8.2 },
  { emoji: '👗', bg: '#f0fdf4', type: '自然流', title: '微胖女生穿搭，一件连衣裙三个场合', source: 'TikTok英区', duration: '35s', plays: '120万', likes: '9.5万', comments: '4.8k', shares: '8.2k', engagement: 7.9 },
  { emoji: '🔌', bg: '#eff6ff', type: '广告', title: '无线耳机降噪实测，地铁通勤必备好物', source: 'TikTok美区', duration: '22s', plays: '62.8万', likes: '4.2万', comments: '1.9k', shares: '2.5k', engagement: 6.7 },
  { emoji: '🏠', bg: '#fffbeb', type: '自然流', title: '出租屋改造前后对比，百元提升幸福感', source: 'TikTok东南亚', duration: '42s', plays: '205万', likes: '15.3万', comments: '7.6k', shares: '12.1k', engagement: 7.5 },
  { emoji: '🍳', bg: '#fff7ed', type: '广告', title: '空气炸锅一周食谱，懒人减脂餐合集', source: 'TikTok美区', duration: '48s', plays: '98.5万', likes: '7.1万', comments: '3.5k', shares: '4.8k', engagement: 7.2 },
  { emoji: '🎮', bg: '#f5f3ff', type: '自然流', title: '游戏外设开箱实测，FPS玩家毕业装备', source: 'TikTok日区', duration: '31s', plays: '45.6万', likes: '3.8万', comments: '2.1k', shares: '1.9k', engagement: 8.5 },
  { emoji: '☕', bg: '#faf5ff', type: '广告', title: '便携咖啡机户外测试，露营好物推荐', source: 'TikTok英区', duration: '25s', plays: '73.2万', likes: '5.6万', comments: '2.8k', shares: '3.4k', engagement: 7.8 },
  { emoji: '📱', bg: '#f0fdfa', type: '自然流', title: '手机壳开箱30个，高颜值平价合集', source: 'TikTok东南亚', duration: '38s', plays: '158万', likes: '12.1万', comments: '6.3k', shares: '9.5k', engagement: 7.6 },
])

const pages = computed(() => {
  const result = []
  for (let i = 0; i < videos.value.length; i += cardsPerPage) {
    result.push(videos.value.slice(i, i + cardsPerPage))
  }
  return result
})

const goToPage = (pi) => {
  currentPage.value = pi
  resetAutoPlay()
}

const prevPage = () => {
  if (currentPage.value > 0) {
    currentPage.value--
    resetAutoPlay()
  }
}

const nextPage = () => {
  if (currentPage.value < pages.value.length - 1) {
    currentPage.value++
    resetAutoPlay()
  }
}

const resetAutoPlay = () => {
  clearInterval(autoTimer)
  autoTimer = setInterval(() => {
    if (currentPage.value < pages.value.length - 1) {
      currentPage.value++
    } else {
      currentPage.value = 0
    }
  }, 4000)
}

onMounted(() => {
  autoTimer = setInterval(() => {
    if (currentPage.value < pages.value.length - 1) {
      currentPage.value++
    } else {
      currentPage.value = 0
    }
  }, 4000)
})

onBeforeUnmount(() => {
  clearInterval(autoTimer)
})
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: hidden; background: #f0f2f5; display: flex; flex-direction: column; }
.page-header { margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
.page-title { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0; }
.header-actions { display: flex; align-items: center; gap: 16px; }
.pill-group { display: flex; background: #fff; border-radius: 10px; padding: 3px; border: 1px solid #e5e7eb; }
.pill { padding: 6px 16px; border-radius: 8px; font-size: 13px; cursor: pointer; color: #666; transition: all 0.2s; }
.pill.active { background: linear-gradient(135deg, #7c4dff, #9b7ff7); color: #fff; }
.search-inline { width: 200px; }

/* 轮播容器 */
.carousel-wrapper { flex: 1; overflow: hidden; margin-bottom: 16px; position: relative; }
.carousel-track { display: flex; height: 100%; transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1); }
.carousel-page { min-width: 100%; height: 100%; }
.carousel-page-inner { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; height: 100%; padding: 4px; }

/* 左右箭头 */
.carousel-arrow { position: absolute; top: 50%; transform: translateY(-50%); width: 40px; height: 40px; border-radius: 50%; border: none; background: rgba(255,255,255,0.9); box-shadow: 0 2px 10px rgba(0,0,0,0.1); cursor: pointer; display: flex; align-items: center; justify-content: center; color: #555; font-size: 16px; transition: all 0.2s; z-index: 2; }
.carousel-arrow:hover { background: #fff; box-shadow: 0 4px 16px rgba(0,0,0,0.15); color: #7c4dff; }
.carousel-arrow.disabled { opacity: 0.3; cursor: not-allowed; pointer-events: none; }
.carousel-arrow-left { left: -20px; }
.carousel-arrow-right { right: -20px; }

/* 小圆点 */
.carousel-dots { display: flex; justify-content: center; gap: 10px; padding-bottom: 6px; }
.dot { width: 10px; height: 10px; border-radius: 50%; background: #d4d4d8; cursor: pointer; transition: all 0.3s; }
.dot:hover { background: #a0a0b8; }
.dot.active { background: #7c4dff; width: 28px; border-radius: 5px; }

/* 卡片 */
.reel-card { border-radius: 16px; padding: 18px; display: flex; flex-direction: column; justify-content: space-between; transition: all 0.3s; cursor: pointer; border: 1px solid rgba(0,0,0,0.05); box-shadow: 0 2px 12px rgba(0,0,0,0.04); height: 100%; }
.reel-card:hover { transform: translateY(-4px); box-shadow: 0 8px 25px rgba(0,0,0,0.08); }
.reel-body { display: flex; align-items: flex-start; gap: 14px; margin-bottom: 16px; }
.reel-emoji { font-size: 48px; flex-shrink: 0; }
.reel-info { flex: 1; min-width: 0; }
.reel-type { display: inline-block; font-size: 11px; font-weight: 600; padding: 2px 9px; border-radius: 6px; margin-bottom: 6px; }
.reel-type.natural { background: #dcfce7; color: #16a34a; }
.reel-type.ads { background: #fef3c7; color: #d97706; }
.reel-title { font-size: 14px; font-weight: 600; color: #1a1a1a; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: 6px; }
.reel-meta { display: flex; gap: 6px; }
.meta-tag { font-size: 11px; color: #8c8c8c; background: rgba(0,0,0,0.04); padding: 2px 8px; border-radius: 4px; }
.reel-stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; margin-bottom: 14px; }
.reel-stat { text-align: center; }
.rs-val { font-size: 15px; font-weight: 700; color: #1a1a1a; }
.rs-label { font-size: 10px; color: #8c8c8c; }
.reel-footer { display: flex; align-items: center; gap: 10px; }
.reel-bar { flex: 1; height: 5px; background: rgba(0,0,0,0.06); border-radius: 3px; overflow: hidden; }
.reel-bar-fill { height: 100%; border-radius: 3px; background: linear-gradient(90deg, #7c4dff, #9b7ff7); }
.reel-engage { font-size: 11px; color: #7c4dff; font-weight: 600; white-space: nowrap; }
</style>
