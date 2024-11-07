package com.duel.RPGChampion.services;

import com.duel.RPGChampion.model.Bandit;
import com.duel.RPGChampion.model.Hero;
import com.duel.RPGChampion.persistence.mapper.HeroMapper;
import com.duel.RPGChampion.persistence.model.HeroDAO;
import com.duel.RPGChampion.persistence.model.UserDAO;
import com.duel.RPGChampion.persistence.repository.HeroRepository;
import com.duel.RPGChampion.persistence.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CombatService {

    @Autowired
    private HeroRepository heroRepository;

    @Autowired
    private HeroMapper heroMapper;

    private static final String HERO_NOT_FOUND = "Hero not found!";

    private static final String HERO_IS_DEAD = "Hero is dead!\n";

    private static final String BANDIT_IS_DEAD = "Bandit is dead!\n";

    private static final int PVE_XP_WON = 50;

    private static final int NEXT_XP_LEVEL_SCALE = 100;

    private static final int DIFFICULTY = 2;

    private static final int NEXT_LOL_STRENGTH_BONUS = 2;

    private static final int NEXT_LVL_ABILITY_BONUS = 2;

    private static final int NEXT_LVL_HEALTH_BONUS = 10;

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

        Bandit bandit = generateBandit(hero);

<<<<<<< Updated upstream
        while (hero.getHp() > 0 && bandit.getHp() > 0) {
            hero.attack(bandit);
=======
        while (true) {
            hero.attack(enemy);
>>>>>>> Stashed changes

            if (bandit.getHp() > 0 && !bandit.dodge()) {
                bandit.attack(hero);
            }

            if (hero.getHp() < 0) {
                ret.append(HERO_IS_DEAD);
                hero.setHp(0); // Marquez le héros comme mort
                heroRepository.save(heroMapper.mapHeroToHeroDAO(hero));
                break;
            }

            if (bandit.getHp() <= 0) {
                ret.append(BANDIT_IS_DEAD);
                hero.setExperience(hero.getExperience() + PVE_XP_WON); // Gain d'XP
                Long currentGold = userDAO.getGold();
                userDAO.setGold(currentGold + PVE_XP_WON);
                levelUp(hero);
                heroRepository.save(heroMapper.mapHeroToHeroDAO(hero));
                break;
            }
        }
        return ret.toString();

    }


    /**
     * Méthode pour généré un Bandit suivant le héro
     * @param hero héro à partir du quel on va calculer les attributs du bandit
     * @return un bandit
     */
<<<<<<< Updated upstream
    private Bandit generateBandit(Hero hero) {
        Bandit bandit = new Bandit();
        bandit.setLevel(hero.getLevel());
        bandit.setHp(hero.getHp() / DIFFICULTY);
        bandit.setStrength(hero.getStrength() / DIFFICULTY);
        bandit.setAgility(hero.getAgility() / DIFFICULTY);
        return bandit;
=======
    private Entity generateEnemy(Hero hero) {
        Random random = new Random();
        int enemyType = random.nextInt(3);

        return switch (enemyType) {
            case 0 -> new Warrior(hero.getLevel()+1);
            case 1 -> new Mage(hero.getLevel()+1);
            case 2 -> new Monster(hero.getLevel()+1);
            default -> new Bandit(hero.getLevel()+1);
        };
>>>>>>> Stashed changes
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
            hero.setHp(hero.getHp() + NEXT_LVL_HEALTH_BONUS);
            hero.setStrength(hero.getStrength() + NEXT_LOL_STRENGTH_BONUS);
            hero.setAgility(hero.getAgility() + NEXT_LVL_ABILITY_BONUS);
        }
    }
}
