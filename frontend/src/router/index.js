import { createRouter, createWebHistory } from 'vue-router'
import MainLayout from '../layout/MainLayout.vue'
import Stores from '../views/Stores.vue'
import Products from '../views/Products.vue'
import Profile from '../views/Profile.vue'
import Login from '../views/Login.vue'
import { useUserStore } from '../stores/user'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: { title: '登录', requiresAuth: false }
  },
  {
    path: '/',
    component: MainLayout,
    redirect: '/stores',
    meta: { requiresAuth: true }, // 需要登录
    children: [
      {
        path: '/stores',
        name: 'Stores',
        component: Stores,
        meta: { title: '店铺管理', requiresAuth: true }
      },
      {
        path: '/products',
        name: 'Products',
        component: Products,
        meta: { title: '商品列表', requiresAuth: true }
      },
      {
        path: '/profile',
        name: 'Profile',
        component: Profile,
        meta: { title: '个人中心', requiresAuth: true }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 全局路由守卫
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  const isLoggedIn = userStore.isLoggedIn()

  // 访问需要登录的页面（/stores, /products 等）
  if (to.meta.requiresAuth && !isLoggedIn) {
    // 无 token，重定向到登录页
    next('/login')
  } 
  // 已登录用户访问登录页，重定向到店铺管理
  else if (to.path === '/login' && isLoggedIn) {
    next('/stores')
  } 
  // 其他情况正常放行
  else {
    next()
  }
})

export default router
