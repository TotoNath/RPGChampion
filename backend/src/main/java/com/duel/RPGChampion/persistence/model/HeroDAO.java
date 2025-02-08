package com.duel.RPGChampion.persistence.model;

import com.duel.RPGChampion.model.Gender;
import jakarta.persistence.*;

import java.sql.Timestamp;
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

    private String guildId;

    private Timestamp afk;

    private String Avatar;

    public HeroDAO() {
        Random random = new Random();
        age = random.nextInt(100);
        gender = Gender.values()[random.nextInt(Gender.values().length)];
        hp = 100;
        afk = null;
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

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public String getGuildId() {
        return guildId;
    }

    public void setGuildId(String guildId) {
        this.guildId = guildId;
    }

    public Timestamp getAfk() {
        return afk;
    }

    public void setAfk(Timestamp afk) {
        this.afk = afk;
    }

    public String getAvatar() {
        return Avatar;
    }

    public void setAvatar(String avatar) {
        Avatar = avatar;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        HeroDAO heroDAO = (HeroDAO) o;
        return id == heroDAO.id && age == heroDAO.age && hp == heroDAO.hp && strength == heroDAO.strength && agility == heroDAO.agility && level == heroDAO.level && experience == heroDAO.experience && Objects.equals(name, heroDAO.name) && gender == heroDAO.gender && Objects.equals(guildId, heroDAO.guildId) && Objects.equals(afk, heroDAO.afk) && Objects.equals(Avatar, heroDAO.Avatar);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, name, age, gender, hp, strength, agility, level, experience, guildId, afk, Avatar);
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
                ", guildId='" + guildId + '\'' +
                ", afk=" + afk +
                ", Avatar='" + Avatar + '\'' +
                '}';
    }
}
