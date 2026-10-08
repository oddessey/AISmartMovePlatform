
package com.smartmove.domain.order.controller;

import com.smartmove.domain.order.dto.EstimateResponse;
import com.smartmove.infra.ai.AiFeignClient;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/orders")
@RequiredArgsConstructor
public class OrderController {

    private final AiFeignClient aiFeignClient;

    @PostMapping("/estimate")
    public ResponseEntity<EstimateResponse> estimate(
            @RequestPart("images") List<MultipartFile> images,
            @RequestParam String from_address,
            @RequestParam String to_address
    ){
        // 1. AI 서버에 이미지 분석 요청
        Map<String, Object> aiResult = aiFeignClient.analyzeImages(images);

        // 2. AI 결과 기반 견적 로직 (Rule + ML)
        // 예: 기본 공임 + 배관 추가 + 난이도
        String type = (String) aiResult.getOrDefault("type", "wall_mounted");
        int basePrice = type.equals("stand") ? 150000 : 120000;

        Map<String, Integer> detail = Map.of(
                "기본 공임", basePrice,
                "배관 연장 2m", 40000,
                "앙카 작업", 20000
        );
        int total = detail.values().stream().mapToInt(Integer::intValue).sum();

        EstimateResponse res = EstimateResponse.builder()
                .detected(aiResult)
                .ai_estimated_price(total)
                .price_detail(detail)
                .confidence((Double) aiResult.getOrDefault("confidence", 0.9))
                .build();

        return ResponseEntity.ok(res);
    }

    @PostMapping
    public ResponseEntity<String> createOrder(){
        // TODO: Order 저장 로직 + Redis Geo 기사 매칭 Publish
        return ResponseEntity.ok("Order created - matching started");
    }
}
