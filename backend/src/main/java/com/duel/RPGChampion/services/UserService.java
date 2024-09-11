package com.duel.RPGChampion.services;

import com.duel.RPGChampion.persistence.mapper.UserMapper;
import com.duel.RPGChampion.persistence.model.HeroDAO;
import com.duel.RPGChampion.persistence.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserMapper userMapper;

    public int getPlayerCount() {
        return userRepository.findAll().size();
    }

    public int getSelectedHeroId(String userId, String guildId) {
        HeroDAO h = userRepository.findByUserId(userId).orElseThrow().getSelectedHero()
                .stream()
                .filter(heroDAO -> heroDAO.getGuildId().equals(guildId) && heroDAO.getAfk() == null).findFirst()
                .orElse(null);
        return h != null ? h.getId() : -1;
    }
}
