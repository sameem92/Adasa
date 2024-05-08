import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    controller.forgotPasswordFormKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "هل نسيت كلمة المرور",
            style: Get.textTheme.headline6
                .merge(TextStyle(color:  Get.theme.colorScheme.secondary)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,

        ),
        body: Form(
          key: controller.forgotPasswordFormKey,
          child: ListView(
            primary: true,
            children: [
              Container(
                height: 220,
                width: Get.width,
                padding: const EdgeInsets.only(top: 50),
                margin: const EdgeInsets.only(bottom:40),
                child:                      Column(
                  children: [
                    Flexible(
                      child: Container(
                        // decoration: Ui.getBoxDecoration(
                        //   radius: 14,
                        //   border:
                        //   Border.all(width: 5, color: Get.theme.primaryColor),
                        // ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: Image.asset(
                            'assets/icon/icon.png',
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ),
              Obx(() {
                if (controller.loading.isTrue) {
                  return  CircularLoadingWidget(height: 300);
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldWidget(
                        labelText: "البريد الإلكتروني",
                        // hintText: "johndoe@gmail.com".tr,
                        // initialValue: controller.currentUser?.value?.email,
                        onSaved: (input) =>
                        controller.currentUser.value.email = input,
                        validator: (input) => !input.contains('@')
                            ? "يجب أن يكون بريد إلكتروني صحيح"
                            : null,
                        iconData: Icons.email_outlined,
                      ),
                      BlockButtonWidget(
                        onPressed: controller.sendResetLink,
                        color: Get.theme.colorScheme.secondary,
                        text: Text(
                          "ارسال رابط إعادة تعيين كلمة المرور",
                          style: Get.textTheme.headline6
                              .merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                      ).paddingSymmetric(vertical: 35, horizontal: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.offAllNamed(Routes.REGISTER);
                            },
                            child: const Text("ليس لديك حساب ؟ سجل معنا"),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.offAllNamed(Routes.LOGIN);
                            },
                            child: const Text("تذكرت كلمة المرور ؟ سجل دخول"),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
        ));
  }
}
