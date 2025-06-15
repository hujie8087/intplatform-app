import 'package:flutter/material.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/model/bus_line_model.dart';
import 'package:logistics_app/pages/route_query_page/route_query_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:photo_view/photo_view.dart';

class RouteQueryDetail extends StatefulWidget {
  const RouteQueryDetail({Key? key, this.listData}) : super(key: key);

  final BusLineModel? listData;

  @override
  _RouteQueryDetailState createState() => _RouteQueryDetailState();
}

class _RouteQueryDetailState extends State<RouteQueryDetail>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  Animation<double>? imageAnimation;
  String title = '';
  CarSiteList? startStation;
  CarSiteList? endStation;

  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    imageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    animationController?.forward();
    super.initState();
    setState(() {
      startStation = widget.listData!.carSiteList![0];
      endStation =
          widget.listData!.carSiteList![widget.listData!.carSiteList!.length -
              1];
      title =
          '${widget.listData!.lineName} ${startStation!.name}~${endStation!.name}';
    });
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
              imageProvider: NetworkImage(imagePath),
              backgroundDecoration: BoxDecoration(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title, style: TextStyle(fontSize: 16.px)),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          // 禁止滚动
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                BusLineView(
                  animation: animation,
                  animationController: animationController,
                  listData: widget.listData,
                ),
                // 时刻表
                AnimatedBuilder(
                  animation: animationController!,
                  builder: (BuildContext context, Widget? child) {
                    return FadeTransition(
                      opacity: imageAnimation!,
                      child: Transform(
                        transform: Matrix4.translationValues(
                          0.0,
                          50 * (1.0 - imageAnimation!.value),
                          0.0,
                        ),
                        child: Card(
                          margin: EdgeInsets.only(
                            left: 10.px,
                            right: 10.px,
                            bottom: 10.px,
                          ),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.px),
                          ),
                          child: _buildTimeGrid(
                            widget.listData!.carDepartureTimeList!,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (widget.listData!.linePath != null)
                  AnimatedBuilder(
                    animation: animationController!,
                    builder: (BuildContext context, Widget? child) {
                      return FadeTransition(
                        opacity: imageAnimation!,
                        child: Transform(
                          transform: Matrix4.translationValues(
                            0.0,
                            50 * (1.0 - imageAnimation!.value),
                            0.0,
                          ),
                          child: Card(
                            margin: EdgeInsets.only(
                              left: 10.px,
                              right: 10.px,
                              bottom: 10.px,
                            ),
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.px),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _showFullScreenImage(
                                  context,
                                  APIs.imagePrefix + widget.listData!.linePath!,
                                );
                              },
                              child: Image.network(
                                APIs.imagePrefix +
                                    widget.listData!.linePath!, // 替换为你的图片路径
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildTimeGrid(List<CarDepartureTimeList> trips) {
  return Container(
    padding: EdgeInsets.all(10.px),
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, size: 20.px, color: primaryColor),
            SizedBox(width: 5.px),
            Text('时刻表', style: TextStyle(fontSize: 14.px)),
          ],
        ),
        SizedBox(height: 10.px),
        Wrap(
          spacing: 5.px,
          runSpacing: 5.px,
          children:
              trips.map((trip) {
                // 判断班次是否已过期
                bool isExpired = false;
                if (trip.departureTime != null) {
                  List<String> timeParts = trip.departureTime!
                      .split(':')
                      .sublist(0, 2);
                  if (timeParts.length == 2) {
                    DateTime now = DateTime.now();
                    DateTime tripTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      int.parse(timeParts[0]),
                      int.parse(timeParts[1]),
                    );
                    isExpired = now.isAfter(tripTime);
                  }
                }

                return GestureDetector(
                  onTap: () {
                    // 显示班次详情
                    // _showTripDetails(trip);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.px,
                      vertical: 3.px,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isExpired
                              ? Colors.grey[200]
                              : primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.px),
                      border: Border.all(
                        color: isExpired ? Colors.grey : primaryColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      trip.departureTime?.split(':').sublist(0, 2).join(':') ??
                          '--:--',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: isExpired ? Colors.grey : primaryColor,
                        fontWeight:
                            isExpired ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    ),
  );
}

class RouteQueryView extends StatelessWidget {
  const RouteQueryView({
    Key? key,
    this.listData,
    this.callBack,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final BusLineModel? listData;
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
              0.0,
              50 * (1.0 - animation!.value),
              0.0,
            ),
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
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  top: 5,
                                  left: 10,
                                  right: 10,
                                  bottom: 5,
                                ),
                                decoration: BoxDecoration(color: primaryColor),
                                child: Row(
                                  children: [
                                    Text(
                                      listData!.lineName ?? '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            listData!.carSiteList![0].name ??
                                                '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.swap_horiz,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            listData!
                                                    .carDepartureTimeList![0]
                                                    .departureTime ??
                                                '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
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
                                        SizedBox(width: 5),
                                        Text(
                                          listData!
                                                  .carDepartureTimeList![0]
                                                  .departureTime ??
                                              '',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        SizedBox(width: 15),
                                        Image.asset(
                                          'assets/images/endStation.png',
                                          width: 20,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          listData!
                                                  .carDepartureTimeList![listData!
                                                          .carDepartureTimeList!
                                                          .length -
                                                      1]
                                                  .departureTime ??
                                              '',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  bottom: 20,
                                ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    listData!.carSiteList!.length,
                                    (index) {
                                      // 生成固定数量的项目
                                      return SizedBox(
                                        width: 30.px, // 固定宽度，避免旋转后溢出
                                        child: Stack(
                                          alignment: Alignment.topLeft,
                                          // 超出不隐藏
                                          clipBehavior: Clip.none,
                                          children: [
                                            // 中文竖排（默认从上往下）
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: 10.px,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children:
                                                    listData!
                                                        .carSiteList![index]
                                                        .name!
                                                        .split('')
                                                        .map(
                                                          (char) => Text(
                                                            char,
                                                            style: TextStyle(
                                                              fontSize: 12.px,
                                                              height: 1.2,
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                              ),
                                            ),

                                            // 旋转后的印尼文，固定底部对齐
                                            Positioned(
                                              top: 0.px,
                                              left: 10.px,
                                              child: Transform(
                                                alignment: Alignment.topLeft,
                                                transform:
                                                    Matrix4.identity()..rotateZ(
                                                      90 * 3.1415926535 / 180,
                                                    ),
                                                child: Text(
                                                  listData!
                                                          .carSiteList![index]
                                                          .indonesianName ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 10.px,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
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
          ),
        );
      },
    );
  }
}
