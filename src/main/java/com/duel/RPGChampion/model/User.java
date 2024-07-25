package com.duel.RPGChampion.model;

import java.util.Objects;
import java.util.Set;

public class User {

    private Long baseId;

    private String username;

    private String userId;

    private Set<Hero> heroes;

    private Hero selectedHero;

    public Long getBaseId() {
        return baseId;
    }

    public void setBaseId(Long baseId) {
        this.baseId = baseId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Set<Hero> getHeroes() {
        return heroes;
    }

    public void setHeroes(Set<Hero> heroes) {
        this.heroes = heroes;
    }

    public Hero getSelectedHero() {
        return selectedHero;
    }

    public void setSelectedHero(Hero selectedHero) {
        this.selectedHero = selectedHero;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return Objects.equals(getBaseId(), user.getBaseId()) && Objects.equals(getUsername(), user.getUsername()) && Objects.equals(getUserId(), user.getUserId()) && Objects.equals(getHeroes(), user.getHeroes()) && Objects.equals(getSelectedHero(), user.getSelectedHero());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getBaseId(), getUsername(), getUserId(), getHeroes(), getSelectedHero());
    }

    @Override
    public String toString() {
        return "User{" +
                "baseId=" + baseId +
                ", username='" + username + '\'' +
                ", userId='" + userId + '\'' +
                ", heroes=" + heroes +
                ", selectedHero=" + selectedHero +
                '}';
    }
}
