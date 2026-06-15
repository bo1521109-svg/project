<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">一键模特换衣</h2>
      <span class="page-badge" style="background:linear-gradient(135deg,#a18cd1,#fbc2eb)">AI 换装</span>
    </div>

    <div class="main-layout">
      <!-- 左：上传区 -->
      <div class="panel upload-panel">
        <div class="panel-title-row"><h3>输入素材</h3></div>

        <div class="upload-section">
          <div class="section-label">模特照片</div>
          <el-upload class="model-upload" drag :auto-upload="false" accept="image/*">
            <div v-if="!modelImage" class="upload-inner">
              <el-icon class="upload-big-icon"><UserFilled /></el-icon>
              <div>上传模特照片</div>
              <div class="upload-sub">全身/半身照最佳</div>
            </div>
            <div v-else class="upload-inner done">
              <span style="font-size:52px">🧍</span>
              <span class="done-label">{{ modelImage }}</span>
            </div>
          </el-upload>
        </div>

        <div class="upload-section">
          <div class="section-label">服装图片</div>
          <el-upload class="model-upload" drag :auto-upload="false" accept="image/*">
            <div v-if="!clothImage" class="upload-inner">
              <el-icon class="upload-big-icon"><ShoppingBag /></el-icon>
              <div>上传服装图片</div>
              <div class="upload-sub">正面平铺图最佳</div>
            </div>
            <div v-else class="upload-inner done">
              <span style="font-size:52px">👕</span>
              <span class="done-label">{{ clothImage }}</span>
            </div>
          </el-upload>
        </div>

        <div class="setting-section">
          <div class="section-label">模特姿态</div>
          <div class="pose-grid">
            <div v-for="p in poses" :key="p.key" class="pose-card" :class="{ active: selectedPose === p.key }" @click="selectedPose = p.key">
              <span class="pose-emoji">{{ p.emoji }}</span>
              <span class="pose-name">{{ p.name }}</span>
            </div>
          </div>
        </div>

        <div class="setting-section">
          <div class="section-label">背景</div>
          <div class="style-row">
            <span v-for="bg in backgrounds" :key="bg.key" class="bg-tag" :class="{ active: selectedBg === bg.key }" @click="selectedBg = bg.key">{{ bg.name }}</span>
          </div>
        </div>

        <el-button type="primary" class="gen-btn" :loading="swapping" @click="handleSwap">
          <el-icon v-if="!swapping"><Switch /></el-icon>
          {{ swapping ? 'AI 换装中...' : '开始换装' }}
        </el-button>
      </div>

      <!-- 中：对比 -->
      <div class="panel compare-panel">
        <div class="panel-title-row"><h3>换装对比</h3></div>
        <div class="compare-area">
          <div v-if="!swapped && !swapping" class="compare-empty">
            <el-icon class="empty-icon"><PictureFilled /></el-icon>
            <span>上传模特和服装后开始换装</span>
          </div>
          <div v-if="swapping" class="compare-swapping">
            <div class="loading-spin"></div>
            <span>{{ swapStep }}</span>
            <div class="swap-progress"><div class="sp-fill" :style="{ width: swapPercent + '%' }"></div></div>
          </div>
          <div v-if="swapped && !swapping" class="compare-result">
            <div class="compare-row">
              <div class="compare-box before">
                <div class="cb-label">换装前</div>
                <div class="cb-image" style="background:#fff5f7">
                  <span style="font-size:64px">🧍</span>
                </div>
              </div>
              <div class="compare-arrow">→</div>
              <div class="compare-box after">
                <div class="cb-label highlight">换装后</div>
                <div class="cb-image" style="background:#f5f0ff">
                  <span style="font-size:64px">💃</span>
                </div>
              </div>
            </div>
            <div class="compare-actions">
              <el-button type="primary" size="small"><el-icon><Download /></el-icon> 下载</el-button>
              <el-button size="small" @click="swapped = false"><el-icon><Refresh /></el-icon> 重新换</el-button>
            </div>
          </div>
        </div>
      </div>

      <!-- 右：历史 -->
      <div class="panel history-panel">
        <div class="panel-title-row"><h3>换装历史</h3></div>
        <div class="history-list">
          <div v-for="h in swapHistory" :key="h.id" class="history-item" @click="swapped = true">
            <div class="hi-row">
              <div class="hi-before" style="background:#fff5f7"><span style="font-size:20px">🧍</span></div>
              <span class="hi-arrow">→</span>
              <div class="hi-after" style="background:#f5f0ff"><span style="font-size:20px">💃</span></div>
            </div>
            <div class="hi-info">
              <span class="hi-cloth">{{ h.cloth }}</span>
              <span class="hi-time">{{ h.time }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const modelImage = ref(null)
const clothImage = ref(null)
const selectedPose = ref('stand')
const selectedBg = ref('white')
const swapping = ref(false)
const swapped = ref(false)
const swapPercent = ref(0)
const swapStep = ref('')

const poses = [
  { key: 'stand', name: '站立正面', emoji: '🧍' },
  { key: 'side', name: '侧身展示', emoji: '🕺' },
  { key: 'walk', name: '行走姿态', emoji: '🚶' },
  { key: 'sit', name: '优雅坐姿', emoji: '🪑' }
]

const backgrounds = [
  { key: 'white', name: '纯白背景' },
  { key: 'studio', name: '影棚灯光' },
  { key: 'street', name: '街拍风格' },
  { key: 'nature', name: '自然户外' }
]

const swapHistory = ref([
  { id: 1, cloth: '夏季碎花连衣裙', time: '1小时前' },
  { id: 2, cloth: '通勤西装套装', time: '3小时前' },
  { id: 3, cloth: '运动休闲卫衣', time: '昨天' },
  { id: 4, cloth: '秋冬羊毛大衣', time: '昨天' }
])

const handleSwap = () => {
  if (!modelImage.value) modelImage.value = 'model_demo.jpg'
  if (!clothImage.value) clothImage.value = 'dress_demo.jpg'
  swapping.value = true
  swapped.value = false
  swapPercent.value = 0

  const steps = [
    { text: '识别人体关键点...', pct: 15 },
    { text: '分析服装结构...', pct: 35 },
    { text: '匹配人体姿态...', pct: 60 },
    { text: '融合服装纹理...', pct: 85 },
    { text: '完成！', pct: 100 }
  ]
  let i = 0
  const timer = setInterval(() => {
    if (i >= steps.length) {
      clearInterval(timer)
      swapping.value = false
      swapped.value = true
      swapHistory.value.unshift({
        id: Date.now(),
        cloth: clothImage.value,
        time: '刚刚'
      })
      ElMessage.success('换装完成！')
      return
    }
    swapStep.value = steps[i].text
    swapPercent.value = steps[i].pct
    i++
  }, 600)
}
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: hidden; background: #f0f2f5; display: flex; flex-direction: column; }
.page-header { display: flex; align-items: center; gap: 10px; margin-bottom: 20px; flex-shrink: 0; }
.page-title { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0; }
.page-badge { font-size: 11px; padding: 2px 10px; border-radius: 10px; color: #fff; font-weight: 600; }

.main-layout { flex: 1; display: flex; gap: 20px; overflow: hidden; }
.panel { background: #fff; border-radius: 16px; padding: 20px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); display: flex; flex-direction: column; overflow-y: auto; }
.upload-panel { width: 300px; flex-shrink: 0; }
.compare-panel { flex: 1; }
.history-panel { width: 240px; flex-shrink: 0; }

.panel-title-row { margin-bottom: 16px; }
.panel-title-row h3 { font-size: 16px; font-weight: 700; color: #1a1a1a; margin: 0; }

.upload-section { margin-bottom: 16px; }
.section-label { font-size: 13px; font-weight: 600; color: #333; margin-bottom: 8px; }
.setting-section { margin-bottom: 14px; }

.model-upload :deep(.el-upload-dragger) { border-radius: 12px; padding: 16px; }
.upload-inner { text-align: center; }
.upload-inner.done { padding: 16px 0; }
.upload-big-icon { font-size: 32px; color: #c0c4cc; margin-bottom: 6px; }
.upload-sub { font-size: 11px; color: #bbb; margin-top: 4px; }
.done-label { display: block; font-size: 11px; color: #888; margin-top: 4px; }

.pose-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 8px; }
.pose-card { display: flex; flex-direction: column; align-items: center; gap: 4px; padding: 10px 6px; border-radius: 10px; border: 2px solid #f0f0f0; cursor: pointer; transition: all 0.2s; }
.pose-card:hover { border-color: #d4c8ff; }
.pose-card.active { border-color: #a18cd1; background: #f5f0ff; }
.pose-emoji { font-size: 24px; }
.pose-name { font-size: 10px; color: #666; }

.style-row { display: flex; gap: 6px; flex-wrap: wrap; }
.bg-tag { font-size: 11px; padding: 4px 10px; border-radius: 12px; border: 1px solid #e5e7eb; cursor: pointer; color: #666; transition: all 0.2s; }
.bg-tag:hover { border-color: #a18cd1; color: #a18cd1; }
.bg-tag.active { background: #f5f0ff; border-color: #a18cd1; color: #a18cd1; font-weight: 600; }

.gen-btn { width: 100%; height: 44px; border-radius: 10px; font-size: 15px; font-weight: 600; background: linear-gradient(135deg, #a18cd1, #fbc2eb); border: none; margin-top: auto; }
.gen-btn:hover { background: linear-gradient(135deg, #9178c7, #f5a8e0); }

/* 对比 */
.compare-area { flex: 1; display: flex; flex-direction: column; }
.compare-empty { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #bbb; gap: 10px; }
.empty-icon { font-size: 52px; }

.compare-swapping { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 12px; }
.loading-spin { width: 44px; height: 44px; border: 3px solid #f0f0f0; border-top-color: #a18cd1; border-radius: 50%; animation: spin 0.8s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
.swap-progress { width: 280px; height: 4px; background: #f0f0f0; border-radius: 2px; overflow: hidden; }
.sp-fill { height: 100%; background: linear-gradient(90deg, #a18cd1, #fbc2eb); border-radius: 2px; transition: width 0.5s; }

.compare-result { flex: 1; display: flex; flex-direction: column; }
.compare-row { display: flex; align-items: center; justify-content: center; gap: 20px; flex: 1; }
.compare-box { text-align: center; }
.cb-label { font-size: 12px; color: #888; margin-bottom: 8px; font-weight: 600; }
.cb-label.highlight { color: #a18cd1; }
.cb-image { width: 180px; height: 240px; border-radius: 14px; display: flex; align-items: center; justify-content: center; }
.compare-arrow { font-size: 28px; color: #a18cd1; font-weight: 700; }
.compare-actions { display: flex; gap: 8px; justify-content: center; padding-top: 16px; border-top: 1px solid #f0f0f0; }

/* 历史 */
.history-list { display: flex; flex-direction: column; gap: 10px; }
.history-item { padding: 10px; border-radius: 10px; cursor: pointer; transition: all 0.2s; }
.history-item:hover { background: #f5f7fa; }
.hi-row { display: flex; align-items: center; gap: 6px; margin-bottom: 6px; }
.hi-before, .hi-after { width: 40px; height: 40px; border-radius: 8px; display: flex; align-items: center; justify-content: center; }
.hi-arrow { font-size: 12px; color: #aaa; }
.hi-info { }
.hi-cloth { font-size: 12px; font-weight: 500; color: #333; display: block; }
.hi-time { font-size: 10px; color: #bbb; }
</style>
