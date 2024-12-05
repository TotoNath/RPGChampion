package com.duel.RPGChampion.controller.hero;

import com.duel.RPGChampion.controller.CommandController;
import com.duel.RPGChampion.controller.PrefixController;
import com.duel.RPGChampion.model.Hero;
import com.duel.RPGChampion.persistence.model.UserDAO;
import com.duel.RPGChampion.services.CombatService;
import com.duel.RPGChampion.services.HeroService;
import com.duel.RPGChampion.services.UserService;
import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.entities.Message;
import net.dv8tion.jda.api.entities.emoji.Emoji;
import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.events.message.react.MessageReactionAddEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.BiConsumer;

import static com.duel.RPGChampion.controller.help.HelpController.LEFT_ARROW;
import static com.duel.RPGChampion.controller.help.HelpController.RIGHT_ARROW;


@Controller
public class HeroController extends ListenerAdapter implements CommandController {

    public static final String HERO = "Hero ";

    public static final String HERO_INFORMATION_DISPLAY =
            "🧑 **Name**: %s\n" +
                    "🎂 **Age**: %d\n" +
                    "🏋️‍♂️ **Strength**: %d\n" +
                    "🤸 **Agility**: %d\n" +
                    "❤️  **HP**  :   %d\n" +
                    "🎯 **Level**: %d\n" +
                    "⭐ **Experience**: %d\n" +
                    "🏠 **Location**: %s\n";

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
        } else if (command.startsWith(prefix + "afk")) {
            afk(event);
        } else if (command.startsWith(prefix + "wakeUp")) {
            wakeUp(event);
        }
    }

    private void wakeUp(MessageReceivedEvent event) {
        String userId = event.getAuthor().getId();
        String username = event.getAuthor().getName();
        int isNowAwake = heroService.wakeUp(userId, event.getGuild().getId());

        EmbedBuilder embed = new EmbedBuilder();

        if (isNowAwake != -1) {
            embed.setTitle("Hero Woke Up 🌅");
            embed.setColor(0x00FF00); // Couleur verte pour le succès
            embed.setDescription(String.format("**%s**, your currently selected hero is now back home and won **%d XP**!", username, isNowAwake));
        } else {
            embed.setTitle("Wake Up Failed ❌");
            embed.setColor(0xFF0000); // Couleur rouge pour l'erreur
            embed.setDescription(String.format("**%s**, your selected hero wasn't able to go back home!", username));
        }

        event.getChannel().sendMessageEmbeds(embed.build()).queue();
    }


    private void afk(MessageReceivedEvent event) {
        String userId = event.getAuthor().getId();
        String username = event.getAuthor().getName();
        boolean isNowAfk = heroService.afk(userId, event.getGuild().getId());

        EmbedBuilder embed = new EmbedBuilder();

        if (isNowAfk) {
            embed.setTitle("Hero is AFK 🏞️");
            embed.setColor(0x00FF00); // Couleur verte pour le succès
            embed.setDescription(String.format("**%s**, your currently selected hero is now exploring!", username));
        } else {
            embed.setTitle("AFK Failed ❌");
            embed.setColor(0xFF0000); // Couleur rouge pour l'erreur
            embed.setDescription(String.format("**%s**, your selected hero wasn't able to go on a new adventure, maybe he is on one already!", username));
        }

        event.getChannel().sendMessageEmbeds(embed.build()).queue();
    }


    private void showLeaderboard(MessageReceivedEvent event) {
        String leaderboard = heroService.getLeaderboard(event.getGuild().getId());

        EmbedBuilder embed = new EmbedBuilder();
        embed.setTitle("Leaderboard 🏆");
        embed.setColor(0x3498db); // Couleur bleue
        embed.setDescription(leaderboard);

        event.getChannel().sendMessageEmbeds(embed.build()).queue();
    }


    //TODO : fix error duplicated key ...
    private void renameHero(MessageReceivedEvent event, String command, String prefix) {
        String[] parts = command.split(" ", 2);

        EmbedBuilder embed = new EmbedBuilder();

        if (parts.length == 2) {
            String newHeroName = parts[1];
            String userId = event.getAuthor().getId();
            String username = event.getAuthor().getName();
            boolean wasRenamed = heroService.renameHero(newHeroName, userId, event.getGuild().getId());

            if (wasRenamed) {
                embed.setTitle("Hero Renamed ✏️");
                embed.setColor(0x00FF00); // Couleur verte pour le succès
                embed.setDescription(String.format("**%s**, your hero has been renamed to **%s**!", username, newHeroName));
            } else {
                embed.setTitle("Rename Failed ❌");
                embed.setColor(0xFF0000); // Couleur rouge pour l'erreur
                embed.setDescription(String.format("**%s**, your hero wasn't renamed. Please try again.", username));
            }
        } else {
            embed.setTitle("Incorrect Usage ⚠️");
            embed.setColor(0xFF0000); // Couleur rouge pour l'erreur
            embed.setDescription(String.format("Usage: **%srenameHero <HeroName>**", prefix));
        }

        event.getChannel().sendMessageEmbeds(embed.build()).queue();
    }


    private void fightPVE(MessageReceivedEvent event) {
        String userId = event.getAuthor().getId();
        int heroId = userService.getSelectedHeroId(userId, event.getGuild().getId());

        EmbedBuilder embed = new EmbedBuilder();

        if (heroId != -1) {
            String combatOutput = combatService.startCombat(heroId,userId);

            if (combatOutput.length() <= 2000) {
                embed.setTitle("Combat Result ⚔️");
                embed.setDescription(combatOutput);
                embed.setColor(0x3498db); // Couleur bleue
            } else {
                sendLongMessage(event, combatOutput); // Gérer les longs messages comme avant
                return; // Sortir pour éviter l'envoi multiple de messages
            }
        } else {
            embed.setTitle("No Hero Selected ❌");
            embed.setColor(0xFF0000); // Couleur rouge
            embed.setDescription("You need to create a hero and select him/her/it or wake him up from his adventure.");
        }

        event.getChannel().sendMessageEmbeds(embed.build()).queue();
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

        EmbedBuilder embed = new EmbedBuilder();

        if (parts.length == 2) {
            String heroName = parts[1];
            String userId = event.getAuthor().getId();
            String username = event.getAuthor().getName();
            boolean wasSelected = heroService.selectHero(heroName, userId, event.getGuild().getId());

            if (wasSelected) {
                embed.setTitle("Hero Selected ✔️");
                embed.setColor(0x00FF00); // Couleur verte pour le succès
                embed.setDescription(String.format("**%s**, your hero **%s** has been selected!", username, heroName));
            } else {
                embed.setTitle("Selection Failed ❌");
                embed.setColor(0xFF0000); // Couleur rouge pour l'erreur
                embed.setDescription(String.format("**%s**, your hero **%s** wasn't selected. Please check the name!", username, heroName));
            }
        } else {
            embed.setTitle("Incorrect Usage ⚠️");
            embed.setColor(0xFF0000); // Couleur rouge pour l'erreur
            embed.setDescription(String.format("Usage: **%sselectHero <HeroName>**", prefix));
        }

        event.getChannel().sendMessageEmbeds(embed.build()).queue();
    }


    private void deleteHero(MessageReceivedEvent event, String command) {
        String[] parts = command.split(" ", 2);

        EmbedBuilder embed = new EmbedBuilder();

        if (parts.length == 2) {
            String heroName = parts[1];
            String userId = event.getAuthor().getId();
            String username = event.getAuthor().getName();
            boolean wasSuppressed = heroService.deleteHero(heroName, userId, event.getGuild().getId());

            if (wasSuppressed) {
                // Embed pour la suppression réussie
                embed.setTitle("Hero Deleted 🗑️");
                embed.setColor(0x00FF00); // Couleur verte pour le succès
                embed.setDescription(String.format("**%s** has deleted the hero named **%s**!", username, heroName));
            } else {
                // Embed pour la suppression échouée
                embed.setTitle("Deletion Failed ❌");
                embed.setColor(0xFF0000); // Couleur rouge pour l'erreur
                embed.setDescription(String.format("**%s** failed to delete the hero named **%s**. Please check the name!", username, heroName));
            }
        } else {
            // Embed pour l'usage incorrect de la commande
            embed.setTitle("Incorrect Usage ⚠️");
            embed.setColor(0xFF0000); // Couleur rouge pour l'erreur
            embed.setDescription("Usage: **!deleteHero <HeroName>**");
        }

        // Envoi de l'embed
        event.getChannel().sendMessageEmbeds(embed.build()).queue();
    }


    private void getHeroes(MessageReceivedEvent event) {
        List<Hero> heroes = heroService.getHeroesOfUser(event.getAuthor().getId(), event.getGuild().getId());
        UserDAO userDAO = userService.getUser(event.getAuthor().getId());

        final String[] user = {event.getAuthor().getName()};
        user[0] = user[0].substring(0, 1).toUpperCase() + user[0].substring(1);

        if (CollectionUtils.isEmpty(heroes)) {
            EmbedBuilder embed = new EmbedBuilder();
            embed.setColor(0x3498db); // Bleu
            embed.setTitle(user[0] + " HEROES");
            embed.setDescription("No heroes found for user " + user[0]);
            event.getChannel().sendMessageEmbeds(embed.build()).queue();
            return;
        }

        AtomicInteger index = new AtomicInteger(0); // Gère l'index de la pagination
        String userId = event.getAuthor().getId();

        // Fonction pour afficher un héros spécifique
        BiConsumer<Message, Integer> updateHeroDisplay = (message, heroIndex) -> {
            Hero hero = heroes.get(heroIndex);

            EmbedBuilder embed = new EmbedBuilder();
            embed.setColor(0x3498db); // Couleur de l'embed en bleu
            user[0] = user[0].substring(0, 1).toUpperCase() + user[0].substring(1);
            embed.setTitle(user[0] + " HEROES");

            // Format des informations du héros
            String heroStats = String.format(
                    HERO_INFORMATION_DISPLAY,
                    hero.getName(),
                    hero.getAge(),
                    hero.getStrength(),
                    hero.getAgility(),
                    hero.getHp(),
                    hero.getLevel(),
                    hero.getExperience(),
                    hero.getAfk()!=null ? "Exploring somewhere" : "Home"
            );

            // Ajout des informations du héros dans l'embed
            embed.addBlankField(true);
            embed.setDescription("\n\n" +"🪙 **Global Tresory**: "+userDAO.getGold() +"\n\n"+heroStats);
            embed.addBlankField(true);
            embed.setFooter(String.format("%d/%d  \t\t\tcurrent hero being displayed : %s", heroIndex + 1, heroes.size(), hero.getName()));

            message.editMessageEmbeds(embed.build()).queue();
        };

        // Envoie du premier héros avec pagination
        EmbedBuilder initialEmbed = new EmbedBuilder();
        initialEmbed.setColor(0x3498db);
        initialEmbed.setTitle(user[0] + " HEROES");
        initialEmbed.setFooter("1/" + heroes.size() + "  \t\t\tcurrent hero being displayed : " + heroes.get(0).getName());

        String initialHeroStats = String.format(
                HERO_INFORMATION_DISPLAY,
                heroes.get(0).getName(),
                heroes.get(0).getAge(),
                heroes.get(0).getStrength(),
                heroes.get(0).getAgility(),
                heroes.get(0).getHp(),
                heroes.get(0).getLevel(),
                heroes.get(0).getExperience(),
                heroes.get(0).getAfk()!=null ? "Exploring somewhere" : "Home"

        );
        initialEmbed.addBlankField(true);
        initialEmbed.setDescription("\n\n" +"🪙 **Global Tresory**: "+userDAO.getGold() +"\n\n"+initialHeroStats);
        initialEmbed.addBlankField(true);
        manageGetHeroesPagination(event, initialEmbed, userId, index, heroes, updateHeroDisplay);
    }

    private static void manageGetHeroesPagination(MessageReceivedEvent event, EmbedBuilder initialEmbed, String userId, AtomicInteger index, List<Hero> heroes, BiConsumer<Message, Integer> updateHeroDisplay) {
        event.getChannel().sendMessageEmbeds(initialEmbed.build()).queue(message -> {
            message.addReaction(Emoji.fromUnicode(LEFT_ARROW)).queue(); // Flèche gauche
            message.addReaction(Emoji.fromUnicode(RIGHT_ARROW)).queue(); // Flèche droite

            event.getJDA().addEventListener(new ListenerAdapter() {
                @Override
                public void onMessageReactionAdd(@NotNull MessageReactionAddEvent reactionEvent) {
                    if (!reactionEvent.getUserId().equals(userId) || reactionEvent.getMessageIdLong() != message.getIdLong()) {
                        return; // Ignore si ce n'est pas l'auteur original ou si ce n'est pas le bon message
                    }

                    String emoji = reactionEvent.getEmoji().getName();
                    if (emoji.equals("➡️")) {
                        if (index.incrementAndGet() >= heroes.size()) {
                            index.set(0); // Boucle vers le premier héros
                        }
                    } else if (emoji.equals("⬅️")) {
                        if (index.decrementAndGet() < 0) {
                            index.set(heroes.size() - 1); // Boucle vers le dernier héros
                        }
                    }

                    updateHeroDisplay.accept(message, index.get());

                    // Retire la réaction de l'utilisateur pour éviter le spam
                    reactionEvent.getReaction().removeReaction(reactionEvent.getUser()).queue();
                }
            });
        });
    }


    private void createHero(MessageReceivedEvent event) {
        String[] parts = event.getMessage().getContentRaw().split(" ", 2);

        if (parts.length == 2) {
            String heroName = parts[1];
            String userId = event.getAuthor().getId();
            String username = event.getAuthor().getName();
            String guildId = event.getGuild().getId();

            // Création du héros
            heroService.createHero(heroName, userId, username, guildId);

            // Création de l'embed
            EmbedBuilder embed = new EmbedBuilder();
            embed.setTitle("Hero Created 🎉");
            embed.setColor(0x00FF00); // Couleur verte pour le succès
            embed.setDescription(String.format("**%s** has created a new hero named **%s**!", username, heroName));

            // Ajout d'informations supplémentaires
            embed.addField("Hero Name", heroName, true);
            embed.addField("Created By", username, true);
            embed.addField("Guild ID", guildId, true);

            // Optionnel: Ajouter une image ou une icône si désiré
            // embed.setThumbnail("https://example.com/hero-image.png");

            // Envoi du message embed
            event.getChannel().sendMessageEmbeds(embed.build()).queue();
        } else {
            // Embed pour l'usage incorrect de la commande
            EmbedBuilder errorEmbed = new EmbedBuilder();
            errorEmbed.setTitle("Incorrect Usage ⚠️");
            errorEmbed.setColor(0xFF0000); // Couleur rouge pour l'erreur
            errorEmbed.setDescription("Usage: **!createHero <HeroName>**");

            event.getChannel().sendMessageEmbeds(errorEmbed.build()).queue();
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
