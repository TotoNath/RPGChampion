package com.duel.RPGChampion.config;

import com.duel.RPGChampion.services.ActivityChangerService;
import net.dv8tion.jda.api.JDA;
import net.dv8tion.jda.api.JDABuilder;
import net.dv8tion.jda.api.OnlineStatus;
import net.dv8tion.jda.api.entities.Activity;
import net.dv8tion.jda.api.requests.GatewayIntent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@Configuration
public class BotConfig {

    public static final int INTERVAL_IN_SEC = 6;
    @Autowired
    private ActivityChangerService activityChangerService;

    @Value("${discord.bot.token}")
    private String token;

    @Bean
    public JDA jda(JDABuilder jdaBuilder) throws Exception {
        JDA jda = jdaBuilder.build();
        startActivityUpdater(jda);
        return jda;
    }

    @Bean
    public JDABuilder jdaBuilder() {
        return JDABuilder.createDefault(token)
                .enableIntents(GatewayIntent.MESSAGE_CONTENT)
                .setActivity(Activity.playing(activityChangerService.getActivity()))
                .setStatus(OnlineStatus.DO_NOT_DISTURB);
    }

    private void startActivityUpdater(JDA jda) {
        ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
        scheduler.scheduleAtFixedRate(() -> {
            String activity = activityChangerService.getActivity();
            jda.getPresence().setActivity(Activity.playing(activity));
        }, 0, INTERVAL_IN_SEC, TimeUnit.SECONDS);
    }
}
