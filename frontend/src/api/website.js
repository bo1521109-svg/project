/**
 * 建站模块 API 接口
 */
import request from '../utils/request'

/**
 * 获取站点列表
 */
export function getWebsites(params) {
  return request.get('/v1/website/websites', { params })
}

/**
 * 获取站点详情
 */
export function getWebsite(id) {
  return request.get(`/v1/website/websites/${id}`)
}

/**
 * 创建站点
 */
export function createWebsite(data) {
  return request.post('/v1/website/websites', data)
}

/**
 * 更新站点
 */
export function updateWebsite(id, data) {
  return request.put(`/v1/website/websites/${id}`, data)
}

/**
 * 删除站点
 */
export function deleteWebsite(id) {
  return request.delete(`/v1/website/websites/${id}`)
}

/**
 * 发布站点
 */
export function publishWebsite(id) {
  return request.post(`/v1/website/websites/${id}/publish`)
}

/**
 * 暂停站点
 */
export function pauseWebsite(id) {
  return request.post(`/v1/website/websites/${id}/pause`)
}

/**
 * 获取模板列表
 */
export function getTemplates(params) {
  return request.get('/v1/website/templates', { params })
}
