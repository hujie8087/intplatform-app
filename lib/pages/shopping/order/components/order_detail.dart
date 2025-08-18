import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/model/order_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class OrderDetail extends StatelessWidget {
  final OrderModel order;

  const OrderDetail({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenAdapterHelper.init(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 商品列表最多显示3个
              for (var detail in (order.orderDetailsList ?? []).take(3))
                Container(
                  margin: EdgeInsets.only(right: 8.px),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.px),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: detail.image?.indexOf('food') != -1
                                  ? APIs.foodPrefix + detail.image!
                                  : APIs.imagePrefix + detail.image!,
                              width: 60.px,
                              height: 60.px,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(5.px),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.px, vertical: 2.px),
                                child: Text(
                                  'x ' + detail.num.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.px,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if ((order.orderDetailsList ?? []).length > 1)
                        Container(
                          width: 60.px,
                          child: Text(
                            detail.name ?? '',
                            style: TextStyle(
                              fontSize: 10.px,
                              height: 2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              if ((order.orderDetailsList ?? []).length > 3)
                Center(
                  child: Icon(
                    Icons.more_horiz,
                    color: Colors.grey,
                  ),
                ),
              if ((order.orderDetailsList ?? []).length == 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      order.orderDetailsList?[0].name ?? '',
                      style: TextStyle(color: Colors.grey, fontSize: 10.px),
                    ),
                    SizedBox(height: 5.px),
                    Text(
                      S.of(context).orderTime +
                          ':${order.createTime?.replaceAll('T', ' ')}',
                      style: TextStyle(color: Colors.grey, fontSize: 10.px),
                    ),
                    SizedBox(height: 5.px),
                    Text(
                      S.of(context).phone + ':${order.tel}',
                      style: TextStyle(color: Colors.grey, fontSize: 10.px),
                    ),
                  ],
                )
            ],
          ),
          if ((order.orderDetailsList ?? []).length > 1)
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.px),
                  Text(
                    S.of(context).orderTime +
                        ':${order.createTime?.replaceAll('T', ' ')}',
                    style: TextStyle(color: Colors.grey, fontSize: 10.px),
                  ),
                  SizedBox(height: 5.px),
                  Text(
                    S.of(context).phone + ':${order.tel}',
                    style: TextStyle(color: Colors.grey, fontSize: 10.px),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
