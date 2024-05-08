import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {


  @override
  Widget build(BuildContext context) {
    controller.loginFormKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "تسجيل الدخول",
            style: Get.textTheme.headline6
                .merge(TextStyle(color:  Get.theme.colorScheme.secondary)),
          ),
          centerTitle: true,
          backgroundColor:Get.theme.scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color:  Get.theme.colorScheme.secondary),
            onPressed: () => {
              Get.lazyPut(()=>RootController()),
              Get.find<RootController>().changePageOutRoot(1)
            },
          ),
        ),
        body: Form(
          key: controller.loginFormKey,
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
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) =>
                        controller.currentUser.value.email = input,
                        validator: (input) => !input.contains('@')
                            ? "يجب أن يكون بريد إلكتروني صحيح"
                            : null,
                        iconData: Icons.email_outlined,
                      ),
                      Obx(() {
                        return TextFieldWidget(
                          labelText: "كلمة المرور",
                          // hintText: "••••••••••••",
                          initialValue: controller.currentUser?.value?.password,
                          onSaved: (input) =>
                          controller.currentUser.value.password = input,
                          validator: (input) => input.length < 3
                              ? "يجب أن تكون لا تقل عن ٣ خانات".tr
                              : null,
                          obscureText: controller.hidePassword.value,
                          iconData: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword.value =
                              !controller.hidePassword.value;
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(controller.hidePassword.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.FORGOT_PASSWORD);
                            },
                            child: const Text("هل نسيت كلمة المرور"),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 20),
                      BlockButtonWidget(
                        onPressed: () {
                          Get.put(RootController());
                          controller.login();
                        },
                        color: Get.theme.colorScheme.secondary,
                        text: Text(
                          "تسجيل الدخول",
                          style: Get.textTheme.headline6
                              .merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                      ).paddingSymmetric(vertical: 10, horizontal: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.REGISTER);
                            },
                            child: const Text("ليس لديك حساب ؟  سجل معنا"),
                          ),
                        ],
                      ).paddingSymmetric(vertical: 20),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
