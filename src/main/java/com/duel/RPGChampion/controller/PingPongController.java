package com.duel.RPGChampion.controller;

import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class PingPongController extends ListenerAdapter implements CommandController {

    @Override
    public void onMessageReceived(MessageReceivedEvent event) {
        if (event.getAuthor().isBot()) {
            return;
        }

        String message = event.getMessage().getContentRaw();

        if (message.equalsIgnoreCase("!ping")) {
            event.getChannel().sendMessage("!pong").queue();
        }
    }

    @Override
    public List<String> getCommands() {
        return List.of("!ping : returns pong");
    }
}