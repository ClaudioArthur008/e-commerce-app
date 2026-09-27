import 'package:e_commerce_app/src/features/cart/application/cart_provider.dart';
import 'package:e_commerce_app/src/features/favorites/application/favorites_provider.dart';
import 'package:e_commerce_app/src/features/products/application/product_provider.dart';
import 'package:e_commerce_app/src/features/products/presentation/widgets/category_chip.dart'
    show kPrimaryOrange;
import 'package:e_commerce_app/src/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesIds = ref.watch(favoritesProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: productsAsync.when(
          data: (allProducts) {
            final favorites = allProducts
                .where((p) => favoritesIds.contains(p.id))
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Header ───
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mes favoris',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1F1F1F),
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Vos produits préférés, à portée de main',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.5,
                                color: Color(0xFF8A8A8A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (favorites.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryOrange.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${favorites.length}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryOrange,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ─── Liste ───
                Expanded(
                  child: favorites.isEmpty
                      ? const _EmptyFavoritesState()
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                          itemCount: favorites.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 0.68,
                              ),
                          itemBuilder: (context, index) {
                            final product = favorites[index];
                            return ProductCard(
                              product: product,
                              isFavorite: true, // écran favoris → toujours vrai
                              onTap: () => context.goNamed(
                                'product-detail',
                                pathParameters: {'id': product.id},
                                extra: product,
                              ),
                              onAddToCart: () => ref
                                  .read(cartProvider.notifier)
                                  .addItem(product),
                              onToggleFavorite: () => ref
                                  .read(favoritesProvider.notifier)
                                  .toggleFavorite(product.id),
                            );
                          },
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => _ErrorState(message: '$err'),
        ),
      ),
    );
  }
}

class _EmptyFavoritesState extends StatelessWidget {
  const _EmptyFavoritesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: kPrimaryOrange.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 40,
                color: kPrimaryOrange,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Aucun favori pour le moment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Ajoutez des produits à vos favoris en appuyant sur le cœur.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                height: 1.5,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            const Text(
              'Une erreur est survenue',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F1F1F),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey.shade500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
