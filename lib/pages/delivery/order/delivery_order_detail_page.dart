import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/delivery_order_detail_model.dart';
import 'package:logistics_app/http/model/delivery_station_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryOrderDetailPage extends StatefulWidget {
  const DeliveryOrderDetailPage({super.key, required this.orderNo});

  final String orderNo;

  @override
  _DeliveryOrderDetailPageState createState() =>
      _DeliveryOrderDetailPageState();
}

class _DeliveryOrderDetailPageState extends State<DeliveryOrderDetailPage>
    with TickerProviderStateMixin {
  // 轨迹
  List<LatLng> trackPoints = [];
  // 当前位置
  Position? _currentPosition;
  Position? _deliveryStaffPosition;
  DeliveryOrderDetailModel? _orderDetail;
  List<StatusNodes>? statusNodes;
  DeliveryStationModel? deliveryStation;
  bool _showDetail = true;
  double _lastOffset = 0;
  final DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    getOrderDetail();
    _getCurrentLocation();
    _draggableScrollableController.addListener(() {
      if (_draggableScrollableController.size < 0.3) {
        if (_showDetail) {
          setState(() => _showDetail = false);
        }
      } else {
        if (!_showDetail) {
          setState(() => _showDetail = true);
        }
      }
    });
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();
  }

  Future<void> _fetchDeliveryStationInfo(String code) async {
    DataUtils.getDeliveryStationByCode(
      {'code': code},
      success: (data) {
        setState(() {
          deliveryStation = DeliveryStationModel.fromJson(data['data']);
        });
      },
    );
  }

  // 获取订单详情
  Future<void> getOrderDetail() async {
    DataUtils.getDeliveryOrderDetail(
      {'orderNo': widget.orderNo},
      success: (data) {
        _orderDetail = DeliveryOrderDetailModel.fromJson(data['data']);
        if (_orderDetail?.orderDelivery?.code != null) {
          _fetchDeliveryStationInfo(_orderDetail?.orderDelivery?.code ?? '');
        }

        setState(() {
          statusNodes = _orderDetail?.statusNodes;
          trackPoints =
              _orderDetail?.orderDeliveryLocations
                  ?.map(
                    (e) => LatLng(
                      double.parse(e.latitude ?? '0'),
                      double.parse(e.longitude ?? '0'),
                    ),
                  )
                  .toList() ??
              [];
          if (_orderDetail?.orderDelivery?.deliveryStatus == 1 &&
              trackPoints.length > 0) {
            _deliveryStaffPosition = Position(
              latitude: double.parse(trackPoints.last.latitude.toString()),
              longitude: double.parse(trackPoints.last.longitude.toString()),
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              altitudeAccuracy: 0,
              heading: 0,
              headingAccuracy: 0,
              speed: 0,
              speedAccuracy: 0,
            );
          }
        });
      },
      fail: (error, message) {
        ProgressHUD.showError(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).deliveryOrderDetail,
          style: TextStyle(fontSize: 16.px),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                0.48037046303693953,
                127.9839849472046,
              ), // 默认经纬度，丹江坞食堂
              initialZoom: 16,
              maxZoom: 20,
              minZoom: 12,
            ),
            children: [
              // 地图底图
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              // 自定义地图图层
              OverlayImageLayer(
                overlayImages: [
                  OverlayImage(
                    imageProvider: AssetImage('assets/images/south-all.webp'),
                    bounds: LatLngBounds(
                      LatLng(0.462128, 128.047638),
                      LatLng(0.554159, 127.883903),
                    ),
                  ),
                ],
              ),
              // 绘制轨迹的图层
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: trackPoints, // 轨迹点
                    strokeWidth: 4.0, // 线宽
                    color: Colors.deepOrange, // 轨迹颜色
                  ),
                ],
              ),
              // 发货点标点
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      double.parse(deliveryStation?.latitude ?? '0'),
                      double.parse(deliveryStation?.longitude ?? '0'),
                    ),
                    height: 50.px,
                    width: 120.px,
                    // 给标点添加动画
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.px),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.px),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.px),
                                margin: EdgeInsets.all(2.px),
                                decoration: BoxDecoration(
                                  color: secondaryColor[50],
                                  borderRadius: BorderRadius.circular(1.px),
                                ),
                                child: Text(
                                  '发',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 10.px,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.px),
                              Expanded(
                                child: Text(
                                  deliveryStation?.sourceStation ?? '',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.px,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.location_on,
                          color: primaryColor,
                          size: 24.px,
                        ),
                      ],
                    ),
                  ),
                  // 配送员位置
                  if (_orderDetail?.orderDelivery?.deliveryStatus == 1)
                    Marker(
                      point: LatLng(
                        _deliveryStaffPosition?.latitude ?? 0,
                        _deliveryStaffPosition?.longitude ?? 0,
                      ),
                      height: 50.px,
                      width: 80.px,
                      // 给标点添加动画
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.px),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.px),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2.px),
                                  margin: EdgeInsets.all(2.px),
                                  decoration: BoxDecoration(
                                    color: secondaryColor[50],
                                    borderRadius: BorderRadius.circular(1.px),
                                  ),
                                  child: Text(
                                    '送',
                                    style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 10.px,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.px),
                                Expanded(
                                  child: Text(
                                    '正在配送中...',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.px,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.delivery_dining,
                            color: secondaryColor,
                            size: 24.px,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              // 配送员位置
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      _currentPosition?.latitude ?? 0,
                      _currentPosition?.longitude ?? 0,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 24.px,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 底部信息栏
          DraggableScrollableSheet(
            controller: _draggableScrollableController,
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.7,
            snap: true,
            snapSizes: const [0.1, 0.3, 0.7],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.px),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 拖动指示器
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8.px),
                          width: 40.px,
                          height: 4.px,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2.px),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(),
                        padding: EdgeInsets.symmetric(
                          vertical: 5.px,
                          horizontal: 10.px,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.px,
                                  backgroundColor: Colors.grey[200],
                                  child: Icon(
                                    Icons.delivery_dining,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 10.px),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _orderDetail?.deliveryStaff?.nickName ??
                                          '',
                                      style: TextStyle(fontSize: 14.px),
                                    ),
                                    SmoothStarRating(
                                      allowHalfRating: false,
                                      starCount: 5,
                                      rating: 5.0,
                                      size: 14.px,
                                      color: secondaryColor,
                                      borderColor: secondaryColor,
                                      spacing: 0.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            OutlinedButton(
                              onPressed: () {
                                launchUrl(
                                  Uri.parse(
                                    'tel:${_orderDetail?.deliveryStaff?.tel}',
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(40.px, 10.px),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.px,
                                  vertical: 4.px,
                                ),
                                side: BorderSide(color: primaryColor),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    size: 14.px,
                                    color: primaryColor,
                                  ),
                                  SizedBox(width: 4.px),
                                  Text(
                                    S.of(context).contact,
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12.px,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedCrossFade(
                        crossFadeState:
                            _showDetail
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: Duration(milliseconds: 300),
                        firstChild: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.px,
                            horizontal: 16.px,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.px),
                            color: Colors.white,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.px,
                              horizontal: 16.px,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.px),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.delivery_dining,
                                      size: 24.px,
                                      color: secondaryColor,
                                    ),
                                    SizedBox(width: 4.px),
                                    Text(
                                      S.of(context).deliveryOrderNo + ': ',
                                      style: TextStyle(
                                        fontSize: 12.px,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      '${_orderDetail?.orderDelivery?.deliveryNo}',
                                      style: TextStyle(
                                        fontSize: 14.px,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.px),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 24.px,
                                      color: primaryColor,
                                    ),
                                    SizedBox(width: 4.px),
                                    Text(
                                      S.of(context).deliveryAddress +
                                          ': ${_orderDetail?.orderDelivery?.deliveryAddress}',
                                      style: TextStyle(
                                        fontSize: 12.px,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.px),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    for (
                                      int index = 0;
                                      index < (statusNodes?.length ?? 0);
                                      index++
                                    )
                                      TimelineTile(
                                        isFirst: index == 0,
                                        isLast:
                                            index ==
                                            (statusNodes?.length ?? 0) - 1,
                                        indicatorStyle: const IndicatorStyle(
                                          width: 10,
                                          color: secondaryColor,
                                          indicatorXY: 0.2,
                                          padding: EdgeInsets.all(8),
                                        ),
                                        beforeLineStyle: LineStyle(
                                          color: Colors.grey[300]!,
                                          thickness: 2,
                                        ),
                                        endChild: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 4.px),
                                              Row(
                                                children: [
                                                  Text(
                                                    _getStatusText(
                                                      statusNodes?[index].status
                                                              .toString() ??
                                                          '',
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 14.px,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          index == 0
                                                              ? secondaryColor
                                                              : Colors
                                                                  .grey[400],
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.px),
                                                  Text(
                                                    '${statusNodes?[index].time ?? ''}',
                                                    style: TextStyle(
                                                      fontSize: 12.px,
                                                      color:
                                                          index == 0
                                                              ? secondaryColor
                                                              : Colors
                                                                  .grey[400],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4.px),
                                              Text(
                                                S.of(context).operator +
                                                    ': ${statusNodes?[index].deliveryStaffMsg ?? ''}',
                                                style: TextStyle(
                                                  fontSize: 12.px,
                                                  color:
                                                      index == 0
                                                          ? Colors.black
                                                          : Colors.grey[400],
                                                ),
                                              ),
                                              SizedBox(height: 4.px),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (_orderDetail
                                            ?.orderDelivery
                                            ?.deliveryStatus ==
                                        2 ||
                                    _orderDetail
                                            ?.orderDelivery
                                            ?.deliveryStatus ==
                                        3)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 6.px),
                                      Text(
                                        '送达照片',
                                        style: TextStyle(
                                          fontSize: 14.px,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 6.px),
                                      Container(
                                        height: 100.px,
                                        width: 100.px,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8.px,
                                          ),
                                        ),
                                        // PhotoView(
                                        //   imageProvider: NetworkImage(
                                        //     APIs.imagePrefix +
                                        //         (_orderDetail
                                        //                 ?.orderDelivery
                                        //                 ?.msg ??
                                        //             ''),
                                        //   ),
                                        //   backgroundDecoration:
                                        //       const BoxDecoration(
                                        //         color: Colors.black,
                                        //       ),
                                        // )
                                        child: GestureDetector(
                                          child: Image.network(
                                            APIs.imagePrefix +
                                                (_orderDetail
                                                        ?.orderDelivery
                                                        ?.msg ??
                                                    ''),
                                          ),
                                          onTap: () {
                                            showGeneralDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              barrierLabel: 'Image Preview',
                                              barrierColor: Colors.black
                                                  .withOpacity(0.9),
                                              transitionDuration: Duration(
                                                milliseconds: 300,
                                              ),
                                              pageBuilder: (
                                                context,
                                                anim1,
                                                anim2,
                                              ) {
                                                return Center(
                                                  child: PhotoView(
                                                    imageProvider: NetworkImage(
                                                      APIs.imagePrefix +
                                                          (_orderDetail
                                                                  ?.orderDelivery
                                                                  ?.msg ??
                                                              ''),
                                                    ),
                                                    backgroundDecoration:
                                                        const BoxDecoration(
                                                          color: Colors.black,
                                                        ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        secondChild: SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 检查服务是否启用
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {});
      return;
    }

    // 检查权限
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ProgressHUD.showError('请开启定位权限');
        setState(() {});
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ProgressHUD.showError('请开启定位权限');
      setState(() {});
      return;
    }

    // 获取当前位置
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // setState(() {
    //   print('position::${position}');
    //   _currentPosition = position;
    // });
  }

  // 获取状态文本
  String _getStatusText(String? status) {
    switch (status) {
      case '0':
        return '待接单';
      case '1':
        return '配送中';
      case '2':
        return '已送达';
      case '3':
        return '已收货';
      case '4':
        return '已评价';
      case '99':
        return '待打包';
      default:
        return '未知状态';
    }
  }
}
