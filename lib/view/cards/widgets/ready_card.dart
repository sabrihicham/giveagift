import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cards/widgets/brand_image.dart';
import 'package:giveagift/view/widgets/gift_card.dart';

class ReadyCard extends StatefulWidget {
  const ReadyCard({
    super.key,
    required this.card,
  });

  final CardData card;

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
        shadowColor: Colors.grey.shade200,
        color: Colors.white,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GiftCard(
                  controller: controller,
                  frontBackgroundImage: widget.card.cardFront,
                  backBackgroundImage: widget.card.cardBack,
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
      
                  }, 
                  icon: const Icon(
                    Icons.add_rounded,
                  ) 
                ),
                Row(
                  children: [
                    Text(
                      widget.card.price,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'SAR',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
