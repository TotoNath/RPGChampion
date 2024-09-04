package com.duel.RPGChampion.persistence.model;

import jakarta.persistence.*;

import java.util.Objects;
import java.util.Set;

@Entity
public class UserDAO {

    @Id
    @GeneratedValue()
    private Long baseId;

    private String username;

    private String userId;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private Set<HeroDAO> heroes;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private Set<HeroDAO> selectedHero;

    public Long getBaseId() {
        return baseId;
    }

    public void setBaseId(Long baseId) {
        this.baseId = baseId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Set<HeroDAO> getHeroes() {
        return heroes;
    }

    public void setHeroes(Set<HeroDAO> heroes) {
        this.heroes = heroes;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Set<HeroDAO> getSelectedHero() {
        return selectedHero;
    }

    public void setSelectedHero(Set<HeroDAO> selectedHero) {
        this.selectedHero = selectedHero;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserDAO userDAO = (UserDAO) o;
        return Objects.equals(baseId, userDAO.baseId) && Objects.equals(username, userDAO.username) && Objects.equals(userId, userDAO.userId) && Objects.equals(heroes, userDAO.heroes) && Objects.equals(selectedHero, userDAO.selectedHero);
    }

    @Override
    public int hashCode() {
        return Objects.hash(baseId, username, userId, heroes, selectedHero);
    }

    @Override
    public String toString() {
        return "UserDAO{" +
                "baseId=" + baseId +
                ", username='" + username + '\'' +
                ", userId='" + userId + '\'' +
                ", heroes=" + heroes +
                ", selectedHero=" + selectedHero +
                '}';
    }
}
