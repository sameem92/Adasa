import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/notification_model.dart' as model;

class NotificationItemWidget extends StatelessWidget {
  NotificationItemWidget({Key key, this.notification, this.onDismissed, this.onTap, this.icon}) : super(key: key);
  final model.Notification notification;
  final ValueChanged<model.Notification> onDismissed;
  final ValueChanged<model.Notification> onTap;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: Ui.getBoxDecoration(color:  Get.theme.focusColor.withOpacity(0.15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.notifications_active_outlined,color: Get.theme.colorScheme.secondary,),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  this.notification.getMessage(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: Get.textTheme.headline6.merge(TextStyle(fontWeight:FontWeight.w600)),
                ),
                SizedBox(height: 10,),
                Text(
                  DateFormat('d, MMMM y | HH:mm', Get.locale.toString()).format(this.notification.createdAt),
                  style: Get.textTheme.bodyMedium.merge(TextStyle(color: Get.theme.hintColor.withOpacity(.7))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
