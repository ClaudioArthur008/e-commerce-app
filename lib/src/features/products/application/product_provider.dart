import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';
import '../domain/product_model.dart';

enum SortOption { nameAsc, nameDesc, priceAsc, priceDesc }

class SelectedCategoryNotifier extends Notifier<Category?> {
  @override
  Category? build() => null;

  void select(Category? category) {
    if (state?.id == category?.id) {
      state = null;
    } else {
      state = category;
    }
  }

  void set(Category? category) => state = category;

  void clear() => state = null;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, Category?>(
      SelectedCategoryNotifier.new,
    );

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;

  void clear() => state = '';
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

class SortOptionNotifier extends Notifier<SortOption> {
  @override
  SortOption build() => SortOption.nameAsc;

  void setSortOption(SortOption option) => state = option;
}

final sortOptionProvider = NotifierProvider<SortOptionNotifier, SortOption>(
  SortOptionNotifier.new,
);

final categoriesProvider = Provider<List<Category>>((ref) {
  return mockCategories;
});

final productsProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return mockProducts;
});

final productByIdProvider = FutureProvider.family<Product, String>((
  ref,
  id,
) async {
  final products = await ref.watch(productsProvider.future);
  final product = products.firstWhere((p) => p.id == id);
  return product;
});

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final allProducts = ref.watch(productsProvider).value ?? [];
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final sortOption = ref.watch(sortOptionProvider);

  // Filtrage
  var filtered = allProducts.where((product) {
    final categoryMatch =
        selectedCategory == null || product.category == selectedCategory.name;
    final searchMatch =
        query.isEmpty || product.name.toLowerCase().contains(query);
    return categoryMatch && searchMatch;
  }).toList();

  // Tri
  switch (sortOption) {
    case SortOption.nameAsc:
      filtered.sort((a, b) => a.name.compareTo(b.name));
      break;
    case SortOption.nameDesc:
      filtered.sort((a, b) => b.name.compareTo(a.name));
      break;
    case SortOption.priceAsc:
      filtered.sort((a, b) => a.price.compareTo(b.price));
      break;
    case SortOption.priceDesc:
      filtered.sort((a, b) => b.price.compareTo(a.price));
      break;
  }

  return filtered;
});
