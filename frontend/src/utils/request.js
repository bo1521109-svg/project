/**
 * Axios 请求配置
 * 自动添加 JWT Token 到请求头
 */
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { useUserStore } from '../stores/user'
import router from '../router'

// 创建 axios 实例
const request = axios.create({
  baseURL: '/api',
  timeout: 30000
})

// 请求拦截器：添加 token
request.interceptors.request.use(
  (config) => {
    const userStore = useUserStore()
    const token = userStore.token

    // 如果有 token，添加到请求头
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }

    return config
  },
  (error) => {
    console.error('请求错误', error)
    return Promise.reject(error)
  }
)

// 响应拦截器：处理错误
request.interceptors.response.use(
  (response) => {
    return response
  },
  (error) => {
    if (error.response) {
      const { status, data } = error.response

      // 401 未授权：token 过期或无效
      if (status === 401) {
        const userStore = useUserStore()
        userStore.logout()
        ElMessage.error('登录已过期，请重新登录')
        router.push('/login')
      } 
      // 其他错误
      else {
        ElMessage.error(data.detail || '请求失败')
      }
    } else {
      ElMessage.error('网络错误，请检查网络连接')
    }

    return Promise.reject(error)
  }
)

export default request
