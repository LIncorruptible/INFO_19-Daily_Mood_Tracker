# Daily Mood Tracker

### Rapport de Projet : Maël Rhuin & Adrien Chretien  

Bienvenue dans l’application **Daily Mood Tracker** ! Cette application iOS vous permet de suivre vos humeurs, de consigner des journaux et de personnaliser vos expériences émotionnelles.  

## 🏁 Prise en Main Rapide  
Pour tester l’application, vous pouvez utiliser le compte suivant :  
- **Email** : `enseignant@email.com`  
- **Mot de passe** : `user2025PWD`  

Vous êtes également libre de créer un nouveau compte pour explorer toutes les fonctionnalités.  

---

## 📖 Introduction  
Ce projet a été réalisé par **Maël Rhuin** et **Adrien Chretien** dans le but d’approfondir nos compétences en développement d’applications complètes avec **SwiftUI** et **SwiftData**. Nous avons travaillé ensemble sur tous les aspects (frontend et backend) pour apprendre et progresser efficacement.

---

## ⚙️ Fonctionnalités Principales  
- **Gestion des Humeurs** : Suivi d’humeurs prédéfinies et personnalisées.  
- **Journal de Bord** : Ajout de notes détaillées à chaque humeur enregistrée.  
- **Authentification Sécurisée** : Gestion des comptes utilisateurs avec hachage des mots de passe.  
- **Personnalisation** : Ajout d’images et descriptions aux humeurs via `PhotosPicker`.  
- **Design Responsive** : Interface adaptée aux orientations portrait et paysage.

---

## 🏗️ Architecture et Technologies  
**Architecture MVC** :  
- **Models** : Gestion des entités principales (`Mood`, `Journal`, `User`) et persistance via **SwiftData**.  
- **Controllers** : Logique métier implémentée dans des classes comme `MoodController` et `UserController`.  
- **Views** : Interface utilisateur créée avec **SwiftUI**.

**Technologies** :  
- **SwiftUI** : Interfaces dynamiques et modernes.  
- **SwiftData** : Persistance des données et gestion des relations entités (Utilisateur ↔ Journal ↔ Humeur).

---

## 🖥️ Développement et Collaboration  
- **Méthodologie** :  
  - Création d’un document de conception initial pour structurer les fonctionnalités et les relations entre les données.  
  - Utilisation de **Git** pour la synchronisation et les revues de code.  
- **Communication** : Collaboration via **Discord**, avec des échanges réguliers et revues de code détaillées.  

---

## 📊 Modèle Conceptuel de Données (MCD)  
### Entités Principales :  
- **Utilisateur** : ID, nom, email, mot de passe.  
- **Humeur** : Nom, description, image, niveau.  
- **Journal** : Date, notes, humeur associée.  

### Relations :  
- Un utilisateur peut avoir plusieurs journaux (1-N).  
- Une humeur peut être associée à plusieurs journaux (1-N).

---

## 🔍 Limites et Prochaines Étapes  
### Non Implémenté :  
- **Statistiques avancées** : Analyse graphique des tendances d’humeur.  
- **Widget iOS** : Ajout rapide d’humeurs.  
- **Gestion des rappels** : Backend incomplet.  

### Améliorations Futures :  
- Intégration de tests automatisés.  
- Finalisation des fonctionnalités avancées.  

---

## 📦 Installation et Déploiement  
1. Clonez ce repository via Git :  
   ```bash
   git clone https://github.com/LIncorruptible/INFO_19-Daily_Mood_Tracker.git
   ```
2. Ouvrez le projet dans **Xcode**.  
3. Configurez un simulateur ou un appareil iOS pour tester l’application.  
4. Lancez l’application avec le compte de test ou créez un nouveau compte.

---

## 📝 Conclusion  
**Daily Mood Tracker** nous a permis de :  
- Appliquer une architecture moderne (**MVC**) et découvrir **SwiftUI**.  
- Collaborer efficacement dans un environnement de développement partagé.  
- Concevoir une application fonctionnelle, même avec des contraintes temporelles.  

Nous espérons que vous apprécierez explorer notre projet autant que nous avons apprécié le développer. 🚀  

--- 

### Contact  
Pour toute question ou retour, vous pouvez nous contacter à :  
- **Maël Rhuin** : [maelrhuin@gmail.com] 

---
