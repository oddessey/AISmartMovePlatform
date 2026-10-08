
# YOLOv8 학습 파이프라인

## 1. 데이터 준비
- Roboflow에서 `appliance` 프로젝트 생성
- 클래스: aircon_indoor_wall, aircon_indoor_stand, aircon_outdoor, washer, fridge, tv, pipe, bracket
- 최소 500장 per class 라벨링

```bash
python prepare_data.py --roboflow-api-key YOUR_KEY --project appliance --version 3
```

## 2. 학습

### 로컬
```bash
pip install -r requirements-training.txt
python train.py --data dataset.yaml --model yolov8m.pt --epochs 100 --imgsz 640 --batch 16
```

### Docker (GPU)
```bash
docker build -f Dockerfile.training -t smartmove-train .
docker run --gpus all -v $(pwd)/datasets:/workspace/datasets -v $(pwd)/runs:/workspace/runs smartmove-train
```

### W&B 로깅
```bash
wandb login
python train.py --epochs 150 # 자동으로 wandb에 로그 전송
```

## 3. 결과물
- `runs/detect/appliance_v4/weights/best.pt` -> `../app/models/best_appliance.pt`로 자동 복사
- `best.onnx`로 변환되어 FastAPI에서 2배 빠르게 서빙

## 4. 성능 목표
- mAP50 > 0.92
- mAP50-95 > 0.78
- 추론 속도 < 150ms (T4 GPU 기준)
