package com.duel.RPGChampion.model;

import java.util.Objects;

public class Hero extends Entity {

    private int id;

    private String name;

    private int age;

    private Gender gender;

    private User user;

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

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        if (!super.equals(o)) return false;
        Hero hero = (Hero) o;
        return getId() == hero.getId() && getAge() == hero.getAge() && Objects.equals(getName(), hero.getName()) && getGender() == hero.getGender() && Objects.equals(getUser(), hero.getUser());
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getId(), getName(), getAge(), getGender(), getUser());
    }

    @Override
    public String toString() {
        return "Hero{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", gender=" + gender +
                ", user=" + user +
                '}';
    }

    public String toFriendlyString(){
        return name + " is " + age + " years old, is a " + gender + " has " + super.getHp() + "hp with " + super.getStrength() + "strenght and " + super.getAgility() +" ability\n\t\tLVL :" + super.getLevel() + "\tExperience :" + super.getExperience();
    }
}
