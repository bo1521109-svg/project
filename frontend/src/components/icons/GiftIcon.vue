<template>
  <svg 
    viewBox="0 0 1024 1024" 
    xmlns="http://www.w3.org/2000/svg"
    fill="none"
    stroke="currentColor"
    stroke-width="60"
    stroke-linecap="round"
    stroke-linejoin="round"
  >
    <!-- 礼物盒主体 -->
    <rect x="200" y="400" width="624" height="500" />
    
    <!-- 礼物盒盖子 -->
    <rect x="150" y="280" width="724" height="120" />
    
    <!-- 蝴蝶结 - 左边 -->
    <path d="M 380 280 Q 280 200 200 280" />
    <path d="M 380 280 Q 280 360 200 280" />
    
    <!-- 蝴蝶结 - 右边 -->
    <path d="M 644 280 Q 744 200 824 280" />
    <path d="M 644 280 Q 744 360 824 280" />
    
    <!-- 蝴蝶结中心结 -->
    <circle cx="512" cy="280" r="40" />
    
    <!-- 垂直丝带 -->
    <line x1="512" y1="280" x2="512" y2="900" />
    
    <!-- 水平丝带 -->
    <line x1="150" y1="340" x2="874" y2="340" />
  </svg>
</template>

<script setup>
</script>

<style scoped>
svg {
  width: 1em;
  height: 1em;
  vertical-align: middle;
}
</style>
