<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">一键克隆视频</h2>
      <span class="page-badge">AI 克隆</span>
    </div>

    <div class="main-layout">
      <!-- 左侧：源视频 -->
      <div class="panel source-panel">
        <div class="panel-title-row">
          <h3>源视频</h3>
          <span class="panel-tag">参考视频</span>
        </div>

        <div class="source-input-area">
          <el-input v-model="sourceUrl" placeholder="粘贴参考视频链接..." size="default">
            <template #prefix><el-icon><Link /></el-icon></template>
          </el-input>
          <span class="or-text">或</span>
        </div>

        <el-upload
          class="video-upload"
          drag
          :auto-upload="false"
          accept="video/*"
        >
          <div v-if="!sourceVideo" class="upload-placeholder">
            <el-icon class="upload-big-icon"><VideoCamera /></el-icon>
            <div>点击或拖拽上传参考视频</div>
            <div class="upload-sub">MP4, MOV, WebM</div>
          </div>
          <div v-else class="uploaded-video">
            <div class="uv-preview" :style="{ background: '#f5f3ff' }">
              <span style="font-size:48px">🎬</span>
            </div>
            <div class="uv-info">
              <span class="uv-name">{{ sourceVideo.name }}</span>
              <span class="uv-size">{{ sourceVideo.size }}</span>
            </div>
          </div>
        </el-upload>

        <div class="analysis-section" v-if="sourceVideo">
          <div class="section-label">AI 分析结果</div>
          <div class="analysis-grid">
            <div class="analysis-item">
              <span class="ai-label">场景数</span>
              <span class="ai-val">5 个</span>
            </div>
            <div class="analysis-item">
              <span class="ai-label">总时长</span>
              <span class="ai-val">28s</span>
            </div>
            <div class="analysis-item">
              <span class="ai-label">文字数</span>
              <span class="ai-val">12 处</span>
            </div>
            <div class="analysis-item">
              <span class="ai-label">转场</span>
              <span class="ai-val">4 种</span>
            </div>
          </div>
          <div class="scene-list">
            <div class="scene-item" v-for="(s, i) in scenes" :key="i">
              <div class="scene-num">{{ i + 1 }}</div>
              <div class="scene-bar">
                <div class="scene-bar-fill" :style="{ width: s.width + '%', background: s.color }"></div>
              </div>
              <span class="scene-time">{{ s.time }}</span>
              <span class="scene-label">{{ s.label }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 中间：替换内容 -->
      <div class="panel middle-panel">
        <div class="panel-title-row">
          <h3>替换内容</h3>
          <span class="panel-tag">你的产品</span>
        </div>

        <div class="replace-section">
          <div class="section-label">产品图片</div>
          <div class="product-img-grid">
            <div class="product-img-card" v-for="(p, i) in productImages" :key="i">
              <div class="pim-preview" :style="{ background: p.bg }">
                <span class="pim-emoji">{{ p.emoji }}</span>
              </div>
              <span class="pim-label">{{ p.label }}</span>
            </div>
            <div class="product-img-card add-card">
              <div class="pim-preview add-preview">
                <el-icon><Plus /></el-icon>
              </div>
              <span class="pim-label">添加图片</span>
            </div>
          </div>
        </div>

        <div class="replace-section">
          <div class="section-label">产品文案</div>
          <el-input v-model="productTitle" placeholder="产品名称/标题" size="default" class="mb-8" />
          <el-input
            v-model="productDesc"
            type="textarea"
            :rows="3"
            placeholder="产品卖点描述，用于替换原视频中的文字内容..."
          />
        </div>

        <div class="replace-section">
          <div class="section-label">品牌 Logo</div>
          <div class="logo-upload">
            <div class="logo-preview" v-if="logoText">
              <span class="logo-placeholder">{{ logoText }}</span>
            </div>
            <div class="logo-preview logo-empty" v-else>
              <el-icon><Plus /></el-icon>
            </div>
            <el-input v-model="logoText" placeholder="输入品牌名称或上传Logo" size="small" class="logo-input" />
          </div>
        </div>

        <div class="replace-section">
          <div class="section-label">克隆选项</div>
          <div class="option-list">
            <div class="option-item">
              <el-switch v-model="cloneOptions.structure" />
              <span>保持原视频结构</span>
            </div>
            <div class="option-item">
              <el-switch v-model="cloneOptions.effects" />
              <span>复制转场特效</span>
            </div>
            <div class="option-item">
              <el-switch v-model="cloneOptions.captions" />
              <span>自动生成字幕</span>
            </div>
            <div class="option-item">
              <el-switch v-model="cloneOptions.music" />
              <span>替换背景音乐</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧：生成结果 -->
      <div class="panel result-panel">
        <div class="panel-title-row">
          <h3>生成结果</h3>
        </div>

        <div class="result-area">
          <div v-if="!cloned && !cloning" class="result-empty">
            <el-icon class="empty-icon"><VideoPlay /></el-icon>
            <span>点击生成按钮开始克隆</span>
          </div>

          <div v-if="cloning" class="result-cloning">
            <div class="cloning-spin"></div>
            <div class="cloning-text">正在克隆视频...</div>
            <div class="cloning-progress">
              <div class="cp-fill" :style="{ width: clonePercent + '%' }"></div>
            </div>
            <div class="cloning-step">{{ cloneStep }}</div>
          </div>

          <div v-if="cloned && !cloning" class="result-video">
            <div class="rv-preview" :style="{ background: '#f0fdf4' }">
              <span style="font-size:56px">✅</span>
              <div class="rv-play-btn">▶</div>
            </div>
            <div class="rv-info">
              <div class="rv-name">克隆视频_成品</div>
              <div class="rv-meta">28s · 1080p · 15.2MB</div>
            </div>
            <div class="rv-actions">
              <el-button type="primary" size="small">
                <el-icon><Download /></el-icon> 下载
              </el-button>
              <el-button size="small">
                <el-icon><CopyDocument /></el-icon> 复制
              </el-button>
              <el-button size="small" text @click="cloned = false; cloning = false">
                <el-icon><Refresh /></el-icon> 重新克隆
              </el-button>
            </div>
          </div>
        </div>

        <el-button
          type="primary"
          size="large"
          class="clone-btn"
          :loading="cloning"
          :disabled="!sourceVideo && !sourceVideo"
          @click="handleClone"
        >
          <el-icon v-if="!cloning"><MagicStick /></el-icon>
          {{ cloning ? '克隆中...' : '开始克隆视频' }}
        </el-button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const sourceUrl = ref('')
const sourceVideo = ref(null)
const productTitle = ref('')
const productDesc = ref('')
const logoText = ref('')
const cloning = ref(false)
const cloned = ref(false)
const clonePercent = ref(0)
const cloneStep = ref('')

const cloneOptions = ref({
  structure: true,
  effects: true,
  captions: true,
  music: false
})

const scenes = [
  { time: '0-5s', width: 18, color: '#7c4dff', label: '产品特写' },
  { time: '6-12s', width: 25, color: '#f56c6c', label: '使用场景' },
  { time: '13-18s', width: 21, color: '#e6a23c', label: '功能演示' },
  { time: '19-24s', width: 21, color: '#67c23a', label: '对比展示' },
  { time: '25-28s', width: 15, color: '#409eff', label: '结尾CTA' }
]

const productImages = [
  { bg: '#fef2f2', emoji: '📦', label: '主图' },
  { bg: '#f0fdf4', emoji: '🔍', label: '细节图' },
  { bg: '#eff6ff', emoji: '🏠', label: '场景图' }
]

const handleClone = () => {
  // Demo: simulate with default source video
  if (!sourceVideo.value) {
    sourceVideo.value = { name: '参考视频_爆款.mp4', size: '45.2MB' }
  }
  cloning.value = true
  cloned.value = false
  clonePercent.value = 0

  const steps = [
    { text: '分析视频结构...', pct: 15 },
    { text: '提取关键帧...', pct: 35 },
    { text: '替换产品内容...', pct: 55 },
    { text: '同步转场特效...', pct: 75 },
    { text: '生成最终视频...', pct: 95 },
    { text: '完成！', pct: 100 }
  ]
  let i = 0
  const timer = setInterval(() => {
    if (i >= steps.length) {
      clearInterval(timer)
      cloning.value = false
      cloned.value = true
      ElMessage.success('视频克隆成功！')
      return
    }
    cloneStep.value = steps[i].text
    clonePercent.value = steps[i].pct
    i++
  }, 700)
}
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: hidden; background: #f0f2f5; display: flex; flex-direction: column; }
.page-header { display: flex; align-items: center; gap: 10px; margin-bottom: 20px; flex-shrink: 0; }
.page-title { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0; }
.page-badge { font-size: 11px; padding: 2px 10px; border-radius: 10px; background: linear-gradient(135deg, #7c4dff, #9b7ff7); color: #fff; font-weight: 600; }

.main-layout { flex: 1; display: flex; gap: 20px; overflow: hidden; }
.panel { background: #fff; border-radius: 16px; padding: 20px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); display: flex; flex-direction: column; overflow-y: auto; }
.source-panel { width: 340px; flex-shrink: 0; }
.middle-panel { flex: 1; }
.result-panel { width: 300px; flex-shrink: 0; }

.panel-title-row { display: flex; align-items: center; gap: 8px; margin-bottom: 16px; }
.panel-title-row h3 { font-size: 16px; font-weight: 700; color: #1a1a1a; margin: 0; }
.panel-tag { font-size: 10px; padding: 2px 8px; border-radius: 8px; background: #f0f2f5; color: #888; }

.source-input-area { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; }
.or-text { font-size: 12px; color: #bbb; white-space: nowrap; }

.video-upload { width: 100%; }
.video-upload :deep(.el-upload-dragger) { border-radius: 12px; padding: 24px; }
.upload-placeholder { text-align: center; }
.upload-big-icon { font-size: 36px; color: #c0c4cc; margin-bottom: 8px; }
.upload-sub { font-size: 11px; color: #bbb; margin-top: 4px; }
.uploaded-video {  }
.uv-preview { height: 100px; border-radius: 10px; display: flex; align-items: center; justify-content: center; }
.uv-info { display: flex; justify-content: space-between; margin-top: 8px; }
.uv-name { font-size: 12px; font-weight: 500; color: #333; }
.uv-size { font-size: 11px; color: #999; }

.analysis-section { margin-top: 16px; padding: 14px; background: #fafafa; border-radius: 10px; }
.section-label { font-size: 13px; font-weight: 600; color: #333; margin-bottom: 10px; }
.analysis-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 8px; margin-bottom: 12px; }
.analysis-item { text-align: center; padding: 8px; background: #fff; border-radius: 8px; }
.ai-label { font-size: 11px; color: #999; display: block; }
.ai-val { font-size: 14px; font-weight: 700; color: #333; }
.scene-list { display: flex; flex-direction: column; gap: 6px; }
.scene-item { display: flex; align-items: center; gap: 8px; }
.scene-num { width: 20px; height: 20px; border-radius: 50%; background: #f0f2f5; display: flex; align-items: center; justify-content: center; font-size: 10px; font-weight: 600; color: #666; flex-shrink: 0; }
.scene-bar { flex: 1; height: 6px; background: #f0f0f0; border-radius: 3px; overflow: hidden; }
.scene-bar-fill { height: 100%; border-radius: 3px; }
.scene-time { font-size: 10px; color: #999; min-width: 42px; }
.scene-label { font-size: 10px; color: #666; min-width: 48px; text-align: right; }

/* 中间面板 */
.replace-section { margin-bottom: 20px; }
.mb-8 { margin-bottom: 8px; }
.product-img-grid { display: flex; gap: 10px; }
.product-img-card { text-align: center; cursor: pointer; }
.pim-preview { width: 72px; height: 72px; border-radius: 10px; display: flex; align-items: center; justify-content: center; transition: all 0.2s; }
.pim-preview:hover { transform: scale(1.05); }
.add-preview { border: 2px dashed #ddd; background: #fafafa; color: #bbb; font-size: 20px; }
.pim-emoji { font-size: 28px; }
.pim-label { font-size: 10px; color: #888; margin-top: 4px; display: block; }

.logo-upload { display: flex; align-items: center; gap: 12px; }
.logo-preview { width: 52px; height: 52px; border-radius: 10px; display: flex; align-items: center; justify-content: center; background: #f5f3ff; }
.logo-placeholder { font-size: 14px; font-weight: 700; color: #7c4dff; }
.logo-empty { border: 2px dashed #ddd; background: #fafafa; color: #bbb; font-size: 18px; }
.logo-input { flex: 1; }

.option-list { display: flex; flex-direction: column; gap: 10px; }
.option-item { display: flex; align-items: center; gap: 10px; font-size: 13px; color: #555; }

/* 右侧结果 */
.result-area { flex: 1; display: flex; flex-direction: column; }
.result-empty { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #bbb; gap: 8px; }
.empty-icon { font-size: 48px; }
.result-cloning { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 12px; }
.cloning-spin { width: 44px; height: 44px; border: 3px solid #e5e7eb; border-top-color: #7c4dff; border-radius: 50%; animation: spin 0.8s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
.cloning-text { font-size: 14px; font-weight: 500; color: #333; }
.cloning-progress { width: 100%; height: 4px; background: #f0f0f0; border-radius: 2px; overflow: hidden; }
.cp-fill { height: 100%; background: linear-gradient(90deg, #7c4dff, #9b7ff7); border-radius: 2px; transition: width 0.5s; }
.cloning-step { font-size: 12px; color: #888; }
.result-video { flex: 1; display: flex; flex-direction: column; }
.rv-preview { height: 180px; border-radius: 12px; display: flex; align-items: center; justify-content: center; position: relative; }
.rv-play-btn { position: absolute; bottom: 10px; right: 10px; width: 36px; height: 36px; background: rgba(0,0,0,0.5); backdrop-filter: blur(4px); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 14px; }
.rv-info { margin-top: 10px; }
.rv-name { font-size: 13px; font-weight: 600; color: #333; }
.rv-meta { font-size: 11px; color: #999; margin-top: 2px; }
.rv-actions { display: flex; gap: 6px; margin-top: 12px; padding-top: 12px; border-top: 1px solid #f0f0f0; }

.clone-btn { margin-top: auto; width: 100%; height: 44px; border-radius: 10px; font-size: 14px; font-weight: 600; background: linear-gradient(135deg, #7c4dff, #9b7ff7); border: none; }
.clone-btn:hover { background: linear-gradient(135deg, #6a3de8, #8b6ff5); }
</style>
