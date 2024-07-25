package com.duel.RPGChampion.persistence.repository;

import com.duel.RPGChampion.persistence.model.HeroDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface HeroRepository extends JpaRepository<HeroDAO, Integer> {

    Optional<HeroDAO> findById(int heroId);
}
