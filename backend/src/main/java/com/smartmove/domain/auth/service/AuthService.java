
package com.smartmove.domain.auth.service;

import com.smartmove.domain.auth.dto.AuthDto.*;
import com.smartmove.domain.user.entity.User;
import com.smartmove.domain.user.repository.UserRepository;
import com.smartmove.global.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    @Transactional
    public void signup(SignupRequest req) {
        if (userRepository.existsByEmail(req.getEmail())) {
            throw new IllegalArgumentException("이미 존재하는 이메일입니다");
        }
        User user = User.builder()
                .email(req.getEmail())
                .password(passwordEncoder.encode(req.getPassword()))
                .name(req.getName())
                .phone(req.getPhone())
                .role(User.Role.valueOf(req.getRole()))
                .provider("local")
                .build();
        userRepository.save(user);
    }

    @Transactional(readOnly = true)
    public TokenResponse login(LoginRequest req) {
        User user = userRepository.findByEmail(req.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 이메일"));

        if (!passwordEncoder.matches(req.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("비밀번호 불일치");
        }

        String access = jwtTokenProvider.createAccessToken(user.getId(), user.getRole().name());
        String refresh = jwtTokenProvider.createRefreshToken(user.getId());

        return TokenResponse.builder()
                .accessToken(access)
                .refreshToken(refresh)
                .role(user.getRole().name())
                .userId(user.getId())
                .build();
    }
}
