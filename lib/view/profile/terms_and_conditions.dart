import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  Color? get textColor => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.white.withOpacity(0.1) : null,
      appBar: AppBar(
        title: Text('terms_and_conditions'.tr),
        backgroundColor: Get.isDarkMode ? null : Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 336.w,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'مرحبًا بكم في موقع “GIVE A GIFT”. تحكم هذه الشروط والأحكام استخدامك لموقعنا والخدمات المتاحة من خلاله، بما في ذلك شراء بطاقات الهدايا الرقمية. يُرجى قراءة هذه الشروط بعناية قبل استخدام الموقع أو إتمام أي عملية شراء. باستخدامك للموقع، فإنك توافق على الالتزام بالشروط التالية.\n\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: ' 1.⁠ ⁠التعريفات\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\n	•	“الموقع”: يشير إلى متجر “GIVE A GIFT” الإلكتروني.\n	•	“نحن” أو “لنا”: تشير إلى شركة “GIVE A GIFT” المالكة والمشغلة للموقع.\n	•	“أنت” أو “العميل”: تشير إلى الشخص الذي يستخدم الموقع أو يستفيد من الخدمات المقدمة من خلاله.\n\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: ' 2.⁠ ⁠قبول الشروط\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\nباستخدامك للموقع وإتمامك لأي عملية شراء، فإنك توافق على الالتزام بهذه الشروط والأحكام، وأي سياسات أو إشعارات ذات صلة منشورة على الموقع.\n\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: ' 3.⁠ ⁠استخدام الموقع\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\n	•	يُسمح لك باستخدام الموقع لأغراض قانونية وبما يتوافق مع هذه الشروط والأحكام.\n	•	يُحظر استخدام الموقع لأي غرض غير قانوني أو غير أخلاقي، بما في ذلك التلاعب في أي من محتوياته أو محاولة الوصول غير المصرح به إلى أنظمة الموقع.\n\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: ' 4.⁠ ⁠شراء بطاقات الهدايا الرقمية\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\n	•	إتمام الطلب: عند إتمام عملية شراء بطاقة هدية رقمية، سيتم إرسال البطاقة إلى الرقم الذي تقدمه. يتحمل العميل المسؤولية الكاملة عن دقة المعلومات المقدمة.\n	•	عدم الإلغاء أو الاستبدال: نظرًا لطبيعة المنتجات الرقمية، لا يمكن إلغاء الطلب أو استبدال البطاقة بعد إرسالها.\n	•	شروط الاستخدام: تخضع بطاقات الهدايا لشروط وأحكام المتجر الشريك الذي تُستخدم فيه. يجب عليك مراجعة هذه الشروط قبل استخدام البطاقة.\n	•	المسؤولية عن الاستخدام: نحن لسنا مسؤولين عن أي فقدان أو سوء استخدام للبطاقة بعد إرسالها بنجاح إلى المستلم.\n\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: ' 5.⁠ ⁠الدفع والأسعار\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\n	•	جميع الأسعار المعروضة نهائية وتشمل الضرائب المطبقة، إن وجدت، بموجب قوانين المملكة العربية السعودية.\n	•	تتم عمليات الدفع عبر مزودي خدمات دفع معتمدين، ويتم تشفير كافة بيانات الدفع لضمان الأمان. نحن لا نقوم بتخزين معلومات الدفع الخاصة بك على خوادمنا.\n	•	يتحمل العميل مسؤولية تقديم معلومات دفع دقيقة وصحيحة لإتمام العملية بنجاح.\n\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: ' 6.⁠ ⁠الملكية الفكرية\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\n	•	جميع المحتويات المتوفرة على الموقع، بما في ذلك النصوص، الصور، الشعارات، والعلامات التجارية، هي ملكية خاصة لشركة “GIVE A GIFT” أو الجهات المرخصة لها.\n	•	يُحظر نسخ أو إعادة إنتاج أو توزيع أي جزء من الموقع دون الحصول على إذن كتابي صريح منا.\n\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: ' 7.⁠ ⁠سياسة الخصوصية\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\n	•	نحن ملتزمون بحماية خصوصيتك وفقًا لأنظمة حماية البيانات المعمول بها في المملكة العربية السعودية. لمزيد من التفاصيل، يُرجى مراجعة سياسة الخصوصية المتاحة على الموقع.\n\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: ' 8.⁠ ⁠حدود المسؤولية\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\n	•	يتم تقديم الموقع وجميع الخدمات المتاحة عليه “كما هي” دون أي ضمانات من أي نوع.\n	•	لن نكون مسؤولين عن أي أضرار مباشرة أو غير مباشرة تنشأ عن استخدام الموقع أو عن أي منتجات أو خدمات يتم شراؤها من خلاله.\n	•	لن نكون مسؤولين عن أي ضرر ناتج عن إساءة استخدام بطاقات الهدايا بعد إرسالها للمستلم.\n\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: ' 9.⁠ ⁠القانون المعمول به والاختصاص القضائي\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\n	•	تخضع هذه الشروط والأحكام وتُفسر وفقًا للقوانين والأنظمة المعمول بها في المملكة العربية السعودية.\n	•	في حال حدوث أي نزاع يتعلق باستخدامك للموقع أو أي معاملة تم إجراؤها من خلاله، سيتم تقديم النزاع إلى المحاكم المختصة في المملكة العربية السعودية.\n\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: '10.⁠ ⁠التعديلات على الشروط والأحكام\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\n	•	نحتفظ بالحق في تعديل هذه الشروط والأحكام في أي وقت، وستصبح التعديلات سارية فور نشرها على الموقع. يُنصح بمراجعة الشروط بانتظام لضمان معرفتك بأي تغييرات.\n	•	استمرارك في استخدام الموقع بعد إجراء التعديلات يعني موافقتك على الشروط والأحكام الجديدة.\n\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: '11.⁠ ⁠القوة القاهرة\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\nلن نكون مسؤولين عن أي تأخير أو فشل في تنفيذ التزاماتنا بموجب هذه الشروط والأحكام إذا كان التأخير أو الفشل ناتجًا عن أحداث خارجة عن سيطرتنا المعقولة، بما في ذلك الكوارث الطبيعية أو القرارات الحكومية.\n\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: '12.⁠ ⁠الاتصال بنا\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\nإذا كانت لديك أي استفسارات أو ترغب في التواصل معنا بشأن هذه الشروط والأحكام، يمكنك الاتصال بنا عن طريق صفحة اتصل بنا.\n\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text: 'الخاتمة\n',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  TextSpan(
                    text:
                        '\nباستخدامك لموقع “GIVE A GIFT”، فإنك توافق على الالتزام بهذه الشروط والأحكام وتقر بأنك قد قرأتها وفهمتها بالكامل. نحن نلتزم بتقديم تجربة آمنة وموثوقة لعملائنا مع الامتثال الكامل للقوانين واللوائح المعمول بها في المملكة العربية السعودية.',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
    );
  }
}
