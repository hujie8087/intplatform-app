import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/image_preview_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsContent extends StatelessWidget {
  const NewsContent({super.key, required this.htmlContent});
  final String htmlContent;

  @override
  Widget build(BuildContext context) {
    // ✅ 移动端用 webview_flutter
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'ImageChannel',
            onMessageReceived: (message) {
              final imageUrl = message.message;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImagePreviewPage(imageUrl: imageUrl),
                ),
              );
            },
          )
          ..loadHtmlString(htmlContent);

    return WebViewWidget(controller: controller);
  }
}
