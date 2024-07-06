import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/pages/film_page/film_download_model.dart';
import 'package:logistics_app/pages/notice_page/notice_view_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/format_file_size.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FilmDownloadPage extends StatefulWidget {
  const FilmDownloadPage({Key? key}) : super(key: key);
  @override
  _FilmDownloadPage createState() => _FilmDownloadPage();
}

class _FilmDownloadPage extends State<FilmDownloadPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<FilmDownloadModel> filmsDataList = FilmDownloadModel.filmDownList;

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
            "下载",
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
                      return FilmDownloadItem(
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

class FilmDownloadItem extends StatelessWidget {
  const FilmDownloadItem(
      {Key? key,
      this.listData,
      this.callBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final FilmDownloadModel? listData;
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
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 8, bottom: 8),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      // 圆角
                                      borderRadius: BorderRadius.circular(4),
                                      image: DecorationImage(
                                        image: AssetImage(listData!.imagePath),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 5),
                                    child: Row(children: [
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            listData!.title,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          listData!.percentage == 100
                                              ? Row(
                                                  children: [
                                                    Text(
                                                        listData!.status == 1
                                                            ? '已观看'
                                                            : '未观看',
                                                        style: TextStyle(
                                                            color: Colors.white
                                                                .withAlpha(
                                                                    90))),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                        formatFileSize(
                                                            listData!.size),
                                                        style: TextStyle(
                                                            color: Colors.white
                                                                .withAlpha(90)))
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    // 线性进度条
                                                    LinearProgressIndicator(
                                                        value: listData!
                                                                .percentage /
                                                            100,
                                                        backgroundColor:
                                                            primaryColor
                                                                .withAlpha(90),
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                primaryColor),
                                                        minHeight: 2),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text('下载中',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withAlpha(
                                                                        90))),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text('3.8M/s',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withAlpha(
                                                                        90)))
                                                      ],
                                                    )
                                                  ],
                                                )
                                        ],
                                      )),
                                      if (listData!.percentage == 100)
                                        GestureDetector(
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white.withAlpha(90),
                                          ),
                                          onTap: () => showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('提示'),
                                                content: Text('确定删除该文件吗？'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () => {
                                                      print('取消'),
                                                      Navigator.of(context)
                                                          .pop()
                                                    },
                                                    child: Text('取消'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => {
                                                      print('确定'),
                                                      Navigator.of(context)
                                                          .pop()
                                                    },
                                                    child: Text('确定'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                    ]),
                                  )),
                                ]),
                          ),
                        ),
                      ))));
        });
  }
}
