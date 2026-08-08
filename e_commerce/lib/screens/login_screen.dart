import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );

      return;
    }

    try {
      await context.read<AuthProvider>().login(username, password);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),

                child: Card(
                  elevation: 10,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(32),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        // LOGO
                        Container(
                          width: 80,
                          height: 80,

                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,

                            shape: BoxShape.circle,
                          ),

                          child: Icon(
                            Icons.shopping_bag_rounded,
                            size: 42,

                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // TITLE
                        const Text(
                          'Welcome Back!',
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Sign in to continue shopping',
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // USERNAME
                        TextField(
                          controller: usernameController,

                          decoration: InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter your username',

                            prefixIcon: const Icon(Icons.person_outline),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // PASSWORD
                        TextField(
                          controller: passwordController,

                          obscureText: obscurePassword,

                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',

                            prefixIcon: const Icon(Icons.lock_outline),

                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },

                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // LOGIN BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 52,

                          child: ElevatedButton(
                            onPressed: authProvider.isLoading ? null : login,

                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),

                            child: authProvider.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,

                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        Text(
                          'Your account is securely connected to the API',
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
