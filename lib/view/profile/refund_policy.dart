import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RefundPage extends StatelessWidget {
  const RefundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.white.withOpacity(0.1) : null,
      appBar: AppBar(
        title: Text(
          'refund_policy'.tr,
        ),
        backgroundColor: null,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: 336.w,
            padding: EdgeInsets.symmetric(vertical: 24.h ),
            child: Text(
              'نحن في “GIVE A GIFT” نسعى لضمان رضاك التام عن تجربتك معنا. نظرًا لطبيعة المنتجات الرقمية (بطاقات الهدايا الإلكترونية)، لا يمكن إلغاء أو استبدال الطلب بعد إتمام عملية الشراء وإرسال البطاقة إلى رقم المستلم.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ),
      ),
    );
  }
}