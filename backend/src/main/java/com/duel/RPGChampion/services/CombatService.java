package com.duel.RPGChampion.services;

import com.duel.RPGChampion.model.*;
import com.duel.RPGChampion.persistence.mapper.HeroMapper;
import com.duel.RPGChampion.persistence.model.HeroDAO;
import com.duel.RPGChampion.persistence.model.UserDAO;
import com.duel.RPGChampion.persistence.repository.HeroRepository;
import com.duel.RPGChampion.persistence.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Random;

@Service
public class CombatService {

    @Autowired
    private HeroRepository heroRepository;

    @Autowired
    private HeroMapper heroMapper;

    private static final String HERO_NOT_FOUND = "Hero not found!";

    private static final int PVE_XP_WON = 50;

    public static final int NEXT_XP_LEVEL_SCALE = 100;

    public static final int NEXT_LOL_STRENGTH_BONUS = 2;

    public static final int NEXT_LVL_ABILITY_BONUS = 2;

    public static final int NEXT_LVL_HEALTH_BONUS = 10;

    @Autowired
    private UserRepository userRepository;

    /**
     * PVE Combat methpd
     * @param heroId the id of the user fighting
     * @param userId the id of the user that launched the pve command
     * @return the final state of combat
     */
    @Transactional
    public String startCombat(int heroId, String userId) {
        StringBuilder ret = new StringBuilder();
        UserDAO userDAO = userRepository.findByUserId(userId).orElse(null);
        Hero hero = heroMapper.mapHeroDAOToHero(heroRepository.findById(heroId).orElse(null));
        if (hero == null || userDAO == null) {
            return HERO_NOT_FOUND;
        }

        Entity enemy = generateEnemy(hero);

        while (hero.getHp() > 0 && enemy.getHp() > 0) {
            hero.attack(enemy);

            if (enemy.getHp() > 0 && !enemy.dodge()) {
                enemy.attack(hero);
            }

            if (hero.getHp() < 0) {
                ret.append("Hero was killed by: ").append(enemy.getClass().getSimpleName()).append("\n");
                hero.setHp(0); // Marque le héros comme mort
                heroRepository.save(heroMapper.mapHeroToHeroDAO(hero));
                break;
            }

            if (enemy.getHp() <= 0) {
                ret.append("Hero killed a ").append(enemy.getClass().getSimpleName()).append("\n");
                hero.setExperience(hero.getExperience() + PVE_XP_WON);
                Long currentGold = userDAO.getGold();
                userDAO.setGold(currentGold + enemy.getCoins());
                levelUp(hero);
                heroRepository.save(heroMapper.mapHeroToHeroDAO(hero));
                break;
            }
        }
        return ret.toString();
    }



    /**
     * Méthode pour générer un ennemi suivant le héro
     * @param hero héro à partir du quel on va calculer les attributs de l'adversaire
     * @return un adversaire
     */
    private Entity generateEnemy(Hero hero) {
        Random random = new Random();
        int enemyType = random.nextInt(3);

        return switch (enemyType) {
            case 0 -> new Warrior(hero.getLevel());
            case 1 -> new Mage(hero.getLevel());
            case 2 -> new Monster(hero.getLevel());
            default -> new Bandit(hero.getLevel());
        };
    }


    /**
     * Méthode utilisé pour le levelUp d'un héro
     * @param hero le héro à le level up
     */
    private void levelUp(Hero hero) {
        int xpToNextLevel = hero.getLevel() * (NEXT_XP_LEVEL_SCALE + hero.getLevel());
        if (hero.getExperience() >= xpToNextLevel) {
            hero.setLevel(hero.getLevel() + 1);
            hero.setExperience(hero.getExperience() - xpToNextLevel);
            hero.setHp(hero.getHp() + NEXT_LVL_HEALTH_BONUS+100);
            hero.setStrength(hero.getStrength() + NEXT_LOL_STRENGTH_BONUS);
            hero.setAgility(hero.getAgility() + NEXT_LVL_ABILITY_BONUS);
        }
    }
}
