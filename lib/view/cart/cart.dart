import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/view/cards/widgets/brand_image.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';
import 'package:giveagift/view/payment/payment.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'cart'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            backgroundColor: Get.isDarkMode
              ? Colors.grey[900]
              : Colors.white,
          ),
          body: controller.carts.isEmpty
              ? Center(
                  child: Text('empty_cart'.tr),
                )
              : ListView.builder(
                  itemCount: controller.carts.length,
                  itemBuilder: (context, index) {
                    final cart = controller.carts[index];
                    final item = cart.items.first;
                    return Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                          ? Colors.grey[900]!
                          : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Get.isDarkMode
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                            offset: const Offset(0.0, 0.0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              BrandImage(
                                logoImage: item.brand,
                                size: 50,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.brand),
                                  Text("${item.price} SAR"),
                                ],
                              ),
                            ],
                          ),
                          if (!item.isCustom)
                            Column(
                              children: [
                                Text('reciver_info'.tr),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text('${'name'.tr}: '),
                                    Text(item.receiverInfo.name),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('${'phone_number'.tr}: '),
                                    Text(item.receiverInfo.phone),
                                  ],
                                ),
                              ],
                            ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.removeReadyCardFromLocalCart(cart.id);
                                }, 
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.white,
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    if (!Platform.isIOS) {
                                      bool isLaunched = await launchUrl(
                                        Uri.http(
                                          API.BASE_URL,
                                          '/payment',
                                          {
                                            'cartId': cart.id,
                                            'amount': item.price.toString(),
                                          },
                                        ),
                                      );

                                      if (!isLaunched) {
                                        Get.showSnackbar(
                                          const GetSnackBar(
                                            message: 'Failed to open the payment page',
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }

                                      return;
                                    }
                                    
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PaymentPage(cartId: cart.id, amount: item.price),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'pay'.tr,
                                    style: Theme.of(context).textTheme.titleSmall
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}