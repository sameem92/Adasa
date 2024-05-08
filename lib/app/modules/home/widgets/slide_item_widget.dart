import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/slide_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class SlideItemWidget extends StatelessWidget {
  final Slide slide;

  const SlideItemWidget({
    this.slide,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(
              Directionality.of(context) == TextDirection.rtl ? 0 : math.pi),
          child: CachedNetworkImage(
            width: double.infinity,
            height: 310,
            fit: Ui.getBoxFit(slide.imageFit),
            imageUrl: slide.image.url,
            placeholder: (context, url) => Image.asset(
              'assets/img/loading.gif',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error_outline),
          ),
        ),
        if (slide.button != null && slide.button != '')
          Positioned(
              bottom: 110,
              left: MediaQuery.of(context).size.width-MediaQuery.of(context).size.width/2-120/2,
              child: GestureDetector(
                onTap: () {
                  if (slide.eProvider != null) {
                    Get.toNamed(Routes.E_PROVIDER, arguments: {
                      'eProvider': slide.eProvider,
                      'heroTag': 'e_provider_slide_item'
                    });
                  } else if (slide.eService != null) {
                    Get.toNamed(Routes.E_SERVICE, arguments: {
                      'eService': slide.eService,
                      'heroTag': 'slide_item'
                    });
                  }
                },
                child: Container(
                  width: 150,
                  padding: EdgeInsets.only(bottom: 4,top:4 ),
                  decoration: BoxDecoration(color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Center(
                    child: Text(
                      slide.button,
                      textAlign: TextAlign.start,
                      style: TextStyle(color:Get.theme.colorScheme.secondary,fontSize: 17),
                    ),
                  ),
                ),
              )

              ),
        // Positioned(
        //     top: 10,
        //     right: 10,
        //     child: GestureDetector(
        //       onTap: () {
        //         Get.toNamed(Routes.SEARCH);
        //       },
        //       child: Container(
        //         width: 170,
        //         padding: EdgeInsets.only(bottom: 4,top:4 ),
        //         decoration: BoxDecoration(color: Get.theme.colorScheme.secondary,
        //             borderRadius: BorderRadius.all(Radius.circular(20))
        //         ),
        //         child: Center(
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Icon(Icons.search,color: Get.theme.primaryColor,size: 18,),
        //               SizedBox(width: 5,),
        //               Text(
        //                 'ابحث عن أي خدمة',
        //                 textAlign: TextAlign.start,
        //                 style: TextStyle(color: Get.theme.primaryColor,fontSize: 15),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     )
        //
        // ),


      ],
    );
  }
}
