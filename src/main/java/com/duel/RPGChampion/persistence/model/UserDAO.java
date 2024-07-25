package com.duel.RPGChampion.persistence.model;

import jakarta.persistence.*;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.Type;

import java.util.Objects;
import java.util.Set;

@Entity
public class UserDAO {

    @Id
    @GeneratedValue()
    private Long baseId;

    private String username;

    private String userId;

    @OneToMany( cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private Set<HeroDAO> heroes;

    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private HeroDAO selectedHero;

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

    public HeroDAO getSelectedHero() {
        return selectedHero;
    }

    public void setSelectedHero(HeroDAO selectedHero) {
        this.selectedHero = selectedHero;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserDAO userDAO = (UserDAO) o;
        return getBaseId() == userDAO.getBaseId() && Objects.equals(getUsername(), userDAO.getUsername()) && Objects.equals(getUserId(), userDAO.getUserId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getBaseId(), getUsername(), getUserId());
    }

    @Override
    public String toString() {
        return "UserDAO{" +
                "baseId=" + baseId +
                ", username='" + username + '\'' +
                ", userId='" + userId + '\'' +
                '}';
    }
}
