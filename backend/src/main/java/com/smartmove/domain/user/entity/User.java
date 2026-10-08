
package com.smartmove.domain.user.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter @Setter @Builder
@NoArgsConstructor @AllArgsConstructor
public class User {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String email;

    private String password; // 소셜 로그인시 null

    @Column(nullable = false)
    private String name;

    private String phone;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private Role role = Role.CLIENT;

    private String provider; // local, kakao
    private String providerId;

    @CreationTimestamp
    private LocalDateTime createdAt;

    public enum Role { CLIENT, ENGINEER, ADMIN }
}
