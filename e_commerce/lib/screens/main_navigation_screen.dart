import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),

          NavigationDestination(
            icon: _CartIcon(count: cart.totalItems),
            selectedIcon: _CartIcon(count: cart.totalItems, filled: true),
            label: 'Cart',
          ),

          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _CartIcon extends StatelessWidget {
  final int count;
  final bool filled;

  const _CartIcon({required this.count, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text(count > 99 ? '99+' : '$count'),
      child: Icon(filled ? Icons.shopping_cart : Icons.shopping_cart_outlined),
    );
  }
}
