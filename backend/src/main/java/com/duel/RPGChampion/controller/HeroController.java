package com.duel.RPGChampion.controller;

import com.duel.RPGChampion.model.Hero;
import com.duel.RPGChampion.persistence.model.HeroDAO;
import com.duel.RPGChampion.services.CombatService;
import com.duel.RPGChampion.services.HeroService;
import com.duel.RPGChampion.services.UserService;
import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

@Controller
public class HeroController extends ListenerAdapter implements CommandController {

    public static final String HERO = "Hero ";
    @Autowired
    private final PrefixController prefixController;
    @Autowired
    private HeroService heroService;
    @Autowired
    private UserService userService;
    @Autowired
    private CombatService combatService;

    public HeroController(PrefixController prefixController) {
        this.prefixController = prefixController;
    }

    @Override
    public void onMessageReceived(@NotNull MessageReceivedEvent event) {
        String prefix = prefixController.getPrefix(event);
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
            selectHero(event, command, prefix);
        } else if (command.startsWith(prefix + "pve")) {
            fightPVE(event);
        } else if (command.startsWith(prefix + "renameHero")) {
            renameHero(event, command, prefix);
        } else if (command.startsWith(prefix + "leaderboard")) {
            showLeaderboard(event);
        }else if (command.startsWith(prefix + "afk")) {
            afk(event);
        }else if (command.startsWith(prefix + "wakeUp")) {
            wakeUp(event);
        }
    }

    private void wakeUp(MessageReceivedEvent event) {
        String userId = event.getAuthor().getId();
        String username = event.getAuthor().getName();
        int isNowAwake = heroService.wakeUp(userId, event.getGuild().getId());
        if (isNowAwake!=-1) {
            event.getChannel().sendMessage(username + " currently selected hero is now back home and won "+isNowAwake+" xp").queue();
        } else {
            event.getChannel().sendMessage(username + " selected hero wasn't able to went back home !").queue();
        }
    }

    private void afk(MessageReceivedEvent event) {
            String userId = event.getAuthor().getId();
            String username = event.getAuthor().getName();
            boolean isNowAfk = heroService.afk(userId, event.getGuild().getId());
            if (isNowAfk) {
                event.getChannel().sendMessage(username + " currently selected hero is now exploring").queue();
            } else {
                event.getChannel().sendMessage(username + " selected hero wasn't able to go on a new adventure, maybe he is on one already !").queue();
            }
    }

    private void showLeaderboard(MessageReceivedEvent event) {
        String messageToPrint = heroService.getLeaderboard(event.getGuild().getId());
        event.getChannel().sendMessage(messageToPrint).queue();
    }

    private void renameHero(MessageReceivedEvent event, String command, String prefix) {
        String[] parts = command.split(" ", 2);
        if (parts.length == 2) {
            String newHeroName = parts[1];
            String userId = event.getAuthor().getId();
            String username = event.getAuthor().getName();
            boolean wasRenamed = heroService.renameHero(newHeroName, userId, event.getGuild().getId());
            if (wasRenamed) {
                event.getChannel().sendMessage(HERO + newHeroName + " was renamed").queue();
            } else {
                event.getChannel().sendMessage(HERO + newHeroName + " wasn't renamed for user " + username).queue();
            }
        } else {
            event.getChannel().sendMessage("Usage: " + prefix + "renameHero <HeroName>").queue();
        }
    }

    private void fightPVE(MessageReceivedEvent event) {
        String userId = event.getAuthor().getId();
        int heroId = userService.getSelectedHeroId(userId, event.getGuild().getId());
        if (heroId != -1) {
            String combatOutput = combatService.startCombat(heroId);

            if (combatOutput.length() <= 2000) {
                event.getChannel().sendMessage(combatOutput).queue();
            } else {
                sendLongMessage(event, combatOutput);
            }
        } else {
            event.getChannel().sendMessage("You need first to create a hero and select him/her/it or wake him up from his adventure").queue();
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


    private void selectHero(MessageReceivedEvent event, String command, String prefix) {
        String[] parts = command.split(" ", 2);
        if (parts.length == 2) {
            String heroName = parts[1];
            String userId = event.getAuthor().getId();
            String username = event.getAuthor().getName();
            boolean wasSelected = heroService.selectHero(heroName, userId, event.getGuild().getId());
            if (wasSelected) {
                event.getChannel().sendMessage(HERO + heroName + " was selected").queue();
            } else {
                event.getChannel().sendMessage(HERO + heroName + " wasn't selected for user " + username).queue();
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
            boolean wasSuppresed = heroService.deleteHero(heroName, userId, event.getGuild().getId());
            if (wasSuppresed) {
                event.getChannel().sendMessage(HERO + heroName + " deleted for user " + username).queue();
            } else {
                event.getChannel().sendMessage(HERO + heroName + " wasn't deleted for user " + username).queue();
            }
        } else {
            event.getChannel().sendMessage("Usage: !deleteHero <HeroName>").queue();
        }
    }

    private void getHeroes(MessageReceivedEvent event) {
        List<Hero> heroes = heroService.getHeroesOfUser(event.getAuthor().getId(), event.getGuild().getId());
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
            HeroDAO heroDAO = heroService.getSelectedHero(event.getAuthor().getId(), event.getGuild().getId());
            if(heroDAO != null) {
                ret.append("Your selected Hero is ").append(heroDAO.getName()).append(" .\n");
            }
        }

        event.getChannel().sendMessage(ret.toString()).queue();
    }

    private void createHero(MessageReceivedEvent event) {
        String[] parts = event.getMessage().getContentRaw().split(" ", 2);
        if (parts.length == 2) {
            String heroName = parts[1];
            String userId = event.getAuthor().getId();
            String username = event.getAuthor().getName();
            String guildId = event.getGuild().getId();
            heroService.createHero(heroName, userId, username, guildId);
            event.getChannel().sendMessage(HERO + heroName + " created for user " + username).queue();
        } else {
            event.getChannel().sendMessage("Usage: !createHero <HeroName>").queue();
        }
    }

    @Override
    public List<String> getCommands(String guildId) {
        String prefix = prefixController.getPrefix(guildId);
        return List.of(prefix + "createHero <heroName> : Creates a new hero",
                prefix + "getHeroes : returns your heroes",
                prefix + "deleteHero <heroName> : Deletes a hero",
                prefix + "heroesCount : The number of heroes created",
                prefix + "selectHero <heroName> : Selects ur hero for several action such as !pve. You can select hero if you have any other hero afk",
                prefix + "renameHero <heroName> : Renames your selected hero",
                prefix + "afk : Your selected hero gains xp each 1/4 hour but he can't fight pve neither pvp until wakeUp then he gains the xp",
                prefix + "wakeUp : Your selected hero gains xp for each 1/4 hour and can now fight pve and pvp",
                prefix + "pve : Your hero goes for a walk ... who knows what will happen ?");
    }
}
