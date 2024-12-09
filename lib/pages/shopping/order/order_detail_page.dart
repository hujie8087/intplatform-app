import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/shopping_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/order_model.dart';
import 'package:logistics_app/http/model/pickup_type_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  const OrderDetailPage({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _isLoading = true;
  OrderModel? _orderDetail;
  List<DictModel> statusList = [];
  List<PickupTypeModel> pickupTypeList = [];

  @override
  void initState() {
    super.initState();
    _fetchAllPickupType();
    _fetchOrderStatus();
    _fetchOrderDetail();
  }

  // 获取所有配送方式
  Future<void> _fetchAllPickupType() async {
    ShoppingUtils.getCanteenPickupType(
      null,
      success: (data) {
        pickupTypeList =
            RowsModel.fromJson(data, (json) => PickupTypeModel.fromJson(json))
                    .rows ??
                [];
        setState(() {});
      },
    );
  }

  // 获取订单状态
  Future<void> _fetchOrderStatus() async {
    DataUtils.getDictDataList(
      'order_type_status',
      success: (data) {
        statusList = BaseListModel<DictModel>.fromJson(
                data, (json) => DictModel.fromJson(json)).data ??
            [];
        setState(() {});
      },
    );
  }

  Future<void> _fetchOrderDetail() async {
    setState(() {
      _isLoading = true;
    });
    DataUtils.getDetailById(
      APIs.getOrderDetail + '/' + widget.orderId,
      success: (data) {
        _orderDetail = OrderModel.fromJson(data['data']);
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).orderDetail,
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _fetchOrderDetail();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // 订单状态
                  _buildOrderStatus(),
                  SizedBox(height: 8.px),
                  // 订单信息
                  _buildOrderInfo(),
                  SizedBox(height: 8.px),
                  // 商品信息
                  _buildProductInfo(),
                  SizedBox(height: 8.px),
                  // 订单金额
                  _buildOrderAmount(),
                ],
              ),
            ),
    );
  }

  Widget _buildOrderStatus() {
    return Container(
      padding: EdgeInsets.all(12.px),
      color: primaryColor,
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.white,
            size: 24.px,
          ),
          SizedBox(width: 8.px),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                statusList.length > 0
                    ? statusList
                            .firstWhere((e) =>
                                e.dictValue == _orderDetail?.status.toString())
                            .dictLabel ??
                        ''
                    : '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.px,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.px),
              Text(
                S.of(context).orderNo + ':${_orderDetail?.no}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.px,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      padding: EdgeInsets.all(12.px),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).orderInfo,
            style: TextStyle(
              fontSize: 14.px,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.px),
          // 姓名
          _buildInfoItem(S.of(context).name, _orderDetail?.name ?? ''),
          _buildInfoItem(
              S.of(context).employeeNumber, _orderDetail?.nick ?? ''),
          _buildInfoItem(S.of(context).phone, _orderDetail?.tel ?? ''),
          _buildInfoItem(
              S.of(context).pickupType,
              pickupTypeList.length > 0
                  ? pickupTypeList
                          .firstWhere((e) => e.id == _orderDetail?.pickupType)
                          .name ??
                      ''
                  : ''),
          _buildInfoItem(S.of(context).orderTime,
              _orderDetail?.createTime?.replaceAll('T', ' ') ?? ''),
          if (_orderDetail?.pickupType == 3)
            _buildInfoItem(
                S.of(context).pickupTime, _orderDetail?.deliveryArea ?? ''),
          if (_orderDetail?.pickupType == 3)
            _buildInfoItem(S.of(context).address, _orderDetail?.address ?? ''),

          if (_orderDetail?.remark?.isNotEmpty == true)
            _buildInfoItem(S.of(context).remark, _orderDetail?.remark ?? ''),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12.px,
            ),
          ),
          SizedBox(width: 8.px),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.px,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: EdgeInsets.all(12.px),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).goodsInfo,
            style: TextStyle(
              fontSize: 14.px,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.px),
          ...(_orderDetail?.orderDetailsList ?? [])
              .map((detail) => _buildProductItem(detail))
        ],
      ),
    );
  }

  Widget _buildProductItem(OrderDetailsList detail) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.px),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: detail.image?.indexOf('food') != -1
                  ? APIs.foodPrefix + detail.image!
                  : APIs.imagePrefix + detail.image!,
              width: 60.px,
              height: 60.px,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(width: 8.px),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.name ?? '',
                  style: TextStyle(
                    fontSize: 12.px,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5.px),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '¥${detail.price}',
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 12.px,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'x${detail.num}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.px,
                      ),
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

  Widget _buildOrderAmount() {
    return Container(
      padding: EdgeInsets.all(12.px),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).goodsTotal,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.px,
                ),
              ),
              Text(
                '${_orderDetail?.totalPrice?.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12.px,
                ),
              ),
            ],
          ),
          // 配送费用
          if (_orderDetail?.pickupType == 3)
            _buildInfoItem(
                S.of(context).deliveryFee, '${_orderDetail?.postPrice}'),

          SizedBox(height: 8.px),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).actualPayment,
                style: TextStyle(
                  fontSize: 14.px,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '¥${_orderDetail?.totalPrice?.toStringAsFixed(2)}',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 16.px,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
