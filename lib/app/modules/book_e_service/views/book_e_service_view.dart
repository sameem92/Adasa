import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/book_e_service_controller.dart';

class BookEServiceView extends GetView<BookEServiceController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "الحجز".tr,
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
        bottomNavigationBar: buildBlockButtonWidget(controller.booking.value),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      MaterialButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14),
                        onPressed: () {
                          Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                        elevation: 0,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            Text("حدد موقعك من الخريطة".tr,
                                style: Get.textTheme.subtitle1),
                            Icon(
                              Icons.location_on_outlined,
                              color: Get.theme.colorScheme.secondary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  Obx(() {
                    if (controller.addresses.isEmpty) {
                      return const TabBarLoadingWidget();
                    } else {
                      return TabBarWidget(
                        initialSelectedId: "0",
                        tag: 'addresses',
                        tabs:
                        List.generate(controller.addresses.length, (index) {
                          final _address =
                          controller.addresses.elementAt(index);
                          return ChipWidget(
                            tag: 'addresses',
                            text: _address.getDescription,
                            id: index,
                            onSelected: (id) {
                              Get.find<SettingsService>().address.value =
                                  _address;
                            },
                          );
                        }),
                      );
                    }
                  }),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Icon(Icons.place_outlined, color: Get.theme.focusColor),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Obx(() {
                          return Text(
                              controller.currentAddress?.address ??
                                  "يرجى تحديد عنوانك".tr,
                              style: Get.textTheme.bodyText2);
                        }),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
            TextFieldWidget(
              onChanged: (input) => controller.booking.value.hint = input,
              labelText: "ملاحظاتك لمقدم الخدمة".tr,
            ),
            Obx(() {
              return TextFieldWidget(
                onChanged: (input) =>

                controller.booking.value.coupon.code = input,
                hintText: "00000".tr,
                labelText: "كوبون الخصم".tr,
                errorText: controller.getValidationMessage(),
                // iconData: Icons.confirmation_number_outlined,
                style: Get.textTheme.bodyText2.merge(TextStyle(
                    color: controller.getValidationMessage() != null
                        ? Colors.redAccent
                        : Colors.green)),
                suffixIcon: MaterialButton(
                  onPressed: () {
                    controller.validateCoupon();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color:  Get.theme.colorScheme.secondary,
                  elevation: 0,
                  child: Text("تأكيد الكوبون".tr, style: TextStyle(color:  Get.theme.primaryColor)),
                ).marginSymmetric(vertical: 4),
              );
            }),
            // const SizedBox(height: 20),
            Obx(() {
              return Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: Ui.getBoxDecoration(
                    color: controller.getColor(!controller.scheduled.value)),
                child: Theme(
                  data: ThemeData(
                    checkboxTheme: CheckboxThemeData(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return null;
                            }
                            if (states.contains(MaterialState.selected)) {
                              return Get.theme.primaryColor;
                            }
                            return null;
                          }),
                    ),
                    radioTheme: RadioThemeData(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return null;
                            }
                            if (states.contains(MaterialState.selected)) {
                              return Get.theme.primaryColor;
                            }
                            return null;
                          }),
                    ),
                    switchTheme: SwitchThemeData(
                      thumbColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return null;
                            }
                            if (states.contains(MaterialState.selected)) {
                              return Get.theme.primaryColor;
                            }
                            return null;
                          }),
                      trackColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return null;
                            }
                            if (states.contains(MaterialState.selected)) {
                              return Get.theme.primaryColor;
                            }
                            return null;
                          }),
                    ),
                  ),
                  child: RadioListTile(
                    value: false,
                    groupValue: controller.scheduled.value,
                    activeColor: Get.theme.colorScheme.secondary,
                    onChanged: (value) {
                      controller.toggleScheduled(value);
                    },
                    title: Text("في أقصى سرعة ممكنة".tr,
                        style: controller
                            .getTextTheme(!controller.scheduled.value))
                        .paddingSymmetric(vertical: 20),
                  ),
                ),
              );
            }),
            Obx(() {
              return Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                decoration: Ui.getBoxDecoration(
                    color: controller.getColor(controller.scheduled.value)),
                child: Theme(
                  data: ThemeData(
                    checkboxTheme: CheckboxThemeData(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return null;
                            }
                            if (states.contains(MaterialState.selected)) {
                              return Get.theme.primaryColor;
                            }
                            return null;
                          }),
                    ),
                    radioTheme: RadioThemeData(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return null;
                            }
                            if (states.contains(MaterialState.selected)) {
                              return Get.theme.primaryColor;
                            }
                            return null;
                          }),
                    ),
                    switchTheme: SwitchThemeData(
                      thumbColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return null;
                            }
                            if (states.contains(MaterialState.selected)) {
                              return Get.theme.primaryColor;
                            }
                            return null;
                          }),
                      trackColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return null;
                            }
                            if (states.contains(MaterialState.selected)) {
                              return Get.theme.primaryColor;
                            }
                            return null;
                          }),
                    ),
                  ),
                  child: RadioListTile(
                    value: true,
                    groupValue: controller.scheduled.value,
                    activeColor: Get.theme.colorScheme.secondary,
                    onChanged: (value) {
                      controller.toggleScheduled(value);
                    },
                    title: Text("حسب تاريخ محدد".tr,
                        style: controller
                            .getTextTheme(controller.scheduled.value))
                        .paddingSymmetric(vertical: 20),
                  ),
                ),
              );
            }),
            Obx(() {
              return AnimatedOpacity(
                opacity: controller.scheduled.value ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: controller.scheduled.value ? 0 : 0),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: controller.scheduled.value ? 20 : 0),
                  decoration: Ui.getBoxDecoration(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              controller.showMyTimePicker(context);
                            },
                            shape: const StadiumBorder(),
                            color: Get.theme.colorScheme.secondary
                                .withOpacity(0.2),
                            elevation: 0,
                            child: Text("Select a time".tr,
                                style: Get.textTheme.subtitle1),
                          ),
                          MaterialButton(
                            elevation: 0,
                            onPressed: () {
                              controller.showMyDatePicker(context);
                            },
                            shape: const StadiumBorder(),
                            color: Get.theme.colorScheme.secondary
                                .withOpacity(0.2),
                            child: Text("Select a Date".tr,
                                style: Get.textTheme.subtitle1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ));
  }

  Widget buildBlockButtonWidget(Booking _booking) {
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
      child: Obx(() {
        return BlockButtonWidget(
          text: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "احجز".tr,
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
          (!(Get.find<SettingsService>().address.value?.isUnknown() ??
              true))
              ? () async {
            await Get.toNamed(Routes.BOOKING_SUMMARY);
          }
              : null,
        ).paddingOnly(right: 20, left: 20);
      }),
    );
  }
}
