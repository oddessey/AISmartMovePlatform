
package com.smartmove.domain.payment.controller;

import com.smartmove.domain.payment.dto.PaymentDto.*;
import com.smartmove.domain.payment.service.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;

    @PostMapping("/create")
    public ResponseEntity<Map<String, Object>> create(
            @RequestBody CreateRequest req,
            @AuthenticationPrincipal UserDetails userDetails
    ){
        // userId 추출 - 실제로는 CustomUserDetails에서 id 가져와야 함
        Long userId = 1L; // TODO: SecurityContext에서 userId 추출
        return ResponseEntity.ok(paymentService.createPayment(req, userId));
    }

    @PostMapping("/confirm")
    public ResponseEntity<ConfirmResponse> confirm(@RequestBody ConfirmRequest req) {
        return ResponseEntity.ok(paymentService.confirmPayment(req));
    }

    @PostMapping("/webhook")
    public ResponseEntity<String> webhook(@RequestBody Map<String, Object> payload) {
        // Toss 웹훅: 결제 상태 변경 시 호출됨 (CANCEL 등)
        // https://docs.tosspayments.com/reference/webhook
        return ResponseEntity.ok("ok");
    }
}
