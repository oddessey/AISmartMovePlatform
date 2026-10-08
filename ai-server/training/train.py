
"""
SmartMove YOLOv8 학습 파이프라인
- 가전 인식 모델 + 설치 불량 탐지 모델 동시 학습

사용법:
python train.py --data dataset.yaml --model yolov8m.pt --epochs 100 --imgsz 640
"""
import argparse
from ultralytics import YOLO
import torch
import os

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--data', type=str, default='dataset.yaml', help='dataset yaml path')
    parser.add_argument('--model', type=str, default='yolov8m.pt', help='base model')
    parser.add_argument('--epochs', type=int, default=100)
    parser.add_argument('--imgsz', type=int, default=640)
    parser.add_argument('--batch', type=int, default=16)
    parser.add_argument('--project', type=str, default='runs/detect')
    parser.add_argument('--name', type=str, default='appliance_v4')
    return parser.parse_args()

def main():
    args = parse_args()

    print(f"""[SmartMove] 학습 시작
    - Model: {args.model}
    - Data: {args.data}
    - Epochs: {args.epochs}
    - Device: {'cuda' if torch.cuda.is_available() else 'cpu'}
    """)

    model = YOLO(args.model)

    # 학습
    results = model.train(
        data=args.data,
        epochs=args.epochs,
        imgsz=args.imgsz,
        batch=args.batch,
        project=args.project,
        name=args.name,
        device=0 if torch.cuda.is_available() else 'cpu',
        # Augmentation
        hsv_h=0.015,
        hsv_s=0.7,
        hsv_v=0.4,
        degrees=15,
        translate=0.1,
        scale=0.5,
        mosaic=1.0,
        # Early stopping
        patience=20,
        save_period=10,
        # Validation
        val=True,
        plots=True
    )

    # 검증
    print("[SmartMove] 검증 시작")
    metrics = model.val()
    print(f"mAP50-95: {metrics.box.map}")

    # Best 모델을 production으로 복사
    best_path = f"{args.project}/{args.name}/weights/best.pt"
    if os.path.exists(best_path):
        os.system(f"cp {best_path} ../app/models/best_appliance.pt")
        print(f"Best 모델 복사 완료: ../app/models/best_appliance.pt")

    # ONNX export (FastAPI 서빙 최적화)
    model.export(format='onnx', dynamic=True)
    print("ONNX export 완료")

if __name__ == "__main__":
    main()
