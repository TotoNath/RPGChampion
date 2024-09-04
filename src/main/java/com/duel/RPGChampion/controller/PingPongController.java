package com.duel.RPGChampion.controller;

import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;


@Component
public class PingPongController extends ListenerAdapter implements CommandController {

    @Autowired
    private final PrefixController prefixController;

    public PingPongController(PrefixController prefixController) {
        this.prefixController = prefixController;
    }

    @Override
    public void onMessageReceived(@NotNull MessageReceivedEvent event) {
        String prefix = prefixController.getPrefix(event);
        if (event.getAuthor().isBot()) {
            return;
        }

        String message = event.getMessage().getContentRaw();

        if (message.equalsIgnoreCase(prefix + "ping")) {
            event.getChannel().sendMessage(prefix + "pong").queue();
        }
    }

    @Override
    public List<String> getCommands(String guildId) {
        String prefix = prefixController.getPrefix(guildId);

        return List.of(prefix + "ping : returns pong");
    }
}