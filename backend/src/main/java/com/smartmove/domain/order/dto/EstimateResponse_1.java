
package com.smartmove.domain.order.dto;

import lombok.Builder;
import java.util.Map;

@Builder
public record EstimateResponse(
    Map<String, Object> detected,
    int ai_estimated_price,
    Map<String, Integer> price_detail,
    double confidence
) {}
