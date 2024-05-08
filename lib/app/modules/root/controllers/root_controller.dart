
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/custom_page_model.dart';
import '../../../repositories/custom_page_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../bookings/views/bookings_view.dart';
import '../../favorites/views/favorites_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home2_view.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/views/messages_view.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/views/profile_view.dart';

class RootController extends GetxController {
  final currentIndex = 1.obs;
  final notificationsCount = 0.obs;
  final customPages = <CustomPage>[].obs;
  NotificationRepository _notificationRepository;
  CustomPageRepository _customPageRepository;

  RootController() {
    _notificationRepository = NotificationRepository();
    _customPageRepository = CustomPageRepository();
  }
  ProfileController  controllerProfile = Get.put(ProfileController());

  @override
  void onInit() async {

    super.onInit();
    await getCustomPages();

    // Get.lazyPut(()=>FavoritesController());
  }

  List<Widget> pages = [
    ProfileView(),
    Home2View(),
    BookingsView(),

    // MessagesView(),


  ];

  Widget get currentPage => pages[currentIndex.value];

  /// change page in route
  ///
  Future<void> changePageInRoot(int index) async {
    if (!Get.find<AuthService>().isAuth && index > 1 || !Get.find<AuthService>().isAuth && index < 1) {
      await Get.toNamed(Routes.LOGIN);
    } else {
      currentIndex.value = index;
      await refreshPage(index);
    }
  }

  Future<void> changePageOutRoot(int index) async {
    if (!Get.find<AuthService>().isAuth && index > 1 || !Get.find<AuthService>().isAuth && index < 1) {
      await Get.toNamed(Routes.LOGIN);
    }
    currentIndex.value = index;
    await refreshPage(index);
    await Get.offNamedUntil(Routes.ROOT, (Route route) {
      if (route.settings.name == Routes.ROOT) {
        return true;
      }
      return false;
    }, arguments: index);
  }

  Future<void> changePage(int index) async {

    if (Get.currentRoute == Routes.ROOT) {
      await changePageInRoot(index);
    } else {
      await changePageOutRoot(index);
    }
  }

  Future<void> refreshPage(int index) async {
    switch (index) {
      case 0:
        {
          await Get.find<ProfileController>().refreshProfile();
          // await Get.find<BookingsController>().refreshBookings();

          break;
        }
      case 1:
        {
          await Get.find<HomeController>().refreshHome();

          break;
        }
      case 2:
        {
          await Get.find<BookingsController>().refreshBookings();

          // await Get.find<MessagesController>().refreshMessages();
          break;
        }
    }
  }

  void getNotificationsCount() async {
    notificationsCount.value = await _notificationRepository.getCount();
  }

  Future<void> getCustomPages() async {
    customPages.assignAll(await _customPageRepository.all());
  }
}
