import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';

class FeedbackFormView extends StatefulWidget {
  const FeedbackFormView({Key? key, this.animationController})
    : super(key: key);

  final AnimationController? animationController;
  @override
  _FeedbackFormView createState() => _FeedbackFormView();
}

class _FeedbackFormView extends State<FeedbackFormView>
    with TickerProviderStateMixin {
  String? _lineValue;
  String? _selectedValue;
  String? _typeValue;
  String? _titleValue;
  String? _contentValue;
  Animation<double>? opacityAnimation;

  // 下拉框选项列表
  final List<String> _dropdownItems = ['选项 1', '选项 2', '选项 3', '选项 4'];
  // 下拉框选项列表
  final List<String> _lineItems = ['1号线', '2号线', '3号线', '4号线'];

  // 下拉框选项列表
  final List<String> _typeItems = ['车辆管理方面', '人员管理方面'];
  // 下拉框选项列表
  final List<String> _titleItems = ['车辆环境', '线路优化', '站点设置', '运行时间'];

  @override
  void initState() {
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController!,
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    widget.animationController!.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: opacityAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              50 * (1.0 - opacityAnimation!.value),
              0.0,
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '选择线路号',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular((10.0)),
                          ),
                          child: DropdownButtonFormField<String>(
                            initialValue: _lineValue,
                            hint: Text('请选择线路号'),
                            style: TextStyle(color: Colors.black, fontSize: 12),
                            borderRadius: BorderRadius.circular(10),
                            isExpanded: true,
                            padding: EdgeInsets.only(left: 10),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            items:
                                _lineItems.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _lineValue = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '选择车辆编号',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular((10.0)),
                          ),
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedValue,
                            hint: Text('请选择车辆编号'),
                            style: TextStyle(color: Colors.black, fontSize: 12),
                            borderRadius: BorderRadius.circular(10),
                            isExpanded: true,
                            padding: EdgeInsets.only(left: 10),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            items:
                                _dropdownItems.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedValue = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '选择反馈类型',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular((10.0)),
                          ),
                          child: DropdownButtonFormField<String>(
                            initialValue: _typeValue,
                            hint: Text('请选择反馈类型'),
                            style: TextStyle(color: Colors.black, fontSize: 12),
                            borderRadius: BorderRadius.circular(10),
                            isExpanded: true,
                            padding: EdgeInsets.only(left: 10),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            items:
                                _typeItems.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _typeValue = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // 反馈标题
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '选择反馈标题',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular((10.0)),
                          ),
                          child: DropdownButtonFormField<String>(
                            initialValue: _titleValue,
                            hint: Text('请选择反馈标题'),
                            style: TextStyle(color: Colors.black, fontSize: 12),
                            borderRadius: BorderRadius.circular(10),
                            isExpanded: true,
                            padding: EdgeInsets.only(left: 10),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            items:
                                _titleItems.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _titleValue = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '反馈内容',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            border: Border.all(
                              color: Colors.white60,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular((10.0)),
                          ),
                          child: TextFormField(
                            // 设置输入框背景色
                            style: TextStyle(color: Colors.black, fontSize: 12),
                            maxLines: 8,
                            decoration: InputDecoration(
                              hintText: '请输入内容',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                              // fillColor: Colors.white,
                              // filled: true,
                            ),
                            onChanged: (value) {
                              _contentValue = value;
                              print(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    RaisedButton(
                      onPressed: () {
                        print('提交反馈');
                        print(_contentValue);
                      },
                      child: Text('提交反馈'),
                      color: primaryColor,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget RaisedButton({
    required void Function() onPressed,
    required Text child,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 70, right: 70, top: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: child,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(textColor),
        ),
      ),
    );
  }
}
