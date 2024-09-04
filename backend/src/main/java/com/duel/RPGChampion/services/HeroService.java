package com.duel.RPGChampion.services;

import com.duel.RPGChampion.model.Hero;
import com.duel.RPGChampion.persistence.mapper.HeroMapper;
import com.duel.RPGChampion.persistence.model.HeroDAO;
import com.duel.RPGChampion.persistence.model.UserDAO;
import com.duel.RPGChampion.persistence.repository.HeroRepository;
import com.duel.RPGChampion.persistence.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

/**
 * The hero Service
 */
@Service
public class HeroService {

    /**
     * The hero repository
     */
    @Autowired
    private HeroRepository heroRepository;

    /**
     * The user Repository
     */
    @Autowired
    private UserRepository userRepository;

    /**
     * The hero mapper
     */
    @Autowired
    private HeroMapper heroMapper;

    private static boolean wasHeroSuppressedFromHeroes(Set<HeroDAO> userDAO, String heroName, String guildId) {
        return userDAO.stream().noneMatch(hero -> hero.getName().equals(heroName) && hero.getGuildId().equals(guildId));
    }

    /**
     * Creates a hero
     *
     * @param heroName the heroes name
     * @param userId   the users id
     * @param username the username
     * @param guildId  the server id
     */
    public void createHero(String heroName, String userId, String username, String guildId) {
        Optional<UserDAO> optUser = userRepository.findByUserId(userId);
        UserDAO userDAO;

        if (optUser.isEmpty()) {
            userDAO = new UserDAO();
            userDAO.setUserId(userId);
            userDAO.setUsername(username);
            userDAO = userRepository.save(userDAO);
        } else {
            userDAO = optUser.get();
        }
        HeroDAO heroDAO = new HeroDAO();
        heroDAO.setName(heroName);
        heroDAO.setGuildId(guildId);
        heroDAO = heroRepository.save(heroDAO);

        Set<HeroDAO> oldHeroes = userDAO.getHeroes();
        Set<HeroDAO> newHeroes = new HashSet<>();

        if (!CollectionUtils.isEmpty(oldHeroes)) {
            newHeroes.addAll(oldHeroes);
        }

        newHeroes.add(heroDAO);
        userDAO.setHeroes(newHeroes);
        userRepository.save(userDAO);
        heroMapper.mapHeroDAOToHero(heroDAO);
    }

    /**
     * Get all the heroes of the current users id by the discord server
     *
     * @param userId the users id
     * @return all the heroes
     */
    @Transactional
    public List<Hero> getHeroesOfUser(String userId, String guildId) {
        List<Hero> ret = null;
        UserDAO userDAO = userRepository.findByUserId(userId).orElse(null);
        if (userDAO != null) {
            Set<HeroDAO> tmpSet = userDAO.getHeroes();
            List<HeroDAO> tmpList = null;
            if (!CollectionUtils.isEmpty(tmpSet)) {
                tmpList = tmpSet.stream().filter(hero -> hero.getGuildId().equals(guildId)).toList();
            }
            if (!CollectionUtils.isEmpty(tmpList)) {
                ret = tmpList.stream().map(heroMapper::mapHeroDAOToHero).sorted(Comparator.comparing(Hero::getId)).collect(Collectors.toList());
            }
        }
        return ret;

    }

    /**
     * The current function deletes a hero by his name from the heroes of the current user id
     *
     * @param heroName the heroes name
     * @param userId   the users id
     * @param guildId  the discord server id
     * @return true if was suppressed false otherwise
     */
    @Transactional
    public boolean deleteHero(String heroName, String userId, String guildId) {
        UserDAO userDAO = userRepository.findByUserId(userId).orElseThrow();

        Set<HeroDAO> heroes = userDAO.getHeroes();
        Set<HeroDAO> selectedHeroes = userDAO.getSelectedHero();

        removeAllHeroes(heroName, guildId, heroes);
        removeAllHeroes(heroName, guildId, selectedHeroes);

        userDAO.setHeroes(heroes);
        userDAO.setSelectedHero(selectedHeroes);

        userDAO = userRepository.save(userDAO);

        return wasHeroSuppressedFromHeroes(userDAO.getHeroes(), heroName, guildId) ||
                wasHeroSuppressedFromHeroes(userDAO.getSelectedHero(), heroName, guildId);
    }

    private void removeAllHeroes(String heroName, String guildId, Set<HeroDAO> heroDAOSet) {
        Set<HeroDAO> concernedHeroesA = heroDAOSet.stream().filter(hero -> hero.getName().equals(heroName) && hero.getGuildId().equals(guildId)).collect(Collectors.toSet());
        List<HeroDAO> concernedHeroesB = heroDAOSet.stream().filter(hero -> hero.getName().equals(heroName) && hero.getGuildId().equals(guildId)).toList();
        heroDAOSet.removeAll(concernedHeroesA);
        this.heroRepository.deleteAll(concernedHeroesB);
    }

    /**
     * Function returns all created heroes so far
     *
     * @return the count of all heroes
     */
    @Transactional
    public int getHeroesCount() {
        return heroRepository.findAll().size();
    }

    /**
     * Selects the hero with the heroName of the current user
     *
     * @param heroName the heroes name
     * @param userId   the users ID
     * @param guildId  the discord server id
     * @return true if a user is selected
     */
    @Transactional
    public boolean selectHero(String heroName, String userId, String guildId) {
        boolean ret = false;

        UserDAO userDAO = userRepository.findByUserId(userId).orElseThrow(null);

        if (userDAO != null) {
            Optional<HeroDAO> optionalHeroDAO = userDAO.getHeroes().stream().filter(heroDAO -> heroDAO.getName().equals(heroName) && heroDAO.getGuildId().equals(guildId)).findFirst();

            if (optionalHeroDAO.isPresent()) {
                HeroDAO hero = optionalHeroDAO.get();
                Set<HeroDAO> currentSelectedHeroes = userDAO.getSelectedHero();
                if (currentSelectedHeroes != null) {
                    currentSelectedHeroes.removeIf(heroDAO -> heroDAO.getGuildId().equals(hero.getGuildId()));
                    currentSelectedHeroes.add(hero);
                    userDAO.setSelectedHero(currentSelectedHeroes);
                    userRepository.save(userDAO);
                    ret = true;
                }
            }
        }
        return ret;

    }

    /**
     * Function used to rename the currently selected hero
     *
     * @param newHeroName the new hero name
     * @param userId      the id of the curent user playing
     * @param guildId     the id of the discord server
     * @return true if was renamed otherwise returns falls
     */
    @Transactional
    public boolean renameHero(String newHeroName, String userId, String guildId) {
        boolean ret = false;
        UserDAO userDAO = userRepository.findByUserId(userId).orElseThrow();
        HeroDAO selectedHero = userDAO.getSelectedHero().stream().filter(heroDAO -> heroDAO.getGuildId().equals(guildId)).findFirst().orElse(null);

        if (selectedHero != null) {
            Set<HeroDAO> currentSelectedHeroes = userDAO.getSelectedHero();
            currentSelectedHeroes.remove(selectedHero);
            selectedHero.setName(newHeroName);
            currentSelectedHeroes.add(selectedHero);
            userDAO.setSelectedHero(currentSelectedHeroes);
            userRepository.save(userDAO);
            ret = true;
        }

        return ret;
    }

    /**
     * Gets the top 10 heroes by their level
     *
     * @param guildId the guildId
     * @return a friendly string containing the top heroes
     */
    public String getLeaderboard(String guildId) {
        StringBuilder ret = new StringBuilder();
        List<Hero> heroes = heroRepository.findTop10ByGuildIdOrderByLevelDesc(guildId).stream().map(heroMapper::mapHeroDAOToHero).toList();
        if (!CollectionUtils.isEmpty(heroes)) {
            AtomicInteger i = new AtomicInteger(1);
            heroes.forEach(hero -> {
                ret.append(i.getAndIncrement()).append(" : ").append(hero.getName()).append(" is level : ").append(hero.getLevel()).append("\n");
            });

        } else {
            ret.append("No hero was created yet");
        }

        return ret.toString();
    }
}
