package com.duel.RPGChampion;

import com.duel.RPGChampion.controller.*;
import com.duel.RPGChampion.controller.help.HelpController;
import com.duel.RPGChampion.controller.hero.HeroController;
import com.duel.RPGChampion.controller.pingpong.PingPongController;
import com.duel.RPGChampion.controller.user.UserController;
import net.dv8tion.jda.api.JDA;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class RpgChampionApplication implements CommandLineRunner {

    @Autowired
    private JDA jda;

    @Autowired
    private PingPongController pingPongController;

    @Autowired
    private HeroController heroController;

    @Autowired
    private HelpController helpController;

    @Autowired
    private UserController userController;

    @Autowired
    private PrefixController prefixController;

    public static void main(String[] args) {
        SpringApplication.run(RpgChampionApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        jda.addEventListener(pingPongController, heroController, userController, prefixController, helpController);
    }
}