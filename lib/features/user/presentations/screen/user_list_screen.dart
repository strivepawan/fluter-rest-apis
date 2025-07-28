import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/theme/custom_themes/text_Theme.dart';
import '../../../../utils/theme/widget_themes/appbar_theme.dart';
import '../providers/user_provider.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userNotifierProvider.notifier).fetchUsers(count: 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);
    final userNotifier = ref.read(userNotifierProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Random Users',
          style: TtextTheme.lightTextTheme.headlineSmall,
        ),
        centerTitle: true,
        backgroundColor: TAppBarTheme.lightAppBarTheme.backgroundColor,
        elevation: TAppBarTheme.lightAppBarTheme.elevation,
        iconTheme: TAppBarTheme.lightAppBarTheme.iconTheme,
        actionsIconTheme: TAppBarTheme.lightAppBarTheme.actionsIconTheme,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: userState.isLoading ? null : () => userNotifier.fetchUsers(count: 5),
            tooltip: 'Refresh Users',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [TColors.lightGrey, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _buildBody(userState, userNotifier, context),
      ),
    );
  }

  Widget _buildBody(UserState userState, UserNotifier userNotifier, BuildContext context) {
    if (userState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: AppBar().preferredSize.height + TSizes.spaceBtwSections),
            _buildLoadingIndicator(),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              'Fetching awesome users...',
              style: TtextTheme.lightTextTheme.bodyLarge,
            ),
          ],
        ),
      );
    } else if (userState.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: AppBar().preferredSize.height + TSizes.spaceBtwSections),
              Icon(Icons.cloud_off, color: Colors.red.shade400, size: TSizes.iconLg * 2),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                'Oops! Something went wrong:\n${userState.errorMessage}',
                textAlign: TextAlign.center,
                style: TtextTheme.lightTextTheme.bodyLarge?.copyWith(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              ElevatedButton.icon(
                onPressed: () => userNotifier.fetchUsers(count: 5),
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.buttonWidth,
                    vertical: TSizes.buttonHeight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: AppBar().preferredSize.height + TSizes.spaceBtwSections),
        child: ListView.builder(
          itemCount: userState.users.length,
          itemBuilder: (context, index) {
            final user = userState.users[index];
            return AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: 1.0,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: TSizes.spaceBtwSections,
                  vertical: TSizes.spaceBtwItems,
                ),
                decoration: BoxDecoration(
                  color: TColors.light,
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
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
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tapped on ${user.firstName} ${user.lastName}')),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(TSizes.defaultSpace),
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
                                backgroundColor: TColors.primary.withOpacity(0.1),
                                foregroundImage: NetworkImage(user.largePicture),
                                onForegroundImageError: (exception, stackTrace) {
                                  debugPrint('Error loading image: $exception');
                                },
                              ),
                            ),
                            const SizedBox(width: TSizes.spaceBtwItems),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.title} ${user.firstName} ${user.lastName}',
                                    style: TtextTheme.lightTextTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    user.email,
                                    style: TtextTheme.lightTextTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${user.streetNumber} ${user.streetName},\n${user.city}, ${user.country}',
                                    style: TtextTheme.lightTextTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Age: ${user.age}',
                                    style: TtextTheme.lightTextTheme.bodyMedium?.copyWith(
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
            color: TColors.primary.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: CircularProgressIndicator(
        strokeWidth: 6,
        valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
        backgroundColor: TColors.primary.withOpacity(0.2),
      ),
    );
  }
}
