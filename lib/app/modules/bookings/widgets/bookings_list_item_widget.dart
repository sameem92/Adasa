/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../controllers/booking_controller.dart';
import '../controllers/bookings_controller.dart';
import 'booking_options_popup_menu_widget.dart';

class BookingsListItemWidget extends StatelessWidget {

  const BookingsListItemWidget({
    Key key,
    @required Booking booking,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;

  @override
  Widget build(BuildContext context) {
    Color _color = _booking.cancel ? Get.theme.focusColor : Get.theme.colorScheme.secondary;
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.BOOKING, arguments: _booking);
      },
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 15, ),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: Ui.getBoxDecoration(),
        child: Column(
          children: [
            Container(

              width: double.infinity,
              child:
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('HH:mm', Get.locale.toString()).format(_booking.bookingAt),
                      maxLines: 1,
                      style: Get.textTheme.bodyText2.merge(
                        TextStyle(color: Get.theme.primaryColor, height: 1.4,fontSize: 20),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  SizedBox(width: 30,),
                  Text(DateFormat('dd /', Get.locale.toString()).format(_booking.bookingAt),
                      maxLines: 1,
                      style: Get.textTheme.headline3.merge(
                        TextStyle(color: Get.theme.primaryColor, height: 1,fontSize: 20),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  SizedBox(width: 10,),
                  Text(DateFormat('MMM', Get.locale.toString()).format(_booking.bookingAt),
                      maxLines: 1,
                      style: Get.textTheme.bodyText2.merge(
                        TextStyle(color: Get.theme.primaryColor, height: 1,fontSize: 20),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                ],
              ),
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),

            ),
            ClipRRect(
              // borderRadius: BorderRadius.only(b: Radius.circular(10), topRight: Radius.circular(10)),
              child: CachedNetworkImage(
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl: _booking.eService.firstImageThumb,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 80,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            ),
            // SizedBox(height: 10,),
            // if (_booking.payment != null)
            //   Container(
            //     width: 80,
            //     child: Text(_booking.payment.paymentStatus?.status ?? '',
            //         style: Get.textTheme.caption.merge(
            //           TextStyle(fontSize: 10),
            //         ),
            //         maxLines: 1,
            //         softWrap: false,
            //         textAlign: TextAlign.center,
            //         overflow: TextOverflow.fade),
            //     decoration: BoxDecoration(
            //       color: Get.theme.focusColor.withOpacity(0.2),
            //     ),
            //     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            //   ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    child: Opacity(
                      opacity: _booking.cancel ? 0.3 : 1,
                      child: Wrap(
                        runSpacing: 10,
                        alignment: WrapAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _booking.eService?.name ?? '',
                                  style: Get.textTheme.bodyText2,
                                  maxLines: 3,
                                  // textAlign: TextAlign.end,
                                ),
                              ),
                              !_booking.cancel && _booking.status.order < Get.find<GlobalService>().global.value.onTheWay?
                              GestureDetector(
                                onTap: (){
                                  BookingsController().cancelBookingService(_booking);
                                },
                                child: Text(
                                  "إلغاء الطلب",
                                  style: TextStyle(color: Colors.redAccent,decoration: TextDecoration.underline),
                                  maxLines: 3,
                                  // textAlign: TextAlign.end,
                                ),
                              ):SizedBox(),
                              // BookingOptionsPopupMenuWidget(booking: _booking),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  _booking.eProvider.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Get.textTheme.bodyText1,
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Ui.getPrice(
                                    _booking.getTotal(),
                                    style: Get.textTheme.headline6.merge(TextStyle(color: _color)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
