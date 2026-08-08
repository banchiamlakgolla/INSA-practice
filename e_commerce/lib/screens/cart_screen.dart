import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
        actions: [
          if (cartProvider.cartProducts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                cartProvider.clearCart();
              },
            ),
        ],
      ),
      body: cartProvider.cartProducts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = cartProvider.cartProducts[index];

                      final quantity = cartProvider.getQuantity(product.id);

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Image.network(
                                product.image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      "\$${product.price}",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            cartProvider.decreaseQuantity(
                                              product,
                                            );
                                          },
                                          icon: const Icon(Icons.remove),
                                        ),

                                        Text(
                                          "$quantity",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        IconButton(
                                          onPressed: () {
                                            cartProvider.increaseQuantity(
                                              product,
                                            );
                                          },
                                          icon: const Icon(Icons.add),
                                        ),

                                        const Spacer(),

                                        IconButton(
                                          onPressed: () {
                                            cartProvider.removeFromCart(
                                              product,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "\$${cartProvider.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
