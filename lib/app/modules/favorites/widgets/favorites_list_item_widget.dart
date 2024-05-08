/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/favorite_model.dart';
import '../../../routes/app_routes.dart';

class FavoritesListItemWidget extends StatelessWidget {
  const FavoritesListItemWidget({
    Key key,
    @required Favorite favorite,
  })  : _favorite = favorite,
        super(key: key);

  final Favorite _favorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.E_SERVICE, arguments: {
          'eService': _favorite.eService,
          'heroTag': 'favorite_list_item_carousel${_favorite.id}'
        });
      },
      child: Container(

        padding: const EdgeInsets.only( bottom: 10),
        margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 3),
        decoration: Ui.getBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

                Hero(
                  tag:
                  'favorite_list_item_carousel${_favorite.id}${_favorite.eService.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: _favorite.eService.firstImageUrl,
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: Wrap(
                runSpacing: 1,
                alignment: WrapAlignment.start,
                children: <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _favorite.eService.name ?? '',
                        style: Get.textTheme.bodyText2,
                        maxLines: 3,
                        // textAlign: TextAlign.end,
                      ),
                      Wrap(
                        children:
                        Ui.getStarsList(_favorite.eService.rate, size: 20),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            _favorite.eService.eProvider.name,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Get.textTheme.bodyText1,
                          ),
                          SizedBox(width: 10,),
                          if (_favorite.eService.eProvider.available)
                            Text("Available".tr,
                                maxLines: 1,
                                style: Get.textTheme.bodyText2.merge(
                                  const TextStyle(
                                      color: Colors.green, height: 1.4, fontSize: 10),
                                ),
                                softWrap: false,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade),
                          if (!_favorite.eService.eProvider.available)
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (_favorite.eService.getOldPrice > 0)
                            Ui.getPrice(
                              _favorite.eService.getOldPrice,
                              noUnit: false,
                              style: Get.textTheme.bodyText2.merge(TextStyle(
                                  color: Get.theme.focusColor,
                                  decoration: TextDecoration.lineThrough)),
                              // unit: _favorite.eService.getUnit,
                            ),
                          Ui.getPrice(
                            _favorite.eService.getPrice,
                            style: Get.textTheme.headline6,
                            unit: _favorite.eService.getUnit,
                          ),
                        ],
                      ),
                    ],
                  ),


                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}
