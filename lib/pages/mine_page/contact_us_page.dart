import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logistics_app/app_theme.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPage createState() => _ContactUsPage();
}

class _ContactUsPage extends State<ContactUsPage> {
  final htmlContent = r'''<![CDATA[
        <h2>APP更多功能敬请期待</h2>''';

  String? _version = "1.0.0";

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: Text(
            '联系我们',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            Image.asset("assets/images/feedbackImage.png",
                width: 88, height: 88),
            Text("v$_version"),
            Html(data: htmlContent)
          ]),
        )));
  }
}
