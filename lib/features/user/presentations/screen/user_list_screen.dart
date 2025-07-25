import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_provider.dart';

// Change from ConsumerWidget to ConsumerStatefulWidget
class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

// Update the State class to ConsumerState
class _UserListScreenState extends ConsumerState<UserListScreen> {

  @override
  void initState() {
    super.initState();
    // This line is the key! It calls fetchUsers when the widget is first initialized.
    // Use `WidgetsBinding.instance.addPostFrameCallback` to ensure the context is ready,
    // though for simple `read` calls, it's often not strictly necessary but good practice.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userNotifierProvider.notifier).fetchUsers(count: 5);
    });
  }

  @override
  Widget build(BuildContext context) { // build method no longer takes WidgetRef directly
    // Watch the state from the userNotifierProvider
    final userState = ref.watch(userNotifierProvider);
    // Get the notifier to call methods
    final userNotifier = ref.read(userNotifierProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Random Users',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            // The refresh button should still work
            onPressed: userState.isLoading ? null : () => userNotifier.fetchUsers(count: 5),
            tooltip: 'Refresh Users',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0E0E0), Color(0xFFF5F5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _buildBody(userState, userNotifier, context), // Pass context here if needed in _buildBody
      ),
    );
  }

  // Extracted build logic into a helper method
  Widget _buildBody(UserState userState, UserNotifier userNotifier, BuildContext context) {
    if (userState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: AppBar().preferredSize.height + 40),
            _buildLoadingIndicator(),
            const SizedBox(height: 20),
            Text(
              'Fetching awesome users...',
              style: TextStyle(fontSize: 18, color: Colors.blueGrey.shade700),
            ),
          ],
        ),
      );
    } else if (userState.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: AppBar().preferredSize.height + 40),
              Icon(Icons.cloud_off, color: Colors.red.shade400, size: 80),
              const SizedBox(height: 24),
              Text(
                'Oops! Something went wrong:\n${userState.errorMessage}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.red.shade700, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => userNotifier.fetchUsers(count: 5),
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  shadowColor: Colors.deepPurple.shade900.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: AppBar().preferredSize.height + 20),
        child: ListView.builder(
          itemCount: userState.users.length,
          itemBuilder: (context, index) {
            final user = userState.users[index];
            return AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: 1.0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.6),
                      blurRadius: 4,
                      offset: const Offset(-2, -2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade200, width: 0.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tapped on ${user.firstName} ${user.lastName}')),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(3, 3),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.deepPurple.shade100,
                                foregroundImage: NetworkImage(user.largePicture),
                                onForegroundImageError: (exception, stackTrace) {
                                  debugPrint('Error loading large image: $exception');
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.title} ${user.firstName} ${user.lastName}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${user.streetNumber} ${user.streetName},\n${user.city}, ${user.country}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Age: ${user.age}',
                                    style: TextStyle(
                                      color: Colors.blueGrey.shade700,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.shade200.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: CircularProgressIndicator(
        strokeWidth: 6,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple.shade700),
        backgroundColor: Colors.deepPurple.shade100,
      ),
    );
  }
}