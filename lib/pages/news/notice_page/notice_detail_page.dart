import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logistics_app/pages/news/news_page/news_content.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/route/route_annotation.dart';

@AppRoute(path: 'notice_detail_page', name: '通知公告详情页')
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
      DataUtils.getDetailById(
        '/system/notice/' + widget.noticeId.toString(),
        success: (data) {
          noticeDetail = NoticeModel.fromJson(data['data']);
          // 更新状态
          setState(() {});
        },
      );
    }
  }

  String fixHtmlImageUrls(String html) {
    final imgRegex = RegExp(r'src="([^"]+)"');
    return html.replaceAllMapped(imgRegex, (match) {
      final rawUrl = match.group(1)!;
      final fixedUrl = Uri.encodeFull(rawUrl);
      return 'src="$fixedUrl"';
    });
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final htmlContent = '''
  <!DOCTYPE html>
  <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <style>
        img { max-width: 100%; height: auto; }
        body { font-family: sans-serif; padding: 16px; }
      </style>
    <script>
      function setupImageClick() {
        const images = document.querySelectorAll('img');
        images.forEach(img => {
          img.onclick = function() {
            ImageChannel.postMessage(this.src);
          };
        });
      }
      window.onload = setupImageClick;
    </script>
    </head>
    <body>
      ${fixHtmlImageUrls(noticeDetail?.noticeContent ?? "<p>No content</p>")}
    </body>
  </html>
  ''';
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
                    fontSize: 16.px,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.px),
                Row(
                  children: [
                    Text(
                      noticeDetail?.createDept ?? '',
                      style: TextStyle(color: primaryColor, fontSize: 12.px),
                    ),
                    SizedBox(width: 10.px),
                    Text(
                      noticeDetail?.createTime ?? '',
                      style: TextStyle(color: Colors.grey, fontSize: 12.px),
                    ),
                  ],
                ),
                SizedBox(height: 10.px),
              ],
            ),
          ),
          if (noticeDetail?.noticeContent != null)
            Expanded(
              child:
                  kIsWeb
                      ? SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 12.px),
                        child: Html(
                          data: fixHtmlImageUrls(
                            noticeDetail?.noticeContent ?? '',
                          ),
                        ),
                      )
                      : NewsContent(htmlContent: htmlContent),
            ),
        ],
      ),
    );
  }
}
