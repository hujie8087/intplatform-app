import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class DetailInformation extends StatefulWidget {
  final MealDeliveryOrderModel order;
  const DetailInformation({Key? key, required this.order}) : super(key: key);

  @override
  _DetailInformationState createState() => _DetailInformationState();
}

String extractAfterLastSlash(String str) {
  RegExp regExp = RegExp(r'\/([^\/]*)$');
  Match? match = regExp.firstMatch(str);
  return match?.group(1) ?? '';
}

class _DetailInformationState extends State<DetailInformation> {
  @override
  Widget build(BuildContext context) {
    final foodName = {
      '0': S.of(context).breakfast,
      '1': S.of(context).lunch,
      '2': S.of(context).dinner,
      '3': S.of(context).nightSnack,
      '5': S.of(context).dessert,
      '6': S.of(context).earlyTea,
    };
    final foodType = {
      '0': S.of(context).chineseFood,
      '1': S.of(context).indonesianFood,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.px),
      child: Column(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${S.of(context).orderTime}：${widget.order.createTime}',
                      style: TextStyle(fontSize: 12.px, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 8.px),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${S.of(context).delivery_site}：${widget.order.deliverySite}',
                        style: TextStyle(fontSize: 12.px, color: Colors.grey),
                      ),
                      if (widget.order.orderType != '1')
                        Text(
                          '${S.of(context).mealTime}：${foodName[widget.order.foodName]}',
                          style: TextStyle(fontSize: 12.px, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 8.px),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${S.of(context).delivery_canteen}：${widget.order.canteen}',
                          style: TextStyle(fontSize: 12.px, color: Colors.grey),
                        ),
                      ),
                      if (widget.order.orderType != '1')
                        Text(
                          '${S.of(context).foodType}：${foodType[widget.order.foodType]}',
                          style: TextStyle(fontSize: 12.px, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 8.px),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${S.of(context).deliveryType}：${widget.order.deliveryType == '1' ? S.of(context).selfPickup : S.of(context).delivery}',
                      style: TextStyle(fontSize: 12.px, color: Colors.grey),
                    ),
                    Text(
                      '${S.of(context).orderNum}：${widget.order.pNum}',
                      style: TextStyle(fontSize: 12.px, color: Colors.grey),
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
