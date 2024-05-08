/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarController extends GetxController {
  RxString selectedId;


  TabBarController() {
    selectedId = RxString("");
  }

  bool isSelected(dynamic tabId) => selectedId.value == tabId.toString();

  void toggleSelected(
      dynamic tabId,
      ) {
    if (!isSelected(tabId)) {
      selectedId.value = tabId.toString();
    }
  }
}

class TabBarWidget extends StatelessWidget implements PreferredSize {
  TabBarWidget(
      {Key key,
        @required this.tag,
        @required this.tabs,
        @required this.initialSelectedId}) {
    tabs[0] = Padding(
        padding: const EdgeInsetsDirectional.only(start: 15),
        child: tabs.elementAt(0));
    tabs[tabs.length - 1] = Padding(
        padding: const EdgeInsetsDirectional.only(end: 15),
        child: tabs[tabs.length - 1]);
  }

  final String tag;
  final dynamic initialSelectedId;
  final List<Widget> tabs;

  Widget buildTabBar() {
    final controller = Get.put(TabBarController(), tag: tag, permanent: true);
    if (controller.selectedId.firstRebuild) {
      controller.selectedId.value = initialSelectedId.toString();
    }
    return Container(
      alignment: AlignmentDirectional.centerStart,
      height: 60,
      child: ListView(
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: tabs),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTabBar();
  }

  @override
  Widget get child => buildTabBar();

  @override
  Size get preferredSize => Size(Get.width, 60);
}

class TabBarLoadingWidget extends StatelessWidget implements PreferredSize {
  const TabBarLoadingWidget({Key key}) : super(key: key);

  Widget buildTabBar() {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      height: 60,
      child: ListView(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: List.generate(
          4,
              (index) => RawChip(
            elevation: 0,
            label: const Text(''),
            padding: EdgeInsets.symmetric(
                horizontal: 20.0 * (index + 1), vertical: 15),
            backgroundColor: Get.theme.focusColor.withOpacity(0.1),
            selectedColor: Get.theme.colorScheme.secondary,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            showCheckmark: false,
            pressElevation: 0,
          ).marginSymmetric(horizontal: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTabBar();
  }

  @override
  Widget get child => buildTabBar();

  @override
  Size get preferredSize => Size(Get.width, 60);
}

class ChipWidget extends StatelessWidget {
  const ChipWidget({
    Key key,
    @required this.text,
    this.onSelected,
    @required this.tag,
    @required this.id,
  }) : super(key: key);

  final String text;
  final dynamic id;
  final String tag;
  final ValueChanged<dynamic> onSelected;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabBarController(), tag: tag, permanent: true);
    return Obx(() {
      return RawChip(
        elevation: 0,
        label: Text(text),
        labelStyle: controller.isSelected(id)
            ? Get.textTheme.bodyText2
            .merge(TextStyle(color: Get.theme.primaryColor))
            : Get.textTheme.bodyText2,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        backgroundColor: Get.theme.focusColor.withOpacity(0.1),
        selectedColor: Get.theme.colorScheme.secondary,
        selected: controller.isSelected(id),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        showCheckmark: false,
        pressElevation: 0,
        onSelected: (bool value) {
          controller.toggleSelected(id);
          onSelected(id);
        },
      ).marginSymmetric(horizontal: 5);
    });
  }
}
