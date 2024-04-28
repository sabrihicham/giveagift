import 'package:flutter/material.dart';
import 'package:giveagift/view/cards/widgets/brand_image.dart';
import 'package:giveagift/view/widgets/gift_card.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({
    super.key,
    this.showOnly = CardSide.front,
    this.color,
    this.backgroundImage,
    this.brandImage,
    this.textStyle,
    this.message,
    this.price,
    
    this.currency = 'ر.س',
  });

  final CardSide showOnly;
  final Color? color;
  final String? backgroundImage;
  final String? brandImage;
  final TextStyle? textStyle;
  final String? message, price;
  final String currency;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 400 : 300,
      height: MediaQuery.of(context).size.width > 600 ? 230 : 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GiftCard(
              frontBackgroundImage: widget.backgroundImage,
              color: widget.color ?? Colors.grey.shade200,
              showOnly: widget.showOnly,
            ),
            if(widget.showOnly == CardSide.front && widget.brandImage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: BrandImage(
                      logoImage: widget.brandImage!,
                      fit: BoxFit.contain,
                      margin: EdgeInsets.zero,
                      size: MediaQuery.of(context).size.width > 600
                        ? 80
                        : 60,
                    ),
                  ),
                ),
              ),
            if(widget.showOnly == CardSide.back && widget.message != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Text(
                        widget.message!,
                        textAlign: TextAlign.center,
                        style: widget.textStyle ?? TextStyle(
                          color: (widget.color?.computeLuminance() ?? 0) > 0.5 ? Colors.black : Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if(widget.showOnly == CardSide.back && widget.price != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    '${widget.price} ${widget.currency}',
                    textAlign: TextAlign.center,
                    style: widget.textStyle ?? TextStyle(
                      color: (widget.color?.computeLuminance() ?? 0) > 0.5 ? Colors.black : Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            if(widget.showOnly == CardSide.back)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    'assets/images/logo.webp',
                    width: MediaQuery.of(context).size.width > 600 ? 100 : 90,
                    height: MediaQuery.of(context).size.width > 600 ? 34.8 : 30,
                  )
                ),
              ),
          ],
        ),
      ),
    );
  }
}
