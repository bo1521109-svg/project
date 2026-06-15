<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">AI 模特手持图</h2>
      <span class="page-badge" style="background:linear-gradient(135deg,#43e97b,#38f9d7)">AI 模特</span>
    </div>

    <div class="main-layout">
      <!-- 左：设置 -->
      <div class="panel settings-panel">
        <div class="panel-title-row"><h3>创建设置</h3></div>

        <div class="setting-section">
          <div class="section-label">产品图片</div>
          <el-upload class="product-up" drag :auto-upload="false" accept="image/*">
            <div v-if="!productImg" class="up-empty">
              <el-icon class="up-icon"><UploadFilled /></el-icon>
              <div>上传产品图片</div>
              <div class="up-sub">PNG透明底最佳</div>
            </div>
            <div v-else class="up-done">
              <span style="font-size:48px">📦</span>
              <span class="up-name">{{ productImg }}</span>
            </div>
          </el-upload>
        </div>

        <!-- 模特选择 -->
        <div class="setting-section">
          <div class="section-label">模特类型</div>
          <div class="model-grid">
            <div v-for="m in models" :key="m.key" class="model-card" :class="{ active: selectedModel === m.key }" @click="selectedModel = m.key">
              <div class="mc-avatar" :style="{ background: m.bg }">
                <span class="mc-emoji">{{ m.emoji }}</span>
              </div>
              <span class="mc-name">{{ m.name }}</span>
              <span class="mc-desc">{{ m.desc }}</span>
            </div>
          </div>
        </div>

        <!-- 手持姿势 -->
        <div class="setting-section">
          <div class="section-label">手持姿势</div>
          <div class="pose-row">
            <div v-for="p in holdPoses" :key="p.key" class="hold-pose" :class="{ active: selectedHoldPose === p.key }" @click="selectedHoldPose = p.key">
              <span class="hp-emoji">{{ p.emoji }}</span>
              <span class="hp-name">{{ p.name }}</span>
            </div>
          </div>
        </div>

        <!-- 场景 -->
        <div class="setting-section">
          <div class="section-label">场景</div>
          <div class="hold-scene-row">
            <span v-for="s in holdScenes" :key="s.key" class="hs-tag" :class="{ active: selectedHoldScene === s.key }" @click="selectedHoldScene = s.key">{{ s.name }}</span>
          </div>
        </div>

        <!-- 生成数量 -->
        <div class="setting-section">
          <div class="section-label">生成方案数</div>
          <el-radio-group v-model="genNum" size="small">
            <el-radio-button :value="1">1组</el-radio-button>
            <el-radio-button :value="2">2组</el-radio-button>
            <el-radio-button :value="3">3组</el-radio-button>
          </el-radio-group>
        </div>

        <el-button type="primary" class="gen-btn" :loading="running" @click="handleRun">
          <el-icon v-if="!running"><MagicStick /></el-icon>
          {{ running ? 'AI 生成中...' : '生成手持图' }}
        </el-button>
      </div>

      <!-- 右：结果 -->
      <div class="panel result-panel">
        <div class="panel-title-row">
          <h3>生成结果</h3>
          <div class="view-toggle">
            <span :class="{ active: viewMode === 'grid' }" @click="viewMode = 'grid'"><el-icon><Grid /></el-icon></span>
            <span :class="{ active: viewMode === 'list' }" @click="viewMode = 'list'"><el-icon><List /></el-icon></span>
          </div>
        </div>

        <div class="result-content">
          <div v-if="running" class="running-view">
            <div class="run-spin"></div>
            <h3>{{ runText }}</h3>
            <div class="run-bar"><div class="run-fill" :style="{ width: runPercent + '%' }"></div></div>
          </div>

          <div v-else-if="results.length" class="results-display" :class="viewMode">
            <div v-for="(r, i) in results" :key="i" class="r-card">
              <div class="rk-image" :style="{ background: r.bg }">
                <span class="rk-emoji">{{ r.emoji }}</span>
                <div class="rk-model-tag">{{ r.model }}</div>
              </div>
              <div class="rk-body">
                <div class="rk-title">{{ r.title }}</div>
                <div class="rk-meta">{{ r.pose }} · {{ r.scene }}</div>
                <div class="rk-stats">
                  <span class="rks-item">{{ r.resolution }}</span>
                </div>
              </div>
              <div class="rk-actions">
                <el-button size="small" type="primary" text><el-icon><Download /></el-icon></el-button>
                <el-button size="small" text><el-icon><CopyDocument /></el-icon></el-button>
                <el-button size="small" text><el-icon><ZoomIn /></el-icon></el-button>
              </div>
            </div>
          </div>

          <div v-else class="empty-view">
            <el-icon class="empty-icon"><PictureFilled /></el-icon>
            <span>上传产品并选择模特开始生成</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const productImg = ref(null)
const selectedModel = ref('asian-female')
const selectedHoldPose = ref('one-hand')
const selectedHoldScene = ref('studio')
const genNum = ref(2)
const viewMode = ref('grid')
const running = ref(false)
const runText = ref('')
const runPercent = ref(0)
const results = ref([])

const models = [
  { key: 'asian-female', name: '亚洲女性', desc: '25岁·温柔知性', bg: '#fff0f5', emoji: '👩🏻' },
  { key: 'asian-male', name: '亚洲男性', desc: '28岁·阳光帅气', bg: '#f0f8ff', emoji: '👨🏻' },
  { key: 'eu-female', name: '欧美女性', desc: '23岁·时尚活力', bg: '#fff5ee', emoji: '👩🏼' },
  { key: 'eu-male', name: '欧美男性', desc: '30岁·成熟稳重', bg: '#f5f5f0', emoji: '👨🏼' }
]

const holdPoses = [
  { key: 'one-hand', name: '单手托举', emoji: '🤲' },
  { key: 'two-hand', name: '双手捧持', emoji: '👐' },
  { key: 'chest', name: '胸前展示', emoji: '💁' },
  { key: 'side', name: '侧身手拿', emoji: '🙋' }
]

const holdScenes = [
  { key: 'studio', name: '纯色影棚' },
  { key: 'living', name: '客厅家居' },
  { key: 'office', name: '办公场景' },
  { key: 'outdoor', name: '户外自然' },
  { key: 'coffee', name: '咖啡厅' },
  { key: 'minimal', name: '极简白' }
]

const handleRun = () => {
  if (!productImg.value) productImg.value = 'product_hand_hold.png'
  running.value = true
  results.value = []
  runPercent.value = 0

  const steps = [
    { text: '分析产品尺寸形状...', pct: 15 },
    { text: '匹配模特姿态...', pct: 40 },
    { text: '合成手部与产品...', pct: 65 },
    { text: '渲染场景光影...', pct: 88 },
    { text: '完成！', pct: 100 }
  ]
  let i = 0
  const timer = setInterval(() => {
    if (i >= steps.length) {
      clearInterval(timer)
      running.value = false
      const modelName = models.find(m => m.key === selectedModel.value)?.name || ''
      const poseName = holdPoses.find(p => p.key === selectedHoldPose.value)?.name || ''
      const sceneName = holdScenes.find(s => s.key === selectedHoldScene.value)?.name || ''
      const newResults = []
      for (let j = 0; j < genNum.value * 2; j++) {
        newResults.push({
          title: `${modelName}_手持图${j + 1}`,
          model: modelName,
          pose: poseName,
          scene: sceneName,
          resolution: '2048×2048px',
          bg: ['#fff0f5','#f0f8ff','#fff5ee','#f5f5f0','#f0fff0','#fffaf0'][j],
          emoji: ['💄','🧴','📱','⌚','💎','🎁'][j]
        })
      }
      results.value = newResults
      ElMessage.success('手持图生成完成！')
      return
    }
    runText.value = steps[i].text
    runPercent.value = steps[i].pct
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
.settings-panel { width: 320px; flex-shrink: 0; }
.result-panel { flex: 1; }

.panel-title-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.panel-title-row h3 { font-size: 16px; font-weight: 700; color: #1a1a1a; margin: 0; }

.setting-section { margin-bottom: 16px; }
.section-label { font-size: 13px; font-weight: 600; color: #333; margin-bottom: 8px; }

.product-up :deep(.el-upload-dragger) { border-radius: 12px; padding: 20px; }
.up-empty { text-align: center; }
.up-icon { font-size: 32px; color: #c0c4cc; margin-bottom: 6px; }
.up-sub { font-size: 11px; color: #bbb; margin-top: 4px; }
.up-done { text-align: center; padding: 16px 0; }
.up-name { display: block; font-size: 11px; color: #888; margin-top: 4px; }

.model-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 8px; }
.model-card { display: flex; flex-direction: column; align-items: center; gap: 4px; padding: 12px 8px; border-radius: 12px; border: 2px solid #f0f0f0; cursor: pointer; transition: all 0.2s; }
.model-card:hover { border-color: #a0e8c0; }
.model-card.active { border-color: #38f9d7; background: #f0fdf4; }
.mc-avatar { width: 48px; height: 48px; border-radius: 50%; display: flex; align-items: center; justify-content: center; }
.mc-emoji { font-size: 24px; }
.mc-name { font-size: 12px; font-weight: 600; color: #333; }
.mc-desc { font-size: 10px; color: #999; }

.pose-row { display: grid; grid-template-columns: repeat(2, 1fr); gap: 8px; }
.hold-pose { display: flex; flex-direction: column; align-items: center; gap: 4px; padding: 8px; border-radius: 10px; border: 2px solid #f0f0f0; cursor: pointer; transition: all 0.2s; }
.hold-pose:hover { border-color: #a0e8c0; }
.hold-pose.active { border-color: #38f9d7; background: #f0fdf4; }
.hp-emoji { font-size: 22px; }
.hp-name { font-size: 10px; color: #666; }

.hold-scene-row { display: flex; gap: 6px; flex-wrap: wrap; }
.hs-tag { font-size: 11px; padding: 4px 10px; border-radius: 12px; border: 1px solid #e5e7eb; cursor: pointer; color: #666; transition: all 0.2s; }
.hs-tag:hover { border-color: #38f9d7; color: #38f9d7; }
.hs-tag.active { background: #f0fdf4; border-color: #38f9d7; color: #38f9d7; font-weight: 600; }

.gen-btn { width: 100%; height: 44px; border-radius: 10px; font-size: 15px; font-weight: 600; background: linear-gradient(135deg, #43e97b, #38f9d7); border: none; margin-top: auto; }
.gen-btn:hover { background: linear-gradient(135deg, #38d96e, #32e8c4); }

/* 结果 */
.view-toggle { display: flex; gap: 2px; background: #f0f2f5; border-radius: 6px; padding: 2px; }
.view-toggle span { width: 28px; height: 28px; display: flex; align-items: center; justify-content: center; border-radius: 4px; cursor: pointer; color: #aaa; font-size: 14px; }
.view-toggle span.active { background: #fff; color: #333; box-shadow: 0 1px 3px rgba(0,0,0,0.06); }

.result-content { flex: 1; overflow: auto; }
.empty-view { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #bbb; gap: 10px; }
.empty-icon { font-size: 52px; }

.running-view { display: flex; flex-direction: column; align-items: center; padding: 60px 0; text-align: center; }
.run-spin { width: 56px; height: 56px; border: 4px solid #f0f0f0; border-top-color: #38f9d7; border-radius: 50%; animation: spin 0.8s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
.running-view h3 { font-size: 18px; color: #1a1a1a; margin: 20px 0 12px; }
.run-bar { width: 360px; height: 6px; background: #f0f0f0; border-radius: 3px; overflow: hidden; }
.run-fill { height: 100%; background: linear-gradient(90deg, #43e97b, #38f9d7); border-radius: 3px; transition: width 0.4s; }

.results-display.grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 14px; }
.results-display.list { display: flex; flex-direction: column; gap: 10px; }
.results-display.list .r-card { display: flex; align-items: center; gap: 14px; }
.results-display.list .rk-image { width: 80px; height: 80px; }
.results-display.list .rk-body { flex: 1; }
.r-card { border-radius: 14px; border: 1px solid #f0f0f0; overflow: hidden; transition: all 0.2s; background: #fff; }
.r-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
.rk-image { height: 180px; display: flex; align-items: center; justify-content: center; position: relative; }
.rk-emoji { font-size: 48px; }
.rk-model-tag { position: absolute; bottom: 6px; left: 6px; font-size: 10px; padding: 2px 8px; background: rgba(0,0,0,0.5); color: #fff; border-radius: 4px; backdrop-filter: blur(4px); }
.rk-body { padding: 10px 12px; }
.rk-title { font-size: 12px; font-weight: 600; color: #333; }
.rk-meta { font-size: 11px; color: #999; margin-top: 2px; }
.rk-stats { margin-top: 4px; }
.rks-item { font-size: 10px; color: #aaa; }
.rk-actions { display: flex; gap: 2px; padding: 6px 12px 10px; border-top: 1px solid #f5f5f5; }
</style>
