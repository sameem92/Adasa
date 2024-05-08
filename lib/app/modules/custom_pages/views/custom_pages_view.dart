

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../providers/laravel_provider.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/custom_pages_controller.dart';

class CustomPagesView extends GetView<CustomPagesController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return Text(
              controller.customPage.value.title.tr,
              style: Get.textTheme.headline6,
            );
          }),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color:  Get.theme.colorScheme.secondary),
              onPressed: () async{
                await Get.lazyPut(()=>RootController());
                Get.find<RootController>().changePage(2);
                // await Get.offNamedUntil(Routes.PROFILE);
                // await Get.offNamedUntil(Routes.PROFILE,(route) => true,);

              }
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshCustomPage(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Obx(() {
              if (controller.customPage.value.content.isEmpty) {
                return const SizedBox();
              } else {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Ui.applyHtml(controller.customPage.value.content),
                  ),
                );
              }
            }),
          ),
        ));
  }
}
