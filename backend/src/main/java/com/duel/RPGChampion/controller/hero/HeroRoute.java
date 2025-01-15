package com.duel.RPGChampion.controller.hero;

import com.duel.RPGChampion.model.Hero;
import com.duel.RPGChampion.persistence.model.HeroDAO;
import com.duel.RPGChampion.services.CombatService;
import com.duel.RPGChampion.services.HeroService;
import com.duel.RPGChampion.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/heroes")
public class HeroRoute {

    @Autowired
    private HeroService heroService;

    @Autowired
    private UserService userService;

    @Autowired
    private CombatService combatService;

    @PostMapping("/create")
    public ResponseEntity<String> createHero(@RequestParam String heroName,
                                             @RequestParam String userId,
                                             @RequestParam String username,
                                             @RequestParam String guildId) {
        heroService.createHero(heroName, userId, username, guildId);
        return ResponseEntity.ok("Hero " + heroName + " created successfully!");
    }

    @GetMapping("/list")
    public ResponseEntity<List<Hero>> getHeroes(@RequestParam String userId, @RequestParam String guildId) {
        List<Hero> heroes = heroService.getHeroesOfUser(userId, guildId);
        return ResponseEntity.ok(heroes);
    }

    @DeleteMapping("/delete")
    public ResponseEntity<String> deleteHero(@RequestParam String heroName,
                                             @RequestParam String userId,
                                             @RequestParam String guildId) {
        boolean wasDeleted = heroService.deleteHero(heroName, userId, guildId);
        if (wasDeleted) {
            return ResponseEntity.ok("Hero " + heroName + " deleted successfully!");
        } else {
            return ResponseEntity.badRequest().body("Failed to delete hero " + heroName);
        }
    }

    @GetMapping("/count")
    public ResponseEntity<String> getHeroesCount() {
        int count = heroService.getHeroesCount();
        return ResponseEntity.ok("Number of created heroes: " + count);
    }

    @PostMapping("/select")
    public ResponseEntity<String> selectHero(@RequestParam String heroName,
                                             @RequestParam String userId,
                                             @RequestParam String guildId) {
        boolean wasSelected = heroService.selectHero(heroName, userId, guildId);
        if (wasSelected) {
            return ResponseEntity.ok("Hero " + heroName + " selected successfully!");
        } else {
            return ResponseEntity.badRequest().body("Failed to select hero " + heroName);
        }
    }

    @GetMapping("/select")
    public ResponseEntity<String> selectedHero(@RequestParam String heroName,
                                             @RequestParam String userId,
                                             @RequestParam String guildId) {
        HeroDAO selectedHero = heroService.getSelectedHero(userId, guildId);
        if (selectedHero != null) {
            return ResponseEntity.ok(selectedHero.getName());
        } else {
            return ResponseEntity.badRequest().body("Failed to select hero " + heroName);
        }
    }

    @PostMapping("/pve")
    public ResponseEntity<String> fightPVE(@RequestParam String userId, @RequestParam String guildId) {
        int heroId = userService.getSelectedHeroId(userId, guildId);
        if (heroId == -1) {
            return ResponseEntity.badRequest().body("No hero selected or active for combat.");
        }
        String combatOutput = combatService.startCombat(heroId, userId);
        return ResponseEntity.ok(combatOutput);
    }

    @PostMapping("/rename")
    public ResponseEntity<String> renameHero(@RequestParam String newHeroName,
                                             @RequestParam String userId,
                                             @RequestParam String guildId) {
        boolean wasRenamed = heroService.renameHero(newHeroName, userId, guildId);
        if (wasRenamed) {
            return ResponseEntity.ok("Hero renamed to " + newHeroName);
        } else {
            return ResponseEntity.badRequest().body("Failed to rename hero.");
        }
    }

    @PostMapping("/afk")
    public ResponseEntity<String> afkHero(@RequestParam String userId, @RequestParam String guildId) {
        boolean isNowAfk = heroService.afk(userId, guildId);
        if (isNowAfk) {
            return ResponseEntity.ok("Hero is now AFK.");
        } else return ResponseEntity.badRequest().body("Hero could not go AFK.");
    }

    @PostMapping("/wakeUp")
    public ResponseEntity<String> wakeUpHero(@RequestParam String userId, @RequestParam String guildId) {
        int xpGained = heroService.wakeUp(userId, guildId);
        if (xpGained != -1) {
            return ResponseEntity.ok("Hero woke up and gained " + xpGained + " XP!");
        } else {
            return ResponseEntity.badRequest().body("Failed to wake up the hero.");
        }
    }

    @GetMapping("/leaderboard")
    public ResponseEntity<String> showLeaderboard(@RequestParam String guildId) {
        String leaderboard = heroService.getLeaderboard(guildId);
        return ResponseEntity.ok(leaderboard);
    }
}
