import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    // Loading
    if (productProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Error
    if (productProvider.errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('E-Commerce App'), centerTitle: true),
        body: Center(child: Text(productProvider.errorMessage)),
      );
    }

    final products = productProvider.products;

    // Get categories
    final categories = <String>[
      'All',
      ...products.map((product) => product.category).toSet().toList(),
    ];

    // Filter products
    final filteredProducts = products.where((product) {
      final searchText = searchController.text.toLowerCase();

      final matchesSearch = product.title.toLowerCase().contains(searchText);

      final matchesCategory =
          selectedCategory == 'All' || product.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      // App bar
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'E-Commerce App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // Body
      body: Column(
        children: [
          //search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),

            child: TextField(
              controller: searchController,

              onChanged: (_) {
                setState(() {});
              },

              decoration: InputDecoration(
                hintText: 'Search products...',

                prefixIcon: const Icon(Icons.search),

                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),

                        onPressed: () {
                          searchController.clear();

                          setState(() {});
                        },
                      )
                    : null,

                filled: true,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),

                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Category list
          SizedBox(
            height: 48,

            child: ListView.builder(
              scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.symmetric(horizontal: 12),

              itemCount: categories.length,

              itemBuilder: (context, index) {
                final category = categories[index];

                final isSelected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),

                  child: ChoiceChip(
                    label: Text(category),

                    selected: isSelected,

                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Product count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),

            child: Align(
              alignment: Alignment.centerLeft,

              child: Text(
                '${filteredProducts.length} products',

                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 5),

          // Products
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Text(
                      'No products found',

                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(10),

                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          childAspectRatio: 0.78,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),

                    itemCount: filteredProducts.length,

                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return ProductCard(product: product);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
