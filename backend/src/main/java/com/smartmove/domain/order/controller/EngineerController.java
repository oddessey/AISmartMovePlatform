
package com.smartmove.domain.order.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/engineers")
@RequiredArgsConstructor
public class EngineerController {

    @GetMapping("/nearby")
    public ResponseEntity<List<Map<String, Object>>> nearby(
            @RequestParam double lat,
            @RequestParam double lng,
            @RequestParam(defaultValue = "5km") String radius
    ){
        // TODO: PostGIS ST_DWithin 쿼리로 실제 구현
        // 지금은 Mock
        List<Map<String, Object>> mock = List.of(
            Map.of("id", 1, "lat", lat+0.001, "lng", lng+0.002, "name", "김기사", "rating", 4.9, "isAvailable", true),
            Map.of("id", 2, "lat", lat-0.002, "lng", lng+0.001, "name", "박설치", "rating", 4.8, "isAvailable", true),
            Map.of("id", 3, "lat", lat+0.003, "lng", lng-0.001, "name", "이명장", "rating", 5.0, "isAvailable", false)
        );
        return ResponseEntity.ok(mock);
    }
}
