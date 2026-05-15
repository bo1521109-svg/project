<template>
  <div class="placeholder-container">
    <el-empty :description="description">
      <template #image>
        <el-icon :size="100" color="#909399">
          <Tools />
        </el-icon>
      </template>
      <el-button type="primary" @click="contactAdmin">联系管理员</el-button>
    </el-empty>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Tools } from '@element-plus/icons-vue'

const route = useRoute()

// 从路由 meta 中获取标题，动态生成描述
const description = computed(() => {
  const title = route.meta?.title || '该模块'
  return `${title} 功能开发中，敬请期待`
})

const contactAdmin = () => {
  ElMessage.info('如需了解更多信息，请联系管理员')
}
</script>

<style scoped>
.placeholder-container {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  padding: 0;
  background: #f5f7fa;
}

.el-empty {
  padding: 60px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}
</style>
