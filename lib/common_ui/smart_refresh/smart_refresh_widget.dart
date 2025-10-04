import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///下拉刷新上拉加载组件
class SmartRefreshWidget extends StatelessWidget {
  //启用下拉
  final bool? enablePullDown;

  //启用上拉
  final bool? enablePullUp;

  //刷新头布局
  final Widget? header;

  //加载尾布局
  final Widget? footer;

  //刷新事件
  final VoidCallback? onRefresh;

  //加载事件
  final VoidCallback? onLoading;

  //刷新组件控制器
  final RefreshController controller;

  //被刷新的子组件
  final Widget child;

  const SmartRefreshWidget({
    super.key,
    this.enablePullDown,
    this.enablePullUp,
    this.header,
    this.footer,
    this.onRefresh,
    this.onLoading,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _refreshView();
  }

  Widget _refreshView() {
    return SmartRefresher(
      controller: controller,
      enablePullDown: enablePullDown ?? true,
      enablePullUp: enablePullUp ?? true,
      header: WaterDropHeader(
        refresh: Text(
          S.current.refreshing,
          style: TextStyle(fontSize: 12.px, color: Colors.grey),
        ), // 指定语言文本
        complete: Text(
          S.current.refreshComplete,
          style: TextStyle(fontSize: 12.px, color: Colors.grey),
        ),
        failed: Text(
          S.current.refreshFailed,
          style: TextStyle(fontSize: 12.px, color: Colors.grey),
        ),
      ),
      footer: ClassicFooter(
        loadingText: S.current.loading, // 指定语言文本
        noDataText: S.current.noMoreData,
        idleText: S.current.pullUpLoadMore,
        failedText: S.current.loadFailed,
        canLoadingText: S.current.releaseLoadMore,
        textStyle: TextStyle(fontSize: 12.px, color: Colors.grey),
      ),
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }
}
