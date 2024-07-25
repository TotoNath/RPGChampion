package com.duel.RPGChampion.persistence.mapper;

import com.duel.RPGChampion.model.User;
import com.duel.RPGChampion.persistence.model.UserDAO;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface UserMapper {

    UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

    User mapUserDAOtoUser(UserDAO userDAO);

    UserDAO mapUserToUserDAO(User user);
}
