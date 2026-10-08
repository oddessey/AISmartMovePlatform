
package com.smartmove.domain.payment.service;

import com.smartmove.domain.payment.dto.PaymentDto.*;
import com.smartmove.domain.payment.entity.Payment;
import com.smartmove.domain.payment.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.util.Base64;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${toss.secret-key}")
    private String tossSecretKey;

    @Value("${toss.success-url}")
    private String successUrl;

    @Value("${toss.fail-url}")
    private String failUrl;

    @Transactional
    public Map<String, Object> createPayment(CreateRequest req, Long userId) {
        String tossOrderId = "SM_" + UUID.randomUUID().toString().substring(0, 12);

        Payment payment = Payment.builder()
                .orderId(req.getOrderId())
                .userId(userId)
                .tossOrderId(tossOrderId)
                .orderName(req.getOrderName())
                .amount(req.getAmount())
                .status(Payment.Status.READY)
                .build();
        paymentRepository.save(payment);

        return Map.of(
            "tossOrderId", tossOrderId,
            "orderName", req.getOrderName(),
            "amount", req.getAmount(),
            "successUrl", successUrl,
            "failUrl", failUrl,
            "customerEmail", "test@test.com"
        );
    }

    @Transactional
    public ConfirmResponse confirmPayment(ConfirmRequest req) {
        // 1. DB 검증 - 위변조 방지: amount가 DB와 일치하는지
        Payment payment = paymentRepository.findByTossOrderId(req.getOrderId())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 주문"));

        if (!payment.getAmount().equals(req.getAmount())) {
            throw new IllegalArgumentException("결제 금액 불일치 - 위변조 의심");
        }

        // 2. Toss API 호출
        String encodedKey = Base64.getEncoder().encodeToString((tossSecretKey + ":").getBytes());

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Basic " + encodedKey);
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> body = Map.of(
            "paymentKey", req.getPaymentKey(),
            "orderId", req.getOrderId(),
            "amount", req.getAmount()
        );

        HttpEntity<Map> request = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(
                "https://api.tosspayments.com/v1/payments/confirm",
                request,
                Map.class
            );

            Map resBody = response.getBody();
            log.info("Toss confirm success: {}", resBody);

            // 3. DB 업데이트
            payment.setTossPaymentKey(req.getPaymentKey());
            payment.setStatus(Payment.Status.DONE);
            payment.setApprovedAt((String) resBody.get("approvedAt"));
            payment.setMethod((String) resBody.get("method"));
            paymentRepository.save(payment);

            return ConfirmResponse.builder()
                    .tossPaymentKey(req.getPaymentKey())
                    .orderId(req.getOrderId())
                    .status("DONE")
                    .totalAmount(req.getAmount())
                    .approvedAt((String) resBody.get("approvedAt"))
                    .method((String) resBody.get("method"))
                    .build();

        } catch (Exception e) {
            log.error("Toss confirm failed", e);
            payment.setStatus(Payment.Status.FAILED);
            paymentRepository.save(payment);
            throw new RuntimeException("결제 승인 실패: " + e.getMessage());
        }
    }
}
