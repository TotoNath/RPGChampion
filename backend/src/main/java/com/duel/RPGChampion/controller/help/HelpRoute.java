package com.duel.RPGChampion.controller.help;

import com.duel.RPGChampion.controller.CommandController;
import com.duel.RPGChampion.services.GuildService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api")
public class HelpRoute {

    private final List<CommandController> commandControllers;
    private final GuildService guildService;

    @Autowired
    public HelpRoute(List<CommandController> commandControllers, GuildService guildService) {
        this.commandControllers = commandControllers;
        this.guildService = guildService;
    }

    @GetMapping("/getBotGuilds")
    public List<String> getAllGuildsIdWhereBotIsConnected() {
        return guildService.getConnectedGuildIds();
    }

    @GetMapping("/help")
    public List<String> getHelp(@RequestParam(name = "guildId", required = false) String guildId) {
        return getAllCommands(guildId);
    }

    private List<String> getAllCommands(String guildId) {
        return commandControllers.stream()
                .flatMap(controller -> controller.getCommands(guildId).stream())
                .toList();
    }

}
