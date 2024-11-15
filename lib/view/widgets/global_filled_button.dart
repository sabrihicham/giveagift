// Widget _buildGlobalFilledButton({
//     double? height,
//     double? width,
//     Color color = const Color(0xFF222A40),
//     required Function() onPressed,
//     String text = '',
//     Color? textColor,
//     FontWeight? fontWeight = FontWeight.w500,
//     bool enableBorder = false,
//     Color borderColor = const Color(0xFF222A40),
//   }) {
//     return Container(
//       height: height,
//       width: width,
//       decoration: ShapeDecoration(
//         color: color,
//         shape: RoundedRectangleBorder(
//           side: enableBorder ? BorderSide(color: borderColor) : BorderSide.none,
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       child: CupertinoButton(
//         onPressed: onPressed,
//         padding: EdgeInsets.zero,
//         child: Text(
//           text,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: textColor ?? Colors.white,
//             fontSize: 16,
//             fontWeight: fontWeight,
//           ),
//         ),
//       ),
//     );
//   }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlobalFilledButton extends StatelessWidget {
  const GlobalFilledButton({
    Key? key,
    this.height,
    this.width,
    this.color = const Color(0xFF222A40),
    required this.onPressed,
    this.text = '',
    this.loading = false,
    this.textColor,
    this.textSize,
    this.fontWeight = FontWeight.w500,
    this.enableBorder = false,
    this.borderColor = const Color(0xFF222A40),
  }) : super(key: key);

  final double? height;
  final double? width;
  final Color color;
  final Function() onPressed;
  final String text;
  final bool loading;
  final Color? textColor;
  final double? textSize;
  final FontWeight? fontWeight;
  final bool enableBorder;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          side: enableBorder ? BorderSide(color: borderColor) : BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: loading
        ? const Center(
          child: CupertinoActivityIndicator(color: Colors.white,)
        )
        : Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: textSize ?? 16,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
