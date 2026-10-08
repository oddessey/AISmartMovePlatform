
package com.smartmove.domain.auth.dto;

import lombok.*;

public class AuthDto {
    @Getter @Setter
    public static class SignupRequest {
        private String email;
        private String password;
        private String name;
        private String phone;
        private String role; // CLIENT, ENGINEER
    }

    @Getter @Setter
    public static class LoginRequest {
        private String email;
        private String password;
    }

    @Builder @Getter
    public static class TokenResponse {
        private String accessToken;
        private String refreshToken;
        private String role;
        private Long userId;
    }
}
