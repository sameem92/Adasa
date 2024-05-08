import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/home_controller.dart';
import 'services_carousel_widget.dart';

class FeaturedCategoriesWidget extends GetWidget<HomeController> {

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.featured.isEmpty) {
        return  CircularLoadingWidget(height: 300);
      }
      return Column(
        children: List.generate(controller.featured.length, (index) {
          var _category = controller.featured.elementAt(index);
          return Column(
            children: [

              controller.featured.elementAt(index).eServices.isNotEmpty?
              Container(
                padding:
                const EdgeInsets.only(right: 20,bottom: 20,top: 30,left: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(_category.name,
                            style: Get.textTheme.headline6)),
                    GestureDetector(onTap: (){
                      Get.put(SearchController());
                      Get.toNamed(Routes.CATEGORY, arguments: _category);

                    },child: Text("المزيد".tr, style: Get.textTheme.subtitle1)),
                    // ),
                  ],
                ),
              ):Column(),
              Obx(() {
                if (controller.featured.elementAt(index).eServices.isEmpty) {
                  return  Column();
                }
                return ServicesCarouselWidget(
                    services: controller.featured.elementAt(index).eServices);
              }),
            ],
          );
        }),
      );
    });
  }
}
