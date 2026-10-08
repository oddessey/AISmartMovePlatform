# AISmartMovePlatform
AI가전이전설치 플랫폼

# SmartMove AI - AI 기반 가전 이전설치 플랫폼

> **"사진 한 장으로 견적부터 기사 매칭, 설치 검증까지"**
> React.js + Spring Boot + PostgreSQL + AI Microservice 기반의 스마트 가전 이전설치 올인원 플랫폼

[[React](https://img.shields.io/badge/Frontend-React%2018-61DAFB?logo=react)](https://reactjs.org/)
[[Spring Boot](https://img.shields.io/badge/Backend-Spring%20Boot%203.2-6DB33F?logo=springboot)](https://spring.io/)
[[PostgreSQL](https://img.shields.io/badge/DB-PostgreSQL%2016-4169E1?logo=postgresql)](https://www.postgresql.org/)
[[AI](https://img.shields.io/badge/AI-FastAPI%20%2B%20YOLOv8%20%2B%20GPT--4o-FF6F00?logo=openai)](https://openai.com/)
[[License](https://img.shields.io/badge/License-MIT-yellow.svg)]()

---

### 📋 목차
1. [프로젝트 개요](#-프로젝트-개요)
2. [해결하려는 문제](#-해결하려는-문제)
3. [핵심 기능](#-핵심-기능)
4. [AI 핵심 기능 (AI Core)](#-ai-핵심-기능-ai-core)
5. [기술 스택](#-기술-스택)
6. [시스템 아키텍처](#-시스템-아키텍처)
7. [데이터베이스 설계 (ERD)](#-데이터베이스-설계-erd)
8. [프로젝트 구조](#-프로젝트-구조)
9. [시작하기](#-시작하기)
10. [환경 변수 설정](#-환경-변수-설정)
11. [API 명세](#-api-명세)
12. [AI 파이프라인 상세](#-ai-파이프라인-상세)

---

### 1. 프로젝트 개요

**SmartMove AI**는 에어컨, 세탁기, 냉장고, TV 등 대형 가전의 이전/재설치를 중개하는 플랫폼입니다. 기존의 전화 견적, 불투명한 추가비용 문제를 AI로 해결합니다.

고객이 가전 제품 사진 2~3장을 업로드하면, AI가 모델명/용량/설치환경을 자동 인식하여 즉시 견적을 산출하고, 최적의 설치 기사를 매칭하며, 설치 완료 후 사진으로 정상 설치 여부를 검증합니다.

### 2. 해결하려는 문제

- **견적 불투명성:** 기사마다 다른 추가금, 현장에서의 가격 변동
- **정보 비대칭:** 고객은 가전 모델명/배관 길이 등을 정확히 모름
- **매칭 비효율:** 거리, 보유장비, 자격증을 고려하지 않은 배정
- **설치 품질 이슈:** 부실 시공에 대한 사후 검증 불가

### 3. 핵심 기능

#### 👤 고객 (Client App - React)
- **AI 간편 견적:** 사진 업로드 → 모델 자동 인식 → 즉시 견적
- **실시간 매칭 현황:** 내 주변 가용 기사 5명 지도에서 확인 (PostGIS 기반)
- **예약 및 결제:** 원하는 날짜/시간 예약, 토스페이먼츠/카카오페이 결제
- **설치 라이브 트래킹:** 기사 이동 경로, 도착 예정 시간
- **설치 검증 리포트:** AI가 분석한 설치 완료 사진 + 정상/주의 판정

#### 🔧 설치 기사 (Partner App - React)
- **AI 오더 추천:** 내 위치/보유장비/숙련도 기반 최적 오더 10개 추천
- **수익 대시보드:** 일/주/월 정산, 경로 최적화 제안
- **AR 설치 가이드:** 복잡한 배관 작업 시 AR 가이드 제공 (선택)

#### 🛡️ 관리자 (Admin - React)
- **AI 이상 탐지 대시보드:** 부실 설치 의심 건 자동 플래깅
- **분쟁 조정 센터:** 고객-기사 채팅, 사진 로그 타임라인
- **동적 요금 관리:** 지역/시즌/수요 기반 서지 요금 정책 설정

### 4. AI 핵심 기능 (AI Core)

본 프로젝트의 차별점은 별도의 **Python FastAPI AI Microservice**를 둔 것입니다.

| AI 기능 | 설명 | 사용 기술 |
| :--- | :--- | :--- |
| **1. Vision 기반 가전 인식** | 고객이 찍은 사진에서 가전 종류, 제조사, 모델명, 용량(예: 24평), 벽걸이/스탠드 여부 인식 | YOLOv8 (Custom Trained), CLIP, GPT-4o Vision |
| **2. AI 자동 견적 엔진** | 인식된 모델 + 설치 환경(배관 길이, 앵글 유무, 타공 필요) + DB의 표준 공임표를 결합해 95% 정확도의 견적 산출 | LightGBM Regressor, Rule-based Engine |
| **3. AI 챗봇 상담 (RAG)** | "에어컨 이전설치시 냉매 회수는 포함인가요?" 같은 질문에 자사 정책/매뉴얼 기반 답변 | LangChain, OpenAI GPT-4o, PGVector |
| **4. 기사-오더 최적 매칭** | 헝가리안 알고리즘 + 강화학습 기반. 거리(40%), 기사 평점/숙련도(30%), 장비 보유(20%), 현재 교통(10%) 가중치 | OR-Tools, Python |
| **5. 설치 품질 검증** | 기사가 업로드한 최종 설치 사진에서 배관 테이핑, 배수 기울기, 실외기 수평 불량 등을 탐지 | YOLOv8 Anomaly Detection |

### 5. 기술 스택

#### Frontend
- **Core:** React 18, TypeScript, Vite
- **State:** Zustand + TanStack Query v5
- **UI:** Tailwind CSS, shadcn/ui, Framer Motion
- **Map:** Kakao Map SDK / Naver Map (기사 위치 표시)
- **기타:** React Hook Form, Zod

#### Backend
- **Core:** Java 17, Spring Boot 3.2.5, Gradle
- **Security:** Spring Security 6 + JWT (Access/Refresh) + OAuth2 (카카오)
- **Data:** Spring Data JPA, QueryDSL, PostgreSQL 16 + PostGIS, Redis (매칭 큐, 캐시)
- **Infra:** Spring Cloud OpenFeign (AI 서버 통신), WebSocket (실시간 위치)

#### AI Server
- **Core:** Python 3.11, FastAPI
- **AI/ML:** Ultralytics YOLOv8, OpenAI API, LangChain, Scikit-learn, LightGBM
- **Vector DB:** PostgreSQL + pgvector 확장 (RAG용)

#### DevOps
- Docker, Docker Compose, GitHub Actions, AWS EC2/RDS/S3

### 6. 시스템 아키텍처

```
[ React Client ] --REST--> [ Spring Boot API (8080) ] --Feign--> [ AI FastAPI Server (8000) ]
      |                           |   |                           |
      |                           |   +--> [ PostgreSQL + PostGIS + pgvector ]
      |                           +--> [ Redis - 기사 위치, 매칭 큐 ]
      +--> [ S3 - 가전 이미지 저장 ]
```

**플로우:**
1. 고객 사진 업로드 -> S3 Presigned URL -> Spring Boot
2. Spring Boot -> AI Server `/api/v1/vision/analyze` 호출
3. AI Server 분석 결과(JSON) 반환 -> Spring Boot에서 견적 계산
4. 확정된 오더 -> Redis Geo 기반 근처 기사에게 Push (FCM)

### 7. 데이터베이스 설계 (ERD)

```sql
-- 핵심 테이블
Users (id, role[CLIENT, ENGINEER, ADMIN], name, phone, oauth_provider)
Engineers (user_id FK, career_years, rating, has_ladder, has_welding, current_lat, current_lng, is_available)
Appliances (id, type[AIRCON, WASHER, FRIDGE, TV], brand, model_name, capacity)
Orders (id, client_id FK, status[PENDING, MATCHED, MOVING, INSTALLING, VERIFYING, DONE], 
        from_address, to_address, desired_date, final_price, ai_estimated_price)
Order_Images (id, order_id FK, image_url, ai_detected_info JSONB) -- AI 인식 결과 저장
Matches (id, order_id FK, engineer_id FK, distance_m, score)
Install_Reports (id, order_id FK, after_image_url, ai_anomaly_score, ai_check_result JSONB)
```

- `Order_Images.ai_detected_info` 예시: `{"brand": "LG", "model": "FQ25L...", "type": "wall_mounted", "confidence": 0.97}`
- `Orders` 테이블에 `GIST` 인덱스로 PostGIS 위치 검색 최적화

### 8. 프로젝트 구조

```
smartmove-ai/
├── frontend/ (React)
│   ├── src/
│   │   ├── features/ (order, engineer, auth)
│   │   ├── components/ui/
│   │   ├── hooks/
│   │   └── lib/api.ts (axios instance)
│   └── ...
├── backend/ (Spring Boot)
│   ├── src/main/java/com/smartmove/
│   │   ├── domain/order/
│   │   ├── domain/engineer/
│   │   ├── global/security/
│   │   ├── infra/ai/ (Feign Client)
│   │   └── infra/s3/
│   └── ...
├── ai-server/ (FastAPI)
│   ├── app/
│   │   ├── routers/vision.py
│   │   ├── routers/chatbot.py
│   │   ├── services/yolo_service.py
│   │   └── models/ (yolov8 weights)
│   ├── requirements.txt
│   └── Dockerfile
└── docker-compose.yml
```

### 9. 시작하기

#### 사전 요구사항
- Docker Desktop (Docker Compose 포함), Node.js 20+, npm

#### 1. 클론 및 실행
```bash
git clone https://github.com/oddessey/AISmartMovePlatform.git
cd AISmartMovePlatform

# 환경 변수 파일 생성 (최초 1회)
cp .env.example .env

# PostgreSQL, Redis, AI 서버, Spring Boot 백엔드 실행
docker compose up --build -d

# 프론트엔드 실행 (새 터미널)
cd frontend
npm install
npm run dev
```

- Frontend: http://localhost:5173
- Backend API Docs: http://localhost:8080/swagger-ui/index.html
- AI Server Docs: http://localhost:8000/docs

### 10. 환경 변수 설정

프로젝트 루트의 `.env.example`을 `.env`로 복사해 사용합니다. `.env`는 Git에서 제외됩니다.
`DB_PASSWORD`는 Compose의 PostgreSQL 비밀번호(`postgres`)와 동일하게 설정하세요.
배포 환경에서는 반드시 `JWT_SECRET`을 안전한 값으로 교체하세요.

### 11. API 명세

| Method | Endpoint | 설명 |
| :--- | :--- | :--- |
| `POST` | `/api/v1/orders/estimate` | AI 견적 요청 (이미지 업로드) |
| `POST` | `/api/v1/orders` | 정식 이전설치 주문 생성 |
| `GET` | `/api/v1/engineers/nearby?lat=&lng=&radius=5km` | 근처 가용 기사 조회 (PostGIS) |
| `POST` | `/api/v1/matches/auto` | AI 최적 기사 자동 매칭 |
| `POST` | `/api/v1/install-reports` | 설치 완료 사진 업로드 및 AI 검증 |
| `POST` | `/api/v1/chatbot/ask` | RAG 기반 AI 상담 |

**AI 견적 요청 예시:**
```json
// POST /api/v1/orders/estimate
// Content-Type: multipart/form-data
{
  "images": ["aircon1.jpg", "aircon2.jpg"],
  "from_address": "서울시 강남구...",
  "to_address": "서울시 송파구..."
}

// Response 200
{
  "detected": {"brand": "삼성", "model": "AF25...", "type": "스탠드"},
  "ai_estimated_price": 180000,
  "price_detail": {"기본 공임": 120000, "배관 연장 2m": 40000, "앙카 작업": 20000},
  "confidence": 0.94
}
```

### 12. AI 파이프라인 상세

1.  **데이터 수집:** 5000장의 가전 설치 현장 사진 라벨링 (Roboflow)
2.  **학습:** `yolo task=detect mode=train data=appliance.yaml model=yolov8m.pt epochs=100`
3.  **서빙:** FastAPI에서 모델 로드 후 `/vision/analyze` 엔드포인트로 추론. 결과는 Spring Boot가 캐싱.

> **로드맵**
> - [ ] v1.0: 사진 기반 견적 및 매칭 MVP
> - [ ] v1.5: PGVector 기반 챗봇 고도화, 기사 경로 최적화 (TSP)
> - [ ] v2.0: AR 설치 가이드, IoT 가전 연동으로 설치 후 자동 시운전 체크

---
