import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../routes/app_routes.dart';

class ServicesCarouselWidget extends StatelessWidget {
  final List<EService> services;

  const ServicesCarouselWidget({Key key, this.services}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 0),

          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: services.length,
          itemBuilder: (_, index) {
            var _service = services.elementAt(index);
            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.E_SERVICE, arguments: {
                  'eService': _service,
                  'heroTag': 'services_carousel'
                });
              },
              child:
              Container(
                width: 300,
                margin: EdgeInsetsDirectional.only(
                    end: 20, start: index == 0 ? 20 : 0, top: 10, bottom: 2),
                // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Get.theme.hintColor.withOpacity(.2),
                        blurRadius: 20,
                        spreadRadius: 0,

                    ),
                  ],
                ),
                child: Column(
                  //alignment: AlignmentDirectional.topStart,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: Stack(
                        children: [

                          CachedNetworkImage(
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: _service.firstImageUrl,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150,
                            ),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error_outline),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      // height:60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _service.name,
                                maxLines: 1,
                                style: Get.textTheme.bodyText2
                                    .merge(TextStyle(color: Get.theme.hintColor)),
                              ),
                              Wrap(
                                    children: Ui.getStarsList(_service.rate),
                                  ),

                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text(
                                _service.eProvider.name,
                                maxLines: 1,
                                style: Get.textTheme.bodyText2
                                    .merge(TextStyle(color: Get.theme.hintColor.withOpacity(.6))),
                              ),
                              Row(mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (_service.getOldPrice > 0)
                                    Ui.getPrice(
                                      _service.getOldPrice,
                                      noUnit: false,
                                      style: Get.textTheme.bodyText1.merge(
                                          TextStyle(
                                              color: Get.theme.focusColor,
                                              decoration:
                                              TextDecoration.lineThrough)),
                                      // unit: _service.getUnit,
                                    ),

                                  Ui.getPrice(
                                    _service.getPrice,
                                    style: Get.textTheme.bodyText2.merge(
                                        TextStyle(
                                            color: Get
                                                .theme.colorScheme.secondary)),
                                    unit: _service.getUnit,
                                  ),

                                ],
                                // ),
                                // ],
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
          }),
    );
  }
}
