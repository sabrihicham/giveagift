import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:giveagift/app_navigation.dart';
import 'package:giveagift/constants/enums.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/dialog_utils.dart';
import 'package:giveagift/core/utiles/loading_overlay.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cards/widgets/ready_card.dart';
import 'package:giveagift/view/cart/cart.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';
import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/cart/recepient_info.dart';
import 'package:giveagift/view/profile/update_profile.dart';
import 'package:giveagift/view/widgets/global_text_field.dart';
import 'package:giveagift/view/widgets/my_flip_card.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ReadyToUsePage extends StatelessWidget {
  const ReadyToUsePage({
    super.key,
    required this.controller,
    this.hideAppBar = false,
    this.title
  });

  final CardsController controller;
  final bool hideAppBar;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    return Padding(
      padding: EdgeInsets.only(
        top: hideAppBar ? 0 : MediaQuery.of(context).padding.top
      ),
      child: GetBuilder<CardsController>(
        init: controller,
        id: CardType.readyToUse.name,
        builder: (controller) => Column(children: [
          if (!hideAppBar)
            SizedBox(
                width: double.infinity,
                height: 100,
                child: Stack(
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
                    Center(
                      child: Text(
                        title ?? 'cards_title_msg'.tr,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: !hideAppBar,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Filter by price in range
                        showBottomSheet(
                            context: context,
                            // isDismissible: false,
                            showDragHandle: true,
                            enableDrag: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              return ReadyCardFilter(
                                controller: controller,
                              );
                            });
                      },
                      child: Row(
                        children: [
                          Text(
                            'filter'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.filter_alt_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  '${'cards'.tr} ${controller.readyCardsSourceRepository.length}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Add line
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 0),
            width: double.infinity,
            color: Colors.grey[400],
          ),
          Flexible(
            child: Container(
              color: Get.isDarkMode ? Colors.black : null,
              child: Container(
                color: Get.isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white,
                child: LoadingMoreList(
                  ListConfig<CardData>(
                    itemBuilder: (context, item, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.w/2, vertical: 12.h/2),
                        child: ReadyCard(
                          card: item,
                          shopId: item.shop!.id,
                          onAddTap: () async {
                            cartController.addSpecialCardToCartView(item.shop!.id, item, context);
                          },
                        ),
                      );
                    },
                    addAutomaticKeepAlives: true,
                    sourceList: controller.readyCardsSourceRepository,
                    lastChildLayoutType: LastChildLayoutType.fullCrossAxisExtent,
                    indicatorBuilder: (context, status) {
                      if (status == IndicatorStatus.none) {
                        return const SizedBox.shrink();
                      } else if (status == IndicatorStatus.loadingMoreBusying) {
                        return Center(
                          child: Column(
                            children: [
                              const CircularProgressIndicator.adaptive(),
                              Text(
                                'Loading more',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        );
                      } else if (status == IndicatorStatus.fullScreenBusying) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator.adaptive(),
                              const SizedBox(height: 10),
                              Text(
                                'Loading...',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        );
                      } else if (status == IndicatorStatus.error) {
                        return const Center(
                          child: Text('Error loading data'),
                        );
                      } else if (status == IndicatorStatus.fullScreenError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error loading data',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 10),
                              CupertinoButton(
                                // color: Color.fromRGBO(65, 84, 123, 1),
                                // color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  controller.readyCardsSourceRepository.refresh();
                                },
                                child: Text(
                                  'Retry',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (status == IndicatorStatus.noMoreLoad) {
                        return const Center(
                          child: Text('No more data'),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                    // horizontal: ((MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width > 600 ? 400 : 300)) / 2) / (MediaQuery.of(context).size.width > 600 ? 3 : 1),
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 3.0,
                        mainAxisSpacing: 3.0,
                        childAspectRatio: 1.10
                        // mainAxisExtent: 320,
                        ),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class ReadyCardFilter extends StatefulWidget {
  const ReadyCardFilter({
    super.key,
    required this.controller,
  });

  final CardsController controller;

  @override
  State<ReadyCardFilter> createState() => _ReadyCardFilterState();
}

class _ReadyCardFilterState extends State<ReadyCardFilter> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width > 600
            ? 500
            : MediaQuery.of(context).size.width * 0.9,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // height: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Center(
              //   child: Container(
              //     width: 50,
              //     height: 5,
              //     decoration: BoxDecoration(
              //       color: Colors.grey[300],
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              // ),
              Text(
                'filter'.tr,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'price'.tr,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    RangeSlider(
                        values: RangeValues(
                          widget.controller.priceRange.start!,
                          widget.controller.priceRange.end!,
                        ),
                        min: 0,
                        max: 1000,
                        onChanged: (RangeValues values) {
                          setState(() {
                            widget.controller.priceRange.start = values.start;
                            widget.controller.priceRange.end = values.end;
                          });
                        },
                        divisions: 4,
                        activeColor: Theme.of(context).primaryColor,
                        overlayColor: WidgetStateProperty.all(
                            Theme.of(context).primaryColor.withOpacity(0.3)),
                        labels: RangeLabels(
                            widget.controller.priceRange.start.toString(),
                            widget.controller.priceRange.end.toString())),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'stores'.tr,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    Wrap(
                      children: widget.controller.brands.map((brand) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: FilterChip(
                            label: Text(brand),
                            selected: widget.controller.selectedBrands
                                .contains(brand),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  widget.controller.selectedBrands.add(brand);
                                } else {
                                  widget.controller.selectedBrands
                                      .remove(brand);
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ]),
              const SizedBox(
                height: 40,
              ),
              SafeArea(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: InkWell(
                    onTap: () {
                      // TODO: Filter cards from source
                      // widget.controller.readyCardsSourceRepository.refresh();

                      widget.controller.filterReadyCardsLocaly();

                      Navigator.pop(context);
                    },
                    child: Text(
                      'apply'.tr,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCartBottomSheet extends StatelessWidget {
  const AddCartBottomSheet({
    super.key,
    required this.item,
    required this.cartController,
  });

  final CardData item;
  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final nameController = TextEditingController();

    final message = ValueNotifier('');

    return TapRegion(
      onTapOutside: (event) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          // color: Get.isDarkMode
          //   ? Colors.grey[900]
          //   : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyFlipCard(card: item.toCard()),
            SizedBox(
                width: double.infinity,
                // height: 100,
                child: Center(
                  child: Text(
                    'reciver_info'.tr,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            GlobalTextField(
              controller: nameController,
              placeholder: 'name'.tr,
            ),
            const SizedBox(height: 20),
            GlobalTextField(
                controller: phoneController,
                placeholder: 'phone_number'.tr,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                prefix: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '+966',
                    style: TextStyle(
                      color:
                          Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
            // error message
            ValueListenableBuilder<String>(
                valueListenable: message,
                builder: (context, value, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  );
                }),
            const SizedBox(height: 20),
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).padding.bottom + 10,
                    horizontal: 20),
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: InkWell(
                  onTap: () async {
                    if (phoneController.text.isEmpty ||
                        nameController.text.isEmpty) {
                      message.value = 'الرجاء إدخال البيانات';
                      return;
                    } else if (!phoneController.text.startsWith('6') &&
                        !phoneController.text.startsWith('5')) {
                      message.value = 'رقم الجوال يجب أن يبدأ بـ 5 أو 6';
                      return;
                    } else if (phoneController.text.length < 9) {
                      message.value = 'رقم الجوال يجب أن يكون 9 أرقام';
                      return;
                    } else {
                      message.value = '';
                    }

                    // send request to server
                    final response = await cartController.addSpecialCardToCart(
                      item.shop!.id,
                      item.price,
                      recipientName: nameController.text,
                      recipientNumber: phoneController.text,
                      receiveAt: null,
                    );

                    Navigator.pop(context);

                    String _message;

                    if (response != null) {
                      if (response.status == "success") {
                        _message = 'add_to_cart_success'.tr;
                      } else {
                        _message = 'add_to_cart_failed'.tr;
                      }
                    } else {
                      if (cartController.submissionStates is SubmissionError) {
                        _message =
                            (cartController.submissionStates as SubmissionError)
                                .exception
                                .message;
                      } else {
                        _message = 'add_to_cart_failed'.tr;
                      }
                    }

                    Get.snackbar(
                      'success'.tr,
                      _message,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 3),
                      margin: const EdgeInsets.all(10),
                      borderRadius: 10,
                      isDismissible: true,
                      dismissDirection: DismissDirection.endToStart,
                      forwardAnimationCurve: Curves.easeOutBack,
                      reverseAnimationCurve: Curves.easeInBack,
                      animationDuration: const Duration(milliseconds: 800),
                      snackStyle: SnackStyle.FLOATING,
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      ),
                    );
                  },
                  child: Text(
                    'add_to_cart'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class SnackBarHelper {
  static void showSnackBar(
      {required String title,
      required String message,
      Color? color,
      String? buttonText,
      Function()? onTapButton}) async {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: DismissDirection.endToStart,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 800),
      snackStyle: SnackStyle.FLOATING,
      mainButton: buttonText != null || onTapButton != null
          ? TextButton(
              onPressed: onTapButton,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  buttonText ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
      ),
    );
  }

  static void reminderSnackBar(String title, String message,
      {Function()? onTextClicked, String buttonLable = 'ok'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor:
          Theme.of(Get.context!).colorScheme.secondary.withOpacity(0.6),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      maxWidth: 600,
      mainButton: TextButton(
        onPressed: onTextClicked,
        child: GlobalButton(
          lable: buttonLable,
        ),
      ),
    );
  }
}
