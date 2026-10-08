
"""
Roboflow / S3에서 데이터 다운로드 및 YOLO 포맷 변환
"""
import os
import requests
from pathlib import Path
import shutil
import random

def download_from_roboflow(api_key, workspace, project, version, dest):
    """Roboflow에서 데이터셋 다운로드 예시"""
    # pip install roboflow
    # from roboflow import Roboflow
    # rf = Roboflow(api_key=api_key)
    # project = rf.workspace(workspace).project(project)
    # dataset = project.version(version).download("yolov8")
    # shutil.move(dataset.location, dest)
    print("Roboflow 다운로드 로직 구현 필요 - API 키로 다운로드")

def split_dataset(src_images, src_labels, dest_root, train_ratio=0.8):
    images = list(Path(src_images).glob("*.jpg")) + list(Path(src_images).glob("*.png"))
    random.shuffle(images)

    train_n = int(len(images) * train_ratio)
    train_files = images[:train_n]
    val_files = images[train_n:]

    for split, files in [("train", train_files), ("val", val_files)]:
        img_dest = Path(dest_root) / "images" / split
        lbl_dest = Path(dest_root) / "labels" / split
        img_dest.mkdir(parents=True, exist_ok=True)
        lbl_dest.mkdir(parents=True, exist_ok=True)

        for img in files:
            shutil.copy(img, img_dest / img.name)
            label = Path(src_labels) / (img.stem + ".txt")
            if label.exists():
                shutil.copy(label, lbl_dest / label.name)

    print(f"Split 완료: train {len(train_files)}, val {len(val_files)}")

if __name__ == "__main__":
    # 예시
    # split_dataset("raw/images", "raw/labels", "datasets/appliance")
    pass
