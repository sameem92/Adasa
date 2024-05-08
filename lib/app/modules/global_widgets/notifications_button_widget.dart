import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../root/controllers/root_controller.dart';

class NotificationsButtonWidget extends GetView<RootController> {
  const NotificationsButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: GestureDetector(
        // hoverElevation: 0,
        // // minWidth: ,
        //
        // highlightElevation: 0,
        // elevation: 0,
        onTap: () {
          if (Get.find<AuthService>().isAuth == true) {
            Get.toNamed(Routes.NOTIFICATIONS);
          } else {
            Get.toNamed(Routes.LOGIN);
          }
        },
        // color: Colors.transparent,
        child:
        Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Icon(
              Icons.notifications_active_outlined,
              color: iconColor ?? Get.theme.hintColor,
              size: 28,
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child:
              Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: labelColor ?? Get.theme.colorScheme.secondary,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                constraints: const BoxConstraints(
                    minWidth: 16, maxWidth: 16, minHeight: 16, maxHeight: 16),
                child:

                Obx(() {
                  return Center(
                    child: Text(
                      controller.notificationsCount.value.toString(),
                      textAlign: TextAlign.center,
                      style: Get.textTheme.caption.merge(
                        TextStyle(
                            color: Get.theme.primaryColor,
                            fontSize: 9,
                            height: 1.4),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class SearchButtonWidget extends GetView<RootController> {
  const SearchButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(

      onPressed: () {
        Get.toNamed(Routes.SEARCH);
      },
      color: Colors.transparent,
      icon:  Icon(
        Icons.search,
        color: iconColor ?? Get.theme.hintColor,
        size: 28,
      ),
    );
  }
}


class FavouriteButtonWidget extends GetView<RootController> {
  const FavouriteButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(

      onPressed: () {
        Get.toNamed(Routes.FAVORITES);
      },
      color: Colors.transparent,
      icon:  Icon(
        Icons.favorite_border,
        color: iconColor ?? Get.theme.hintColor,
        size: 28,
      ),
    );
  }
}