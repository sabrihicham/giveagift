import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:get/get.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cards/widgets/brand_image.dart';
import 'package:giveagift/view/widgets/gift_card.dart';

class ReadyCard extends StatefulWidget {
  const ReadyCard({
    super.key,
    required this.card,
    required this.onAddTap,
  });

  final CardData card;
  final void Function() onAddTap;

  @override
  State<ReadyCard> createState() => _ReadyCardState();
}

class _ReadyCardState extends State<ReadyCard> with AutomaticKeepAliveClientMixin {
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final GestureFlipCardController controller = GestureFlipCardController();
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 400 : 300,
      child: Card(
        elevation: 5,
        shadowColor: Get.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200,
        color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                controller.flipcard();
              },
              child: GiftCard(
                controller: controller,
                frontBackgroundImage: widget.card.cardFront,
                backBackgroundImage: widget.card.cardBack,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: widget.onAddTap, 
                  icon: const Icon(
                    Icons.add_rounded,
                  ) 
                ),
                Row(
                  children: [
                    Text(
                      widget.card.price,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'SAR',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Get.isDarkMode ? Colors.white : Colors.grey[400],
                      ),
                    ),
                    BrandImage(logoImage: widget.card.logoImage)
                  ],
                )
              ],
            )
          ],
        ),
      
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
