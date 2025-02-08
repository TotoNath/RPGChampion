package com.duel.RPGChampion.model;

import java.util.Objects;
import java.util.Random;

public abstract class Entity {

    private int hp;

    private int strength;

    private int agility;

    private int level;

    private int experience;

    private String Avatar;

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

    public String getAvatar() {
        return Avatar;
    }

    public void setAvatar(String avatar) {
        Avatar = avatar;
    }

    public boolean attack(Entity target) {
        Random rand = new Random();
        int attackChance = rand.nextInt(100);
        if (attackChance < this.strength) {
            target.hp -= this.strength;
            return true;
        }
        return false;
    }

    public boolean dodge() {
        Random rand = new Random();
        int dodgeChance = rand.nextInt(100);
        return dodgeChance < this.agility;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Entity entity = (Entity) o;
        return hp == entity.hp && strength == entity.strength && agility == entity.agility && level == entity.level && experience == entity.experience && Avatar == entity.Avatar;
    }

    @Override
    public int hashCode() {
        return Objects.hash(hp, strength, agility, level, experience, Avatar);
    }

    @Override
    public String toString() {
        return "Entity{" +
                "hp=" + hp +
                ", strength=" + strength +
                ", agility=" + agility +
                ", level=" + level +
                ", experience=" + experience +
                ", Avatar=" + Avatar +
                '}';
    }
}
