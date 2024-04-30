import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cards/widgets/custom_card.dart';
import 'package:giveagift/view/widgets/gift_card.dart';

enum CustomCardStep {
  color,
  shape,
  store,
  messageAndPrice,
  reciverInfo,
}

class CustomCardPage extends StatefulWidget {
  const CustomCardPage({
    super.key,
    required this.controller,
  });

  final CardsController controller;

  @override
  State<CustomCardPage> createState() => _CustomCardPageState();
}

class _CustomCardPageState extends State<CustomCardPage> {
  Color? color;
  String? backgroundImage, brandImage, message,  price;
  CustomCardStep currentStep = CustomCardStep.color;
  CardSide cardSide = CardSide.front;

  String _fontFamily = 'Default';

  String? get fontFamily {
    if(_fontFamily == 'Default') {
      return null;
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
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  Map<Color, TextStyle> messageColorStyles = {
    Colors.white: const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    Colors.black: const TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
  };

  void onStepChanged(CustomCardStep step) {
    setState(() {
      currentStep = step;

      if(currentStep == CustomCardStep.messageAndPrice) {
        cardSide = CardSide.back;
      } else {
        cardSide = CardSide.front;
      }
    });
  }

  Widget buildStepContent(CustomCardStep step) {
    if(widget.controller.customSubmissionState is Submitting) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if(widget.controller.customSubmissionState is SubmissionError) {
      return Center(
        child: Column(
          children: [
            Text(
              (widget.controller.customSubmissionState as SubmissionError).exception?.message ?? 'حدث خطأ ما',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.red
              ),
            ),
            const SizedBox(height: 10),
            CupertinoButton(
              onPressed: () {
                widget.controller.fetchCustomCards();
              },
              child: Text(
                'retry'.tr,
                style: Theme.of(context).textTheme.bodyLarge
              ),
            ),
          ],
        ),
      );
    }
    
    switch (step) {
      case CustomCardStep.color:
        return ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 200,
            maxWidth: 500,
          ),
          child: CustomColorChooser(
            onColorSelected: (c) {
              setState(() {
                color = c;
              });
            },
          ),
        );
      case CustomCardStep.shape:
        final shapes = widget.controller.customCardsResponse!.shapes;

        if(shapes.isEmpty) {
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

        return Wrap(
          children: [
            for(final shape in shapes)
              if(shape != null)
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: MediaQuery.of(context).size.width > 600 ? 400 : 300,
                  height: MediaQuery.of(context).size.width > 600 ? 230 : 180,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                      ? Colors.grey[900]!
                      : Colors.grey[200],
                    border: shape == backgroundImage
                      ? Border.all(
                          color: Colors.blue,
                          width: 2,
                        )
                      : Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        backgroundImage = shape;
                      });
                    },
                    child: CachedNetworkImage(
                      imageUrl: shape,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator.adaptive()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                )
          ],
        );
      case CustomCardStep.store:
        final stores = widget.controller.customCardsResponse?.logoWithoutBackgroundUrls;

        if(stores!.isEmpty) {
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

        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 8 : 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: [
            for(final store in stores)
              if(store != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInToLinear,
                  padding: store == brandImage ? const EdgeInsets.all(5) : const EdgeInsets.all(0),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    border: store == brandImage
                      ? Border.all(
                          color: Colors.blue,
                          width: 2,
                        )
                      : Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    shape: BoxShape.circle,
                  ),
                  width: store == brandImage ? 70 : 60,
                  height: store == brandImage ? 70 : 60,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          brandImage = store;
                        });
                      },
                      child: CachedNetworkImage(
                        imageUrl: store,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator.adaptive()),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                )
          ],
        );
      case CustomCardStep.messageAndPrice:
        return Column(
          children: [
            const Text(
              'الرسالة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 200,
                  maxWidth: 500,
                ),
                child: CupertinoTextField(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  maxLines: 6,
                  style: TextStyle(
                    color: Get.isDarkMode
                      ? Colors.white
                      : Colors.black,
                    fontSize: 16,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(60),
                  ],
                  onChanged: (value) {
                    setState(() {
                      message = value;
                    });
                  },
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                      ? Colors.grey[900]!
                      : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),  
                ),
              ),
            ),
            const SizedBox(height: 10),
            // price
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(final color in messageColorStyles.keys)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStyle = messageColorStyles[color]!;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: color,
                        border: selectedStyle.color == color
                          ? Border.all(
                              color: Colors.blue,
                              width: 2,
                            )
                          : Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Aa',
                          style: selectedStyle.copyWith(
                            color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                          )
                        ),
                      ),
                    ),
                  ),
                  // select font family
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.text_fields_rounded,
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            title: const Text('اختر نوع الخط'),
                            actions: [
                              for(final family in fontFamilies)
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _fontFamily = family;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox.shrink(),
                                      Text(family),
                                      if(family == _fontFamily)
                                        const Icon(
                                          Icons.check,
                                          color: Colors.blue,
                                        )
                                      else
                                        const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    )
                  ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'السعر',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 50,
                    maxWidth: 500,
                  ),
                  child: CupertinoTextField(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    maxLines: 1,
                    style: TextStyle(
                      color: Get.isDarkMode
                        ? Colors.white
                        : Colors.black,
                      fontSize: 16,
                    ),
                    // fit Container height with parent
                    suffix: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'SAR',
                        style: TextStyle(
                          color: Get.isDarkMode
                            ? Colors.grey[400]
                            : Colors.grey[600],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5),
                    ],
                    onChanged: (value) {
                      setState(() {
                        price = value;
                      });
                    },
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                        ? Colors.grey[900]!
                        : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),  
                  ),
                ),
              ),
            ),
          ],
        );
      case CustomCardStep.reciverInfo:
      // get reciver name and number for +966
        return Column(
          children: [
            const Text(
              'معلومات المستلم',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 50,
                  maxWidth: 500,
                ),
                child: CupertinoTextField(
                  placeholder: 'اسم المستلم',
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  maxLines: 1,
                  style: TextStyle(
                    color: Get.isDarkMode
                      ? Colors.white
                      : Colors.black,
                    fontSize: 16,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                  ],
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                      ? Colors.grey[900]!
                      : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),  
                ),
              ),
            ), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 50,
                  maxWidth: 500,
                ),
                child: CupertinoTextField(
                  placeholder: 'رقم الجوال',
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  maxLines: 1,
                  style: TextStyle(
                    color: Get.isDarkMode
                      ? Colors.white
                      : Colors.black,
                    fontSize: 16,
                  ),
                  prefix: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '+966',
                      style: TextStyle(
                        color: Get.isDarkMode
                          ? Colors.grey[400]
                          : Colors.grey[600],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                      ? Colors.grey[900]!
                      : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),  
                ),
              ),
            ),
            const SizedBox(height: 10),
            // submit button
            CupertinoButton(
              onPressed: () {
                // TODO: submit custom card
              },
              color: Colors.blue,
              child: const Text(
                'إرسال',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
    }
  }

  String getStepTitle(CustomCardStep step) {
    switch (step) {
      case CustomCardStep.color:
        return 'اختر لون البطاقة';
      case CustomCardStep.shape:
        return 'اختر شكل البطاقة';
      case CustomCardStep.store:
        return 'اختر المتجر';
      case CustomCardStep.messageAndPrice:
        return 'املآ الرسالة والسعر';
      case CustomCardStep.reciverInfo:
        return 'معلومات المستلم';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardsController>(
      init: widget.controller,
      id: CardType.custom.name,
      builder: (controller) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CustomCard(
              color: color,
              backgroundImage: backgroundImage,
              brandImage: brandImage,
              textStyle: selectedStyle.copyWith(
                fontFamily: fontFamily,
              ),
              message: message,
              price: price,
              showOnly: cardSide,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 600
                ? MediaQuery.of(context).size.width * .25
                : 10,
            ),
            child: EasyStepper(
                  activeStep: currentStep.index,
                  fitWidth: MediaQuery.of(context).size.width <= 600,
                  steppingEnabled: false,
                  finishedStepBorderType: BorderType.normal,
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  disableScroll: MediaQuery.of(context).size.width > 600 ? true : false,
                  lineStyle: LineStyle(
                    // lineSpace: 1,
                    lineType: LineType.normal,
                    unreachedLineColor: Colors.grey.withOpacity(0.5),
                    finishedLineColor: const Color.fromRGBO(65, 84, 123, 1),
                    activeLineColor: Colors.grey.withOpacity(0.5),
                  ),
                  // activeStepBorderColor: Color.fromRGBO(65, 84, 123, 1),
                  activeStepIconColor: const Color.fromRGBO(65, 84, 123, 1),
                  activeStepTextColor: const Color.fromRGBO(65, 84, 123, 1),
                  activeStepBackgroundColor: Colors.white,
                  unreachedStepBackgroundColor:Colors.transparent,
                  // unreachedStepBorderColor:Colors.grey,
                  unreachedStepIconColor: Colors.grey,
                  unreachedStepTextColor: Colors.grey.withOpacity(0.5),
                  finishedStepBackgroundColor: const Color.fromRGBO(65, 84, 123, 1),
                  // finishedStepBorderColor: Colors.grey.withOpacity(0.5),
                  finishedStepIconColor: Colors.white,
                  finishedStepTextColor: Colors.white,
                  // borderThickness: 10,
                  internalPadding: 0,
                  showLoadingAnimation: false,
                  onStepReached: (index) => setState(() => currentStep = CustomCardStep.values[index]),
                  steps: [
                    for(final step in CustomCardStep.values)
                      EasyStep(
                        icon: currentStep.index >= step.index
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24,
                            )
                          : const Icon(
                            Icons.circle,
                            color: Colors.grey,
                            size: 24,
                          ),
                        customTitle: Text(
                          getStepTitle(step),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    buildStepContent(currentStep),
                    if(controller.customSubmissionState is SubmissionSuccess)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if(currentStep != CustomCardStep.color)
                            IconButton(
                              onPressed: () {
                                onStepChanged(CustomCardStep.values[currentStep.index - 1]);
                              },
                              icon: Icon(
                                Icons.adaptive.arrow_back_rounded,
                              ),
                            )
                          else
                            const SizedBox(),
                          if(currentStep != CustomCardStep.reciverInfo)
                            IconButton(
                              onPressed: () {
                                onStepChanged(CustomCardStep.values[currentStep.index + 1]);
                              },
                              icon: Icon(
                                Icons.adaptive.arrow_forward_rounded,
                              ),
                            )
                          else
                            const SizedBox(),
                        ],
                      )
                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}

class CustomColorChooser extends StatefulWidget {
  const CustomColorChooser({
    super.key,
    required this.onColorSelected,
  });

  final Function(Color) onColorSelected;

  @override
  State<CustomColorChooser> createState() => _CustomColorChooserState();
}

class _CustomColorChooserState extends State<CustomColorChooser> {
  final colors = Colors.primaries;
  Color selected = Colors.primaries.first;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for(final color in colors)
          GestureDetector(
            onTap: () {
              setState(() {
                selected = color;
              });
              widget.onColorSelected(color);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInToLinear,
              width: color == selected ? 60 : 50,
              height: color == selected ? 60 : 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
      ]
    );
  }
}