import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class CategoriesCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: EdgeInsets.only(bottom: 20,top: 20),
      child: Obx(() {
        return ListView.builder(
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (_, index) {
              var _category = controller.categories.elementAt(index);
              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.CATEGORY, arguments: _category);
                },
                child: Container(
                  width: 100,
                  // height: 100,
                  margin: EdgeInsetsDirectional.only(end: 10, start: index == 0 ? 10 : 0,),
                  padding: EdgeInsets.symmetric(vertical: 1),
                  decoration: new BoxDecoration(
                    color: context.theme.colorScheme.secondary,
                    // gradient: new LinearGradient(
                    //     colors: [_category.color.withOpacity(1), _category.color.withOpacity(0.1)],
                    //     begin: AlignmentDirectional.topStart,
                    //     //const FractionalOffset(1, 0),
                    //     end: AlignmentDirectional.bottomEnd,
                    //     stops: [0.1, 0.9],
                    //     tileMode: TileMode.clamp),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Get.theme.colorScheme.secondary.withOpacity(.2),
                    //     blurRadius: 5,
                    //     spreadRadius:2,
                    //
                    //   ),
                    // ],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),

                        child:
                        Center(
                          child: Text(
                            _category.name,
                            maxLines: 2,
                            style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)),
                          ),
                        ),


                ),
              );
            });
      }),
    );
  }
}
