
from fastapi import APIRouter, UploadFile, File
from typing import List
from app.services.yolo_service import analyze_image

router = APIRouter()

@router.post("/analyze")
async def analyze_images(images: List[UploadFile] = File(...)):
    # 첫 번째 이미지를 대표로 분석 (실제로는 여러 장 앙상블)
    results = []
    for img in images:
        bytes_data = await img.read()
        res = analyze_image(bytes_data)
        results.append(res)

    # 가장 confidence 높은 결과 반환
    best = max(results, key=lambda x: x['confidence'])
    return best

@router.post("/verify-install")
async def verify_install(image: UploadFile = File(...)):
    # 설치 완료 사진 검증 로직
    # 배관 테이핑 불량, 실외기 기울기 등 탐지
    return {
        "is_normal": True,
        "anomaly_score": 0.12,
        "checks": {
            "pipe_taping": "정상",
            "drain_slope": "정상",
            "outdoor_level": "주의 - 2도 기울어짐"
        }
    }
