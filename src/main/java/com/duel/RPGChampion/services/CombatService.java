package com.duel.RPGChampion.services;

import com.duel.RPGChampion.model.Bandit;
import com.duel.RPGChampion.model.Hero;
import com.duel.RPGChampion.persistence.mapper.HeroMapper;
import com.duel.RPGChampion.persistence.repository.HeroRepository;
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

    @Transactional
    public String startCombat(int heroId) {
        StringBuilder ret = new StringBuilder();

        Hero hero = heroMapper.mapHeroDAOToHero(heroRepository.findById(heroId).orElse(null));
        if (hero == null) {
            return HERO_NOT_FOUND;
        }

        Bandit bandit = generateBandit(hero);

        while (hero.getHp() > 0 && bandit.getHp() > 0) {
            hero.attack(bandit);

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
    private Bandit generateBandit(Hero hero) {
        Bandit bandit = new Bandit();
        bandit.setLevel(hero.getLevel());
        bandit.setHp(hero.getHp() / DIFFICULTY);
        bandit.setStrength(hero.getStrength() / DIFFICULTY);
        bandit.setAgility(hero.getAgility() / DIFFICULTY);
        return bandit;
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
