<template>
  <div class="permission-management">
    <el-card>
      <h3>角色权限管理</h3>
      
      <el-tabs v-model="activeTab" type="border-card">
        <el-tab-pane label="角色列表" name="roles">
          <el-table :data="roles" style="width: 100%" v-loading="loading">
            <el-table-column prop="role_key" label="角色标识" width="150" />
            <el-table-column prop="role_name" label="角色名称" width="150" />
            <el-table-column prop="description" label="描述" />
            <el-table-column prop="user_count" label="用户数量" width="120" />
            <el-table-column label="权限" width="400">
              <template #default="{ row }">
                <el-tag
                  v-for="perm in row.permissions"
                  :key="perm"
                  style="margin-right: 5px; margin-bottom: 5px"
                  size="small"
                >
                  {{ getPermissionName(perm) }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <el-tab-pane label="权限列表" name="permissions">
          <div class="filter-bar">
            <el-select v-model="moduleFilter" placeholder="模块筛选" style="width: 200px" @change="fetchPermissions">
              <el-option label="全部模块" value="" />
              <el-option label="管理员模块" value="admin" />
              <el-option label="数据模块" value="data" />
              <el-option label="内容模块" value="content" />
              <el-option label="社媒模块" value="social" />
              <el-option label="用户模块" value="user" />
            </el-select>
          </div>

          <el-table :data="permissions" style="width: 100%; margin-top: 20px" v-loading="loading">
            <el-table-column prop="permission_key" label="权限标识" width="200" />
            <el-table-column prop="permission_name" label="权限名称" width="150" />
            <el-table-column prop="description" label="描述" />
            <el-table-column prop="module" label="所属模块" width="120">
              <template #default="{ row }">
                <el-tag :type="getModuleType(row.module)">
                  {{ getModuleName(row.module) }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import axios from 'axios'

const activeTab = ref('roles')
const loading = ref(false)
const roles = ref([])
const permissions = ref([])
const moduleFilter = ref('')

const permissionNameMap = {
  user_management: '用户管理',
  crawler_management: '爬虫管理',
  system_config: '系统配置',
  data_export: '数据导出',
  log_view: '日志查看',
  data_view: '数据查看',
  content_create: '内容创作',
  social_manage: '社媒管理',
  personal_center: '个人中心'
}

const moduleNameMap = {
  admin: '管理员',
  data: '数据',
  content: '内容',
  social: '社媒',
  user: '用户'
}

const getPermissionName = (key) => {
  return permissionNameMap[key] || key
}

const getModuleName = (module) => {
  return moduleNameMap[module] || module
}

const getModuleType = (module) => {
  const typeMap = {
    admin: 'danger',
    data: 'primary',
    content: 'success',
    social: 'warning',
    user: 'info'
  }
  return typeMap[module] || ''
}

const fetchRoles = async () => {
  loading.value = true
  try {
    const token = localStorage.getItem('token')
    const response = await axios.get('/api/v1/admin/permissions', {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (response.data.code === 200) {
      roles.value = response.data.data.roles
    }
  } catch (error) {
    ElMessage.error('获取角色列表失败')
    console.error('获取角色列表失败:', error)
  } finally {
    loading.value = false
  }
}

const fetchPermissions = async () => {
  loading.value = true
  try {
    const token = localStorage.getItem('token')
    const params = {}
    if (moduleFilter.value) {
      params.module = moduleFilter.value
    }
    
    const response = await axios.get('/api/v1/admin/permissions/permissions', {
      headers: { Authorization: `Bearer ${token}` },
      params
    })
    if (response.data.code === 200) {
      permissions.value = response.data.data.permissions
    }
  } catch (error) {
    ElMessage.error('获取权限列表失败')
    console.error('获取权限列表失败:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchRoles()
  fetchPermissions()
})
</script>

<style scoped>
.permission-management {
  padding: 20px;
}

h3 {
  margin: 0 0 20px 0;
  font-size: 18px;
  font-weight: 600;
}

.filter-bar {
  margin-bottom: 10px;
}
</style>
