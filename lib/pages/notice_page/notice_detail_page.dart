import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class NoticeDetailPage extends StatefulWidget {
  const NoticeDetailPage({Key? key, required this.noticeId}) : super(key: key);
  final int noticeId;
  @override
  _NoticeDetailPageState createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  String? title;
  String? content;
  NoticeModel? noticeDetail;

  Future<void> _fetchData() async {
    // 模拟异步数据获取
    if (widget.noticeId.toString() != '') {
      DataUtils.getDetailById('/system/notice/' + widget.noticeId.toString(),
          success: (data) {
        noticeDetail = NoticeModel.fromJson(data['data']);
        // 更新状态
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          noticeDetail?.noticeTitle ?? '',
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
              noticeDetail?.noticeTitle ?? '',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  noticeDetail?.createDept ?? '',
                  style: TextStyle(color: primaryColor, fontSize: 14),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  noticeDetail?.createTime ?? '',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(child: Html(data: noticeDetail?.noticeContent ?? ''))
          ],
        ),
      ),
    );
  }
}
