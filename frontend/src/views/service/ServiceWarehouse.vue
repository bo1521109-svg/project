<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">海外仓</h2>
      <p class="page-desc">全球海外仓资源，支持一件代发、退货处理、FBA中转等服务</p>
    </div>
    <div class="page-body">
      <div class="stat-row">
        <div class="stat-item"><span class="stat-num">6</span><span class="stat-text">覆盖大区</span></div>
        <div class="stat-item"><span class="stat-num">23</span><span class="stat-text">覆盖国家</span></div>
        <div class="stat-item"><span class="stat-num">60</span><span class="stat-text">仓储城市</span></div>
        <div class="stat-item"><span class="stat-num">86%</span><span class="stat-text">可用率</span></div>
      </div>
      <div v-for="group in warehouseGroups" :key="group.region" class="region-section">
        <div class="region-title">{{ group.flag }} {{ group.region }}</div>
        <div class="warehouse-grid">
          <div class="warehouse-card" v-for="w in group.warehouses" :key="w.city">
            <div class="wh-header">
              <span class="wh-country">{{ w.flag }} {{ w.country }}</span>
              <span class="wh-city">{{ w.city }}</span>
              <el-tag :type="w.status === '空闲' ? 'success' : w.status === '繁忙' ? 'warning' : 'info'" size="small">{{ w.status }}</el-tag>
            </div>
            <div class="wh-body">
              <div class="wh-info"><span class="lbl">仓库面积</span><span class="val">{{ w.area }}㎡</span></div>
              <div class="wh-info"><span class="lbl">日处理量</span><span class="val">{{ w.capacity }}单</span></div>
              <div class="wh-info"><span class="lbl">仓储费</span><span class="val">${{ w.storageFee }}/m³/月</span></div>
              <div class="wh-info"><span class="lbl">操作费</span><span class="val">${{ w.opsFee }}/单</span></div>
            </div>
            <div class="wh-services">
              <span class="service-tag" v-for="s in w.services" :key="s">{{ s }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const warehouseGroups = ref([
  {
    flag: '🇺🇸', region: '美国',
    warehouses: [
      { flag: '🇺🇸', country: '美国', city: '纽瓦克(新泽西)', status: '繁忙', area: 5000, capacity: 3000, storageFee: 4.0, opsFee: 1.5, services: ['一件代发', '质检拍照'] },
      { flag: '🇺🇸', country: '美国', city: '泽西市(新泽西)', status: '空闲', area: 3500, capacity: 2000, storageFee: 3.8, opsFee: 1.4, services: ['一件代发', '退货处理'] },
      { flag: '🇺🇸', country: '美国', city: '纽约(纽约州)', status: '繁忙', area: 6000, capacity: 4000, storageFee: 5.0, opsFee: 2.0, services: ['一件代发', 'FBA中转', '退货处理'] },
      { flag: '🇺🇸', country: '美国', city: '费城(宾夕法尼亚)', status: '空闲', area: 4000, capacity: 2200, storageFee: 3.5, opsFee: 1.3, services: ['一件代发', '贴标换标'] },
      { flag: '🇺🇸', country: '美国', city: '洛杉矶(加利福尼亚)', status: '空闲', area: 8000, capacity: 5000, storageFee: 3.5, opsFee: 1.2, services: ['一件代发', 'FBA中转', '退货处理'] },
      { flag: '🇺🇸', country: '美国', city: '安大略(加利福尼亚)', status: '空闲', area: 4500, capacity: 2800, storageFee: 3.2, opsFee: 1.1, services: ['一件代发', 'FBA中转'] },
      { flag: '🇺🇸', country: '美国', city: '旧金山(加利福尼亚)', status: '繁忙', area: 5500, capacity: 3500, storageFee: 4.5, opsFee: 1.8, services: ['一件代发', '退货处理', '质检拍照'] },
      { flag: '🇺🇸', country: '美国', city: '拉斯维加斯(内华达)', status: '空闲', area: 3000, capacity: 1800, storageFee: 3.0, opsFee: 1.0, services: ['一件代发', '贴标换标'] },
      { flag: '🇺🇸', country: '美国', city: '芝加哥(伊利诺伊)', status: '空闲', area: 6000, capacity: 3800, storageFee: 3.6, opsFee: 1.4, services: ['一件代发', 'FBA中转', '退货处理'] },
      { flag: '🇺🇸', country: '美国', city: '西雅图(华盛顿州)', status: '空闲', area: 4000, capacity: 2500, storageFee: 4.2, opsFee: 1.6, services: ['一件代发', '质检拍照'] },
      { flag: '🇺🇸', country: '美国', city: '休斯顿(得克萨斯)', status: '空闲', area: 5000, capacity: 3200, storageFee: 3.3, opsFee: 1.2, services: ['一件代发', 'FBA中转'] },
      { flag: '🇺🇸', country: '美国', city: '达拉斯(得克萨斯)', status: '繁忙', area: 4500, capacity: 2800, storageFee: 3.4, opsFee: 1.3, services: ['一件代发', '退货处理', '贴标换标'] },
      { flag: '🇺🇸', country: '美国', city: '奥斯汀(得克萨斯)', status: '空闲', area: 2800, capacity: 1600, storageFee: 3.1, opsFee: 1.1, services: ['一件代发'] },
      { flag: '🇺🇸', country: '美国', city: '迈阿密(佛罗里达)', status: '空闲', area: 3500, capacity: 2000, storageFee: 3.8, opsFee: 1.5, services: ['一件代发', 'FBA中转'] },
      { flag: '🇺🇸', country: '美国', city: '亚特兰大(左治亚)', status: '空闲', area: 4000, capacity: 2400, storageFee: 3.2, opsFee: 1.2, services: ['一件代发', '退货处理'] },
      { flag: '🇺🇸', country: '美国', city: '查尔斯顿(南卡)', status: '空闲', area: 2500, capacity: 1400, storageFee: 2.8, opsFee: 1.0, services: ['一件代发'] }
    ]
  },
  {
    flag: '🌏', region: '东南亚',
    warehouses: [
      { flag: '🇮🇩', country: '印尼', city: '雅加达', status: '繁忙', area: 4000, capacity: 2500, storageFee: 2.0, opsFee: 0.6, services: ['一件代发', '退货处理'] },
      { flag: '🇮🇩', country: '印尼', city: '唐格朗', status: '空闲', area: 3000, capacity: 1800, storageFee: 1.8, opsFee: 0.5, services: ['一件代发'] },
      { flag: '🇮🇩', country: '印尼', city: '勿加泗', status: '空闲', area: 2500, capacity: 1500, storageFee: 1.5, opsFee: 0.5, services: ['一件代发', '贴标换标'] },
      { flag: '🇻🇳', country: '越南', city: '胡志明', status: '空闲', area: 3500, capacity: 2200, storageFee: 1.8, opsFee: 0.5, services: ['一件代发', '退货处理'] },
      { flag: '🇻🇳', country: '越南', city: '河内', status: '空闲', area: 2800, capacity: 1600, storageFee: 1.6, opsFee: 0.4, services: ['一件代发'] },
      { flag: '🇹🇭', country: '泰国', city: '曼谷', status: '繁忙', area: 4500, capacity: 3000, storageFee: 2.2, opsFee: 0.7, services: ['一件代发', 'FBA中转', '退货处理'] },
      { flag: '🇲🇾', country: '马来西亚', city: '吉隆坡', status: '空闲', area: 3200, capacity: 2000, storageFee: 2.0, opsFee: 0.6, services: ['一件代发', '质检拍照'] },
      { flag: '🇵🇭', country: '菲律宾', city: '大马尼拉都会区', status: '空闲', area: 3000, capacity: 1800, storageFee: 1.8, opsFee: 0.5, services: ['一件代发'] },
      { flag: '🇸🇬', country: '新加坡', city: '新加坡', status: '繁忙', area: 5000, capacity: 3500, storageFee: 3.5, opsFee: 1.2, services: ['一件代发', 'FBA中转', '退货处理', '质检拍照'] }
    ]
  },
  {
    flag: '🇪🇺', region: '欧洲',
    warehouses: [
      { flag: '🇩🇪', country: '德国', city: '鲁尔区', status: '空闲', area: 5500, capacity: 3500, storageFee: 4.2, opsFee: 1.6, services: ['一件代发', 'FBA中转'] },
      { flag: '🇩🇪', country: '德国', city: '法兰克福', status: '繁忙', area: 6000, capacity: 4000, storageFee: 4.5, opsFee: 1.8, services: ['一件代发', 'FBA中转', '退货处理'] },
      { flag: '🇩🇪', country: '德国', city: '汉堡', status: '空闲', area: 4000, capacity: 2500, storageFee: 4.0, opsFee: 1.5, services: ['一件代发', '退货处理'] },
      { flag: '🇩🇪', country: '德国', city: '柏林', status: '空闲', area: 3500, capacity: 2200, storageFee: 4.3, opsFee: 1.7, services: ['一件代发', '贴标换标'] },
      { flag: '🇩🇪', country: '德国', city: '科隆', status: '空闲', area: 3000, capacity: 1800, storageFee: 3.8, opsFee: 1.4, services: ['一件代发'] },
      { flag: '🇬🇧', country: '英国', city: '大伦敦区', status: '繁忙', area: 5500, capacity: 3800, storageFee: 4.8, opsFee: 2.0, services: ['一件代发', 'FBA中转', '退货处理'] },
      { flag: '🇬🇧', country: '英国', city: '曼彻斯特', status: '空闲', area: 3500, capacity: 2000, storageFee: 4.2, opsFee: 1.6, services: ['一件代发', '贴标换标'] },
      { flag: '🇬🇧', country: '英国', city: '伯明翰', status: '空闲', area: 2800, capacity: 1600, storageFee: 3.8, opsFee: 1.4, services: ['一件代发'] },
      { flag: '🇬🇧', country: '英国', city: '利物浦', status: '空闲', area: 2500, capacity: 1400, storageFee: 3.5, opsFee: 1.3, services: ['一件代发', '退货处理'] },
      { flag: '🇫🇷', country: '法国', city: '大巴黎区', status: '空闲', area: 5000, capacity: 3200, storageFee: 4.5, opsFee: 1.8, services: ['一件代发', 'FBA中转', '退货处理'] },
      { flag: '🇫🇷', country: '法国', city: '里尔', status: '空闲', area: 2500, capacity: 1500, storageFee: 3.5, opsFee: 1.3, services: ['一件代发'] },
      { flag: '🇫🇷', country: '法国', city: '里昂', status: '空闲', area: 3000, capacity: 1800, storageFee: 3.8, opsFee: 1.4, services: ['一件代发', '贴标换标'] },
      { flag: '🇫🇷', country: '法国', city: '马赛', status: '空闲', area: 2800, capacity: 1600, storageFee: 3.6, opsFee: 1.3, services: ['一件代发', '退货处理'] },
      { flag: '🇮🇹', country: '意大利', city: '罗马', status: '空闲', area: 3200, capacity: 1800, storageFee: 4.0, opsFee: 1.5, services: ['一件代发', '质检拍照'] },
      { flag: '🇮🇹', country: '意大利', city: '米兰', status: '繁忙', area: 4000, capacity: 2500, storageFee: 4.2, opsFee: 1.6, services: ['一件代发', 'FBA中转', '退货处理'] },
      { flag: '🇪🇸', country: '西班牙', city: '马德里', status: '空闲', area: 3500, capacity: 2000, storageFee: 3.8, opsFee: 1.4, services: ['一件代发', '退货处理'] },
      { flag: '🇪🇸', country: '西班牙', city: '巴塞罗那', status: '空闲', area: 3000, capacity: 1800, storageFee: 3.5, opsFee: 1.3, services: ['一件代发', 'FBA中转'] },
      { flag: '🇧🇪', country: '比利时', city: '列日', status: '空闲', area: 2800, capacity: 1600, storageFee: 3.6, opsFee: 1.4, services: ['一件代发'] },
      { flag: '🇧🇪', country: '比利时', city: '安特卫普', status: '空闲', area: 3200, capacity: 2000, storageFee: 3.8, opsFee: 1.5, services: ['一件代发', '退货处理'] },
      { flag: '🇳🇱', country: '荷兰', city: '阿姆斯特丹', status: '繁忙', area: 4500, capacity: 3000, storageFee: 4.5, opsFee: 1.8, services: ['一件代发', 'FBA中转', '退货处理'] },
      { flag: '🇳🇱', country: '荷兰', city: '鹿特丹', status: '空闲', area: 3800, capacity: 2500, storageFee: 4.2, opsFee: 1.6, services: ['一件代发', 'FBA中转'] },
      { flag: '🇵🇱', country: '波兰', city: '华沙', status: '空闲', area: 2800, capacity: 1600, storageFee: 3.0, opsFee: 1.0, services: ['一件代发', '贴标换标'] }
    ]
  },
  {
    flag: '🌎', region: '拉美',
    warehouses: [
      { flag: '🇧🇷', country: '巴西', city: '圣保罗', status: '空闲', area: 4000, capacity: 2400, storageFee: 3.0, opsFee: 1.0, services: ['一件代发', '退货处理'] },
      { flag: '🇧🇷', country: '巴西', city: '里约', status: '空闲', area: 3000, capacity: 1800, storageFee: 2.8, opsFee: 0.9, services: ['一件代发'] },
      { flag: '🇧🇷', country: '巴西', city: '维多利亚', status: '空闲', area: 2200, capacity: 1200, storageFee: 2.5, opsFee: 0.8, services: ['一件代发'] },
      { flag: '🇨🇱', country: '智利', city: '圣地亚哥', status: '空闲', area: 2800, capacity: 1600, storageFee: 3.2, opsFee: 1.1, services: ['一件代发', '退货处理'] },
      { flag: '🇨🇴', country: '哥伦比亚', city: '波哥大', status: '空闲', area: 2500, capacity: 1400, storageFee: 2.8, opsFee: 0.9, services: ['一件代发'] },
      { flag: '🇵🇪', country: '秘鲁', city: '利马', status: '空闲', area: 2200, capacity: 1200, storageFee: 2.6, opsFee: 0.8, services: ['一件代发'] }
    ]
  },
  {
    flag: '🏔️', region: '中亚',
    warehouses: [
      { flag: '🇰🇿', country: '哈萨克斯坦', city: '阿拉木图', status: '空闲', area: 3000, capacity: 1800, storageFee: 2.5, opsFee: 0.8, services: ['一件代发'] },
      { flag: '🇰🇿', country: '哈萨克斯坦', city: '阿斯塔纳', status: '空闲', area: 2500, capacity: 1500, storageFee: 2.2, opsFee: 0.7, services: ['一件代发', '贴标换标'] },
      { flag: '🇺🇿', country: '乌兹别克斯坦', city: '塔什干', status: '空闲', area: 2200, capacity: 1200, storageFee: 2.0, opsFee: 0.6, services: ['一件代发'] }
    ]
  },
  {
    flag: '🗾', region: '东亚',
    warehouses: [
      { flag: '🇰🇷', country: '韩国', city: '仁川', status: '空闲', area: 3500, capacity: 2200, storageFee: 4.0, opsFee: 1.5, services: ['一件代发', '退货处理'] },
      { flag: '🇰🇷', country: '韩国', city: '首尔', status: '繁忙', area: 4500, capacity: 3000, storageFee: 4.5, opsFee: 1.8, services: ['一件代发', 'FBA中转', '退货处理'] },
      { flag: '🇯🇵', country: '日本', city: '关东圈', status: '繁忙', area: 5000, capacity: 3500, storageFee: 5.0, opsFee: 2.0, services: ['一件代发', 'FBA中转', '退货处理', '质检拍照'] },
      { flag: '🇯🇵', country: '日本', city: '关西圈', status: '空闲', area: 4000, capacity: 2800, storageFee: 4.8, opsFee: 1.8, services: ['一件代发', '退货处理', '质检拍照'] }
    ]
  }
])
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { margin-bottom: 24px; }
.page-title { font-size: 20px; font-weight: 700; color: #1a1a1a; margin: 0 0 8px 0; }
.page-desc { font-size: 14px; color: #8c8c8c; margin: 0; }
.page-body { background: #fff; border-radius: 8px; padding: 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.04); }
.stat-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; }
.stat-item { background: linear-gradient(135deg, #f5f0ff, #faf8ff); border: 1px solid #ece6ff; border-radius: 12px; padding: 20px; text-align: center; }
.stat-num { display: block; font-size: 28px; font-weight: 700; background: linear-gradient(135deg, #7c4dff, #9b7ff7); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
.stat-text { font-size: 13px; color: #8c8c8c; margin-top: 4px; display: block; }
.region-section { margin-bottom: 24px; }
.region-title { font-size: 16px; font-weight: 600; color: #1a1a1a; margin-bottom: 12px; padding-left: 4px; }
.warehouse-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px; }
.warehouse-card { padding: 16px; border: 1px solid #f0f0f0; border-radius: 12px; transition: all 0.2s; }
.warehouse-card:hover { border-color: #7c4dff; box-shadow: 0 2px 12px rgba(124,77,255,0.1); }
.wh-header { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; }
.wh-country { font-size: 13px; font-weight: 600; color: #1a1a1a; }
.wh-city { font-size: 12px; color: #8c8c8c; flex: 1; }
.wh-body { display: grid; grid-template-columns: 1fr 1fr; gap: 6px; margin-bottom: 10px; }
.wh-info { font-size: 12px; }
.wh-info .lbl { color: #8c8c8c; }
.wh-info .val { color: #262626; font-weight: 500; margin-left: 4px; }
.wh-services { display: flex; flex-wrap: wrap; gap: 5px; }
.service-tag { font-size: 11px; color: #7c4dff; background: #f5f0ff; padding: 2px 7px; border-radius: 4px; }
</style>
