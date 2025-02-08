# Étape 1 : Utilisation d'une image Maven pour construire le projet
FROM maven:3.9.0-eclipse-temurin-17 AS build

# Défini le répertoire de travail dans le conteneur
WORKDIR /app

# Copie les fichiers de configuration Maven et le code source dans le conteneur
COPY pom.xml ./
COPY src ./src

# Construction du projet
RUN mvn clean package -DskipTests

# Étape 2 : Image de production minimale pour exécuter l'application
FROM eclipse-temurin:17-jdk

# Défini le répertoire de travail   dans le conteneur
WORKDIR /app

# Copier le JAR généré depuis l'étape de build
COPY --from=build /app/target/*.jar app.jar

# Expose le port sur lequel l'application écoute
EXPOSE 8080

# Commande pour exécuter l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
