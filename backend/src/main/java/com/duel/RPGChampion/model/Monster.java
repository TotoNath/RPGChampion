package com.duel.RPGChampion.model;

public class Monster extends Entity {
    // Constructeur avec des statistiques spécifiques au Monstre
    public Monster(int level) {
        this.setLevel(level);
        this.setHp(level * 200);
        this.setStrength(level * 5);
        this.setAgility(level * 2);
    }

    @Override
    public Long getCoins() {
        return ((getLevel()+1)* 5L);
    }
}

