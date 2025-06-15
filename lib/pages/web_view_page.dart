import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  NoticeModel? noticeData;

  @override
  void initState() {
    super.initState();
    getNoticeData();
  }

  // 异步获取数据
  Future getNoticeData() async {
    DataUtils.getDetailById(
      '/system/notice/' + widget.id.toString(),
      success: (data) {
        noticeData = NoticeModel.fromJson(data);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          noticeData?.noticeTitle ?? '',
          style: TextStyle(fontSize: 16.px),
          textAlign: TextAlign.left,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noticeData?.noticeTitle ?? '',
              style: TextStyle(fontSize: 16.px),
            ),
            SizedBox(height: 8.px),
            Row(
              children: [
                Text(
                  noticeData?.createDept ?? '',
                  style: TextStyle(color: primaryColor, fontSize: 12.px),
                ),
                SizedBox(width: 10),
                Text(
                  noticeData?.createTime ?? '',
                  style: TextStyle(color: Colors.grey, fontSize: 12.px),
                ),
              ],
            ),
            SizedBox(height: 8.px),
            Container(child: Html(data: noticeData?.noticeContent ?? '')),
          ],
        ),
      ),
    );
  }
}
