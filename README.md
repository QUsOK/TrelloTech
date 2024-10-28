# TaskTician


<a  name="readme-top"></a>


<!-- PROJECT LOGO -->
<br  />
<div  align="center">
<a  href="https://github.com/othneildrew/Best-README-Template">
<img  src="images/logo.png"  alt="Logo"  width="80"  height="80">
</a>
<h3  align="center">TaskTician</h3>
<p  align="center">
Gérer votre organisation simplement et efficacement via la gestion API de Trello, le tout, dans une app mobile.
<br  />
<a  href="https://github.com/othneildrew/Best-README-Template"><strong>Explore the docs »</strong></a>
<br  />
<br  />
</p>
</div>

<!-- TABLE OF CONTENTS -->

<details>
<summary>Table des matières</summary>
<ol>
<li>
<a  href="#a-propos-du-projet">A propos du projet</a>
<ul>
<li><a  href="#stack-technologique">Stack technologique</a></li>
</ul>
</li>
<li>
<a  href="#commencer">Commencer</a>
<ul>
<li><a  href="#pré-requis">Pré-requis</a></li>
<li><a  href="#installation">Installation</a></li>
</ul>
</li>
</ol>
</details>

## A propos du projet

  

[![Product Name Screen Shot][product-screenshot]](https://example.com)


Le projet TrellTech vise à créer une application de gestion de projet innovante en intégrant judicieusement des bibliothèques existantes et en mettant en œuvre l'API Trello pour offrir une expérience utilisateur exceptionnelle. Cette documentation détaille les aspects clés du projet, couvrant l'intégration des bibliothèques, l'utilisation de l'API Trello, les considérations UX/UI, et la stratégie de test.

  

---

### Intégration de Bibliothèques Existantes

  
  

L'objectif principal de cette phase est de minimiser la réécriture de code inutile en intégrant des bibliothèques existantes. Le code sera structuré en deux parties distinctes : le collage entre les composants fonctionnels existants et la logique métier.

Recommandations Préliminaires

Avant de débuter le projet, il est fortement recommandé de mener une recherche approfondie sur les frameworks et les bibliothèques disponibles. L'analyse des API à implémenter est essentielle pour choisir le framework le plus approprié. Cette phase déterminera le succès de l'intégration des bibliothèques existantes.

  

---

### Application avec l'API Trello
L'application TrellTech utilisera l'API Trello pour fournir une gestion de projet robuste. Les caractéristiques obligatoires incluent :
- Gestion des Espaces de Travail : Permettre aux utilisateurs de créer, modifier et organiser des espaces de travail dédiés à différents projets.
- Tableaux : Faciliter la création de tableaux pour organiser les tâches de manière visuelle.
- Listes : Offrir une gestion flexible des listes au sein des tableaux, permettant un suivi détaillé des étapes du projet.
- Cartes : Autoriser la création et la gestion de cartes, représentant les tâches individuelles.
Fonctionnalités Facultatives (Bonus)

En plus des caractéristiques obligatoires, des fonctionnalités bonus peuvent être intégrées, telles que la documentation utilisateur complète et d'autres fonctionnalités novatrices qui n'ont pas été explicitement spécifiées.
  
---

### Expérience Utilisateur et Interface Utilisateur
  
L'expérience utilisateur (UX) est au cœur du développement de TrellTech. Les utilisateurs doivent non seulement bénéficier de fonctionnalités puissantes, mais aussi d'une interface utilisateur (UI) intuitive. L'évaluation de l'identité visuelle, de l'interface utilisateur et de l'expérience utilisateur sera cruciale pour assurer la satisfaction des utilisateurs finaux.

Considérations


- Navigation Intuitive : Assurer une navigation fluide et intuitive à travers l'application.
- Design Visuel : Évaluer l'aspect visuel de l'application pour garantir une expérience esthétiquement agréable.
- Réactivité : Veiller à ce que l'application réponde de manière rapide et efficace aux actions de l'utilisateur.
---

### Stratégie de Test

  

La qualité de toute application dépend de son processus de test. Pour TrellTech, une stratégie de test complète sera mise en place pour garantir la fiabilité et la stabilité de l'application.

Éléments Clés

- Tests Unitaires : Évaluation des composants individuels pour s'assurer de leur fonctionnement correct.
- Tests d'Intégration : Vérification de l'interopérabilité entre les différentes parties de l'application.
- Tests d'Interface Utilisateur : Validation de l'expérience utilisateur conformément aux spécifications UX/UI.
- Tests de Performance : Mesure de la réactivité et de la stabilité de l'application sous différentes charges.

  

<p  align="right">(<a  href="#readme-top">Revenir en haut</a>)</p>

  

---
  

### Stack technologique

  

* [![Flutter1][Flutter2]][Flutter-url]

* [![Dart1][Dart2]][Dart-url]

* [![Trello1][Trello2]][Trello-url]

<p  align="right">(<a  href="#readme-top">Revenir en haut</a>)</p>

  
  
<!-- GETTING STARTED -->

## Commencer

### Pré-requis

  

Installation de flutter

```sh

https://docs.flutter.dev/get-started/install

```  

### Installation
  


1. Clone the repo

```sh

git clone git@github.com:EpitechMscProPromo2026/T-DEV-600-NCY_2.git

```

2. Création d'une espace personnel

```
https://trello.com/power-ups/admin
```

3. Changement des variables d'environnement dans `.\trellotech\env.g.dart`

```sh
final class _Env {
  static const String apikey = 'my_api_key';
  static const String token = 'my_token';
  static const String board = 'my_board';
}
```

4. Lancement de l'application

```js

cd .\trellotech
flutter run

```
<p  align="right">(<a  href="#readme-top">Revenir en haut</a>)</p>

  
<!-- MARKDOWN LINKS & IMAGES -->

<!-- Image projet -->
[product-screenshot]: images/screenshot.png
  
<!-- STACK TECHNOLOGIQUE -->

<!-- Flutter -->
[Flutter2]: https://img.shields.io/badge/flutter-blue?style=for-the-badge&logo=flutter&logoColor=blue&labelColor=grey
[Flutter-url]: https://flutter.dev/

<!-- Dart -->
[Dart2]: https://img.shields.io/badge/dart-blue?style=for-the-badge&logo=dart&logoColor=blue&labelColor=grey
[Dart-url]: https://dart.dev/

<!-- Trello -->
[Trello2]: https://img.shields.io/badge/Trello_API-blue?style=for-the-badge&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAACQElEQVR42nWTT0hUZfv/98ZyRkiRjAURAZJDEwFGkNRCY9iMJWkNRhNGjLqFNpEGlGbhZYrLFXVgkFBw8ODL8hZGRkcLy/vlzAABlMJ3/M9lZpmdmZmagoKCsLTk5OD69atMTExOnTokL+/v1dXVlYYNGzbMzMwM3Nzc0GAx+Mr6dOnWqqgqKiovD1q1bl+Hh4Vi7di4VHx+eOnTsnJyVJcFCxcqNjZqamsLx582IyPDp06IlmzZpVt27bPnj1C3oWGhkpMTM88eWlJSwtrZWVkZCgoKPFy9eXL9+PAhPTk9F7tdXV1bNmTJNWrUKDQ
[Trello-url]: https://vuejs.org/

<h3>Contributeurs</h3>

* <a  href="https://www.linkedin.com/in/marc-cendan-6544b8195/">**Marc CENDAN**</a>
* <a  href="https://www.linkedin.com/in/nathan-gassmann/">**Nathan GASSMANN**</a>
* <a  href="https://www.linkedin.com/in/axel-boulfoul-morin-259884143/">**Axel BOUFOUL MORIN**</a>
