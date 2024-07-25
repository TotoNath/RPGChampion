package com.duel.RPGChampion.persistence.mapper;

import com.duel.RPGChampion.model.Hero;
import com.duel.RPGChampion.persistence.model.HeroDAO;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;
import org.springframework.beans.factory.annotation.Autowired;

@Mapper(componentModel = "spring")
public interface HeroMapper {

    HeroMapper INSTANCE = Mappers.getMapper(HeroMapper.class);

    @Autowired UserMapper userMapper = Mappers.getMapper(UserMapper.class);

    HeroDAO mapHeroToHeroDAO(Hero hero);

   default Hero mapHeroDAOToHero(HeroDAO hero) {
       if ( hero == null ) {
           return null;
       }

       Hero hero1 = new Hero();

       hero1.setHp( hero.getHp() );
       hero1.setStrength( hero.getStrength() );
       hero1.setAgility( hero.getAgility() );
       hero1.setLevel( hero.getLevel() );
       hero1.setExperience( hero.getExperience() );
       hero1.setId( hero.getId() );
       hero1.setName( hero.getName() );
       hero1.setAge( hero.getAge() );
       hero1.setGender( hero.getGender() );

       return hero1;
   }
}
