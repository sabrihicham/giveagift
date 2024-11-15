import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/colors.dart';
import 'package:giveagift/core/extensions/web_images.dart';
import 'package:giveagift/view/cards/data/models/color.dart';

class CustomColorChooser extends StatefulWidget {
  const CustomColorChooser({
    super.key,
    this.colors = const [],
    this.selected,
    required this.onColorSelected,
  });

  final List<MyColor> colors;
  final MyColor? selected;
  final Function(MyColor?) onColorSelected;

  @override
  State<CustomColorChooser> createState() => _CustomColorChooserState();
}

class _CustomColorChooserState extends State<CustomColorChooser> {
  MyColor? selected;

  @override
  void initState() {
    selected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late double iconSize = MediaQuery.of(context).size.width > 600 ? 32 : 24;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 6 : 5,
          crossAxisSpacing: 25.5.w,
          mainAxisSpacing: 15.w,
          childAspectRatio: 1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.colors.length,
        itemBuilder: (context, index) {
          final color = widget.colors[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = selected == color ? null : color;
              });
              widget.onColorSelected(selected);
            },
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInToLinear,
              padding: EdgeInsets.all(color == selected ? 0 : 5),
              child: LayoutBuilder(
                builder: (context, constraints) => Badge(
                  label: SvgPicture.asset(
                    'assets/icons/pro.svg',
                    width: iconSize,
                    height: iconSize,
                    color: ConstColors.gold,
                  ),
                  alignment: Get.locale?.languageCode != 'ar'
                    ? Alignment(
                        1 + iconSize / constraints.maxWidth,
                        -1 - iconSize / constraints.maxHeight,
                      )
                    : Alignment(
                      -1 - iconSize / constraints.maxWidth,
                      -1 - iconSize / constraints.maxHeight,
                    ),
                  largeSize: iconSize,
                  backgroundColor: Colors.transparent,
                  isLabelVisible: color is ProColor,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: (color is ColorModel) ? color.color : null,
                        border: color == selected
                            ? Border.all(
                                color: color is ProColor
                                    ? ConstColors.gold
                                    : Colors.black,
                                width: color is ProColor ? 3 : 3,
                              )
                            : null,
                        shape: BoxShape.circle
                        // borderRadius: BorderRadius.circular(10),
                        ),
                    child: (color is ProColor)
                        ? Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // borderRadius: BorderRadius.circular(5),
                             ),
                            child: CachedNetworkImage(
                              imageUrl: color.image.colorImage,
                              fit: BoxFit.fill,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
