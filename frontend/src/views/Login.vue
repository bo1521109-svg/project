<template>
  <div class="login-container">
    <el-card class="login-card">
      <template #header>
        <div class="card-title">
          {{ isLoginMode ? '登录' : '注册' }}
        </div>
      </template>

      <el-form :model="formData" :rules="rules" ref="formRef" label-width="80px">
        <el-form-item label="用户名" prop="username">
          <el-input 
            v-model="formData.username" 
            placeholder="请输入用户名"
            clearable
          />
        </el-form-item>

        <el-form-item label="密码" prop="password">
          <el-input 
            v-model="formData.password" 
            type="password" 
            placeholder="请输入密码"
            show-password
            clearable
          />
        </el-form-item>

        <!-- 注册模式显示邀请码 -->
        <el-form-item v-if="!isLoginMode" label="邀请码" prop="invitation_code">
          <el-input 
            v-model="formData.invitation_code" 
            placeholder="请输入邀请码（注册时显示）"
            clearable
          />
        </el-form-item>

        <el-form-item>
          <el-button 
            type="primary" 
            @click="handleSubmit" 
            :loading="loading"
            style="width: 100%"
          >
            {{ isLoginMode ? '登录' : '注册' }}
          </el-button>
        </el-form-item>

        <el-form-item>
          <el-button 
            type="text" 
            @click="toggleMode"
            style="width: 100%"
          >
            {{ isLoginMode ? '没有账号？去注册' : '已有账号？去登录' }}
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import request from '../utils/request'
import { useUserStore } from '../stores/user'

const router = useRouter()
const userStore = useUserStore()

// 数据
const isLoginMode = ref(true) // true: 登录模式, false: 注册模式
const loading = ref(false)
const formRef = ref(null)

const formData = reactive({
  username: '',
  password: '',
  invitation_code: ''
})

// 表单验证规则
const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 50, message: '用户名长度在 3 到 50 个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少 6 个字符', trigger: 'blur' }
  ]
}

// 切换登录/注册模式
const toggleMode = () => {
  isLoginMode.value = !isLoginMode.value
  formData.invitation_code = ''
  formRef.value?.clearValidate()
}

// 提交表单
const handleSubmit = async () => {
  try {
    await formRef.value.validate()
    
    loading.value = true

    if (isLoginMode.value) {
      // 登录
      await handleLogin()
    } else {
      // 注册
      await handleRegister()
    }
  } catch (error) {
    console.error('表单验证失败', error)
  } finally {
    loading.value = false
  }
}

// 处理登录
const handleLogin = async () => {
  try {
    const response = await request.post('/v1/auth/login', {
      username: formData.username,
      password: formData.password
    })

    const { access_token, user_info } = response.data

    // 保存 token 和用户信息
    userStore.login(access_token, user_info)

    ElMessage.success('登录成功')
    
    // 跳转到店铺管理页面
    router.push('/stores')
  } catch (error) {
    ElMessage.error('登录失败：' + (error.response?.data?.detail || error.message))
  }
}

// 处理注册
const handleRegister = async () => {
  try {
    const payload = {
      username: formData.username,
      password: formData.password
    }

    // 如果填写了邀请码，添加到请求中
    if (formData.invitation_code) {
      payload.invitation_code = formData.invitation_code
    }

    const response = await request.post('/v1/auth/register', payload)

    ElMessage.success(`注册成功！您的邀请码：${response.data.invitation_code}`)
    
    // 切换到登录模式
    isLoginMode.value = true
    formData.password = ''
    formData.invitation_code = ''
  } catch (error) {
    const errorMsg = error.response?.data?.detail || error.message
    if (errorMsg.includes('用户名已存在')) {
      ElMessage.error('用户名已存在，请更换用户名')
    } else if (errorMsg.includes('邀请码不存在')) {
      ElMessage.error('邀请码不存在，请检查或联系推荐人')
    } else {
      ElMessage.error('注册失败：' + errorMsg)
    }
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-card {
  width: 400px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.card-title {
  text-align: center;
  font-size: 24px;
  font-weight: bold;
  color: #303133;
}

/* 移动端适配 */
@media (max-width: 768px) {
  .login-card {
    width: 90%;
    margin: 20px;
  }
}
</style>
