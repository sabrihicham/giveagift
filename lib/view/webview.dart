import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewArguments {
  final String url;
  final String? title;
  WebViewArguments({required this.url, required this.title});
}

class InAppWebViewPage extends StatefulWidget {
  final WebViewArguments arguments;
  const InAppWebViewPage({required this.arguments, Key? key}) : super(key: key);

  @override
  InAppWebViewPageState createState() => InAppWebViewPageState();
}

class InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.arguments.title ?? ''),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
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
                onLoadStart: (InAppWebViewController controller, Uri? url) { },
                onLoadStop: (InAppWebViewController controller, Uri? url) async { },
                onProgressChanged: (InAppWebViewController controller, int progress) async {},
                onUpdateVisitedHistory: (controller, url, androidIsReload) { },
                onTitleChanged: (InAppWebViewController controller, String? title) async { },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
