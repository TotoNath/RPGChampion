package com.duel.RPGChampion.persistence.repository;

import com.duel.RPGChampion.persistence.model.PrefixModelDAO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PrefixRepository  extends JpaRepository<PrefixModelDAO, Integer> {
}
