import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MonthlyDetailPage extends StatefulWidget {
  const MonthlyDetailPage({Key? key, required this.pdfUrl, required this.title})
      : super(key: key);

  final String pdfUrl;
  final String title;
  @override
  _MonthlyDetailPageState createState() => _MonthlyDetailPageState();
}

class _MonthlyDetailPageState extends State<MonthlyDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SfPdfViewer.network(widget.pdfUrl),
    );
  }
}
