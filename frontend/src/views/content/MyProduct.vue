<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">我的产品</h2>
      <span class="page-badge" style="background:linear-gradient(135deg,#667eea,#764ba2)">产品库</span>
      <div class="header-actions">
        <el-button type="primary" @click="showAddDialog = true"><el-icon><Plus /></el-icon> 添加产品</el-button>
        <el-upload class="batch-upload" multiple accept="image/*" :show-file-list="false">
          <el-button><el-icon><Upload /></el-icon> 批量导入</el-button>
        </el-upload>
      </div>
    </div>

    <!-- 统计 -->
    <div class="stat-row">
      <div class="stat-item" v-for="s in stats" :key="s.label">
        <span class="stat-icon">{{ s.icon }}</span>
        <div class="stat-info">
          <span class="stat-num">{{ s.num }}</span>
          <span class="stat-label">{{ s.label }}</span>
        </div>
      </div>
    </div>

    <!-- 工具栏 -->
    <div class="toolbar">
      <el-input v-model="keyword" placeholder="搜索产品名称..." class="search-input" clearable>
        <template #prefix><el-icon><Search /></el-icon></template>
      </el-input>
      <el-select v-model="catFilter" placeholder="全部分类" style="width:140px" clearable>
        <el-option v-for="c in categories" :key="c" :label="c" :value="c" />
      </el-select>
      <span class="toolbar-count">共 {{ filteredProducts.length }} 个产品</span>
      <div class="toolbar-right">
        <span class="view-tog" :class="{ active: viewMode === 'grid' }" @click="viewMode = 'grid'"><el-icon><Grid /></el-icon></span>
        <span class="view-tog" :class="{ active: viewMode === 'list' }" @click="viewMode = 'list'"><el-icon><List /></el-icon></span>
      </div>
    </div>

    <!-- 网格视图 -->
    <div v-if="viewMode === 'grid'" class="product-grid">
      <div v-for="p in filteredProducts" :key="p.id" class="product-card">
        <div class="pc-thumb" :style="{ background: p.bg }">
          <span class="pc-emoji">{{ p.emoji }}</span>
          <div class="pc-actions">
            <el-button size="small" circle @click="ElMessage.info('预览 ' + p.name)"><el-icon><ZoomIn /></el-icon></el-button>
            <el-button size="small" circle type="danger" @click="handleDelete(p)"><el-icon><Delete /></el-icon></el-button>
          </div>
          <span class="pc-cat">{{ p.category }}</span>
        </div>
        <div class="pc-body">
          <div class="pc-name">{{ p.name }}</div>
          <div class="pc-meta">
            <span>{{ p.size }}</span>
            <span>·</span>
            <span>{{ p.format }}</span>
          </div>
          <div class="pc-date">{{ p.date }}</div>
        </div>
      </div>
    </div>

    <!-- 列表视图 -->
    <div v-else class="product-list">
      <div class="pl-header">
        <span style="width: 60px">预览</span>
        <span style="flex:1">名称</span>
        <span style="width: 80px">分类</span>
        <span style="width: 80px">大小</span>
        <span style="width: 120px">上传时间</span>
        <span style="width: 80px">操作</span>
      </div>
      <div v-for="p in filteredProducts" :key="p.id" class="pl-row">
        <div class="pl-thumb" :style="{ background: p.bg }"><span class="pl-emoji">{{ p.emoji }}</span></div>
        <span class="pl-name">{{ p.name }}</span>
        <el-tag size="small" type="info">{{ p.category }}</el-tag>
        <span class="pl-size">{{ p.size }}</span>
        <span class="pl-date">{{ p.date }}</span>
        <div class="pl-ops">
          <el-button size="small" text><el-icon><ZoomIn /></el-icon></el-button>
          <el-button size="small" text type="danger" @click="handleDelete(p)"><el-icon><Delete /></el-icon></el-button>
        </div>
      </div>
    </div>

    <!-- 空状态 -->
    <div v-if="filteredProducts.length === 0" class="empty-view">
      <el-icon class="empty-icon"><PictureFilled /></el-icon>
      <span>暂无产品，点击"添加产品"开始</span>
    </div>

    <!-- 添加弹窗 -->
    <el-dialog v-model="showAddDialog" title="添加产品" width="520px">
      <el-form label-width="80px" size="small">
        <el-form-item label="产品名称"><el-input v-model="addForm.name" placeholder="输入产品名称" /></el-form-item>
        <el-form-item label="分类"><el-select v-model="addForm.category" placeholder="选择分类" style="width:100%"><el-option v-for="c in categories" :key="c" :label="c" :value="c" /></el-select></el-form-item>
        <el-form-item label="产品图片">
          <el-upload drag accept="image/*" :auto-upload="false" :show-file-list="true">
            <div class="dialog-upload"><el-icon><UploadFilled /></el-icon><div>拖拽或点击上传</div></div>
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
import { ElMessage, ElMessageBox } from 'element-plus'

const keyword = ref('')
const catFilter = ref('')
const viewMode = ref('grid')
const showAddDialog = ref(false)
const addForm = ref({ name: '', category: '' })

const stats = ref([
  { icon: '📦', num: 47, label: '产品总数' },
  { icon: '📁', num: 8, label: '分类数' },
  { icon: '💾', num: '128MB', label: '占用空间' },
  { icon: '📅', num: '3天前', label: '最近更新' }
])

const categories = ref(['3C数码', '美妆护肤', '服装配饰', '家居日用', '食品饮料', '运动户外', '玩具礼品', '其他'])

const products = ref([
  { id: 1, name: 'WH-1000XM5 头戴式降噪耳机', category: '3C数码', emoji: '🎧', bg: '#f5f0ff', size: '2.4MB', format: 'PNG', date: '2026-06-05' },
  { id: 2, name: '夏季冰丝防晒袖套', category: '服装配饰', emoji: '🧤', bg: '#e8f5e9', size: '1.1MB', format: 'PNG', date: '2026-06-04' },
  { id: 3, name: '珍珠水光气垫霜', category: '美妆护肤', emoji: '💄', bg: '#fce4ec', size: '3.2MB', format: 'PNG', date: '2026-06-04' },
  { id: 4, name: '智能LED护眼台灯', category: '家居日用', emoji: '💡', bg: '#fff8e1', size: '2.8MB', format: 'JPG', date: '2026-06-03' },
  { id: 5, name: '磁吸无线充电宝10000mAh', category: '3C数码', emoji: '🔋', bg: '#e3f2fd', size: '1.8MB', format: 'PNG', date: '2026-06-03' },
  { id: 6, name: '有机黑芝麻核桃粉', category: '食品饮料', emoji: '🫙', bg: '#fff3e0', size: '2.1MB', format: 'JPG', date: '2026-06-02' },
  { id: 7, name: '情侣款运动跑鞋', category: '运动户外', emoji: '👟', bg: '#f3e5f5', size: '4.5MB', format: 'PNG', date: '2026-06-02' },
  { id: 8, name: '生日惊喜礼盒套装', category: '玩具礼品', emoji: '🎁', bg: '#fce4ec', size: '3.6MB', format: 'PNG', date: '2026-06-01' },
  { id: 9, name: '超声波去黑头仪', category: '美妆护肤', emoji: '✨', bg: '#ffebee', size: '1.5MB', format: 'JPG', date: '2026-06-01' },
  { id: 10, name: '便携折叠露营椅', category: '运动户外', emoji: '⛺', bg: '#e8f5e9', size: '2.3MB', format: 'PNG', date: '2026-05-30' },
  { id: 11, name: 'Type-C 6合1扩展坞', category: '3C数码', emoji: '🔌', bg: '#ede7f6', size: '1.2MB', format: 'PNG', date: '2026-05-29' },
  { id: 12, name: '日式简约硅藻泥地垫', category: '家居日用', emoji: '🧽', bg: '#f5f5f5', size: '2.7MB', format: 'JPG', date: '2026-05-28' }
])

const filteredProducts = computed(() => {
  return products.value.filter(p => {
    if (keyword.value && !p.name.includes(keyword.value)) return false
    if (catFilter.value && p.category !== catFilter.value) return false
    return true
  })
})

const handleDelete = (p) => {
  ElMessageBox.confirm(`确认删除「${p.name}」？`, '确认删除', { type: 'warning' }).then(() => {
    products.value = products.value.filter(item => item.id !== p.id)
    ElMessage.success('删除成功')
  }).catch(() => {})
}

const handleAdd = () => {
  if (!addForm.value.name) {
    ElMessage.warning('请输入产品名称')
    return
  }
  products.value.unshift({
    id: Date.now(),
    name: addForm.value.name,
    category: addForm.value.category || '其他',
    emoji: '📦',
    bg: '#f5f7fa',
    size: '1.0MB',
    format: 'PNG',
    date: new Date().toISOString().slice(0, 10)
  })
  showAddDialog.value = false
  addForm.value = { name: '', category: '' }
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
.stat-item { display: flex; align-items: center; gap: 12px; background: #fff; border-radius: 12px; padding: 16px 18px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
.stat-icon { font-size: 28px; }
.stat-info { display: flex; flex-direction: column; }
.stat-num { font-size: 22px; font-weight: 700; color: #1a1a1a; }
.stat-label { font-size: 12px; color: #999; }

.toolbar { display: flex; align-items: center; gap: 12px; background: #fff; border-radius: 12px; padding: 12px 18px; margin-bottom: 16px; flex-shrink: 0; }
.search-input { width: 220px; }
.toolbar-count { font-size: 12px; color: #999; }
.toolbar-right { margin-left: auto; display: flex; gap: 2px; background: #f0f2f5; border-radius: 6px; padding: 2px; }
.view-tog { width: 28px; height: 28px; display: flex; align-items: center; justify-content: center; border-radius: 4px; cursor: pointer; color: #aaa; }
.view-tog.active { background: #fff; color: #333; box-shadow: 0 1px 3px rgba(0,0,0,0.06); }

.product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 14px; }
.product-card { background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.03); transition: all 0.25s; }
.product-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); transform: translateY(-2px); }
.pc-thumb { height: 160px; display: flex; align-items: center; justify-content: center; position: relative; }
.pc-emoji { font-size: 48px; }
.pc-actions { position: absolute; bottom: 8px; right: 8px; display: flex; gap: 4px; opacity: 0; transition: opacity 0.2s; }
.pc-thumb:hover .pc-actions { opacity: 1; }
.pc-cat { position: absolute; top: 8px; left: 8px; font-size: 10px; padding: 2px 8px; background: rgba(0,0,0,0.45); color: #fff; border-radius: 4px; }
.pc-body { padding: 10px 12px; }
.pc-name { font-size: 13px; font-weight: 600; color: #1a1a1a; line-height: 1.4; margin-bottom: 4px; }
.pc-meta { font-size: 11px; color: #aaa; display: flex; gap: 4px; }
.pc-date { font-size: 10px; color: #ccc; margin-top: 2px; }

.product-list { background: #fff; border-radius: 12px; overflow: hidden; }
.pl-header { display: flex; align-items: center; gap: 10px; padding: 12px 16px; background: #fafafa; font-size: 12px; color: #999; font-weight: 600; }
.pl-row { display: flex; align-items: center; gap: 10px; padding: 12px 16px; border-bottom: 1px solid #f5f5f5; transition: background 0.15s; }
.pl-row:hover { background: #fafafa; }
.pl-thumb { width: 48px; height: 48px; border-radius: 8px; display: flex; align-items: center; justify-content: center; }
.pl-emoji { font-size: 22px; }
.pl-name { flex: 1; font-size: 13px; color: #333; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.pl-size { font-size: 12px; color: #999; width: 80px; }
.pl-date { font-size: 12px; color: #bbb; width: 120px; }
.pl-ops { width: 80px; display: flex; gap: 2px; }

.empty-view { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #bbb; gap: 10px; }
.empty-icon { font-size: 56px; }

.dialog-upload { text-align: center; padding: 24px 0; }
</style>
