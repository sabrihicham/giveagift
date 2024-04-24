import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/widgets/gift_card.dart';

class ReadyCard extends StatelessWidget {
  const ReadyCard({
    super.key,
    required this.card,
  });

  final CardData card;

  @override
  Widget build(BuildContext context) {
    final GestureFlipCardController controller = GestureFlipCardController();
    return SizedBox(
      width: 300,
      child: Card(
        // elevation: 0,
        elevation: 3,
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
                  frontBackgroundImage: card.cardFront,
                  backBackgroundImage: card.cardBack,
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
                      '${card.price}',
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
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: card.logoImage,
                        width: 50,
                        height: 50,
                        errorWidget: (context, url, error) {
                          return const Center(
                            child: Icon(
                              Icons.storefront_outlined,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      
      ),
    );
  }
}
