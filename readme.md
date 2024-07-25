# RPGChampion

RPGChampion est une application Spring Boot intégrée à un bot Discord utilisant JDA (Java Discord API). L'application permet aux utilisateurs de créer et gérer des héros, ainsi que de participer à des combats PvE.

## Prérequis

- Java 17 ou supérieur 
- Maven 3.6.3 ou supérieur
- Un token Discord valide

## Installation

1. Clonez le repository :
 
    ```bash
    git clone https://github.com/TotoNath/RPGChampion
    cd RPGChampion
    ```

2. Configurez les propriétés de l'application :

   Modifiez le fichier `application.properties` situé dans `src/main/resources` pour y inclure votre token Discord et les informations de votre base de données :

    ```properties
    # application.properties
    spring.application.name=RPGChampion
    discord.bot.token=YOUR_DISCORD_BOT_TOKEN

    # Propriétés de la base de données
    spring.datasource.url=jdbc:postgresql://localhost:5432/mydatabase
    spring.datasource.username=postgres
    spring.datasource.password=postgres
    spring.datasource.driver-class-name=org.postgresql.Driver

    # Propriétés JPA/Hibernate
    spring.jpa.hibernate.ddl-auto=update
    spring.jpa.show-sql=true
    spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
    ```

3. Compilez et lancez l'application :

    ```bash
    mvn clean install
    mvn spring-boot:run
    ```

## Utilisation

### Commandes disponibles

Le bot Discord répond à plusieurs commandes :

- `!ping` : répond `!pong`
- `!help` : affiche la liste des commandes disponibles
- `!createHero <heroName>` : crée un nouveau héros
- `!getHeroes` : affiche la liste de vos héros
- `!deleteHero <heroName>` : supprime un héros
- `!heroesCount` : affiche le nombre total de héros créés
- `!selectHero <heroName>` : sélectionne un héros pour des actions spécifiques comme `!pve`
- `!pve` : engage un combat PvE avec votre héros sélectionné
- `!playerCount` : affiche le nombre total d'utilisateurs

### Exemple

Pour créer un héros nommé "Arthur", envoyez la commande suivante sur votre serveur Discord :

```plaintext
!createHero Arthur
```
## Structure du projet

- `RpgChampionApplication` : Point d'entrée de l'application
- `BotConfig` : Configuration du bot Discord
- `controller` : Contient les différents contrôleurs gérant les commandes
    - `HelpController` : Commande d'aide
    - `HeroController` : Commandes liées aux héros
    - `PingPongController` : Commande ping-pong
    - `UserController` : Commandes liées aux utilisateurs
- `model` : Contient les modèles de données
- `services` : Contient les services de l'application

## Contribuer

Les contributions sont les bienvenues. Pour contribuer :

1. Forkez le repository
2. Créez une branche pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Commitez vos modifications (`git commit -m 'Add some AmazingFeature'`)
4. Poussez la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## License

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.
