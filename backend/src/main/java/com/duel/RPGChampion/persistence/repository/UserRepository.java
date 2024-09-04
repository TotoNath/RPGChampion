package com.duel.RPGChampion.persistence.repository;

import com.duel.RPGChampion.persistence.model.UserDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserDAO, Long> {
    Optional<UserDAO> findByUserId(String userId);
}
