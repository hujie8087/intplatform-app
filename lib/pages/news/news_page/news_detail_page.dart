import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({Key? key, required this.noticeId}) : super(key: key);

  final String noticeId;

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  NoticeModel? noticeModel;

  @override
  void initState() {
    super.initState();
    getNoticeDetail();
  }

  Future<void> getNoticeDetail() async {
    DataUtils.getDetailById(
      '/system/notice/' + widget.noticeId,
      success: (data) {
        noticeModel = NoticeModel.fromJson(data['data']);
        setState(() {});
      },
      fail: (error, message) {
        ProgressHUD.showError(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          noticeModel?.noticeTitle ?? '',
          style: TextStyle(fontSize: 16.px),
          textAlign: TextAlign.left,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                noticeModel?.noticeTitle ?? '',
                style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.px),
              Row(
                children: [
                  Text(
                    noticeModel?.createDept ?? '',
                    style: TextStyle(color: primaryColor, fontSize: 12.px),
                  ),
                  SizedBox(width: 10.px),
                  Text(
                    noticeModel?.createTime ?? '',
                    style: TextStyle(color: Colors.grey, fontSize: 12.px),
                  ),
                ],
              ),
              SizedBox(height: 10.px),
              Container(
                child: Html(
                  data: noticeModel?.noticeContent ?? '',
                  style: {'body': Style(fontSize: FontSize(12.px))},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
