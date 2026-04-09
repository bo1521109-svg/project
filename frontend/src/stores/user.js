/**
 * 用户状态管理 (Pinia Store)
 */
import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useUserStore = defineStore('user', () => {
  // 状态
  const token = ref(localStorage.getItem('token') || '')
  const userInfo = ref(JSON.parse(localStorage.getItem('userInfo') || 'null'))

  // 设置 Token
  const setToken = (newToken) => {
    token.value = newToken
    localStorage.setItem('token', newToken)
  }

  // 设置用户信息
  const setUserInfo = (info) => {
    userInfo.value = info
    localStorage.setItem('userInfo', JSON.stringify(info))
  }

  // 登录
  const login = (tokenData, userData) => {
    setToken(tokenData)
    setUserInfo(userData)
  }

  // 登出
  const logout = () => {
    token.value = ''
    userInfo.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
  }

  // 检查是否已登录
  const isLoggedIn = () => {
    return !!token.value
  }

  return {
    token,
    userInfo,
    setToken,
    setUserInfo,
    login,
    logout,
    isLoggedIn
  }
})
