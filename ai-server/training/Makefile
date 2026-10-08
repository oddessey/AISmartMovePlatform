
train:
	python train.py --data dataset.yaml --model yolov8m.pt --epochs 100

train-small:
	python train.py --data dataset.yaml --model yolov8n.pt --epochs 10 --batch 8

export-onnx:
	python -c "from ultralytics import YOLO; YOLO('runs/detect/appliance_v4/weights/best.pt').export(format='onnx')"

download-data:
	python prepare_data.py

clean:
	rm -rf runs/ datasets/
