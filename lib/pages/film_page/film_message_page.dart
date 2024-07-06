import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/pages/film_page/film_message_model.dart';
import 'package:logistics_app/pages/notice_page/notice_view_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FilmMessagePage extends StatefulWidget {
  const FilmMessagePage({Key? key}) : super(key: key);
  @override
  _FilmMessagePage createState() => _FilmMessagePage();
}

class _FilmMessagePage extends State<FilmMessagePage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<FilmMessageModel> filmsDataList = FilmMessageModel.filmDataList;

  late RefreshController _refreshController;

  var model = NoticeViewModel();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _refreshController = RefreshController();

    super.initState();
    model.getNoticeModelList();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return model;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "我的消息",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: filmAppBarBackgroundColor,
          foregroundColor: Colors.white,
        ),
        backgroundColor: filmBackgroundColor,
        body: SafeArea(
          child: SmartRefreshWidget(
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () {
              //关闭刷新
              print('刷新完成');
              model.getNoticeModelList().then((value) {
                _refreshController.refreshCompleted();
              });
            },
            controller: _refreshController,
            child: SafeArea(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filmsDataList.length,
                    itemBuilder: (context, index) {
                      final int count = filmsDataList.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn)));
                      animationController?.forward();
                      return FilmMessageItem(
                        listData: filmsDataList[index],
                        callBack: () => {print('123')},
                        animation: animation,
                        animationController: animationController,
                      );
                    })),
          ),
        ),
      ),
    );
  }
}

class FilmMessageItem extends StatelessWidget {
  const FilmMessageItem(
      {Key? key,
      this.listData,
      this.callBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final FilmMessageModel? listData;
  final VoidCallback? callBack;
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
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: callBack,
                        child: Ink(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                listData!.createTime,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 8, bottom: 8),
                                  child: Container(
                                    width: double.infinity,
                                    // 设置圆角
                                    decoration: BoxDecoration(
                                        color: filmAppBarBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                listData!.title,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 5),
                                              decoration: BoxDecoration(
                                                color: getBackgroundColor(
                                                    listData!.type),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                getTypeText(listData!.type),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          listData!.content,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white
                                                  .withOpacity(0.8)),
                                        ),
                                        // 根据listData.type是否等于1或2显示组件
                                        showReplay(listData)
                                            ? Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  // 设置一个分割线
                                                  Container(
                                                    height: 1,
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '管理员回复：',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                secondaryColor),
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                        listData!.replay,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                primaryColor),
                                                      ))
                                                    ],
                                                  )
                                                ],
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ))));
        });
  }

  // 根据listData.type返回不同的颜色
  Color getBackgroundColor(type) {
    if (type == '1') {
      return primaryColor;
    } else if (type == '2') {
      return secondaryColor;
    } else if (type == '3') {
      return Colors.blue;
    } else {
      return Colors.white;
    }
  } // 根据listData.type返回不同的颜色

  String getTypeText(type) {
    if (type == '1') {
      return '求片';
    } else if (type == '2') {
      return '反馈';
    } else if (type == '3') {
      return '通知';
    } else {
      return '其他';
    }
  }

  bool showReplay(listData) {
    if (listData.type == '1' || listData.type == '2') {
      return listData.status == '1';
    } else {
      return false;
    }
  }
}
