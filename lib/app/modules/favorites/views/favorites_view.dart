import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../controllers/favorites_controller.dart';
import '../widgets/favorites_list_widget.dart';

class FavoritesView extends GetView<FavoritesController> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          controller.refreshFavorites(showMessage: true);
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: CustomScrollView(
          primary: true,
          shrinkWrap: false,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              expandedHeight: 0,
              elevation: 0.5,
              primary: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color:  Get.theme.colorScheme.secondary),
                onPressed: () => Get.back(),
              ),
              // pinned: true,
              floating: true,
              iconTheme: IconThemeData(color:  Get.theme.colorScheme.secondary),
              title: Text(
                "المفضلة",
                style: Get.textTheme.headline6
                    .merge(TextStyle(color:  Get.theme.colorScheme.secondary)),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,

            ),
            SliverToBoxAdapter(
              child: Wrap(
                children: [
                  FavoritesListWidget(favorites: controller.favorites),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
