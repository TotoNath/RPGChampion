package com.duel.RPGChampion.model;

public class Warrior extends Entity {
    // Constructeur avec des statistiques spécifiques au Guerrier
    public Warrior(int level) {
        this.setLevel(level);
        this.setHp(level * 150);
        this.setStrength(level * 10);
        this.setAgility(level * 5);
    }

    @Override
    public Long getCoins() {
        return ((getLevel()+1)* 4L);
    }
}
