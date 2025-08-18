import 'package:flutter/material.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/KeepAliveWrapper.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/pages/repair/components/content_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class TabBarModel {
  final String? title; // 标题
  final int? repairState; // 对应的widget
  const TabBarModel({this.title, this.repairState});
}

class MyRepairPage extends StatefulWidget {
  const MyRepairPage({Key? key}) : super(key: key);
  @override
  _MyRepairPage createState() => _MyRepairPage();
}

class _MyRepairPage extends State<MyRepairPage>
    with TickerProviderStateMixin, RouteAware {
  late TabController _tabController;
  final List<TabBarModel> tabs = [
    TabBarModel(title: S.current.all, repairState: null),
    TabBarModel(title: S.current.pending, repairState: 0),
    TabBarModel(title: S.current.repaired, repairState: 1),
    TabBarModel(title: S.current.completed, repairState: 3),
  ];

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // 释放资源
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).myRepair,
          style: TextStyle(fontSize: 16.px),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              color: AppTheme.background,
              child: TabBar(
                  padding: EdgeInsets.zero,
                  controller: _tabController,
                  labelStyle: TextStyle(fontSize: 12.px),
                  tabs: tabs.map((e) => Tab(text: e.title)).toList(),
                  labelColor: primaryColor,
                  indicatorColor: primaryColor,
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label),
            )),
      ),
      backgroundColor: AppTheme.background,
      body: TabBarView(
        //构建
        controller: _tabController,
        children: tabs.map((e) {
          return KeepAliveWrapper(
            child: Container(
              alignment: Alignment.center,
              child: ContentPage(
                repairState: e.repairState,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
