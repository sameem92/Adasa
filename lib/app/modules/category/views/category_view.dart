import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../controllers/category_controller.dart';
import '../widgets/services_list_widget.dart';

class CategoryView extends GetView<CategoryController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (!Get.find<LaravelApiClient>().isLoading(tasks: [
            'getAllEServicesWithPagination',
            'getFeaturedEServices',
            'getPopularEServices',
            'getMostRatedEServices',
            'getAvailableEServices'
          ])) {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshEServices(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          }
        },
        child: CustomScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: false,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              expandedHeight: 10,
              elevation: 0.5,
              primary: true,
              // pinned: true,
              floating: true,
              iconTheme: IconThemeData(color: Get.theme.focusColor),
              title: Text(
                controller.category.value.name,
                style: Get.textTheme.headline6
                    .merge(TextStyle(color: Get
                    .theme.colorScheme.secondary)),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                     color:  Get.theme.colorScheme.secondary),
                onPressed: () => {Get.back()},
              ),

            ),
            SliverToBoxAdapter(
              child: Wrap(
                children: [
                  SizedBox(
                    height: 60,
                    child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(CategoryFilter.values.length,
                                (index) {
                              var _filter = CategoryFilter.values.elementAt(index);
                              return Obx(() {
                                return Padding(
                                  padding:
                                  const EdgeInsetsDirectional.only(start: 20),
                                  child: RawChip(
                                    elevation: 0,
                                    label: Text(_filter.toString().tr),
                                    labelStyle: controller.isSelected(_filter)
                                        ? Get.textTheme.bodyText2.merge(TextStyle(
                                        color: Get.theme.primaryColor))
                                        : Get.textTheme.bodyText2,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                    backgroundColor: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.1),
                                    selectedColor: Get
                                        .theme.colorScheme.secondary,
                                    selected: controller.isSelected(_filter),
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(10)),
                                    showCheckmark: false,
                                    // checkmarkColor: Get.theme.primaryColor,
                                    onSelected: (bool value) {
                                      controller.toggleSelected(_filter);
                                      controller.loadEServicesOfCategory(
                                          controller.category.value.id,
                                          filter: controller.selected.value);
                                    },
                                  ),
                                );
                              });
                            })),
                  ),
                   ServicesListWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
