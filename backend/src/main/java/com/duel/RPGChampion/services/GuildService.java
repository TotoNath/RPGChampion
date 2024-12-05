package com.duel.RPGChampion.services;

import net.dv8tion.jda.api.JDA;
import net.dv8tion.jda.api.entities.Guild;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class GuildService {

    private final JDA jda; // Injection de l'instance JDA

    @Autowired
    public GuildService(JDA jda) {
        this.jda = jda;
    }

    /**
     * Retourne les IDs des guildes où le bot est connecté.
     *
     * @return Une liste d'identifiants de guildes.
     */
    public List<String> getConnectedGuildIds() {
        // Utilise JDA pour récupérer toutes les guildes où le bot est connecté
        return jda.getGuilds().stream()
                .map(Guild::getId) // Récupère uniquement les IDs des guildes
                .collect(Collectors.toList());
    }
}
