import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GlobalTextField extends StatefulWidget {
  const GlobalTextField({
    super.key,
    required this.controller,
    this.placeholder,
    this.prefix,
    this.backgroundColor,
    this.inputFormatters,
    this.obscureText,
    this.title,
    this.textSize,
    this.textAlign = TextAlign.start,
  });

  final TextEditingController controller;
  final String? placeholder;
  final Widget? prefix;
  final Color? backgroundColor;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obscureText;
  final String? title;
  final double? textSize;
  final TextAlign textAlign;

  @override
  State<GlobalTextField> createState() => _GlobalTextFieldState();
}

class _GlobalTextFieldState extends State<GlobalTextField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.obscureText ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.title!,
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              // maxHeight: 50,
              maxWidth: 500,
            ),
            child: CupertinoTextField(
              placeholder: widget.placeholder,
              placeholderStyle: TextStyle(
                color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              controller: widget.controller,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              maxLines: 1,
              textAlign: widget.textAlign,
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontSize: widget.textSize ?? 16,
              ),
              prefix: widget.prefix,
              suffix: widget.obscureText == true
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    )
                  : null,
              inputFormatters: widget.inputFormatters,
              obscureText: _obscureText,
              decoration: BoxDecoration(
                color: widget.backgroundColor ??( Get.isDarkMode ? Colors.grey[800] : Colors.grey[100]),
                border: Border.all(
                  color: Get.isDarkMode ? Colors.grey[200]! : Colors.grey[800]!,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlobalTextFieldForm extends StatefulWidget {
  const GlobalTextFieldForm({
    super.key,
    required this.controller,
    this.placeholder,
    this.prefix,
    this.inputFormatters,
    this.obscureText,
    this.title,
    this.validator,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String? placeholder;
  final Widget? prefix;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obscureText;
  final String? title;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  State<GlobalTextFieldForm> createState() => _GlobalTextFieldFormState();
}

class _GlobalTextFieldFormState extends State<GlobalTextFieldForm> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.obscureText ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.title!,
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              // maxHeight: 50,
              maxWidth: 500,
            ),
            child: CupertinoTextFormFieldRow(
              placeholder: widget.placeholder,
              validator: widget.validator,
              placeholderStyle: TextStyle(
                color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              controller: widget.controller,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              maxLines: 1,
              keyboardType: widget.keyboardType,
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
              ),
              prefix: widget.prefix,
              inputFormatters: widget.inputFormatters,
              obscureText: _obscureText,
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[100],
                border: Border.all(
                  color: Get.isDarkMode ? Colors.grey[200]! : Colors.grey[800]!,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
