package com.duel.RPGChampion.controller.pingpong;

import com.duel.RPGChampion.controller.PrefixController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class PingPongRoute {

    @Autowired
    private final PrefixController prefixController;

    public PingPongRoute(PrefixController prefixController) {
        this.prefixController = prefixController;
    }

    @GetMapping("/ping")
    public Map<String, Object> ping(@RequestHeader(value = "message-time", required = false) String messageTime) {
        long responseTime = -1;

        // Calculate response time if the header "message-time" is provided.
        if (messageTime != null) {
            try {
                long messageTimeMillis = Long.parseLong(messageTime);
                long currentTimeMillis = Instant.now().toEpochMilli();
                responseTime = Math.abs(currentTimeMillis - messageTimeMillis);
            } catch (NumberFormatException e) {
                // Invalid header value
            }
        }

        return Map.of(
                "title", "Pong! 🏓",
                "responseTime", responseTime >= 0 ? responseTime + " ms" : "Unavailable",
                "message", "Ping response received."
        );
    }
}
