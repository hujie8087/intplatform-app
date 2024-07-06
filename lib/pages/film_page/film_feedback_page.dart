import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';

class FilmFeedbackPage extends StatefulWidget {
  const FilmFeedbackPage({Key? key, this.animationController})
      : super(key: key);
  final AnimationController? animationController;
  @override
  _FilmFeedbackPage createState() => _FilmFeedbackPage();
}

class _FilmFeedbackPage extends State<FilmFeedbackPage> {
  Animation<double>? opacityAnimation;

  @override
  void initState() {
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));

    widget.animationController!.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "意见反馈",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            backgroundColor: filmAppBarBackgroundColor,
            foregroundColor: Colors.white,
          ),
          backgroundColor: filmBackgroundColor,
          body: Container(
              padding: EdgeInsets.all(10),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '分享您的体验，帮助我们做得更好。',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 14),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      // 设置光标颜色
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          // 取消边框
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          fillColor: filmAppBarBackgroundColor,
                          // 设置背景
                          filled: true,
                          // 提示语颜色
                          hintText: '请输入反馈标题',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      // 多行文本
                      maxLines: 10,
                      style: TextStyle(color: Colors.white),
                      // 设置光标颜色
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          // 取消边框
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          fillColor: filmAppBarBackgroundColor,
                          // 设置背景
                          filled: true,
                          // 提示语颜色
                          hintText: '请输入反馈内容',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          // 设置圆角
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                          // 设置宽度
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size(200, 50)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(secondaryColor),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(10))),
                      child: Text(
                        '提交',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
