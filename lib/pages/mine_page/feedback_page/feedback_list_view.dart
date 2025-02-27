import 'package:flutter/material.dart';
import 'package:logistics_app/pages/news/notice_page/notice_list_page.dart';
import 'package:logistics_app/pages/news/notice_page/notice_view_model.dart';
import 'package:provider/provider.dart';

class FeedbackListView extends StatefulWidget {
  const FeedbackListView({Key? key, this.animationController})
      : super(key: key);

  final AnimationController? animationController;
  @override
  _FeedbackListViewState createState() => _FeedbackListViewState();
}

class _FeedbackListViewState extends State<FeedbackListView>
    with TickerProviderStateMixin {
  var model = NoticeViewModel();
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  List<Widget> listViews = <Widget>[];
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    model.getNoticeModelList(1, 10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => model,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Consumer<NoticeViewModel>(builder: (context, model, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: model.list?.length ?? 0,
                  itemBuilder: (context, index) {
                    final int count = model.list?.length ?? 0;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    widget.animationController?.forward();
                    return NoticeDataView(
                      listData: model.list?[index],
                      callBack: () => {},
                      animation: animation,
                      animationController: widget.animationController,
                    );
                  },
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
