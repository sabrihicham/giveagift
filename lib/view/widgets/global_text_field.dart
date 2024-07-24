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
    this.inputFormatters,
    this.obscureText,
  });

  final TextEditingController controller;
  final String? placeholder;
  final Widget? prefix;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obscureText;

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
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 50,
          maxWidth: 500,
        ),
        child: CupertinoTextField(
          placeholder: widget.placeholder,
          controller: widget.controller,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          maxLines: 1,
          style: TextStyle(
            color: Get.isDarkMode
              ? Colors.white
              : Colors.black,
            fontSize: 16,
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
                      ? Icons.lock
                      : Icons.lock_open,
                    color: Get.isDarkMode
                      ? Colors.white
                      : Colors.black,
                  ),
                ),
            )
            : null,
          inputFormatters: widget.inputFormatters,
          obscureText: _obscureText,
          decoration: BoxDecoration(
            color: Get.isDarkMode
              ? Colors.grey[800]
              : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),  
        ),
      ),
    );
  }
}