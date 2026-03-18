import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'dart:math' as math;
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:flutter/foundation.dart';

@AppRoute(path: 'employee_detail_page', name: '员工风采详情页')
class EmployeeDetailPage extends StatefulWidget {
  const EmployeeDetailPage({Key? key, required this.noticeId})
    : super(key: key);

  final String noticeId;

  @override
  _EmployeeDetailPageState createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
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
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            // 背景图片
            Positioned.fill(
              top: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    Container(
                      height: 80.px,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/employee_top.png'),
                          alignment: Alignment.topRight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            noticeModel != null
                ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40.px),
                        padding: EdgeInsets.symmetric(horizontal: 32.px),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icon/icon.png',
                              width: 50.px,
                              height: 50.px,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'IWIP后勤服务',
                                  style: TextStyle(
                                    fontSize: 14.px,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                Text(
                                  'IWIPLogistics Services',
                                  style: TextStyle(
                                    fontSize: 10.px,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.px),

                      // ShaderMask(
                      //   shaderCallback: (Rect bounds) {
                      //     return LinearGradient(
                      //       colors: [Color(0xFF8AAE2B), Color(0xFF328638)],
                      //       begin: Alignment.topCenter,
                      //       end: Alignment.bottomCenter,
                      //     ).createShader(bounds);
                      //   },
                      //   blendMode: BlendMode.srcIn,
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(horizontal: 16.px),
                      //     width: double.infinity,
                      //     child: Text(
                      //       noticeModel?.noticeTitle ?? '',
                      //       style: TextStyle(
                      //         fontSize: 18.px,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //       textAlign: TextAlign.left,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 10.px),
                      // 员工图片
                      // Container(
                      //   width: double.infinity,
                      //   height: 350.px, // 给定高度以容纳布局
                      //   padding: EdgeInsets.only(left: 40.px),
                      //   child: Stack(
                      //     alignment: Alignment.center,
                      //     children: [
                      //       // 背景黄色装饰 (Background Yellow decoration)
                      //       Positioned(
                      //         top: 20.px,
                      //         left: 0,
                      //         child: Container(
                      //           width: 235.px,
                      //           height: 282.px,
                      //           decoration: BoxDecoration(
                      //             image: DecorationImage(
                      //               image: AssetImage(
                      //                 'assets/images/employee_avatar.png',
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       // 头像 (Profile Image)
                      //       Positioned(
                      //         top: 0,
                      //         // 居中
                      //         child: Container(
                      //           padding: EdgeInsets.all(10.px),
                      //           child: Container(
                      //             width: 350.px,
                      //             height: 350.px,
                      //             child: ClipPath(
                      //               // 1. 这里调用自定义的裁剪器
                      //               clipper: MyShapeClipper(),
                      //               child: Container(
                      //                 width: 350.px,
                      //                 height: 250.px,
                      //                 // 2. 图片可以直接用 Image 组件，或者保留在 decoration 里都可以
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.green,
                      //                   image: DecorationImage(
                      //                     image: NetworkImage(
                      //                       APIs.imagePrefix +
                      //                           noticeModel!.img!,
                      //                     ),
                      //                     fit: BoxFit.cover, // 确保图片填满裁剪区域
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       // 姓名标签 (Name Tag)
                      //       Positioned(
                      //         bottom: 0.px,
                      //         left: 0.px,
                      //         child: Container(
                      //           width: 120.px,
                      //           height: 120.px,
                      //           decoration: BoxDecoration(
                      //             image: DecorationImage(
                      //               image: AssetImage(
                      //                 'assets/images/employee_name.png',
                      //               ),
                      //               fit: BoxFit.cover,
                      //               alignment: Alignment.center,
                      //             ),
                      //           ),
                      //           child: Column(
                      //             mainAxisSize: MainAxisSize.min,
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Text(
                      //                 noticeModel?.name ?? S.of(context).name,
                      //                 style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontSize: 20.px,
                      //                   fontWeight: FontWeight.bold,
                      //                   letterSpacing: 2,
                      //                 ),
                      //               ),
                      //               SizedBox(height: 4.px),
                      //               Container(
                      //                 constraints: BoxConstraints(
                      //                   maxWidth: 160.px,
                      //                 ),
                      //                 child: Text(
                      //                   noticeModel?.createDept ??
                      //                       S.of(context).dept,
                      //                   style: TextStyle(
                      //                     color: Colors.white.withOpacity(0.9),
                      //                     fontSize: 10.px,
                      //                   ),
                      //                   maxLines: 2,
                      //                   overflow: TextOverflow.ellipsis,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // 信息
                      Stack(
                        children: [
                          // 背景图片
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/employee_bg.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          // 渐变覆盖
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFFFFFF),
                                    Color(0xFFFFFFFF),
                                    Color(0xFFFFFFFF).withOpacity(0.8),
                                    Color(0xFFFFFFFF).withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 0.8, 0.9, 1.0],
                                ),
                              ),
                            ),
                          ),
                          // 内容
                          Container(
                            padding: EdgeInsets.all(16.px),
                            margin: EdgeInsets.only(bottom: 32.px),
                            width: double.infinity,
                            child: Container(
                              padding: EdgeInsets.all(4.px),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFF328638)),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10.px),
                              ),
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
                            ),
                          ),
                          // Bottom background
                          Positioned.fill(
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/employee_bottom.png',
                                  ),
                                  alignment: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                : Container(child: Center(child: Text(S.of(context).loading))),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 6,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                ),
                color: Colors.black,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // --- 你的原始路径代码 Start ---
    // 注意：第一行建议改为 moveTo，虽然 lineTo 也能工作（默认从0,0开始连线会多一条线）
    path.moveTo(size.width * 0.07, size.height * 1.99);

    path.cubicTo(
      size.width * 0.03,
      size.height * 2.09,
      size.width * 0.09,
      size.height * 2.21,
      size.width / 5,
      size.height * 2.23,
    );
    path.cubicTo(
      size.width * 0.29,
      size.height * 2.25,
      size.width * 0.37,
      size.height * 2.25,
      size.width * 0.45,
      size.height * 2.25,
    );
    path.cubicTo(
      size.width * 0.69,
      size.height * 2.23,
      size.width * 0.85,
      size.height * 2.22,
      size.width * 0.95,
      size.height * 2.12,
    );
    path.cubicTo(
      size.width * 1.03,
      size.height * 2.05,
      size.width * 1.04,
      size.height * 2.01,
      size.width * 1.06,
      size.height * 1.93,
    );
    path.cubicTo(
      size.width * 1.07,
      size.height * 1.87,
      size.width * 1.05,
      size.height * 1.81,
      size.width * 1.02,
      size.height * 1.77,
    );
    path.cubicTo(
      size.width * 1.02,
      size.height * 1.77,
      size.width * 0.7,
      size.height * 1.34,
      size.width * 0.7,
      size.height * 1.34,
    );
    path.cubicTo(
      size.width * 0.59,
      size.height * 1.2,
      size.width * 0.37,
      size.height * 1.23,
      size.width * 0.31,
      size.height * 1.39,
    );
    path.cubicTo(
      size.width * 0.31,
      size.height * 1.39,
      size.width * 0.23,
      size.height * 1.59,
      size.width * 0.23,
      size.height * 1.59,
    );
    path.cubicTo(
      size.width * 0.23,
      size.height * 1.59,
      size.width * 0.07,
      size.height * 1.99,
      size.width * 0.07,
      size.height * 1.99,
    );
    // 这里的最后一段 cubicTo 看参数似乎是原地打转，可能转换工具有问题，但保留也没事
    path.close(); // 闭合路径
    // --- 你的原始路径代码 End ---
    Matrix4 matrix = Matrix4.rotationZ(-math.pi / 2);
    path = path.transform(matrix.storage);
    // 计算需要移动的距离：把路径的左上角移动到 (0,0)
    // 如果你想居中，逻辑会更复杂一点，但通常对齐左上角就够了
    Rect bounds = path.getBounds();
    path = path.shift(Offset(-bounds.left, -bounds.top));
    double scaleFactor = 0.8;
    Matrix4 scaleMatrix = Matrix4.diagonal3Values(
      scaleFactor,
      scaleFactor,
      1.0,
    );
    path = path.transform(scaleMatrix.storage);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
