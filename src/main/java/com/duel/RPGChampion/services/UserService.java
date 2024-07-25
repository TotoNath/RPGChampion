package com.duel.RPGChampion.services;

import com.duel.RPGChampion.persistence.mapper.UserMapper;
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

    public int getSelectedHeroId(String userId) {
        return userRepository.findByUserId(userId).orElseThrow().getSelectedHero().getId();
    }
}
