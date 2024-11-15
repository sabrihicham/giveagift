import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/view/cards/data/models/category.dart';
import 'package:giveagift/view/cards/widgets/brand_image.dart';
import 'package:giveagift/view/store/controller/shop_controller.dart';
import 'package:giveagift/view/store/data/model/shop.dart';
import 'package:giveagift/view/store/shop_details.dart';

final shopViewKey = GlobalKey<_ShopViewState>();

class ShopView extends StatefulWidget {
  final Category? category;

  const ShopView({super.key, this.category});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> with WidgetsBindingObserver {
  final ShopController controller = Get.put(ShopController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.white.withOpacity(0.1) : null,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Get.locale?.languageCode == 'ar'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Text(
                    'shops_title_msg'.tr,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GetBuilder<ShopController>(
                  init: controller,
                  builder: (controller) {
                    if (controller.defaultState is Submitting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }

                    if (controller.defaultState is SubmissionError) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (controller.defaultState as SubmissionError)
                                .exception
                                .message,
                          ),
                          CupertinoButton(
                            onPressed: () {
                              controller.fetchShops();
                            },
                            child: Text('retry'.tr),
                          ),
                        ],
                      );
                    }

                    if (controller.shops.isEmpty) {
                      return const Center(
                        child: Text('لا يوجد متاجر'),
                      );
                    }

                    var stores = controller.shops[controller.page]!.toList();

                    if (widget.category != null) {
                      stores = stores
                          .where(
                            (element) =>
                                element.category?.id == widget.category?.id,
                          )
                          .toList();
                    }

                    if (stores.isEmpty) {
                      return Center(
                        child: Text('no_stores'.tr),
                      );
                    }

                    // return MasonryGridView.builder(
                    //   itemCount: store.length,
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 10,
                    //     vertical: 20,
                    //   ),
                    //   gridDelegate:
                    //       SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount:
                    //         MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    //   ),
                    //   itemBuilder: (context, index) {
                    //     return ShopWidget(
                    //       store: store.elementAt(index),
                    //     );
                    //   },
                    // );

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          GridView.builder(
                            addAutomaticKeepAlives: true,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.8,
                            ),
                            itemBuilder: (context, index) {
                              return ShopWidget(
                                store: stores.elementAt(index),
                              );
                            },
                            itemCount: stores.length,
                          ),
                          SizedBox(height: 110.h),
                        ],
                      ),
                    );
                  }),
            ),
            // TODO: implement pagination with NumberPaginator
            // GetBuilder<ShopController>(
            //   init: controller,
            //   builder: (controller) => (controller.response?.data.length ?? 1) <= 1
            //     ? const SizedBox()
            //     : Padding(
            //         padding: const EdgeInsets.all(18.0),
            //         child: NumberPaginator(
            //           numberPages: controller.response?.data.length ?? 1,
            //           onPageChange: (int index) {
            //             controller.page = index + 1;
            //             controller.fetchShop();
            //           },
            //         ),
            //       ),
            // )
          ],
        ),
      ),
    );
  }
}

class ShopWidget extends StatefulWidget {
  const ShopWidget({
    super.key,
    required this.store,
  });

  final Shop store;

  @override
  State<ShopWidget> createState() => _ShopWidgetState();
}

class _ShopWidgetState extends State<ShopWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Get.isDarkMode ? Colors.grey[850]! : Colors.grey.shade200,
            blurRadius: Get.isDarkMode ? 10 : 5,
            spreadRadius: 0.5,
            offset: Get.isDarkMode ? const Offset(4, 4) : const Offset(6, 6),
          ),
          BoxShadow(
            color: Get.isDarkMode ? Colors.grey[850]! : Colors.grey.shade100,
            blurRadius: Get.isDarkMode ? 10 : 5,
            spreadRadius: 0.5,
            offset:
                Get.isDarkMode ? const Offset(-4, -4) : const Offset(-6, -6),
          )
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Get.to(() => ShopDetailsPage(
              shopId: widget.store.id, shopName: widget.store.name));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BrandImage(
              logoImage: '${API.BASE_URL}/shops/${widget.store.logo}',
              // origilanSize: true,
              // onTap: () {
              //   widget.store.launchShop();
              // },
              backgroundColor: Colors.white,
              size: 60.w,
              fit: BoxFit.fill,
            ),
            Text(
              widget.store.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            // Text(
            //   widget.store.description,
            //   textAlign: TextAlign.center,
            //   overflow: TextOverflow.ellipsis,
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Get.isDarkMode ? Colors.white : Colors.black,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
