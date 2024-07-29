package com.duel.RPGChampion.controller;

import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.springframework.stereotype.Component;

import java.util.List;

import static com.duel.RPGChampion.controller.PrefixController.prefix;

@Component
public class PingPongController extends ListenerAdapter implements CommandController {

    @Override
    public void onMessageReceived(MessageReceivedEvent event) {
        if (event.getAuthor().isBot()) {
            return;
        }

        String message = event.getMessage().getContentRaw();

        if (message.equalsIgnoreCase(prefix+"ping")) {
            event.getChannel().sendMessage(prefix+"pong").queue();
        }
    }

    @Override
    public List<String> getCommands() {
        return List.of(prefix+"ping : returns pong");
    }
}