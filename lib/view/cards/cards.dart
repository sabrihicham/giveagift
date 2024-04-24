
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cards/widgets/ready_card.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({
    super.key,
    this.initialTab = CardType.readyToUse
  });

  final CardType initialTab;

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final controller = Get.put(CardsController());
  late CardType _selectedTab;

  @override
  void initState() {
    _selectedTab = widget.initialTab;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoNavigationBar(
          middle: CupertinoSegmentedControl<CardType>(
            selectedColor: Colors.grey[300],
            padding: const EdgeInsets.symmetric(horizontal: 12),
            groupValue: _selectedTab,
            onValueChanged: (CardType value) {
              setState(() {
                _selectedTab = value;
              });
            },
            children: const <CardType, Widget>{
              CardType.readyToUse: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Ready to Use',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              CardType.custom: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Custom',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            },
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: _selectedTab == CardType.readyToUse
                  ? ReadyToUsePage(controller: controller)
                  : CustomCardPage(controller: controller),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomCardPage extends StatelessWidget {
  const CustomCardPage({
    super.key,
    required this.controller,
  });

  final CardsController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardsController>(
      init: controller,
      tag: CardType.custom.name,
      builder: (controller) => Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 150,
            child: Center(
              child: Text(
                'بطاقات مخصصة',
                style: TextStyle(
                  color: Color.fromRGBO(65, 84, 123, 1),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ),
          const SizedBox(height: 20),
          const Text(
            'اختر البطاقة التي تريد تصميمها',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'No cards found',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ),
        ],
      )
    );
  }
}

class ReadyToUsePage extends StatelessWidget {
  const ReadyToUsePage({
    super.key,
    required this.controller,
  });

  final CardsController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardsController>(
      init: controller,
      tag: CardType.readyToUse.name,
      builder: (controller) => Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 150,
            child: Center(
              child: Text(
                'بطاقات جاهزة لك',
                style: TextStyle(
                  color: Color.fromRGBO(65, 84, 123, 1),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Text(
                      'filter',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              Text(
                'cards'.tr + (controller.response?.data.length.toString() ?? '-'),
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Add line
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            color: Colors.grey[400],
          ),
          Builder(
            builder: (context)  {

              if (controller.submissionState is Submitting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              if (controller.submissionState is SubmissionError) {
                return Center(
                  child: Text((controller.submissionState as SubmissionError).exception!.message),
                );
              }

              if (controller.response!.data.isEmpty) {
                return Center(
                  child: Text('no_cards_found'.tr),
                );
              }

              return Column(
                children: List.generate(
                  controller.response!.data.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ReadyCard(
                      card: controller.response!.data[index],
                    ),
                  )
                )
              );
            }
          )
        ]
      ),
    );
  }
}