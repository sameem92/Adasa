import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../providers/laravel_provider.dart';
import '../controllers/e_services_controller.dart';
import 'services_empty_list_widget.dart';
import 'services_list_item_widget.dart';

class ServicesListWidget extends GetView<EServicesController> {
   ServicesListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<LaravelApiClient>().isLoading(tasks: [
        'getEProviderEServices',
        'getEProviderPopularEServices',
        'getEProviderMostRatedEServices',
        'getEProviderAvailableEServices',
        'getEProviderFeaturedEServices'
      ]) &&
          controller.page == 1) {
        return const indicatorAdasa();
      } else if (controller.eServices.isEmpty) {
        return const ServicesEmptyListWidget();
      } else {
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.eServices.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.eServices.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Opacity(
                      opacity: controller.isLoading.value ? 1 : 0,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                );
              });
            } else {
              var _service = controller.eServices.elementAt(index);
              return ServicesListItemWidget(service: _service);
            }
          }),
        );
      }
    });
  }
}
