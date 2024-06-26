import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/booking_model.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/checkout_controller.dart';
import '../widgets/payment_details_widget.dart';
import '../widgets/payment_method_item_widget.dart';

class CheckoutView extends GetView<CheckoutController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "خيارات الدفع".tr,
          style: context.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color:  Get.theme.colorScheme.secondary),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadPaymentMethodsList();
          await controller.loadWalletList();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Obx(() {
            if (controller.isLoading.isTrue) {
              return CircularLoadingWidget(height: 200);
            }
            return Column(
              children: [

                ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: controller.paymentsList.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    var _paymentMethod = controller.paymentsList.elementAt(index);
                    return PaymentMethodItemWidget(paymentMethod: _paymentMethod);
                  },
                ),
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: buildBottomWidget(Get.arguments as Booking),
    );
  }

  Widget buildBottomWidget(Booking _booking) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaymentDetailsWidget(booking: _booking),
          BlockButtonWidget(
              text: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "الدفع الآن".tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headline6.merge(
                        TextStyle(color: Get.theme.primaryColor),
                      ),
                    ),
                  ),

                ],
              ),
              color: Get.theme.colorScheme.secondary,
              onPressed: () {
                controller.payBooking(_booking);
              }).paddingSymmetric(vertical: 10, horizontal: 20),
        ],
      ),
    );
  }
}
