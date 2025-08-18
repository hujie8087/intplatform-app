import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DetailProgressPage extends StatefulWidget {
  final MealDeliveryOrderModel order;
  const DetailProgressPage({Key? key, required this.order}) : super(key: key);

  @override
  _DetailProgressPageState createState() => _DetailProgressPageState();
}

class _DetailProgressPageState extends State<DetailProgressPage> {
  IconData getOrderStatusIcon(int statusCode) {
    switch (statusCode) {
      case 0:
        return Icons.check_circle;
      case 1:
        return Icons.watch_later_rounded;
      case 2:
        return Icons.watch_later_rounded;
      case 3:
        return Icons.watch_later_rounded;
      case 4:
        return Icons.check_circle;
      default:
        return Icons.cancel;
    }
  }

  String getOrderStatusText(int statusCode) {
    switch (statusCode) {
      case 0:
        return S.of(context).deliveryOrderPlaced;
      case 1:
        return S.of(context).deliveryCooking;
      case 2:
        return S.of(context).deliveryPacked;
      case 3:
        return S.of(context).deliveryDelivering;
      case 4:
        return S.of(context).deliveryDelivered;
      default:
        return S.of(context).deliveryCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    int status = int.parse(widget.order.orderStatus ?? '0');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.px),
      margin: EdgeInsets.symmetric(vertical: 10.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.px),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.px),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      getOrderStatusIcon(status),
                      color: secondaryColor,
                      size: 24.px,
                    ),
                    SizedBox(width: 10.px),
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        getOrderStatusText(status),
                        style: TextStyle(
                          fontSize: 16.px,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      S.of(context).orderProgress,
                      style: TextStyle(fontSize: 14.px),
                    ),
                  ],
                ),
                SizedBox(height: 20.px),
                TimelineTile(
                  isFirst: true,
                  isLast: false,
                  indicatorStyle: IndicatorStyle(
                    width: 12.px,
                    color: secondaryColor,
                    indicatorXY: 0.2,
                    padding: EdgeInsets.all(8.px),
                  ),
                  beforeLineStyle: LineStyle(
                    color: Colors.grey[300]!,
                    thickness: 2,
                  ),
                  endChild: Container(
                    margin: EdgeInsets.only(bottom: 20.px),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.px),
                        Text(
                          S.of(context).deliveryOrderPlaced,
                          style: TextStyle(
                            fontSize: 14.px,
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                          ),
                        ),
                        SizedBox(height: 4.px),
                        Text(
                          widget.order.orderTime ?? '',
                          style: TextStyle(
                            fontSize: 12.px,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TimelineTile(
                  isFirst: false,
                  isLast: false,
                  indicatorStyle: IndicatorStyle(
                    width: 12.px,
                    color:
                        status > 1
                            ? Colors.green
                            : status == 1
                            ? Colors.orange
                            : Colors.grey[400]!,
                    indicatorXY: 0.2,
                    padding: EdgeInsets.all(8.px),
                  ),
                  beforeLineStyle: LineStyle(
                    color: Colors.grey[300]!,
                    thickness: 2,
                  ),
                  endChild: Container(
                    margin: EdgeInsets.only(bottom: 20.px),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.px),
                        Text(
                          S.of(context).deliveryCooking,
                          style: TextStyle(
                            fontSize: 12.px,
                            fontWeight: FontWeight.bold,
                            color:
                                status > 1
                                    ? Colors.green
                                    : status == 1
                                    ? Colors.orange
                                    : Colors.grey[400]!,
                          ),
                        ),
                        SizedBox(height: 4.px),
                        Text(
                          widget.order.leadTime ?? '',
                          style: TextStyle(
                            fontSize: 12.px,
                            color:
                                status > 1
                                    ? Colors.green
                                    : status == 1
                                    ? Colors.orange
                                    : Colors.grey[400]!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TimelineTile(
                  isFirst: false,
                  isLast: false,
                  indicatorStyle: IndicatorStyle(
                    width: 12.px,
                    color:
                        status >= 4
                            ? Colors.green
                            : status >= 3
                            ? Colors.orange
                            : Colors.grey[400]!,
                    indicatorXY: 0.2,
                    padding: EdgeInsets.all(8.px),
                  ),
                  beforeLineStyle: LineStyle(
                    color: Colors.grey[300]!,
                    thickness: 2,
                  ),

                  endChild: Container(
                    margin: EdgeInsets.only(bottom: 20.px),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.px),
                        Text(
                          S.of(context).deliveryDelivering,
                          style: TextStyle(
                            fontSize: 14.px,
                            fontWeight: FontWeight.bold,
                            color:
                                status >= 4
                                    ? Colors.green
                                    : status >= 3
                                    ? Colors.orange
                                    : Colors.grey[400]!,
                          ),
                        ),
                        SizedBox(height: 4.px),
                        Text(
                          widget.order.mealTime ?? '',
                          style: TextStyle(
                            fontSize: 12.px,
                            color:
                                status >= 4
                                    ? Colors.green
                                    : status >= 3
                                    ? Colors.orange
                                    : Colors.grey[400]!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TimelineTile(
                  isFirst: false,
                  isLast: true,
                  indicatorStyle: IndicatorStyle(
                    width: 12.px,
                    color: status >= 4 ? Colors.green : Colors.grey[400]!,
                    indicatorXY: 0.2,
                    padding: EdgeInsets.all(8.px),
                  ),
                  beforeLineStyle: LineStyle(
                    color: Colors.grey[300]!,
                    thickness: 2,
                  ),
                  endChild: Container(
                    margin: EdgeInsets.only(bottom: 20.px),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.px),
                        Text(
                          S.of(context).deliveryDelivered,
                          style: TextStyle(
                            fontSize: 14.px,
                            fontWeight: FontWeight.bold,
                            color:
                                status >= 4 ? Colors.green : Colors.grey[400]!,
                          ),
                        ),
                        SizedBox(height: 4.px),
                        Text(
                          widget.order.completeTime ?? '',
                          style: TextStyle(
                            fontSize: 12.px,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          S.of(context).orderPlacedBy,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12.px,
                          ),
                        ),
                        SizedBox(width: 10.px),
                        Text(
                          widget.order.createBy ?? '',
                          style: TextStyle(fontSize: 12.px),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
