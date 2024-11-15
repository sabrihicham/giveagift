import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/utiles/url_launcher_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WebViewArguments {
  final String url;
  final String? successUrl;
  final String? errorUrl;
  final String? title;

  WebViewArguments({
    required this.url,
    this.successUrl,
    this.errorUrl,
    this.title,
  });
}

class InAppWebViewPage extends StatefulWidget {
  final WebViewArguments arguments;
  const InAppWebViewPage({required this.arguments, super.key});

  @override
  InAppWebViewPageState createState() => InAppWebViewPageState();
}

class InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.arguments.title ?? ''),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            // show dialog to confirm exit
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('exit_confirm_msg'.tr),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('no'.tr),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('yes'.tr),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(widget.arguments.url)),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    mediaPlaybackRequiresUserGesture: true,
                  ),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                onLoadStart: (InAppWebViewController controller, Uri? url) {
                  if (widget.arguments.successUrl != null && widget.arguments.successUrl!.isNotEmpty && url.toString().contains(widget.arguments.successUrl!)) {
                    Navigator.pop(context, true);
                  } else if (widget.arguments.errorUrl != null && widget.arguments.errorUrl!.isNotEmpty && url.toString().contains(widget.arguments.errorUrl!)) {
                    if (url != null && url.queryParameters.containsKey('paymentId')) {
                      UrlLauncherUtils.launchPaymentResult(
                        paymentId: url.queryParameters['paymentId']!
                      );
                    }
                    Navigator.pop(context, false);
                  }
                },
                onLoadStop: (InAppWebViewController controller, Uri? url) async {},
                onProgressChanged: (InAppWebViewController controller, int progress) async {},
                onUpdateVisitedHistory: (controller, url, androidIsReload) {},
                onTitleChanged: (InAppWebViewController controller, String? title) async {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
