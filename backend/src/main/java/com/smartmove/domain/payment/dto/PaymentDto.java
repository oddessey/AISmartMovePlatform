
package com.smartmove.domain.payment.dto;

import lombok.*;

public class PaymentDto {
    @Getter @Setter
    public static class CreateRequest {
        private Long orderId;
        private Integer amount;
        private String orderName;
    }

    @Getter @Setter
    public static class ConfirmRequest {
        private String paymentKey;
        private String orderId;
        private Integer amount;
    }

    @Builder @Getter
    public static class ConfirmResponse {
        private String tossPaymentKey;
        private String orderId;
        private String status;
        private Integer totalAmount;
        private String approvedAt;
        private String method;
    }
}
