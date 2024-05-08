import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:producer_family_app/screens/navigation_botton_screens/user_home_screen/home/user_home_screen.dart';
// import 'package:producer_family_app/screens/navigation_botton_screens/user_home_screen/orders/order_screen.dart';
// import 'package:producer_family_app/screens/public_screens/notification_screen.dart';
// import 'package:producer_family_app/screens/public_screens/profile_screen.dart';
// import 'package:producer_family_app/storage/providersAndGetx/cart_getx_controller.dart';
// import 'package:producer_family_app/storage/shared_preferences_controller.dart';
// import 'package:producer_family_app/style/size_config.dart';
// import 'package:producer_family_app/style/style_colors.dart';
// import 'package:producer_family_app/style/style_text.dart';
//
// import '../../../storage/providersAndGetx/home_getx.dart';
// import '../../public_screens/map_screen.dart';
// import 'login_screens/login_screen.dart';
import '../../global_widgets/custom_bottom_nav_bar.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: controller.currentPage,
        bottomNavigationBar:
        CurvedNavigationBar(
animationCurve: Curves.easeInOut,
          backgroundColor: context.theme.colorScheme.secondary,
          color: Colors.white,
          onTap: (index) {
            controller.changePage(index);
          },
          animationDuration: const Duration(milliseconds: 450),
          index: controller.currentIndex.value,
          items: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon( Icons.account_circle_outlined,color:context.theme.colorScheme.secondary ,),

                Text('حسابي',style: TextStyle(color: Get.theme.colorScheme.secondary),)
              ],
            ),
          CircleAvatar(
            foregroundImage: const AssetImage(
              'assets/icon/adasa trans.png',),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
            radius: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined,color:context.theme.colorScheme.secondary),
                Text('طلباتي',style: TextStyle(color: Get.theme.colorScheme.secondary),)
              ],
            ),



          ],
        )

    //     CustomBottomNavigationBar(
    //       backgroundColor: context.theme.scaffoldBackgroundColor,
    //       itemColor: context.theme.colorScheme.secondary,
    //
    //       currentIndex: controller.currentIndex.value,
    //       onChange: (index) {
    //         controller.changePage(index);
    //       },
    //       children: [
    //         CustomBottomNavigationItem(
    //           icon: Icons.account_circle_outlined,
    //           label: "حسابي",boolLogoHome: false,
    //         ),
    //         CustomBottomNavigationItem(
    //           icon: Icons.home_outlined,boolLogoHome: true,
    //           label: "عدسة",
    //         ),
    //         CustomBottomNavigationItem(
    //           icon: Icons.assignment_outlined,
    //           label: "طلباتي",
    //           boolLogoHome: false,
    //
    //         ),
    // ],
    //     ),
      );
    });
  }
}
