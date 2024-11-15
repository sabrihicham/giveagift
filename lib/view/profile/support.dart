import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/contact_us.dart';
import 'package:giveagift/view/profile/contact_us.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  Future<void> _launchEmail() async {
  final Uri _emailUri = Uri(
    scheme: 'mailto',
    path: 'giveagift.sa@gmail.com',
    // queryParameters: {
    //   'subject': 'Subject',
    //   'body': 'Body of the email',
    // },
  );

  if (!await launchUrl(_emailUri)) {
    throw 'Could not launch email';
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.white.withOpacity(0.1) : null,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text('support'.tr),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'assets/images/support.webp',
                  width: 257.w,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 327.w,
                height: 178.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'إذا كنت بحاجة إلى مساعدة، لا تتردد في التواصل\n مع فريق الدعم الخاص بنا ',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'هنا',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Get.to(() => const ContactUsPage());
                                  /// Send email to: Giveagift.sa@gmail.com
                                  
                                  // launchUrlString('mailto:Giveagift.sa@gmail.com');

                                  _launchEmail();
                                },
                              style: TextStyle(
                                color: const Color(0xFFB62026),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'يمكنك زيارة صفحتنا على إنستغرام من ',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'هنا',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  ContactUs.instagram.launchContact();
                                },
                              style: TextStyle(
                                color: const Color(0xFFB62026),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: const Color(0xFFB62026),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'للمزيد من المعلومات. نحن سعداء لمساعدتك',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'يمكنك التواصل معنا عبر الواتساب من ',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'هنا',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  ContactUs.whatsapp.launchContact();
                                },
                              style: TextStyle(
                                color: const Color(0xFFB62026),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
