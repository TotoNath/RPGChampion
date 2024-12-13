package com.duel.RPGChampion.controller.user;

import com.duel.RPGChampion.controller.PrefixController;
import com.duel.RPGChampion.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class UserRoute {

    @Autowired
    private final PrefixController prefixController;

    @Autowired
    private final UserService userService;

    public UserRoute(PrefixController prefixController, UserService userService) {
        this.prefixController = prefixController;
        this.userService = userService;
    }

    /**
     * Endpoint to get the player count.
     *
     * @return A JSON response with the number of players.
     */
    @GetMapping("/playerCount")
    public Map<String, Object> getPlayerCount() {
        int playerCount = userService.getPlayerCount();

        return Map.of(
                "title", "Player Count 👥",
                "playerCount", playerCount,
                "message", "The number of all players is: " + playerCount
        );
    }

    @GetMapping("/gold")
    public Map<String, Object> getGold() {
        int playerCount = userService.getPlayerCount();

        return Map.of(
                "title", "Player Count 👥",
                "playerCount", playerCount,
                "message", "The number of all players is: " + playerCount
        );
    }
}
