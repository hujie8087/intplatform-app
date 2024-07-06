import 'package:logistics_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({Key? key}) : super(key: key);

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  String? title;
  String? content;

  @override
  void initState() {
    super.initState();
    // 获取路由参数
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var map = ModalRoute.of(context)?.settings.arguments;
      print(map);
      if (map is Map) {
        title = map['noticeTitle'];
        content = map['noticeContent'];
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title ?? '',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.left,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? '',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'ACC 后勤部',
                  style: TextStyle(color: primaryColor, fontSize: 14),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '2021-09-01 10:00:00',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Image.asset(
              'assets/images/bg_video.gif',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10,
            ),
            Container(child: Html(data: content ?? ''))
          ],
        ),
      ),
    );
  }
}
