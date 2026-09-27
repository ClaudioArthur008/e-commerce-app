import 'package:e_commerce_app/src/features/cart/application/cart_provider.dart';
import 'package:e_commerce_app/src/features/favorites/application/favorites_provider.dart';
import 'package:e_commerce_app/src/features/products/application/product_provider.dart';
import 'package:e_commerce_app/src/features/products/domain/product_model.dart';
import 'package:e_commerce_app/src/features/products/presentation/widgets/category_chip.dart';
import 'package:e_commerce_app/src/features/products/presentation/widgets/filter_bottom_sheet.dart';
import 'package:e_commerce_app/src/features/products/presentation/widgets/header.dart';
import 'package:e_commerce_app/src/features/products/presentation/widgets/product_card.dart';
import 'package:e_commerce_app/src/features/products/presentation/widgets/product_carrousel.dart';
import 'package:e_commerce_app/src/features/products/presentation/widgets/search_bar.dart';
import 'package:e_commerce_app/src/features/products/presentation/widgets/sort_bottom_sheet.dart';
import 'package:e_commerce_app/src/features/profile/application/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final categories = ref.watch(categoriesProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);

    void onSearchChanged(String value) {
      ref.read(searchQueryProvider.notifier).setQuery(value);
    }

    void onProductTap(Product product) => context.goNamed(
      'product-detail',
      pathParameters: {'id': product.id},
      extra: product,
    );

    void onAddToCart(Product product) =>
        ref.read(cartProvider.notifier).addItem(product);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            Header(user: user),
            const SizedBox(height: 20),
            CustomSearchBar(onChanged: onSearchChanged),
            const SizedBox(height: 22),
            _SectionHeader(
              title: 'Catégories',
              onActionTap: () => showCategoryFilterBottomSheet(
                context,
                categories: categories,
              ),
            ),
            const SizedBox(height: 12),
            CategorySelector(categories: categories),
            const SizedBox(height: 22),
            FeaturedProductsCarousel(
              products: filteredProducts.take(5).toList(),
              onTap: onProductTap,
              onAddToCart: onAddToCart,
            ),
            const SizedBox(height: 22),
            _SectionHeader(
              title: 'Tous les produits',
              subtitle: '${filteredProducts.length} articles',
              showAction: true,
              actionLabel: 'Trier ',
              actionIcon: Icons.tune_rounded,
              onActionTap: () => showSortBottomSheet(context),
            ),
            const SizedBox(height: 12),
            if (filteredProducts.isEmpty)
              const _EmptyProductsState()
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  final isFavorite = ref
                      .watch(favoritesProvider)
                      .contains(product.id);

                  return ProductCard(
                    product: product,
                    onTap: () => onProductTap(product),
                    onAddToCart: () => onAddToCart(product),
                    isFavorite: isFavorite,
                    onToggleFavorite: () => ref
                        .read(favoritesProvider.notifier)
                        .toggleFavorite(product.id),
                  );
                },
              ),
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showAction;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback? onActionTap;

  const _SectionHeader({
    required this.title,
    this.subtitle,
    this.showAction = true,
    this.actionLabel = 'Voir tout',
    this.actionIcon = Icons.chevron_right_rounded,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                color: Color(0xFF303030),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ],
        ),
        if (showAction)
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onActionTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionLabel,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(actionIcon, color: Colors.grey.shade600, size: 18),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Aucun produit trouvé',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
