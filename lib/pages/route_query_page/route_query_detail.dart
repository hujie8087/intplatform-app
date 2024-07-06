import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:logistics_app/datas/route_query_data.dart';
import 'package:logistics_app/model/route_query_vm.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:photo_view/photo_view.dart';

class RouteQueryDetail extends StatefulWidget {
  const RouteQueryDetail({Key? key}) : super(key: key);

  @override
  _RouteQueryDetailState createState() => _RouteQueryDetailState();
}

class _RouteQueryDetailState extends State<RouteQueryDetail>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  Animation<double>? imageAnimation;

  List<RouteQueryDataData> routeQueryList = RouteQueryVmData.routeList;

  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));
    imageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  void _showFullScreenImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: PhotoView(
              imageProvider: AssetImage(imagePath),
              backgroundDecoration: BoxDecoration(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = 'assets/images/1line.png';
    return SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '1号线路详情',
              style: TextStyle(fontSize: 18),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            // 禁止滚动
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  RouteQueryView(
                    animation: animation,
                    animationController: animationController,
                    listData: routeQueryList[0],
                  ),
                  AnimatedBuilder(
                      animation: animationController!,
                      builder: (BuildContext context, Widget? child) {
                        return FadeTransition(
                            opacity: imageAnimation!,
                            child: Transform(
                                transform: Matrix4.translationValues(0.0,
                                    50 * (1.0 - imageAnimation!.value), 0.0),
                                child: Card(
                                  margin: EdgeInsets.only(bottom: 15),
                                  clipBehavior: Clip.antiAlias,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showFullScreenImage(context, imagePath);
                                    },
                                    child: Image.asset(
                                      imagePath, // 替换为你的图片路径
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                )));
                      }),
                ],
              ),
            ),
          ),
        ));
  }
}

class RouteQueryView extends StatelessWidget {
  const RouteQueryView(
      {Key? key,
      this.listData,
      this.callBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final RouteQueryDataData? listData;
  final VoidCallback? callBack;
  final AnimationController? animationController;
  final Animation<double>? animation;
  @override
  Widget build(BuildContext context) {
    String lastItem = listData!.def1!.isNotEmpty
        ? listData!.def1![listData!.def1!.length - 1]
        : '';
    return AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 50 * (1.0 - animation!.value), 0.0),
                  child: Card(
                    margin: EdgeInsets.only(bottom: 15),
                    clipBehavior: Clip.antiAlias,
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: ClipRRect(
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Positioned.fill(
                                child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(
                                          top: 5,
                                          left: 10,
                                          right: 10,
                                          bottom: 5),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            listData!.lineNo,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                            textAlign: TextAlign.left,
                                          ),
                                          Expanded(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                listData!.def1![0],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.swap_horiz,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                lastItem,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/firstStation.png',
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                listData!.def2 ?? '',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Image.asset(
                                                'assets/images/endStation.png',
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                listData!.def3 ?? '',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 20),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: primaryColor,
                                            width: 4,
                                          ),
                                        ),
                                      ),
                                      width: double.infinity,
                                      child: Row(
                                          children: List.generate(
                                              listData!.def1!.length, (index) {
                                        // 生成固定数量的项目
                                        return Expanded(
                                          child: Column(
                                              children: listData!.def1![index]
                                                  .split('')
                                                  .map((char) {
                                            return Text(char,
                                                style: TextStyle(fontSize: 12));
                                          }).toList()),
                                        );
                                      })),
                                    )
                                  ]),
                            )),
                          ],
                        ),
                      ),
                    ),
                  )));
        });
  }
}
