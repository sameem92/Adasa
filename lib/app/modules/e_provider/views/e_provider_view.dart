import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/media_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/e_provider_controller.dart';
import '../widgets/e_provider_til_widget.dart';
import '../widgets/e_provider_title_bar_widget.dart';
import '../widgets/featured_carousel_widget.dart';
import '../widgets/review_item_widget.dart';

class EProviderView extends GetView<EProviderController> {

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _eProvider = controller.eProvider.value;
      if (!_eProvider.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                controller.refreshEProvider(showMessage: true);
                Get.find<LaravelApiClient>().unForceRefresh();
              },
              child: CustomScrollView(

                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 310,
                    elevation: 0,
                    floating: true,
                    iconTheme:
                    IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color:  Get.theme.colorScheme.secondary),
                      onPressed: () => {Get.back()},
                    ),
                    bottom: buildEProviderTitleBarWidget(_eProvider),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            buildCarouselSlider(_eProvider),
                            buildCarouselBullets(_eProvider),
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 50),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        // buildContactUs(),
                        EProviderTilWidget(
                          title: Text("Description".tr,
                              style: Get.textTheme.subtitle2),
                          content: Ui.applyHtml(_eProvider.description ?? '',
                              style: Get.textTheme.bodyText1),
                        ),
                        // buildAddresses(context),
                        // buildAvailabilityHours(_eProvider),
                        // buildAwards(),
                        // buildExperiences(),
                        EProviderTilWidget(
                          horizontalPadding: 0,
                          // title: Text("خدمات".tr,
                          //     style: Get.textTheme.subtitle2)
                          //     .paddingSymmetric(horizontal: 20),
                          content:  FeaturedCarouselWidget(),
                          // actions: [
                          //   InkWell(
                          //     onTap: () {
                          //       Get.put(SearchController());
                          //       Get.toNamed(Routes.E_PROVIDER_E_SERVICES,
                          //           arguments: _eProvider);
                          //     },
                          //     child: Text("المزيد".tr,
                          //         style: Get.textTheme.subtitle1),
                          //   ).paddingSymmetric(horizontal: 20),
                          // ],
                        ),
                        buildGalleries(),
                        EProviderTilWidget(
                          title: Text("Reviews & Ratings".tr,
                              style: Get.textTheme.subtitle2),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_eProvider.rate.toString(),
                                  style: Get.textTheme.headline1),
                              Wrap(
                                children:
                                Ui.getStarsList(_eProvider.rate, size: 22),
                              ),
                              Text(
                                "Reviews (%s)".trArgs(
                                    [_eProvider.totalReviews.toString()]),
                                style: Get.textTheme.caption,
                              ).paddingOnly(top: 10),
                              const Divider(height: 25, thickness: 1.3),
                              Obx(() {
                                if (controller.reviews.isEmpty) {
                                  return  CircularLoadingWidget(height: 100);
                                }
                                return ListView.separated(
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    return ReviewItemWidget(
                                        review: controller.reviews
                                            .elementAt(index));
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(height: 25, thickness: 1.3);
                                  },
                                  itemCount: controller.reviews.length,
                                  primary: false,
                                  shrinkWrap: true,
                                );
                              }),
                            ],
                          ),
                          actions: const [
                            // TODO view all reviews
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      }
    });
  }

  Widget buildGalleries() {
    return Obx(() {
      if (controller.galleries.isEmpty) {
        return const SizedBox();
      }
      return EProviderTilWidget(
        horizontalPadding: 0,
        title: Text("Galleries".tr, style: Get.textTheme.subtitle2)
            .paddingSymmetric(horizontal: 20),
        content: SizedBox(
          height: 120,
          child: ListView.builder(
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: controller.galleries.length,
              itemBuilder: (_, index) {
                var _media = controller.galleries.elementAt(index);
                return InkWell(
                  onTap: () {
                    Get.toNamed(Routes.GALLERY, arguments: {
                      'media': controller.galleries,
                      'current': _media,
                      'heroTag': 'e_provide_galleries'
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsetsDirectional.only(
                        end: 20,
                        start: index == 0 ? 20 : 0,
                        top: 10,
                        bottom: 10),
                    child: Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Hero(
                          tag: 'e_provide_galleries${_media.id}',
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: _media.thumb,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 100,
                              ),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error_outline),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 12, top: 8),
                          child: Text(
                            _media.name ?? '',
                            maxLines: 2,
                            style: Get.textTheme.bodyText2.merge(
                                TextStyle(color: Get.theme.primaryColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        actions: const [
          // TODO show all galleries
        ],
      );
    });
  }

  // EProviderTilWidget buildAvailabilityHours(EProvider _eProvider) {
  //   return EProviderTilWidget(
  //     title: Text("Availability".tr, style: Get.textTheme.subtitle2),
  //     content: _eProvider.availabilityHours.isEmpty
  //         ? CircularLoadingWidget(height: 150)
  //         : ListView.separated(
  //             padding: EdgeInsets.zero,
  //             primary: false,
  //             shrinkWrap: true,
  //             itemCount: _eProvider.groupedAvailabilityHours().entries.length,
  //             separatorBuilder: (context, index) {
  //               return Divider(height: 16, thickness: 0.8);
  //             },
  //             itemBuilder: (context, index) {
  //               var _availabilityHour = _eProvider
  //                   .groupedAvailabilityHours()
  //                   .entries
  //                   .elementAt(index);
  //               var _data =
  //                   _eProvider.getAvailabilityHoursData(_availabilityHour.key);
  //               return AvailabilityHourItemWidget(
  //                   availabilityHour: _availabilityHour, data: _data);
  //             },
  //           ),
  //     actions: [
  //       if (_eProvider.available)
  //         Container(
  //           child: Text("Available".tr,
  //               maxLines: 1,
  //               style: Get.textTheme.bodyText2.merge(
  //                 TextStyle(color: Colors.green, height: 1.4, fontSize: 10),
  //               ),
  //               softWrap: false,
  //               textAlign: TextAlign.center,
  //               overflow: TextOverflow.fade),
  //           decoration: BoxDecoration(
  //             color: Colors.green.withOpacity(0.2),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  //         ),
  //       if (!_eProvider.available)
  //         Container(
  //           child: Text("Offline".tr,
  //               maxLines: 1,
  //               style: Get.textTheme.bodyText2.merge(
  //                 TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
  //               ),
  //               softWrap: false,
  //               textAlign: TextAlign.center,
  //               overflow: TextOverflow.fade),
  //           decoration: BoxDecoration(
  //             color: Colors.grey.withOpacity(0.2),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  //         ),
  //     ],
  //   );
  // }

  // Widget buildAwards() {
  //   return Obx(() {
  //     if (controller.awards.isEmpty) {
  //       return SizedBox(height: 0);
  //     }
  //     return EProviderTilWidget(
  //       title: Text("Awards".tr, style: Get.textTheme.subtitle2),
  //       content: ListView.separated(
  //         padding: EdgeInsets.zero,
  //         primary: false,
  //         shrinkWrap: true,
  //         itemCount: controller.awards.length,
  //         separatorBuilder: (context, index) {
  //           return Divider(height: 16, thickness: 0.8);
  //         },
  //         itemBuilder: (context, index) {
  //           var _award = controller.awards.elementAt(index);
  //           return Column(
  //             children: [
  //               Text(_award.title ?? '').paddingSymmetric(vertical: 5),
  //               Ui.applyHtml(
  //                 _award.description ?? '',
  //                 style: Get.textTheme.caption,
  //               ),
  //             ],
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //           );
  //         },
  //       ),
  //     );
  //   });
  // }
  //
  // Widget buildExperiences() {
  //   return Obx(() {
  //     if (controller.experiences.isEmpty) {
  //       return SizedBox(height: 0);
  //     }
  //     return EProviderTilWidget(
  //       title: Text("Experiences".tr, style: Get.textTheme.subtitle2),
  //       content: ListView.separated(
  //         padding: EdgeInsets.zero,
  //         primary: false,
  //         shrinkWrap: true,
  //         itemCount: controller.experiences.length,
  //         separatorBuilder: (context, index) {
  //           return Divider(height: 16, thickness: 0.8);
  //         },
  //         itemBuilder: (context, index) {
  //           var _experience = controller.experiences.elementAt(index);
  //           return Column(
  //             children: [
  //               Text(_experience.title ?? '').paddingSymmetric(vertical: 5),
  //               Text(
  //                 _experience.description ?? '',
  //                 style: Get.textTheme.caption,
  //               ),
  //             ],
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //           );
  //         },
  //       ),
  //     );
  //   });
  // }

  // Container buildContactUs() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     decoration: Ui.getBoxDecoration(),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text("Contact us".tr, style: Get.textTheme.subtitle2),
  //               Text("If your have any question!".tr,
  //                   style: Get.textTheme.caption),
  //             ],
  //           ),
  //         ),
  //         // Wrap(
  //         //   spacing: 5,
  //         //   children: [
  //         //     MaterialButton(
  //         //       onPressed: () {
  //         //         launchUrlString(
  //         //             "tel:${controller.eProvider.value.mobileNumber}");
  //         //       },
  //         //       height: 44,
  //         //       minWidth: 44,
  //         //       padding: EdgeInsets.zero,
  //         //       shape: RoundedRectangleBorder(
  //         //           borderRadius: BorderRadius.circular(10)),
  //         //       color: Get.theme.colorScheme.secondary.withOpacity(0.2),
  //         //       elevation: 0,
  //         //       child: Icon(
  //         //         Icons.phone_android_outlined,
  //         //         color: Get.theme.colorScheme.secondary,
  //         //       ),
  //         //     ),
  //         //     MaterialButton(
  //         //       onPressed: () {
  //         //         controller.startChat();
  //         //       },
  //         //       shape: RoundedRectangleBorder(
  //         //           borderRadius: BorderRadius.circular(10)),
  //         //       color: Get.theme.colorScheme.secondary.withOpacity(0.2),
  //         //       padding: EdgeInsets.zero,
  //         //       height: 44,
  //         //       minWidth: 44,
  //         //       elevation: 0,
  //         //       child: Icon(
  //         //         Icons.chat_outlined,
  //         //         color: Get.theme.colorScheme.secondary,
  //         //       ),
  //         //     ),
  //         //   ],
  //         // )
  //       ],
  //     ),
  //   );
  // }

  // Container buildAddresses(context) {
  //   var _addresses = controller.eProvider.value.addresses;
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //     decoration: Ui.getBoxDecoration(),
  //     child: (_addresses.isEmpty)
  //         ? Shimmer.fromColors(
  //             baseColor: Colors.grey.withOpacity(0.15),
  //             highlightColor: Colors.grey[200].withOpacity(0.1),
  //             child: Container(
  //               width: double.infinity,
  //               height: 220,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.all(Radius.circular(10)),
  //               ),
  //             ),
  //           )
  //         : Column(
  //             children: [
  //               ClipRRect(
  //                 borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
  //                 child: MapsUtil.getStaticMaps(
  //                     _addresses.map((e) => e.getLatLng()).toList()),
  //               ),
  //               Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //                 decoration: BoxDecoration(
  //                   color: Get.theme.primaryColor,
  //                   borderRadius:
  //                       BorderRadius.vertical(bottom: Radius.circular(10)),
  //                 ),
  //                 child: Column(
  //                   children: List.generate(_addresses.length, (index) {
  //                     var _address = _addresses.elementAt(index);
  //                     return Row(
  //                       children: [
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(_address.description,
  //                                   style: Get.textTheme.subtitle2),
  //                               SizedBox(height: 5),
  //                               Text(_address.address,
  //                                   style: Get.textTheme.caption),
  //                             ],
  //                           ),
  //                         ),
  //                         MaterialButton(
  //                           onPressed: () {
  //                             MapsUtil.openMapsSheet(
  //                                 context,
  //                                 _address.getLatLng(),
  //                                 controller.eProvider.value.name);
  //                           },
  //                           height: 44,
  //                           minWidth: 44,
  //                           padding: EdgeInsets.zero,
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10)),
  //                           color: Get.theme.colorScheme.secondary
  //                               .withOpacity(0.2),
  //                           child: Icon(
  //                             Icons.directions_outlined,
  //                             color: Get.theme.colorScheme.secondary,
  //                           ),
  //                           elevation: 0,
  //                         ),
  //                       ],
  //                     ).marginOnly(bottom: 10);
  //                   }),
  //                 ),
  //               ),
  //             ],
  //           ),
  //   );
  // }

  CarouselSlider buildCarouselSlider(EProvider _eProvider) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 7),
        height: 360,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _eProvider.images.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: controller.heroTag + _eProvider.id,
              child: CachedNetworkImage(
                width: double.infinity,
                height: 360,
                fit: BoxFit.cover,
                imageUrl: media.url,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error_outline),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Container buildCarouselBullets(EProvider _eProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _eProvider.images.map((Media media) {
          return Container(
            width: 5.0,
            height: 5.0,
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value ==
                    _eProvider.images.indexOf(media)
                    ? Get.theme.hintColor
                    : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  EProviderTitleBarWidget buildEProviderTitleBarWidget(EProvider _eProvider) {
    return EProviderTitleBarWidget(
      title:
          Row(
            children: [
              Expanded(
                child: Text(
                  _eProvider.name ?? '',
                  style: Get.textTheme.headline6.merge(const TextStyle(height: 1.1)),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Get.theme.colorScheme.secondary.withOpacity(0.2),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //   child: Text(_eProvider.type?.name?.tr ?? ' . . . ',
              //       maxLines: 1,
              //       style: Get.textTheme.bodyText2.merge(
              //         TextStyle(
              //             color: Get.theme.colorScheme.secondary,
              //             height: 1.4,
              //             fontSize: 10),
              //       ),
              //       softWrap: false,
              //       textAlign: TextAlign.center,
              //       overflow: TextOverflow.fade),
              // ),
              Wrap(
                spacing: 5,
                children: [
                  // MaterialButton(
                  //   onPressed: () {
                  //     launchUrlString(
                  //         "tel:${controller.eProvider.value.mobileNumber}");
                  //   },
                  //   height: 40,
                  //   minWidth: 40,
                  //   padding: EdgeInsets.zero,
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10)),
                  //   // color:Color,
                  //   elevation: 0,
                  //   child: Icon(
                  //     Icons.phone_android_outlined,
                  //     color: Get.theme.colorScheme.secondary,
                  //   ),
                  // ),
                  // MaterialButton(
                  //   onPressed: () {
                  //     controller.startChat();
                  //   },
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10)),
                  //   // color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  //   padding: EdgeInsets.zero,
                  //   height: 40,
                  //   minWidth: 40,
                  //   elevation: 0,
                  //   child:
                  IconButton(
                    onPressed: (){
                      launchUrlString(
                          "tel:${controller.eProvider.value.mobileNumber}");
                    },
                    icon: Icon(
                      Icons.phone_android_outlined,
                      color: Get.theme.colorScheme.secondary,
                    ),
                  ),IconButton(
                    onPressed: (){
                      controller.startChat();
                    },
                    icon: Icon(
                      Icons.chat_outlined,
                      color: Get.theme.colorScheme.secondary,
                    ),
                  ),

                ],
              )
            ],
          ),


    );
  }
}
