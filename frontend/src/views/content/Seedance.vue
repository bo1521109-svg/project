<template>
  <div class="page-container">
    <!-- 左侧：生成面板 -->
    <div class="panel-left">
      <div class="panel-header">
        <h2 class="panel-title">Seedance 2.0 / Sora 2</h2>
        <span class="panel-badge">AI 视频生成</span>
      </div>

      <!-- 提示词输入 -->
      <div class="section">
        <div class="section-label">创作提示词</div>
        <el-input
          v-model="prompt"
          type="textarea"
          :rows="4"
          placeholder="描述你想要生成的视频内容，例如：一只金毛犬在海边奔跑，夕阳逆光，电影质感，慢动作..."
          class="prompt-input"
        />
        <div class="prompt-suggestions">
          <span class="sug-label">试试：</span>
          <span class="sug-tag" v-for="s in suggestions" :key="s" @click="prompt = s">{{ s }}</span>
        </div>
      </div>

      <!-- 风格选择 -->
      <div class="section">
        <div class="section-label">视频风格</div>
        <div class="style-grid">
          <div
            v-for="s in styles"
            :key="s.key"
            class="style-card"
            :class="{ active: style === s.key }"
            @click="style = s.key"
          >
            <span class="style-emoji">{{ s.emoji }}</span>
            <span class="style-name">{{ s.name }}</span>
          </div>
        </div>
      </div>

      <!-- 参数设置 -->
      <div class="section">
        <div class="section-label">参数设置</div>
        <div class="params-row">
          <div class="param-item">
            <span class="param-label">视频时长</span>
            <el-select v-model="duration" size="small" class="param-select">
              <el-option label="5秒" value="5s" />
              <el-option label="10秒" value="10s" />
              <el-option label="15秒" value="15s" />
              <el-option label="30秒" value="30s" />
            </el-select>
          </div>
          <div class="param-item">
            <span class="param-label">分辨率</span>
            <el-select v-model="resolution" size="small" class="param-select">
              <el-option label="1080p" value="1080p" />
              <el-option label="720p" value="720p" />
              <el-option label="4K" value="4k" />
            </el-select>
          </div>
          <div class="param-item">
            <span class="param-label">画面比例</span>
            <el-select v-model="aspectRatio" size="small" class="param-select">
              <el-option label="16:9 横屏" value="16:9" />
              <el-option label="9:16 竖屏" value="9:16" />
              <el-option label="1:1 方形" value="1:1" />
            </el-select>
          </div>
        </div>
      </div>

      <!-- 生成按钮 -->
      <el-button type="primary" class="generate-btn" :loading="generating" @click="handleGenerate">
        <el-icon v-if="!generating"><MagicStick /></el-icon>
        <span>{{ generating ? '生成中...' : '开始生成视频' }}</span>
      </el-button>
    </div>

    <!-- 右侧：预览与历史 -->
    <div class="panel-right">
      <div class="preview-section">
        <div class="panel-header">
          <h3 class="panel-title">视频预览</h3>
          <div class="preview-actions">
            <el-button size="small" text :disabled="!currentVideo">
              <el-icon><Download /></el-icon> 下载
            </el-button>
            <el-button size="small" text :disabled="!currentVideo">
              <el-icon><CopyDocument /></el-icon> 复制
            </el-button>
          </div>
        </div>
        <div class="preview-area">
          <div v-if="generating" class="preview-placeholder generating">
            <div class="loading-spin"></div>
            <span>AI 正在生成视频...</span>
          </div>
          <div v-else-if="currentVideo" class="preview-video">
            <div class="video-card" :style="{ background: currentVideo.bg }">
              <span class="video-emoji">{{ currentVideo.emoji }}</span>
              <span class="video-play-icon">▶</span>
            </div>
            <div class="video-info-bar">
              <span class="video-name">{{ currentVideo.prompt }}</span>
              <span class="video-dur">{{ currentVideo.duration }}</span>
            </div>
          </div>
          <div v-else class="preview-placeholder">
            <el-icon class="placeholder-icon"><VideoPlay /></el-icon>
            <span>输入提示词并点击生成</span>
          </div>
        </div>
      </div>

      <!-- 生成历史 -->
      <div class="history-section">
        <div class="panel-header">
          <h3 class="panel-title">生成历史</h3>
          <span class="history-count">{{ history.length }} 个</span>
        </div>
        <div class="history-list">
          <div
            v-for="(h, i) in history"
            :key="i"
            class="history-item"
            :class="{ active: currentVideo === h }"
            @click="currentVideo = h"
          >
            <div class="hi-thumb" :style="{ background: h.bg }">
              <span class="hi-emoji">{{ h.emoji }}</span>
            </div>
            <div class="hi-info">
              <div class="hi-prompt">{{ h.prompt }}</div>
              <div class="hi-meta">{{ h.style }} · {{ h.duration }}</div>
            </div>
            <span class="hi-time">{{ h.time }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const prompt = ref('')
const style = ref('realistic')
const duration = ref('10s')
const resolution = ref('1080p')
const aspectRatio = ref('16:9')
const generating = ref(false)
const currentVideo = ref(null)

const suggestions = [
  '赛博朋克城市夜景，霓虹灯闪烁，雨中街景',
  '产品开箱展示，柔光棚拍风格',
  '自然风光航拍，4K超清画质',
  '卡通角色跳舞，3D动画风格'
]

const styles = [
  { key: 'realistic', name: '真实写实', emoji: '📷' },
  { key: 'anime', name: '动漫风格', emoji: '🎨' },
  { key: 'cinematic', name: '电影质感', emoji: '🎬' },
  { key: '3d', name: '3D渲染', emoji: '🖥️' },
  { key: 'product', name: '产品展示', emoji: '📦' },
  { key: 'minimal', name: '极简白底', emoji: '🤍' }
]

const history = ref([
  { prompt: '产品360度旋转展示', style: '产品展示', duration: '15s', bg: '#fef2f2', emoji: '📦', time: '2小时前' },
  { prompt: '夏日海滩度假氛围感', style: '电影质感', duration: '10s', bg: '#eff6ff', emoji: '🏖️', time: '5小时前' },
  { prompt: '化妆品特写慢镜头', style: '真实写实', duration: '5s', bg: '#f5f3ff', emoji: '💄', time: '昨天' },
  { prompt: '运动鞋弹跳展示', style: '3D渲染', duration: '10s', bg: '#fffbeb', emoji: '👟', time: '昨天' },
  { prompt: '厨房电器使用场景', style: '真实写实', duration: '30s', bg: '#f0fdf4', emoji: '🍳', time: '2天前' }
])

const handleGenerate = () => {
  if (!prompt.value.trim()) {
    ElMessage.warning('请输入创作提示词')
    return
  }
  generating.value = true
  setTimeout(() => {
    generating.value = false
    const newVideo = {
      prompt: prompt.value,
      style: styles.find(s => s.key === style.value)?.name || '',
      duration: duration.value,
      bg: ['#fef2f2', '#eff6ff', '#f5f3ff', '#fffbeb', '#f0fdf4'][Math.floor(Math.random() * 5)],
      emoji: ['🎬', '✨', '🌟', '🎯', '🔥'][Math.floor(Math.random() * 5)],
      time: '刚刚'
    }
    history.value.unshift(newVideo)
    currentVideo.value = newVideo
    ElMessage.success('视频生成成功！')
  }, 3000)
}
</script>

<style scoped>
.page-container { display: flex; gap: 20px; padding: 24px; height: calc(100vh - 120px); background: #f0f2f5; overflow: hidden; }

/* 左侧面板 */
.panel-left { width: 420px; flex-shrink: 0; background: #fff; border-radius: 16px; padding: 24px; display: flex; flex-direction: column; gap: 20px; overflow-y: auto; box-shadow: 0 2px 12px rgba(0,0,0,0.04); }
.panel-right { flex: 1; display: flex; flex-direction: column; gap: 16px; overflow: hidden; }

.panel-header { display: flex; align-items: center; gap: 10px; margin-bottom: 0; }
.panel-title { font-size: 18px; font-weight: 700; color: #1a1a1a; margin: 0; }
.panel-badge { font-size: 11px; padding: 2px 10px; border-radius: 10px; background: linear-gradient(135deg, #7c4dff, #9b7ff7); color: #fff; font-weight: 600; }

.section { display: flex; flex-direction: column; gap: 10px; }
.section-label { font-size: 13px; font-weight: 600; color: #333; }
.prompt-input :deep(.el-textarea__inner) { border-radius: 10px; font-size: 13px; resize: none; }
.prompt-suggestions { display: flex; flex-wrap: wrap; gap: 6px; align-items: center; }
.sug-label { font-size: 11px; color: #999; }
.sug-tag { font-size: 11px; padding: 3px 10px; border-radius: 12px; background: #f0f2f5; color: #666; cursor: pointer; transition: all 0.2s; white-space: nowrap; }
.sug-tag:hover { background: #e8e0ff; color: #7c4dff; }

.style-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; }
.style-card { display: flex; flex-direction: column; align-items: center; gap: 4px; padding: 12px 8px; border-radius: 10px; border: 2px solid #f0f0f0; cursor: pointer; transition: all 0.2s; background: #fafafa; }
.style-card:hover { border-color: #d4c8ff; background: #f9f7ff; }
.style-card.active { border-color: #7c4dff; background: #f5f0ff; }
.style-emoji { font-size: 24px; }
.style-name { font-size: 11px; color: #666; font-weight: 500; }

.params-row { display: flex; gap: 10px; }
.param-item { flex: 1; display: flex; flex-direction: column; gap: 4px; }
.param-label { font-size: 11px; color: #999; }
.param-select { width: 100%; }

.generate-btn { width: 100%; height: 44px; border-radius: 10px; font-size: 15px; font-weight: 600; background: linear-gradient(135deg, #7c4dff, #9b7ff7); border: none; }
.generate-btn:hover { background: linear-gradient(135deg, #6a3de8, #8b6ff5); }

/* 右侧预览 */
.preview-section { background: #fff; border-radius: 16px; padding: 20px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); }
.preview-actions { display: flex; gap: 4px; }
.preview-area { margin-top: 16px; min-height: 280px; }
.preview-placeholder { height: 280px; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #bbb; gap: 10px; border-radius: 12px; border: 2px dashed #e5e7eb; }
.preview-placeholder.generating { border-color: #7c4dff; background: #faf8ff; }
.placeholder-icon { font-size: 48px; }

.loading-spin { width: 40px; height: 40px; border: 3px solid #e5e7eb; border-top-color: #7c4dff; border-radius: 50%; animation: spin 0.8s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

.preview-video { }
.video-card { height: 220px; border-radius: 12px; display: flex; align-items: center; justify-content: center; position: relative; overflow: hidden; }
.video-emoji { font-size: 64px; }
.video-play-icon { position: absolute; bottom: 12px; right: 12px; width: 36px; height: 36px; background: rgba(0,0,0,0.5); backdrop-filter: blur(8px); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 14px; }
.video-info-bar { display: flex; justify-content: space-between; align-items: center; margin-top: 10px; padding: 0 4px; }
.video-name { font-size: 13px; color: #333; font-weight: 500; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.video-dur { font-size: 11px; color: #999; padding: 2px 8px; background: #f0f2f5; border-radius: 4px; }

/* 历史 */
.history-section { flex: 1; background: #fff; border-radius: 16px; padding: 20px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); display: flex; flex-direction: column; overflow: hidden; }
.history-count { font-size: 12px; color: #999; }
.history-list { flex: 1; overflow-y: auto; margin-top: 12px; display: flex; flex-direction: column; gap: 8px; }
.history-item { display: flex; align-items: center; gap: 12px; padding: 10px; border-radius: 10px; cursor: pointer; transition: all 0.2s; }
.history-item:hover { background: #f5f7fa; }
.history-item.active { background: #f5f0ff; }
.hi-thumb { width: 48px; height: 48px; border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.hi-emoji { font-size: 24px; }
.hi-info { flex: 1; min-width: 0; }
.hi-prompt { font-size: 12px; font-weight: 500; color: #333; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.hi-meta { font-size: 11px; color: #999; margin-top: 2px; }
.hi-time { font-size: 11px; color: #bbb; white-space: nowrap; }
</style>
