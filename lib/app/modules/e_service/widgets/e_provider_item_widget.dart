import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';

class EProviderItemWidget extends StatelessWidget {
  final EProvider provider;

  const EProviderItemWidget({Key key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 20,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                height: 65,
                width: 65,
                fit: BoxFit.cover,
                imageUrl: provider.firstImageThumb,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  height: 65,
                  width: 65,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error_outline),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    provider.name,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).hintColor)),
                  ),
                  const SizedBox(height: 5),
                  Ui.removeHtml(
                    (provider.description ?? '').substring(0, min((provider.description ?? '').length, 50)),
                    style: Get.textTheme.caption,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 32,
              child:
              // Chip(
              //   padding: const EdgeInsets.all(0),
              //   label:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(provider.rate.toString(), style:TextStyle(color:  Get.theme.colorScheme.secondary.withOpacity(0.9),)),
                  Icon(
                    Icons.star_border,
                    color: Get.theme.colorScheme.secondary.withOpacity(0.9),
                    size: 16,
                  ),
                ],
              ),
              // backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.9),
              // shape: const StadiumBorder(),
              // ),
            ),
          ],
        ),
        // Text(
        //   review.review,
        //   style: Theme.of(context).textTheme.caption,
        //   overflow: TextOverflow.ellipsis,
        //   softWrap: false,
        //   maxLines: 3,
        // )
      ],
    );
  }
}
