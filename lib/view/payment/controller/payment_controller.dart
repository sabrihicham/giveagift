import 'package:flutter/material.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_controller.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:http/http.dart' as http;

class PaymentController extends CustomController {
  final String cartId;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  DateTime? scheduleDate;
  

  PaymentController(this.cartId);

  void pay() {
    setState(Submitting());

    try {
      final respone = http.put(
        Uri.http(
          API.BASE_URL,
          '/api/cart-update-payment/$cartId',
        ),
        body: {
          // "2024-04-28T09:18:39.887Z"
          "scheduleDate": scheduleDate?.toIso8601String(),
          "scheduleState": scheduleDate != null,
          // +9665446053
          "phone": phoneController.text,
        }
      );
    } catch (e) { }
  }
}