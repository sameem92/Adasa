import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/booking_notification_item_widget.dart';
import '../widgets/message_notification_item_widget.dart';
import '../widgets/notification_item_widget.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "إشعارات",
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color:  Get.theme.colorScheme.secondary),
          onPressed: () => {Get.back()},
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          await controller.refreshNotifications(showMessage: true);
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: ListView(
          primary: true,
          children: <Widget>[
            // Text("Incoming Notifications".tr, style: Get.textTheme.headline5)
            //     .paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
            // Text("اسحب العنصر لليساد لحذفه".tr, style: Get.textTheme.caption)
            //     .paddingSymmetric(horizontal: 22, vertical: 5),
            notificationsList(),
          ],
        ),
      ),
    );
  }

  Widget notificationsList() {
    return Obx(() {
      if (!controller.notifications.isNotEmpty) {
        return  CircularLoadingWidget(
          height: 600,
          onCompleteText: "لا يوجد إشعارات",
        );
      } else {
        var _notifications = controller.notifications;
        return ListView.separated(
            itemCount: _notifications.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 7);
            },
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              var _notification = controller.notifications.elementAt(index);
              if (_notification.data['message_id'] != null) {
                return MessageNotificationItemWidget(
                    notification: _notification);
              } else if (_notification.data['booking_id'] != null) {
                return BookingNotificationItemWidget(
                    notification: _notification);
              } else {
                return NotificationItemWidget(
                  notification: _notification,
                  onDismissed: (notification) {
                    controller.removeNotification(notification);
                  },
                  onTap: (notification) async {
                    await controller.markAsReadNotification(notification);
                  },
                );
              }
            }
      );
      }
    });
  }
}
