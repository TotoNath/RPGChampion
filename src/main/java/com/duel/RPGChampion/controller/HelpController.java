package com.duel.RPGChampion.controller;

import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class HelpController extends ListenerAdapter implements CommandController {

    private final List<CommandController> commandControllers;

    @Autowired
    public HelpController(List<CommandController> commandControllers) {
        this.commandControllers = commandControllers;
    }
    @Override
    public void onMessageReceived(MessageReceivedEvent event) {
        String command = event.getMessage().getContentRaw();

        if (command.equalsIgnoreCase("!help")) {
            StringBuilder helpMessage = new StringBuilder("Available commands:\n");

            commandControllers.forEach(controller -> {
                controller.getCommands().forEach(c -> helpMessage.append(c).append("\n"));
            });

            event.getChannel().sendMessage(helpMessage.toString()).queue();
        }
    }

    @Override
    public List<String> getCommands() {
        return List.of("!help : shows all commands");
    }
}
