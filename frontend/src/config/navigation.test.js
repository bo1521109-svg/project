/**
 * 导航配置测试文件
 * 
 * 用于验证导航配置的正确性
 */

import { navigationConfig, adminNavigation, getFilteredNav, getAccessiblePaths } from './navigation.js'

console.log('=' .repeat(60))
console.log('导航配置测试')
console.log('=' .repeat(60))

// 测试1：基础导航结构
console.log('\n1. 基础导航结构（一级导航）:')
navigationConfig.forEach((item, index) => {
  console.log(`  ${index + 1}. ${item.name} (${item.path})`)
  console.log(`     - 图标: ${item.icon}`)
  console.log(`     - 禁用: ${item.disabled || false}`)
  console.log(`     - 占位: ${item.placeholder || false}`)
  console.log(`     - 子项数量: ${item.children?.length || 0}`)
})

// 测试2：管理员专属导航
console.log('\n2. 管理员专属导航:')
console.log(`  名称: ${adminNavigation.name}`)
console.log(`  路径: ${adminNavigation.path}`)
console.log(`  角色限制: ${adminNavigation.roles.join(', ')}`)
console.log(`  子项数量: ${adminNavigation.children.length}`)

// 测试3：普通用户导航过滤
console.log('\n3. 普通用户 (role: "user") 可见导航:')
const userNav = getFilteredNav('user')
console.log(`  一级导航数量: ${userNav.length}`)
userNav.forEach((item, index) => {
  console.log(`  ${index + 1}. ${item.name}`)
  if (item.children) {
    item.children.forEach(child => {
      console.log(`     - ${child.name} ${child.disabled ? '(未开发)' : ''}`)
    })
  }
})

// 测试4：管理员导航过滤
console.log('\n4. 管理员 (role: "admin") 可见导航:')
const adminNav = getFilteredNav('admin')
console.log(`  一级导航数量: ${adminNav.length}`)
console.log(`  最后一项: ${adminNav[adminNav.length - 1].name} (应为"平台管理")`)

// 测试5：可访问路径
console.log('\n5. 普通用户可访问的路径:')
const userPaths = getAccessiblePaths('user')
console.log(`  路径数量: ${userPaths.length}`)
console.log(`  路径列表: ${userPaths.join(', ')}`)

console.log('\n6. 管理员可访问的路径:')
const adminPaths = getAccessiblePaths('admin')
console.log(`  路径数量: ${adminPaths.length}`)
console.log(`  路径列表: ${adminPaths.join(', ')}`)

// 测试6：独立站数据模块详情
console.log('\n7. "独立站数据" 模块详情:')
const shopifyModule = navigationConfig.find(item => item.name === '独立站数据')
console.log(`  名称: ${shopifyModule.name}`)
console.log(`  路径: ${shopifyModule.path}`)
console.log(`  禁用: ${shopifyModule.disabled || false}`)
console.log(`  子项:`)
shopifyModule.children.forEach(child => {
  console.log(`    - ${child.name} (${child.path}) ${child.disabled ? '[未开发]' : '[已开发]'}`)
})

console.log('\n' + '=' .repeat(60))
console.log('测试完成')
console.log('=' .repeat(60))
