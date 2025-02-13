import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/app_navigation.dart';
import 'package:giveagift/constants/enums.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/extensions/web_images.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/splash_screen.dart';
import 'package:giveagift/view/cards/cards.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cards/explore.dart';
import 'package:giveagift/view/cards/pages/ready_card_preview.dart';
import 'package:giveagift/view/cards/widgets/ready_card.dart';
import 'package:giveagift/view/cart/cart.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';
import 'package:giveagift/view/home/controllers/home_controller.dart';
import 'package:giveagift/view/profile/wallet.dart';
import 'package:giveagift/view/widgets/gift_card.dart';
import 'package:giveagift/view/widgets/global_section_header.dart';
import 'package:giveagift/view/widgets/search_bar.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final _carouselController = CarouselSliderController();
    final _currentIndex = ValueNotifier(0);

    return Scaffold(
      backgroundColor: Get.isDarkMode ? Theme.of(context).cardColor : Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        notificationPredicate: (notification) {
          return notification is OverscrollIndicatorNotification;
        },
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            // Get.to(() => const SplashScreen());
          },
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            width: 63.07.w,
          ),
        ),
        toolbarHeight: 70,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(174, 174, 174, 0.1),
            shape: BoxShape.circle,
          ),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.to(() => const WalletPage());
            },
            child: SvgPicture.asset(
              'assets/icons/solar_wallet-linear.svg',
              width: 24.w,
              color: Get.isDarkMode ? Colors.white : null,
            ),
          ),
        ),
        leadingWidth: 70,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GetBuilder(
              init: cartController,
              didChangeDependencies: (controller) {
                if (SharedPrefs.instance.isLogedIn.value && controller.controller?.defaultState is SubmissionError) {
                  Get.snackbar(
                    'Error',
                    (controller.controller!.defaultState as SubmissionError).exception.message,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              builder: (controller) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: Badge(
                    label: Text(
                      '${cartController.cards?.where((element) => element.isPaid == false).length ?? "0"}',
                    ),
                    isLabelVisible: true,
                    backgroundColor: Colors.redAccent,
                    offset: const Offset(-5, 5),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      disabledColor: Colors.transparent,
                      onPressed: () {
                        Get.to(
                          () => CartPage(key: cartPageKey),
                          duration: Get.isDarkMode ? 0.seconds : null
                        );
                        // appNavigationKey.currentState?.changeSelectedTab(Pages.cart);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(174, 174, 174, 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/solar_bag-linear.svg',
                          width: 24.w,
                          color: Get.isDarkMode ? Colors.white : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // physics: const ClampingScrollPhysics(),
        child:
          Column(
            children: [
              // SizedBox(
              //   height: MediaQuery.of(context).padding.top + 70,
              // ),
              // Search Bar
              SearchBar(
                margin: const EdgeInsets.only(top: 30, bottom: 10, left: 16, right: 16),
                onSearch: (value) {
                  Get.find<CardsController>().readyCardsSourceRepository.emptyFilter();
                  Get.find<CardsController>().readyCardsSourceRepository.searchText = value;
                  Get.find<CardsController>().filterReadyCardsLocaly();
                },
              ),
              Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Container(
                  color: Get.isDarkMode
                      ? Colors.black.withOpacity(0.9)
                      : Colors.white,
                  child: Column(
                    children: [
                      GetBuilder<HomeController>(
                        builder: (controller) {
                          if (controller.defaultState is Submitting) {
                            return Column(
                              children: [
                                SizedBox(height: 5.h),
                                CarouselSlider(
                                  carouselController: _carouselController,
                                  options: CarouselOptions(
                                    enlargeCenterPage: true,
                                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                                    viewportFraction: 0.872,
                                    aspectRatio: 2.2,
                                    onPageChanged: (index, reason) {
                                      _currentIndex.value = index;
                                    },
                                  ),
                                  items: [
                                    for(int i = 0 ; i < 3 ; i++)
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[200]!,
                                        highlightColor: Colors.white,
                                        child: Container(
                                          width: double.infinity,
                                          height: 153.h,
                                          margin: const EdgeInsets.symmetric(horizontal: 5),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      )
                                  ]
                                ),
                                const SizedBox(height: 20),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (int i = 0; i < 3; i++)
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                                          child: AnimatedContainer(
                                            width: i == 1 ? 6.w : 4.w,
                                            height: i == 1 ? 6.w : 4.w,
                                            duration: const Duration(milliseconds: 300),
                                            decoration: BoxDecoration(
                                              borderRadius:  BorderRadius.circular(10.r),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              ]
                            );
                          } else if (controller.defaultState is SubmissionError) {
                            return SizedBox(
                              height: 153.h + 20 + 6.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (controller.defaultState as SubmissionError).exception.message,
                                  ),
                                  SizedBox(height: 10.h),
                                  TextButton(
                                    child: Text('retry'.tr),
                                    onPressed: () {
                                      controller.getSlides();
                                    },
                                  )
                                ],
                              ),
                            );
                          }
      
                          if (controller.slides?.isEmpty ?? true) {
                            return const SizedBox.shrink();
                          }
      
                          return Column(
                            children: [
                              SizedBox(height: 5.h),
                              CarouselSlider(
                                carouselController: _carouselController,
                                options: CarouselOptions(
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 5),
                                  autoPlayAnimationDuration: const Duration(milliseconds: 2000),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                                  aspectRatio: 2.4,
                                  onPageChanged: (index, reason) {
                                    _currentIndex.value = index;
                                  },
                                ),
                                items: controller.slides!.map((slide) {
                                  print(slide);
                                  return GestureDetector(
                                    onTap: () {
                                      // Get.to(() => SplashScreen());
                                    },
                                  // onTap: () {
                                  //   if (slide.link != null) {
                                  //     Get.to(() => ExplorePage());
                                  //   }
                                  // },
                                  child: Container(
                                      height: 153.h,
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(horizontal: 8.w/2),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: slide.image.slidesImage,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                );
                                },
                                ).toList(),
                              ),
                              const SizedBox(height: 20),
                              // indicators
                              ValueListenableBuilder(
                                  valueListenable: _currentIndex,
                                  builder: (context, value, _) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        for (int i = 0; i < (controller.slides?.length ?? 0); i++)
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                                            child: AnimatedContainer(
                                              width: i == value ? 6.w : 4.w,
                                              height: i == value ? 6.w : 4.w,
                                              duration: const Duration(milliseconds: 300),
                                              decoration: BoxDecoration(
                                                borderRadius:  BorderRadius.circular(10),
                                                color: i == value
                                                  ? Get.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black
                                                  : Colors.grey,
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  }
                              ),
                            ],
                          );
                        }
                      ),
                      // const SizedBox(height: 20),
                      // Container(
                      //   // margin: const EdgeInsets.symmetric(vertical: 20),
                      //   width: double.infinity,
                      //   color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).scaffoldBackgroundColor,
                      //   child: GetBuilder<ShopController>(
                      //     builder: (controller) {
                      //       if (controller.defaultState is SubmissionSuccess && controller.shops.isEmpty) {
                      //         return Center(
                      //           child: Text('no_data'.tr),
                      //         );
                      //       } else if (controller.defaultState is SubmissionError) {
                      //         return AspectRatio(
                      //           aspectRatio: 4.4,
                      //           child: Container(
                      //             height: 100,
                      //             child: Center(
                      //               child: Text(
                      //                 (controller.defaultState as SubmissionError).exception.message,
                      //               ),
                      //             ),
                      //           ),
                      //         );
                      //       }
                            
                      //       return StoresScrolle(
                      //         items: controller.shops.values
                      //           .expand((store) => store)
                      //           .where((store) => store.showInHome ?? false)
                      //           .map(
                      //             (store) => Container(
                      //               clipBehavior: Clip.antiAliasWithSaveLayer,
                      //               decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.circular(10),
                      //                 color: Colors.white,
                      //               ),
                      //               child: CachedNetworkImage(
                      //                 imageUrl: '${API.BASE_URL}/shops/${store.logo}',
                      //                 fit: BoxFit.fill,
                      //                 width: 100,
                      //                 errorWidget: (context, url, error) => Column(
                      //                   mainAxisAlignment: MainAxisAlignment.center,
                      //                   children: [
                      //                     const Icon(Icons.storefront_rounded),
                      //                     Text(store.name)
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ).toList(),
                      //       );
                      //     },
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      GlobalSectionHeader(
                        title: "choose_what_suits_you".tr,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          // vertical: 10,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w, 
                          vertical: 20,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constrained) {
                            Widget layoutbuilder({required List<Widget> children}) {
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  // if (constraints.maxWidth > 480 * 2 + 40) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: children,
                                    ),
                                  );
                                  // }
                                  // return Column(
                                  //   children: children,
                                  // );
                                },
                              );
                          }
      
                          return Column(
                            children: [
                              layoutbuilder(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // appNavigationKey.currentState?.changeSelectedTab(Pages.cards);
                                            // cardsPageKey.currentState?.changeTab(CardType.readyToUse);
                                            // cardsPageKey.currentState?.changeReadyCardsAppBar();

                                            Get.to(() => const CardsPage(initialTab: CardType.readyToUse));
                                          },
                                          child: Container(
                                            width:  165.w,
                                            padding: EdgeInsets.only(top: 4.w, right: 4.w, left: 4.w),
                                            child: GiftCard(
                                              frontBackgroundImage: "assets/images/special-front-shape.png",
                                              isFrontAssets: true,
                                              frontBackgroundImageFit: BoxFit.fill,
                                              backBackgroundImage: "assets/images/special-back-shape.png",
                                              isBackAssets: true,
                                              backForegroundImageFit: BoxFit.fill,
                                              borderRadius: 10.r,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 10,
                                          ),
                                          width: MediaQuery.of(context).size.width / 2 - 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                              color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              'ready_cards'.tr,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600
                                              ),
                                            ),
                                          ),
                                        ),
      
                                        // // Gift Cards
                                        // Padding(
                                        //   padding:const EdgeInsets.symmetric(vertical: 20),
                                        //   child: Text(
                                        //     "gift_cards".tr,
                                        //     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        //       color: Get.isDarkMode
                                        //         ? Colors.white
                                        //         : Colors.black,
                                        //     ),
                                        //   ),
                                        // ),
                                        // // Choose a gift card from our wide collection
                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(vertical: 0),
                                        //   child: Text(
                                        //     "gift_cards_desc".tr,
                                        //     textAlign: TextAlign.center,
                                        //     style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        //       color: Get.isDarkMode
                                        //         ? Colors.white
                                        //         : Colors.black,
                                        //       ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 13.w,
                                    width: 13.w,
                                  ),
                                  TitledCard(
                                    title: 'custom_cards'.tr,
                                    width: 165.w,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    content: Container(
                                      width: 165.w,
                                      padding: EdgeInsets.only(top: 4.w, right: 4.w, left: 4.w),
                                      child: GiftCard(
                                        frontBackgroundImage: "assets/images/custom-front-shape.png",
                                        isFrontAssets: true,
                                        frontBackgroundImageFit: BoxFit.fill,
                                        backBackgroundImage: "assets/images/custom-back-shape.png",
                                        isBackAssets: true,
                                        backForegroundImageFit: BoxFit.fill,
                                        borderRadius: 10.r,
                                      ),
                                    ),
                                    onTap: () {
                                      // appNavigationKey.currentState?.changeSelectedTab(Pages.cards);
                                      // cardsPageKey.currentState?.changeTab(CardType.custom);
                                      Get.to(() => const Scaffold(body: CardsPage(initialTab: CardType.custom)));
                                    },
                                  )
                                ],
                              ),
                              SectionHeader(
                                title: 'ready_card_for_you'.tr,
                                onMore: () {
                                  // appNavigationKey.currentState?.changeSelectedTab(Pages.cards);
                                  // cardsPageKey.currentState?.changeTab(CardType.readyToUse);
                                  // cardsPageKey.currentState?.changeReadyCardsAppBar();

                                  Get.to(() => const CardsPage(initialTab: CardType.readyToUse));
                                }
                              ),
                              HomeReadyCardsView(Get.find<CardsController>(), context),
                              // Container(
                              //   width: double.infinity,
                              //   clipBehavior: Clip.antiAlias,
                              //   constraints: const BoxConstraints(
                              //     maxWidth: 700,
                              //   ),
                              //   decoration: const BoxDecoration(
                              //     borderRadius: BorderRadius.only(
                              //       topLeft: Radius.circular(20),
                              //       topRight: Radius.circular(20),
                              //     ),
                              //   ),
                              //   child: CachedNetworkImage(
                              //     imageUrl: 'https://giveagift.netlify.app/static/media/policy.ffb21e9f5f0661da9a4b.webp',
                              //     fit: BoxFit.contain,
                              //     width: double.infinity,
                              //   ),
                              // ),
                              // const SizedBox(height: 20),
                              // Column(
                              //   children: [
                              //     Text(
                              //       "our_policy".tr,
                              //       style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              //         color: Get.isDarkMode ? Colors.white : Colors.black,
                              //       ),
                              //     ),
                              //     const SizedBox(height: 20),
                              //     ConstrainedBox(
                              //       constraints: const BoxConstraints(maxWidth: 600),
                              //       child: Text(
                              //         "policy_desc".tr,
                              //         textAlign: TextAlign.justify,
                              //         style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              //           color: Get.isDarkMode ? Colors.white : Colors.black,
                              //         ),
                              //       ),
                              //     )
                              //   ],
                              // ),
                              SizedBox(height: 16.h),
                              HomeBanner(),
                              SizedBox(height: 16.h),
                              GlobalSectionHeader(
                                title: "store_features".tr,
                              ),
                              SizedBox(height: 16.h),
                              ShopSpecials(),
                              SizedBox(height: 16.h),
                              // const Divider(),
                              // Container(
                              //   margin: const EdgeInsets.symmetric(
                              //       vertical: 20),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.center,
                              //     children: contactUs
                              //         .map(
                              //           (contact) => Padding(
                              //             padding: const EdgeInsets
                              //                 .symmetric(horizontal: 5),
                              //             child: InkWell(
                              //               onTap: () =>
                              //                   contact.launchContact(),
                              //               child: SvgPicture.asset(
                              //                 contact.image,
                              //                 width: 30,
                              //                 height: 30,
                              //                 theme: SvgTheme(
                              //                     currentColor: Get
                              //                             .isDarkMode
                              //                         ? Colors.white
                              //                         : Colors.black),
                              //                 fit: BoxFit.contain,
                              //               ),
                              //             ),
                              //           ),
                              //         )
                              //         .toList(),
                              //   ),
                              // )
                            ],
                          );
                        }),
                      ),
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 76.h)
                    ],
                  ),
                ),
              ),
              // SliverAppBar(
              //   systemOverlayStyle: SystemUiOverlayStyle.dark,
              //   // stretch: true,
              //   // forceMaterialTransparency: true,
              //   backgroundColor: Colors.transparent,
              //   surfaceTintColor: Colors.transparent,
              //   elevation: 0,
              //   // flexibleSpace: FlexibleSpaceBar(
              //   //   // stretchModes: [StretchMode.zoomBackground],
              //   //   background: Container(
              //   //     decoration: const BoxDecoration(
              //   //       gradient: LinearGradient(
              //   //         colors: [
              //   //           Colors.black,
              //   //           Colors.transparent,
              //   //         ],
              //   //         begin: Alignment.topCenter,
              //   //         end: Alignment.bottomCenter,
              //   //       ),
              //   //     ),
              //   //   ),
              //   // ),
              //   // floating: true,
              //   // forceElevated: false,
              //   // snap: true,
              //   title: Image.asset(
              //     'assets/images/logo.webp',
              //     width: 80.w,
              //   ),
              //   toolbarHeight: 70,
              //   leading: Container(
              //       margin: const EdgeInsets.all(10),
              //       decoration: const BoxDecoration(
              //         color: Color.fromRGBO(174, 174, 174, 0.1),
              //         shape: BoxShape.circle,
              //     ),
              //       child: CupertinoButton(
              //         padding: EdgeInsets.zero,
              //         onPressed: () {
              //           Get.to(() => const WalletPage());
              //         },
              //         child: SvgPicture.asset(
              //           'assets/icons/solar_wallet-linear.svg',
              //           width: 30.w,
              //           color: Get.isDarkMode ? Colors.white : null,
              //         ),
              //       )
              //   ),
              //   leadingWidth: 70,
              //   actions: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 10),
              //       child: GetBuilder(
              //         init: cartController,
              //         didChangeDependencies: (controller) {
              //           if (controller.controller?.defaultState is SubmissionError) {
              //             Get.snackbar(
              //               'Error',
              //               (controller.controller!.defaultState as SubmissionError).exception.message,
              //               backgroundColor: Colors.red,
              //               colorText: Colors.white,
              //             );
              //           }
              //         },
              //         builder: (controller) {
              //           return Directionality(
              //             textDirection: TextDirection.ltr,
              //             child: Badge(
              //               label: Text(
              //                 '${cartController.cards?.where((element) => element.isPaid == false).length ?? "0"}',
              //               ),
              //               isLabelVisible: true,
              //               backgroundColor: Colors.redAccent,
              //               offset: const Offset(-5, 5),
              //               child: CupertinoButton(
              //                 padding: EdgeInsets.zero,
              //                 disabledColor: Colors.transparent,
              //                 onPressed: () {
              //                   Get.to(() => CartPage(key: cartPageKey));
              //                   // appNavigationKey.currentState?.changeSelectedTab(Pages.cart);
              //                 },
              //                 child: Container(
              //                   padding: const EdgeInsets.all(10),
              //                   decoration: const BoxDecoration(
              //                     color: Color.fromRGBO(174, 174, 174, 0.1),
              //                     shape: BoxShape.circle,
              //                   ),
              //                   child: SvgPicture.asset(
              //                     'assets/icons/solar_bag-linear.svg',
              //                     width: 30.w,
              //                     color: Get.isDarkMode ? Colors.white : null,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           );
              //         },
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
      ),
    );
  }

  Widget HomeReadyCardsView(CardsController controller, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150.w * 2 + 45.w,
      child: GetBuilder(
        init: Get.find<CardsController>(),
        id: CardType.readyToUse.name,
        builder: (controller) {
          if (controller.readyCardsSourceRepository.isLoading) {
            return const CupertinoActivityIndicator();
          }

          return controller.readyCardsSourceRepository.isEmpty
              ? Center(child: Text('no_data'.tr))
              : StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 13.w,
                children: [
                  for (int i = 0 ; i < min(4, controller.readyCardsSourceRepository.length) ; i ++)
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ReadyCardPreview(card: controller.readyCardsSourceRepository[i], shopId: controller.readyCardsSourceRepository[i].shop!.id),
                          duration: Get.isDarkMode ? 0.seconds : null
                        );
                      },
                      child: SizedBox(
                        width: 165.w,
                        height: 160.w,
                        child: ReadyCard(
                          shopId: controller.readyCardsSourceRepository[i].shop!.id,
                          card: controller.readyCardsSourceRepository[i],
                          onAddTap: () {
                            Get.to(() => ReadyCardPreview(card: controller.readyCardsSourceRepository[i], shopId: controller.readyCardsSourceRepository[i].shop!.id));
                          },
                        ),
                      )
                    )
                ],
              );
              // : ListView.separated(
              //     shrinkWrap: true,
              //     physics: const BouncingScrollPhysics(),
              //     scrollDirection: Axis.horizontal,
              //     itemCount: controller.readyCardsSourceRepository.length,
              //     separatorBuilder: (context, index) => SizedBox(width: 13.w),
              //     itemBuilder: (context, index) {
              //       final card = controller.readyCardsSourceRepository[index];
              //       return GestureDetector(
              //           onTap: () {
              //             Get.to(() => ReadyCardPreview(card: card));
              //           },
              //           child: SizedBox(
              //             width: 165.w,
              //             height: 145.h,
              //             child: ReadyCard(
              //               card: card,
              //               onAddTap: () {
              //                 Get.to(() => ReadyCardPreview(card: card));
              //               },
              //             ),
              //           ));
              //     },
              //   );
        }
      ),
    );
  }
}

class ShopSpecials extends StatelessWidget {
  const ShopSpecials({
    super.key,
  });

  Color get textColor => Get.isDarkMode ? Colors.white : Color(0xFF222A40);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 343.w,
          // height: 271.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  // color: Get.isDarkMode
                  //   ? Colors.grey[900]
                  //   : const Color(0xFFF9F9FB),
                  color: Get.isDarkMode ? Theme.of(context).cardColor : const Color(0xFFF9F9FB),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.w, color: Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 59.w,
                      height: 59.w,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 59.w,
                              height: 59.w,
                              decoration: ShapeDecoration(
                                color: Get.isDarkMode ? Colors.white.withOpacity(.05) : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              left: 11.w,
                              top: 12.w,
                              child: SvgPicture.asset(
                                'assets/icons/hand-card.svg',
                                width: 36.w,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'feature_1'.tr,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'feature_1_msg'.tr,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  // color: Get.isDarkMode
                  //   ? Colors.grey[900]
                  //   : const Color(0xFFF9F9FB),
                  color: Get.isDarkMode ? Theme.of(context).cardColor : const Color(0xFFF9F9FB),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.w, color: Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 59.w,
                      height: 59.w,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 59.w,
                              height: 59.w,
                              decoration: ShapeDecoration(
                                color: Get.isDarkMode ? Colors.white.withOpacity(.05) : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 11.w,
                            top: 12.h,
                            child: SvgPicture.asset(
                              'assets/icons/tabler_cards.svg',
                              width: 36.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'feature_2'.tr,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'feature_2_msg'.tr,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  // color: Get.isDarkMode
                  //   ? Colors.grey[900]
                  //   : const Color(0xFFF9F9FB),
                  color: Get.isDarkMode ? Theme.of(context).cardColor : const Color(0xFFF9F9FB),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.w, color: Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 59.w,
                      height: 59.w,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 59.w,
                              height: 59.w,
                              decoration: ShapeDecoration(
                                color: Get.isDarkMode ? Colors.white.withOpacity(.05) : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 11.w,
                            top: 12.h,
                            child: SvgPicture.asset(
                              'assets/icons/secure-signin.svg',
                              width: 36.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'feature_3'.tr,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'feature_3_msg'.tr,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HomeBanner extends StatelessWidget {
  const HomeBanner({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 343.w,
          height: 223.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 343.w,
                height: 223.h,
                decoration: ShapeDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/banner.png"),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              Positioned(
                top: 77.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'home_body'.tr,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'home_desc'.tr,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,  
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 157.h,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.to(() => const Scaffold(body: CardsPage(initialTab: CardType.custom)));
                    // appNavigationKey.currentState?.changeSelectedTab(Pages.cards);
                    // cardsPageKey.currentState?.changeTab(CardType.readyToUse);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'custom_a_gift'.tr,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFF222A40),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StoresScrolle extends StatelessWidget {
  const StoresScrolle({super.key, this.items});

  final List<Widget>? items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider(
        disableGesture: false,
        options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 2000),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          // height: 60,
          enlargeFactor: 0,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          viewportFraction: MediaQuery.of(context).size.width > 600 ? 0.2 : 1 / 3,
          aspectRatio: MediaQuery.of(context).size.width > 600 ? 10 : 4.4,
        ),
        items: items,
      ),
    );
  }
}

class TitledCard extends StatelessWidget {
  final Widget? content;
  final double? height, width;
  final String? title;
  final Function()? onTap;
  final EdgeInsets? margin;

  const TitledCard({
    super.key,
    this.height,
    this.width,
    this.content,
    this.title,
    this.onTap,
    this.margin
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: content
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20)
            ),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                title ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}