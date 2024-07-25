package com.duel.RPGChampion;

import com.duel.RPGChampion.controller.HelpController;
import com.duel.RPGChampion.controller.HeroController;
import com.duel.RPGChampion.controller.PingPongController;
import com.duel.RPGChampion.controller.UserController;
import net.dv8tion.jda.api.JDABuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class RpgChampionApplication implements CommandLineRunner {

    @Autowired
    private JDABuilder jdaBuilder;

    @Autowired
    private PingPongController pingPongController;

    @Autowired
    private HeroController heroController;

    @Autowired
    private HelpController helpController;

    @Autowired
    private UserController userController;

    public static void main(String[] args) {
        SpringApplication.run(RpgChampionApplication.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        jdaBuilder.addEventListeners(pingPongController)
                .addEventListeners(heroController)
                .addEventListeners(helpController)
                .addEventListeners(userController)
                .build();
    }

}
