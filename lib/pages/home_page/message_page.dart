import 'package:flutter/material.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/pages/home_page/message_view_model.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePage createState() => _MessagePage();
}

class _MessagePage extends State<MessagePage> with TickerProviderStateMixin {
  late RefreshController _refreshController;
  AnimationController? animationController;
  var model = MessageViewModel();
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _refreshController = RefreshController();
    super.initState();
    model.geNoticeList(1, 10);
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return model;
        },
        child: Scaffold(
            backgroundColor: AppTheme.background,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              backgroundColor: AppTheme.background,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios)),
                  Text(
                    S.of(context).message,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16.px),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '(2)',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 12.px),
                  ),
                  SizedBox(
                    width: 10.px,
                  ),
                  TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        size: 12.px,
                        color: Colors.grey,
                      ),
                      label: Text(
                        S.of(context).allRead,
                        style: TextStyle(color: Colors.grey, fontSize: 12.px),
                      ))
                ],
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // 搜索框
                  Container(
                    margin: EdgeInsets.only(top: 8.px, left: 8.px, right: 8.px),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.px)),
                    ),
                    height: 32.px,
                    child: TextField(
                      style: TextStyle(
                        fontSize: 12.px,
                      ),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(right: 10.px),
                        hintText: S.of(context).searchMessage,
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.px),
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) => {print('搜索内容: $value')},
                    ),
                  ),
                  SizedBox(
                    height: 5.px,
                  ),
                  Expanded(
                      child: SmartRefreshWidget(
                          enablePullDown: true,
                          enablePullUp: true,
                          onRefresh: () {
                            model.geNoticeList(1, 10).then((value) {
                              _refreshController.refreshCompleted();
                            });
                          },
                          controller: _refreshController,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: messageListView(),
                          )))
                ],
              ),
            )));
  }

  Widget messageListView() {
    return Consumer<MessageViewModel>(
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
            return MessageDataView(
              listData: model.list?[index],
              callBack: () => {},
              deleteCallBack: () => {},
              editCallBack: () => {},
              animation: animation,
              animationController: animationController,
            );
          },
        );
      },
    );
  }
}

class MessageDataView extends StatelessWidget {
  const MessageDataView(
      {Key? key,
      this.listData,
      this.callBack,
      this.deleteCallBack,
      this.editCallBack,
      this.animationController,
      this.animation,
      this.isEdit})
      : super(key: key);

  final NoticeModel? listData;
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
                      0.0, 50.px * (1.0 - animation!.value), 0.0),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.px),
                    child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.px),
                        child: Container(
                          padding: EdgeInsets.all(12.px),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.px),
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
                                      Text(listData?.createTime ?? '',
                                          style: TextStyle(
                                              fontSize: 10.px,
                                              color: Colors.grey)),
                                      SizedBox(
                                        height: 8.px,
                                      ),
                                      Text(listData?.noticeTitle ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12.px,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 8.px,
                                      ),
                                      HtmlLineLimit(
                                          htmlContent:
                                              listData?.noticeContent ?? ''),
                                      SizedBox(
                                        width: 10.px,
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ],
                          ),
                        )),
                  )));
        });
  }
}
