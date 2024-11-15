import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncherUtils {
  static void launchPaymentResult({required String paymentId}) async {
    launchUrlString(
      "https://sa.myfatoorah.com/En/SAU/PayInvoice/Result?paymentId=$paymentId",
    );
  }
}