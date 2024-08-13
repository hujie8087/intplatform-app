import 'package:flutter/cupertino.dart';
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

  const SmartRefreshWidget(
      {super.key,
      this.enablePullDown,
      this.enablePullUp,
      this.header,
      this.footer,
      this.onRefresh,
      this.onLoading,
      required this.controller,
      required this.child});

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
        refresh: Text('刷新中...'), // 指定语言文本
        complete: Text('刷新完成'),
        failed: Text('刷新失败'),
      ),
      footer: ClassicFooter(
        loadingText: '加载中...', // 指定语言文本
        noDataText: '没有更多数据',
        idleText: '上拉加载更多',
        failedText: '加载失败',
        canLoadingText: '松开加载更多',
      ),
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }
}
