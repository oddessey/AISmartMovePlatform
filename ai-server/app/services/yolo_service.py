
from PIL import Image
import io
import random

# TODO: 실제 YOLO 모델 로드
# from ultralytics import YOLO
# model = YOLO("models/best_appliance_v3.pt")

BRANDS = ["삼성", "LG", "캐리어", "위니아"]
MODELS = ["AF25TX", "FQ25L", "DS-POS"]
TYPES = ["wall_mounted", "stand", "2in1"]

def analyze_image(file_bytes: bytes):
    # 실제 구현에서는 YOLO 추론
    # results = model(Image.open(io.BytesIO(file_bytes)))
    # Mock 데이터 반환
    return {
        "brand": random.choice(BRANDS),
        "model": random.choice(MODELS),
        "type": random.choice(TYPES),
        "capacity": "24평",
        "confidence": round(random.uniform(0.89, 0.98), 2),
        "bbox": [100, 120, 400, 500],
        "detected_parts": ["실내기", "배관"]
    }
