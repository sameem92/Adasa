import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../e_service/controllers/e_service_controller.dart';
import '../controllers/home_controller.dart';

class RecommendedCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return
      Obx(() {
        return controller.eServices.isNotEmpty
            ? CarouselSlider.builder(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            height: 220,
            enlargeCenterPage: true,
            aspectRatio: .2,
            disableCenter: false,
            pauseAutoPlayOnTouch: true,
            viewportFraction: .65,
          ),
          itemCount: controller.eServices.length,
          itemBuilder: (context, index, realIndex) {

            var _service = controller.eServices.elementAt(index);
            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.E_SERVICE, arguments: {
                  'eService': _service,
                  'heroTag': 'recommended_carousel'
                });
              },
              child: Container(
                width: 270,
                // height: 300,

                margin: EdgeInsetsDirectional.only(
                    end: 5, start:  5 , bottom: 10),
                // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Get.theme.hintColor.withOpacity(.2),
                      blurRadius: 10,
                      spreadRadius: 0,

                    ),
                  ],
                ),
                child: Column(

                  mainAxisSize: MainAxisSize.min,
                  children: [

                        Expanded(
                          child: Hero(
                            tag: 'recommended_carousel${_service.id}',
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    height: 200,
                                    width: 350,
                                    fit: BoxFit.cover,
                                    imageUrl: _service.firstImageUrl,
                                    placeholder: (context, url) =>
                                        Image.asset(
                                          'assets/img/loading.gif',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 200,
                                        ),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error_outline),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 10),
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(

                        color: Get.theme.primaryColor,

                        // backgroundBlendMode: BlendMode.overlay,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            _service.name ?? '',
                            maxLines: 1,
                            style: Get.textTheme.bodyText2.merge(
                                TextStyle(color: Get.theme.hintColor)),
                          ),

                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  if (_service.getOldPrice > 0)
                                    Ui.getPrice(
                                      _service.getOldPrice,
                                      noUnit: false,
                                      style: Get.textTheme.bodyText1
                                          .merge(TextStyle(
                                          color:
                                          Get.theme.focusColor,
                                          decoration: TextDecoration
                                              .lineThrough)),
                                      // unit: _service.getUnit,
                                    ),

                                  Ui.getPrice(
                                    _service.getPrice,
                                    style: Get.textTheme.bodyText2
                                        .merge(TextStyle(
                                        color: Get.theme.colorScheme
                                            .secondary)),
                                    unit: _service.getUnit,
                                  ),
                                ],
                              ),

                            Wrap(
                                  children:
                                  Ui.getStarsList(_service.rate,size: 11),
                                ),

                            ],
                          ),
                          // ],
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },

        )
            : const SizedBox();
      });
  }
}
