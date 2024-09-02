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

    /**
     * Creates a hero
     *
     * @param heroName the heroes name
     * @param userId   the users id
     * @param username the username
     */
    public void createHero(String heroName, String userId, String username) {
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
     * Get all the heroes of the current users id
     *
     * @param id the users id
     * @return all the heroes
     */
    @Transactional
    public List<Hero> getHeroesOfUser(String id) {
        List<Hero> ret = null;
        UserDAO userDAO = userRepository.findByUserId(id).orElse(null);
        if (userDAO != null) {
            ret = userDAO.getHeroes().stream()
                    .map(heroMapper::mapHeroDAOToHero)
                    .sorted(Comparator.comparing(Hero::getId))
                    .collect(Collectors.toList());
        }
        return ret;

    }

    /**
     * The current function deletes a hero by his name from the heroes of the current user id
     *
     * @param heroName the heroes name
     * @param userId   the users id
     * @return true if was suppressed false otherwise
     */
    @Transactional
    public boolean deleteHero(String heroName, String userId) {
        UserDAO userDAO = userRepository.findByUserId(userId).orElseThrow();

        Set<HeroDAO> heroes = userDAO.getHeroes();
        heroes.removeAll(heroes.stream().filter(hero -> hero.getName().equals(heroName)).collect(Collectors.toSet()));
        userDAO.setHeroes(heroes);
        userDAO = userRepository.save(userDAO);
        return userDAO.getHeroes().stream().noneMatch(hero -> hero.getName().equals(heroName));
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
     * @return true if a user is selected
     */
    @Transactional
    public boolean selectHero(String heroName, String userId) {
        boolean ret = false;
        try {
            UserDAO userDAO = userRepository.findByUserId(userId).orElseThrow();
            HeroDAO hero = userDAO.getHeroes().stream().filter(heroDAO -> heroDAO.getName().equals(heroName)).findFirst().get();
            userDAO.setSelectedHero(hero);
            userRepository.save(userDAO);
            ret = true;
        } catch (Exception ignored) {
        }
        return ret;
    }

    /**
     * Function used to rename the currently selected hero
     *
     * @param newHeroName the new hero name
     * @param userId      the id of the curent user playing
     * @return true if was renamed otherwise returns falls
     */
    @Transactional
    public boolean renameHero(String newHeroName, String userId) {
        boolean ret = false;
        UserDAO userDAO = userRepository.findByUserId(userId).orElseThrow();
        HeroDAO selectedHero = userDAO.getSelectedHero();

        if (selectedHero != null) {
            selectedHero.setName(newHeroName);
            userDAO.setSelectedHero(selectedHero);
            userRepository.save(userDAO);
            ret = true;
        }

        return ret;
    }

    /**
     * Gets the top 10 heroes by their level
     *
     * @return a friendly string containing the top heroes
     */
    public String getLeaderboard() {
        StringBuilder ret = new StringBuilder();
        List<Hero> heroes = heroRepository.findTop10ByOrderByLevelDesc().stream().map(heroMapper::mapHeroDAOToHero).toList();
        if (!CollectionUtils.isEmpty(heroes)) {
            AtomicInteger i = new AtomicInteger(1);
            heroes.forEach(hero -> {
                ret.append(i.getAndIncrement())
                        .append(" : ")
                        .append(hero.getName())
                        .append(" is level : ")
                        .append(hero.getLevel())
                        .append("\n");
            });

        } else {
            ret.append("No hero was created yet");
        }

        return ret.toString();
    }
}
