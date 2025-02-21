import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/view/cart/card_preview.dart';
import 'package:giveagift/view/recivedCards/controller/received_cards.dart';
import 'package:giveagift/view/recivedCards/model/recived_card.dart';
import 'package:giveagift/view/recivedCards/widgets/recived_card_item.dart';
import 'package:giveagift/view/widgets/global_filled_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RecivedCardsPage extends StatefulWidget {
  const RecivedCardsPage({super.key});

  @override
  State<RecivedCardsPage> createState() => RecivedCardstate();
}

class RecivedCardstate extends State<RecivedCardsPage> {
  final RecivedCardsController recivedCardsController = Get.put(RecivedCardsController());

  @override
  void initState() {
    recivedCardsController.getRecivedCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black.withOpacity(0.1) : null,
      appBar: AppBar(
        title: Text('recived_cards'.tr),
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          recivedCardsController.getRecivedCards();
        },
        child: GetBuilder<RecivedCardsController>(
          init: recivedCardsController,
          tag: 'getRecivedCards',
          id: 'getRecivedCards',
          builder: (controller) {
            if (controller.getRecivedCardsState is Submitting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (controller.getRecivedCardsState is SubmissionError) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (controller.getRecivedCardsState as SubmissionError).exception.message,
                    ),
                    CupertinoButton(
                      onPressed: () {
                        recivedCardsController.getRecivedCards();
                      },
                      child: Text('retry'.tr),
                    )
                  ],
                ),
              );
            }

            if (controller.recivedCards == null || controller.recivedCards!.isEmpty) {
              return Center(
                child: Text('no_recived_cards'.tr),
              );
            }

            return SingleChildScrollView(
              child: StaggeredGrid.count(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                children: [
                  for (final card in controller.recivedCards!.reversed)
                    // RecivedCardsPrview(card: card),
                    RecivedCardItem(card: card),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class RecivedCardsPrview extends StatelessWidget {
  final RecivedCard card;

  const RecivedCardsPrview({super.key, required this.card});

  // Order Details

  // Price: 15
  // Shape Price:
  // Color Price: 0
  // celebration Icon Price: 0
  // celebration Link Price: 0
  // VAT Value: 0%
  // Total Price: 15
  // Store: Elct
  // ----------------------
  // Customer & Recipient
  // Customer: hicham sabri
  // Email: hicham@gmail.com
  // Phone Number: 966556855555
  // Recipient: Hicham Sabri
  // Recipient whatsapp: 659668559
  // ----------------------
  // ID & Date
  // Order Number: 46
  // card Id: 66f9663ba63cf14c04b68112
  // Date: 29/09/2024
  // Time: 15:47

  String formatDate(DateTime? date) {
    if (date == null) {
      return '----/--/--';
    }

    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  TextStyle get titleStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'card_details'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp ,
              ),
            ),
          ),
          CardInfoLine(
            text: '${'sender'.tr}: ', 
            value: card.sender?.name ?? '-',
          ),
          CardInfoLine(
            text: '${'recipient'.tr}: ',
            value: '${card.recipient.name}',
          ),
          CardInfoLine(
            text: '${'message'.tr}: ',
            value: '${card.text?.message}',
          ),
          CardInfoLine(
            text: '${'date'.tr}: ',
            value: formatDate(card.createdAt),
          ),
          CardInfoLine(
            text: '${'price'.tr}: ',
            value: '${card.price.value} ${'sar'.tr}',
          ),
          CardInfoLine(
            text: '${'discount'.tr}: ',
            value: card.discountCode?.isUsed == true ? 'yes'.tr : 'no'.tr,
            isBold: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: GlobalFilledButton(
                  text: 'view_card'.tr,
                  textSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  width: 132.w,
                  height: 36.h,
                  onPressed: () {
                    showModalBottomSheet(
                      enableDrag: false,
                      constraints: BoxConstraints(
                        // maxHeight: 547.h,
                        maxHeight: MediaQuery.of(context).size.height * 0.9,
                      ),
                      backgroundColor: Get.isDarkMode
                        ? Colors.grey.shade900
                        : const Color(0xFFF9F9FB),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => CardPreview(cardId: card.id)
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CardInfoLine extends StatelessWidget {
  const CardInfoLine(
      {super.key,
      required this.text,
      required this.value,
      this.isBold = false});

  final String text, value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(
            'assets/icons/dollar.svg',
            color: Theme.of(context).primaryColor,
            width: 20.w,
            height: 20.w,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w700 : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

