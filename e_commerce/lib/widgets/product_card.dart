import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          ),
        );
      },

      child: Card(
        elevation: 2,

        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        clipBehavior: Clip.antiAlias,

        child: Padding(
          padding: const EdgeInsets.all(8),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Image
              Expanded(
                flex: 5,

                child: Center(
                  child: Image.network(
                    product.image,

                    width: double.infinity,

                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              //Pro title
              Text(
                product.title,

                maxLines: 2,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 13,

                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              // Price
              Text(
                '\$${product.price.toStringAsFixed(2)}',

                style: const TextStyle(
                  fontSize: 16,

                  fontWeight: FontWeight.bold,

                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 3),

              // Rating
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),

                  const SizedBox(width: 3),

                  Text(
                    product.rating.toString(),

                    style: const TextStyle(fontSize: 12),
                  ),

                  const SizedBox(width: 3),

                  Text(
                    '(${product.ratingCount})',

                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),

              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
