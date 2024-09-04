package com.duel.RPGChampion.model;

import java.util.Objects;
import java.util.Set;

public class User {

    private Long baseId;

    private String username;

    private String userId;

    private Set<Hero> heroes;

    private Set<Hero> selectedHero;

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

    public Set<Hero> getSelectedHero() {
        return selectedHero;
    }

    public void setSelectedHero(Set<Hero> selectedHero) {
        this.selectedHero = selectedHero;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return Objects.equals(baseId, user.baseId) && Objects.equals(username, user.username) && Objects.equals(userId, user.userId) && Objects.equals(heroes, user.heroes) && Objects.equals(selectedHero, user.selectedHero);
    }

    @Override
    public int hashCode() {
        return Objects.hash(baseId, username, userId, heroes, selectedHero);
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
