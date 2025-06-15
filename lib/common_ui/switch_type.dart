import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

// 定义一个对象类型，包含label和value
class SwitchType {
  final String label;
  final int value;

  SwitchType(this.label, this.value);
}

class SwitchTypeView extends StatelessWidget {
  const SwitchTypeView({
    Key? key,
    required this.listData,
    required this.callBack,
    this.animationController,
    this.current = 0,
    this.animation,
  }) : super(key: key);

  final List<SwitchType> listData;
  final callBack;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final int current;
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              40.px * (1.0 - animation!.value),
              0.0,
            ),
            child: ButtonBar(
              alignment: MainAxisAlignment.start,
              children:
                  listData
                      .map(
                        (e) => TextButton(
                          onPressed: () {
                            callBack(e.value);
                          },
                          child: Column(
                            children: [
                              AnimatedDefaultTextStyle(
                                style:
                                    current == listData.indexOf(e)
                                        ? TextStyle(
                                          fontSize: 14.px,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        )
                                        : TextStyle(
                                          fontSize: 14.px,
                                          color: Colors.grey,
                                        ),
                                duration: Duration(milliseconds: 300),
                                child: Text(e.label),
                              ),
                              SizedBox(height: 5), // 添加间距以避免图片与文字重叠
                              AnimatedOpacity(
                                opacity: current == listData.indexOf(e) ? 1 : 0,
                                duration: Duration(milliseconds: 300),
                                child: Image.asset(
                                  'assets/images/wan.png',
                                  width: 26.px,
                                  key: ValueKey('notif'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        );
      },
    );
  }
}
