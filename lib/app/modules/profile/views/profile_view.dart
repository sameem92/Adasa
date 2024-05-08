import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/media_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../custom_pages/views/custom_page_drawer_link_widget.dart';
import '../../global_widgets/image_field_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final bool hideAppBar;
  const ProfileView({ this.hideAppBar = false}) ;

  @override
  Widget build(BuildContext context) {
    // controller.refreshProfile();
    controller.profileForm = GlobalKey<FormState>();
    return Scaffold(
        appBar: hideAppBar
            ? null
            : AppBar(
          title: Text(
            "الملف الشخصي",
            style: context.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Form(
          key: controller.profileForm,
          child: ListView(
            primary: true,
            children: [
              TextFieldWidget(
                onSaved: (input) => controller.user.value.name = input,
                validator: (input) => input.length < 3
                    ? "يجب أن يكون الاسم لا يقل عن ٣ حروف"
                    : null,
                keyboardType: TextInputType.text,
                initialValue: controller.user.value.name,
                labelText: "الاسم الكريم",
                iconData: Icons.person_outline,
              ),
              TextFieldWidget(
                onSaved: (input) => controller.user.value.email = input,
                validator: (input) => !input.contains('@')
                    ? "يجب أن يكون بريد إلكتروني صحيح"
                    : null,
                initialValue: controller.user.value.email,
                keyboardType: TextInputType.emailAddress,
                labelText: "البريد الإلكتروني",
                iconData: Icons.alternate_email,
              ),
              TextFieldWidget(
                onSaved: (input) {
                  controller.user.value.phoneNumber = input;
                },
                // validator: (input) =>
                //     input.length != 10 ? "يجب أن يكون ١٠ أرقام".tr : null,
                initialValue: controller.user.value.phoneNumber,
                labelText: "رقم الجوال",
                iconData: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              Obx(() {
                return TextFieldWidget(
                  labelText: "كلمة المرور الجديدة",
                  onSaved: (input) => controller.newPassword.value = input,
                  onChanged: (input) => controller.newPassword.value = input,
                  validator: (input) {
                    if (input.isNotEmpty && input.length < 3) {
                      return "يجب أن تكون لا تقل عن ٣ خانات";
                    } else if (input != controller.confirmPassword.value) {
                      return "لا يوجد تطابق في كلمة المرور".tr;
                    } else {
                      return null;
                    }
                  },
                  initialValue: controller.newPassword.value,
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
                  isFirst: false,
                  isLast: false,
                );
              }),
              Obx(() {
                return TextFieldWidget(
                  labelText: "تأكيد كلمة المرور",
                  onSaved: (input) => controller.confirmPassword.value = input,
                  onChanged: (input) =>
                  controller.confirmPassword.value = input,
                  validator: (input) {
                    if (input.isNotEmpty && input.length < 3) {
                      return "يجب أن تكون لا تقل عن ٣ خانات";
                    } else if (input != controller.newPassword.value) {
                      return "لا يوجد تطابق في كلمة المرور".tr;
                    } else {
                      return null;
                    }
                  },
                  initialValue: controller.confirmPassword.value,
                  obscureText: controller.hidePassword.value,
                  iconData: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  isFirst: false,
                  isLast: true,
                );
              }),

              Obx(() {
                return ImageFieldWidget(
                  label: "الصورة الشخصية",
                  field: 'avatar',
                  tag: controller.profileForm.hashCode.toString(),
                  initialImage: controller.user.value.avatar.thumb,
                  uploadCompleted: (uuid) {
                    controller.avatar.value = Media(id: uuid);
                  },
                  reset: (uuid) {
                    controller.avatar.value =
                        Media(thumb: controller.user.value.avatar.thumb);
                  },
                );
              }),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Get.theme.focusColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5)),
                  ],
                ),
                child:
                MaterialButton(
                  onPressed: () {
                    controller.saveProfileForm();
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary,
                  elevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                  child: Text("حفظ",
                      style: Get.textTheme.bodyText2
                          .merge(TextStyle(color: Get.theme.primaryColor))),
                ),

              ),

              Divider(color:  Get.theme.focusColor,height: 40),
              // container_profile(title: 'المحفظة',
              //   onPressed: ()async {
              //     await Get.offAndToNamed(Routes.WALLETS);
              //   },
              // ),

              container_profile(title: 'تقييم التطبيق',
                onPressed: ()async {
                  launchURL('https://www.google.com/');
                },
              ),

        container_profile(title: 'شارك التطبيق لمن تعرف',
                onPressed: ()async {
                  Share.share(
                    'https://www.google.com/',
                  );
                },
              ),

              container_profile(title: 'الأسئلة الشائعة',
                onPressed: ()async {
                  await Get.offAndToNamed(Routes.HELP);
                },
              ),

              const CustomPageDrawerLinkWidget(),


              // // if (Get.find<AuthService>().isAuth)
              container_profile(title: 'حذف حسابي',
                onPressed: () {
                  _showDeleteDialog(context);
                },
              ),
              //
              // if (Get.find<AuthService>().isAuth)
              container_profile(title: 'تسجيل الخروج',
                onPressed: ()async {
                  await Get.find<AuthService>().removeCurrentUser();
                  Get.back();
                  await Get.find<RootController>().changePageOutRoot(1);
                },
              ),

              ListTile(
                dense: true,
                title: Text(
                  "${"Version".tr} ${Get.find<SettingsService>().setting.value.appVersion}",
                  style: Get.textTheme.caption,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ));
  }


  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,

      barrierDismissible: true, // user must not tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
          title: Text(
            "حذف حسابك!".tr,
            style: const TextStyle(color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                    "هل أنت متأكد من حذف حسابك نهائياً ؟"
                        .tr,
                    style: Get.textTheme.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("لا", style: Get.textTheme.bodyText1),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: const Text(
                "نعم",
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () async {
                Get.back();
                await controller.deleteUser();
                await Get.find<RootController>().changePage(0);
              },
            ),
          ],
        );
      },
    );
  }
}




class container_profile extends StatelessWidget {

  Function onPressed;
  String title;
  container_profile({
    this.onPressed,
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: MaterialButton(
        onPressed: ()async {
          onPressed();

        },

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        color: Get.theme.primaryColor,
        elevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: Get.textTheme.bodyText2
            ),

            Icon(Icons.arrow_forward_ios,color: Get.theme.focusColor,size: 15,)
          ],
        ),
      ),
    );
  }
}
void launchURL(url) async => await canLaunchUrl(Uri.parse(url))
    ? await launchUrl(Uri.parse(url))
    : throw 'Could not launch $url';