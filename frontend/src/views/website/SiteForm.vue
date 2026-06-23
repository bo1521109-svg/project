<template>
  <div class="site-form-page">
    <!-- ====== Hero 头部 ====== -->
    <div class="hero-section">
      <div class="hero-bg-shapes">
        <span class="shape shape-1" />
        <span class="shape shape-2" />
      </div>
      <div class="hero-content">
        <h1 class="hero-title">{{ isEdit ? '编辑站点' : '创建站点' }}<span class="hero-dot" /></h1>
        <p class="hero-subtitle">{{ isEdit ? '修改站点配置，保持最佳状态' : '三步完成站点搭建，让生意快速上线' }}</p>
      </div>
    </div>

    <!-- ====== 步骤条（支持点击已完成步骤回退） ====== -->
    <div class="steps-wrap">
      <template v-for="(step, idx) in stepList" :key="idx">
        <!-- 步骤项 -->
        <div
          class="step-item"
          :class="{ done: activeStep > idx, active: activeStep === idx, clickable: activeStep > idx }"
          @click="activeStep > idx ? activeStep = idx : null"
        >
          <div class="step-circle">
            <el-icon v-if="activeStep > idx" :size="18" color="#fff"><Check /></el-icon>
            <span v-else>{{ idx + 1 }}</span>
          </div>
          <div class="step-info">
            <span class="step-title" :class="{ 'step-active': activeStep === idx, 'step-done': activeStep > idx }">
              {{ step.title }}
            </span>
            <span class="step-desc">{{ step.desc }}</span>
          </div>
        </div>
        <!-- 连接线 -->
        <div v-if="idx < stepList.length - 1" class="step-line" :class="{ done: activeStep > idx }" />
      </template>
    </div>

    <!-- ====== 步骤内容卡片 ====== -->
    <div class="step-card">
      <!-- ====== 步骤1：基础信息 ====== -->
      <div v-show="activeStep === 0" class="step-panel">
        <h3 class="panel-title">📋 填写站点基础信息</h3>

        <!-- 站点 Logo 上传（简单占位） -->
        <div class="logo-section">
          <div class="logo-label">站点 Logo</div>
          <el-upload
            :show-file-list="false"
            :before-upload="handleLogoUpload"
            accept="image/png,image/jpeg,image/gif,image/webp"
            class="logo-uploader"
          >
            <div v-if="logoUrl" class="logo-preview">
              <img :src="logoUrl" alt="logo" />
              <div class="logo-overlay">
                <el-icon :size="20"><EditPen /></el-icon>
                <span>更换</span>
              </div>
            </div>
            <div v-else class="logo-placeholder">
              <el-icon :size="32"><Picture /></el-icon>
              <span>上传 Logo</span>
              <span class="logo-hint">建议 200×200px</span>
            </div>
          </el-upload>
        </div>

        <el-form
          ref="formRef"
          :model="form"
          :rules="rules"
          label-position="top"
          class="base-form"
        >
          <!-- 站点名称 -->
          <el-form-item label="站点名称" prop="name">
            <el-input
              v-model="form.name"
              placeholder="为你的站点起个好听的名字"
              maxlength="50"
              show-word-limit
              size="large"
            />
          </el-form-item>

          <!-- 品牌 Slogan（新增，可选） -->
          <el-form-item label="品牌 Slogan" prop="slogan">
            <el-input
              v-model="form.slogan"
              placeholder="用一句话描述你的品牌"
              maxlength="30"
              show-word-limit
              size="large"
            />
          </el-form-item>

          <!-- 域名 -->
          <el-form-item label="域名（选填）" prop="domain">
            <el-input v-model="form.domain" placeholder="例如：myshop.com" size="large">
              <template #prepend>https://</template>
            </el-input>
          </el-form-item>

          <!-- 所属行业 -->
          <el-form-item label="所属行业" prop="industry">
            <div class="industry-grid">
              <button
                v-for="ind in industries"
                :key="ind"
                class="ind-btn"
                :class="{ active: form.industry === ind }"
                @click="toggleIndustry(ind)"
                type="button"
              >
                <span class="ind-text">{{ ind }}</span>
                <span v-if="form.industry === ind" class="ind-check">
                  <el-icon :size="14" color="#fff"><Check /></el-icon>
                </span>
              </button>
            </div>
          </el-form-item>
        </el-form>
      </div>

      <!-- ====== 步骤2：模板选择 ====== -->
      <div v-show="activeStep === 1" class="step-panel">
        <h3 class="panel-title">🎨 选择模板风格</h3>
        <p class="panel-desc">选择一个模板作为站点的初始风格，后续可以自行调整。</p>
        <div class="template-grid">
          <div
            v-for="tpl in templates"
            :key="tpl.id"
            class="tpl-card"
            :class="{ selected: form.template_id === tpl.id }"
            @click="selectTemplate(tpl)"
          >
            <div class="tpl-preview" :style="{ background: tpl.bgColor }">
              <span class="tpl-emoji">{{ tpl.emoji }}</span>
              <div v-if="form.template_id === tpl.id" class="tpl-check">
                <el-icon :size="18" color="#fff"><Check /></el-icon>
              </div>
            </div>
            <div class="tpl-info">
              <h4>{{ tpl.name }}</h4>
              <p>{{ tpl.description }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- ====== 步骤3：确认 ====== -->
      <div v-show="activeStep === 2" class="step-panel">
        <h3 class="panel-title">✅ 确认信息并提交</h3>
        <div class="confirm-card">
          <div class="confirm-item">
            <span class="confirm-label">站点 Logo</span>
            <span class="confirm-val">
              <img v-if="logoUrl" :src="logoUrl" class="confirm-logo" alt="logo" />
              <span v-else style="color:#909399;">未上传</span>
            </span>
          </div>
          <div class="confirm-item">
            <span class="confirm-label">站点名称</span>
            <span class="confirm-val">{{ form.name || '-' }}</span>
          </div>
          <div class="confirm-item">
            <span class="confirm-label">品牌 Slogan</span>
            <span class="confirm-val">{{ form.slogan || '未设置' }}</span>
          </div>
          <div class="confirm-item">
            <span class="confirm-label">域名</span>
            <span class="confirm-val">{{ form.domain ? `https://${form.domain}` : '未设置' }}</span>
          </div>
          <div class="confirm-item">
            <span class="confirm-label">所属行业</span>
            <span class="confirm-val">{{ form.industry || '-' }}</span>
          </div>
          <div class="confirm-item">
            <span class="confirm-label">选择模板</span>
            <span class="confirm-val">{{ selectedTemplateName || '-' }}</span>
          </div>
        </div>
        <div class="confirm-actions">
          <el-button size="large" @click="activeStep = 0">返回修改</el-button>
          <el-button size="large" type="primary" :loading="submitting" @click="handleSubmit">
            {{ isEdit ? '确认更新' : '确认创建' }}
          </el-button>
        </div>
      </div>
    </div>

    <!-- ====== 底部导航 ====== -->
    <div class="step-footer">
      <el-button v-if="activeStep > 0" size="large" @click="prevStep">上一步</el-button>
      <el-button v-if="activeStep < 2" size="large" type="primary" @click="nextStep">下一步</el-button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useRouter, useRoute, onBeforeRouteLeave } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Check, Picture, EditPen } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const isEdit = computed(() => !!route.query.edit)

// ====== 步骤列表 ======
const stepList = [
  { title: '基础信息', desc: '填写站点信息' },
  { title: '选择模板', desc: '挑选模板风格' },
  { title: '确认完成', desc: '检查并提交' }
]

// ====== 行业列表 ======
const industries = ['服装', '数码', '家居', '美妆', '宠物', '运动', '母婴', '食品', '教育', '珠宝', '其他']

// ====== 状态 ======
const activeStep = ref(0)
const formRef = ref(null)
const submitting = ref(false)
const formSubmitted = ref(false)

// Logo 上传
const logoUrl = ref('')

/**
 * 表单数据
 */
const form = ref({
  name: '',
  slogan: '',
  domain: '',
  industry: '',
  template_id: null,
  template_name: ''
})

/**
 * 计算是否有未保存的内容（用于离开确认）
 */
const hasUnsavedContent = computed(() => {
  return (
    form.value.name ||
    form.value.slogan ||
    form.value.domain ||
    form.value.industry ||
    form.value.template_id ||
    logoUrl.value
  )
})

/** 监视内容变化，标记未提交状态 */
watch(form.value, () => { formSubmitted.value = false }, { deep: true })

// ====== 表单校验规则 ======
const validatorDomain = (rule, value, callback) => {
  if (!value) return callback() // 选填
  // 基础域名格式校验：包含点 + 合法 TLD
  const domainRegex = /^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)+$/
  if (!domainRegex.test(value)) {
    return callback(new Error('域名格式不正确，请输入有效域名（如 myshop.com）'))
  }
  callback()
}

const rules = {
  name: [
    { required: true, message: '请输入站点名称', trigger: 'blur' },
    { min: 1, max: 50, message: '站点名称长度在 1-50 个字符', trigger: 'blur' }
  ],
  slogan: [
    { max: 30, message: 'Slogan 不能超过 30 个字符', trigger: 'blur' }
  ],
  domain: [
    { validator: validatorDomain, trigger: 'blur' }
  ],
  industry: [
    { required: true, message: '请选择所属行业', trigger: 'change' }
  ]
}

// ====== 模板数据 ======
const mockTemplates = [
  { id: 1, name: '时尚精品', description: '简洁大气的时尚风格', bgColor: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)', emoji: '👗' },
  { id: 2, name: '科技极简', description: '科技感十足的极简风格', bgColor: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)', emoji: '💻' },
  { id: 3, name: '温馨家居', description: '温暖舒适的家居风格', bgColor: 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)', emoji: '🏠' },
  { id: 4, name: '可爱风格', description: '可爱清新的风格', bgColor: 'linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%)', emoji: '🐾' },
  { id: 5, name: '运动活力', description: '充满活力的运动风格', bgColor: 'linear-gradient(135deg, #fccb90 0%, #d57eeb 100%)', emoji: '⚽' },
  { id: 6, name: '自然生态', description: '清新自然的风格', bgColor: 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)', emoji: '🌿' }
]
const templates = ref(mockTemplates)

const selectedTemplateName = computed(() => {
  const t = templates.value.find(t => t.id === form.value.template_id)
  return t ? t.name : ''
})

// ====== 方法 ======

/** 行业选择（支持取消选中） */
function toggleIndustry(ind) {
  form.value.industry = form.value.industry === ind ? '' : ind
  // 触发校验
  formRef.value?.validateField('industry')
}

/** 模板选择 */
function selectTemplate(tpl) {
  form.value.template_id = tpl.id
  form.value.template_name = tpl.name
}

/** Logo 上传（前端占位，不上传到后端） */
function handleLogoUpload(file) {
  // 读取本地文件作为 data URL 显示预览
  const reader = new FileReader()
  reader.onload = (e) => {
    logoUrl.value = e.target.result
  }
  reader.readAsDataURL(file)
  ElMessage.success('Logo 已上传（前端预览）')
  return false // 阻止真正上传
}

/** 下一步 */
async function nextStep() {
  if (activeStep.value === 0) {
    // step 1：校验表单
    const valid = await formRef.value.validate().catch(() => false)
    if (!valid) {
      // 滚动到第一个错误字段
      scrollToFirstError()
      return
    }
  }
  if (activeStep.value < 2) {
    activeStep.value++
  }
}

/** 上一步 */
function prevStep() {
  if (activeStep.value > 0) {
    activeStep.value--
  }
}

/** 滚动到第一个错误字段 */
function scrollToFirstError() {
  // Element Plus 的 ElForm 提供了 scrollToField 方法
  const formEl = formRef.value
  if (formEl && formEl.$el) {
    // 查找第一个 .el-form-item__error 所在的父级 el-form-item
    const firstError = formEl.$el.querySelector('.el-form-item.is-error')
    if (firstError) {
      firstError.scrollIntoView({ behavior: 'smooth', block: 'center' })
    }
  }
}

/** 提交表单 */
function handleSubmit() {
  if (!form.value.template_id) {
    ElMessage.warning('请先选择模板')
    activeStep.value = 1
    return
  }
  submitting.value = true
  formSubmitted.value = true
  setTimeout(() => {
    submitting.value = false
    ElMessage.success(`${isEdit.value ? '更新' : '创建'}成功`)
    router.push('/website/my-sites')
  }, 500)
}

/** 离开确认 */
onBeforeRouteLeave((to, from, next) => {
  if (hasUnsavedContent.value && !formSubmitted.value) {
    ElMessageBox.confirm(
      '内容尚未保存，确定离开吗？',
      '提示',
      {
        confirmButtonText: '离开',
        cancelButtonText: '取消',
        type: 'warning'
      }
    ).then(() => next()).catch(() => next(false))
  } else {
    next()
  }
})
</script>

<style scoped>
.site-form-page { max-width: 960px; margin: 0 auto; }

/* ================== Hero ================== */
.hero-section {
  position: relative;
  background: linear-gradient(135deg, #e8f4fd 0%, #f0f7ff 40%, #f5f9fc 100%);
  border-radius: 24px;
  padding: 40px 48px;
  margin-bottom: 28px;
  overflow: hidden;
}
.hero-bg-shapes { position: absolute; inset: 0; pointer-events: none; }
.shape { position: absolute; border-radius: 50%; opacity: 0.12; }
.shape-1 { width: 260px; height: 260px; background: radial-gradient(circle, #409eff, transparent); top: -60px; right: -40px; }
.shape-2 { width: 180px; height: 180px; background: radial-gradient(circle, #a78bfa, transparent); bottom: -30px; left: 15%; }
.hero-content { position: relative; z-index: 1; }
.hero-title { margin: 0; font-size: 36px; font-weight: 800; color: #1a1a2e; display: flex; align-items: center; gap: 8px; }
.hero-dot { width: 10px; height: 10px; border-radius: 50%; background: linear-gradient(135deg, #409eff, #a78bfa); box-shadow: 0 0 8px rgba(64,158,255,.2); display: inline-block; }
.hero-subtitle { margin: 8px 0 0; font-size: 15px; color: #6b7280; }

/* ================== 步骤条 ================== */
.steps-wrap { display: flex; align-items: center; justify-content: center; margin-bottom: 28px; gap: 0; }
.step-item { display: flex; align-items: center; gap: 12px; }
.step-item.clickable { cursor: pointer; }
.step-item.clickable:hover .step-title { color: #409eff; }
.step-circle {
  width: 40px; height: 40px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-size: 16px; font-weight: 700;
  background: #f0f0f0; color: #909399;
  transition: all .35s;
  flex-shrink: 0;
}
.step-item.active .step-circle {
  background: linear-gradient(135deg, #409eff, #5372ff);
  color: #fff;
  box-shadow: 0 4px 12px rgba(64,158,255,.3);
}
.step-item.done .step-circle {
  background: #67c23a;
  color: #fff;
}
.step-item.done:hover .step-circle {
  box-shadow: 0 4px 12px rgba(103,194,58,.4);
  transform: scale(1.05);
}
.step-info { display: flex; flex-direction: column; }
.step-title { font-size: 14px; font-weight: 500; color: #909399; transition: color .25s; }
.step-title.step-active { font-weight: 700; color: #409eff; }
.step-title.step-done { color: #67c23a; }
.step-desc { font-size: 12px; color: #c0c4cc; }
.step-line { flex: 1; height: 2px; background: #e8ecf1; max-width: 80px; margin: 0 12px; transition: background .35s; }
.step-line.done { background: #67c23a; }

/* ================== 步骤卡片 ================== */
.step-card { background: #fff; border-radius: 20px; padding: 36px 40px; box-shadow: 0 1px 3px rgba(0,0,0,.04); border: 1px solid rgba(0,0,0,.04); min-height: 420px; }
.panel-title { margin: 0 0 6px; font-size: 18px; font-weight: 700; color: #1a1a2e; }
.panel-desc { margin: 8px 0 24px; font-size: 14px; color: #909399; }

.base-form { max-width: 520px; }
.base-form :deep(.el-form-item__label) { font-weight: 600; color: #303133; padding-bottom: 6px; }

/* ================== Logo 上传 ================== */
.logo-section { margin-bottom: 24px; }
.logo-label { font-size: 14px; font-weight: 600; color: #303133; margin-bottom: 10px; }
.logo-uploader { display: inline-block; cursor: pointer; }
.logo-placeholder {
  width: 128px; height: 128px;
  border: 2px dashed #dcdfe6;
  border-radius: 16px;
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  gap: 6px; color: #c0c4cc; transition: all .3s;
  background: #fafbfc;
}
.logo-placeholder:hover { border-color: #409eff; color: #409eff; background: #ecf5ff; }
.logo-placeholder .el-icon { font-size: 28px; }
.logo-placeholder span { font-size: 12px; }
.logo-hint { font-size: 10px !important; opacity: .6; }
.logo-preview {
  width: 128px; height: 128px;
  border-radius: 16px; overflow: hidden;
  position: relative; border: 1px solid #e8ecf1;
}
.logo-preview img { width: 100%; height: 100%; object-fit: cover; }
.logo-overlay {
  position: absolute; inset: 0;
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  gap: 4px; background: rgba(0,0,0,.5); color: #fff; font-size: 12px;
  opacity: 0; transition: opacity .25s;
}
.logo-preview:hover .logo-overlay { opacity: 1; }

/* ================== 行业选择 ================== */
.industry-grid { display: flex; flex-wrap: wrap; gap: 10px; }
.ind-btn {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 10px 20px;
  border: 1.5px solid #e8ecf1; border-radius: 12px;
  background: #fff; font-size: 14px; color: #606266;
  cursor: pointer; transition: all .25s; font-weight: 500;
}
.ind-btn:hover {
  border-color: #409eff; color: #409eff;
  transform: translateY(-2px); box-shadow: 0 4px 12px rgba(64,158,255,.1);
}
.ind-btn.active {
  border-color: #409eff; background: #ecf5ff; color: #409eff;
  box-shadow: 0 0 0 3px rgba(64,158,255,.15);
}
.ind-check {
  display: inline-flex; align-items: center; justify-content: center;
  width: 20px; height: 20px; border-radius: 50%;
  background: #409eff; flex-shrink: 0;
}

/* ================== 模板选择 ================== */
.template-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-top: 20px; }
.tpl-card { border: 2px solid #e8ecf1; border-radius: 16px; overflow: hidden; cursor: pointer; transition: all .3s; background: #fff; }
.tpl-card:hover { border-color: #409eff; transform: translateY(-3px); box-shadow: 0 8px 24px rgba(64,158,255,.12); }
.tpl-card.selected { border-color: #409eff; box-shadow: 0 0 0 4px rgba(64,158,255,.12); }
.tpl-preview { height: 120px; display: flex; align-items: center; justify-content: center; position: relative; }
.tpl-emoji { font-size: 44px; filter: drop-shadow(0 2px 4px rgba(0,0,0,.2)); }
.tpl-check { position: absolute; top: 10px; right: 10px; width: 28px; height: 28px; border-radius: 50%; background: #409eff; display: flex; align-items: center; justify-content: center; }
.tpl-info { padding: 14px 16px; }
.tpl-info h4 { margin: 0 0 4px; font-size: 14px; font-weight: 600; color: #1a1a2e; }
.tpl-info p { margin: 0; font-size: 12px; color: #909399; }

/* ================== 确认卡片 ================== */
.confirm-card { background: #fafbfc; border-radius: 16px; padding: 24px 28px; margin-top: 20px; }
.confirm-item { display: flex; justify-content: space-between; align-items: center; padding: 14px 0; border-bottom: 1px solid #f0f0f0; }
.confirm-item:last-child { border-bottom: none; }
.confirm-label { font-size: 14px; color: #909399; font-weight: 500; }
.confirm-val { font-size: 14px; color: #1a1a2e; font-weight: 600; }
.confirm-logo { width: 40px; height: 40px; border-radius: 8px; object-fit: cover; border: 1px solid #e8ecf1; }
.confirm-actions { display: flex; justify-content: center; gap: 12px; margin-top: 28px; }

/* ================== 底部导航 ================== */
.step-footer { display: flex; justify-content: center; gap: 12px; margin-top: 28px; }
</style>
