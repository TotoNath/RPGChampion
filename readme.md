# RPGChampion

RPGChampion est une application composée d'un backend en Spring Boot et d'un frontend développé avec Flutter. Le backend
est intégré à un bot Discord utilisant JDA (Java Discord API) et permet aux utilisateurs de créer et gérer des héros,
ainsi que de participer à des combats PvE. Le frontend Flutter permettra d'interagir avec le backend via une API REST
pour enrichir l'expérience utilisateur en dehors de Discord.

## Prérequis

### Backend

- Java 17 ou supérieur
- Maven 3.6.3 ou supérieur
- Un token Discord valide
- PostgreSQL pour la base de données

### Frontend

- Flutter SDK 3.0 ou supérieur
- Un émulateur ou un appareil physique pour tester l'application mobile

# Installation

## Backend

1. Clonez le repository :

```bash
git clone https://github.com/TotoNath/RPGChampion
cd RPGChampion/backend
```

2. Configurez les propriétés de l'application :

Modifiez le fichier ``application.properties`` situé dans ``src/main/resources`` pour y inclure votre token Discord et
les
informations de votre base de données :

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

3. Compilez et lancez l'application backend :

```bash
mvn clean install
mvn spring-boot:run
```

## Frontend

1. Allez dans le répertoire frontend :

```
bash
cd ../frontend
```

2. Assurez-vous que Flutter est correctement installé et fonctionnel, puis récupérez les dépendances du projet :

```bash
flutter pub get
```

3. Lancer l'application sur un émulateur ou appareil physique :

```bash
flutter run
```

# Utilisation

## Backend (Bot Discord)

Le bot Discord répond à plusieurs commandes :

- ``!ping`` : répond !pong
- ``!help`` : affiche la liste des commandes disponibles
- ``!createHero <heroName>`` : crée un nouveau héros
- ``!getHeroes`` : affiche la liste de vos héros
- ``!deleteHero <heroName>`` : supprime un héros
- ``!heroesCount`` : affiche le nombre total de héros créés
- ``!selectHero <heroName>`` : sélectionne un héros pour des actions spécifiques comme !pve
- ``!pve`` : engage un combat PvE avec votre héros sélectionné
- ``!playerCount`` : affiche le nombre total d'utilisateurs

## Frontend (Application Flutter)

L'application Flutter est une interface utilisateur mobile qui communique avec le backend via une API REST pour
permettre la gestion des héros et des combats PvE en dehors de Discord. L'API du backend expose les fonctionnalités
suivantes :

- Créer un héros
- Obtenir la liste des héros
- Supprimer un héros
- Sélectionner un héros
- Participer à un combat PvE
-

Les requêtes HTTP du frontend Flutter se font via le package http pour dialoguer avec l'API REST du backend.

# Structure du projet

## Backend

- RpgChampionApplication : Point d'entrée de l'application
- BotConfig : Configuration du bot Discord
- controller : Gère les commandes et les API REST
- model : Modèles de données
- services : Contient les services de l'application
- persistence : Gère l'accès aux données via des repositories

## Frontend

- lib : Contient les fichiers Dart pour les pages et la logique de l'application
- android : Configuration Android
- ios : Configuration iOS

# Contribuer

Les contributions sont les bienvenues. Pour contribuer :

1. Forkez le repository
2. Créez une branche pour votre fonctionnalité (git checkout -b feature/AmazingFeature)
3. Commitez vos modifications (git commit -m 'Add some AmazingFeature')
4. Poussez la branche (git push origin feature/AmazingFeature)
5. Ouvrez une Pull Request

# License

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.