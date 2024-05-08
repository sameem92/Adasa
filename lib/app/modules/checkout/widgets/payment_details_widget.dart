/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../bookings/widgets/booking_row_widget.dart';

class PaymentDetailsWidget extends StatelessWidget {
  const PaymentDetailsWidget({
    Key key,
    @required Booking booking,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // decoration: Ui.getBoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Wrap(
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: <Widget>[

                BookingRowWidget(
                  description: "Tax Amount".tr,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Ui.getPrice(_booking.getTaxesValue(), style: Get.textTheme.subtitle2),
                  ),
                ),
                BookingRowWidget(
                  description: "المجموع".tr,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Ui.getPrice(_booking.getSubtotal(), style: Get.textTheme.subtitle2),
                  ),
                ),
                // if ((_booking.coupon?.discount ?? 0) > 0)
                  BookingRowWidget(
                    description: "كوبون الخصم".tr,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        children: [
                          Ui.getPrice(_booking.coupon?.discount ?? 0, style: Get.textTheme.bodyText1, unit: _booking.coupon.discountType == 'percent' ? "%" : null),
                        ],
                      ),
                    ),
                    hasDivider: false,
                  ),
                BookingRowWidget(
                  description: "Total Amount".tr,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Ui.getPrice(_booking.getTotal(), style: Get.textTheme.headline6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
