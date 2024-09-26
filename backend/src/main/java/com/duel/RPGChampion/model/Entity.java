package com.duel.RPGChampion.model;

import java.util.Objects;
import java.util.Random;

public abstract class Entity {

    private int hp;

    private int strength;

    private int agility;

    private int level;

    private int experience;

    public int getHp() {
        return hp;
    }

    public void setHp(int hp) {
        this.hp = hp;
    }

    public int getStrength() {
        return strength;
    }

    public void setStrength(int strength) {
        this.strength = strength;
    }

    public int getAgility() {
        return agility;
    }

    public void setAgility(int agility) {
        this.agility = agility;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public int getExperience() {
        return experience;
    }

    public void setExperience(int experience) {
        this.experience = experience;
    }

    public boolean attack(Entity target) {
        Random rand = new Random();
        int attackChance = rand.nextInt(100);
        int bonus = 20; // Bonus de chance d'attaque augmenté pour le joueur
        if (this instanceof Hero) {
            attackChance += bonus;
        }
        if (attackChance < this.strength) {
            target.hp -= this.strength;
            return true;
        }
        return false;
    }

    public boolean dodge() {
        Random rand = new Random();
        int dodgeChance = rand.nextInt(100);
        int bonus = 20; // Bonus de chance d'esquive augmenté pour le joueur
        if (this instanceof Hero) {
            dodgeChance += bonus;
        }
        return dodgeChance < this.agility;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Entity entity = (Entity) o;
        return getHp() == entity.getHp() && getStrength() == entity.getStrength() && getAgility() == entity.getAgility() && getLevel() == entity.getLevel() && getExperience() == entity.getExperience();
    }

    @Override
    public int hashCode() {
        return Objects.hash(getHp(), getStrength(), getAgility(), getLevel(), getExperience());
    }

    @Override
    public String toString() {
        return "Entity{" +
                "hp=" + hp +
                ", strength=" + strength +
                ", agility=" + agility +
                ", level=" + level +
                ", experience=" + experience +
                '}';
    }

    public abstract Long getCoins();
}
