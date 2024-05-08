/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EServiceTitleBarWidget extends StatelessWidget implements PreferredSize {
  final Widget title;

  const EServiceTitleBarWidget({Key key, @required this.title}) : super(key: key);

  Widget buildTitleBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTitleBar();
  }

  @override
  Widget get child => buildTitleBar();

  @override
  Size get preferredSize => Size(Get.width, 110);
}
