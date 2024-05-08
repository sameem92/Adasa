import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingsEmptyListWidget extends StatelessWidget {
  const BookingsEmptyListWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        const SizedBox(height: 60),

        const SizedBox(height: 200),
        SizedBox(
          width: double.infinity,
          child: Opacity(
            opacity: 0.3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "لا يوجد".tr,
                textAlign: TextAlign.center,
                style: Get.textTheme.headline4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
