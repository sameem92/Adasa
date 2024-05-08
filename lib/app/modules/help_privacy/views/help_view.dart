import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/help_controller.dart';
import '../widgets/faq_item_widget.dart';

class HelpView extends GetView<HelpController> {

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Get.theme.hintColor),
          bottom: controller.faqCategories.isEmpty
              ?  TabBarLoadingWidget()
              : TabBarWidget(
            tag: 'help',
            initialSelectedId: controller.faqCategories.elementAt(0).id,
            tabs: List.generate(controller.faqCategories.length, (index) {
              var _category = controller.faqCategories.elementAt(index);
              return ChipWidget(
                tag: 'help',
                text: _category.name.tr,
                id: _category.id,
                onSelected: (id) {
                  controller.getFaqs(categoryId: id);
                },
              );
            }),
          ),
          title: Text(
            "الأسئلة الشائعة",
            style: Get.textTheme.headline6.merge(
                TextStyle( color: Get.theme.hintColor)),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color:  Get.theme.colorScheme.secondary),
            onPressed: () async{

              Get.put(RootController());
              await Get.find<RootController>().changePage(0);

            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshFaqs(
              showMessage: true,
              categoryId:
              Get.find<TabBarController>(tag: '/help').selectedId.value,
            );
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Obx(() {
                  if (Get.find<LaravelApiClient>().isLoading(task: 'getFaqs')) {
                    return  CircularLoadingWidget(height: 300);
                  } else {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: controller.faqs.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, indexFaq) {
                        return FaqItemWidget(
                            faq: controller.faqs.elementAt(indexFaq));
                      },
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
