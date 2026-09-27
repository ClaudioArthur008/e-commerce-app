# E-commerce App with Riverpod

## Architecture
- **Domain** : modèles (Product, Category, CartItem, User)
- **Data** : mock data et persistance locale (SharedPreferences pour les favoris)
- **Application** : providers Riverpod pour la logique métier
- **Presentation** : widgets et pages Flutter

## Providers
- `productsProvider` : FutureProvider pour charger les produits
- `cartProvider` : StateNotifierProvider pour gérer le panier
- `favoritesProvider` : StateNotifierProvider pour gérer les favoris avec persistance
- `selectedCategoryProvider` : NotifierProvider pour la catégorie sélectionnée
- `searchQueryProvider` : StateProvider pour la recherche
- `sortOptionProvider` : StateProvider pour le tri
- `filteredProductsProvider` : Provider combinant filtres et tri

## Fonctionnalités
- Catalogue de produits avec grille
- Détail du produit
- Panier (ajout, retrait, modification quantité)
- Favoris persistés localement
- Filtrage par catégorie et recherche
- Tri (nom, prix)
- Profil utilisateur mocké
- Gestion des états de chargement et erreurs avec AsyncValue

## Lancer le projet
1. `flutter pub get`
2. `flutter run`