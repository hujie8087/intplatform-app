import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPage createState() => _ContactUsPage();
}

class _ContactUsPage extends State<ContactUsPage> {
  final htmlContent = r'''<![CDATA[
        <br>
        <h3>更多功能敬请期待！</h3>
        <h4>有想联系我们的，请扫下方二维码</h4>
        <p>
            联系人：韩栋
        </p>
        <p>
            微信：decoy-27
        </p>
        <p>
            客服时间：周一至周六 8:00-18:00
        </p>
        ''';

  String? _version = "1.0.3";

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: Text(
            S.of(context).contactUs,
            style: TextStyle(fontSize: 16.px),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            Image.asset("assets/images/feedbackImage.png",
                width: 88.px, height: 88.px),
            Text("v$_version"),
            Html(
              data: htmlContent,
              // 设置字体大小
              style: {
                'body': Style(fontSize: FontSize(12.px)),
              },
            )
          ]),
        )));
  }
}
