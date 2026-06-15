<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">我的模特</h2>
      <span class="page-badge" style="background:linear-gradient(135deg,#f093fb,#f5576c)">模特库</span>
      <div class="header-actions">
        <el-button type="primary" @click="showAddDialog = true"><el-icon><Plus /></el-icon> 添加模特</el-button>
        <el-button><el-icon><Upload /></el-icon> 批量导入</el-button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stat-row">
      <div class="stat-card" v-for="s in stats" :key="s.label">
        <span class="s-num">{{ s.num }}</span>
        <span class="s-label">{{ s.label }}</span>
      </div>
    </div>

    <!-- 筛选 -->
    <div class="toolbar">
      <div class="tb-filters">
        <span class="tb-tag" :class="{ active: genderFilter === '' }" @click="genderFilter = ''">全部</span>
        <span class="tb-tag" :class="{ active: genderFilter === '女' }" @click="genderFilter = '女'">女性</span>
        <span class="tb-tag" :class="{ active: genderFilter === '男' }" @click="genderFilter = '男'">男性</span>
      </div>
      <el-input v-model="keyword" placeholder="搜索模特..." style="width:200px" clearable>
        <template #prefix><el-icon><Search /></el-icon></template>
      </el-input>
      <span class="tb-count">共 {{ filteredModels.length }} 位模特</span>
    </div>

    <!-- 模特网格 -->
    <div class="model-grid">
      <div v-for="m in filteredModels" :key="m.id" class="model-card" :class="{ favorite: m.favorite }">
        <div class="mc-image" :style="{ background: m.bg }">
          <span class="mc-emoji">{{ m.emoji }}</span>
          <el-icon v-if="m.favorite" class="mc-star"><StarFilled /></el-icon>
          <el-icon v-else class="mc-star-outline" @click.stop="toggleFav(m)"><Star /></el-icon>
        </div>
        <div class="mc-body">
          <div class="mc-name">{{ m.name }}</div>
          <div class="mc-tags">
            <span class="mc-tag" v-for="t in m.tags" :key="t">{{ t }}</span>
          </div>
          <div class="mc-meta">
            <span>{{ m.gender }}</span>
            <span>·</span>
            <span>{{ m.age }}岁</span>
            <span>·</span>
            <span>{{ m.nationality }}</span>
          </div>
        </div>
        <div class="mc-footer">
          <el-button size="small" type="primary" text>查看详情</el-button>
          <span class="mc-used">{{ m.usedIn }}个任务</span>
        </div>
      </div>
    </div>

    <!-- 空 -->
    <div v-if="filteredModels.length === 0" class="empty-view">
      <el-icon class="empty-icon"><User /></el-icon>
      <span>暂无模特</span>
    </div>

    <!-- 添加弹窗 -->
    <el-dialog v-model="showAddDialog" title="添加模特" width="480px">
      <el-form label-width="80px" size="small">
        <el-form-item label="模特名称"><el-input v-model="addForm.name" /></el-form-item>
        <el-form-item label="性别"><el-radio-group v-model="addForm.gender"><el-radio>女</el-radio><el-radio>男</el-radio></el-radio-group></el-form-item>
        <el-form-item label="年龄"><el-input-number v-model="addForm.age" :min="18" :max="60" /></el-form-item>
        <el-form-item label="国籍"><el-input v-model="addForm.nationality" placeholder="如：中国、美国" /></el-form-item>
        <el-form-item label="标签"><el-input v-model="addForm.tagInput" placeholder="用逗号分隔" /></el-form-item>
        <el-form-item label="模特照片">
          <el-upload drag accept="image/*" :auto-upload="false">
            <div class="dialog-upload"><el-icon><UploadFilled /></el-icon><div>上传模特照片</div></div>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="handleAdd">确认添加</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { ElMessage } from 'element-plus'

const keyword = ref('')
const genderFilter = ref('')
const showAddDialog = ref(false)
const addForm = ref({ name: '', gender: '女', age: 25, nationality: '', tagInput: '' })

const stats = ref([
  { num: 16, label: '模特总数' },
  { num: 6, label: '亚洲面孔' },
  { num: 5, label: '欧美面孔' },
  { num: 5, label: '其他地区' }
])

const models = ref([
  { id: 1, name: 'Li Na', emoji: '👩🏻', bg: '#fff0f5', gender: '女', age: 24, nationality: '中国', tags: ['温柔风', '通勤', '彩妆'], favorite: true, usedIn: 28 },
  { id: 2, name: 'Emma Chen', emoji: '👩🏻', bg: '#f5f5f0', gender: '女', age: 26, nationality: '中国', tags: ['时尚', '街拍', '运动'], favorite: true, usedIn: 35 },
  { id: 3, name: 'Sophie Wang', emoji: '👩🏻', bg: '#fce4ec', gender: '女', age: 22, nationality: '中国', tags: ['甜美', '少女', '护肤'], favorite: false, usedIn: 15 },
  { id: 4, name: 'Akira Tanaka', emoji: '👨🏻', bg: '#f0f8ff', gender: '男', age: 28, nationality: '日本', tags: ['商务', '精英', '手表'], favorite: false, usedIn: 12 },
  { id: 5, name: 'Olivia Smith', emoji: '👩🏼', bg: '#fff5ee', gender: '女', age: 23, nationality: '美国', tags: ['欧美风', '运动', '户外'], favorite: false, usedIn: 22 },
  { id: 6, name: 'James Wilson', emoji: '👨🏼', bg: '#f5f5f0', gender: '男', age: 30, nationality: '英国', tags: ['成熟', '绅士', '配饰'], favorite: false, usedIn: 18 },
  { id: 7, name: 'Minji Park', emoji: '👩🏻', bg: '#f3e5f5', gender: '女', age: 21, nationality: '韩国', tags: ['韩系', '少女', '彩妆'], favorite: true, usedIn: 31 },
  { id: 8, name: 'Hana Sato', emoji: '👩🏻', bg: '#fff8e1', gender: '女', age: 27, nationality: '日本', tags: ['知性', '轻熟', '家居'], favorite: false, usedIn: 19 }
])

const filteredModels = computed(() => {
  return models.value.filter(m => {
    if (genderFilter.value && m.gender !== genderFilter.value) return false
    if (keyword.value && !m.name.includes(keyword.value) && !m.tags.some(t => t.includes(keyword.value))) return false
    return true
  })
})

const toggleFav = (m) => {
  m.favorite = !m.favorite
}

const handleAdd = () => {
  if (!addForm.value.name) { ElMessage.warning('请输入名称'); return }
  models.value.unshift({
    id: Date.now(),
    name: addForm.value.name,
    emoji: addForm.value.gender === '男' ? '👨🏻' : '👩🏻',
    bg: addForm.value.gender === '男' ? '#f0f8ff' : '#fff0f5',
    gender: addForm.value.gender,
    age: addForm.value.age,
    nationality: addForm.value.nationality || '中国',
    tags: addForm.value.tagInput ? addForm.value.tagInput.split(',').map(t => t.trim()) : ['通用'],
    favorite: false,
    usedIn: 0
  })
  showAddDialog.value = false
  addForm.value = { name: '', gender: '女', age: 25, nationality: '', tagInput: '' }
  ElMessage.success('添加成功')
}
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; display: flex; flex-direction: column; }
.page-header { display: flex; align-items: center; gap: 10px; margin-bottom: 20px; flex-shrink: 0; }
.page-title { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0; }
.page-badge { font-size: 11px; padding: 2px 10px; border-radius: 10px; color: #fff; font-weight: 600; }
.header-actions { margin-left: auto; display: flex; gap: 8px; }

.stat-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; margin-bottom: 20px; flex-shrink: 0; }
.stat-card { background: #fff; border-radius: 12px; padding: 18px; text-align: center; box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
.s-num { display: block; font-size: 28px; font-weight: 800; background: linear-gradient(135deg, #f093fb, #f5576c); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.s-label { font-size: 12px; color: #999; margin-top: 4px; display: block; }

.toolbar { display: flex; align-items: center; gap: 12px; background: #fff; border-radius: 12px; padding: 12px 18px; margin-bottom: 16px; flex-shrink: 0; }
.tb-filters { display: flex; gap: 6px; }
.tb-tag { font-size: 12px; padding: 5px 14px; border-radius: 14px; cursor: pointer; color: #666; background: #f5f5f5; transition: all 0.2s; }
.tb-tag:hover { background: #fee2e2; color: #f5576c; }
.tb-tag.active { background: linear-gradient(135deg, #f093fb, #f5576c); color: #fff; }
.tb-count { margin-left: auto; font-size: 12px; color: #999; }

.model-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 16px; }
.model-card { background: #fff; border-radius: 14px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.03); transition: all 0.25s; }
.model-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); transform: translateY(-3px); }
.mc-image { height: 200px; display: flex; align-items: center; justify-content: center; position: relative; }
.mc-emoji { font-size: 64px; }
.mc-star, .mc-star-outline { position: absolute; top: 10px; right: 10px; font-size: 18px; cursor: pointer; color: #f59e0b; }
.mc-star-outline { color: #ccc; }
.mc-star-outline:hover { color: #f59e0b; }
.mc-body { padding: 14px 16px 8px; }
.mc-name { font-size: 16px; font-weight: 700; color: #1a1a1a; margin-bottom: 6px; }
.mc-tags { display: flex; gap: 6px; margin-bottom: 6px; }
.mc-tag { font-size: 11px; padding: 2px 8px; background: #fff0f5; color: #f5576c; border-radius: 4px; }
.mc-meta { font-size: 12px; color: #999; display: flex; gap: 4px; }
.mc-footer { display: flex; align-items: center; justify-content: space-between; padding: 8px 16px 12px; border-top: 1px solid #f5f5f5; }
.mc-used { font-size: 11px; color: #bbb; }

.empty-view { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #bbb; gap: 10px; }
.empty-icon { font-size: 56px; }

.dialog-upload { text-align: center; padding: 24px 0; }
</style>
