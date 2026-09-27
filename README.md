# 🛍️ E-commerce App — Flutter & Riverpod

Application e-commerce mobile développée avec **Flutter** et **Riverpod** comme solution unique de gestion d'état, dans le cadre d'un exercice de validation des compétences en state management.

---

## 📋 Sommaire

- [Fonctionnalités](#-fonctionnalités)
- [Stack technique](#-stack-technique)
- [Architecture](#-architecture)
- [Structure du projet](#-structure-du-projet)
- [Providers Riverpod](#-providers-riverpod)
- [Navigation](#-navigation)
- [Gestion des états asynchrones](#-gestion-des-états-asynchrones)
- [Lancer le projet](#-lancer-le-projet)
- [Limites connues / pistes d'amélioration](#-limites-connues--pistes-damélioration)

---

## ✨ Fonctionnalités

| Fonctionnalité            | Description                                                                             |
| ------------------------- | --------------------------------------------------------------------------------------- |
| 🏠 **Catalogue produits** | Liste des produits avec recherche, carrousel des produits mis en avant, grille complète |
| 🔍 **Détail produit**     | Écran dédié avec image, description, sélecteur de quantité, ajout au panier             |
| 🛒 **Panier**             | Ajout, suppression (swipe), modification de quantité, calcul du total en temps réel     |
| ❤️ **Favoris**            | Ajout/retrait d'un produit aux favoris, persistance locale                              |
| 🗂️ **Filtres & tri**      | Filtrage par catégorie (bottom sheet dédié), tri par nom/prix (croissant/décroissant)   |
| 👤 **Profil utilisateur** | Écran de profil (données mockées)                                                       |

---

## 🧱 Stack technique

- **Flutter** — framework UI
- **flutter_riverpod** — gestion d'état (providers modernes `Notifier`/`AsyncNotifier` + `StateNotifier` legacy où pertinent)
- **go_router** — navigation déclarative, avec `StatefulShellRoute` pour la barre de navigation persistante
- **Poppins** — police principale de l'app (cohérence visuelle sur tous les écrans)

---

## 🏗️ Architecture

Le projet suit une **architecture en couches** (_layered architecture_), avec une séparation stricte entre logique métier et widgets, organisée **par fonctionnalité** (_feature-first_) plutôt que par type de fichier :

```
feature/
├── data/            # Sources de données (mock, JSON, API future) et modèles bruts
├── domain/           # Modèles métier (Product, Category, CartItem, User…)
├── application/       # Providers Riverpod : logique métier, état, dérivation de données
└── presentation/
    ├── screens/       # Écrans complets (pages)
    └── widgets/        # Composants réutilisables et sans logique métier propre
```

**Principe directeur** : les widgets de `presentation/` ne contiennent **aucune logique métier**. Ils consomment l'état exposé par les providers (`ref.watch`) et déclenchent des actions via les notifiers (`ref.read(...).notifier`). Toute la logique (filtrage, tri, calcul de total, gestion du panier…) vit dans `application/`.

---

## 📁 Structure du projet

```
lib/
└── src/
    ├── core/
    │   └── widgets/
    │       └── navigation_bar.dart          # Barre de navigation (Bottom Navigation)
    ├── features/
    │   ├── products/
    │   │   ├── data/
    │   │   │   └── mock_data.dart            # Produits & catégories mockés
    │   │   ├── domain/
    │   │   │   └── product_model.dart        # Product, Category
    │   │   ├── application/
    │   │   │   └── product_provider.dart     # Providers catalogue, filtres, tri
    │   │   └── presentation/
    │   │       ├── products_screen.dart
    │   │       ├── screens/
    │   │       │   └── product_detail_screen.dart
    │   │       └── widgets/
    │   │           ├── header.dart
    │   │           ├── search_bar.dart
    │   │           ├── category_chip.dart
    │   │           ├── product_card.dart
    │   │           ├── product_carrousel.dart
    │   │           ├── filter_bottom_sheet.dart
    │   │           └── sort_bottom_sheet.dart
    │   ├── cart/
    │   │   ├── data/
    │   │   │   └── cart_item_model.dart
    │   │   ├── application/
    │   │   │   └── cart_provider.dart
    │   │   └── presentation/
    │   │       └── cart_screen.dart
    │   ├── favorites/
    │   │   ├── application/
    │   │   │   └── favorites_provider.dart
    │   │   └── presentation/
    │   │       └── favorites_screen.dart
    │   └── profile/
    │       ├── application/
    │       │   └── user_provider.dart
    │       └── presentation/
    │           └── profile_screen.dart
    └── routing/
        └── routes.dart                   # Configuration go_router
```

---

## ⚙️ Providers Riverpod

Le projet compte **plus de 5 providers distincts**, couvrant les différents types proposés par Riverpod (`NotifierProvider`, `StateNotifierProvider`, `FutureProvider`, `Provider`, `Provider.family`).

| Provider                   | Type                                                    | Rôle                                                                   |
| -------------------------- | ------------------------------------------------------- | ---------------------------------------------------------------------- |
| `productsProvider`         | `FutureProvider`                                        | Charge le catalogue produits (données mockées, simule un appel réseau) |
| `productByIdProvider`      | `FutureProvider.family<Product, String>`                | Récupère un produit précis par `id`, utilisé sur l'écran de détail     |
| `categoriesProvider`       | `Provider`                                              | Expose la liste des catégories                                         |
| `selectedCategoryProvider` | `NotifierProvider<SelectedCategoryNotifier, Category?>` | Catégorie sélectionnée pour le filtrage                                |
| `searchQueryProvider`      | `NotifierProvider<SearchQueryNotifier, String>`         | Texte de recherche saisi par l'utilisateur                             |
| `sortOptionProvider`       | `NotifierProvider<SortOptionNotifier, SortOption>`      | Option de tri active (nom/prix, asc/desc)                              |
| `filteredProductsProvider` | `Provider<List<Product>>`                               | Provider **dérivé** : combine produits, catégorie, recherche et tri    |
| `cartProvider`             | `StateNotifierProvider<CartNotifier, List<CartItem>>`   | État du panier (ajout, suppression, quantité)                          |
| `cartTotalProvider`        | `Provider<double>`                                      | Provider dérivé : total du panier                                      |
| `cartItemCountProvider`    | `Provider<int>`                                         | Provider dérivé : nombre total d'articles                              |
| `favoritesProvider`        | `NotifierProvider`                                      | Liste des ids favoris, avec persistance locale                         |
| `userProvider`             | `Provider`                                              | Utilisateur mocké pour l'écran de profil                               |

> 💡 **Pattern clé** : `filteredProductsProvider`, `cartTotalProvider` et `cartItemCountProvider` illustrent l'usage de **providers dérivés** — ils observent d'autres providers (`ref.watch`) et recalculent automatiquement leur valeur, sans logique dupliquée côté UI.

---

## 🧭 Navigation

La navigation utilise **go_router** avec un `StatefulShellRoute.indexedStack` pour la barre de navigation persistante (Accueil, Panier, Favoris, Profil), chaque onglet conservant son propre état de pile.

Point d'architecture important : l'écran de **détail produit** est déclaré comme route **top-level**, en dehors du `StatefulShellRoute` — il s'affiche donc en plein écran, sans la barre de navigation, avec une gestion correcte du retour (`context.pop()` avec fallback si aucune route à empiler).

---

## ⏳ Gestion des états asynchrones

Les données chargées de façon asynchrone (`productsProvider`, `productByIdProvider`) sont exposées via `AsyncValue` et consommées avec `.when(...)` dans l'UI :

```dart
productAsync.when(
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (err, _) => _ErrorState(message: '$err', onRetry: () => ref.invalidate(...)),
  data: (product) => _ProductDetailContent(product: product),
);
```

Chaque écran concerné gère explicitement les **3 états** : chargement, erreur (avec action de retry via `ref.invalidate`), et succès.

---

## ▶️ Lancer le projet

```bash
flutter pub get
flutter run
```

---

## 🚧 Limites connues / pistes d'amélioration

- **Persistance des favoris** : le provider expose l'API nécessaire ; la persistance locale (`shared_preferences` ou `hive`) est à finaliser/vérifier selon l'implémentation actuelle du `FavoritesNotifier`.
- **Commande** : le bouton "Commander" du panier est un point d'entrée UI non branché à un flux de paiement (hors périmètre de l'exercice).
- **Données produits** : actuellement mockées en local ; l'architecture en couches (`data/` séparé de `domain/`) permet de basculer vers une vraie API sans impacter `application/` ni `presentation/`.
- **Animations bonus** : à ajouter sur l'action "ajouter au panier" (ex. `Hero` déjà posé sur l'image produit, extensible avec une animation de vol vers l'icône panier).
