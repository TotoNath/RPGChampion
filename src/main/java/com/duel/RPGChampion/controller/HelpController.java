package com.duel.RPGChampion.controller;

import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.entities.Message;
import net.dv8tion.jda.api.entities.emoji.Emoji;
import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.events.message.react.MessageReactionAddEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.awt.*;
import java.util.ArrayList;
import java.util.List;

import static com.duel.RPGChampion.controller.PrefixController.prefix;

@Controller
public class HelpController extends ListenerAdapter implements CommandController {

    public static final String LEFT_ARROW = "⬅️";
    public static final String RIGHT_ARROW = "➡️";
    private final List<CommandController> commandControllers;
    private final int COMMANDS_PER_PAGE = 4;

    @Autowired
    public HelpController(List<CommandController> commandControllers) {
        this.commandControllers = commandControllers;
    }

    @Override
    public void onMessageReceived(MessageReceivedEvent event) {
        String command = event.getMessage().getContentRaw();

        if (command.equalsIgnoreCase(prefix + "help")) {
            List<String> allCommands = new ArrayList<>();
            commandControllers.forEach(controller -> allCommands.addAll(controller.getCommands()));

            sendHelpMessage(event, allCommands, 0);
        }
    }

    @Override
    public List<String> getCommands() {
        return List.of(prefix + "help : shows all commands");
    }

    private void sendHelpMessage(MessageReceivedEvent event, List<String> commands, int pageIndex) {
        int totalPages = (int) Math.ceil((double) commands.size() / COMMANDS_PER_PAGE);

        EmbedBuilder embedBuilder = new EmbedBuilder();
        embedBuilder.setTitle("Available Commands (Page " + (pageIndex + 1) + "/" + totalPages + ")");
        embedBuilder.setColor(Color.BLUE);

        StringBuilder helpMessage = new StringBuilder();
        int start = pageIndex * COMMANDS_PER_PAGE;
        int end = Math.min(start + COMMANDS_PER_PAGE, commands.size());
        for (int i = start; i < end; i++) {
            helpMessage.append(commands.get(i)).append("\n");
        }

        embedBuilder.addField("Commands", helpMessage.toString(), false);

        event.getChannel().sendMessageEmbeds(embedBuilder.build()).queue(message -> {
            if (totalPages > 1) {
                if (pageIndex > 0) {
                    message.addReaction(Emoji.fromUnicode(LEFT_ARROW)).queue(); // Emoji gauche (⬅️)
                }
                if (pageIndex < totalPages - 1) {
                    message.addReaction(Emoji.fromUnicode(RIGHT_ARROW)).queue(); // Emoji droit (➡️)
                }
            }
        });
    }

    @Override
    public void onMessageReactionAdd(MessageReactionAddEvent event) {
        Message message = event.retrieveMessage().complete();
        if (message.getAuthor().isBot() && !event.getUser().isBot()) {
            String[] titleParts = message.getEmbeds().get(0).getTitle().split(" ");
            int currentPage = 0;
            int totalPages = 0;

            try {
                currentPage = Integer.parseInt(titleParts[titleParts.length - 1].split("/")[0]) - 1; // Page index position
                totalPages = Integer.parseInt(titleParts[titleParts.length - 1].split("/")[1].replace(")", ""));
            } catch (NumberFormatException e) {
                // Log or handle the error
                e.printStackTrace();
                return;
            }

            List<String> allCommands = new ArrayList<>();
            commandControllers.forEach(controller -> allCommands.addAll(controller.getCommands()));

            if (event.getReaction().getEmoji().getName().equals(LEFT_ARROW)) {
                if (currentPage > 0) {
                    updateHelpMessage(message, allCommands, currentPage - 1);
                }
            } else if (event.getReaction().getEmoji().getName().equals(RIGHT_ARROW)) {
                if (currentPage < totalPages - 1) {
                    updateHelpMessage(message, allCommands, currentPage + 1);
                }
            }

            // Retire les réactions de l'utilisateur pour éviter le spam
            event.getReaction().removeReaction(event.getUser()).queue();
        }
    }

    private void updateHelpMessage(Message message, List<String> commands, int pageIndex) {
        int totalPages = (int) Math.ceil((double) commands.size() / COMMANDS_PER_PAGE);

        EmbedBuilder embedBuilder = new EmbedBuilder();
        embedBuilder.setTitle("Available Commands (Page " + (pageIndex + 1) + "/" + totalPages + ")");
        embedBuilder.setColor(Color.BLUE);

        StringBuilder helpMessage = new StringBuilder();
        int start = pageIndex * COMMANDS_PER_PAGE;
        int end = Math.min(start + COMMANDS_PER_PAGE, commands.size());
        for (int i = start; i < end; i++) {
            helpMessage.append(commands.get(i)).append("\n");
        }

        embedBuilder.addField("Commands", helpMessage.toString(), false);

        // Suppression des réactions existantes
        message.clearReactions().queue(success -> {
            // Mise à jour du message existant
            message.editMessageEmbeds(embedBuilder.build()).queue(updatedMessage -> {
                if (totalPages > 1) {
                    if (pageIndex > 0) {
                        updatedMessage.addReaction(Emoji.fromUnicode(LEFT_ARROW)).queue(); // Emoji gauche (⬅️)
                    }
                    if (pageIndex < totalPages - 1) {
                        updatedMessage.addReaction(Emoji.fromUnicode(RIGHT_ARROW)).queue(); // Emoji droit (➡️)
                    }
                }
            });
        });
    }
}
