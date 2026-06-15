<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">自动生成样片</h2>
      <span class="page-badge">AI 智能剪辑</span>
    </div>

    <!-- 步骤流程 -->
    <div class="steps-bar">
      <div class="step" :class="{ active: step >= 1, done: step > 1 }">
        <div class="step-num">{{ step > 1 ? '✓' : '1' }}</div>
        <span>上传产品</span>
      </div>
      <div class="step-line" :class="{ active: step > 1 }"></div>
      <div class="step" :class="{ active: step >= 2, done: step > 2 }">
        <div class="step-num">{{ step > 2 ? '✓' : '2' }}</div>
        <span>选择模板</span>
      </div>
      <div class="step-line" :class="{ active: step > 2 }"></div>
      <div class="step" :class="{ active: step >= 3 }">
        <div class="step-num">3</div>
        <span>生成样片</span>
      </div>
    </div>

    <div class="main-content">
      <!-- 步骤 1：上传产品 -->
      <div v-if="step === 1" class="step-content">
        <div class="upload-area">
          <div class="upload-section">
            <div class="section-title">产品链接</div>
            <el-input v-model="productUrl" placeholder="粘贴商品链接，自动获取产品信息..." size="large" class="url-input">
              <template #prefix>
                <el-icon><Link /></el-icon>
              </template>
              <template #append>
                <el-button type="primary" :loading="fetching" @click="handleFetchProduct">获取产品信息</el-button>
              </template>
            </el-input>
          </div>

          <div class="upload-divider">
            <span>或</span>
          </div>

          <div class="upload-section">
            <div class="section-title">上传素材</div>
            <el-upload
              class="upload-dropzone"
              drag
              multiple
              :auto-upload="false"
              :on-change="handleFileChange"
              accept="image/*,video/*"
            >
              <el-icon class="upload-icon"><UploadFilled /></el-icon>
              <div class="upload-text">拖拽图片或视频到此处</div>
              <div class="upload-hint">支持 JPG, PNG, MP4, MOV，单文件不超过 500MB</div>
            </el-upload>
          </div>
        </div>

        <!-- 已上传的文件 -->
        <div v-if="uploadedFiles.length" class="uploaded-files">
          <div class="section-title">已上传素材 ({{ uploadedFiles.length }})</div>
          <div class="file-grid">
            <div v-for="(f, i) in uploadedFiles" :key="i" class="file-card">
              <div class="file-preview" :style="{ background: f.bg }">
                <span class="file-emoji">{{ f.emoji }}</span>
              </div>
              <div class="file-name">{{ f.name }}</div>
              <el-icon class="file-remove" @click="uploadedFiles.splice(i, 1)"><Close /></el-icon>
            </div>
          </div>
        </div>

        <div class="product-info-card" v-if="productInfo">
          <div class="section-title">产品信息</div>
          <div class="pic-row">
            <div class="pic-thumb" :style="{ background: '#f0fdf4' }">
              <span style="font-size:32px">📦</span>
            </div>
            <div class="pic-detail">
              <div class="pic-name">{{ productInfo.name }}</div>
              <div class="pic-price">{{ productInfo.price }}</div>
              <div class="pic-desc">{{ productInfo.desc }}</div>
            </div>
          </div>
        </div>

        <el-button type="primary" size="large" class="next-btn" @click="step = 2" :disabled="!uploadedFiles.length && !productInfo">
          下一步：选择模板
          <el-icon><ArrowRight /></el-icon>
        </el-button>
      </div>

      <!-- 步骤 2：选择模板 -->
      <div v-if="step === 2" class="step-content">
        <div class="section-title">选择视频模板</div>
        <div class="template-grid">
          <div
            v-for="t in templates"
            :key="t.id"
            class="template-card"
            :class="{ active: selectedTemplate === t.id }"
            @click="selectedTemplate = t.id"
          >
            <div class="tc-preview" :style="{ background: t.bg }">
              <span class="tc-emoji">{{ t.emoji }}</span>
              <div class="tc-duration">{{ t.duration }}</div>
            </div>
            <div class="tc-info">
              <div class="tc-name">{{ t.name }}</div>
              <div class="tc-tags">
                <span class="tc-tag" v-for="tag in t.tags" :key="tag">{{ tag }}</span>
              </div>
            </div>
            <div class="tc-check" v-if="selectedTemplate === t.id">✓</div>
          </div>
        </div>

        <div class="btn-row">
          <el-button size="large" @click="step = 1">
            <el-icon><ArrowLeft /></el-icon> 上一步
          </el-button>
          <el-button type="primary" size="large" @click="step = 3" :disabled="!selectedTemplate">
            下一步：生成样片
            <el-icon><ArrowRight /></el-icon>
          </el-button>
        </div>
      </div>

      <!-- 步骤 3：生成样片 -->
      <div v-if="step === 3" class="step-content">
        <div class="generating-area" v-if="generating">
          <div class="gen-status">
            <div class="loading-spin-large"></div>
            <h3>AI 正在生成样片...</h3>
            <p class="gen-progress">{{ genProgress }}</p>
            <div class="progress-bar">
              <div class="progress-fill" :style="{ width: genPercent + '%' }"></div>
            </div>
          </div>
        </div>

        <div class="results-area" v-else>
          <div class="section-title">生成结果</div>
          <div class="result-grid">
            <div v-for="(r, i) in results" :key="i" class="result-card">
              <div class="rc-video" :style="{ background: r.bg }">
                <span class="rc-emoji">{{ r.emoji }}</span>
                <div class="rc-play">▶</div>
              </div>
              <div class="rc-info">
                <div class="rc-name">{{ r.name }}</div>
                <div class="rc-meta">{{ r.template }} · {{ r.duration }}</div>
              </div>
              <div class="rc-actions">
                <el-button size="small" type="primary" text>
                  <el-icon><Download /></el-icon>
                </el-button>
                <el-button size="small" text>
                  <el-icon><CopyDocument /></el-icon>
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <div class="btn-row" v-if="!generating">
          <el-button size="large" @click="regenerate">
            <el-icon><Refresh /></el-icon> 重新生成
          </el-button>
          <el-button size="large" @click="step = 2">
            <el-icon><ArrowLeft /></el-icon> 返回选模板
          </el-button>
          <el-button type="primary" size="large">
            <el-icon><Download /></el-icon> 下载全部
          </el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const step = ref(1)
const productUrl = ref('')
const fetching = ref(false)
const productInfo = ref(null)
const selectedTemplate = ref(null)
const generating = ref(false)
const genProgress = ref('正在分析产品信息...')
const genPercent = ref(0)

const uploadedFiles = ref([
  { name: 'product-front.jpg', bg: '#fef2f2', emoji: '🖼️' },
  { name: 'product-detail.mp4', bg: '#eff6ff', emoji: '🎥' }
])

const templates = [
  { id: 1, name: '快节奏卡点', duration: '15s', bg: '#fef2f2', emoji: '⚡', tags: ['热门', '带货'] },
  { id: 2, name: '开箱测评', duration: '30s', bg: '#f0fdf4', emoji: '📦', tags: ['测评', '真实'] },
  { id: 3, name: '对比展示', duration: '20s', bg: '#eff6ff', emoji: '🔄', tags: ['对比', '功能'] },
  { id: 4, name: '场景演示', duration: '25s', bg: '#fffbeb', emoji: '🏠', tags: ['场景', '生活'] },
  { id: 5, name: '产品特写', duration: '12s', bg: '#f5f3ff', emoji: '🔍', tags: ['细节', '质感'] },
  { id: 6, name: '创意混剪', duration: '18s', bg: '#fff7ed', emoji: '🎨', tags: ['创意', '吸睛'] }
]

const results = ref([
  { name: '产品展示-卡点版', template: '快节奏卡点', duration: '15s', bg: '#fef2f2', emoji: '⚡' },
  { name: '产品展示-开箱版', template: '开箱测评', duration: '30s', bg: '#f0fdf4', emoji: '📦' },
  { name: '产品展示-对比版', template: '对比展示', duration: '20s', bg: '#eff6ff', emoji: '🔄' }
])

const handleFetchProduct = () => {
  if (!productUrl.value.trim()) {
    ElMessage.warning('请输入商品链接')
    return
  }
  fetching.value = true
  setTimeout(() => {
    fetching.value = false
    productInfo.value = {
      name: '无线蓝牙降噪耳机 Pro Max',
      price: '$29.99',
      desc: 'ANC主动降噪 | 40小时续航 | IPX5防水 | 低延迟游戏模式'
    }
    ElMessage.success('产品信息获取成功')
  }, 1500)
}

const handleFileChange = () => {}

const regenerate = () => {
  generating.value = true
  genPercent.value = 0
  const steps = [
    { text: '正在分析产品信息...', pct: 20 },
    { text: '正在匹配模板风格...', pct: 45 },
    { text: '正在生成视频片段...', pct: 70 },
    { text: '正在添加转场与特效...', pct: 90 },
    { text: '生成完成！', pct: 100 }
  ]
  let i = 0
  const timer = setInterval(() => {
    if (i >= steps.length) {
      clearInterval(timer)
      generating.value = false
      ElMessage.success('样片生成完成！')
      return
    }
    genProgress.value = steps[i].text
    genPercent.value = steps[i].pct
    i++
  }, 800)
}
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { display: flex; align-items: center; gap: 10px; margin-bottom: 20px; }
.page-title { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0; }
.page-badge { font-size: 11px; padding: 2px 10px; border-radius: 10px; background: linear-gradient(135deg, #7c4dff, #9b7ff7); color: #fff; font-weight: 600; }

.steps-bar { display: flex; align-items: center; justify-content: center; gap: 0; margin-bottom: 28px; background: #fff; border-radius: 14px; padding: 20px 40px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); }
.step { display: flex; align-items: center; gap: 8px; font-size: 14px; color: #bbb; font-weight: 500; }
.step.active { color: #7c4dff; }
.step.done { color: #52c41a; }
.step-num { width: 28px; height: 28px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; border: 2px solid #e5e7eb; background: #fff; }
.step.active .step-num { border-color: #7c4dff; background: #f5f0ff; color: #7c4dff; }
.step.done .step-num { border-color: #52c41a; background: #f0fdf4; color: #52c41a; }
.step-line { width: 80px; height: 2px; background: #e5e7eb; margin: 0 12px; }
.step-line.active { background: #7c4dff; }

.main-content { max-width: 900px; margin: 0 auto; }
.step-content { background: #fff; border-radius: 16px; padding: 28px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); }

.section-title { font-size: 15px; font-weight: 600; color: #1a1a1a; margin-bottom: 12px; }

.upload-section { margin-bottom: 8px; }
.upload-divider { display: flex; align-items: center; gap: 16px; margin: 16px 0; color: #bbb; font-size: 13px; }
.upload-divider::before, .upload-divider::after { content: ''; flex: 1; height: 1px; background: #e5e7eb; }

.url-input { max-width: 600px; }

.upload-dropzone { width: 100%; }
.upload-dropzone :deep(.el-upload-dragger) { border-radius: 12px; }
.upload-icon { font-size: 40px; color: #c0c4cc; }
.upload-text { font-size: 14px; color: #606266; margin-top: 8px; }
.upload-hint { font-size: 11px; color: #bbb; margin-top: 4px; }

.uploaded-files { margin-top: 20px; }
.file-grid { display: flex; gap: 12px; flex-wrap: wrap; }
.file-card { position: relative; width: 100px; }
.file-preview { height: 80px; border-radius: 10px; display: flex; align-items: center; justify-content: center; }
.file-emoji { font-size: 28px; }
.file-name { font-size: 11px; color: #666; text-align: center; margin-top: 4px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.file-remove { position: absolute; top: -6px; right: -6px; width: 20px; height: 20px; background: #f56c6c; color: #fff; border-radius: 50%; font-size: 10px; cursor: pointer; display: flex; align-items: center; justify-content: center; }

.product-info-card { margin-top: 20px; padding: 16px; background: #fafafa; border-radius: 12px; }
.pic-row { display: flex; gap: 14px; align-items: center; }
.pic-thumb { width: 64px; height: 64px; border-radius: 10px; display: flex; align-items: center; justify-content: center; }
.pic-detail { flex: 1; }
.pic-name { font-size: 14px; font-weight: 600; color: #1a1a1a; }
.pic-price { font-size: 18px; font-weight: 700; color: #f56c6c; margin-top: 2px; }
.pic-desc { font-size: 12px; color: #999; margin-top: 4px; }

.next-btn { margin-top: 24px; width: 100%; height: 48px; border-radius: 10px; font-size: 15px; font-weight: 600; }

.template-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px; }
.template-card { border-radius: 14px; border: 2px solid #f0f0f0; padding: 0; cursor: pointer; transition: all 0.2s; overflow: hidden; position: relative; }
.template-card:hover { border-color: #d4c8ff; transform: translateY(-2px); box-shadow: 0 4px 16px rgba(0,0,0,0.06); }
.template-card.active { border-color: #7c4dff; box-shadow: 0 0 0 3px rgba(124,77,255,0.15); }
.tc-preview { height: 120px; display: flex; align-items: center; justify-content: center; position: relative; }
.tc-emoji { font-size: 48px; }
.tc-duration { position: absolute; bottom: 8px; right: 8px; font-size: 11px; padding: 2px 8px; background: rgba(0,0,0,0.5); color: #fff; border-radius: 4px; backdrop-filter: blur(4px); }
.tc-info { padding: 12px; }
.tc-name { font-size: 13px; font-weight: 600; color: #1a1a1a; }
.tc-tags { display: flex; gap: 4px; margin-top: 6px; }
.tc-tag { font-size: 10px; padding: 1px 6px; border-radius: 4px; background: #f0f2f5; color: #888; }
.tc-check { position: absolute; top: 8px; right: 8px; width: 24px; height: 24px; background: #7c4dff; color: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700; }

.btn-row { display: flex; gap: 12px; justify-content: center; margin-top: 28px; }

.generating-area { display: flex; flex-direction: column; align-items: center; padding: 60px 0; }
.gen-status { text-align: center; }
.gen-status h3 { font-size: 18px; color: #1a1a1a; margin: 20px 0 8px; }
.gen-progress { font-size: 13px; color: #888; margin: 0 0 16px; }
.progress-bar { width: 400px; height: 6px; background: #f0f0f0; border-radius: 3px; overflow: hidden; }
.progress-fill { height: 100%; background: linear-gradient(90deg, #7c4dff, #9b7ff7); border-radius: 3px; transition: width 0.4s; }

.loading-spin-large { width: 56px; height: 56px; border: 4px solid #e5e7eb; border-top-color: #7c4dff; border-radius: 50%; animation: spin 0.8s linear infinite; margin: 0 auto; }
@keyframes spin { to { transform: rotate(360deg); } }

.result-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-top: 16px; }
.result-card { border-radius: 14px; border: 1px solid #f0f0f0; overflow: hidden; transition: all 0.2s; }
.result-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.06); }
.rc-video { height: 140px; display: flex; align-items: center; justify-content: center; position: relative; }
.rc-emoji { font-size: 40px; }
.rc-play { position: absolute; bottom: 10px; right: 10px; width: 32px; height: 32px; background: rgba(0,0,0,0.5); backdrop-filter: blur(4px); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 12px; }
.rc-info { padding: 10px 12px; }
.rc-name { font-size: 12px; font-weight: 600; color: #333; }
.rc-meta { font-size: 11px; color: #999; margin-top: 2px; }
.rc-actions { display: flex; gap: 4px; padding: 6px 12px 10px; border-top: 1px solid #f5f5f5; }
</style>
