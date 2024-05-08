import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/slide_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/categories_carousel_widget.dart';
import '../widgets/featured_categories_widget.dart';
import '../widgets/recommended_carousel_widget.dart';
import '../widgets/slide_item_widget.dart';

class Home2View extends GetView<HomeController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            await controller.refreshHome(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 320,
                elevation: 1,
                floating: true,
                 leadingWidth: 100,
                // iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                leading:
                // IconButton(
                //   icon: Icon(Icons.chat_outlined,
                //       color: Get.theme.hintColor),
                //   onPressed: () => { Get.toNamed(Routes.Messages)},
                // ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.search,
                          color: Get.theme.hintColor),
                      onPressed: () => { Get.toNamed(Routes.SEARCH)},
                    ),
                    IconButton(
                      icon: Icon(Icons.chat_outlined,
                          color: Get.theme.hintColor),
                      onPressed: () => { Get.toNamed(Routes.Messages)},
                    ),
                  ],
                ),
                actions: const [NotificationsButtonWidget(),FavouriteButtonWidget()



                ],
                flexibleSpace:  FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Obx(() {
                    return Stack(
                      alignment: controller.slider.isEmpty
                          ? AlignmentDirectional.center
                          : Ui.getAlignmentDirectional(controller.slider
                          .elementAt(controller.currentSlide.value)
                          .textPosition),
                      children: <Widget>[
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 7),
                            height: 360,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              controller.currentSlide.value = index;
                            },
                          ),
                          items: controller.slider.map((Slide slide) {
                            return SlideItemWidget(slide: slide);
                          }).toList(),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 70, horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: controller.slider.map((Slide slide) {
                              return Container(
                                width: 5.0,
                                height: 5.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: controller.currentSlide.value ==
                                        controller.slider.indexOf(slide)
                                        ? Get.theme.colorScheme.secondary
                                        : Get.theme.colorScheme.secondary
                                        .withOpacity(0.4)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }),
                  // RecommendedCarouselWidget(),
                ).marginOnly(top: 100),
              ),

              SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 15)
                    ,child: Wrap(

                    children:   [

                      CategoriesCarouselWidget(),
                      RecommendedCarouselWidget(),
                      FeaturedCategoriesWidget(),

                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
