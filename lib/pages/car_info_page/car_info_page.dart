import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logistics_app/common_ui/switch_type.dart';
import 'package:logistics_app/datas/route_query_data.dart';
import 'package:logistics_app/model/route_query_vm.dart';
import 'package:logistics_app/utils/color.dart';

class CarInfoPage extends StatefulWidget {
  const CarInfoPage({Key? key}) : super(key: key);

  @override
  _CarInfoPageState createState() => _CarInfoPageState();
}

class _CarInfoPageState extends State<CarInfoPage>
    with TickerProviderStateMixin {
  List<RouteQueryDataData> routeQueryList = RouteQueryVmData.routeList;
  AnimationController? animationController;

  Animation<double>? switchAnimation;
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    switchAnimation = CurvedAnimation(
        parent: animationController!,
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  int current = 0;

  //更新焦点的事件名
  void updateCurrent(int value) {
    setState(() {
      current = value;
      print(current);
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  final List<SwitchType> buttonLabels = [
    SwitchType('公交车辆', 0),
    SwitchType('其他车辆', 1),
  ];

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            '车辆信息',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Flex(
            direction: Axis.vertical,
            children: [
              SwitchTypeView(
                listData: buttonLabels,
                callBack: (int value) {
                  print(value);
                  updateCurrent(value);
                },
                animationController: animationController,
                animation: switchAnimation,
                current: current,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 0, left: 12, right: 12),
                  itemCount: routeQueryList.length,
                  itemBuilder: (context, index) {
                    final int count = routeQueryList.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    animationController?.forward();
                    return CarInfoPageView(
                      busInfo: BusInfo(
                        vehicleNumber: 'IWIP-BUS-07',
                        route: '2C',
                        status: '正常运行',
                        model: '大巴车',
                        capacity: 60,
                        imageUrl: 'https://via.placeholder.com/150',
                      ),
                      animation: animation,
                      animationController: animationController,
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}

class CarInfoPageView extends StatelessWidget {
  final BusInfo busInfo;

  CarInfoPageView(
      {required this.busInfo, this.animation, this.animationController});

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
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 10),
                    // 超出隐藏
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(busInfo.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 120,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, left: 10.0, right: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${busInfo.vehicleNumber}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // 状态模块
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '正常运行',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '线路号: ${busInfo.route}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '车型: ${busInfo.model}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '核载人数: ${busInfo.capacity} 人',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )));
        });
  }
}

class BusInfo {
  final String vehicleNumber;
  final String route;
  final String status;
  final String model;
  final int capacity;
  final String imageUrl;

  BusInfo({
    required this.vehicleNumber,
    required this.route,
    required this.status,
    required this.model,
    required this.capacity,
    required this.imageUrl,
  });
}
