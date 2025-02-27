import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/icon_api_widget.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/tool_utils.dart';
import 'package:logistics_app/http/model/guide_type_view_model.dart';
import 'package:logistics_app/http/model/guide_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/pages/guide/guide_view_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class GuideListPage extends StatefulWidget {
  const GuideListPage({Key? key, required this.guideTypeId}) : super(key: key);
  final int guideTypeId;
  @override
  _GuideListPage createState() => _GuideListPage();
}

class _GuideListPage extends State<GuideListPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  GuideTypeViewModel? guideType;
  List<GuideViewModel> guideList = [];

  String imagePrefix = APIs.foodPrefix;

  // 获取引导类型
  void getGuideType() async {
    ToolUtils.getGuideTypeDetail(widget.guideTypeId, success: (data) {
      setState(() {
        guideType = GuideTypeViewModel.fromJson(data['data']);
      });
    });
  }

  // 获取引导列表
  void getGuideList() async {
    ToolUtils.getGuideList({'typeId': widget.guideTypeId}, success: (data) {
      setState(() {
        guideList =
            RowsModel.fromJson(data, (json) => GuideViewModel.fromJson(json))
                    .rows ??
                [];
      });
    });
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    getGuideType();
    getGuideList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          guideType?.title ?? '',
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(10.px),
        child: guideList.length > 0 ? restaurantListView() : EmptyView(),
      )),
    );
  }

  Widget restaurantListView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 6.px,
        mainAxisSpacing: 0,
      ),
      shrinkWrap: true,
      physics: guideList.length > 0 ? NeverScrollableScrollPhysics() : null,
      padding: EdgeInsets.all(0),
      itemCount: guideList.length,
      itemBuilder: (context, index) {
        final int count = guideList.length;
        final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: animationController!,
                curve: Interval((1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn)));
        animationController?.forward();
        return GuideViewDataView(
            listData: guideList[index],
            callBack: () => {
                  RouteUtils.push(
                      context, GuideViewPage(id: guideList[index].id!))
                },
            imagePrefix: imagePrefix,
            animation: animation,
            animationController: animationController,
            index: index);
      },
    );
  }
}

class GuideViewDataView extends StatelessWidget {
  const GuideViewDataView({
    Key? key,
    required this.listData,
    this.callBack,
    required this.imagePrefix,
    this.animationController,
    this.animation,
    this.index,
  }) : super(key: key);

  final GuideViewModel listData;
  final VoidCallback? callBack;
  final String imagePrefix;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final int? index;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 50.px * (1.0 - animation!.value), 0.0),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.px),
                    child: Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.px),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.px),
                            onTap: callBack,
                            child: Container(
                              padding: EdgeInsets.all(10.px),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12.px),
                                    decoration: BoxDecoration(
                                        color: index! % 2 == 1
                                            ? primaryColor.withOpacity(0.1)
                                            : secondaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100.px))),
                                    child: Icon(
                                      iconMap[listData.img],
                                      size: 20.px,
                                      color: index! % 2 == 1
                                          ? primaryColor[500]
                                          : secondaryColor[500],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.px,
                                  ),
                                  Text(listData.title ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.px,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        )),
                  )));
        });
  }
}
