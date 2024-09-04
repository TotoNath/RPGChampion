package com.duel.RPGChampion.controller;

import com.duel.RPGChampion.services.UserService;
import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;


@Controller
public class UserController extends ListenerAdapter implements CommandController {

    @Autowired
    private final PrefixController prefixController;

    @Autowired
    private UserService userService;

    public UserController(PrefixController prefixController) {
        this.prefixController = prefixController;
    }

    @Override
    public void onMessageReceived(MessageReceivedEvent event) {
        String command = event.getMessage().getContentRaw();
        String lowerCommand = command.toLowerCase();

        if (lowerCommand.equalsIgnoreCase(prefixController.getPrefix(event) + "playerCount")) {
            event.getChannel().sendMessage("The number of all players is : " + userService.getPlayerCount() + "\n").queue();
        }
    }

    @Override
    public List<String> getCommands(String guildId) {
        return List.of(prefixController.getPrefix(guildId) + "playerCount : The number of users");
    }
}
