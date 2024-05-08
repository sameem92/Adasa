import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../providers/laravel_provider.dart';
import '../controllers/booking_controller.dart';
import '../controllers/bookings_controller.dart';
import '../widgets/booking_actions_widget.dart';
import '../widgets/booking_row_widget.dart';
import '../widgets/booking_til_widget.dart';
import '../widgets/booking_title_bar_widget.dart';

class BookingView extends GetView<BookingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BookingActionsWidget(),
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshBooking(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 370,
                elevation: 0,
                floating: true,
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios,
                      color: Get.theme.colorScheme.secondary),
                  onPressed: () async {
                    Get.find<BookingsController>().refreshBookings();
                    Get.back();
                  },
                ),
                bottom: buildBookingTitleBarWidget(controller.booking),
                flexibleSpace: Obx(() {
                  if (controller.booking.value.address == null)
                    return SizedBox();
                  else
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: MapsUtil.getStaticMaps(
                          [controller.booking.value.address.getLatLng()],
                          height: 600, size: '700x600', zoom: 14),
                    );
                }).marginOnly(bottom: 50),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildContactService(controller.booking.value),
                      buildContactProvider(controller.booking.value),
                      Obx(() {
                        if (controller.booking.value.status == null)
                          return SizedBox();
                        else
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: Container(
                              margin: EdgeInsets.symmetric( vertical: 5),
                              decoration: Ui.getBoxDecoration(),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                title: Text("Booking Details".tr,
                                    style: Get.textTheme.headline6),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: BookingRowWidget(
                                        descriptionFlex: 1,
                                        valueFlex: 2,
                                        description: 'رقم الطلبية',
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12,
                                              left: 12,
                                              top: 6,
                                              bottom: 6),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "#" + controller.booking.value.id,
                                                overflow: TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                                style: TextStyle(
                                                    color: Get.theme.hintColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        hasDivider: true),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: BookingRowWidget(
                                        descriptionFlex: 1,
                                        valueFlex: 2,
                                        description: "حالة الطلب".tr,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  right: 12,
                                                  left: 12,
                                                  top: 6,
                                                  bottom: 6),
                                              // decoration: BoxDecoration(
                                              //   borderRadius: BorderRadius.all(Radius.circular(5)),
                                              //   color: Get.theme.focusColor.withOpacity(0.1),
                                              // ),
                                              child: Text(
                                                controller
                                                    .booking.value.status.status,
                                                overflow: TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                                style: TextStyle(
                                                    color: Get.theme.hintColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                        hasDivider: true),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: BookingRowWidget(
                                        description: "الدفع".tr,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  right: 12,
                                                  left: 12,
                                                  top: 6,
                                                  bottom: 6),
                                              // decoration: BoxDecoration(
                                              //   borderRadius: BorderRadius.all(Radius.circular(5)),
                                              //   color: Get.theme.focusColor.withOpacity(0.1),
                                              // ),
                                              child: Text(
                                                controller.booking.value.payment
                                                        ?.paymentStatus?.status ??
                                                    "لم يتم الدفع".tr,
                                                style: TextStyle(
                                                    color: Get.theme.hintColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                        hasDivider: true),
                                  ),
                                  if (controller
                                          .booking.value.payment?.paymentMethod !=
                                      null)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: BookingRowWidget(
                                          description: "Payment Method".tr,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    right: 12,
                                                    left: 12,
                                                    top: 6,
                                                    bottom: 6),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5)),
                                                  color: Get.theme.focusColor
                                                      .withOpacity(0.1),
                                                ),
                                                child: Text(
                                                  controller.booking.value.payment
                                                      ?.paymentMethod
                                                      ?.getName(),
                                                  style: TextStyle(
                                                      color: Get.theme.hintColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                          hasDivider: true),
                                    ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: BookingRowWidget(
                                      description: "ملاحظات".tr,
                                      child: Ui.removeHtml(
                                          controller.booking.value.hint,
                                          alignment: Alignment.centerRight,
                                          textAlign: TextAlign.end),
                                    ),
                                  ),
                                  SizedBox(height: 10,)
                                ],
                              ),
                            ),
                          );
                      }),
                      Obx(() {
                        if (controller.booking.value.eService == null)
                          return SizedBox();
                        else
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: Container(
                              margin: EdgeInsets.symmetric( vertical: 5),
                              decoration: Ui.getBoxDecoration(),
                              child: ExpansionTile(
                                initiallyExpanded: false,
                                title: Text("الفاتورة".tr,
                                    style: Get.textTheme.headline6),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: BookingRowWidget(
                                        descriptionFlex: 2,
                                        valueFlex: 1,
                                        description:
                                            controller.booking.value.eService.name,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ui.getPrice(
                                              controller
                                                  .booking.value.eService.getPrice,
                                              style: Get.textTheme.subtitle2),
                                        ),
                                        hasDivider: true),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Column(
                                      children: List.generate(
                                          controller.booking.value.options.length,
                                          (index) {
                                        var _option = controller
                                            .booking.value.options
                                            .elementAt(index);
                                        return BookingRowWidget(
                                            descriptionFlex: 2,
                                            valueFlex: 1,
                                            description: _option.name,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ui.getPrice(_option.price,
                                                  style: Get.textTheme.bodyText1),
                                            ),
                                            hasDivider: (controller.booking.value
                                                        .options.length -
                                                    1) ==
                                                index);
                                      }),
                                    ),
                                  ),
                                  if (controller
                                          .booking.value.eService.priceUnit ==
                                      'fixed')
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: BookingRowWidget(
                                          description: "Quantity".tr,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "x" +
                                                  controller.booking.value.quantity
                                                      .toString() +
                                                  " " +
                                                  controller.booking.value.eService
                                                      .quantityUnit.tr,
                                              style: Get.textTheme.bodyText2,
                                            ),
                                          ),
                                          hasDivider: true),
                                    ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Column(
                                      children: List.generate(
                                          controller.booking.value.taxes.length,
                                          (index) {
                                        var _tax = controller.booking.value.taxes
                                            .elementAt(index);
                                        return BookingRowWidget(
                                            description: _tax.name,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: _tax.type == 'percent'
                                                  ? Text(
                                                      _tax.value.toString() + '%',
                                                      style:
                                                          Get.textTheme.bodyText1)
                                                  : Ui.getPrice(
                                                      _tax.value,
                                                      style:
                                                          Get.textTheme.bodyText1,
                                                    ),
                                            ),
                                            hasDivider: (controller.booking.value
                                                        .taxes.length -
                                                    1) ==
                                                index);
                                      }),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Obx(() {
                                      return BookingRowWidget(
                                        description: "Tax Amount".tr,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ui.getPrice(
                                              controller.booking.value
                                                  .getTaxesValue(),
                                              style: Get.textTheme.subtitle2),
                                        ),
                                        hasDivider: true,
                                      );
                                    }),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Obx(() {
                                      return BookingRowWidget(
                                          description: "Subtotal".tr,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Ui.getPrice(
                                                controller.booking.value
                                                    .getSubtotal(),
                                                style: Get.textTheme.subtitle2),
                                          ),
                                          hasDivider: true);
                                    }),
                                  ),
                                  if ((controller
                                              .booking.value.coupon?.discount ??
                                          0) >
                                      0)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: BookingRowWidget(
                                          description: "Coupon".tr,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Wrap(
                                              children: [
                                                Text(' - ',
                                                    style: Get.textTheme.bodyText1),
                                                Ui.getPrice(
                                                    controller.booking.value.coupon
                                                        .discount,
                                                    style: Get.textTheme.bodyText1,
                                                    unit: controller
                                                                .booking
                                                                .value
                                                                .coupon
                                                                .discountType ==
                                                            'percent'
                                                        ? "%"
                                                        : null),
                                              ],
                                            ),
                                          ),
                                          hasDivider: true),
                                    ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Obx(() {
                                      return BookingRowWidget(
                                        description: "Total Amount".tr,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ui.getPrice(
                                              controller.booking.value.getTotal(),
                                              style: Get.textTheme.headline6),
                                        ),
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 10,)
                                ],
                              ),
                            ),
                          );
                      })
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  BookingTitleBarWidget buildBookingTitleBarWidget(Rx<Booking> _booking) {
    return BookingTitleBarWidget(
      title: Obx(() {
        return Row(
          children: [
            Expanded(
              child: Container(
                color: Get.theme.colorScheme.secondary,
                child: Obx(() {
                  return Center(
                    child: Text(
                      controller.getTime(),
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  );
                }),
              ),
            ),
            _booking.value.bookingAt != null
                ? Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              DateFormat('HH:mm', Get.locale.toString())
                                  .format(_booking.value.bookingAt),
                              maxLines: 1,
                              style: Get.textTheme.bodyText2.merge(
                                TextStyle(
                                    color: Get.theme.colorScheme.secondary,
                                    height: 1.4,
                                    fontSize: 20),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade),
                          Text(
                              DateFormat('     dd', Get.locale.toString())
                                  .format(_booking.value.bookingAt ?? ''),
                              maxLines: 1,
                              style: Get.textTheme.headline3.merge(
                                TextStyle(
                                    color: Get.theme.colorScheme.secondary,
                                    height: 1,
                                    fontSize: 20),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade),
                          Text(
                              DateFormat('/ MMM', Get.locale.toString())
                                  .format(_booking.value.bookingAt ?? ''),
                              maxLines: 1,
                              style: Get.textTheme.bodyText2.merge(
                                TextStyle(
                                    color: Get.theme.colorScheme.secondary,
                                    height: 1,
                                    fontSize: 20),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        );
      }),
    );
  }

  Container buildContactProvider(Booking _booking) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: Ui.getBoxDecoration(),
      child: ExpansionTile(
        title: Text("مزود الخدمة".tr, style: Get.textTheme.headline6),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("اسم المزود :".tr, style: Get.textTheme.bodyMedium),
                Text(_booking.eProvider?.name, style: Get.textTheme.bodyMedium),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Divider(thickness: 1, height: 25),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("التواصل :".tr, style: Get.textTheme.bodyMedium),
                Wrap(
                  spacing: 5,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        launchUrlString(
                            "tel:${_booking.eProvider?.phoneNumber ?? ''}");
                      },
                      height: 44,
                      minWidth: 44,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                      child: Icon(
                        Icons.phone_android_outlined,
                        color: Get.theme.colorScheme.secondary,
                      ),
                      elevation: 0,
                    ),
                    MaterialButton(
                      onPressed: () {
                        controller.startChat();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                      padding: EdgeInsets.zero,
                      height: 44,
                      minWidth: 44,
                      child: Icon(
                        Icons.chat_outlined,
                        color: Get.theme.colorScheme.secondary,
                      ),
                      elevation: 0,
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }

  Container buildContactService(Booking _booking) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: Ui.getBoxDecoration(),
        child: ExpansionTile(
          title: Text("عن الخدمة".tr, style: Get.textTheme.headline6),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("العنوان :".tr, style: Get.textTheme.bodyMedium),
                  Text(_booking.eService.name, style: Get.textTheme.bodyMedium),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Divider(thickness: 1, height: 25),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("الوصف :".tr, style: Get.textTheme.bodyMedium),
                  Flexible(
                      child: Ui.applyHtml(_booking.eService.description,
                          style: Get.textTheme.bodyMedium)),
                ],
              ),
            ),
            SizedBox(height: 10,)
          ],
        )

        );
  }
}
