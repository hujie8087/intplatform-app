import 'dart:math' as math;
import 'package:logistics_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/main.dart';
import 'package:logistics_app/utils/color.dart';

import '../../pages/models/tabIcon_data.dart';

class NavigationBarItem extends StatefulWidget {
  const NavigationBarItem(
      {Key? key, this.tabIconsList, this.changeIndex, this.addClick})
      : super(key: key);

  final Function(int index)? changeIndex;
  final Function()? addClick;
  final List<TabIconData>? tabIconsList;
  @override
  NavigationBarItemState createState() => NavigationBarItemState();
}

class NavigationBarItemState extends State<NavigationBarItem>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  late AnimationController physicalShapeAnimationController;
  double current = 0.0;
  double prev = 0.0;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animationController?.forward();
    super.initState();
    physicalShapeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600), // 动画持续时间
    );
    physicalShapeAnimationController.forward();
  }

  @override
  void dispose() {
    physicalShapeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child) {
            return AnimatedBuilder(
                animation: physicalShapeAnimationController,
                builder: (context, child) {
                  double radius = Tween<double>(begin: 0.0, end: 1.0)
                          .animate(CurvedAnimation(
                              parent: animationController!,
                              curve: Curves.fastOutSlowIn))
                          .value *
                      38.0;
                  double horizontalOffset = prev == 1.0
                      ? Tween<double>(begin: 0.0, end: 1.0)
                              .animate(CurvedAnimation(
                                  parent: physicalShapeAnimationController,
                                  curve: Curves.fastOutSlowIn))
                              .value *
                          screenWidth /
                          widget.tabIconsList!.length *
                          (current - 1)
                      : Tween<double>(begin: -1.0, end: 1.0)
                              .animate(CurvedAnimation(
                                  parent: physicalShapeAnimationController,
                                  curve: Curves.fastOutSlowIn))
                              .value *
                          screenWidth /
                          widget.tabIconsList!.length *
                          (current - 1);
                  return Transform(
                    transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                    child: PhysicalShape(
                      color: AppTheme.white,
                      elevation: 16.0,
                      clipper: TabClipper(
                          radius: radius, horizontalOffset: horizontalOffset),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                            child: Container(
                              child: Row(
                                children: widget.tabIconsList!.map((item) {
                                  return Expanded(
                                      child: TabIcons(
                                          tabIconData: item,
                                          removeAllSelect: () {
                                            setRemoveAllSelection(item);
                                            widget.changeIndex!(item.index);
                                          }));
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ],
    );
  }

  void setRemoveAllSelection(TabIconData? tabIconData) {
    if (!mounted) return;
    setState(() {
      current = tabIconData!.index.toDouble();
      physicalShapeAnimationController.forward(from: 0.0).then((res) {
        prev = current;
      });
    });
  }
}

class TabIcons extends StatefulWidget {
  const TabIcons({Key? key, this.tabIconData, this.removeAllSelect})
      : super(key: key);

  final TabIconData? tabIconData;
  final Function()? removeAllSelect;
  @override
  _TabIconsState createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabIconData?.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (!mounted) return;
          widget.removeAllSelect!();
          widget.tabIconData?.animationController?.reverse();
        }
      });
    super.initState();
  }

  void setAnimation() {
    widget.tabIconData?.animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (!widget.tabIconData!.isSelected) {
              setAnimation();
            }
          },
          child: IgnorePointer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 600), // 动画持续时间
                  curve: Curves.easeInOut, // 动画曲线
                  transform: Matrix4.translationValues(
                      0.0, widget.tabIconData!.isSelected ? -20.0 : 0, 0.0),
                  decoration: BoxDecoration(
                    color: widget.tabIconData!.isSelected
                        ? primaryColor
                        : Colors.white, // 动画颜色
                    gradient: widget.tabIconData!.isSelected
                        ? LinearGradient(
                            colors: [
                                primaryColor,
                                HexColor('#6A88E5'),
                              ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)
                        : null,
                    shape: BoxShape.circle,
                    boxShadow: widget.tabIconData!.isSelected
                        ? <BoxShadow>[
                            BoxShadow(
                                color: primaryColor.withOpacity(0.4),
                                offset: const Offset(8.0, 16.0),
                                blurRadius: 16.0),
                          ]
                        : null,
                  ),
                  child: ScaleTransition(
                    alignment: widget.tabIconData!.isSelected
                        ? Alignment.center
                        : Alignment.topCenter,
                    scale: Tween<double>(begin: 0.7, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: Interval(0.1, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    child: Image.asset(widget.tabIconData!.isSelected
                        ? widget.tabIconData!.selectedImagePath
                        : widget.tabIconData!.imagePath),
                  ),
                ),
                if (!widget.tabIconData!.isSelected)
                  Positioned(
                    bottom: 0,
                    child: ScaleTransition(
                      alignment: Alignment.bottomCenter,
                      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.tabIconData!.animationController!,
                              curve: Interval(0.1, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                      child: Text(
                        widget.tabIconData!.labelName,
                        style: TextStyle(
                            color: widget.tabIconData!.isSelected
                                ? primaryColor
                                : Colors.grey,
                            fontSize: 14),
                      ),
                    ),
                  ),
                Positioned(
                  top: 4,
                  left: 6,
                  right: 0,
                  child: ScaleTransition(
                    alignment: Alignment.topCenter,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: Interval(0.2, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 6,
                  bottom: 8,
                  child: ScaleTransition(
                    alignment: Alignment.topCenter,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: Interval(0.5, 0.8,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 8,
                  bottom: 0,
                  child: ScaleTransition(
                    alignment: Alignment.topCenter,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: Interval(0.5, 0.6,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabClipper extends CustomClipper<Path> {
  TabClipper({this.radius = 38.0, this.horizontalOffset = 0.0});

  final double radius;
  final double horizontalOffset; // 只影响凹型图案的水平偏移量

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double v = radius * 2;

    // 绘制从左侧开始的路径，不影响到凹槽部分
    path.lineTo(0, 0);
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
        degreeToRadians(90), false);

    // 绘制凹槽前的直线路径
    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2 + horizontalOffset) - v / 2) - radius + v * 0.04,
            0,
            radius,
            radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);

    // 应用水平偏移量到凹槽部分
    path.arcTo(
        Rect.fromLTWH(
            (size.width / 2) - v / 2 + horizontalOffset, -v / 2, v, v),
        degreeToRadians(160),
        degreeToRadians(-140),
        false);

    // 绘制凹槽后的直线路径
    path.arcTo(
        Rect.fromLTWH(
            (size.width + horizontalOffset - ((size.width / 2) - v / 2)) -
                v * 0.04,
            0,
            radius,
            radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);

    // 完成剩下的路径
    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    final double radian = (math.pi / 180) * degree;
    return radian;
  }
}
