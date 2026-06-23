"""
AI 出海助手 - 大模型代理接口
============================
安全设计原则：
1. API Key 仅存储在服务端环境变量，前端不可见
2. 请求经后端代理转发，避免前端直接调用大模型
3. 支持多模型切换（OpenAI / Claude / 国产模型）
4. 未配置大模型时自动降级到本地规则匹配

使用方式：
  配置环境变量 BIG_MODEL_API_KEY 后自动启用大模型
  未配置时使用预设 FAQ 匹配回答
"""
from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel, Field
from typing import Optional, List, Literal
import os
import httpx

router = APIRouter(prefix="/ai-assistant", tags=["AI出海助手"])

# ==================== 配置 ====================

# 大模型 API Key（从环境变量读取）
LLM_API_KEY = os.getenv("BIG_MODEL_API_KEY", "")
LLM_API_URL = os.getenv("BIG_MODEL_API_URL", "https://api.openai.com/v1/chat/completions")
LLM_MODEL = os.getenv("BIG_MODEL_MODEL", "gpt-4o-mini")

# 预设 FAQ（用作降级后备 + 引导问题）
PRESET_FAQ = [
    {"id":1, "question":"新手应该先选哪个市场？", "answer":"建议优先考虑东南亚（印尼、泰国、越南）：① TikTok Shop渗透率高（48-52%），流量红利大；② 文化相近，选品门槛低；③ 物流成熟。客单价高的产品也可考虑北美。", "category":"市场选择"},
    {"id":2, "question":"怎么选爆品？", "answer":"三步骤：① 看大盘趋势——出海工作台品类热度图找上升品类；② 盯竞品——追踪头部店铺新品上架节奏；③ 分析达人——高转化达人带货商品特征。工具：爆品雷达 + 蓝海品类。", "category":"选品策略"},
    {"id":3, "question":"东南亚卖什么好？", "answer":"热销品类：服装（快时尚、基础款）、美妆个护（面膜、防晒）、电子配件（耳机、充电器、手机壳）。蓝海机会：穆斯林时尚（+54%）、宠物智能用品（+35%）。", "category":"选品策略"},
    {"id":4, "question":"TikTok还是独立站？", "answer":"双轨并行策略：TikTok Shop 用于测试新品、获取流量、快速起量；Shopify独立站用于建立品牌、提升复购、沉淀用户资产。建议先 TikTok 跑通模式，再用独立站承接品牌流量。", "category":"市场选择"},
    {"id":5, "question":"跨境物流怎么选？", "answer":"按阶段：新手→平台官方物流（TikTok FBT/Shopee SLS）；成长期→海外仓（月发5000+件时考虑）；成熟期→FBA+海外仓组合。各国有不同关税和认证要求，建议咨询合规服务商。", "category":"物流方案"},
    {"id":6, "question":"需要什么合规认证？", "answer":"主要市场：美国-FCC(电子)/FDA(食药妆)/CPC(儿童品)；欧盟-CE/GDPR/EPR；印尼-BPOM/SNI/Halal；日本-PSE/METI。建议咨询专业合规服务商逐项办理。", "category":"合规要求"},
    {"id":7, "question":"达人营销预算怎么定？", "answer":"达人合作费 ≈ 产品客单价 × 预期销量 × 10-15%。找达人：在达人排行榜按品类/国家/粉丝量筛选，重点看带货评分8.0+的。先小规模试单3-5人，ROAS>3再扩大。合作费用$500-$15000不等。", "category":"营销策略"},
    {"id":8, "question":"中东市场好做吗？", "answer":"中东增速最快(+32%)，优势：客单价高、竞争低。注意：必须HALAL认证；斋月是最大消费季提前3月备货；沙特需IECEE认证；物流首选Aramex。热销：奢华配饰、母婴、家居装饰。", "category":"市场选择"},
    {"id":9, "question":"如何提升直播转化率？", "answer":"四要素：① 东南亚本土主播（语言+文化亲和力）；② 前15秒有利益点（限时折扣/赠品）；③ 实景好于虚拟背景；④ 开播5分钟后投流，ROAS目标2.5+。Top直播间场均GMV$8000+。", "category":"营销策略"},
    {"id":10, "question":"品牌出海节奏怎么规划？", "answer":"三阶段：0-6月验证PMF（TikTok/Amazon测3-5个SKU，月GMV>$5万）；6-18月建品牌（Shopify+社媒矩阵+20+达人）；18月+全域增长（多国多渠道+海外团队，年GMV>$100万）。", "category":"品牌战略"}
]

# 系统 Prompt
SYSTEM_PROMPT = """你是一个跨境电商出海数据平台的 AI 助手（出海匠）。你的知识覆盖：
- TikTok Shop / Shopify / Amazon 等平台的选品、运营
- 东南亚、北美、欧洲、中东、拉美等市场分析
- 达人营销、直播带货策略
- 跨境物流、支付、合规认证
- 独立站建站与品牌出海

回答要求：
1. 使用中文，专业但不生硬，2-3 段内说清
2. 有具体数据优先引用，给出可操作建议
3. 如果不确定，诚实地说明，并建议咨询专业顾问
4. 回答末尾可附 1-2 个相关引导问题"""


# ==================== 请求/响应模型 ====================

class ChatMessage(BaseModel):
    """单条对话消息"""
    role: Literal["user", "assistant"] = Field(..., description="角色：user=用户，assistant=AI")
    content: str = Field(..., description="消息内容")


class ChatRequest(BaseModel):
    """对话请求"""
    question: str = Field(..., min_length=1, max_length=2000, description="用户问题")
    history: Optional[List[ChatMessage]] = Field(default=[], description="历史对话上下文（近10轮）")
    stream: bool = Field(default=False, description="是否启用流式响应（暂未实现）")


class ChatResponse(BaseModel):
    """对话响应"""
    answer: str = Field(..., description="AI 回答")
    source: Literal["llm", "faq"] = Field(default="faq", description="回答来源")
    related_questions: List[str] = Field(default=[], description="相关引导问题")
    conversation_id: Optional[str] = Field(default=None, description="会话 ID")


class SuggestionResponse(BaseModel):
    """引导问题列表"""
    questions: List[dict] = Field(default=[], description="引导问题列表")


# ==================== 核心逻辑 ====================

def match_faq(question: str) -> Optional[dict]:
    """本地 FAQ 匹配（中文关键词+语义相似度）"""
    q = question.lower()

    for faq in PRESET_FAQ:
        faq_q = faq["question"].lower()

        # 精确匹配
        if q == faq_q:
            return faq
        if faq_q in q or q in faq_q:
            return faq

    # 关键词重合度匹配
    best_match = None
    best_score = 0

    for faq in PRESET_FAQ:
        faq_q = faq["question"].lower()
        # 中文按字符拆分为 2-gram
        q_chars = list(q)
        faq_chars = list(faq_q)
        q_ngrams = set(''.join(q_chars[i:i+2]) for i in range(len(q_chars)-1))
        q_set = set(q_chars) | q_ngrams
        faq_ngrams = set(''.join(faq_chars[i:i+2]) for i in range(len(faq_chars)-1))
        faq_set = set(faq_chars) | faq_ngrams

        if not faq_set:
            continue

        overlap = q_set & faq_set
        score = (len(overlap) / len(faq_set)) * 70

        if score > best_score:
            best_score = score
            best_match = faq

    return best_match if best_score >= 25 else None


async def call_llm(question: str, history: list) -> tuple[str, list[str]]:
    """调用大模型（OpenAI 兼容接口）"""
    if not LLM_API_KEY:
        raise ValueError("未配置大模型 API Key")

    messages = [{"role": "system", "content": SYSTEM_PROMPT}]
    # 添加历史（最近 10 轮，即 20 条）
    for msg in history[-20:]:
        messages.append({"role": msg.role, "content": msg.content})
    messages.append({"role": "user", "content": question})

    async with httpx.AsyncClient(timeout=30) as client:
        resp = await client.post(
            LLM_API_URL,
            headers={
                "Authorization": f"Bearer {LLM_API_KEY}",
                "Content-Type": "application/json"
            },
            json={
                "model": LLM_MODEL,
                "messages": messages,
                "temperature": 0.7,
                "max_tokens": 800
            }
        )

        if resp.status_code != 200:
            raise HTTPException(status_code=502, detail=f"大模型调用失败: {resp.text[:200]}")

        data = resp.json()
        answer = data["choices"][0]["message"]["content"].strip()
        related = []  # 可让模型返回建议问题，这里简化
        return answer, related


# ==================== API 端点 ====================

@router.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    """与 AI 助手对话"""
    question = request.question.strip()
    history = request.history or []

    # 1. 尝试 FAQ 匹配（快速、免费、不消耗 token）
    faq_match = match_faq(question)
    if faq_match:
        return ChatResponse(
            answer=faq_match["answer"],
            source="faq",
            related_questions=[q["question"] for q in PRESET_FAQ[:3]]
        )

    # 2. 尝试大模型
    try:
        if LLM_API_KEY:
            answer, related = await call_llm(question, history)
            return ChatResponse(
                answer=answer,
                source="llm",
                related_questions=related
            )
    except Exception as e:
        # 大模型失败时返回通用回答
        pass

    # 3. 降级回答
    return ChatResponse(
        answer="这是一个很好的问题！我目前无法给出精确回答。\n\n"
               "建议：\n"
               "• 尝试用更具体的关键词提问（如「印尼什么卖得好」）\n"
               "• 查看出海工作台的数据趋势\n"
               "• 联系我们的出海顾问获取一对一帮助\n\n"
               "您可以尝试问我：市场选择、选品策略、物流方案、合规要求等问题。",
        source="faq",
        related_questions=["新手应该先选哪个市场？", "怎么选爆品？", "TikTok还是独立站？"]
    )


@router.get("/suggestions", response_model=SuggestionResponse)
async def get_suggestions():
    """获取引导问题列表（供前端快捷提问按钮使用）"""
    return SuggestionResponse(
        questions=[{"id": q["id"], "question": q["question"], "category": q["category"]} for q in PRESET_FAQ[:6]]
    )


@router.get("/health")
async def health_check():
    """检查大模型配置状态"""
    return {
        "llm_configured": bool(LLM_API_KEY),
        "model": LLM_MODEL if LLM_API_KEY else None,
        "faq_count": len(PRESET_FAQ),
        "message": "大模型已就绪" if LLM_API_KEY else "使用 FAQ 模式（设置 BIG_MODEL_API_KEY 启用大模型）"
    }
