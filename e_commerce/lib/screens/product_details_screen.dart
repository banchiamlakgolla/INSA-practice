import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details"), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Pro Image
            Center(child: Image.network(product.image, height: 250)),

            const SizedBox(height: 20),

            // PPro title
            Text(
              product.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // price
            Text(
              "\$${product.price}",
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 73, 156, 76),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // CATEGORY
            Chip(label: Text(product.category)),

            const SizedBox(height: 10),

            // RATING
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),

                const SizedBox(width: 5),

                Text("${product.rating} (${product.ratingCount} reviews)"),
              ],
            ),

            const SizedBox(height: 20),

            // DESCRIPTION TITLE
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // DESCRIPTION
            Text(product.description),

            const SizedBox(height: 30),

            // ADD TO CART BUTTON
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () async {
                  await context.read<CartProvider>().addToCart(product);

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Product added to cart")),
                  );
                },

                child: const Text("Add To Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
