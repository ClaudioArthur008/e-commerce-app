import 'package:e_commerce_app/src/features/products/application/product_provider.dart';
import 'package:e_commerce_app/src/features/products/presentation/widgets/category_chip.dart'
    show kPrimaryOrange;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showSortBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _SortBottomSheet(),
  );
}

class _SortBottomSheet extends ConsumerWidget {
  const _SortBottomSheet();

  static const _labels = {
    SortOption.nameAsc: 'Nom (A → Z)',
    SortOption.nameDesc: 'Nom (Z → A)',
    SortOption.priceAsc: 'Prix croissant',
    SortOption.priceDesc: 'Prix décroissant',
  };

  static const _icons = {
    SortOption.nameAsc: Icons.sort_by_alpha_rounded,
    SortOption.nameDesc: Icons.sort_by_alpha_rounded,
    SortOption.priceAsc: Icons.trending_up_rounded,
    SortOption.priceDesc: Icons.trending_down_rounded,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(sortOptionProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Poignée ───
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ─── Titre ───
              Row(
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
                  const Text(
                    'Trier par',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ─── Options ───
              ..._labels.entries.map((entry) {
                final isSelected = entry.key == current;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _SortOptionTile(
                    icon: _icons[entry.key]!,
                    label: entry.value,
                    isSelected: isSelected,
                    onTap: () {
                      ref
                          .read(sortOptionProvider.notifier)
                          .setSortOption(entry.key);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOptionTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? kPrimaryOrange.withValues(alpha: 0.10)
                : const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? kPrimaryOrange.withValues(alpha: 0.4)
                  : Colors.grey.shade200,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              // Pastille icône
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? kPrimaryOrange.withValues(alpha: 0.18)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? kPrimaryOrange.withValues(alpha: 0.3)
                        : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: isSelected ? kPrimaryOrange : const Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(width: 12),

              // Libellé
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? kPrimaryOrange
                        : const Color(0xFF1F1F1F),
                  ),
                ),
              ),

              // Check
              AnimatedOpacity(
                opacity: isSelected ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: kPrimaryOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
