package com.duel.RPGChampion.controller.pingpong;

import com.duel.RPGChampion.controller.CommandController;
import com.duel.RPGChampion.controller.PrefixController;
import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
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
    public void onMessageReceived(MessageReceivedEvent event) {
        String prefix = prefixController.getPrefix(event);

        if (event.getAuthor().isBot()) {
            return;
        }

        String message = event.getMessage().getContentRaw();

        if (message.equalsIgnoreCase(prefix + "ping")) {
            long messageTime = event.getMessage().getTimeCreated().toInstant().toEpochMilli(); // Temps de l'envoi du message
            long currentTime = System.currentTimeMillis(); // Temps actuel

            // Calcule le temps de réponse
            long responseTime = Math.abs(currentTime - messageTime);
            EmbedBuilder embed = new EmbedBuilder();
            embed.setTitle("Pong! 🏓");
            embed.setColor(0x3498db); // Couleur bleue
            embed.setDescription("Response time: **" + responseTime + " ms**");

            event.getChannel().sendMessageEmbeds(embed.build()).queue();
        }
    }

    @Override
    public List<String> getCommands(String guildId) {
        String prefix = prefixController.getPrefix(guildId);

        return List.of(prefix + "ping : returns pong");
    }
}