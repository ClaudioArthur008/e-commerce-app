import 'package:e_commerce_app/src/core/widgets/navigation_bar.dart';
import 'package:e_commerce_app/src/features/cart/presentation/cart_screen.dart';
import 'package:e_commerce_app/src/features/favorites/presentation/favorites_screen.dart';
import 'package:e_commerce_app/src/features/products/presentation/products_screen.dart';
import 'package:e_commerce_app/src/features/profile/presentation/profile_screen.dart';
import 'package:e_commerce_app/src/features/products/presentation/screens/product_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppTab { home, cart, favorites, profile }

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavigation(navigationShell: navigationShell);
        },
        branches: [
          // Branche Accueil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: AppTab.home.name,
                builder: (context, state) => const ProductsScreen(),
              ),
            ],
          ),
          // Branche Panier
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                name: AppTab.cart.name,
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          // Branche Favoris
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                name: AppTab.favorites.name,
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),
          // Branche Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: AppTab.profile.name,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Route top-level
      GoRoute(
        path: '/product/:id',
        name: 'product-detail',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
    ],
  );
});
