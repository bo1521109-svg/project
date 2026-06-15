<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">海外工厂</h2>
      <p class="page-desc">海外代工厂与供应链资源，覆盖东南亚、南亚等主要制造基地</p>
    </div>
    <div class="page-body">
      <el-table :data="tableData" style="width: 100%">
        <el-table-column prop="name" label="工厂名称" min-width="180" />
        <el-table-column prop="country" label="所在国家" width="120" />
        <el-table-column prop="industry" label="行业" min-width="140" />
        <el-table-column prop="scale" label="规模" width="100" />
        <el-table-column prop="capacity" label="月产能" sortable width="120" />
        <el-table-column prop="moq" label="起订量" width="100" />
        <el-table-column prop="cert" label="资质" min-width="160" />
        <el-table-column prop="clients" label="合作品牌" min-width="140" />
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tableData = ref([
  { name: '越兴纺织制衣厂', country: '越南', industry: '服装纺织', scale: '大型', capacity: '50万件', moq: '1000件', cert: 'ISO9001/BSCI', clients: 'Nike/Adidas代工' },
  { name: '泰达电子组装厂', country: '泰国', industry: '电子组装', scale: '中型', capacity: '20万台', moq: '500台', cert: 'ISO9001/CE', clients: '三星/小米供应链' },
  { name: '印尼家具制造公司', country: '印尼', industry: '家具制造', scale: '大型', capacity: '5万件', moq: '100件', cert: 'FSC/ISO14001', clients: '宜家/Wayfair' },
  { name: '柬埔寨成衣工厂', country: '柬埔寨', industry: '服装纺织', scale: '中型', capacity: '30万件', moq: '2000件', cert: 'WRAP/GOTS', clients: 'Zara/H&M供应商' },
  { name: '孟加拉皮革制品厂', country: '孟加拉', industry: '皮革制品', scale: '大型', capacity: '10万件', moq: '500件', cert: 'LWG/SEDEX', clients: '欧美品牌代工' },
  { name: '印度精密零件厂', country: '印度', industry: '精密制造', scale: '中型', capacity: '8万件', moq: '200件', cert: 'ISO9001/TS16949', clients: '汽车零部件供应链' },
  { name: '墨西哥包装印刷厂', country: '墨西哥', industry: '包装印刷', scale: '小型', capacity: '100万件', moq: '5000件', cert: 'ISO9001', clients: '本地品牌/美墨贸易' },
  { name: '菲律宾电子元器件厂', country: '菲律宾', industry: '电子元器件', scale: '中型', capacity: '50万件', moq: '1000件', cert: 'ISO9001/UL', clients: '日系品牌供应链' },
])
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { margin-bottom: 24px; }
.page-title { font-size: 20px; font-weight: 700; color: #1a1a1a; margin: 0 0 8px 0; }
.page-desc { font-size: 14px; color: #8c8c8c; margin: 0; }
.page-body { background: #fff; border-radius: 8px; padding: 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.04); }
</style>
