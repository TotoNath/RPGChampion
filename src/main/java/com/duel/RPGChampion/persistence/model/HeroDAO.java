package com.duel.RPGChampion.persistence.model;

import com.duel.RPGChampion.model.Gender;
import jakarta.persistence.*;

import java.util.Objects;
import java.util.Random;

@Entity
public class HeroDAO {

    @Id
    @GeneratedValue()
    private int id;

    private String name;

    private int age;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    private int hp;

    private int strength;

    private int agility;

    private int level;

    private int experience;

    public HeroDAO() {
        Random random = new Random();
        age = random.nextInt(100);
        gender = Gender.values()[random.nextInt(Gender.values().length)];
        hp = 100;
        calculateStrength();
        calculateAgility();
    }

    private void calculateAgility() {
        if (age < 18) {
            agility = 45;
        } else if (age > 60) {
            agility = 25;
        } else {
            agility = 35;
        }
    }

    private void calculateStrength() {
        if (age < 18) {
            strength = 5; // Faible force pour les mineurs
        } else if (age > 60) {
            strength = 10; // Faible force pour les personnes âgées
        } else {
            Random random = new Random();
            strength = random.nextInt(16) + 20; // Force aléatoire entre 20 et 35 pour les adultes entre 18 et 60 ans
        }
    }


    public void setId(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

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

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        HeroDAO heroDAO = (HeroDAO) o;
        return getId() == heroDAO.getId() && getAge() == heroDAO.getAge() && getHp() == heroDAO.getHp() && getStrength() == heroDAO.getStrength() && getAgility() == heroDAO.getAgility() && getLevel() == heroDAO.getLevel() && getExperience() == heroDAO.getExperience() && Objects.equals(getName(), heroDAO.getName()) && getGender() == heroDAO.getGender();
    }

    @Override
    public int hashCode() {
        return Objects.hash(getId(), getName(), getAge(), getGender(), getHp(), getStrength(), getAgility(), getLevel(), getExperience());
    }

    @Override
    public String toString() {
        return "HeroDAO{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", gender=" + gender +
                ", hp=" + hp +
                ", strength=" + strength +
                ", agility=" + agility +
                ", level=" + level +
                ", experience=" + experience +
                '}';
    }
}
