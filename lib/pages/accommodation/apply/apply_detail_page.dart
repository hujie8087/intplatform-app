import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ApplyDetailPage extends StatefulWidget {
  final String url;
  final String title;
  const ApplyDetailPage({super.key, required this.url, required this.title});

  @override
  State<ApplyDetailPage> createState() => _ApplyDetailPageState();
}

class _ApplyDetailPageState extends State<ApplyDetailPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onHttpError: (HttpResponseError error) {
          print('onHttpError: ${error.request!.uri}');
          print('onHttpError: ${error.response.toString()}');
          // ProgressHUD.showError('网络错误，请稍后再试');
          // Navigator.pop(context);
        },
        onWebResourceError: (WebResourceError error) {
          print('onWebResourceError: ${error.toString()}');
          // ProgressHUD.showError('网络错误，请稍后再试');
          // Navigator.pop(context);
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    _controller.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: WebViewWidget(controller: _controller),
    );
  }
}
