import 'dart:async';

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../services/auth_service.dart';
import '../../root/controllers/root_controller.dart';

class RatingController extends GetxController {
  final booking = Booking().obs;
  final review = new Review(rate: 0).obs;
  BookingRepository _bookingRepository;

  RatingController() {
    _bookingRepository = new BookingRepository();
  }

  @override
  void onInit() {
    booking.value = Get.arguments as Booking;
    review.value.user = Get.find<AuthService>().user.value;
    review.value.eService = booking.value.eService;
    super.onInit();
  }

  Future addReview() async {
    try {
      if (review.value.rate < 1) {
        Get.showSnackbar(Ui.ErrorSnackBar(message:
        "الرجاء تقييم الخدمة بالضغط على النجوم".tr));
        return;
      }
      if (review.value.review == null || review.value.review.isEmpty) {
        Get.showSnackbar(Ui.ErrorSnackBar(message:
        "الرجاء تقييم الخدمة بكتابة تعليقك عليها".tr));
        return;
      }
      await _bookingRepository.addReview(review.value);
      Get.showSnackbar(Ui.SuccessSnackBar(message:
      "شكراً لك للتقييم".tr));
      Timer(Duration(seconds: 2), () {
        Get.find<RootController>().changePage(1);
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
