package com.duel.RPGChampion.model;

public class Mage extends Entity {
    // Constructeur avec des statistiques spécifiques au Mage
    public Mage(int level) {
        this.setLevel(level);
        this.setHp(level * 80); // Moins de PV mais plus de force magique
        this.setStrength(level * 15); // Dégâts élevés
        this.setAgility(level * 3); // Moins d'agilité
    }

    @Override
    public Long getCoins() {
        return ((getLevel()+1)* 2L);
    }
}
