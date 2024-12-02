import 'package:flutter/material.dart';
import 'package:logistics_app/app_theme.dart';
import 'package:logistics_app/common_ui/switch_type.dart';
import 'package:logistics_app/pages/mine_page/feedback_page/feedback_form_view.dart';
import 'package:logistics_app/pages/mine_page/feedback_page/feedback_list_view.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Widget tabBody = Container(
    color: AppTheme.background,
  );
  Animation<double>? switchAnimation;
  int current = 0;

  //更新焦点的事件名
  void updateCurrent(int value) {
    setState(() {
      current = value;
      if (value == 0) {
        tabBody = FeedbackFormView(animationController: animationController);
      } else {
        tabBody = FeedbackListView(animationController: animationController);
      }
    });
  }

  final List<SwitchType> buttonLabels = [
    SwitchType('意见反馈', 0),
    SwitchType('我的反馈', 1),
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    switchAnimation = CurvedAnimation(
        parent: animationController!,
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn));
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '意见反馈',
              style: TextStyle(fontSize: 18),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  SwitchTypeView(
                    listData: buttonLabels,
                    callBack: (int value) {
                      updateCurrent(value);
                    },
                    animationController: animationController,
                    animation: switchAnimation,
                    current: current,
                  ),
                  Container(
                    child: FeedbackFormView(
                        animationController: animationController),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
