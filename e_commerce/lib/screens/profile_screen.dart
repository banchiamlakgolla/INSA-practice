import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();

  User? user;

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final users = await _apiService.getUsers();

      if (!mounted) return;

      if (users.isNotEmpty) {
        setState(() {
          user = users.first;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No user found.';
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to load profile.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Profile'), centerTitle: true),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 50),
              const SizedBox(height: 12),
              Text(errorMessage),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = '';
                  });

                  loadUser();
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),

            child: Column(
              children: [
                // PROFILE HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),

                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,

                        child: Icon(Icons.person, size: 55),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        '${user!.firstName} ${user!.lastName}',
                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        '@${user!.username}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ACCOUNT INFORMATION
                const Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    'Account Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 12),

                _buildInfoCard(
                  context,
                  Icons.email_outlined,
                  'Email',
                  user!.email,
                ),

                _buildInfoCard(
                  context,
                  Icons.phone_outlined,
                  'Phone',
                  user!.phone,
                ),

                _buildInfoCard(
                  context,
                  Icons.location_city_outlined,
                  'City',
                  user!.city,
                ),

                _buildInfoCard(
                  context,
                  Icons.home_outlined,
                  'Address',
                  '${user!.street}, ${user!.zipcode}',
                ),

                const SizedBox(height: 10),

                // USER ID
                Text(
                  'User ID: ${user!.id}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,

                borderRadius: BorderRadius.circular(14),
              ),

              child: Icon(icon),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
