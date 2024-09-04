package com.duel.RPGChampion.services;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

@Service
public class ActivityChangerService {

    private final List<String> activities = List.of(
            "Wanna Fight ?",
            "Create your heroes!",
            "Fight against others!"
    );

    private final AtomicInteger index = new AtomicInteger(0);

    public String getActivity() {
        int currentIndex = index.getAndUpdate(i -> (i + 1) % activities.size());
        return activities.get(currentIndex);
    }
}
