package com.devops.microservicio;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import java.util.Map;

@RestController
public class HealthController {

    @GetMapping("/health")
    public Map<String, String> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "ok");
        return response;
    }

    @GetMapping("/version")
    public Map<String, String> version() {
        String appVersion = System.getenv("APP_VERSION");
        if (appVersion == null) {
            appVersion = "1.0.0";
        }
        
        Map<String, String> response = new HashMap<>();
        response.put("version", appVersion);
        return response;
    }

}
