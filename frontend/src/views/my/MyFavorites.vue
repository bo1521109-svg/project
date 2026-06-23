<template>
  <div class="my-favorites">
    <div class="page-header">
      <h2 class="page-title">我的收藏</h2>
      <p class="page-desc">管理您收藏的创意素材与产品</p>
    </div>

    <!-- 统计卡片 -->
    <div class="stat-cards">
      <div class="stat-card" v-for="stat in stats" :key="stat.label">
        <div class="stat-icon" :style="{ background: stat.bg }">
          <el-icon :size="20"><component :is="stat.icon" /></el-icon>
        </div>
        <div class="stat-info">
          <div class="stat-value">{{ stat.value }}</div>
          <div class="stat-label">{{ stat.label }}</div>
        </div>
      </div>
    </div>

    <!-- 筛选栏 -->
    <div class="filter-bar">
      <el-segmented v-model="activeTab" :options="tabs" size="default" />
      <el-input
        v-model="searchQuery"
        placeholder="搜索收藏内容..."
        :prefix-icon="Search"
        clearable
        class="search-input"
      />
    </div>

    <!-- 收藏列表 -->
    <div class="favorites-grid" v-loading="loading">
      <div
        class="favorite-card"
        v-for="item in filteredItems"
        :key="item.id"
        @click="handleClick(item)"
      >
        <div class="card-image">
          <div class="image-placeholder" :style="{ background: item.bgColor }">
            <el-icon :size="36"><component :is="item.typeIcon" /></el-icon>
          </div>
          <el-tag
            :type="item.typeTagType"
            size="small"
            class="type-badge"
          >{{ item.typeLabel }}</el-tag>
          <div class="card-actions">
            <el-button
              :type="item.starred ? 'warning' : 'default'"
              :icon="Star"
              circle
              size="small"
              @click.stop="toggleStar(item)"
            />
            <el-button
              type="danger"
              :icon="Delete"
              circle
              size="small"
              @click.stop="handleDelete(item)"
            />
          </div>
        </div>
        <div class="card-body">
          <h4 class="card-title">{{ item.title }}</h4>
          <p class="card-desc">{{ item.description }}</p>
          <div class="card-meta">
            <span class="meta-tag">
              <el-icon :size="12"><Clock /></el-icon>
              {{ item.createTime }}
            </span>
            <span class="meta-tag" v-if="item.source">
              <el-icon :size="12"><Link /></el-icon>
              {{ item.source }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- 空状态 -->
    <el-empty v-if="!loading && filteredItems.length === 0" description="暂无收藏内容" />

    <!-- 分页 -->
    <div class="pagination-wrapper" v-if="filteredItems.length > 0">
      <el-pagination
        v-model:current-page="currentPage"
        :page-size="pageSize"
        :total="filteredItems.length"
        layout="prev, pager, next"
        background
        small
      />
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import {
  Star,
  Delete,
  Clock,
  Link,
  Search,
  VideoCamera,
  PictureFilled,
  ShoppingCart,
  MagicStick,
  FolderOpened
} from '@element-plus/icons-vue'

const loading = ref(false)
const activeTab = ref('全部')
const searchQuery = ref('')
const currentPage = ref(1)
const pageSize = ref(8)

const tabs = ['全部', '视频素材', '图片素材', '产品', 'AI创作']

const stats = [
  { label: '总收藏', value: 48, icon: Star, bg: 'linear-gradient(135deg, #667eea, #764ba2)' },
  { label: '本周新增', value: 12, icon: MagicStick, bg: 'linear-gradient(135deg, #f093fb, #f5576c)' },
  { label: '已使用', value: 23, icon: ShoppingCart, bg: 'linear-gradient(135deg, #4facfe, #00f2fe)' },
  { label: '分类数', value: 5, icon: FolderOpened, bg: 'linear-gradient(135deg, #43e97b, #38f9d7)' },
]

const favorites = ref([
  { id: 1, title: '爆款口播种草视频模板', description: 'TikTok美妆品类高转化视频素材，含文案与分镜脚本', type: '视频素材', typeIcon: VideoCamera, typeTagType: 'primary', typeLabel: '视频', source: 'TikTok', createTime: '2026-06-15', starred: true, bgColor: 'linear-gradient(135deg, #a18cd1, #fbc2eb)' },
  { id: 2, title: '夏季连衣裙产品主图', description: '法式复古碎花连衣裙高清产品图10张套图', type: '图片素材', typeIcon: PictureFilled, typeTagType: 'success', typeLabel: '图片', source: 'Pinterest', createTime: '2026-06-14', starred: true, bgColor: 'linear-gradient(135deg, #fad0c4, #ffd1ff)' },
  { id: 3, title: '无线蓝牙耳机供应链', description: '深圳工厂直供ANC降噪蓝牙耳机，MOQ 500pcs', type: '产品', typeIcon: ShoppingCart, typeTagType: 'warning', typeLabel: '产品', source: '1688', createTime: '2026-06-13', starred: false, bgColor: 'linear-gradient(135deg, #a1c4fd, #c2e9fb)' },
  { id: 4, title: 'AI生成模特试穿效果图', description: '利用Seedance生成的春季新品模特上身效果预览', type: 'AI创作', typeIcon: MagicStick, typeTagType: 'danger', typeLabel: 'AI创作', source: 'Seedance', createTime: '2026-06-12', starred: true, bgColor: 'linear-gradient(135deg, #ffecd2, #fcb69f)' },
  { id: 5, title: 'Instagram开箱视频参考', description: '欧美博主子品类开箱视频，互动率8.2%', type: '视频素材', typeIcon: VideoCamera, typeTagType: 'primary', typeLabel: '视频', source: 'Instagram', createTime: '2026-06-11', starred: false, bgColor: 'linear-gradient(135deg, #89f7fe, #66a6ff)' },
  { id: 6, title: '瑜伽服场景摆拍图集', description: '户外瑜伽场景产品拍摄方案，含30张高质量原图', type: '图片素材', typeIcon: PictureFilled, typeTagType: 'success', typeLabel: '图片', source: 'Pinterest', createTime: '2026-06-10', starred: true, bgColor: 'linear-gradient(135deg, #d4fc79, #96e6a1)' },
  { id: 7, title: '便携式咖啡机选品', description: 'USB充电便携意式咖啡机，客单价$39.99，利润率42%', type: '产品', typeIcon: ShoppingCart, typeTagType: 'warning', typeLabel: '产品', source: 'Amazon', createTime: '2026-06-09', starred: false, bgColor: 'linear-gradient(135deg, #fccb90, #d57eeb)' },
  { id: 8, title: '一键换衣效果展示', description: '模特换衣功能生成的10套搭配方案对比图', type: 'AI创作', typeIcon: MagicStick, typeTagType: 'danger', typeLabel: 'AI创作', source: 'AI工具', createTime: '2026-06-08', starred: false, bgColor: 'linear-gradient(135deg, #e0c3fc, #8ec5fc)' },
  { id: 9, title: 'YouTube广告素材拆解', description: '头部DTC品牌30秒广告片拆解分析，含分镜与话术', type: '视频素材', typeIcon: VideoCamera, typeTagType: 'primary', typeLabel: '视频', source: 'YouTube', createTime: '2026-06-07', starred: true, bgColor: 'linear-gradient(135deg, #f5576c, #f093fb)' },
  { id: 10, title: '宠物用品场景图', description: '猫狗用品居家场景拍摄参考，温馨日系风格', type: '图片素材', typeIcon: PictureFilled, typeTagType: 'success', typeLabel: '图片', source: 'Pinterest', createTime: '2026-06-06', starred: false, bgColor: 'linear-gradient(135deg, #4facfe, #00f2fe)' },
  { id: 11, title: '智能手表爆品分析', description: '华强北智能手表深度拆解，功能对比与定价策略', type: '产品', typeIcon: ShoppingCart, typeTagType: 'warning', typeLabel: '产品', source: '速卖通', createTime: '2026-06-05', starred: true, bgColor: 'linear-gradient(135deg, #fa709a, #fee140)' },
  { id: 12, title: 'AI短视频脚本生成', description: '利用AI生成的30条产品种草短视频口播脚本', type: 'AI创作', typeIcon: MagicStick, typeTagType: 'danger', typeLabel: 'AI创作', source: 'AI工具', createTime: '2026-06-04', starred: false, bgColor: 'linear-gradient(135deg, #30cfd0, #330867)' },
])

const filteredItems = computed(() => {
  let items = favorites.value
  if (activeTab.value !== '全部') {
    items = items.filter(i => i.type === activeTab.value)
  }
  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase()
    items = items.filter(i =>
      i.title.toLowerCase().includes(q) ||
      i.description.toLowerCase().includes(q) ||
      i.source.toLowerCase().includes(q)
    )
  }
  return items
})

const toggleStar = (item) => {
  item.starred = !item.starred
}

const handleDelete = (item) => {
  favorites.value = favorites.value.filter(i => i.id !== item.id)
}

const handleClick = (item) => {
  console.log('查看收藏详情:', item.title)
}
</script>

<style scoped>
.my-favorites {
  padding: 24px;
  max-width: 1400px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 24px;
}

.page-title {
  font-size: 22px;
  font-weight: 700;
  color: #1a1a2e;
  margin: 0 0 4px;
}

.page-desc {
  font-size: 13px;
  color: #909399;
  margin: 0;
}

/* 统计卡片 */
.stat-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}

.stat-card {
  background: #fff;
  border-radius: 10px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 14px;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.06);
  transition: transform 0.2s, box-shadow 0.2s;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  flex-shrink: 0;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #1a1a2e;
  line-height: 1;
}

.stat-label {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}

/* 筛选栏 */
.filter-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
  gap: 16px;
  flex-wrap: wrap;
}

.search-input {
  width: 260px;
}

/* 收藏网格 */
.favorites-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}

.favorite-card {
  background: #fff;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.06);
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
}

.favorite-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
}

.card-image {
  height: 120px;
  position: relative;
  overflow: hidden;
}

.image-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: rgba(255, 255, 255, 0.8);
}

.type-badge {
  position: absolute;
  top: 8px;
  left: 8px;
}

.card-actions {
  position: absolute;
  bottom: 8px;
  right: 8px;
  display: flex;
  gap: 6px;
  opacity: 0;
  transition: opacity 0.2s;
}

.favorite-card:hover .card-actions {
  opacity: 1;
}

.card-body {
  padding: 14px;
}

.card-title {
  font-size: 14px;
  font-weight: 600;
  color: #1a1a2e;
  margin: 0 0 6px;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-desc {
  font-size: 12px;
  color: #909399;
  margin: 0 0 10px;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 11px;
  color: #c0c4cc;
}

.meta-tag {
  display: flex;
  align-items: center;
  gap: 3px;
}

/* 分页 */
.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 8px;
}

@media (max-width: 1200px) {
  .stat-cards { grid-template-columns: repeat(2, 1fr); }
  .favorites-grid { grid-template-columns: repeat(3, 1fr); }
}

@media (max-width: 768px) {
  .favorites-grid { grid-template-columns: repeat(2, 1fr); }
}
</style>
