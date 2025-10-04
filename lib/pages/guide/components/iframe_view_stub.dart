import 'package:flutter/material.dart';

class IframeViewWidget extends StatelessWidget {
  final String url;
  const IframeViewWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Iframe not supported on this platform"));
  }
}
