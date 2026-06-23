/**
 * 域名管理 - 伪数据 + 模拟 API 方法
 * 纯前端模块，不请求后端。后续对接真实 API 时只需替换方法实现。
 */

// ==================== 伪数据 ====================

export const mockDomains = [
  {
    id: 1, site_id: 1,
    domain_name: 'www.fashionvibe.com',
    is_primary: true,
    status: 'verified',           // pending | verified | failed
    verification_record: 'TXT value: fv-verify-a1b2c3',
    created_at: '2026-01-15T08:00:00Z',
    updated_at: '2026-03-10T12:00:00Z'
  },
  {
    id: 2, site_id: 1,
    domain_name: 'shop.fashionvibe.com',
    is_primary: false,
    status: 'verified',
    verification_record: 'TXT value: fv-sub-d4e5f6',
    created_at: '2026-02-20T10:00:00Z',
    updated_at: '2026-04-05T09:00:00Z'
  },
  {
    id: 3, site_id: 1,
    domain_name: 'fashionvibe.store',
    is_primary: false,
    status: 'pending',
    verification_record: 'TXT value: fv-store-g7h8i9',
    created_at: '2026-06-01T14:00:00Z',
    updated_at: '2026-06-01T14:00:00Z'
  },
  {
    id: 4, site_id: 2,
    domain_name: 'www.techgadget.shop',
    is_primary: true,
    status: 'verified',
    verification_record: 'TXT value: tg-main-j1k2l3',
    created_at: '2026-02-20T10:00:00Z',
    updated_at: '2026-03-15T16:00:00Z'
  },
  {
    id: 5, site_id: 2,
    domain_name: 'techgadget-pro.com',
    is_primary: false,
    status: 'failed',
    verification_record: 'TXT value: tg-pro-m4n5o6',
    created_at: '2026-05-10T08:00:00Z',
    updated_at: '2026-05-12T11:00:00Z'
  }
]

// ==================== 模拟 API 方法 ====================

/** 获取指定站点的域名列表 */
export function getDomains(siteId) {
  return mockDomains.filter(d => d.site_id === Number(siteId))
}

/** 添加域名（模拟） */
export function addDomain(siteId, domainName) {
  const newDomain = {
    id: Math.max(...mockDomains.map(d => d.id), 0) + 1,
    site_id: Number(siteId),
    domain_name: domainName,
    is_primary: false,
    status: 'pending',
    verification_record: `TXT value: ${Math.random().toString(36).substring(2, 10)}`,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  }
  mockDomains.push(newDomain)
  return newDomain
}

/** 模拟异步验证域名（80% 成功，20% 失败） */
export function verifyDomain(domainId) {
  return new Promise((resolve) => {
    setTimeout(() => {
      const domain = mockDomains.find(d => d.id === domainId)
      if (!domain) {
        resolve({ success: false, message: '域名不存在' })
        return
      }
      const success = Math.random() < 0.8
      domain.status = success ? 'verified' : 'failed'
      domain.updated_at = new Date().toISOString()
      resolve({
        success,
        message: success ? '域名验证成功' : '域名验证失败，请检查 DNS 记录'
      })
    }, 2000)
  })
}

/** 设置主域名 */
export function setPrimary(domainId) {
  const domain = mockDomains.find(d => d.id === domainId)
  if (!domain) return false
  // 取消同站点所有域名的主域名标记
  mockDomains.forEach(d => { if (d.site_id === domain.site_id) d.is_primary = false })
  // 设置当前为主域名
  domain.is_primary = true
  domain.updated_at = new Date().toISOString()
  return true
}

/** 删除域名 */
export function deleteDomain(domainId) {
  const idx = mockDomains.findIndex(d => d.id === domainId)
  if (idx === -1) return null
  const removed = mockDomains.splice(idx, 1)[0]
  // 如果删除的是主域名，自动设置下一个为主域名
  if (removed.is_primary) {
    const next = mockDomains.find(d => d.site_id === removed.site_id)
    if (next) next.is_primary = true
  }
  return removed
}
