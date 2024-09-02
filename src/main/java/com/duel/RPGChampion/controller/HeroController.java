package com.duel.RPGChampion.controller;

import com.duel.RPGChampion.model.Hero;
import com.duel.RPGChampion.services.CombatService;
import com.duel.RPGChampion.services.HeroService;
import com.duel.RPGChampion.services.UserService;
import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import static com.duel.RPGChampion.controller.PrefixController.prefix;

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

        if (command.startsWith(prefix + "createHero")) {
            createHero(event);
        } else if (command.startsWith(prefix + "getHeroes")) {
            getHeroes(event);
        } else if (command.startsWith(prefix + "deleteHero")) {
            deleteHero(event, command);
        } else if (command.startsWith(prefix + "heroesCount")) {
            event.getChannel().sendMessage("The number of created heroes is " + heroService.getHeroesCount()).queue();
        } else if (command.startsWith(prefix + "selectHero")) {
            selectHero(event, command);
        } else if (command.startsWith(prefix + "pve")) {
            fightPVE(event);
        } else if (command.startsWith(prefix + "renameHero")) {
            renameHero(event, command);
        } else if (command.startsWith(prefix + "leaderboard")) {
            showLeaderboard(event);
        }
    }

    private void showLeaderboard(MessageReceivedEvent event) {
        String messageToPrint = heroService.getLeaderboard();
        event.getChannel().sendMessage(messageToPrint).queue();
    }

    private void renameHero(MessageReceivedEvent event, String command) {
        String[] parts = command.split(" ", 2);
        if (parts.length == 2) {
            String newHeroName = parts[1];
            String userId = event.getAuthor().getId();
            String username = event.getAuthor().getName();
            boolean wasRenamed = heroService.renameHero(newHeroName, userId);
            if (wasRenamed) {
                event.getChannel().sendMessage("Hero " + newHeroName + " was renamed").queue();
            } else {
                event.getChannel().sendMessage("Hero " + newHeroName + " wasn't renamed for user " + username).queue();
            }
        } else {
            event.getChannel().sendMessage("Usage: " + prefix + "renameHero <HeroName>").queue();
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
            event.getChannel().sendMessage("Usage: " + prefix + "deleteHero <HeroName>").queue();
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
        if (CollectionUtils.isEmpty(heroes)) {
            ret.append("No heroes found for user ").append(event.getAuthor().getName());
        } else {
            ret.append("Heroes of player : ").append(event.getAuthor().getName()).append(" \n");
            AtomicInteger i = new AtomicInteger(1);
            heroes.forEach(hero -> {
                ret.append(i).append(" : ").append(hero.toFriendlyString()).append(" \n");
                i.getAndIncrement();
            });
            ret.append("You have ").append(heroes.size()).append(" heroes.\n");
        }


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
        return List.of(prefix + "createHero <heroName> : Creates a new hero",
                prefix + "getHeroes : returns your heroes",
                prefix + "deleteHero <heroName> : Deletes a hero",
                prefix + "heroesCount : The number of heroes created",
                prefix + "selectHero <heroName> : Selects ur hero for several action such as !pve",
                prefix + "renameHero <heroName> : Renames your selected hero",
                prefix + "pve : Your hero goes for a walk ... who knows what will happen ?");
    }
}
