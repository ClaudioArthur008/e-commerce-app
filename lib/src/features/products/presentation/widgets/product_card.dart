import 'package:e_commerce_app/src/features/products/domain/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const ProductCard({
    super.key,
    required this.product,
    this.onAddToCart,
    this.onTap,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: 'product-${widget.product.id}',
                          child: Image.network(
                            widget.product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, a, b) => Container(
                              color: Colors.grey.shade100,
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.grey.shade400,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Dégradé bas pour lisibilité si besoin
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.03),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Bouton favori (coin haut droit)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Material(
                          color: Colors.white.withValues(alpha: 0.95),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: widget.onToggleFavorite,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                widget.isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 16,
                                color: widget.isFavorite
                                    ? Colors.red.shade400
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Informations du produit
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F1F1F),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),

                      Text(
                        widget.product.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Prix + bouton panier
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                    text: r'$',
                                    style: TextStyle(
                                      color: Colors.orange.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.product.price.toStringAsFixed(
                                      2,
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFF1F1F1F),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _AddToCartButton(onTap: widget.onAddToCart),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddToCartButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.add_shopping_cart_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
