import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {

  const RegisterView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "سجل معنا",
            style: Get.textTheme.headline6
                .merge(TextStyle(color: Get.theme.colorScheme.secondary)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back_ios, color: Get.theme.colorScheme.secondary),
          //   onPressed: () => {
          //     Get.put(RootController()),
          //     // Get.find<RootController>().changePageOutRoot(1)
          //     Get.find<RootController>().changePageOutRoot(1)
          //   },
          // ),
        ),
        body: Form(
          key: controller.registerFormKey,
          child: ListView(
            primary: true,
            shrinkWrap: true,
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
                        labelText: "الاسم الكريم",
                        hintText: "",
                        initialValue: controller.currentUser?.value?.name,
                        onSaved: (input) =>
                        controller.currentUser.value.name = input,
                        validator: (input) => input.length < 3
                            ? "يجب أن يكون الاسم لا يقل عن ٣ حروف"
                            : null,
                        iconData: Icons.person_outline,
                        keyboardType: TextInputType.text,
                        isFirst: true,
                        isLast: false,
                      ),
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
                        keyboardType: TextInputType.emailAddress,
                        isFirst: false,
                        isLast: false,
                      ),
                      TextFieldWidget(
                        labelText: "رقم الجوال",
                        // hintText: "johndoe@gmail.com".tr,
                        // initialValue: controller.currentUser?.value?.email,
                        onSaved: (input) {
                          return controller.currentUser.value.phoneNumber =
                              input;
                        },
                        validator: (input) => input.length != 10
                            ? "يجب أن يكون ١٠ أرقام".tr
                            : null,
                        iconData: Icons.phone,
                        keyboardType: TextInputType.phone,
                        isFirst: false,
                        isLast: false,
                      ),
                      // PhoneFieldWidget(
                      //   labelText: "رقم الجوال",
                      //   // hintText: "223 665 7896".tr,
                      //   hintText: "223 665 7896",
                      //   initialCountryCode: controller.currentUser?.value
                      //       ?.getPhoneNumber()
                      //       ?.countryISOCode,
                      //   initialValue: controller.currentUser?.value
                      //       ?.getPhoneNumber()
                      //       ?.number,
                      //   onSaved: (phone) {
                      //     return controller.currentUser.value.phoneNumber =
                      //         phone.completeNumber;
                      //   },
                      //   isLast: false,
                      //   isFirst: false,
                      // ),
                      Obx(() {
                        return TextFieldWidget(
                          labelText: "كلمة المرور الجديدة",
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
                          isLast: true,
                          isFirst: false,
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
                    ],
                  );
                }
              })
            ],
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              children: [
                SizedBox(
                  width: Get.width,
                  child: BlockButtonWidget(
                    onPressed: () {
                      controller.register();
                    },
                    color: Get.theme.colorScheme.secondary,
                    text: Text(
                      "سجل",
                      style: Get.textTheme.headline6
                          .merge(TextStyle(color: Get.theme.primaryColor)),
                    ),
                  ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.LOGIN);
                  },
                  child: const Text(" تملك حساب بالفعل ؟ سجل دخول"),
                ).paddingOnly(bottom: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
