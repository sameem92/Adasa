import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/e_provider_controller.dart';

class FeaturedCarouselWidget extends GetWidget<EProviderController> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Get.theme.primaryColor,
      child: Obx(() {
        if (controller.featuredEServices.isEmpty) {
          return  CircularLoadingWidget(height: 250);
        }
        return ListView.builder(
            padding: const EdgeInsets.only(bottom: 10),
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.featuredEServices.length,
            itemBuilder: (_, index) {
              var _service = controller.featuredEServices.elementAt(index);
              return
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.E_SERVICE, arguments: {
                      'eService': _service,
                      'heroTag': 'featured_carousel'
                    });
                  },
                  child:
                  Container(
                    width: 250,
                    // height: 250,

                    margin: EdgeInsetsDirectional.only(
                        end: 20, start: index == 0 ? 20 : 0, top: 2, bottom: 2),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: Get.theme.focusColor.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [

                            Expanded(
                              child: Hero(
                                tag: 'featured_carousel${_service.id}',
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  child: CachedNetworkImage(

                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageUrl: _service.firstImageUrl,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/img/loading.gif',
                                      fit: BoxFit.cover,
                                      width: double.infinity,

                                    ),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error_outline),
                                  ),
                                ),
                              ),
                            ),


                        
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10),
                          height:70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _service.name ?? '',
                                      maxLines: 2,
                                      style: Get.textTheme.bodyText2
                                          .merge(TextStyle(color: Get.theme.hintColor)),
                                    ),
                                    Wrap(
                                      children: Ui.getStarsList(_service.rate),
                                    ),
                                  ],
                                ),


                              const SizedBox(height: 1),
                              Wrap(
                                spacing: 5,
                                alignment: WrapAlignment.spaceBetween,
                                direction: Axis.horizontal,
                                crossAxisAlignment: WrapCrossAlignment.end,

                                children: [

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_service.getOldPrice > 0)
                                        Ui.getPrice(
                                          _service.getOldPrice,
                                          noUnit: false,
                                          style: Get.textTheme.bodyText1.merge(
                                              TextStyle(
                                                  color: Get.theme.focusColor,
                                                  decoration: TextDecoration
                                                      .lineThrough)),
                                          // unit: _service.getUnit,
                                        ),
                                      Ui.getPrice(
                                        _service.getPrice,
                                        style: Get.textTheme.bodyText2.merge(
                                            TextStyle(
                                                color: Get.theme.colorScheme
                                                    .secondary)),
                                        unit: _service.getUnit,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            });
      }),
    );
  }
}
