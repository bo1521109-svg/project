<template>
  <div class="crawler-tasks-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>爬虫任务管理</span>
          <el-button type="primary" @click="showAddDialog = true">添加爬虫任务</el-button>
        </div>
      </template>

      <!-- 爬虫任务列表表格 -->
      <div class="table-container">
        <el-table :data="tasks" style="width: 100%" v-loading="loading">
          <el-table-column prop="id" label="ID" width="80" class-name="mobile-hide" />
          <el-table-column prop="name" label="任务名称" min-width="200" />
          <el-table-column prop="url" label="目标网址" min-width="300" show-overflow-tooltip class-name="mobile-hide" />
          <el-table-column prop="platform" label="平台" width="120" class-name="mobile-hide" />
          <el-table-column prop="status" label="状态" width="120" class-name="mobile-simple">
            <template #default="{ row }">
              <el-tag :type="getStatusType(row.status)">{{ row.status }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="last_crawl_at" label="最后爬取时间" width="180" class-name="mobile-hide">
            <template #default="{ row }">
              {{ formatDate(row.last_crawl_at) }}
            </template>
          </el-table-column>
          <el-table-column label="操作" width="200" fixed="right" class-name="mobile-simple">
            <template #default="{ row }">
              <el-button 
                type="primary" 
                size="small" 
                :loading="row.is_crawling"
                :disabled="row.is_crawling"
                @click="startCrawl(row.id)"
              >
                {{ row.is_crawling ? '爬取中' : '爬取' }}
              </el-button>
              <el-button 
                type="danger" 
                size="small" 
                :disabled="row.is_crawling"
                @click="deleteTask(row)"
              >
                删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-card>

    <!-- 添加爬虫任务对话框 -->
    <el-dialog v-model="showAddDialog" title="添加爬虫任务" width="500px">
      <el-form :model="newTask" label-width="100px">
        <el-form-item label="任务名称" required>
          <el-input v-model="newTask.name" placeholder="请输入任务名称" />
        </el-form-item>
        <el-form-item label="目标网址" required>
          <el-input v-model="newTask.url" placeholder="https://example.com" />
        </el-form-item>
        <el-form-item label="平台">
          <el-input v-model="newTask.platform" placeholder="默认 shopify" />
        </el-form-item>
        <el-form-item label="国家">
          <el-select v-model="newTask.country" placeholder="请选择国家" clearable filterable>
            <el-option label="全部" value="" />
            <el-option label="美国" value="US" />
            <el-option label="印度尼西亚" value="ID" />
            <el-option label="英国" value="GB" />
            <el-option label="越南" value="VN" />
            <el-option label="泰国" value="TH" />
            <el-option label="马来西亚" value="MY" />
            <el-option label="菲律宾" value="PH" />
            <el-option label="西班牙" value="ES" />
            <el-option label="墨西哥" value="MX" />
            <el-option label="德国" value="DE" />
            <el-option label="法国" value="FR" />
            <el-option label="意大利" value="IT" />
            <el-option label="巴西" value="BR" />
            <el-option label="日本" value="JP" />
            <el-option label="新加坡" value="SG" />
          </el-select>
        </el-form-item>
        <el-form-item label="类别">
          <el-select 
            v-model="newTask.category" 
            placeholder="请选择类别" 
            clearable 
            filterable
            @change="handleCategoryChange"
          >
            <el-option 
              v-for="category in categories" 
              :key="category.value" 
              :label="category.label" 
              :value="category.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="子类别" v-if="subCategories.length > 0">
          <el-select v-model="newTask.subCategory" placeholder="请选择子类别" clearable filterable>
            <el-option label="全部" value="" />
            <el-option 
              v-for="subCat in subCategories" 
              :key="subCat.value" 
              :label="subCat.label" 
              :value="subCat.value"
            />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="addTask" :loading="submitting">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../../utils/request'

// 数据
const tasks = ref([])
const loading = ref(false)
const showAddDialog = ref(false)
const submitting = ref(false)
const newTask = ref({
  name: '',
  url: '',
  platform: 'shopify',
  country: '',
  category: '',
  subCategory: ''
})

// 类别选项（与 StoreSearch 保持一致，包含子类目）
const categories = [
  { 
    label: '全部', 
    value: 'all',
    children: []
  },
  { 
    label: '美妆个护', 
    value: 'beauty',
    children: [
      { label: '美妆', value: 'beauty-makeup' },
      { label: '美容护肤', value: 'beauty-skincare' },
      { label: '头部护理与造型', value: 'beauty-hair' },
      { label: '手足及指甲护理', value: 'beauty-nail' },
      { label: '洗浴与身体护理', value: 'beauty-bath' },
      { label: '男士护理', value: 'beauty-men' },
      { label: '美容、个护电器', value: 'beauty-appliance' },
      { label: '眼镜耳朵护理', value: 'beauty-eye-ear' },
      { label: '鼻子口腔护理', value: 'beauty-nose-mouth' },
      { label: '女性私密处护理', value: 'beauty-women-private' },
      { label: '特殊个护', value: 'beauty-special' },
      { label: '香水', value: 'beauty-perfume' }
    ]
  },
  { 
    label: '女装与女士内衣', 
    value: 'women-fashion',
    children: [
      { label: '女士上装', value: 'women-tops' },
      { label: '女士下装', value: 'women-bottoms' },
      { label: '女士连衣裙', value: 'women-dresses' },
      { label: '女士特殊服饰', value: 'women-special' },
      { label: '女士套装与连体衣', value: 'women-suits' },
      { label: '女士内衣', value: 'women-underwear' },
      { label: '女士睡衣和家居服', value: 'women-sleepwear' }
    ]
  },
  { 
    label: '保健', 
    value: 'health',
    children: [
      { label: '保健食品', value: 'health-food' },
      { label: '医疗保健', value: 'health-medical' },
      { label: '非处方药物与疗法', value: 'health-otc' },
      { label: '另类医疗', value: 'health-alternative' },
      { label: '情趣用品', value: 'health-adult' }
    ]
  },
  { 
    label: '时尚配件', 
    value: 'fashion-accessories',
    children: [
      { label: '假发', value: 'accessories-wigs' },
      { label: '服装布料', value: 'accessories-fabric' },
      { label: '服饰配件', value: 'accessories-clothing' },
      { label: '眼镜', value: 'accessories-glasses' },
      { label: '手表与配件', value: 'accessories-watches' },
      { label: '平价饰品', value: 'accessories-jewelry' },
      { label: '发饰', value: 'accessories-hair' }
    ]
  },
  { 
    label: '运动与户外', 
    value: 'sports',
    children: [
      { label: '运动服饰', value: 'sports-clothing' },
      { label: '运动鞋', value: 'sports-shoes' },
      { label: '运动与户外配件', value: 'sports-accessories' },
      { label: '球类运动设备', value: 'sports-ball' },
      { label: '水上运动设备', value: 'sports-water' },
      { label: '冬季运动设备', value: 'sports-winter' },
      { label: '露营与徒步设备', value: 'sports-camping' },
      { label: '健身设备', value: 'sports-fitness' },
      { label: '休闲与室外休闲设备', value: 'sports-leisure' },
      { label: '球迷周边', value: 'sports-fan' },
      { label: '泳装&冲浪服&潜水服', value: 'sports-swimwear' }
    ]
  },
  { 
    label: '手机与数码', 
    value: 'electronics',
    children: [
      { label: '手机配件', value: 'electronics-phone-accessories' },
      { label: '摄影摄像', value: 'electronics-camera' },
      { label: '影音设备', value: 'electronics-audio-video' },
      { label: '游戏设备', value: 'electronics-gaming' },
      { label: '智能及穿戴设备', value: 'electronics-wearable' },
      { label: '电子教育设备', value: 'electronics-education' },
      { label: '通用配件', value: 'electronics-accessories' },
      { label: '平板电脑配件', value: 'electronics-tablet-accessories' },
      { label: '手机与平板', value: 'electronics-phone-tablet' }
    ]
  },
  { 
    label: '居家日用', 
    value: 'home',
    children: [
      { label: '家居收纳', value: 'home-storage' },
      { label: '浴室用品', value: 'home-bathroom' },
      { label: '装饰', value: 'home-decoration' },
      { label: '家庭护理用品', value: 'home-care' },
      { label: '洗衣工具', value: 'home-laundry' },
      { label: '节庆及派对用品', value: 'home-party' },
      { label: '家居日用', value: 'home-daily' }
    ]
  },
  { 
    label: '食品饮料', 
    value: 'food',
    children: [
      { label: '奶与乳制品', value: 'food-dairy' },
      { label: '饮料', value: 'food-beverage' },
      { label: '即食食品', value: 'food-instant' },
      { label: '主食与烹饪调味', value: 'food-staple' },
      { label: '烘焙用品', value: 'food-baking' },
      { label: '零食', value: 'food-snack' },
      { label: '生鲜冷冻食品', value: 'food-fresh' },
      { label: '酒', value: 'food-alcohol' }
    ]
  },
  { 
    label: '汽车与摩托车', 
    value: 'automotive',
    children: [
      { label: '摩托车零部件', value: 'automotive-motorcycle-parts' },
      { label: '汽车电子产品', value: 'automotive-electronics' },
      { label: '外部配件', value: 'automotive-exterior' },
      { label: '内部配件', value: 'automotive-interior' },
      { label: '汽车修理工具', value: 'automotive-tools' },
      { label: '汽车灯', value: 'automotive-lights' },
      { label: '沙滩车、房车、游艇设备', value: 'automotive-recreational' },
      { label: '洗车及保养', value: 'automotive-care' },
      { label: '摩托车配件', value: 'automotive-motorcycle-accessories' },
      { label: '汽车零部件', value: 'automotive-car-parts' },
      { label: '摩托车', value: 'automotive-motorcycle' }
    ]
  },
  { 
    label: '男装与男士内衣', 
    value: 'men-fashion',
    children: [
      { label: '男士上装', value: 'men-tops' },
      { label: '男士下装', value: 'men-bottoms' },
      { label: '男士特殊服饰', value: 'men-special' },
      { label: '男士内衣', value: 'men-underwear' },
      { label: '男士睡衣和家居服', value: 'men-sleepwear' },
      { label: '男士套装与连体衣', value: 'men-suits' }
    ]
  },
  { 
    label: '收藏品', 
    value: 'collectibles',
    children: [
      { label: '当代文化收藏', value: 'collectibles-culture' },
      { label: '收藏卡片及配件', value: 'collectibles-cards' },
      { label: '运动收藏品', value: 'collectibles-sports' },
      { label: '收藏钱币', value: 'collectibles-coins' },
      { label: '娱乐收藏', value: 'collectibles-entertainment' }
    ]
  },
  { 
    label: '玩具和爱好', 
    value: 'toys',
    children: [
      { label: '娃娃与毛绒玩具', value: 'toys-dolls' },
      { label: '益智玩具', value: 'toys-educational' },
      { label: '运动与户外玩具', value: 'toys-outdoor' },
      { label: '电动与遥控玩具', value: 'toys-rc' },
      { label: '棋盘娱乐', value: 'toys-board-games' },
      { label: '传统与创新玩具', value: 'toys-traditional' },
      { label: '乐器与配件', value: 'toys-instruments' },
      { label: 'DIY爱好', value: 'toys-diy' }
    ]
  },
  { 
    label: '厨房用品', 
    value: 'kitchen',
    children: [
      { label: '咖啡用具与茶用具', value: 'kitchen-coffee-tea' },
      { label: '刀具 刀具', value: 'kitchen-knives' },
      { label: '烧烤用具', value: 'kitchen-bbq' },
      { label: '酒具', value: 'kitchen-bar' },
      { label: '烘焙用具', value: 'kitchen-baking' },
      { label: '烹饪工具', value: 'kitchen-cooking' },
      { label: '餐具', value: 'kitchen-tableware' },
      { label: '饮具', value: 'kitchen-drinkware' },
      { label: '厨房器具', value: 'kitchen-appliances' }
    ]
  },
  { 
    label: '家装建材', 
    value: 'home-improvement',
    children: [
      { label: '太阳能与风能设备', value: 'home-improvement-solar' },
      { label: '灯具和照明设备', value: 'home-improvement-lighting' },
      { label: '电气设备及用品', value: 'home-improvement-electrical' },
      { label: '厨房设备', value: 'home-improvement-kitchen' },
      { label: '家庭智能系统', value: 'home-improvement-smart' },
      { label: '建筑用品', value: 'home-improvement-construction' },
      { label: '浴室设备', value: 'home-improvement-bathroom' },
      { label: '安防劳保用品', value: 'home-improvement-safety' },
      { label: '花园用品', value: 'home-improvement-garden' }
    ]
  },
  { 
    label: '电脑办公', 
    value: 'office',
    children: [
      { label: '电脑整机', value: 'office-computers' },
      { label: '电脑 & 笔记本电脑组件', value: 'office-components' },
      { label: '外设产品与配件', value: 'office-peripherals' },
      { label: '数据储存与软件', value: 'office-storage' },
      { label: '网络组件', value: 'office-network' },
      { label: '办公设备', value: 'office-equipment' },
      { label: '办公文具用品', value: 'office-supplies' }
    ]
  },
  { 
    label: '箱包', 
    value: 'bags',
    children: [
      { label: '女包', value: 'bags-women' },
      { label: '男包', value: 'bags-men' },
      { label: '旅行箱包', value: 'bags-travel' },
      { label: '功能箱包', value: 'bags-functional' },
      { label: '箱包配件', value: 'bags-accessories' }
    ]
  },
  { 
    label: '鞋靴', 
    value: 'shoes',
    children: [
      { label: '女鞋', value: 'shoes-women' },
      { label: '男鞋', value: 'shoes-men' },
      { label: '鞋靴配件', value: 'shoes-accessories' }
    ]
  },
  { 
    label: '五金工具', 
    value: 'tools',
    children: [
      { label: '电动工具', value: 'tools-power' },
      { label: '手动工具', value: 'tools-hand' },
      { label: '测量工具', value: 'tools-measuring' },
      { label: '园林工具', value: 'tools-garden' },
      { label: '焊接工具', value: 'tools-welding' },
      { label: '工具收纳', value: 'tools-storage' },
      { label: '五金', value: 'tools-hardware' },
      { label: '泵及管件设施', value: 'tools-plumbing' }
    ]
  },
  { 
    label: '家纺布艺', 
    value: 'textiles',
    children: [
      { label: '床上用品', value: 'textiles-bedding' },
      { label: '居家布艺', value: 'textiles-home-fabric' },
      { label: '布料与手工工具', value: 'textiles-fabric-tools' }
    ]
  },
  { 
    label: '家电', 
    value: 'appliances',
    children: [
      { label: '厨房家电', value: 'appliances-kitchen' },
      { label: '生活家电', value: 'appliances-living' },
      { label: '大家电', value: 'appliances-major' },
      { label: '商用电器', value: 'appliances-commercial' }
    ]
  },
  { 
    label: '宠物用品', 
    value: 'pet',
    children: [
      { label: '猫狗食品', value: 'pet-food' },
      { label: '猫狗家具', value: 'pet-furniture' },
      { label: '猫狗服饰', value: 'pet-clothing' },
      { label: '猫狗如厕用品', value: 'pet-toilet' },
      { label: '猫狗清洁美容', value: 'pet-grooming' },
      { label: '猫狗健康护理', value: 'pet-health' },
      { label: '猫狗配件', value: 'pet-accessories' },
      { label: '水族用品', value: 'pet-aquarium' },
      { label: '爬行两栖用品', value: 'pet-reptile' },
      { label: '鸟用品', value: 'pet-bird' },
      { label: '小宠用品', value: 'pet-small' },
      { label: '农场动物与家禽用品', value: 'pet-farm' }
    ]
  },
  { 
    label: '珠宝与仿生首饰', 
    value: 'jewelry',
    children: [
      { label: '铂&K金', value: 'jewelry-platinum-gold' },
      { label: '黄金', value: 'jewelry-gold' },
      { label: '银', value: 'jewelry-silver' },
      { label: '钻石', value: 'jewelry-diamond' },
      { label: '天然水晶', value: 'jewelry-natural-crystal' },
      { label: '非天然水晶', value: 'jewelry-synthetic-crystal' },
      { label: '玉石', value: 'jewelry-jade' },
      { label: '天然红蓝绿宝石', value: 'jewelry-natural-gemstone' },
      { label: '天然小众宝石', value: 'jewelry-rare-gemstone' },
      { label: '人造宝石', value: 'jewelry-synthetic-gemstone' },
      { label: '珍珠', value: 'jewelry-pearl' },
      { label: '琥珀', value: 'jewelry-amber' },
      { label: '蜜蜡', value: 'jewelry-beeswax' }
    ]
  },
  { 
    label: '图书杂志音像', 
    value: 'books',
    children: [
      { label: '人文社科', value: 'books-humanities' },
      { label: '杂志与报纸', value: 'books-magazines' },
      { label: '文学与艺术', value: 'books-literature' },
      { label: '经济与管理', value: 'books-business' },
      { label: '儿童与婴幼儿图书', value: 'books-children' },
      { label: '生活与爱好', value: 'books-lifestyle' },
      { label: '科技', value: 'books-technology' },
      { label: '教育', value: 'books-education' },
      { label: '影视&音乐', value: 'books-media' }
    ]
  },
  { 
    label: '母婴用品', 
    value: 'baby',
    children: [
      { label: '婴儿服饰与鞋', value: 'baby-clothing' },
      { label: '婴儿外出用品', value: 'baby-outdoor' },
      { label: '哺育用品', value: 'baby-feeding' },
      { label: '婴儿家具', value: 'baby-furniture' },
      { label: '婴儿安全防护用品', value: 'baby-safety' },
      { label: '婴儿玩具', value: 'baby-toys' },
      { label: '婴儿护理与健康', value: 'baby-care' },
      { label: '奶粉与婴儿食品', value: 'baby-food' },
      { label: '孕产用品', value: 'baby-maternity' },
      { label: '婴儿时尚配件', value: 'baby-accessories' }
    ]
  },
  { 
    label: '家具', 
    value: 'furniture',
    children: [
      { label: '家具辅料', value: 'furniture-accessories' },
      { label: '室内家具', value: 'furniture-indoor' },
      { label: '室外家具', value: 'furniture-outdoor' },
      { label: '儿童家具', value: 'furniture-children' },
      { label: '商用家具', value: 'furniture-commercial' }
    ]
  },
  { 
    label: '儿童时尚', 
    value: 'kids-fashion',
    children: [
      { label: '男童服饰', value: 'kids-boys-clothing' },
      { label: '女童服饰', value: 'kids-girls-clothing' },
      { label: '男童鞋', value: 'kids-boys-shoes' },
      { label: '女童鞋', value: 'kids-girls-shoes' },
      { label: '儿童时尚配件', value: 'kids-accessories' }
    ]
  },
  { 
    label: '穆斯林时尚', 
    value: 'muslim-fashion',
    children: [
      { label: '面纱', value: 'muslim-veil' },
      { label: '女士穆斯林服饰', value: 'muslim-women-clothing' },
      { label: '男士穆斯林服装', value: 'muslim-men-clothing' },
      { label: '外套', value: 'muslim-outerwear' },
      { label: '儿童穆斯林服装', value: 'muslim-children-clothing' },
      { label: '穆斯林配饰', value: 'muslim-accessories' },
      { label: '祈祷用品', value: 'muslim-prayer' },
      { label: '穆斯林运动服饰', value: 'muslim-sportswear' },
      { label: '乌姆罗', value: 'muslim-umrah' }
    ]
  },
  { 
    label: '二手', 
    value: 'second-hand',
    children: [
      { label: '收藏交易卡', value: 'second-hand-trading-cards' },
      { label: '时尚配饰', value: 'second-hand-fashion-accessories' },
      { label: '包', value: 'second-hand-bags' },
      { label: '鞋类', value: 'second-hand-shoes' },
      { label: '男士服装', value: 'second-hand-men-clothing' },
      { label: '女士服装', value: 'second-hand-women-clothing' },
      { label: '翻新手机和电子产品', value: 'second-hand-electronics' },
      { label: '行李箱和旅行用品', value: 'second-hand-luggage' },
      { label: '手表', value: 'second-hand-watches' }
    ]
  },
  { 
    label: '虚拟商品', 
    value: 'virtual',
    children: [
      { label: '电信', value: 'virtual-telecom' }
    ]
  },
  { 
    label: 'POD定制', 
    value: 'pod-custom',
    children: []
  },
  { 
    label: '成人用品', 
    value: 'adult-products',
    children: []
  },
  { 
    label: '文化', 
    value: 'culture',
    children: []
  }
]

// 当前选中类别的子类目列表
const subCategories = computed(() => {
  const selectedCat = categories.find(cat => cat.value === newTask.value.category)
  return selectedCat?.children || []
})

// 获取爬虫任务列表
const fetchTasks = async () => {
  loading.value = true
  try {
    const response = await request.get('/v1/admin/crawler/tasks')
    tasks.value = response.data
  } catch (error) {
    ElMessage.error('获取爬虫任务列表失败：' + (error.response?.data?.detail || error.message))
  } finally {
    loading.value = false
  }
}

// 添加爬虫任务
const addTask = async () => {
  if (!newTask.value.name || !newTask.value.url) {
    ElMessage.warning('请填写任务名称和目标网址')
    return
  }

  submitting.value = true
  try {
    // 构建请求数据，将前端字段映射到后端字段
    const requestData = {
      name: newTask.value.name,
      url: newTask.value.url,
      platform: newTask.value.platform,
      country: newTask.value.country,
      target_country_code: newTask.value.country || null,  // 映射国家代码
      target_category_code: newTask.value.subCategory || newTask.value.category || null  // 优先使用子类目，否则使用一级类目
    }
    
    await request.post('/v1/admin/crawler/tasks', requestData)
    ElMessage.success('添加爬虫任务成功')
    showAddDialog.value = false
    newTask.value = { name: '', url: '', platform: 'shopify', country: '', category: '', subCategory: '' }
    fetchTasks()
  } catch (error) {
    ElMessage.error('添加爬虫任务失败：' + (error.response?.data?.detail || error.message))
  } finally {
    submitting.value = false
  }
}

// 开始爬取
const startCrawl = async (taskId) => {
  try {
    // 更新本地状态
    const task = tasks.value.find(t => t.id === taskId)
    if (task) {
      task.is_crawling = true
    }

    const response = await request.post(`/v1/admin/crawler/tasks/${taskId}/crawl`)
    ElMessage.success(response.data.message || '爬取任务已启动')
    
    // 定时刷新状态
    setTimeout(() => {
      fetchTasks()
    }, 3000)
  } catch (error) {
    ElMessage.error('启动爬取失败：' + (error.response?.data?.detail || error.message))
    // 恢复状态
    const task = tasks.value.find(t => t.id === taskId)
    if (task) {
      task.is_crawling = false
    }
  }
}

// 删除爬虫任务
const deleteTask = async (task) => {
  try {
    // 二次确认
    await ElMessageBox.confirm(
      `确定要删除爬虫任务"${task.name}"吗？此操作将同时删除该任务下的所有数据，且不可恢复！`,
      '警告',
      {
        confirmButtonText: '确定删除',
        cancelButtonText: '取消',
        type: 'warning',
        confirmButtonClass: 'el-button--danger'
      }
    )

    // 执行删除
    const response = await request.delete(`/v1/admin/crawler/tasks/${task.id}`)
    ElMessage.success(response.data.message || '爬虫任务删除成功')
    
    // 刷新列表
    fetchTasks()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除爬虫任务失败：' + (error.response?.data?.detail || error.message))
    }
  }
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleString('zh-CN')
}

// 获取状态标签类型
const getStatusType = (status) => {
  const typeMap = {
    'active': 'success',
    'paused': 'warning',
    'error': 'danger'
  }
  return typeMap[status] || 'info'
}

// 处理一级类别变化
const handleCategoryChange = () => {
  // 清空子类别选择
  newTask.value.subCategory = ''
}

// 页面加载时获取数据
onMounted(() => {
  fetchTasks()
})
</script>

<style scoped>
.crawler-tasks-container {
  padding: 20px;
  height: 100%;
  box-sizing: border-box;
}

.crawler-tasks-container .el-card {
  height: 100%;
  display: flex;
  flex-direction: column;
  border-radius: 8px;
}

.crawler-tasks-container :deep(.el-card__body) {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

.crawler-tasks-container :deep(.el-card__body)::-webkit-scrollbar {
  width: 6px;
}

.crawler-tasks-container :deep(.el-card__body)::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.crawler-tasks-container :deep(.el-card__body)::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.crawler-tasks-container :deep(.el-card__body)::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.table-container {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

:deep(.el-table) {
  min-width: 800px;
}

/* 移动端优化 */
@media (max-width: 768px) {
  .crawler-tasks-container {
    padding: 10px;
  }

  .card-header {
    flex-direction: column;
    gap: 10px;
    align-items: stretch;
  }

  .card-header .el-button {
    width: 100%;
  }

  :deep(.mobile-hide) {
    display: none !important;
  }

  :deep(.mobile-simple .cell) {
    padding: 5px !important;
  }
}
</style>
