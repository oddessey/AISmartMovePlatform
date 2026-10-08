
from fastapi import APIRouter
from pydantic import BaseModel
from typing import List

router = APIRouter()

class Engineer(BaseModel):
    id: int
    lat: float
    lng: float
    rating: float
    has_ladder: bool

class MatchingRequest(BaseModel):
    order_lat: float
    order_lng: float
    engineers: List[Engineer]

@router.post("/optimal")
async def optimal_matching(req: MatchingRequest):
    # TODO: OR-Tools 기반 헝가리안 알고리즘
    # Mock: 거리 + 평점 기반 점수 계산
    scored = []
    for eng in req.engineers:
        dist = abs(eng.lat - req.order_lat) + abs(eng.lng - req.order_lng)
        score = (eng.rating * 0.6) - (dist * 100 * 0.4)
        scored.append({"engineer_id": eng.id, "score": round(score, 2), "distance_km": round(dist*111,2)})

    sorted_eng = sorted(scored, key=lambda x: x['score'], reverse=True)
    return {"recommended": sorted_eng[:5]}
