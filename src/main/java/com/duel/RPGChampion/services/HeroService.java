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

import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class HeroService {

    @Autowired
    private HeroRepository heroRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private HeroMapper heroMapper;

    public Hero createHero(String heroName, String userId, String username) {
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
        Set<HeroDAO> heroes = userDAO.getHeroes();
        heroes.add(heroDAO);
        userDAO.setHeroes(heroes);
        userRepository.save(userDAO);
        return heroMapper.mapHeroDAOToHero(heroDAO);
    }

    @Transactional
    public List<Hero> getHeroesOfUser(String id) {
        UserDAO userDAO = userRepository.findByUserId(id).orElseThrow();
        return userDAO.getHeroes().stream()
                .map(heroMapper::mapHeroDAOToHero)
                .sorted(Comparator.comparing(Hero::getId))
                .collect(Collectors.toList());

    }

    @Transactional
    public boolean deleteHero(String heroName, String userId) {
        UserDAO userDAO = userRepository.findByUserId(userId).orElseThrow();

        Set<HeroDAO> heroes = userDAO.getHeroes();
        heroes.removeAll(heroes.stream().filter(hero -> hero.getName().equals(heroName)).collect(Collectors.toSet()));
        userDAO.setHeroes(heroes);
        userDAO = userRepository.save(userDAO);
        return userDAO.getHeroes().stream().noneMatch(hero -> hero.getName().equals(heroName));
    }

    @Transactional
    public int getHeroesCount() {
        return heroRepository.findAll().size();
    }

    @Transactional
    public boolean selectHero(String heroName, String userId) {
        try {
            UserDAO userDAO = userRepository.findByUserId(userId).orElseThrow();
            HeroDAO hero = userDAO.getHeroes().stream().filter(heroDAO -> heroDAO.getName().equals(heroName)).findFirst().get();
            userDAO.setSelectedHero(hero);
            userRepository.save(userDAO);
            return true;
        } catch (Exception e) {
            return false;
        }

    }
}
