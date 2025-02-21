import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/app_navigation.dart';
import 'package:giveagift/constants/colors.dart';
import 'package:giveagift/constants/enums.dart';
import 'package:giveagift/core/classes/celebrate.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/extensions/colors.dart';
import 'package:giveagift/core/extensions/web_images.dart';
import 'package:giveagift/core/utiles/dialog_utils.dart';
import 'package:giveagift/core/utiles/loading_overlay.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cards/data/models/color.dart';
import 'package:giveagift/view/cards/pages/ready_card_page.dart';
import 'package:giveagift/view/cards/pages/scroll_to_hide.dart';
import 'package:giveagift/view/cards/widgets/custom_card.dart';
import 'package:giveagift/view/cards/widgets/custom_color_chooser.dart';
import 'package:giveagift/view/cards/widgets/layer.dart';
import 'package:giveagift/view/cards/widgets/recepient_info.dart';
import 'package:giveagift/view/cart/cart.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';
import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/cart/recepient_info.dart';
import 'package:giveagift/view/store/controller/shop_controller.dart';
import 'package:giveagift/view/store/data/model/shop.dart';
import 'package:giveagift/view/widgets/gift_card.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart' hide ColorModel;

enum CustomCardStep {
  color,
  shape,
  shop,
  messageAndPrice,
  reciverInfo,
}

class CustomCardPage extends StatefulWidget {
  const CustomCardPage({super.key, required this.controller, this.shop});

  final CardsController controller;
  final Shop? shop;

  @override
  State<CustomCardPage> createState() => _CustomCardPageState();
}

class _CustomCardPageState extends State<CustomCardPage> {
  MyColor? _color;
  Map<CardShape, ShapeLayer>? _shapes;
  Shop? _shop;

  double messagePosX = 0, messagePosY = 0;

  String phoneBegingin = '966';

  // _formKey
  final _formKey = GlobalKey<FormState>();

  final validationMessage = ValueNotifier('');

  DateTime? receiveAt;
  String? celebrateIcon, celebrateLink;

  bool proCelebrateShapeAlerted = false, proCelebrateLinkAlerted = false;

  final calculateAditionalPriceRebuild = ValueNotifier(0);

  Color headColor = Get.isDarkMode ? Colors.grey.shade900 : Colors.white;

  TextEditingController message = TextEditingController(),
      price = TextEditingController(),
      reciverName = TextEditingController(),
      reciverPhone = TextEditingController();

  CustomCardStep currentStep = CustomCardStep.color;
  CardSide cardSide = CardSide.front;

  String _fontFamily = 'Default';

  String? get fontFamily {
    if (_fontFamily == 'Default') {
      return Theme.of(context).textTheme.bodyLarge?.fontFamily;
    }
    return _fontFamily;
  }

  List<String> fontFamilies = <String>[
    'Default',
    'Noto Sans Arabic',
    'Amiri',
    'Cairo',
  ];

  TextStyle selectedStyle = const TextStyle(
    color: Colors.white,
    fontSize: 40,
    fontWeight: FontWeight.w400,
  );

  @override
  void initState() {
    _shop = widget.shop;
    super.initState();
  }

  void reset() {
    _color = null;
    _shapes = null;
    if (widget.shop == null) {
      _shop = null;
    }
    message.clear();
    price.clear();
    reciverName.clear();
    reciverPhone.clear();
    _fontFamily = 'Default';
    selectedStyle = const TextStyle(
      color: Colors.white,
      fontSize: 40,
      fontWeight: FontWeight.w400,
    );
    validationMessage.value = '';
    currentStep = CustomCardStep.color;
    cardSide = CardSide.front;
  }

  void onStepForward() {
    if (currentStep == CustomCardStep.messageAndPrice) {
      if (message.value.text.isEmpty) {
        validationMessage.value = 'empty_message'.tr;
        return;
      } else if (price.value.text.isEmpty) {
        validationMessage.value = 'empty_price'.tr;
        return;
      } else if (int.parse(price.value.text) < 20) {
        validationMessage.value = '${'min_price'.tr} 20';
        return;
      }

      validationMessage.value = '';
    }

    if (currentStep.index == CustomCardStep.shop.index - 1 &&
        widget.shop != null) {
      onStepChanged(CustomCardStep.values[currentStep.index + 2]);
    } else {
      if (currentStep == CustomCardStep.shop && _shop == null) {
        return;
      }

      onStepChanged(CustomCardStep.values[currentStep.index + 1]);
    }
  }

  void onStepChanged(CustomCardStep step) {
    setState(() {
      currentStep = step;

      if (currentStep == CustomCardStep.messageAndPrice) {
        cardSide = CardSide.back;
      } else {
        cardSide = CardSide.front;
      }
    });
  }

  void _alertProItem(String message) {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      '',
      message,
      snackPosition: SnackPosition.TOP,
      borderWidth: 1,
      barBlur: 10,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.only(top: 10),
      maxWidth: 600,
      borderRadius: 0,
      backgroundColor: Theme.of(context).primaryColor,
      titleText: const SizedBox.shrink(),
      messageText: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.info,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 3),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.blue.withOpacity(0.2),
                color: Colors.blue,
              );
            },
          )
        ],
      ),
      duration: const Duration(seconds: 3),
    );
  }

  Widget buildStepContent(CustomCardStep step) {
    switch (step) {
      case CustomCardStep.color:
        return GetBuilder<CardsController>(
            init: widget.controller,
            id: step.name,
            builder: (controller) {
              if (controller.colorsState is Submitting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (controller.colorsState is SubmissionError) {
                return Center(
                  child: Column(
                    children: [
                      Text(
                        (controller.colorsState as SubmissionError)
                            .exception
                            .message,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      CupertinoButton(
                        onPressed: () {
                          controller.fetchColors();
                        },
                        child: Text(
                          'retry'.tr,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                );
              }

              List<MyColor> colors = [
                ...controller.colorsResponse!.data.proColors,
                ...controller.colorsResponse!.data.colors,
              ];

              if (colors.isEmpty) {
                return const Center(
                  child: Text(
                    'لا يوجد ألوان متاحة',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 700,
                ),
                child: CustomColorChooser(
                  colors: colors,
                  selected: _color,
                  onColorSelected: (c) {
                    // if (c is ProColor) {
                    //   _alertProItem('${'pro_color_info'.tr} ${(c).price} ${'sar'.tr}');
                    // }
                    setState(() {
                      _color = c;
                    });
                  },
                ),
              );
            });
      case CustomCardStep.shape:
        return GetBuilder<CardsController>(
          init: widget.controller,
          id: step.name,
          builder: (controller) {
            if (widget.controller.shapesState is Submitting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (controller.shapesState is SubmissionError) {
              return Center(
                child: Column(
                  children: [
                    Text(
                      (controller.shapesState as SubmissionError).exception.message,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    CupertinoButton(
                      onPressed: () {
                        controller.fetchShapes();
                      },
                      child: Text(
                        'retry'.tr,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              );
            }

            final shapes = widget.controller.shapesResponse!.shaps;

            shapes.sort((a, b) => a.priority?.compareTo(b.priority ?? 0) ?? -1);

            if (shapes.isEmpty) {
              return const Center(
                child: Text(
                  'لا يوجد أشكال متاحة',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            final iconSize =
                MediaQuery.of(context).size.width > 600 ? 32.0 : 24.0;

            return ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.w,
                  // childAspectRatio: 16 / 9,
                ),
                children: [
                  for (final shape in shapes)
                    Badge(
                      label: SvgPicture.asset(
                        'assets/icons/pro.svg',
                        width: iconSize,
                        height: iconSize,
                        color: ConstColors.gold,
                      ),
                      alignment: const Alignment(-1, -1),
                      largeSize: iconSize,
                      backgroundColor: Colors.transparent,
                      isLabelVisible: shape.price != null && shape.price! > 0,
                      child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        width: MediaQuery.of(context).size.width > 600 ? 400 : 300,
                        height: MediaQuery.of(context).size.width > 600 ? 230 : 180,
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            _shapes ??= {};
                            final initScale = 0.3;

                            final cardShape = CardShape(
                              shape: shape,
                              scale: initScale,
                              position: Position(
                                x: (_cardKey.currentContext?.size?.width ?? 0) / 2,
                                y: (_cardKey.currentContext?.size?.height ?? 0) / 2,
                              ),
                            );

                            _shapes![cardShape] = ShapeLayer(cardShape: cardShape)
                              ..isSelected.value = true;

                            _rebuildCard.value++;

                            calculateAditionalPriceRebuild.value++;
                          },
                          // check if svg
                          child: RegExp(r'.svg').hasMatch(shape.image.shapeImage)
                            ? SvgPicture.network(
                                shape.image.shapeImage,
                                fit: BoxFit.fitHeight,
                                placeholderBuilder: (context) => const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: shape.image.shapeImage,
                                fit: BoxFit.fitHeight,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                                errorWidget: (context, url, error) =>
                                    GestureDetector(
                                  onTap: () {},
                                  child: const Icon(Icons.error),
                                ),
                              ),
                        ),
                      ),
                    )
                ],
              ),
            );
          },
        );
      case CustomCardStep.shop:
        final shopController = Get.find<ShopController>();

        if (shopController.defaultState is Submitting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (shopController.defaultState is SubmissionError) {
          return Center(
            child: Column(
              children: [
                Text(
                  (shopController.defaultState as SubmissionError)
                      .exception
                      .message,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.red),
                ),
                const SizedBox(height: 10),
                CupertinoButton(
                  onPressed: () {
                    shopController.fetchShops();
                  },
                  child: Text(
                    'retry'.tr,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          );
        }

        final shops = shopController.shops[shopController.page];

        if (shops!.isEmpty) {
          return const Center(
            child: Text(
              'لا يوجد متاجر متاحة',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            children: [
              for (final shop in shops)
                Container(
                  // duration: const Duration(milliseconds: 300),
                  // curve: Curves.easeInToLinear,
                  // padding: shop == _shop
                  //     ? EdgeInsets.all(13.w)
                  //     : EdgeInsets.all(8.w),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  // width: shop == _shop ? 70 : 60,
                  // height: shop == _shop ? 70 : 60,
                  child: Container(
                    width: 60,
                    height: 60,
                    clipBehavior: Clip.antiAlias,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      // color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[200],
                      color: Color(0xDDF9F9F9),
                      // shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _shop = shop == _shop ? null : shop;
                        });
                      },
                      child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: shop == _shop
                              ? Border.all(
                                  color: Colors.blue,
                                  width: 3,
                                  strokeAlign: BorderSide.strokeAlignOutside)
                              : null,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: shop.logo.shopImage,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        );
      case CustomCardStep.messageAndPrice:
        return ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 700,
                    ),
                    child: GlobalOutlineTextFeild(
                      controller: message,
                      title: 'message'.tr,
                      maxLines: 5,
                      onChanged: (value) => setState(() {}),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(60),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Font size
                OutlineContainer(
                  height: 52.h,
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  title: "font_size".tr,
                  radius: 11.r,
                  child: InkWell(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              selectedStyle.fontSize?.toInt().toString() ?? '',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.black,
                          size: 32,
                        ),
                      ],
                    ),
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 500,
                            maxWidth: 600,
                          ),
                          child: CupertinoActionSheet(
                            title: const Text('اختر حجم الخط'),
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('إلغاء'),
                            ),
                            actions: [
                              for (final size in [
                                for (int i = 25; i <= 40; i++) i
                              ])
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      selectedStyle = selectedStyle.copyWith(
                                        fontSize: size.toDouble(),
                                      );
                                    });
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if (size == selectedStyle.fontSize)
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      Text(size.toString()),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15.h),
                // select font family
                OutlineContainer(
                    height: 52.h,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    title: "font_type".tr,
                    radius: 11.r,
                    child: InkWell(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _fontFamily,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.black,
                            size: 32,
                          ),
                        ],
                      ),
                      onTap: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 600,
                            ),
                            child: CupertinoActionSheet(
                              title: const Text('اختر نوع الخط'),
                              actions: [
                                for (final family in fontFamilies)
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        _fontFamily = family;
                                      });
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        if (family == _fontFamily)
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        Text(family),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
                const SizedBox(height: 20),
                // Color
                OutlineContainer(
                  height: 52.h,
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  // padding: EdgeInsets.symmetric(horizontal: 16.w),
                  title: "color".tr,
                  radius: 11.r,
                  child: InkWell(
                    child: Container(
                      color: selectedStyle.color,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          Color? pickedColor;
                          return AlertDialog(
                            title: const Text('Pick a color!'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: Colors.white,
                                onColorChanged: (color) {
                                  pickedColor = color;
                                },
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('Got it'),
                                onPressed: () {
                                  if (pickedColor != null) {
                                    setState(() {
                                      selectedStyle = selectedStyle.copyWith(
                                        color: pickedColor,
                                      );
                                    });
                                  }
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 15.h),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 700,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: GlobalOutlineTextFeild(
                                controller: price,
                                title: 'price'.tr,
                                height: 52.h,
                                textAlignVertical: TextAlignVertical.center,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                expands: true,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            OutlineContainer(
                              height: 52.h,
                              width: 67.w,
                              radius: 11.r,
                              child: Center(
                                child: Text(
                                  'sar'.tr,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                ),
                // error message
                ValueListenableBuilder<String>(
                    valueListenable: validationMessage,
                    builder: (context, value, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        );
      case CustomCardStep.reciverInfo:
        // get reciver name and number for +966

        return SafeArea(
            top: false,
            child: RecepientInfo(
              recepientNameConntroller: reciverName,
              recepientPhoneController: reciverPhone,
              onPhoneBegingin: (phoneBegingin) => this.phoneBegingin = phoneBegingin,
              onTimeChange: (time) => receiveAt = time,
              formKey: _formKey,
              onCelebrateIconChange: (celebrateIcon) {
                setState(() {
                  this.celebrateIcon = celebrateIcon;
                });

                // if (!proCelebrateShapeAlerted) {
                //   proCelebrateShapeAlerted = true;
                //   _alertProItem('${'celebration_shape_info'.tr} ${SharedPrefs.instance.appConfig?.celebrateIconPrice} ${'sar'.tr}');
                // }

                Celebrate.instance.celebrate(
                  context,
                  celebrateTypeFromString(celebrateIcon!),
                  MediaQuery.of(context).size.width > 600,
                  all: false,
                );
                // Isolate.run(() {
                // });
              },
              onCelebrateLinkChange: (celebrateLink) {
                setState(() {
                  this.celebrateLink = celebrateLink;
                });

                // if (!proCelebrateLinkAlerted) {
                //   proCelebrateLinkAlerted = true;
                //   _alertProItem('${'celebration_link_info'.tr} ${SharedPrefs.instance.appConfig!.celebrateIconPrice} ${'sar'.tr}');
                // }
              },
              submitTitle: 'add_to_cart'.tr,
            ));
    }
  }

  String getStepTitle(CustomCardStep step) {
    switch (step) {
      case CustomCardStep.color:
        return 'color'.tr;
      case CustomCardStep.shape:
        return 'shape'.tr;
      case CustomCardStep.shop:
        return 'shop'.tr;
      case CustomCardStep.messageAndPrice:
        return 'message'.tr;
      case CustomCardStep.reciverInfo:
        return 'reciver_info'.tr;
    }
  }

  final GlobalKey _cardKey = GlobalKey<CustomCardState>();

  final _rebuildCard = ValueNotifier<int>(0);

  final _scrollConstroller = ScrollController();

  String calculateAditionalPrice() {
    final proColorPrice = _color is ProColor ? (_color as ProColor).price : 0;
    final proShape = _shapes?.entries.fold(0.0, (prev, element) => prev + (element.key.shape.price ?? 0)) ?? 0;
    final celebrationIconPrice = celebrateIcon != null && celebrateIcon!.isNotEmpty
      ? SharedPrefs.instance.appConfig?.celebrateIconPrice ?? 0 : 0;
    final celebrationLinkPrice = celebrateLink != null && celebrateLink!.isNotEmpty
      ? SharedPrefs.instance.appConfig?.celebrateLinkPrice ?? 0 : 0;

    return (proColorPrice! + proShape + celebrationIconPrice + celebrationLinkPrice).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GetBuilder(
          init: widget.controller,
          id: CustomCardStep.color.name,
          builder: (controller) {
            return controller.colorsState is! SubmissionSuccess
              ? const SizedBox.shrink()
              : ScrollToHide(
                  scrollController: _scrollConstroller,
                  hideDirection: Axis.vertical,
                  height: 102.h,
                  child: Container(
                    width: 375.w,
                    height: 102.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Get.isDarkMode
                            ? Colors.grey.shade700.withOpacity(0.3)
                            : Color(0x3FDDDDDD),
                          blurRadius: 6.30,
                          offset: Offset(0, -2),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 343.w,
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (currentStep != CustomCardStep.color)
                                Expanded(
                                  child: Container(
                                    height: 57.h,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 15.h,
                                    ),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFBFBFBF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                    ),
                                    child: CupertinoButton(
                                      onPressed: () {
                                        if (currentStep.index == CustomCardStep.shop.index + 1 && widget.shop != null) {
                                          onStepChanged(CustomCardStep.values[currentStep.index - 2]);
                                        } else {
                                          onStepChanged(CustomCardStep.values[currentStep.index - 1]);
                                        }
                                      },
                                      padding: EdgeInsets.zero,
                                      child: Text(
                                        'previous'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              // if (currentStep != CustomCardStep.color)
                              Container(
                                width: 55.w,
                                height: 30.h,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                ),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(5.r)),
                                child: ValueListenableBuilder(
                                    valueListenable: calculateAditionalPriceRebuild,
                                    builder: (context, value, _) {
                                      return FittedBox(
                                        child: Text(
                                          '${calculateAditionalPrice()} ${'sar'.tr}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }),
                              ),
                              // if (currentStep != CustomCardStep.reciverInfo)
                              Expanded(
                                child: Container(
                                  height: 57.h,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.h,
                                    vertical: 15.h,
                                  ),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF222A40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: CupertinoButton(
                                    onPressed: () async {
                                      if (currentStep != CustomCardStep.messageAndPrice) {
                                        onStepForward();
                                      } else {
                                        // TODO Verifiy with form validator
                                        if (!(_formKey.currentState?.validate() ?? true)) {
                                          return;
                                        }

                                        final isLogedIn = await DialogUtils.askForLogin(context);

                                        if (!isLogedIn) {
                                          return;
                                        }

                                        final cartController = Get.find<CartController>();
                                        CreateCardResponse? response;

                                        await OverlayUtils.showLoadingOverlay(
                                          asyncFunction: () async {
                                            response = await cartController.addCustomCardToCart(
                                              CreateCardData(
                                                isSpecial: false,
                                                color: _color is ColorModel ? _color!.id : null,
                                                proColor: _color is ProColor ? _color!.id : null,
                                                shapes: _shapes?.keys.map((e) {
                                                  final layer = _shapes![e]!;
                                                  return CreateCardShapeData(
                                                    shape: e.shape.id,
                                                    position: Position(
                                                      x: layer.position.x,
                                                      y: layer.position.y,
                                                    ),
                                                    rotation: layer.rotation * 180 / pi,
                                                    scale: layer.scale,
                                                  );
                                                }).toList(),
                                                shop: _shop!.id,
                                                text: CardText(
                                                  message: message.text,
                                                  fontFamily: fontFamily,
                                                  fontColor: selectedStyle.color?.hex,
                                                  fontSize: selectedStyle.fontSize,
                                                  fontWeight: selectedStyle.fontWeight?.value,
                                                  xPosition: messagePosX,
                                                  yPosition: messagePosY,
                                                ),
                                                price: Price(
                                                  value: num.parse(price.text),
                                                  fontFamily: fontFamily,
                                                  fontSize: selectedStyle.fontSize,
                                                  fontColor: selectedStyle.color?.hex,
                                                  fontWeight: selectedStyle.fontWeight?.value,
                                                ),
                                                // receiveAt: receiveAt,
                                                // recipient: Recipient(
                                                //   name: reciverName.text,
                                                //   whatsappNumber: '$phoneBegingin${reciverPhone.text}',
                                                // ),
                                                // celebrateIcon: celebrateIcon,
                                                // celebrateLink: celebrateLink
                                              ),
                                            );
                                          },
                                        );

                                        bool success = false;
                                        String _message = '';

                                        if (cartController.customCardState is SubmissionSuccess) {
                                          // Get.back();
                                          Navigator.of(context).pop();

                                          success = true;
                                          _message = 'card_added_successfully'.tr;

                                          appNavigationKey.currentState?.changeSelectedTab(Pages.home);

                                          await Get.to(
                                            () => RecepientInfoPage(
                                              card: Card(
                                                id: response!.data['_id'],
                                                isSpecial: false,
                                                color: _color is ColorModel ? _color as ColorModel : null,
                                                proColor: _color is ProColor ? _color as ProColor: null,
                                                shapes: _shapes?.keys.map((e) {
                                                  final layer = _shapes![e]!;
                                                  return CardShape(
                                                    shape: e.shape,
                                                    position: Position(
                                                      x: layer.position.x,
                                                      y: layer.position.y,
                                                    ),
                                                    rotation: layer.rotation * 180 / pi,
                                                    scale: layer.scale,
                                                  );
                                                }).toList(),
                                                shop: _shop,
                                                text: CardText(
                                                  message: message.text,
                                                  fontFamily: fontFamily,
                                                  fontColor: selectedStyle.color?.hex,
                                                  fontSize: selectedStyle.fontSize,
                                                  fontWeight: selectedStyle.fontWeight?.value,
                                                  xPosition: messagePosX,
                                                  yPosition: messagePosY,
                                                ),
                                                price: Price(
                                                  value: num.parse(price.text),
                                                  fontFamily: fontFamily,
                                                  fontSize: selectedStyle.fontSize,
                                                  fontColor: selectedStyle.color?.hex,
                                                  fontWeight: selectedStyle.fontWeight?.value,
                                                ),
                                            )
                                            , later: true)
                                          );

                                          // setState(() {
                                          //   reset();
                                          // });

                                        } else if (cartController.customCardState is SubmissionError) {
                                          _message = (cartController .customCardState as SubmissionError).exception.message;
                                        }

                                        SnackBarHelper.showSnackBar(
                                          title: success ? 'success'.tr : 'error'.tr,
                                          message: _message,
                                          color: success ? Colors.green : Colors.red,
                                          buttonText: 'view_cart'.tr,
                                          onTapButton: () {
                                            // appNavigationKey.currentState?.changeSelectedTab(Pages.cart);
                                            Get.to(() => CartPage(key: cartPageKey));
                                            Get.closeCurrentSnackbar();
                                          },
                                        );
                                      }
                                    },
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      currentStep.index != CustomCardStep.messageAndPrice.index
                                        ? 'next'.tr
                                        : 'add_to_cart'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
          }),
      body: SingleChildScrollView(
        controller: _scrollConstroller,
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).padding.top,
              color: headColor,
            ),
            Stack(
              children: [
                // menu to open drawer
                // if (MediaQuery.of(context).size.width > 500)
                Container(
                  width: double.infinity,
                  color: headColor,
                  height: 40,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Get.locale?.languageCode == 'ar'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: IconButton(
                            icon: Icon(Icons.adaptive.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Get.back();
                            },
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'custom_a_card'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode
                                ? Theme.of(context).textTheme.titleMedium?.color
                                : Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: GetBuilder<CardsController>(
                    init: widget.controller,
                    id: CustomCardStep.color.name,
                    builder: (controller) => SingleChildScrollView(
                      child: SizedBox(
                        // height: MediaQuery.of(context).size.height < MediaQuery.of(context).size.width && MediaQuery.of(context).size.height < 600
                        //   ? MediaQuery.of(context).size.width
                        //   : MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: double.infinity,),
                            Container(
                              color: headColor,
                              width: double.infinity,
                              constraints: const BoxConstraints(
                                maxWidth: 600
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                              child: ValueListenableBuilder(
                                  valueListenable: _rebuildCard,
                                  builder: (context, value, _) {
                                    return CustomCard(
                                      key: _cardKey,
                                      color: _color is ColorModel
                                          ? (_color as ColorModel).color
                                          : null,
                                      backgroundImage: _color is ProColor
                                          ? (_color as ProColor).image.colorImage
                                          : null,
                                      layers: _shapes?.values.toList(),
                                      brandImage: _shop?.logo.shopImage,
                                      textStyle: selectedStyle.copyWith(
                                        fontFamily: fontFamily,
                                      ),
                                      message: message.text,
                                      messagePosX: 0,
                                      messagePosY: 0,
                                      centerText: true,
                                      price: price.text,
                                      currency: 'sar'.tr,
                                      showOnly: cardSide,
                                      // centerText: true,
                                      onMessageDrag: (x, y, heigh, width) {
                                        messagePosX = x;
                                        messagePosY = y;
                                      },
                                      onDelete: (layer) {
                                        // setState(() {
                                        _shapes?.removeWhere((key, value) => value == layer);
                                        _rebuildCard.value++;
                                        calculateAditionalPriceRebuild.value++;
                                        // });
                                      },
                                    );
                                  }),
                            ),
                            OutlineContainer(
                                // padding: EdgeInsets.symmetric(
                                //   horizontal: MediaQuery.of(context).size.width > 600
                                //     ? MediaQuery.of(context).size.width * .25
                                //     : 10,
                                // ),
                                margin: EdgeInsets.all(10.w),
                                padding: EdgeInsets.all(10.w),
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                        CustomCardStep.values.length - 1,
                                        (index) {
                                          final step = CustomCardStep.values[index];

                                          if (step == CustomCardStep.shop && widget.shop != null) {
                                            return const SizedBox.shrink();
                                          }

                                          return GestureDetector(
                                            onTap: () {
                                              if (currentStep.index > step.index) {
                                                onStepChanged(step);
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 5.w,
                                              ),
                                              decoration: BoxDecoration(
                                                color: currentStep == step
                                                  ? const Color(0xFF222A40)
                                                  : null,
                                                borderRadius: BorderRadius.circular(13.r),
                                              ),
                                              child: Text(
                                                getStepTitle(step),
                                                style: TextStyle(
                                                  color: currentStep == step
                                                    ? Get.isDarkMode
                                                      ? Colors.white
                                                      : Colors.white
                                                    : Get.isDarkMode
                                                      ? Colors.grey
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 700,
                              ),
                              child: OutlineContainer(
                                // width: 343.w,
                                // height: 220.h,
                                margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(
                                  bottom: MediaQuery.of(context).padding.bottom,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    LayoutBuilder(
                                      builder: (context, boxConstraints) {
                                        final content = buildStepContent(currentStep);
                                        return content;
                                        // return SingleChildScrollView(
                                        //   physics: const BouncingScrollPhysics(),
                                        //   child: content,
                                        // );
                                      },
                                    ),
                                    // if (controller.colorsState is SubmissionSuccess)
                                    //   SafeArea(
                                    //     top: false,
                                    //     child: Align(
                                    //       alignment: Alignment.bottomCenter,
                                    //       child: Directionality(
                                    //         textDirection: TextDirection.ltr,
                                    //         child: Row(
                                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //           children: [
                                    //             if (currentStep != CustomCardStep.color)
                                    //               IconButton(
                                    //                 onPressed: () {
                                    //                   onStepChanged(CustomCardStep.values[currentStep.index - 1]);
                                    //                 },
                                    //                 icon: Icon(
                                    //                   Icons.adaptive.arrow_back_rounded,
                                    //                 ),
                                    //               )
                                    //             else
                                    //               const SizedBox(),
                                    //             if (currentStep != CustomCardStep.reciverInfo)
                                    //               IconButton(
                                    //                 onPressed: () {
                                    //                   onStepForward();
                                    //                 },
                                    //                 icon: Icon(
                                    //                   Icons.adaptive.arrow_forward_rounded,
                                    //                 ),
                                    //               )
                                    //             else
                                    //               const SizedBox(),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GlobalContainer extends StatelessWidget {
  const GlobalContainer({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), bottomRight: Radius.circular(10),
        ),
        color: Theme.of(context).primaryColor.withOpacity(0.9),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w600, 
          color: Colors.white,
        ),
      ),
    );
  }
}

class OutlineContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final double radius;
  final Widget? child;
  final EdgeInsets? margin, padding;
  final String? title;
  final Color? borderColor;

  const OutlineContainer(
      {super.key,
      this.height,
      this.width,
      this.child,
      this.margin,
      this.padding,
      this.title,
      this.borderColor,
      this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h).copyWith(
                top: margin?.top, left: margin?.left, right: margin?.right),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                title!,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        Container(
          width: width,
          height: height,
          margin: margin,
          padding: padding,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1,
                  color: borderColor ?? const Color(0xEEEEEEEE),
                  strokeAlign: BorderSide.strokeAlignOutside),
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}

class GlobalOutlineTextFeild extends StatelessWidget {
  final TextEditingController? controller;
  final double? height;
  final String? title;
  final Function(String? value)? onChanged;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool expands;

  const GlobalOutlineTextFeild(
      {super.key,
      this.controller,
      this.height,
      this.title,
      this.onChanged,
      this.maxLines,
      this.inputFormatters,
      this.textAlign = TextAlign.start,
      this.textAlignVertical,
      this.expands = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                title!,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        SizedBox(
          height: height,
          child: CupertinoTextField(
            // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            expands: expands,
            maxLines: maxLines,
            controller: controller,
            keyboardType: TextInputType.text,
            textAlign: textAlign,
            textAlignVertical: textAlignVertical,
            style: TextStyle(
              color: Get.isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
            ),
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.grey[900]! : Colors.white,
              border: Border.all(
                color: Get.isDarkMode
                    ? Colors.grey[700]!
                    : const Color(0xEEEEEEEE),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11.r),
            ),
          ),
        ),
      ],
    );
  }
}

class GlobalOutlineFormTextFeild extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final double? height;
  final String? title;
  final Function(String? value)? onChanged;
  final int? maxLines;
  final Color? color, borderColor;
  final String? Function(String?)? validator;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final List<TextInputFormatter>? inputFormatters;
  final bool expands;

  const GlobalOutlineFormTextFeild(
      {super.key,
      this.controller,
      this.placeholder,
      this.height,
      this.title,
      this.onChanged,
      this.maxLines,
      this.color,
      this.borderColor,
      this.validator,
      this.textAlign = TextAlign.start,
      this.textAlignVertical,
      this.inputFormatters,
      this.expands = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                title!,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        SizedBox(
          height: height,
          child: CupertinoTextFormFieldRow(
            // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: EdgeInsets.zero,
            maxLines: maxLines,
            controller: controller,
            placeholder: placeholder,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Get.isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
            ),
            onChanged: onChanged,
            validator: validator,
            textAlign: textAlign,
            textAlignVertical: textAlignVertical,
            inputFormatters: inputFormatters,
            expands: expands,
            decoration: BoxDecoration(
              // color: Get.isDarkMode ? Colors.grey[900]! : Colors.grey[200],
              color: color,
              border: Border.all(
                color: borderColor ??
                    (Get.isDarkMode
                        ? Colors.grey[700]!
                        : const Color(0xEEEEEEEE)),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11.r),
            ),
          ),
        ),
      ],
    );
  }
}
