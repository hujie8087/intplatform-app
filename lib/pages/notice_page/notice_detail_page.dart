import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_video/flutter_html_video.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class NoticeDetailPage extends StatefulWidget {
  const NoticeDetailPage({Key? key, required this.noticeId}) : super(key: key);
  final int noticeId;
  @override
  _NoticeDetailPageState createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
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
            style: TextStyle(fontSize: 16.px),
            textAlign: TextAlign.left,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.px),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      noticeDetail?.noticeTitle ?? '',
                      style: TextStyle(
                          fontSize: 16.px, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.px,
                    ),
                    Row(
                      children: [
                        Text(
                          noticeDetail?.createDept ?? '',
                          style:
                              TextStyle(color: primaryColor, fontSize: 12.px),
                        ),
                        SizedBox(
                          width: 10.px,
                        ),
                        Text(
                          noticeDetail?.createTime ?? '',
                          style: TextStyle(color: Colors.grey, fontSize: 12.px),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.px,
                    ),
                  ],
                ),
              ),
              Container(
                  child: Html(
                data: noticeDetail?.noticeContent ?? '',
                // 设置字体大小
                style: {
                  'body': Style(fontSize: FontSize(12.px)),
                },
                extensions: [
                  const VideoHtmlExtension(),
                ],
              ))
            ],
          ),
        ));
  }
}
