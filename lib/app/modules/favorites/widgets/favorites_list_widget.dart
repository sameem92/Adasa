import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/favorite_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../e_provider/widgets/services_empty_list_widget.dart';
import 'favorites_list_item_widget.dart';

class FavoritesListWidget extends StatelessWidget {
  final List<Favorite> favorites;

   FavoritesListWidget({Key key, this.favorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<LaravelApiClient>()
          .isLoading(task: 'getFavoritesEServices')) {
        return const indicatorAdasa();
      } else if (favorites.isEmpty) {
        return const ServicesEmptyListWidget();
      } else {
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: favorites.length,
          itemBuilder: ((_, index) {
            var _favorite = favorites.elementAt(index);
            return FavoritesListItemWidget(favorite: _favorite);
          }),
        );
      }
    });
  }
}
