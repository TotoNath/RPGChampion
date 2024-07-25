package com.duel.RPGChampion.controller;

import com.duel.RPGChampion.model.Hero;
import com.duel.RPGChampion.services.CombatService;
import com.duel.RPGChampion.services.HeroService;
import com.duel.RPGChampion.services.UserService;
import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

@Controller
public class HeroController extends ListenerAdapter implements CommandController {

    @Autowired
    private HeroService heroService;

    @Autowired
    private UserService userService;

    @Autowired
    private CombatService combatService;

    @Override
    public void onMessageReceived(MessageReceivedEvent event) {
        String command = event.getMessage().getContentRaw();

        if (command.startsWith("!createHero")) {
            createHero(event);
        } else if (command.startsWith("!getHeroes")) {
            getHeroes(event);
        } else if (command.startsWith("!deleteHero")) {
            deleteHero(event, command);
        } else if (command.startsWith("!heroesCount")) {
            event.getChannel().sendMessage("The number of created heroes is " + heroService.getHeroesCount()).queue();
        } else if (command.startsWith("!selectHero")) {
            selectHero(event,command);
        } else if (command.startsWith("!pve")) {
            fightPVE(event);
        }
    }

    private void fightPVE(MessageReceivedEvent event) {
        String userId = event.getAuthor().getId();
        int heroId = userService.getSelectedHeroId(userId);
        String combatOutput = combatService.startCombat(heroId);

        if (combatOutput.length() <= 2000) {
            event.getChannel().sendMessage(combatOutput).queue();
        } else {
            sendLongMessage(event, combatOutput);
        }
    }

    private void sendLongMessage(MessageReceivedEvent event, String message) {
        int maxMessageLength = 2000;
        int start = 0;
        while (start < message.length()) {
            int end = Math.min(start + maxMessageLength, message.length());
            event.getChannel().sendMessage(message.substring(start, end)).queue();
            start = end;
        }
    }


    private void selectHero(MessageReceivedEvent event, String command) {
        String[] parts = command.split(" ", 2);
        if (parts.length == 2) {
            String heroName = parts[1];
            String userId = event.getAuthor().getId();
            String username = event.getAuthor().getName();
            boolean wasSelected = heroService.selectHero(heroName, userId);
            if (wasSelected) {
                event.getChannel().sendMessage("Hero " + heroName + " was selected").queue();
            } else {
                event.getChannel().sendMessage("Hero " + heroName + " wasn't selected for user " + username).queue();
            }
        } else {
            event.getChannel().sendMessage("Usage: !deleteHero <HeroName>").queue();
        }
    }

    private void deleteHero(MessageReceivedEvent event, String command) {
        String[] parts = command.split(" ", 2);
        if (parts.length == 2) {
            String heroName = parts[1];
            String userId = event.getAuthor().getId();
            String username = event.getAuthor().getName();
            boolean wasSuppresed = heroService.deleteHero(heroName, userId);
            if (wasSuppresed) {
                event.getChannel().sendMessage("Hero " + heroName + " deleted for user " + username).queue();
            } else {
                event.getChannel().sendMessage("Hero " + heroName + " wasn't deleted for user " + username).queue();
            }
        } else {
            event.getChannel().sendMessage("Usage: !deleteHero <HeroName>").queue();
        }
    }

    private void getHeroes(MessageReceivedEvent event) {
        List<Hero> heroes = heroService.getHeroesOfUser(event.getAuthor().getId());
        StringBuilder ret = new StringBuilder();
        ret.append("Heroes of player : ").append(event.getAuthor().getName()).append(" \n");
        AtomicInteger i = new AtomicInteger(1);
        heroes.forEach(hero -> {
            ret.append(i).append(" : ").append(hero.toFriendlyString()).append(" \n");
            i.getAndIncrement();
        });
        ret.append("You have ").append(heroes.size()).append(" heroes.\n");

        event.getChannel().sendMessage(ret.toString()).queue();
    }

    private void createHero(MessageReceivedEvent event) {
        String[] parts = event.getMessage().getContentRaw().split(" ", 2);
        if (parts.length == 2) {
            String heroName = parts[1];
            String userId = event.getAuthor().getId();
            String username = event.getAuthor().getName();
            heroService.createHero(heroName, userId, username);
            event.getChannel().sendMessage("Hero " + heroName + " created for user " + username).queue();
        } else {
            event.getChannel().sendMessage("Usage: !createHero <HeroName>").queue();
        }
    }

    @Override
    public List<String> getCommands() {
        return List.of("!createHero <heroName> : Creates a new hero",
                "!getHeroes : returns your heroes",
                "!deleteHero <heroName> : Deletes a hero",
                "!heroesCount : The number of heroes created",
                "!selectHero <heroName> : Selects ur hero for several action such as !pve",
                "!pve : Your hero goes for a walk ... who knows what will happen ?");
    }
}
