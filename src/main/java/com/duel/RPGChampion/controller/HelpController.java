package com.duel.RPGChampion.controller;

import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.entities.Message;
import net.dv8tion.jda.api.entities.MessageChannel;
import net.dv8tion.jda.api.entities.emoji.Emoji;
import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.events.message.react.MessageReactionAddEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.awt.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static com.duel.RPGChampion.controller.PrefixController.prefix;

@Controller
public class HelpController extends ListenerAdapter implements CommandController {

    public static final String LEFT_ARROW = "⬅️";

    public static final String RIGHT_ARROW = "➡️";

    private final List<CommandController> commandControllers;

    private static final int COMMANDS_PER_PAGE = 10;

    @Autowired
    public HelpController(List<CommandController> commandControllers) {
        this.commandControllers = commandControllers;
    }

    @Override
    public void onMessageReceived(MessageReceivedEvent event) {
        String command = event.getMessage().getContentRaw();

        if (command.equalsIgnoreCase(prefix + "help")) {
            List<String> allCommands = getAllCommands();
            sendHelpMessage(event.getChannel(), allCommands, 0);
        }
    }

    @Override
    public List<String> getCommands() {
        return List.of(prefix + "help : shows all commands");
    }

    private List<String> getAllCommands() {
        List<String> allCommands = new ArrayList<>();
        commandControllers.forEach(controller -> allCommands.addAll(controller.getCommands()));
        return allCommands;
    }

    private void sendHelpMessage(MessageChannel channel, List<String> commands, int pageIndex) {
        int totalPages = (int) Math.ceil((double) commands.size() / COMMANDS_PER_PAGE);
        EmbedBuilder embedBuilder = createEmbedBuilder(commands, pageIndex, totalPages);

        channel.sendMessageEmbeds(embedBuilder.build()).queue(message -> addReactions(message, pageIndex, totalPages));
    }

    private EmbedBuilder createEmbedBuilder(List<String> commands, int pageIndex, int totalPages) {
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
        return embedBuilder;
    }

    private void addReactions(Message message, int pageIndex, int totalPages) {
        if (totalPages > 1) {
            if (pageIndex > 0) {
                message.addReaction(Emoji.fromUnicode(LEFT_ARROW)).queue();
            }
            if (pageIndex < totalPages - 1) {
                message.addReaction(Emoji.fromUnicode(RIGHT_ARROW)).queue();
            }
        }
    }

    @Override
    public void onMessageReactionAdd(MessageReactionAddEvent event) {
        Message message = event.retrieveMessage().complete();
        if (message.getAuthor().isBot() && !Objects.requireNonNull(event.getUser()).isBot()) {
            int[] pages = getCurrentAndTotalPages(Objects.requireNonNull(message.getEmbeds().get(0).getTitle()));
            int currentPage = pages[0];
            int totalPages = pages[1];

            List<String> allCommands = getAllCommands();

            if (event.getReaction().getEmoji().getName().equals(LEFT_ARROW) && currentPage > 0) {
                updateHelpMessage(message, allCommands, currentPage - 1);
            } else if (event.getReaction().getEmoji().getName().equals(RIGHT_ARROW) && currentPage < totalPages - 1) {
                updateHelpMessage(message, allCommands, currentPage + 1);
            }

            event.getReaction().removeReaction(event.getUser()).queue();
        }
    }

    private int[] getCurrentAndTotalPages(String title) {
        String[] titleParts = title.split(" ");
        int currentPage = Integer.parseInt(titleParts[titleParts.length - 1].split("/")[0]) - 1;
        int totalPages = Integer.parseInt(titleParts[titleParts.length - 1].split("/")[1].replace(")", ""));
        return new int[]{currentPage, totalPages};
    }

    private void updateHelpMessage(Message message, List<String> commands, int pageIndex) {
        int totalPages = (int) Math.ceil((double) commands.size() / COMMANDS_PER_PAGE);
        EmbedBuilder embedBuilder = createEmbedBuilder(commands, pageIndex, totalPages);

        message.clearReactions().queue(success -> message.editMessageEmbeds(embedBuilder.build()).queue(updatedMessage -> {
            addReactions(updatedMessage, pageIndex, totalPages);
        }));
    }
}
