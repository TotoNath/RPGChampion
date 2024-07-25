package com.duel.RPGChampion.controller;

import net.dv8tion.jda.api.events.message.MessageReceivedEvent;

import java.util.List;

public interface CommandController {

    void onMessageReceived(MessageReceivedEvent event);

    List<String> getCommands();
}
