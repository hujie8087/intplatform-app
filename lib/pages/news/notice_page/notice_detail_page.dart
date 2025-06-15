import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/image_preview_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
      appBar: AppBar(
        title: Text(
          noticeDetail?.noticeTitle ?? '',
          style: TextStyle(fontSize: 16.px),
          textAlign: TextAlign.left,
        ),
      ),
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
              child: WebViewWidget(
                controller:
                    WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..addJavaScriptChannel(
                        'ImageChannel',
                        onMessageReceived: (message) {
                          final imageUrl = message.message;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ImagePreviewPage(imageUrl: imageUrl),
                            ),
                          );
                        },
                      )
                      ..loadHtmlString(htmlContent),
              ),
            ),
        ],
      ),
    );
  }
}
