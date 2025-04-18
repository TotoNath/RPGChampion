package com.duel.RPGChampion.controller;

import com.duel.RPGChampion.persistence.model.PrefixModelDAO;
import com.duel.RPGChampion.persistence.repository.PrefixRepository;
import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Optional;

@Controller
public class PrefixController extends ListenerAdapter implements CommandController {

    public static final String DEFAULT_PREFIX = "!";

    private final PrefixRepository prefixRepository;

    public PrefixController(PrefixRepository prefixRepository) {
        this.prefixRepository = prefixRepository;

        prefixRepository.findAll().forEach(p ->  {
            if(p.getPrefix().length()>1)
                p.setPrefix(DEFAULT_PREFIX);
        });
    }

    @Override
    public void onMessageReceived(MessageReceivedEvent event) {
        String message = event.getMessage().getContentRaw();
        String lowerMessage = message.toLowerCase();

        if (lowerMessage.contains(getPrefix(event) + "prefix")) {
            String[] parts = event.getMessage().getContentRaw().split(" ", 2);
            EmbedBuilder embed = new EmbedBuilder();

            if (parts.length == 2) {
                String newPrefix = parts[1];
                if(newPrefix.length() > 1){
                    embed.setTitle("Incorrect Usage ⚠️");
                    embed.setColor(0xFF0000);
                    embed.setDescription("Usage: **" + getPrefix(event) + "prefix <newPrefix>** the prefix must be 1 character long");
                }else{
                    PrefixModelDAO p = prefixRepository.findByGuildId(event.getGuild().getId()).orElse(new PrefixModelDAO());
                    p.setPrefix(newPrefix);
                    p.setGuildId(event.getGuild().getId());
                    prefixRepository.save(p);

                    embed.setTitle("Prefix Changed ✅");
                    embed.setColor(0x00FF00);
                    embed.setDescription("Prefix was changed to **" + newPrefix + "**.");
                }

            } else {
                embed.setTitle("Incorrect Usage ⚠️");
                embed.setColor(0xFF0000);
                embed.setDescription("Usage: **" + getPrefix(event) + "prefix <newPrefix>**");
            }

            event.getChannel().sendMessageEmbeds(embed.build()).queue();
        }
    }

    @Override
    public List<String> getCommands(String guildId) {
        return List.of(getPrefix(guildId) + "prefix <newPrefix>: changes prefix");
    }

    public String getPrefix(MessageReceivedEvent event) {
        return extractPrefix(event.getGuild().getId());
    }

    public String getPrefix(String guildId) {
        return extractPrefix(guildId);
    }

    private String extractPrefix(String guildId) {
        String ret = DEFAULT_PREFIX;
        Optional<PrefixModelDAO> optionalPrefix = prefixRepository.findByGuildId(guildId);
        if (optionalPrefix.isPresent()) {
            ret = optionalPrefix.get().getPrefix();
        }
        return ret;
    }
}