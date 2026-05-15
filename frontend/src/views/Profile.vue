<template>
  <div class="profile-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>个人中心</span>
        </div>
      </template>

      <el-descriptions :column="1" border>
        <el-descriptions-item label="用户名">
          {{ userInfo?.username || '-' }}
        </el-descriptions-item>
        <el-descriptions-item label="我的邀请码">
          <div class="invitation-code">
            <span class="code-text">{{ userInfo?.invitation_code || '-' }}</span>
            <el-button 
              type="primary" 
              size="small" 
              @click="copyInvitationCode"
              style="margin-left: 10px"
            >
              复制
            </el-button>
          </div>
        </el-descriptions-item>
        <el-descriptions-item label="注册时间">
          {{ formatDate(userInfo?.created_at) }}
        </el-descriptions-item>
        <el-descriptions-item label="邀请人数">
          {{ invitedCount }} 人
        </el-descriptions-item>
      </el-descriptions>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '../stores/user'
import request from '../utils/request'

const userStore = useUserStore()
const invitedCount = ref(0)

// 从 store 获取用户信息
const userInfo = computed(() => userStore.userInfo)

// 获取完整的用户信息（包括邀请人数）
const fetchUserInfo = async () => {
  try {
    const response = await request.get('/v1/auth/users/me')
    invitedCount.value = response.data.invited_count || 0
  } catch (error) {
    console.error('获取用户信息失败', error)
  }
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleString('zh-CN')
}

// 复制邀请码
const copyInvitationCode = async () => {
  const code = userInfo.value?.invitation_code
  if (!code) {
    ElMessage.warning('邀请码不存在')
    return
  }

  try {
    await navigator.clipboard.writeText(code)
    ElMessage.success('邀请码已复制到剪贴板')
  } catch (error) {
    // 降级方案：使用传统方法复制
    const textarea = document.createElement('textarea')
    textarea.value = code
    textarea.style.position = 'fixed'
    textarea.style.opacity = '0'
    document.body.appendChild(textarea)
    textarea.select()
    try {
      document.execCommand('copy')
      ElMessage.success('邀请码已复制到剪贴板')
    } catch (err) {
      ElMessage.error('复制失败，请手动复制')
    }
    document.body.removeChild(textarea)
  }
}

// 页面加载时获取数据
onMounted(() => {
  fetchUserInfo()
})
</script>

<style scoped>
.profile-container {
  padding: 0;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.profile-container .el-card {
  height: 100%;
  display: flex;
  flex-direction: column;
  border-radius: 0;
  border: none;
}

.profile-container :deep(.el-card__body) {
  flex: 1;
  overflow: auto;
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 18px;
  font-weight: bold;
}

.invitation-code {
  display: flex;
  align-items: center;
}

.code-text {
  font-size: 18px;
  font-weight: bold;
  color: #409EFF;
  letter-spacing: 2px;
}

/* 移动端适配 */
@media (max-width: 768px) {
  .profile-container {
    padding: 10px;
  }

  .code-text {
    font-size: 16px;
  }
}
</style>
