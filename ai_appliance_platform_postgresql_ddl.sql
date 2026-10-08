-- AI 가전 이전설치 플랫폼 PostgreSQL DDL
-- PostgreSQL 14+
BEGIN;
DROP SCHEMA IF EXISTS appliance_platform CASCADE;
CREATE SCHEMA appliance_platform;
SET search_path TO appliance_platform, public;

CREATE TABLE code_group (
 code_group_id BIGSERIAL PRIMARY KEY,
 group_code VARCHAR(50) NOT NULL UNIQUE,
 group_name VARCHAR(100) NOT NULL,
 description VARCHAR(500),
 use_yn CHAR(1) NOT NULL DEFAULT 'Y',
 sort_order INTEGER NOT NULL DEFAULT 0,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT ck_code_group_use CHECK (use_yn IN ('Y','N'))
);

CREATE TABLE code (
 code_id BIGSERIAL PRIMARY KEY,
 code_group_id BIGINT NOT NULL REFERENCES code_group(code_group_id),
 code VARCHAR(50) NOT NULL,
 code_name VARCHAR(100) NOT NULL,
 description VARCHAR(500),
 sort_order INTEGER NOT NULL DEFAULT 0,
 use_yn CHAR(1) NOT NULL DEFAULT 'Y',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT uk_code_group_code UNIQUE(code_group_id,code),
 CONSTRAINT ck_code_use CHECK(use_yn IN ('Y','N'))
);

CREATE TABLE app_user (
 user_id BIGSERIAL PRIMARY KEY,
 login_id VARCHAR(100) NOT NULL UNIQUE,
 password_hash VARCHAR(255),
 user_name VARCHAR(100) NOT NULL,
 phone_no VARCHAR(30) NOT NULL,
 email VARCHAR(200),
 user_type VARCHAR(30) NOT NULL,
 status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
 last_login_at TIMESTAMP,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT ck_user_type CHECK(user_type IN('CUSTOMER','TECHNICIAN','ADMIN','PARTNER')),
 CONSTRAINT ck_user_status CHECK(status IN('ACTIVE','INACTIVE','LOCKED','WITHDRAWN'))
);

CREATE TABLE customer (
 customer_id BIGINT PRIMARY KEY REFERENCES app_user(user_id),
 marketing_agree BOOLEAN NOT NULL DEFAULT FALSE,
 birth_date DATE,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE partner (
 partner_id BIGSERIAL PRIMARY KEY,
 partner_name VARCHAR(200) NOT NULL,
 business_no VARCHAR(20) NOT NULL UNIQUE,
 representative VARCHAR(100),
 phone_no VARCHAR(30),
 email VARCHAR(200),
 zip_code VARCHAR(10),
 address VARCHAR(500),
 address_detail VARCHAR(300),
 status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE technician (
 technician_id BIGINT PRIMARY KEY REFERENCES app_user(user_id),
 partner_id BIGINT REFERENCES partner(partner_id),
 technician_grade VARCHAR(30),
 career_years INTEGER NOT NULL DEFAULT 0,
 rating NUMERIC(3,2) NOT NULL DEFAULT 0,
 completed_count INTEGER NOT NULL DEFAULT 0,
 status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT ck_tech_rating CHECK(rating BETWEEN 0 AND 5)
);

CREATE TABLE appliance_category (
 category_id BIGSERIAL PRIMARY KEY,
 parent_category_id BIGINT REFERENCES appliance_category(category_id),
 category_code VARCHAR(50) NOT NULL UNIQUE,
 category_name VARCHAR(100) NOT NULL,
 sort_order INTEGER NOT NULL DEFAULT 0,
 use_yn CHAR(1) NOT NULL DEFAULT 'Y',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE appliance_brand (
 brand_id BIGSERIAL PRIMARY KEY,
 brand_code VARCHAR(50) NOT NULL UNIQUE,
 brand_name VARCHAR(100) NOT NULL,
 use_yn CHAR(1) NOT NULL DEFAULT 'Y',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE appliance_model (
 model_id BIGSERIAL PRIMARY KEY,
 category_id BIGINT NOT NULL REFERENCES appliance_category(category_id),
 brand_id BIGINT NOT NULL REFERENCES appliance_brand(brand_id),
 model_no VARCHAR(100) NOT NULL,
 model_name VARCHAR(200),
 width_mm INTEGER,
 height_mm INTEGER,
 depth_mm INTEGER,
 weight_kg NUMERIC(10,2),
 installation_type VARCHAR(50),
 required_persons INTEGER NOT NULL DEFAULT 1,
 default_install_time INTEGER,
 difficulty_level VARCHAR(30),
 specification_json JSONB,
 use_yn CHAR(1) NOT NULL DEFAULT 'Y',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT uk_model UNIQUE(brand_id,model_no)
);

CREATE TABLE move_request (
 move_request_id BIGSERIAL PRIMARY KEY,
 customer_id BIGINT NOT NULL REFERENCES customer(customer_id),
 request_no VARCHAR(30) NOT NULL UNIQUE,
 request_status VARCHAR(30) NOT NULL DEFAULT 'DRAFT',
 requested_date DATE,
 requested_start_time TIME,
 requested_end_time TIME,
 memo TEXT,
 estimated_amount NUMERIC(15,2) NOT NULL DEFAULT 0,
 final_amount NUMERIC(15,2) NOT NULL DEFAULT 0,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE move_address (
 move_address_id BIGSERIAL PRIMARY KEY,
 move_request_id BIGINT NOT NULL REFERENCES move_request(move_request_id),
 address_type VARCHAR(20) NOT NULL,
 zip_code VARCHAR(10),
 address VARCHAR(500) NOT NULL,
 address_detail VARCHAR(300),
 floor_no INTEGER,
 elevator_yn CHAR(1),
 parking_yn CHAR(1),
 latitude NUMERIC(10,7),
 longitude NUMERIC(10,7),
 access_memo VARCHAR(1000),
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT ck_address_type CHECK(address_type IN('FROM','TO'))
);

CREATE TABLE move_appliance (
 move_appliance_id BIGSERIAL PRIMARY KEY,
 move_request_id BIGINT NOT NULL REFERENCES move_request(move_request_id),
 model_id BIGINT REFERENCES appliance_model(model_id),
 category_id BIGINT NOT NULL REFERENCES appliance_category(category_id),
 brand_name VARCHAR(100),
 model_no VARCHAR(100),
 appliance_name VARCHAR(200),
 quantity INTEGER NOT NULL DEFAULT 1,
 removal_required BOOLEAN NOT NULL DEFAULT TRUE,
 installation_required BOOLEAN NOT NULL DEFAULT TRUE,
 special_condition TEXT,
 estimated_weight_kg NUMERIC(10,2),
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT ck_move_appliance_qty CHECK(quantity > 0)
);

CREATE TABLE file_object (
 file_id BIGSERIAL PRIMARY KEY,
 owner_type VARCHAR(50) NOT NULL,
 owner_id BIGINT NOT NULL,
 file_type VARCHAR(50),
 original_name VARCHAR(500) NOT NULL,
 storage_path VARCHAR(1000) NOT NULL,
 content_type VARCHAR(100),
 file_size BIGINT,
 checksum VARCHAR(128),
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ai_analysis (
 ai_analysis_id BIGSERIAL PRIMARY KEY,
 move_request_id BIGINT NOT NULL REFERENCES move_request(move_request_id),
 move_appliance_id BIGINT REFERENCES move_appliance(move_appliance_id),
 analysis_type VARCHAR(50) NOT NULL,
 ai_model_name VARCHAR(100),
 confidence_score NUMERIC(5,4),
 analysis_status VARCHAR(30) NOT NULL DEFAULT 'REQUESTED',
 raw_result JSONB,
 normalized_result JSONB,
 reviewed_yn CHAR(1) NOT NULL DEFAULT 'N',
 reviewed_by BIGINT REFERENCES app_user(user_id),
 reviewed_at TIMESTAMP,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT ck_ai_conf CHECK(confidence_score IS NULL OR confidence_score BETWEEN 0 AND 1)
);

CREATE TABLE ai_analysis_item (
 ai_analysis_item_id BIGSERIAL PRIMARY KEY,
 ai_analysis_id BIGINT NOT NULL REFERENCES ai_analysis(ai_analysis_id),
 result_type VARCHAR(50) NOT NULL,
 result_key VARCHAR(100),
 result_value TEXT,
 confidence_score NUMERIC(5,4),
 accepted_yn CHAR(1) NOT NULL DEFAULT 'N'
);

CREATE TABLE price_rule (
 price_rule_id BIGSERIAL PRIMARY KEY,
 rule_code VARCHAR(50) NOT NULL UNIQUE,
 rule_name VARCHAR(200) NOT NULL,
 category_id BIGINT REFERENCES appliance_category(category_id),
 rule_type VARCHAR(50) NOT NULL,
 condition_json JSONB NOT NULL DEFAULT '{}'::jsonb,
 calculation_type VARCHAR(30) NOT NULL,
 calculation_value NUMERIC(15,2) NOT NULL DEFAULT 0,
 priority INTEGER NOT NULL DEFAULT 0,
 start_date DATE,
 end_date DATE,
 use_yn CHAR(1) NOT NULL DEFAULT 'Y',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE quote (
 quote_id BIGSERIAL PRIMARY KEY,
 move_request_id BIGINT NOT NULL REFERENCES move_request(move_request_id),
 technician_id BIGINT REFERENCES technician(technician_id),
 quote_no VARCHAR(30) NOT NULL UNIQUE,
 quote_status VARCHAR(30) NOT NULL DEFAULT 'DRAFT',
 base_amount NUMERIC(15,2) NOT NULL DEFAULT 0,
 additional_amount NUMERIC(15,2) NOT NULL DEFAULT 0,
 discount_amount NUMERIC(15,2) NOT NULL DEFAULT 0,
 total_amount NUMERIC(15,2) NOT NULL DEFAULT 0,
 valid_until TIMESTAMP,
 technician_memo TEXT,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE quote_item (
 quote_item_id BIGSERIAL PRIMARY KEY,
 quote_id BIGINT NOT NULL REFERENCES quote(quote_id),
 move_appliance_id BIGINT REFERENCES move_appliance(move_appliance_id),
 item_type VARCHAR(50) NOT NULL,
 item_name VARCHAR(200) NOT NULL,
 quantity NUMERIC(10,2) NOT NULL DEFAULT 1,
 unit_price NUMERIC(15,2) NOT NULL DEFAULT 0,
 amount NUMERIC(15,2) NOT NULL DEFAULT 0,
 price_rule_id BIGINT REFERENCES price_rule(price_rule_id),
 ai_recommended_yn CHAR(1) NOT NULL DEFAULT 'N'
);

CREATE TABLE reservation (
 reservation_id BIGSERIAL PRIMARY KEY,
 move_request_id BIGINT NOT NULL REFERENCES move_request(move_request_id),
 quote_id BIGINT REFERENCES quote(quote_id),
 technician_id BIGINT REFERENCES technician(technician_id),
 reservation_no VARCHAR(30) NOT NULL UNIQUE,
 reservation_date DATE NOT NULL,
 start_time TIME,
 end_time TIME,
 status VARCHAR(30) NOT NULL DEFAULT 'RESERVED',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE installation (
 installation_id BIGSERIAL PRIMARY KEY,
 reservation_id BIGINT NOT NULL UNIQUE REFERENCES reservation(reservation_id),
 technician_id BIGINT NOT NULL REFERENCES technician(technician_id),
 status VARCHAR(30) NOT NULL DEFAULT 'WAITING',
 started_at TIMESTAMP,
 completed_at TIMESTAMP,
 customer_confirmed_yn CHAR(1) NOT NULL DEFAULT 'N',
 customer_signature_file_id BIGINT REFERENCES file_object(file_id),
 technician_memo TEXT,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE installation_item (
 installation_item_id BIGSERIAL PRIMARY KEY,
 installation_id BIGINT NOT NULL REFERENCES installation(installation_id),
 move_appliance_id BIGINT NOT NULL REFERENCES move_appliance(move_appliance_id),
 removal_status VARCHAR(30),
 transport_status VARCHAR(30),
 installation_status VARCHAR(30),
 started_at TIMESTAMP,
 completed_at TIMESTAMP,
 memo TEXT
);

CREATE TABLE payment (
 payment_id BIGSERIAL PRIMARY KEY,
 move_request_id BIGINT NOT NULL REFERENCES move_request(move_request_id),
 reservation_id BIGINT REFERENCES reservation(reservation_id),
 payment_no VARCHAR(50) NOT NULL UNIQUE,
 pg_provider VARCHAR(50),
 pg_transaction_id VARCHAR(200),
 payment_method VARCHAR(30),
 payment_amount NUMERIC(15,2) NOT NULL,
 payment_status VARCHAR(30) NOT NULL DEFAULT 'READY',
 paid_at TIMESTAMP,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE refund (
 refund_id BIGSERIAL PRIMARY KEY,
 payment_id BIGINT NOT NULL REFERENCES payment(payment_id),
 refund_amount NUMERIC(15,2) NOT NULL,
 refund_reason VARCHAR(500),
 refund_status VARCHAR(30) NOT NULL DEFAULT 'REQUESTED',
 pg_refund_id VARCHAR(200),
 refunded_at TIMESTAMP,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE settlement (
 settlement_id BIGSERIAL PRIMARY KEY,
 reservation_id BIGINT NOT NULL UNIQUE REFERENCES reservation(reservation_id),
 technician_id BIGINT NOT NULL REFERENCES technician(technician_id),
 total_amount NUMERIC(15,2) NOT NULL DEFAULT 0,
 platform_fee NUMERIC(15,2) NOT NULL DEFAULT 0,
 adjustment_amount NUMERIC(15,2) NOT NULL DEFAULT 0,
 settlement_amount NUMERIC(15,2) NOT NULL DEFAULT 0,
 settlement_status VARCHAR(30) NOT NULL DEFAULT 'READY',
 settlement_date DATE,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE review (
 review_id BIGSERIAL PRIMARY KEY,
 reservation_id BIGINT NOT NULL UNIQUE REFERENCES reservation(reservation_id),
 customer_id BIGINT NOT NULL REFERENCES customer(customer_id),
 technician_id BIGINT NOT NULL REFERENCES technician(technician_id),
 rating NUMERIC(2,1) NOT NULL,
 content TEXT,
 response_content TEXT,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT ck_review_rating CHECK(rating BETWEEN 1 AND 5)
);

CREATE TABLE cs_inquiry (
 inquiry_id BIGSERIAL PRIMARY KEY,
 customer_id BIGINT REFERENCES customer(customer_id),
 move_request_id BIGINT REFERENCES move_request(move_request_id),
 inquiry_type VARCHAR(50),
 title VARCHAR(300) NOT NULL,
 content TEXT NOT NULL,
 status VARCHAR(30) NOT NULL DEFAULT 'OPEN',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cs_answer (
 answer_id BIGSERIAL PRIMARY KEY,
 inquiry_id BIGINT NOT NULL REFERENCES cs_inquiry(inquiry_id),
 answer_user_id BIGINT NOT NULL REFERENCES app_user(user_id),
 content TEXT NOT NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE favorite (
 favorite_id BIGSERIAL PRIMARY KEY,
 customer_id BIGINT NOT NULL REFERENCES customer(customer_id),
 technician_id BIGINT NOT NULL REFERENCES technician(technician_id),
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT uk_favorite UNIQUE(customer_id,technician_id)
);

CREATE TABLE notification (
 notification_id BIGSERIAL PRIMARY KEY,
 user_id BIGINT NOT NULL REFERENCES app_user(user_id),
 notification_type VARCHAR(30),
 title VARCHAR(200) NOT NULL,
 message TEXT NOT NULL,
 channel VARCHAR(30) NOT NULL,
 reference_type VARCHAR(50),
 reference_id BIGINT,
 read_yn CHAR(1) NOT NULL DEFAULT 'N',
 sent_at TIMESTAMP,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_log (
 audit_log_id BIGSERIAL PRIMARY KEY,
 user_id BIGINT REFERENCES app_user(user_id),
 action_type VARCHAR(50) NOT NULL,
 target_type VARCHAR(50),
 target_id VARCHAR(100),
 request_ip INET,
 old_data JSONB,
 new_data JSONB,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 추가 운영 테이블
CREATE TABLE technician_service_area (
 service_area_id BIGSERIAL PRIMARY KEY,
 technician_id BIGINT NOT NULL REFERENCES technician(technician_id),
 sido_code VARCHAR(20),
 sido_name VARCHAR(100),
 sigungu_code VARCHAR(20),
 sigungu_name VARCHAR(100),
 use_yn CHAR(1) NOT NULL DEFAULT 'Y',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT uk_service_area UNIQUE(technician_id,sido_code,sigungu_code)
);

CREATE TABLE technician_appliance_category (
 technician_category_id BIGSERIAL PRIMARY KEY,
 technician_id BIGINT NOT NULL REFERENCES technician(technician_id),
 category_id BIGINT NOT NULL REFERENCES appliance_category(category_id),
 skill_level VARCHAR(30),
 use_yn CHAR(1) NOT NULL DEFAULT 'Y',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT uk_technician_category UNIQUE(technician_id,category_id)
);

CREATE TABLE business_hours (
 business_hours_id BIGSERIAL PRIMARY KEY,
 technician_id BIGINT NOT NULL REFERENCES technician(technician_id),
 day_of_week SMALLINT NOT NULL,
 start_time TIME,
 end_time TIME,
 closed_yn CHAR(1) NOT NULL DEFAULT 'N',
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT ck_business_day CHECK(day_of_week BETWEEN 0 AND 6)
);

-- INDEX
CREATE INDEX idx_user_type_status ON app_user(user_type,status);
CREATE INDEX idx_user_phone ON app_user(phone_no);
CREATE INDEX idx_technician_partner ON technician(partner_id);
CREATE INDEX idx_technician_status ON technician(status);
CREATE INDEX idx_model_category ON appliance_model(category_id);
CREATE INDEX idx_model_brand ON appliance_model(brand_id);
CREATE INDEX idx_model_no ON appliance_model(model_no);
CREATE INDEX idx_move_customer ON move_request(customer_id);
CREATE INDEX idx_move_status ON move_request(request_status);
CREATE INDEX idx_move_date ON move_request(requested_date);
CREATE INDEX idx_address_request ON move_address(move_request_id,address_type);
CREATE INDEX idx_move_appliance_request ON move_appliance(move_request_id);
CREATE INDEX idx_ai_request ON ai_analysis(move_request_id);
CREATE INDEX idx_ai_appliance ON ai_analysis(move_appliance_id);
CREATE INDEX idx_price_rule_category ON price_rule(category_id);
CREATE INDEX idx_quote_request ON quote(move_request_id);
CREATE INDEX idx_quote_technician ON quote(technician_id);
CREATE INDEX idx_quote_item_quote ON quote_item(quote_id);
CREATE INDEX idx_reservation_date ON reservation(reservation_date);
CREATE INDEX idx_reservation_technician_date ON reservation(technician_id,reservation_date);
CREATE INDEX idx_reservation_status ON reservation(status);
CREATE INDEX idx_installation_technician ON installation(technician_id);
CREATE INDEX idx_payment_request ON payment(move_request_id);
CREATE INDEX idx_payment_status ON payment(payment_status);
CREATE INDEX idx_refund_payment ON refund(payment_id);
CREATE INDEX idx_settlement_technician ON settlement(technician_id);
CREATE INDEX idx_review_technician ON review(technician_id);
CREATE INDEX idx_cs_customer ON cs_inquiry(customer_id);
CREATE INDEX idx_notification_user ON notification(user_id,read_yn);
CREATE INDEX idx_audit_target ON audit_log(target_type,target_id);
CREATE INDEX idx_audit_created ON audit_log(created_at);
CREATE INDEX idx_service_area_region ON technician_service_area(sido_code,sigungu_code);

-- COMMENTS
COMMENT ON SCHEMA appliance_platform IS 'AI 가전 이전설치 플랫폼';
COMMENT ON TABLE app_user IS '플랫폼 사용자 계정';
COMMENT ON TABLE customer IS '고객';
COMMENT ON TABLE partner IS '협력업체';
COMMENT ON TABLE technician IS '이전설치 기사';
COMMENT ON TABLE appliance_category IS '가전 카테고리';
COMMENT ON TABLE appliance_brand IS '가전 브랜드';
COMMENT ON TABLE appliance_model IS '가전 모델 마스터';
COMMENT ON TABLE move_request IS '가전 이전설치 요청';
COMMENT ON TABLE move_address IS '출발지/도착지 주소';
COMMENT ON TABLE move_appliance IS '이전 대상 가전';
COMMENT ON TABLE file_object IS '파일 및 이미지';
COMMENT ON TABLE ai_analysis IS 'AI 분석 결과';
COMMENT ON TABLE ai_analysis_item IS 'AI 분석 상세 결과';
COMMENT ON TABLE price_rule IS '가격 산정 Rule';
COMMENT ON TABLE quote IS '견적';
COMMENT ON TABLE quote_item IS '견적 상세';
COMMENT ON TABLE reservation IS '예약';
COMMENT ON TABLE installation IS '설치 작업';
COMMENT ON TABLE installation_item IS '가전별 작업';
COMMENT ON TABLE payment IS '결제';
COMMENT ON TABLE refund IS '환불';
COMMENT ON TABLE settlement IS '기사/파트너 정산';
COMMENT ON TABLE review IS '고객 리뷰';
COMMENT ON TABLE cs_inquiry IS '고객 문의';
COMMENT ON TABLE cs_answer IS '문의 답변';
COMMENT ON TABLE notification IS '알림';
COMMENT ON TABLE audit_log IS '감사 로그';
COMMENT ON COLUMN price_rule.condition_json IS '가격 Rule 적용조건 JSON';
COMMENT ON COLUMN ai_analysis.raw_result IS 'AI 원본 응답 JSON';
COMMENT ON COLUMN ai_analysis.normalized_result IS '업무용 정규화 결과 JSON';
COMMENT ON COLUMN quote_item.price_rule_id IS '해당 견적금액 산출에 사용된 가격 Rule';

-- 초기 코드
INSERT INTO code_group(group_code,group_name) VALUES
('USER_TYPE','사용자 유형'),
('MOVE_STATUS','이전설치 상태'),
('PAYMENT_STATUS','결제 상태'),
('INSTALL_STATUS','설치 작업 상태'),
('QUOTE_STATUS','견적 상태');

INSERT INTO code(code_group_id,code,code_name)
SELECT code_group_id,'CUSTOMER','고객' FROM code_group WHERE group_code='USER_TYPE';
INSERT INTO code(code_group_id,code,code_name)
SELECT code_group_id,'TECHNICIAN','기사' FROM code_group WHERE group_code='USER_TYPE';
INSERT INTO code(code_group_id,code,code_name)
SELECT code_group_id,'ADMIN','관리자' FROM code_group WHERE group_code='USER_TYPE';
INSERT INTO code(code_group_id,code,code_name)
SELECT code_group_id,'PARTNER','파트너' FROM code_group WHERE group_code='USER_TYPE';

COMMIT;
