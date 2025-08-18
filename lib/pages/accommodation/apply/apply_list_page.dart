import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/icon_api_widget.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/apply_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/pages/accommodation/apply/apply_detail_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class ApplyListPage extends StatefulWidget {
  const ApplyListPage({Key? key}) : super(key: key);
  @override
  _ApplyListPage createState() => _ApplyListPage();
}

class _ApplyListPage extends State<ApplyListPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<ApplyViewModel> applyList = [];
  String applyUrl = '';
  bool isLoading = false;
  bool isGetUrlLoading = false;

  String imagePrefix = APIs.foodPrefix;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    setState(() {
      isLoading = true;
    });
    DataUtils.getApplyList(
      {'status': '2', 'type': '0', 'pageNum': 1, 'pageSize': 100},
      success: (data) {
        RowsModel<ApplyViewModel> response = RowsModel.fromJson(
          data,
          (json) => ApplyViewModel.fromJson(json),
        );
        applyList = response.rows ?? [];
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  void _getApplyUrl(ApplyViewModel apply) async {
    ProgressHUD.showLoadingText(S.of(context).loading);
    DataUtils.getApplyUrl(
      {'id': apply.formId},
      success: (data) {
        ProgressHUD.hide();
        applyUrl = data['data']['url'];
        if (applyUrl.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ApplyDetailPage(
                    url: applyUrl,
                    // url:
                    //     'http://172.90.1.165/spa/workflow/static4mobileform/index.html?ssoToken=B4CDA74115D55D125F34348F45CCF9B3288326CFFDD8A56727DB63E5FE3DB4A308952E4EB916F9B5D0A22D06B7BBE545CA43331AA45DB9B457A14CBD211397B6#/req?iscreate=1&workflowid=26521&docid=',
                    title: apply.title ?? '',
                  ),
            ),
          );
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).onlineApply,
          style: TextStyle(fontSize: 16.px),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.px),
          child: restaurantListView(),
        ),
      ),
    );
  }

  Widget restaurantListView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10.px,
        mainAxisSpacing: 0,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: applyList.length,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        final int count = applyList.length;
        final Animation<double> animation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animationController!,
            curve: Interval(
              (1 / count) * index,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        );
        animationController?.forward();
        return GuideViewDataView(
          listData: applyList[index],
          callBack: () {
            if (isLoading) return;
            _getApplyUrl(applyList[index]);
          },
          imagePrefix: imagePrefix,
          animation: animation,
          animationController: animationController,
          index: index,
        );
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

  final ApplyViewModel listData;
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
              0.0,
              50.px * (1.0 - animation!.value),
              0.0,
            ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.px),
                            decoration: BoxDecoration(
                              color:
                                  index! % 2 == 1
                                      ? primaryColor.withOpacity(0.1)
                                      : secondaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100.px),
                              ),
                            ),
                            child: Icon(
                              iconMap[listData.icon],
                              size: 20.px,
                              color:
                                  index! % 2 == 1
                                      ? primaryColor[500]
                                      : secondaryColor[500],
                            ),
                          ),
                          SizedBox(height: 2.px),
                          Text(
                            listData.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12.px),
                          ),
                        ],
                      ),
                    ),
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
