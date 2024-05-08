import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/custom_page_model.dart';
import '../../../routes/app_routes.dart';
import '../../root/controllers/root_controller.dart';

class CustomPageDrawerLinkWidget extends GetView<RootController> {
  const CustomPageDrawerLinkWidget({Key key}) : super(key: key);

  // const CustomPageDrawerLinkWidget({
  //   Key key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.customPages.isEmpty) {
        return const SizedBox();
      }
      return Column(
        children: List.generate(controller.customPages.length, (index) {
          var _page = controller.customPages.elementAt(index);
          return container_profile(
            title: _page.title,
            onPressed: () async {

              await Get.offAndToNamed(Routes.CUSTOM_PAGES, arguments: _page);
            },
          );
        }),
      );
    });
  }

  IconData getDrawerLinkIcon(CustomPage _page) {
    switch (_page.id) {
      case '1':
        return Icons.privacy_tip_outlined;
      default:
        return Icons.article_outlined;
    }
  }
}
class container_profile extends StatelessWidget {

  Function onPressed;
  String title;
  container_profile({
    this.onPressed,
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: MaterialButton(
        onPressed: ()async {
          await onPressed();

        },

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        color: Get.theme.primaryColor,
        elevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: Get.textTheme.bodyText2
            ),

            Icon(Icons.arrow_forward_ios,color: Get.theme.focusColor,size: 15,)
          ],
        ),
      ),
    );
  }
}