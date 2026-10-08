
package com.smartmove.infra.ai;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.Map;

@FeignClient(name = "ai-server", url = "${ai.server.url}")
public interface AiFeignClient {

    @PostMapping(value = "/api/v1/vision/analyze", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    Map<String, Object> analyzeImages(@RequestPart("images") List<MultipartFile> images);
}
