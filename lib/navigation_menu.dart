import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for SystemNavigator.pop
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'features/account/presentations/screen/account_screen.dart';
import 'features/offers/presentations/screen/offers_screen.dart';
import 'features/search/presentations/screen/search_screen.dart';
import 'features/user/presentations/screen/user_list_screen.dart';
import 'utils/constants/colors.dart';
import 'utils/helpers/helper_functions.dart';





class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(NavigationController());

    return WillPopScope(
      onWillPop: () async {
        return controller.handleBackPressed();
      },
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => NavigationBar(
            backgroundColor: dark ? TColors.black : Colors.white,
            indicatorColor: dark
                ? TColors.white.withOpacity(0.1)
                : TColors.black.withOpacity(0.1),
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(
                icon: Icon(Iconsax.shop),
                label: 'Shop',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.search_normal),
                label: 'Search',
              ),
              NavigationDestination(
                icon: Icon(Icons.local_offer_outlined),
                label: 'Offers',
              ),
              // NavigationDestination(
              //   icon: Icon(CupertinoIcons.list_dash),
              //   label: 'Explore',
              // ),
              NavigationDestination(
                icon: Icon(Iconsax.user),
                label: 'Account',
              ),
            ],
          ),
        ),
        body: Obx(
          () => controller.screens[controller.selectedIndex.value],
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  Rx<int> selectedIndex = 0.obs;
  DateTime? currentBackPressTime;

  final screens = [
    const UserListScreen(),
     const SearchScreen(),
     const OffersScreen(),
 const AccountScreen(),  ];

  Future<bool> handleBackPressed() async {
    DateTime now = DateTime.now();
    if (selectedIndex.value != 0) {
      selectedIndex.value = 0;
      return Future.value(false);
    } else if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Get.snackbar("Tripund", "Press back again to exit");
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }
}
// 
