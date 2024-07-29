package com.duel.RPGChampion.controller;

import com.duel.RPGChampion.persistence.model.PrefixModelDAO;
import com.duel.RPGChampion.persistence.repository.PrefixRepository;
import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class PrefixController extends ListenerAdapter implements CommandController {

    public static String prefix;

    private final PrefixRepository prefixRepository;

    public PrefixController(PrefixRepository prefixRepository) {
        this.prefixRepository = prefixRepository;
        List<PrefixModelDAO> prefixes = prefixRepository.findAll();
        if (!prefixes.isEmpty()) {
            prefixRepository.deleteAll();
        }
            PrefixModelDAO p = new PrefixModelDAO();
            String defaultPrefix = "!";
            p.setPrefix(defaultPrefix);
            prefixRepository.save(p);
            prefix = defaultPrefix;

    }

    @Override
    public void onMessageReceived(MessageReceivedEvent event) {
        String message = event.getMessage().getContentRaw();

        if (message.contains(prefix + "prefix")) {
            String[] parts = event.getMessage().getContentRaw().split(" ", 2);
            if (parts.length == 2) {
                String newPrefix = parts[1];
                prefixRepository.deleteAll();
                PrefixModelDAO p = new PrefixModelDAO();
                p.setPrefix(newPrefix);
                prefixRepository.save(p);
                prefix = newPrefix;

                event.getChannel().sendMessage("Prefix was changed to " + newPrefix).queue();
            } else {
                event.getChannel().sendMessage("Usage: " + prefix + "prefix <newPrefix>").queue();
            }
        }
    }

    @Override
    public List<String> getCommands() {
        return List.of(prefix + "prefix <newPrefix>: changes prefix");
    }
}