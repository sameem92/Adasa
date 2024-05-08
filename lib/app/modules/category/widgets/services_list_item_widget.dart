/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../routes/app_routes.dart';

class ServicesListItemWidget extends StatelessWidget {
   ServicesListItemWidget({
    Key key,
    @required EService service,
  })  : _service = service,
        super(key: key);

  final EService _service;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.E_SERVICE,
            arguments: {'eService': _service, 'heroTag': 'service_list_item'});
      },
      child: Container(
        padding: const EdgeInsets.only( bottom: 10),
        margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 2),
        decoration: Ui.getBoxDecoration(),
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'service_list_item${_service.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: _service.firstImageUrl,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 80,
                      ),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error_outline),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 10,
                  child: Wrap(
                    children:
                    Ui.getStarsList(_service.eProvider.rate, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child:
              Wrap(
                runSpacing: 5,
                alignment: WrapAlignment.start,
                children: <Widget>[

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _service.name ?? '',
                        style: Get.textTheme.bodyText2,
                        maxLines: 3,
                        // textAlign: TextAlign.end,
                      ),

                      if (_service.eProvider.available)
                        Text("Available".tr,
                            maxLines: 1,
                            style: Get.textTheme.bodyText2.merge(
                              const TextStyle(
                                  color: Colors.green, height: 1.4, fontSize: 10),
                            ),
                            softWrap: false,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                      if (!_service.eProvider.available)
                        Text("Offline".tr,
                            maxLines: 1,
                            style: Get.textTheme.bodyText2.merge(
                              const TextStyle(
                                  color: Colors.grey, height: 1.4, fontSize: 10),
                            ),
                            softWrap: false,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _service.eProvider.name,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: Get.textTheme.bodyText1,
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (_service.getOldPrice > 0)
                            Ui.getPrice(
                              _service.getOldPrice,
                              noUnit: false,
                              style: Get.textTheme.bodyText2.merge(TextStyle(
                                  color: Get.theme.focusColor,
                                  decoration: TextDecoration.lineThrough)),
                              // unit: _service.getUnit,
                            ),
                          Ui.getPrice(
                            _service.getPrice,
                            style: Get.textTheme.headline6,
                            unit: _service.getUnit,
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.place_outlined,
                  //       size: 18,
                  //       color: Get.theme.focusColor,
                  //     ),
                  //     const SizedBox(width: 5),
                  //     Flexible(
                  //       child: Text(
                  //         // TODO eProvider address
                  //         _service.eProvider.firstAddress,
                  //         maxLines: 1,
                  //         overflow: TextOverflow.fade,
                  //         softWrap: false,
                  //         style: Get.textTheme.bodyText1,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const Divider(height: 8, thickness: 1),
                  // Wrap(
                  //   spacing: 5,
                  //   runSpacing: 5,
                  //   children:
                  //       List.generate(_service.categories.length, (index) {
                  //     return Container(
                  //       padding:
                  //           const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  //       decoration: BoxDecoration(
                  //           color: Get.theme.primaryColor,
                  //           border: Border.all(
                  //             color: Get.theme.focusColor.withOpacity(0.2),
                  //           ),
                  //           borderRadius:
                  //               const BorderRadius.all(Radius.circular(20))),
                  //       child: Text(_service.categories.elementAt(index).name,
                  //           style: Get.textTheme.caption
                  //               .merge(const TextStyle(fontSize: 10))),
                  //     );
                  //   }),
                  // ),
                ],
              ),


            ),
          ],
        ),
      ),
    );
  }
}
