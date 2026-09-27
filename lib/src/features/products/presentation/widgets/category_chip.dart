import 'package:e_commerce_app/src/features/products/domain/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const kPrimaryOrange = Color(0xFFFF5A1F);

class CategoryChip extends StatelessWidget {
  final Category value;
  final bool selected;
  final ValueChanged<Category>? onSelected;

  const CategoryChip({
    super.key,
    required this.value,
    this.selected = false,
    this.onSelected,
  });

  IconData _iconForCategory(String name) {
    switch (name.toLowerCase()) {
      case 'nourriture':
        return Icons.restaurant_rounded;
      case 'groceries':
      case 'épicerie':
        return Icons.local_grocery_store_rounded;
      case 'stores':
      case 'magasins':
        return Icons.storefront_rounded;
      case 'pharmacy':
      case 'pharmacie':
        return Icons.local_pharmacy_rounded;
      case 'drinks':
      case 'boissons':
        return Icons.local_bar_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected?.call(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.only(left: 6, right: 18, top: 6, bottom: 6),
        decoration: BoxDecoration(
          color: selected ? kPrimaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: selected ? kPrimaryOrange : Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: selected
                  ? Colors.white.withValues(alpha: 0.25)
                  : Colors.grey.shade100,
              child: Icon(
                _iconForCategory(value.name),
                size: 16,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value.name,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, Category?>(
      SelectedCategoryNotifier.new,
    );

class SelectedCategoryNotifier extends Notifier<Category?> {
  @override
  Category? build() => null;

  void selectCategory(Category category) {
    state = state?.id == category.id ? null : category;
  }
}

class CategorySelector extends ConsumerWidget {
  final List<Category> categories;

  const CategorySelector({super.key, required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory?.id == category.id;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CategoryChip(
              value: category,
              selected: isSelected,
              onSelected: (cat) {
                ref.read(selectedCategoryProvider.notifier).selectCategory(cat);
              },
            ),
          );
        },
      ),
    );
  }
}
