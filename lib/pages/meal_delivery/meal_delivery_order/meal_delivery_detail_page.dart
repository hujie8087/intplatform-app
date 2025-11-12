import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/meal_delivery_utils.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/http/model/user_info_model.dart';
import 'package:logistics_app/pages/meal_delivery/components/add_order_person.dart';
import 'package:logistics_app/pages/meal_delivery/components/detail_Information.dart';
import 'package:logistics_app/pages/meal_delivery/components/detail_progress.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_order/bloc/meal_delivery_order_bloc.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_order/bloc/meal_delivery_order_event.dart';
import 'package:logistics_app/pages/meal_delivery/meal_delivery_order/bloc/meal_delivery_order_state.dart';
import 'package:logistics_app/pages/repair/submit_page/repair_form_page.dart';
import 'package:logistics_app/repositories/meal_delivery_order_repository.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MealDeliveryDetailPage extends StatefulWidget {
  final String orderId;
  final UserInfoModel userInfo;

  MealDeliveryDetailPage({required this.orderId, required this.userInfo});

  @override
  State<MealDeliveryDetailPage> createState() => _MealDeliveryDetailPageState();
}

class _MealDeliveryDetailPageState extends State<MealDeliveryDetailPage> {
  MealDeliveryOrderModel? orderDetail;
  Set<int> orderUserIds = {};
  List<AssetEntity> selectedAssets = [];

  @override
  void initState() {
    super.initState();
  }

  // 上传图片
  Future<void> _uploadImage({orderNo, nick}) async {
    final result = await HJBottomSheet.wxPicker(
      context,
      selectedAssets,
      1,
      RequestType.image,
    );
    if (result != null) {
      ProgressHUD.showLoadingText(S.of(context).deliveryUploading);
      final fileUrl = await uploadImages(result);
      ProgressHUD.hide();
      if (fileUrl.isNotEmpty) {
        final parameters = {'orderNo': orderNo, 'imageUrl': fileUrl[0]};
        // 完成订单
        MealDeliveryUtils.updateOrderMealStatusByOrderNo(
          parameters,
          success: (data) {
            ProgressHUD.showSuccess(S.of(context).deliveryOrderCompleted);
            Navigator.pop(context, true);
          },
          fail: (code, msg) {
            ProgressHUD.showError(S.of(context).deliveryOrderSubmitFail);
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => MealDeliveryOrderBloc(
            repository: MealDeliveryOrderRepository(),
            userInfo: UserInfoModel(),
            keyword: '',
          )..add(FetchMealDeliveryOrderDetail(orderId: widget.orderId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).orderDetail,
            style: TextStyle(fontSize: 16.px),
          ),
        ),
        body: BlocBuilder<MealDeliveryOrderBloc, MealDeliveryOrderState>(
          builder: (context, state) {
            ProgressHUD.showLoadingText(S.of(context).deliveryLoading);
            if (state is MealDeliveryOrderDetailLoaded) {
              orderDetail = state.orderDetail;
              orderUserIds =
                  orderDetail?.foodOrdersDetil
                      ?.map((e) => int.parse(e.userId ?? '0'))
                      .toSet() ??
                  {};
              ProgressHUD.hide();
            }
            return SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  DetailProgressPage(
                    order: orderDetail ?? MealDeliveryOrderModel(),
                  ),
                  DetailInformation(
                    order: orderDetail ?? MealDeliveryOrderModel(),
                  ),
                  if (widget.userInfo.permissions?.contains(
                            'order:orders:completeOrder',
                          ) ==
                          true &&
                      orderDetail?.orderStatus == "3")
                    GestureDetector(
                      //员工编辑
                      onTap:
                          () => _uploadImage(
                            orderNo: orderDetail?.orderNo,
                            nick: orderDetail?.userUame,
                          ),
                      child: AddButton(
                        order: orderDetail ?? MealDeliveryOrderModel(),
                        title: S.of(context).uploadImages,
                        color: secondaryColor,
                      ),
                    ),
                  orderDetail?.orderStatus == "-1"
                      ? Container()
                      : Row(
                        children: [
                          orderDetail?.orderType != "1"
                              ? Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    _showPersonListBottomSheet(context);
                                  },
                                  child: AddButton(
                                    order:
                                        orderDetail ?? MealDeliveryOrderModel(),
                                    title: S.of(context).viewPerson,
                                  ),
                                ),
                              )
                              : Container(),

                          //     : Container(),
                          widget.userInfo.permissions?.contains(
                                        'order:orders:updateOrder',
                                      ) ==
                                      true &&
                                  orderDetail?.orderType != "1"
                              ? Expanded(
                                child: GestureDetector(
                                  //员工编辑
                                  onTap: () => {},
                                  child: AddButton(
                                    order:
                                        orderDetail ?? MealDeliveryOrderModel(),
                                    title: S.of(context).modifyPerson,
                                  ),
                                ),
                              )
                              : Container(),
                        ],
                      ),
                  SizedBox(height: 20.px),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // 显示人员列表底部弹窗
  void _showPersonListBottomSheet(BuildContext context) {
    final personList = orderDetail?.foodOrdersDetil ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.px),
              topRight: Radius.circular(20.px),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顶部拖拽指示器
              Container(
                margin: EdgeInsets.only(top: 12.px),
                width: 40.px,
                height: 4.px,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.px),
                ),
              ),

              // 标题
              Padding(
                padding: EdgeInsets.all(16.px),
                child: Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: Theme.of(context).primaryColor,
                      size: 20.px,
                    ),
                    SizedBox(width: 8.px),
                    Text(
                      S.of(context).personList,
                      style: TextStyle(
                        fontSize: 16.px,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${S.of(context).deliveryTotal(personList.length)}',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // 人员列表
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child:
                    personList.isEmpty
                        ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.px),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 48.px,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16.px),
                                Text(
                                  S.of(context).noPersonInfo,
                                  style: TextStyle(
                                    fontSize: 14.px,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 16.px),
                          itemCount: personList.length,
                          itemBuilder: (context, index) {
                            final person = personList[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 12.px),
                              padding: EdgeInsets.all(12.px),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12.px),
                                border: Border.all(
                                  color: Colors.grey[200]!,
                                  width: 1.px,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // 头像
                                  Container(
                                    width: 40.px,
                                    height: 40.px,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(
                                        20.px,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: Theme.of(context).primaryColor,
                                      size: 20.px,
                                    ),
                                  ),
                                  SizedBox(width: 12.px),

                                  // 人员信息
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          person.userName ??
                                              S.of(context).unknownName,
                                          style: TextStyle(
                                            fontSize: 14.px,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4.px),
                                        Text(
                                          '${S.of(context).deliveryJobNumber}: ${person.userNo ?? S.of(context).unknown}',
                                          style: TextStyle(
                                            fontSize: 12.px,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(height: 2.px),
                                        Text(
                                          '${S.of(context).deliveryDept}: ${person.deptName ?? S.of(context).unknown}',
                                          style: TextStyle(
                                            fontSize: 12.px,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        if (person.postName != null &&
                                            person.postName!.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(top: 2.px),
                                            child: Text(
                                              '${S.of(context).deliveryPost}: ${person.postName}',
                                              style: TextStyle(
                                                fontSize: 12.px,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // 备注信息（如果有）
                                  if (person.remarks != null &&
                                      person.remarks!.isNotEmpty)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.px,
                                        vertical: 4.px,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          8.px,
                                        ),
                                      ),
                                      child: Text(
                                        person.remarks!,
                                        style: TextStyle(
                                          fontSize: 10.px,
                                          color: Colors.orange[700],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
              ),

              // 底部按钮
              Padding(
                padding: EdgeInsets.all(16.px),
                child: SizedBox(
                  width: double.infinity,
                  height: 36.px,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.px),
                      ),
                    ),
                    child: Text(
                      S.of(context).close,
                      style: TextStyle(fontSize: 14.px, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.px),
            ],
          ),
        );
      },
    );
  }
}
