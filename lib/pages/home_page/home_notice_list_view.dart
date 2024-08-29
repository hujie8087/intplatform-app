import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/route/routes.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logistics_app/utils/utils.dart';

class HomeNoticeListView extends StatelessWidget {
  const HomeNoticeListView(
      {Key? key,
      this.noticeData,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback? callback;
  final NoticeModel? noticeData;
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
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Container(
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: callback,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          Utils.sendMobpushMessage(1, '消息通知', 1, '');
                          RouteUtils.pushNamed(context, RoutePath.WebViewPage,
                              arguments: {
                                'noticeTitle': noticeData?.noticeTitle,
                                'noticeId': noticeData?.noticeId,
                                'noticeContent': noticeData?.noticeContent
                              });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            'assets/fitness_app/snack.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      color: primaryColor),
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(noticeData?.noticeTitle ?? '',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    Text(noticeData?.createTime ?? '',
                                        style: TextStyle(fontSize: 12))
                                  ],
                                )),
                                SizedBox(width: 10),
                                // 是否已查看
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  child: Text(
                                    '已查看',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              constraints: BoxConstraints(
                                maxHeight: 70.0, // 限制最大高度为100.0
                              ),
                              child: SingleChildScrollView(
                                  child: Html(
                                data: noticeData?.noticeContent ?? '',
                              )),
                            )
                          ],
                        ),
                      ),
                    )
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
