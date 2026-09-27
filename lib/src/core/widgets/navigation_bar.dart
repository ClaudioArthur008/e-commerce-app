import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomNavigation extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavigation({super.key, required this.navigationShell});

  @override
  ConsumerState<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation> {
  final List<Map<String, dynamic>> _tabs = const [
    {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Accueil'},
    {
      'icon': Icons.shopping_cart_outlined,
      'activeIcon': Icons.shopping_cart,
      'label': 'Panier',
    },
    {
      'icon': Icons.favorite_border,
      'activeIcon': Icons.favorite,
      'label': 'Favoris',
    },
    {
      'icon': Icons.person_outline,
      'activeIcon': Icons.person,
      'label': 'Profil',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: KeyedSubtree(
          key: ValueKey<int>(currentIndex),
          child: widget.navigationShell,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_tabs.length, (index) {
                    final isSelected = currentIndex == index;
                    final tab = _tabs[index];

                    return _buildNavItem(
                      icon: isSelected ? tab['activeIcon'] : tab['icon'],
                      isSelected: isSelected,
                      onTap: () => _onTabTapped(index),
                    );
                  }),
                ),
              ),

              const SizedBox(width: 14),

              _buildSearchButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        width: 54,
        height: 54,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.grey.shade100 : Colors.transparent,
        ),
        child: AnimatedScale(
          scale: isSelected ? 1.12 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: Icon(
              icon,
              key: ValueKey<IconData>(icon),
              size: 24,
              color: isSelected ? Colors.black : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Material(
      color: Colors.black,
      elevation: 6,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: _showSearchMenu,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 58,
          height: 58,
          child: Icon(Icons.search, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  void _showSearchMenu() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return const SizedBox(
          height: 250,
          child: Center(child: Text('Menu de recherche')),
        );
      },
    );
  }
}
