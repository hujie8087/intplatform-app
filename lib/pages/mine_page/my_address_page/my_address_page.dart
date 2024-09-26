import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/dialog/dialog_factory.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/http/model/my_address_view_model.dart';
import 'package:logistics_app/pages/mine_page/my_address_page/add_address_page.dart';
import 'package:logistics_app/pages/mine_page/my_address_page/edit_address_page.dart';
import 'package:logistics_app/pages/mine_page/my_address_page/my_address_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyAddressPage extends StatefulWidget {
  const MyAddressPage({super.key});
  @override
  _MyAddressPageState createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  var model = MyAddressModel();
  late RefreshController _refreshController;
  bool isEdit = false;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _refreshController = RefreshController();

    super.initState();
    model.getMyAddressModelList(1, 10);
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  // 第一个页面
  void _navigateToSecondPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAddressPage()),
    );

    // 处理返回值
    if (result == true) {
      model.getMyAddressModelList(1, 10).then((value) {
        _refreshController.refreshCompleted();
      });
    }
  }

  // 跳转详情页
  void _navigateToEditPage(id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditAddressPage(id: id)),
    );

    // 处理返回值
    if (result == true) {
      model.getMyAddressModelList(1, 10).then((value) {
        _refreshController.refreshCompleted();
      });
    }
  }

  // 删除地址
  void _deleteAddress(ids) async {
    if (ids != null) {
      final result = await model.deleteAddress(ids);
      if (result.success == true) {
        model.getMyAddressModelList(1, 10).then((value) {
          _refreshController.refreshCompleted();
        });
      }
    }
  }

  // 设置默认地址
  void _editAddress(AddressModel item) async {
    if (item.id != null) {
      item.isDefault = item.isDefault == '0' ? '1' : '0';
      final result = await model.editAddress(item);
      if (result.success == true) {
        model.getMyAddressModelList(1, 10).then((value) {
          _refreshController.refreshCompleted();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return model;
        },
        child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text(
                '收货地址',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18),
              ),
              centerTitle: false,
              backgroundColor: Colors.white,
              actions: [
                if (isEdit == false)
                  Container(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.edit,
                        color: secondaryColor,
                        size: 14,
                      ),
                      onPressed: () {
                        setState(() {
                          isEdit = true;
                        });
                      },
                      label:
                          Text('管理', style: TextStyle(color: secondaryColor)),
                    ),
                  ),
                if (isEdit == true)
                  Container(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.output_rounded,
                        color: secondaryColor,
                        size: 14,
                      ),
                      onPressed: () {
                        setState(() {
                          isEdit = false;
                        });
                      },
                      label:
                          Text('退出管理', style: TextStyle(color: secondaryColor)),
                    ),
                  ),
                if (isEdit == false)
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.add,
                        color: primaryColor,
                        size: 14,
                      ),
                      onPressed: _navigateToSecondPage,
                      label:
                          Text('新增地址', style: TextStyle(color: primaryColor)),
                    ),
                  )
              ],
            ),
            body: SafeArea(
                child: SmartRefreshWidget(
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: () {
                      model.getMyAddressModelList(1, 10).then((value) {
                        _refreshController.refreshCompleted();
                      });
                    },
                    controller: _refreshController,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: myAddressListView(),
                    )))));
  }

  Widget myAddressListView() {
    return Consumer<MyAddressModel>(
      builder: (context, model, child) {
        if (model.list?.isEmpty == true) {
          return Center(
            child: EmptyView(
              type: EmptyType.empty,
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: model.list?.length ?? 0,
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            final int count = model.list?.length ?? 0;
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController!,
                    curve: Interval((1 / count) * index, 1.0,
                        curve: Curves.fastOutSlowIn)));
            animationController?.forward();
            return MyAddressDataView(
              listData: model.list?[index],
              callBack: () => {_navigateToEditPage(model.list?[index]?.id)},
              deleteCallBack: () =>
                  {_deleteAddress(model.list?[index]?.id.toString())},
              editCallBack: () => {_editAddress(model.list![index]!)},
              animation: animation,
              animationController: animationController,
              isEdit: isEdit,
            );
          },
        );
      },
    );
  }
}

class MyAddressDataView extends StatelessWidget {
  const MyAddressDataView(
      {Key? key,
      this.listData,
      this.callBack,
      this.deleteCallBack,
      this.editCallBack,
      this.animationController,
      this.animation,
      this.isEdit})
      : super(key: key);

  final AddressModel? listData;
  final VoidCallback? callBack;
  final VoidCallback? deleteCallBack;
  final VoidCallback? editCallBack;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final bool? isEdit;
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
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(listData?.detailedAddress ?? '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(listData?.name ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(listData?.name ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(listData?.tel ?? '',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          if (listData?.isDefault == '0')
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: BoxDecoration(
                                                  color: secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                '默认',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            )
                                        ],
                                      )
                                    ],
                                  )),
                                  IconButton(
                                    onPressed: () {
                                      callBack!();
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                              if (isEdit == true)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          value: listData?.isDefault == '0',
                                          onChanged: (value) {
                                            // 确认弹窗
                                            DialogFactory.instance
                                                .showConfirmDialog(
                                                    context: context,
                                                    title: '确定把该地址设置为默认吗？',
                                                    confirmClick: () {
                                                      editCallBack!();
                                                    });
                                          },
                                          activeColor: primaryColor[700],
                                          shape: CircleBorder(
                                            side: BorderSide(
                                                color: Colors.grey, width: 1),
                                          ),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize
                                                  .shrinkWrap, // 去掉额外的边距
                                        ),
                                        Text(
                                          '默认',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        padding: MaterialStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              horizontal: 0.0,
                                              vertical: 0.0), // 控制按钮内边距
                                        ),
                                        minimumSize: MaterialStatePropertyAll(
                                            Size(40, 24)), // 控制按钮的最小尺寸
                                        side: MaterialStatePropertyAll(
                                          BorderSide(
                                              color: Colors.grey, width: 1),
                                        ),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white),
                                      ),
                                      onPressed: () {
                                        // 确认弹窗
                                        DialogFactory.instance
                                            .showConfirmDialog(
                                                context: context,
                                                title: '确定删除地址吗？',
                                                confirmClick: () {
                                                  deleteCallBack!();
                                                });
                                      },
                                      child: Text(
                                        '删除',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    )
                                  ],
                                )
                            ],
                          ),
                        )),
                  )));
        });
  }
}
