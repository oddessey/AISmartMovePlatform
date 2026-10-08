
package com.smartmove.domain.payment.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;

@Entity
@Getter @Setter @Builder
@NoArgsConstructor @AllArgsConstructor
public class Payment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long orderId;
    private Long userId;

    @Column(unique = true)
    private String tossPaymentKey; // toss가 주는 paymentKey

    private String orderName; // 예: "LG 에어컨 이전설치"
    private Integer amount; // 180000

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private Status status = Status.READY;

    private String tossOrderId; // 우리가 생성한 orderId (UUID)

    private String approvedAt;
    private String method; // 카드, 계좌이체 등

    @CreationTimestamp
    private LocalDateTime createdAt;

    public enum Status { READY, IN_PROGRESS, DONE, CANCELED, FAILED }
}
