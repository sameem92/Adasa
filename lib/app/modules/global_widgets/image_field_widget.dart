import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/ui.dart';
import '../../models/media_model.dart';
import '../../repositories/upload_repository.dart';

class ImageFieldController extends GetxController {
  Rx<File> image = Rx<File>(null);
  String uuid;
  final uploading = false.obs;
  UploadRepository _uploadRepository;

  ImageFieldController() {
    _uploadRepository = UploadRepository();
  }


  void reset() {
    image.value = null;
    uploading.value = false;
  }

  Future pickImage(ImageSource source, String field,
      ValueChanged<String> uploadCompleted) async {
    ImagePicker imagePicker = ImagePicker();
    XFile pickedFile =
    await imagePicker.pickImage(source: source, imageQuality: 80);
    File imageFile = File(pickedFile.path);
    if (imageFile != null) {
      try {
        uploading.value = true;
        await deleteUploaded();
        uuid = await _uploadRepository.image(imageFile, field);
        image.value = imageFile;
        uploadCompleted(uuid);
        uploading.value = false;
      } catch (e) {
        uploading.value = false;
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    } else {
      uploading.value = false;
      Get.showSnackbar(
          Ui.ErrorSnackBar(message: "الرجاء اختيار الصورة".tr));
    }
  }

  Future<void> deleteUploaded() async {
    if (uuid != null) {
      final done = await _uploadRepository.delete(uuid);
      if (done) {
        uuid = null;
        image = Rx<File>(null);
      }
    }
  }
}

class ImageFieldWidget extends StatelessWidget {
  const ImageFieldWidget({
    Key key,
    @required this.label,
    @required this.tag,
    @required this.field,
    this.placeholder,
    this.buttonText,
    @required this.uploadCompleted,
    this.initialImage,
    @required this.reset,
  }) : super(key: key);

  final String label;
  final String placeholder;
  final String buttonText;
  final String tag;
  final String field;
  final String initialImage;
  final ValueChanged<String> uploadCompleted;
  final ValueChanged<String> reset;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ImageFieldController(), tag: tag);
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Get.theme.focusColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Obx(() {
            return buildImage(initialImage, controller.image.value);
          })
        ],
      ),
    );
  }

  Widget buildLoader() {
    return SizedBox(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'assets/img/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
        ));
  }

  Widget buildImage(String initialImage, File image) {
    final controller = Get.put(ImageFieldController(), tag: tag);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: [
          if (initialImage != null && image == null)
            GestureDetector(
              onTap: () async {
                await controller.pickImage(
                    ImageSource.gallery, field, uploadCompleted);
              },
              child: Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(200)),
                  child: CachedNetworkImage(
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                    imageUrl: initialImage ?? '',
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 100,
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error_outline),
                  ),
                ),
              ),
            ),
          if (image != null)
            Center(
              child: GestureDetector(
                onTap: () async {
                  await controller.pickImage(
                      ImageSource.gallery, field, uploadCompleted);
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(200)),
                  child: Image.file(
                    image,
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ),
          // Obx(() {
          //   if (controller.uploading.isTrue) {
          //     return buildLoader();
          //   } else {
          //     return GestureDetector(
          //       onTap: () async {
          //         await controller.pickImage(
          //             ImageSource.gallery, field, uploadCompleted);
          //       },
          //       child: Container(
          //         width: 100,
          //         height: 100,
          //         alignment: Alignment.center,
          //         decoration: BoxDecoration(
          //             color: Get.theme.focusColor.withOpacity(0.1),
          //             borderRadius: BorderRadius.circular(10)),
          //         child: Icon(Icons.add_photo_alternate_outlined,
          //             size: 42, color: Get.theme.focusColor.withOpacity(0.4)),
          //       ),
          //     );
          //   }
          // }),
        ],
      ),
    );
  }
}
