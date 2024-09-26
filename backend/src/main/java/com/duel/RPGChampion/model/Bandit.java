package com.duel.RPGChampion.model;

public class Bandit extends Entity{

    public Bandit(int level) {
        this.setLevel(level);
        this.setHp(level * 110);
        this.setStrength(level * 9);
        this.setAgility(level * 4);
    }

    @Override
    public Long getCoins() {
        return ((getLevel()+1)* 5L);
    }
}
