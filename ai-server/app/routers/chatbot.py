
from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()

class ChatRequest(BaseModel):
    question: str
    order_id: str | None = None

@router.post("/ask")
async def ask_chatbot(req: ChatRequest):
    # TODO: LangChain + PGVector RAG 구현
    # 현재는 Mock
    return {
        "answer": f"'{req.question}'에 대한 답변입니다. 에어컨 이전설치 시 냉매 회수는 기본 공임에 포함되어 있으며, 배관 연장 1m당 2만원이 추가됩니다.",
        "sources": ["정책문서_2024.pdf", "설치매뉴얼_v3"]
    }
