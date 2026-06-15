<template>
  <div class="page-container">
    <div class="page-header">
      <h2 class="page-title">资质办理</h2>
      <p class="page-desc">跨境电商合规资质代办服务，含FDA、CE、FCC等国际认证</p>
    </div>
    <div class="page-body">
      <div class="qual-grid">
        <div class="qual-card" v-for="q in qualifications" :key="q.name">
          <div class="qual-icon">{{ q.icon }}</div>
          <div class="qual-name">{{ q.name }}</div>
          <div class="qual-desc">{{ q.desc }}</div>
          <div class="qual-meta">
            <span class="meta-item">适用区域：{{ q.region }}</span>
            <span class="meta-item">周期：{{ q.time }}</span>
            <span class="meta-price">${{ q.price }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const qualifications = ref([
  { icon: '🏥', name: 'FDA认证', desc: '美国食品药品监督管理局注册', region: '美国', time: '15-30天', price: '800起' },
  { icon: '🔌', name: 'CE认证', desc: '欧盟强制性安全合格标志', region: '欧盟', time: '10-20天', price: '500起' },
  { icon: '📡', name: 'FCC认证', desc: '美国联邦通信委员会认证', region: '美国', time: '7-15天', price: '600起' },
  { icon: '🔋', name: 'RoHS认证', desc: '有害物质限制指令合规', region: '欧盟', time: '5-10天', price: '400起' },
  { icon: '🧸', name: 'CPC认证', desc: '儿童产品安全证书', region: '美国', time: '7-14天', price: '350起' },
  { icon: '📋', name: 'ISO9001', desc: '质量管理体系认证', region: '全球', time: '30-60天', price: '2000起' },
  { icon: '🏷️', name: '商标注册', desc: '美国/欧盟/日本商标注册', region: '多区域', time: '6-12月', price: '500起' },
  { icon: '📦', name: 'MSDS报告', desc: '化学品安全技术说明书', region: '全球', time: '3-5天', price: '200起' },
  { icon: '🌿', name: '有机认证', desc: 'USDA有机产品认证', region: '美国', time: '3-6月', price: '1500起' },
])
</script>

<style scoped>
.page-container { padding: 24px; height: calc(100vh - 120px); overflow: auto; background: #f0f2f5; }
.page-header { margin-bottom: 24px; }
.page-title { font-size: 20px; font-weight: 700; color: #1a1a1a; margin: 0 0 8px 0; }
.page-desc { font-size: 14px; color: #8c8c8c; margin: 0; }
.page-body { background: #fff; border-radius: 8px; padding: 24px; box-shadow: 0 1px 4px rgba(0,0,0,0.04); }
.qual-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; }
.qual-card { padding: 20px; border: 1px solid #f0f0f0; border-radius: 12px; transition: all 0.2s; }
.qual-card:hover { border-color: #7c4dff; box-shadow: 0 2px 12px rgba(124,77,255,0.1); }
.qual-icon { font-size: 32px; margin-bottom: 8px; }
.qual-name { font-size: 16px; font-weight: 600; color: #1a1a1a; margin-bottom: 4px; }
.qual-desc { font-size: 13px; color: #8c8c8c; margin-bottom: 12px; }
.qual-meta { display: flex; flex-direction: column; gap: 4px; }
.meta-item { font-size: 12px; color: #666; }
.meta-price { font-size: 16px; font-weight: 700; color: #7c4dff; margin-top: 4px; }
</style>
