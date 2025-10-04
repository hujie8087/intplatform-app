import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;

class IframeViewWidget extends StatelessWidget {
  final String url;
  const IframeViewWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    // 注册 iframe
    ui.platformViewRegistry.registerViewFactory(url, (int viewId) {
      final iframe =
          html.IFrameElement()
            ..src = url
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%';
      return iframe;
    });

    return HtmlElementView(viewType: url);
  }
}
