<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">我的素材</h2>
      <span class="page-badge" style="background:linear-gradient(135deg,#43e97b,#38f9d7)">素材库</span>
      <div class="header-actions">
        <el-button type="primary" @click="showUploadDialog = true"><el-icon><Upload /></el-icon> 上传素材</el-button>
        <el-button><el-icon><FolderAdd /></el-icon> 新建文件夹</el-button>
      </div>
    </div>

    <!-- 空间统计 -->
    <div class="space-bar">
      <div class="sb-info">
        <span class="sb-used">已用 1.2GB / 5GB</span>
        <div class="sb-track"><div class="sb-fill" style="width:24%"></div></div>
      </div>
      <span class="sb-type">
        <span>🖼️ 347张</span>
        <span>🎬 82个</span>
        <span>🎵 15首</span>
      </span>
    </div>

    <!-- 筛选栏 -->
    <div class="toolbar">
      <div class="tb-filters">
        <span class="tb-tag" :class="{ active: typeFilter === '' }" @click="typeFilter = ''">全部</span>
        <span class="tb-tag" :class="{ active: typeFilter === 'image' }" @click="typeFilter = 'image'">🖼️ 图片</span>
        <span class="tb-tag" :class="{ active: typeFilter === 'video' }" @click="typeFilter = 'video'">🎬 视频</span>
        <span class="tb-tag" :class="{ active: typeFilter === 'audio' }" @click="typeFilter = 'audio'">🎵 音频</span>
      </div>
      <el-input v-model="keyword" placeholder="搜索素材..." style="width:200px" clearable>
        <template #prefix><el-icon><Search /></el-icon></template>
      </el-input>
    </div>

    <!-- 素材网格 -->
    <div class="material-grid">
      <div v-for="m in filteredMaterials" :key="m.id" class="material-card" @click="preview = m">
        <div class="mt-top" :style="{ background: m.bg }">
          <span class="mt-type-badge" :class="'type-' + m.type">{{ typeLabels[m.type] }}</span>
          <span class="mt-emoji">{{ m.emoji }}</span>
          <span v-if="m.duration" class="mt-duration">{{ m.duration }}</span>
          <div class="mt-select">
            <el-checkbox />
          </div>
        </div>
        <div class="mt-body">
          <div class="mt-name">{{ m.name }}</div>
          <div class="mt-meta">
            <span>{{ m.size }}</span>
            <span>·</span>
            <span>{{ m.resolution }}</span>
          </div>
        </div>
        <div class="mt-footer">
          <span class="mt-date">{{ m.date }}</span>
          <div class="mt-actions">
            <el-icon class="mt-act" @click.stop="ElMessage.info('下载 ' + m.name)"><Download /></el-icon>
            <el-icon class="mt-act" @click.stop="handleDelete(m)"><Delete /></el-icon>
          </div>
        </div>
      </div>
    </div>

    <!-- 预览弹窗 -->
    <el-dialog :model-value="preview !== null" @update:model-value="v => { if (!v) preview = null }" :title="preview?.name" width="640px" destroy-on-close>
      <div v-if="preview" class="preview-area" :style="{ background: preview.bg }">
        <span class="pv-emoji">{{ preview.emoji }}</span>
        <div class="pv-info">
          <span>{{ preview.size }} · {{ preview.resolution }}</span>
          <span v-if="preview.duration"> · {{ preview.duration }}</span>
        </div>
      </div>
      <template #footer>
        <el-button @click="preview = null">关闭</el-button>
        <el-button type="primary"><el-icon><Download /></el-icon> 下载</el-button>
      </template>
    </el-dialog>

    <!-- 上传弹窗 -->
    <el-dialog v-model="showUploadDialog" title="上传素材" width="480px">
      <el-upload drag multiple accept="image/*,video/*,audio/*" :auto-upload="false">
        <div class="dialog-upload">
          <el-icon class="du-icon"><UploadFilled /></el-icon>
          <div>拖拽或点击上传</div>
          <div class="du-sub">支持 JPG/PNG/MP4/MOV/MP3，单文件 ≤ 500MB</div>
        </div>
      </el-upload>
      <template #footer>
        <el-button @click="showUploadDialog = false">取消</el-button>
        <el-button type="primary" @click="showUploadDialog = false; ElMessage.success('上传成功')">确认上传</el-button>
      </template>
    </el-dialog>

    <!-- 空 -->
    <div v-if="filteredMaterials.length === 0" class="empty-view">
      <el-icon class="empty-icon"><FolderOpened /></el-icon>
      <span>暂无素材</span>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const keyword = ref('')
const typeFilter = ref('')
const preview = ref(null)
const showUploadDialog = ref(false)

const typeLabels = { image: '图片', video: '视频', audio: '音频' }

const materials = ref([
  { id: 1, name: 'product_main_01.jpg', type: 'image', emoji: '📦', bg: '#fce4ec', size: '2.4MB', resolution: '2000×2000', date: '2026-06-05' },
  { id: 2, name: 'model_fashion_02.jpg', type: 'image', emoji: '👗', bg: '#e8f5e9', size: '3.1MB', resolution: '3000×4000', date: '2026-06-05' },
  { id: 3, name: 'opening_video_001.mp4', type: 'video', emoji: '🎬', bg: '#e3f2fd', size: '28MB', resolution: '1920×1080', duration: '0:15', date: '2026-06-04' },
  { id: 4, name: 'bg_music_summer.mp3', type: 'audio', emoji: '🎵', bg: '#fff3e0', size: '4.2MB', resolution: '320kbps', duration: '2:30', date: '2026-06-04' },
  { id: 5, name: 'logo_brand.png', type: 'image', emoji: '✨', bg: '#f3e5f5', size: '0.8MB', resolution: '1000×1000', date: '2026-06-03' },
  { id: 6, name: 'unboxing_video.mp4', type: 'video', emoji: '📦', bg: '#fff8e1', size: '45MB', resolution: '1920×1080', duration: '0:45', date: '2026-06-03' },
  { id: 7, name: 'banner_sale.jpg', type: 'image', emoji: '🏷️', bg: '#ffebee', size: '1.5MB', resolution: '1920×600', date: '2026-06-02' },
  { id: 8, name: 'demo_lifestyle_03.jpg', type: 'image', emoji: '🏠', bg: '#e0f7fa', size: '2.8MB', resolution: '4000×3000', date: '2026-06-02' },
  { id: 9, name: 'transition_effect.mp4', type: 'video', emoji: '✨', bg: '#ede7f6', size: '12MB', resolution: '1080×1920', duration: '0:08', date: '2026-06-01' },
  { id: 10, name: 'voice_female_zh.mp3', type: 'audio', emoji: '🎙️', bg: '#f5f5f0', size: '1.8MB', resolution: '256kbps', duration: '1:15', date: '2026-06-01' },
  { id: 11, name: 'product_detail_04.jpg', type: 'image', emoji: '🔍', bg: '#f0f8ff', size: '1.2MB', resolution: '1200×1200', date: '2026-05-30' },
  { id: 12, name: 'tutorial_intro.mp4', type: 'video', emoji: '📖', bg: '#f5f5f5', size: '35MB', resolution: '1920×1080', duration: '1:02', date: '2026-05-29' }
])

const filteredMaterials = computed(() => {
  return materials.value.filter(m => {
    if (typeFilter.value && m.type !== typeFilter.value) return false
    if (keyword.value && !m.name.includes(keyword.value)) return false
    return true
  })
})

const handleDelete = (m) => {
  ElMessageBox.confirm(`确认删除「${m.name}」？`, '确认删除', { type: 'warning' }).then(() => {
    materials.value = materials.value.filter(item => item.id !== m.id)
    ElMessage.success('已删除')
  }).catch(() => {})
}
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; display: flex; flex-direction: column; }
.page-header { display: flex; align-items: center; gap: 10px; margin-bottom: 16px; flex-shrink: 0; }
.page-title { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0; }
.page-badge { font-size: 11px; padding: 2px 10px; border-radius: 10px; color: #fff; font-weight: 600; }
.header-actions { margin-left: auto; display: flex; gap: 8px; }

.space-bar { display: flex; align-items: center; justify-content: space-between; background: #fff; border-radius: 12px; padding: 14px 18px; margin-bottom: 16px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); flex-shrink: 0; }
.sb-info { display: flex; flex-direction: column; gap: 6px; width: 220px; }
.sb-used { font-size: 13px; font-weight: 600; color: #333; }
.sb-track { height: 6px; background: #f0f0f0; border-radius: 3px; overflow: hidden; }
.sb-fill { height: 100%; background: linear-gradient(90deg, #43e97b, #38f9d7); border-radius: 3px; }
.sb-type { display: flex; gap: 16px; }
.sb-type span { font-size: 12px; color: #888; }

.toolbar { display: flex; align-items: center; gap: 12px; background: #fff; border-radius: 12px; padding: 12px 18px; margin-bottom: 16px; flex-shrink: 0; }
.tb-filters { display: flex; gap: 6px; }
.tb-tag { font-size: 12px; padding: 5px 14px; border-radius: 14px; cursor: pointer; color: #666; background: #f5f5f5; transition: all 0.2s; }
.tb-tag:hover { background: #e0fdf0; color: #38f9d7; }
.tb-tag.active { background: linear-gradient(135deg, #43e97b, #38f9d7); color: #fff; }

.material-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 14px; }
.material-card { background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.03); transition: all 0.25s; cursor: pointer; }
.material-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); transform: translateY(-3px); }
.mt-top { height: 140px; display: flex; align-items: center; justify-content: center; position: relative; }
.mt-type-badge { position: absolute; top: 8px; left: 8px; font-size: 10px; padding: 2px 8px; border-radius: 4px; color: #fff; font-weight: 600; }
.type-image { background: #ef4444; }
.type-video { background: #3b82f6; }
.type-audio { background: #f59e0b; }
.mt-emoji { font-size: 42px; }
.mt-duration { position: absolute; bottom: 8px; right: 8px; font-size: 11px; padding: 2px 6px; background: rgba(0,0,0,0.55); color: #fff; border-radius: 3px; }
.mt-select { position: absolute; top: 8px; right: 8px; opacity: 0; transition: opacity 0.15s; }
.mt-top:hover .mt-select { opacity: 1; }
.mt-body { padding: 10px 12px 4px; }
.mt-name { font-size: 12px; font-weight: 600; color: #1a1a1a; line-height: 1.4; }
.mt-meta { font-size: 11px; color: #aaa; margin-top: 2px; display: flex; gap: 4px; }
.mt-footer { display: flex; align-items: center; justify-content: space-between; padding: 8px 12px 10px; border-top: 1px solid #f5f5f5; }
.mt-date { font-size: 11px; color: #ccc; }
.mt-actions { display: flex; gap: 8px; }
.mt-act { font-size: 14px; color: #bbb; cursor: pointer; }
.mt-act:hover { color: #38f9d7; }

.preview-area { height: 360px; display: flex; flex-direction: column; align-items: center; justify-content: center; border-radius: 12px; }
.pv-emoji { font-size: 80px; }
.pv-info { margin-top: 12px; font-size: 13px; color: #888; }

.empty-view { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #bbb; gap: 10px; }
.empty-icon { font-size: 56px; }

.dialog-upload { text-align: center; padding: 32px 0; }
.du-icon { font-size: 40px; color: #c0c4cc; margin-bottom: 8px; }
.du-sub { font-size: 11px; color: #ccc; margin-top: 6px; }
</style>
