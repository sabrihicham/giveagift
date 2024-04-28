import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return const Placeholder();
      },
    );
  }
}