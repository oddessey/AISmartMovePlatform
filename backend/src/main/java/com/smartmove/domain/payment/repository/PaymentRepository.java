
package com.smartmove.domain.payment.repository;

import com.smartmove.domain.payment.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
    Optional<Payment> findByTossOrderId(String tossOrderId);
    Optional<Payment> findByTossPaymentKey(String paymentKey);
}
