<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">妙做商品主图</h2>
      <span class="page-badge" style="background:linear-gradient(135deg,#f093fb,#f5576c)">AI 生图</span>
    </div>

    <!-- 工作区 -->
    <div class="main-layout">
      <!-- 左：上传和设置 -->
      <div class="panel settings-panel">
        <div class="panel-title-row">
          <h3>商品设置</h3>
        </div>

        <!-- 商品图片上传 -->
        <div class="setting-section">
          <div class="section-label">商品图片</div>
          <el-upload class="product-upload" drag :auto-upload="false" accept="image/*">
            <div v-if="!productImage" class="upload-placeholder">
              <el-icon class="upload-big-icon"><UploadFilled /></el-icon>
              <div>上传商品图片</div>
              <div class="upload-sub">PNG透明底最佳，≤10MB</div>
            </div>
            <div v-else class="product-preview-big">
              <span style="font-size:72px">📦</span>
              <div class="pp-label">{{ productImage }}</div>
              <el-icon class="pp-remove" @click="productImage = null"><Close /></el-icon>
            </div>
          </el-upload>
        </div>

        <!-- 背景场景 -->
        <div class="setting-section">
          <div class="section-label">背景场景</div>
          <div class="scene-grid">
            <div
              v-for="s in scenes"
              :key="s.key"
              class="scene-card"
              :class="{ active: selectedScene === s.key }"
              @click="selectedScene = s.key"
            >
              <div class="sc-preview" :style="{ background: s.bg }">
                <span class="sc-emoji">{{ s.emoji }}</span>
              </div>
              <span class="sc-name">{{ s.name }}</span>
            </div>
          </div>
        </div>

        <!-- 图片风格 -->
        <div class="setting-section">
          <div class="section-label">画面风格</div>
          <div class="style-row">
            <span
              v-for="st in imageStyles"
              :key="st.key"
              class="style-tag"
              :class="{ active: selectedStyle === st.key }"
              @click="selectedStyle = st.key"
            >{{ st.name }}</span>
          </div>
        </div>

        <!-- 尺寸 -->
        <div class="setting-section">
          <div class="section-label">输出尺寸</div>
          <div class="size-row">
            <span
              v-for="sz in sizes"
              :key="sz.key"
              class="size-tag"
              :class="{ active: selectedSize === sz.key }"
              @click="selectedSize = sz.key"
            >{{ sz.label }}</span>
          </div>
        </div>

        <!-- 生成数量 -->
        <div class="setting-section">
          <div class="section-label">生成数量</div>
          <el-radio-group v-model="genCount" size="small">
            <el-radio-button :value="2">2张</el-radio-button>
            <el-radio-button :value="4">4张</el-radio-button>
            <el-radio-button :value="6">6张</el-radio-button>
          </el-radio-group>
        </div>

        <el-button type="primary" class="gen-btn" :loading="generating" @click="handleGenerate">
          <el-icon v-if="!generating"><MagicStick /></el-icon>
          {{ generating ? 'AI 生成中...' : '开始生成主图' }}
        </el-button>
      </div>

      <!-- 右：结果展示 -->
      <div class="panel result-panel">
        <div class="panel-title-row">
          <h3>生成结果</h3>
          <div class="result-tabs">
            <span :class="{ active: resultTab === 'current' }" @click="resultTab = 'current'">当前</span>
            <span :class="{ active: resultTab === 'history' }" @click="resultTab = 'history'">历史</span>
          </div>
        </div>

        <!-- 当前结果 -->
        <div v-if="resultTab === 'current'" class="result-content">
          <div v-if="generating" class="generating-view">
            <div class="loading-spin-large"></div>
            <h3>AI 正在创作中...</h3>
            <p class="gen-step">{{ genStep }}</p>
            <div class="progress-bar"><div class="progress-fill" :style="{ width: genPercent + '%' }"></div></div>
          </div>
          <div v-else-if="currentResults.length" class="result-grid">
            <div v-for="(r, i) in currentResults" :key="i" class="result-card">
              <div class="rc-image" :style="{ background: r.bg }">
                <span class="rc-emoji">{{ r.emoji }}</span>
                <div class="rc-actions-hover">
                  <el-button size="small" type="primary" circle><el-icon><Download /></el-icon></el-button>
                  <el-button size="small" circle><el-icon><CopyDocument /></el-icon></el-button>
                </div>
              </div>
              <div class="rc-info">
                <span class="rc-title">{{ r.name }}</span>
                <span class="rc-meta">{{ r.resolution }}</span>
              </div>
            </div>
          </div>
          <div v-else class="empty-view">
            <el-icon class="empty-icon"><PictureFilled /></el-icon>
            <span>上传商品图片并选择场景后开始生成</span>
          </div>
        </div>

        <!-- 历史 -->
        <div v-if="resultTab === 'history'" class="history-content">
          <div class="history-grid">
            <div v-for="h in genHistory" :key="h.id" class="history-card">
              <div class="hc-images">
                <div class="hc-thumb" v-for="(img, hi) in h.images" :key="hi" :style="{ background: img.bg }">
                  <span class="hc-emoji">{{ img.emoji }}</span>
                </div>
              </div>
              <div class="hc-info">
                <span class="hc-scene">{{ h.scene }}</span>
                <span class="hc-time">{{ h.time }}</span>
              </div>
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

const productImage = ref(null)
const selectedScene = ref('studio')
const selectedStyle = ref('realistic')
const selectedSize = ref('1:1')
const genCount = ref(4)
const generating = ref(false)
const genPercent = ref(0)
const genStep = ref('')
const resultTab = ref('current')
const currentResults = ref([])

const scenes = [
  { key: 'studio', name: '影棚白底', bg: '#f8f9fa', emoji: '📸' },
  { key: 'nature', name: '自然户外', bg: '#e8f5e9', emoji: '🌿' },
  { key: 'marble', name: '大理石台', bg: '#f5f0eb', emoji: '🪨' },
  { key: 'minimal', name: '极简场景', bg: '#fff8e1', emoji: '✨' },
  { key: 'lifestyle', name: '生活方式', bg: '#e3f2fd', emoji: '🏠' },
  { key: 'luxury', name: '轻奢风格', bg: '#fce4ec', emoji: '💎' },
  { key: 'season', name: '季节氛围', bg: '#fff3e0', emoji: '🍂' },
  { key: 'tech', name: '科技感', bg: '#ede7f6', emoji: '🔬' }
]

const imageStyles = [
  { key: 'realistic', name: '写实摄影' },
  { key: '3d', name: '3D渲染' },
  { key: 'watercolor', name: '水彩手绘' },
  { key: 'flat', name: '扁平插画' }
]

const sizes = [
  { key: '1:1', label: '1:1 主图' },
  { key: '3:4', label: '3:4 详情' },
  { key: '16:9', label: '16:9 BANNER' }
]

const genHistory = ref([
  { id: 1, scene: '影棚白底 · 写实摄影', time: '3小时前', images: [
    { bg: '#fce4ec', emoji: '📦' }, { bg: '#f3e5f5', emoji: '📦' }
  ]},
  { id: 2, scene: '自然户外 · 3D渲染', time: '昨天', images: [
    { bg: '#e8f5e9', emoji: '🧴' }, { bg: '#e0f2f1', emoji: '🧴' }
  ]},
  { id: 3, scene: '轻奢风格 · 写实摄影', time: '2天前', images: [
    { bg: '#fce4ec', emoji: '⌚' }, { bg: '#fce4ec', emoji: '⌚' }, { bg: '#f3e5f5', emoji: '⌚' }
  ]}
])

const handleGenerate = () => {
  if (!productImage.value) {
    productImage.value = 'product_demo.png'
  }
  generating.value = true
  currentResults.value = []
  genPercent.value = 0

  const steps = [
    { text: '分析产品特征...', pct: 15 },
    { text: '匹配场景风格...', pct: 35 },
    { text: '生成光影构图...', pct: 55 },
    { text: '渲染细节纹理...', pct: 80 },
    { text: '完成！', pct: 100 }
  ]
  let i = 0
  const timer = setInterval(() => {
    if (i >= steps.length) {
      clearInterval(timer)
      generating.value = false
      const sceneName = scenes.find(s => s.key === selectedScene.value)?.name || ''
      const results = []
      for (let j = 0; j < genCount.value; j++) {
        results.push({
          name: `商品主图_${sceneName}_${j + 1}`,
          resolution: '2000×2000px',
          bg: ['#fce4ec','#e8f5e9','#e3f2fd','#fff3e0','#f3e5f5','#fff8e1'][j],
          emoji: ['📦','🎁','🛍️','✨','💎','🔥'][j]
        })
      }
      currentResults.value = results
      genHistory.value.unshift({
        id: Date.now(),
        scene: sceneName + ' · ' + (imageStyles.find(s => s.key === selectedStyle.value)?.name || ''),
        time: '刚刚',
        images: results.map(r => ({ bg: r.bg, emoji: r.emoji }))
      })
      ElMessage.success('主图生成完成！')
      return
    }
    genStep.value = steps[i].text
    genPercent.value = steps[i].pct
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
.settings-panel { width: 340px; flex-shrink: 0; }
.result-panel { flex: 1; }

.panel-title-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.panel-title-row h3 { font-size: 16px; font-weight: 700; color: #1a1a1a; margin: 0; }

.setting-section { margin-bottom: 18px; }
.section-label { font-size: 13px; font-weight: 600; color: #333; margin-bottom: 8px; }

.product-upload :deep(.el-upload-dragger) { border-radius: 12px; padding: 24px; }
.upload-placeholder { text-align: center; }
.upload-big-icon { font-size: 36px; color: #c0c4cc; margin-bottom: 8px; }
.upload-sub { font-size: 11px; color: #bbb; margin-top: 4px; }
.product-preview-big { text-align: center; position: relative; padding: 20px; }
.pp-label { font-size: 12px; color: #888; margin-top: 6px; }
.pp-remove { position: absolute; top: 0; right: 0; color: #f56c6c; cursor: pointer; font-size: 18px; }

.scene-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; }
.scene-card { display: flex; flex-direction: column; align-items: center; gap: 4px; cursor: pointer; padding: 6px; border-radius: 10px; border: 2px solid transparent; transition: all 0.2s; }
.scene-card:hover { background: #fafafa; }
.scene-card.active { border-color: #f5576c; background: #fff5f7; }
.sc-preview { width: 100%; height: 52px; border-radius: 8px; display: flex; align-items: center; justify-content: center; }
.sc-emoji { font-size: 22px; }
.sc-name { font-size: 10px; color: #666; }

.style-row { display: flex; gap: 6px; flex-wrap: wrap; }
.style-tag { font-size: 11px; padding: 5px 12px; border-radius: 14px; border: 1px solid #e5e7eb; cursor: pointer; color: #666; transition: all 0.2s; }
.style-tag:hover { border-color: #f5576c; color: #f5576c; }
.style-tag.active { background: #fff5f7; border-color: #f5576c; color: #f5576c; font-weight: 600; }

.size-row { display: flex; gap: 6px; }
.size-tag { font-size: 11px; padding: 5px 14px; border-radius: 14px; border: 1px solid #e5e7eb; cursor: pointer; color: #666; transition: all 0.2s; }
.size-tag:hover { border-color: #f5576c; color: #f5576c; }
.size-tag.active { background: #fff5f7; border-color: #f5576c; color: #f5576c; font-weight: 600; }

.gen-btn { width: 100%; height: 44px; border-radius: 10px; font-size: 15px; font-weight: 600; background: linear-gradient(135deg, #f093fb, #f5576c); border: none; margin-top: auto; }
.gen-btn:hover { background: linear-gradient(135deg, #e880f0, #e84559); }

/* 结果 */
.result-tabs { display: flex; gap: 0; background: #f0f2f5; border-radius: 8px; padding: 2px; }
.result-tabs span { padding: 4px 14px; border-radius: 6px; font-size: 12px; cursor: pointer; color: #888; }
.result-tabs span.active { background: #fff; color: #333; font-weight: 600; box-shadow: 0 1px 3px rgba(0,0,0,0.06); }

.result-content { flex: 1; overflow: auto; }
.empty-view { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #bbb; gap: 10px; height: 100%; }
.empty-icon { font-size: 56px; }

.generating-view { display: flex; flex-direction: column; align-items: center; padding: 60px 0; text-align: center; }
.generating-view h3 { font-size: 18px; color: #1a1a1a; margin: 20px 0 8px; }
.gen-step { font-size: 13px; color: #888; margin: 0 0 16px; }
.progress-bar { width: 360px; height: 6px; background: #f0f0f0; border-radius: 3px; overflow: hidden; }
.progress-fill { height: 100%; background: linear-gradient(90deg, #f093fb, #f5576c); border-radius: 3px; transition: width 0.4s; }
.loading-spin-large { width: 56px; height: 56px; border: 4px solid #f0f0f0; border-top-color: #f5576c; border-radius: 50%; animation: spin 0.8s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

.result-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 14px; margin-top: 4px; }
.result-card { border-radius: 14px; border: 1px solid #f0f0f0; overflow: hidden; transition: all 0.2s; }
.result-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
.rc-image { height: 200px; display: flex; align-items: center; justify-content: center; position: relative; }
.rc-emoji { font-size: 52px; }
.rc-actions-hover { position: absolute; bottom: 8px; right: 8px; display: flex; gap: 4px; opacity: 0; transition: opacity 0.2s; }
.rc-image:hover .rc-actions-hover { opacity: 1; }
.rc-info { padding: 8px 12px; }
.rc-title { font-size: 12px; font-weight: 600; color: #333; }
.rc-meta { font-size: 11px; color: #999; }

/* 历史 */
.history-content { flex: 1; overflow: auto; }
.history-grid { display: flex; flex-direction: column; gap: 12px; margin-top: 4px; }
.history-card { display: flex; gap: 14px; padding: 12px; background: #fafafa; border-radius: 12px; align-items: center; }
.hc-images { display: flex; gap: 6px; }
.hc-thumb { width: 56px; height: 56px; border-radius: 8px; display: flex; align-items: center; justify-content: center; }
.hc-emoji { font-size: 22px; }
.hc-info { flex: 1; }
.hc-scene { font-size: 13px; font-weight: 500; color: #333; display: block; }
.hc-time { font-size: 11px; color: #bbb; }
</style>
