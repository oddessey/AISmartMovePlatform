
package com.smartmove.global.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import javax.crypto.SecretKey;
import java.util.Date;

@Component
public class JwtTokenProvider {

    private final SecretKey key;
    private final long accessExp = 1000 * 60 * 60; // 1시간
    private final long refreshExp = 1000 * 60 * 60 * 24 * 7; // 7일

    public JwtTokenProvider(@Value("${jwt.secret}") String secret) {
        this.key = Keys.hmacShaKeyFor(secret.getBytes());
    }

    public String createAccessToken(Long userId, String role) {
        return Jwts.builder()
                .subject(String.valueOf(userId))
                .claim("role", role)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + accessExp))
                .signWith(key)
                .compact();
    }

    public String createRefreshToken(Long userId) {
        return Jwts.builder()
                .subject(String.valueOf(userId))
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + refreshExp))
                .signWith(key)
                .compact();
    }

    public boolean validate(String token) {
        try {
            Jwts.parser().verifyWith(key).build().parseSignedClaims(token);
            return true;
        } catch (JwtException e) {
            return false;
        }
    }

    public Long getUserId(String token) {
        return Long.parseLong(Jwts.parser().verifyWith(key).build()
                .parseSignedClaims(token).getPayload().getSubject());
    }
}
