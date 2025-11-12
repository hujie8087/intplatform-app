import 'dart:math' as math;
import 'package:logistics_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/main.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

import '../../pages/models/tabIcon_data.dart';

class NavigationBarItem extends StatefulWidget {
  final List<TabIconData> tabIconsList;
  final Function(int index) changeIndex;
  final int grooveIndex;

  const NavigationBarItem({
    Key? key,
    required this.tabIconsList,
    required this.changeIndex,
    required this.grooveIndex,
  }) : super(key: key);

  @override
  NavigationBarItemState createState() => NavigationBarItemState();
}

class NavigationBarItemState extends State<NavigationBarItem>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  late AnimationController physicalShapeAnimationController;
  double current = 1.0;
  double prev = 1.0;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    animationController?.forward();
    super.initState();
    physicalShapeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200), // 动画持续时间
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
    double screenWidth =
        MediaQuery.of(context).size.width > 750
            ? 750
            : MediaQuery.of(context).size.width;
    int tabCount = widget.tabIconsList.length;
    int grooveIndex = widget.grooveIndex; // 想让凹槽居中第2个tab
    double itemWidth = screenWidth / tabCount;
    double fromOffset = (grooveIndex + 0.5) * itemWidth - screenWidth / 2;
    double toOffset = (grooveIndex + 0.5) * itemWidth - screenWidth / 2;
    Animation<double> offsetAnimation = Tween<double>(
      begin: fromOffset,
      end: toOffset,
    ).animate(
      CurvedAnimation(
        parent: physicalShapeAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child) {
            return AnimatedBuilder(
              animation: physicalShapeAnimationController,
              builder: (context, child) {
                double radius =
                    Tween<double>(begin: 0.0, end: 1.0)
                        .animate(
                          CurvedAnimation(
                            parent: animationController!,
                            curve: Curves.fastOutSlowIn,
                          ),
                        )
                        .value *
                    30.px;
                double offset = offsetAnimation.valueOrDefault(
                  (grooveIndex + 0.5) * itemWidth - screenWidth / 2,
                );
                return Transform(
                  transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                  child: PhysicalShape(
                    color: AppTheme.white,
                    elevation: 14.0.px,
                    clipper: TabClipper(
                      radius: radius,
                      horizontalOffset: offset,
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40.px,
                          child: Container(
                            child: Row(
                              children:
                                  widget.tabIconsList.map((item) {
                                    return Expanded(
                                      child: TabIcons(
                                        tabIconData: item,
                                        removeAllSelect: () {
                                          widget.changeIndex(item.index);
                                        },
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).padding.bottom),
                      ],
                    ),
                  ),
                );
              },
            );
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
              clipBehavior: Clip.none,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 600), // 动画持续时间
                  curve: Curves.easeInOut, // 动画曲线
                  transform: Matrix4.translationValues(
                    0.0,
                    widget.tabIconData!.isSelected ? -20.px : 0,
                    0.0,
                  ),
                  decoration: BoxDecoration(
                    color:
                        widget.tabIconData!.isSelected
                            ? primaryColor
                            : Colors.white, // 动画颜色
                    gradient:
                        widget.tabIconData!.isSelected
                            ? LinearGradient(
                              colors: [primaryColor, HexColor('#6A88E5')],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                            : null,
                    shape: BoxShape.circle,
                    boxShadow:
                        widget.tabIconData!.isSelected
                            ? <BoxShadow>[
                              BoxShadow(
                                color: primaryColor.withOpacity(0.4),
                                offset: Offset(8.0.px, 16.0.px),
                                blurRadius: 16.0.px,
                              ),
                            ]
                            : null,
                  ),
                  child: ScaleTransition(
                    alignment:
                        widget.tabIconData!.isSelected
                            ? Alignment.center
                            : Alignment.topCenter,
                    scale: Tween<double>(begin: 0.7, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.tabIconData!.animationController!,
                        curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn),
                      ),
                    ),
                    child: Image.asset(
                      widget.tabIconData!.isSelected
                          ? widget.tabIconData!.selectedImagePath
                          : widget.tabIconData!.imagePath,
                    ),
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
                          curve: Interval(
                            0.1,
                            1.0,
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                      ),
                      child: Text(
                        widget.tabIconData!.labelName,
                        style: TextStyle(
                          color:
                              widget.tabIconData!.isSelected
                                  ? primaryColor
                                  : Colors.grey,
                          fontSize: 12.px,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 4.px,
                  left: 6.px,
                  right: 0,
                  child: ScaleTransition(
                    alignment: Alignment.topCenter,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.tabIconData!.animationController!,
                        curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn),
                      ),
                    ),
                    child: Container(
                      width: 8.px,
                      height: 8.px,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.px,
                  left: 6.px,
                  bottom: 8.px,
                  child: ScaleTransition(
                    alignment: Alignment.topCenter,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.tabIconData!.animationController!,
                        curve: Interval(0.5, 0.8, curve: Curves.fastOutSlowIn),
                      ),
                    ),
                    child: Container(
                      width: 4.px,
                      height: 4.px,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6.px,
                  right: 8.px,
                  bottom: 0.px,
                  child: ScaleTransition(
                    alignment: Alignment.topCenter,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: widget.tabIconData!.animationController!,
                        curve: Interval(0.5, 0.6, curve: Curves.fastOutSlowIn),
                      ),
                    ),
                    child: Container(
                      width: 6.px,
                      height: 6.px,
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

//
class TabClipper extends CustomClipper<Path> {
  TabClipper({this.radius = 38.0, this.horizontalOffset = 0.0});

  final double radius;
  final double horizontalOffset;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double v = radius * 2;

    path.lineTo(0, 0);
    path.arcTo(
      Rect.fromLTWH(0, 0, radius, radius),
      degreeToRadians(180),
      degreeToRadians(90),
      false,
    );

    path.arcTo(
      Rect.fromLTWH(
        ((size.width / 2 + horizontalOffset) - v / 2) - radius + v * 0.04,
        0,
        radius,
        radius,
      ),
      degreeToRadians(270),
      degreeToRadians(70),
      false,
    );

    path.arcTo(
      Rect.fromLTWH((size.width / 2) - v / 2 + horizontalOffset, -v / 2, v, v),
      degreeToRadians(160),
      degreeToRadians(-140),
      false,
    );

    path.arcTo(
      Rect.fromLTWH(
        (size.width + horizontalOffset - ((size.width / 2) - v / 2)) - v * 0.04,
        0,
        radius,
        radius,
      ),
      degreeToRadians(200),
      degreeToRadians(70),
      false,
    );

    path.arcTo(
      Rect.fromLTWH(size.width - radius, 0, radius, radius),
      degreeToRadians(270),
      degreeToRadians(90),
      false,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    return (math.pi / 180) * degree;
  }
}

extension _AnimExt on Animation<double> {
  double valueOrDefault(double fallback) {
    if (status == AnimationStatus.dismissed || value.isNaN) return fallback;
    return value;
  }
}
