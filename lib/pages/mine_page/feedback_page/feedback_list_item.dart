import 'package:logistics_app/datas/home_notice_data.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class FeedbackListItem extends StatelessWidget {
  const FeedbackListItem({
    Key? key,
    this.noticeData,
    this.animationController,
    this.animation,
    this.callback,
  }) : super(key: key);

  final VoidCallback? callback;
  final HomeNoticeData? noticeData;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              50 * (1.0 - animation!.value),
              0.0,
            ),
            child: Container(
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: callback,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          // RouteUtils.pushNamed(context, RoutePath.WebViewPage,arguments:{'noticeTitle':noticeData.noticeTitle,'noticeId':noticeData.noticeId,'noticeContent':noticeData.noticeContent} );
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // 圆形图片
                                Container(
                                  width: 30,
                                  height: 30,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/snack.png',
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                    color: primaryColor,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        noticeData?.noticeTitle ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        noticeData?.createTime ?? '',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              child: Html(
                                data: noticeData?.noticeContent ?? '',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
