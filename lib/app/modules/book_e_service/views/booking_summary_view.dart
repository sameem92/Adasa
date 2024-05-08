import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../global_widgets/block_button_widget.dart';
import '../controllers/book_e_service_controller.dart';
import '../widgets/payment_details_widget.dart';

class BookingSummaryView extends GetView<BookEServiceController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "ملخص الحجز".tr,
            style: context.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color:  Get.theme.colorScheme.secondary),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
        ),
        bottomNavigationBar: buildBottomWidget(controller.booking.value),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          color: Get.theme.focusColor),
                      const SizedBox(width: 15),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  DateFormat.yMMMMEEEEd(Get.locale.toString())
                                      .format(controller.booking.value.bookingAt),
                                  style: Get.textTheme.bodyText2),
                              Text(
                                  DateFormat('HH:mm', Get.locale.toString())
                                      .format(controller.booking.value.bookingAt),
                                  style: Get.textTheme.bodyText2),
                            ],
                          )),
                    ],
                  ),
                  const Divider(thickness: 1, height: 25),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, color: Get.theme.focusColor),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (controller.currentAddress.hasDescription())
                                Text(
                                    controller.currentAddress?.getDescription ??
                                        "جاري".tr,
                                    style: Get.textTheme.subtitle2),
                              if (controller.currentAddress.hasDescription())
                                const SizedBox(height: 10),
                              Text(
                                  controller.currentAddress?.address ??
                                      "جاري".tr,
                                  style: Get.textTheme.bodyText2),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1, height: 25),
                  Row(
                    children: [
                      Icon(Icons.description_outlined,
                          color: Get.theme.focusColor),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Obx(() {
                          return Text(controller.booking.value.hint ?? "".tr,
                              style: Get.textTheme.bodyText2);
                        }),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1, height: 25),

                  PaymentDetailsWidget(booking: controller.booking.value),

                ],
              ),
            ),


          ],
        ));
  }

  Widget buildBottomWidget(Booking _booking) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            return BlockButtonWidget(
                text: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "تأكيد".tr,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headline6.merge(
                          TextStyle(color: Get.theme.primaryColor),
                        ),
                      ),
                    ),

                  ],
                ),
                color: Get.theme.colorScheme.secondary,
                onPressed:
                Get.find<LaravelApiClient>().isLoading(task: "addBooking")
                    ? null
                    : () {
                  controller.createBooking();
                });
          }).paddingSymmetric(vertical: 10, horizontal: 20),
        ],
      ),
    );
  }
}
