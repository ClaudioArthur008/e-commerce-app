import 'package:e_commerce_app/src/features/products/application/product_provider.dart';
import 'package:e_commerce_app/src/features/products/domain/product_model.dart';
import 'package:e_commerce_app/src/features/products/presentation/widgets/category_chip.dart'
    show kPrimaryOrange;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showCategoryFilterBottomSheet(
  BuildContext context, {
  required List<Category> categories,
}) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CategoryFilterBottomSheet(categories: categories),
  );
}

class CategoryFilterBottomSheet extends ConsumerStatefulWidget {
  final List<Category> categories;

  const CategoryFilterBottomSheet({super.key, required this.categories});

  @override
  ConsumerState<CategoryFilterBottomSheet> createState() =>
      _CategoryFilterBottomSheetState();
}

class _CategoryFilterBottomSheetState
    extends ConsumerState<CategoryFilterBottomSheet> {
  Category? _pendingSelection;

  @override
  void initState() {
    super.initState();
    _pendingSelection = ref.read(selectedCategoryProvider);
  }

  int _resolveCrossAxisCount(int count) {
    if (count <= 2) return 2;
    if (count <= 6) return 3;
    return 4;
  }

  bool get _hasSelection => _pendingSelection != null;

  void _clearSelection() {
    setState(() => _pendingSelection = null);
  }

  @override
  Widget build(BuildContext context) {
    // +1 pour la carte "Tout"
    final totalCards = widget.categories.length + 1;
    final crossAxisCount = _resolveCrossAxisCount(totalCards);

    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // ─── Poignée ───
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // ─── Header ───
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 16,
                      decoration: BoxDecoration(
                        color: kPrimaryOrange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Filtrer par catégorie',
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F1F1F),
                        ),
                      ),
                    ),
                    if (_hasSelection)
                      TextButton(
                        onPressed: _clearSelection,
                        style: TextButton.styleFrom(
                          foregroundColor: kPrimaryOrange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Réinitialiser',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      color: const Color(0xFF1F1F1F),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // ─── Grille ───
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: totalCards,
                  itemBuilder: (context, index) {
                    // Carte "Tout" en premier
                    if (index == 0) {
                      return _AllCategoriesCard(
                        isSelected: !_hasSelection,
                        onTap: _clearSelection,
                      );
                    }
                    final category = widget.categories[index - 1];
                    final isSelected = category.id == _pendingSelection?.id;
                    return _CategoryGridCard(
                      category: category,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _pendingSelection = isSelected ? null : category;
                        });
                      },
                    );
                  },
                ),
              ),

              // ─── CTA ───
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey.shade200,
                        disabledForegroundColor: Colors.grey.shade500,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        ref
                            .read(selectedCategoryProvider.notifier)
                            .set(_pendingSelection);
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            _hasSelection
                                ? 'Appliquer le filtre'
                                : 'Afficher tout',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AllCategoriesCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _AllCategoriesCard({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _BaseCategoryCard(
      isSelected: isSelected,
      onTap: onTap,
      label: 'Tout',
      child: Icon(
        Icons.apps_rounded,
        size: 20,
        color: isSelected ? Colors.white : const Color(0xFF1F1F1F),
      ),
    );
  }
}

class _CategoryGridCard extends StatefulWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryGridCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryGridCard> createState() => _CategoryGridCardState();
}

class _CategoryGridCardState extends State<_CategoryGridCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: _BaseCategoryCard(
          isSelected: widget.isSelected,
          label: widget.category.name,
          child: _CategoryVisual(
            category: widget.category,
            isSelected: widget.isSelected,
          ),
        ),
      ),
    );
  }
}

class _BaseCategoryCard extends StatelessWidget {
  final bool isSelected;
  final String label;
  final Widget child;
  final VoidCallback? onTap;

  const _BaseCategoryCard({
    required this.isSelected,
    required this.label,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? kPrimaryOrange.withValues(alpha: 0.10)
                  : const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? kPrimaryOrange.withValues(alpha: 0.6)
                    : Colors.grey.shade200,
                width: isSelected ? 1.6 : 1.2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Conteneur visuel
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryOrange : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? kPrimaryOrange : Colors.grey.shade200,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: kPrimaryOrange.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(child: child),
                ),
                const SizedBox(height: 8),

                // Nom
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? kPrimaryOrange
                        : const Color(0xFF1F1F1F),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Badge check en haut à droite
        Positioned(
          top: -2,
          right: -2,
          child: AnimatedScale(
            scale: isSelected ? 1 : 0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutBack,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: kPrimaryOrange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryOrange.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Visuel de catégorie (image ou icône)
// ─────────────────────────────────────────────
class _CategoryVisual extends StatelessWidget {
  final Category category;
  final bool isSelected;

  const _CategoryVisual({required this.category, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    const size = 22.0;

    if (category.imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          category.imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, a, b) => Icon(
            Icons.category_rounded,
            size: size,
            color: isSelected ? Colors.white : const Color(0xFF1F1F1F),
          ),
        ),
      );
    }

    return Icon(
      Icons.category_rounded,
      size: size,
      color: isSelected ? Colors.white : const Color(0xFF1F1F1F),
    );
  }
}
