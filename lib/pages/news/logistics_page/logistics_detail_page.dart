import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/pages/news/news_page/news_content.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/foundation.dart';

@AppRoute(path: 'logistics_detail_page', name: '后勤动态详情页')
class LogisticsDetailPage extends StatefulWidget {
  const LogisticsDetailPage({Key? key, required this.noticeId})
    : super(key: key);

  final String noticeId;

  @override
  _LogisticsDetailPageState createState() => _LogisticsDetailPageState();
}

class _LogisticsDetailPageState extends State<LogisticsDetailPage> {
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

  String fixHtmlImageUrls(String html) {
    final imgRegex = RegExp(r'src="([^"]+)"');
    return html.replaceAllMapped(imgRegex, (match) {
      final rawUrl = match.group(1)!;
      final fixedUrl = Uri.encodeFull(rawUrl);
      return 'src="$fixedUrl"';
    });
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
        body { font-family: sans-serif; margin: 0; padding: 0; font-family: 'PingFang SC';}
        p { font-size: 12px; font-family: 'PingFang SC'; }
        h1 { font-size: 16px; font-family: 'PingFang SC'; }
        h2 { font-size: 14px; font-family: 'PingFang SC'; }
        h3 { font-size: 12px; font-family: 'PingFang SC'; }
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
      <div style="padding: 16px;">
      ${fixHtmlImageUrls(noticeModel?.noticeContent ?? "<p>No content</p>")}
      </div>
    </body>
  </html>
  ''';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(fontSize: 16.px),
          textAlign: TextAlign.left,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.px, horizontal: 15.px),
            child: Column(
              children: [
                Text(
                  noticeModel?.noticeTitle ?? '',
                  style: TextStyle(
                    fontSize: 16.px,
                    fontWeight: FontWeight.bold,
                  ),
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
              ],
            ),
          ),
          SizedBox(height: 10.px),
          if (noticeModel?.noticeContent != null)
            Expanded(
              child:
                  kIsWeb
                      ? SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 12.px),
                        child: Html(
                          data: fixHtmlImageUrls(
                            noticeModel?.noticeContent ?? '',
                          ),
                          // 字体大小
                          style: {
                            "body": Style(fontSize: FontSize(12.px)),
                            "p": Style(fontSize: FontSize(12.px)),
                          },
                        ),
                      )
                      : NewsContent(htmlContent: htmlContent),
            ),
        ],
      ),
    );
  }
}
