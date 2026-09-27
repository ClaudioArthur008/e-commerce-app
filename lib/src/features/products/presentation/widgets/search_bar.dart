import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterPressed;
  final String hintText;

  const CustomSearchBar({
    super.key,
    required this.onChanged,
    this.onFilterPressed,
    this.hintText = 'Rechercher un produit...',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Champ de recherche principal
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              onChanged: onChanged,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 18, right: 10),
                  child: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade700,
                    size: 22,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Bouton de filtre noir
        GestureDetector(
          onTap: onFilterPressed,
          child: Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
