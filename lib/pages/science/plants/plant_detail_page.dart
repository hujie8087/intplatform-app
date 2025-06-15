import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/plant_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class PlantDetailPage extends StatefulWidget {
  final String fId;

  const PlantDetailPage({Key? key, required this.fId}) : super(key: key);

  @override
  _PlantDetailPageState createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage>
    with TickerProviderStateMixin {
  PlantModel? plantData;
  List<String> picture = [];
  AnimationController? animationController;
  ui.Image? woodImage;
  late Animation<double> _swingAnim;
  late AnimationController _controller;
  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _swingAnim = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _loadWoodImage();
    // 获取植物数据
    getPlantData();
  }

  Future<void> _loadWoodImage() async {
    final imageProvider = AssetImage('assets/images/wood.jpg');
    final config = ImageConfiguration();
    final completer = Completer<ui.Image>();
    final stream = imageProvider.resolve(config);
    final listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    });
    stream.addListener(listener);
    final image = await completer.future;
    stream.removeListener(listener);
    setState(() => woodImage = image);
  }

  void getPlantData() {
    // 获取植物数据
    DataUtils.getDetailById(
      '/other/fauna/' + widget.fId,
      success: (data) {
        plantData = PlantModel.fromJson(data['data']);
        setState(() {
          picture = plantData?.picture?.split(',') ?? [];
        });
      },
    );
  }

  @override
  void dispose() {
    animationController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 图片轮播
                SizedBox(
                  height: 300,
                  child: Swiper(
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              APIs.imagePrefix + picture[index],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    itemCount: picture.length,
                    autoplay: true,
                    duration: 300,
                    pagination: const SwiperPagination(),
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.px),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomPaint(
                            painter: WoodenBoardPainter(
                              strokeWidth: 0.px,
                              woodImage: woodImage,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(8.px),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8.px),
                              ),
                              child: CustomPaint(
                                painter: WoodenBoardPainter(),
                                child: Container(
                                  padding: EdgeInsets.all(8.px),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.px),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 主标题
                                      Center(
                                        child: Text(
                                          plantData?.name ?? '暂无名称',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red.shade700,
                                          ),
                                        ),
                                      ),
                                      const Divider(height: 20, thickness: 1.2),
                                      // 别名
                                      _labelRow(
                                        '别名：',
                                        plantData?.otherName ?? '暂无别名',
                                      ),
                                      _labelRow(
                                        '科属：',
                                        plantData?.peacockType ?? '暂无科属',
                                      ),
                                      _labelRow(
                                        '特征：',
                                        plantData?.feature ?? '暂无特征',
                                      ),
                                      _labelRow(
                                        '习性：',
                                        plantData?.habit ?? '暂无习性',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          AnimatedBuilder(
                            animation: _swingAnim,
                            builder:
                                (_, __) => CustomPaint(
                                  size: const Size(double.infinity, 60),
                                  painter: SwingRopePainter(
                                    offset: _swingAnim.value,
                                  ),
                                ),
                          ),
                          Transform.translate(
                            offset: Offset(0, -20),
                            child: CustomPaint(
                              painter: WoodenBoardPainter(
                                strokeWidth: 0.px,
                                woodImage: woodImage,
                              ),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8.px),
                                ),
                                padding: EdgeInsets.all(8.px),
                                child: CustomPaint(
                                  painter: WoodenBoardPainter(),
                                  child: Container(
                                    padding: EdgeInsets.all(8.px),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.px),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // 主标题
                                        Center(
                                          child: Text(
                                            '简介',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red.shade700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Divider(
                                          height: 20,
                                          thickness: 1.2,
                                        ),
                                        Text(
                                          plantData?.introduce ?? '暂无描述',

                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 6,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelRow(String label, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class SwingRopePainter extends CustomPainter {
  final double offset;
  SwingRopePainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.brown
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final topY = 0.0;
    final bottomY = size.height;

    final leftX = centerX - 40;
    final rightX = centerX + 40;

    // 左绳弯曲
    final leftPath = Path();
    leftPath.moveTo(leftX, topY);
    leftPath.quadraticBezierTo(leftX + offset, size.height / 2, leftX, bottomY);
    canvas.drawPath(leftPath, paint);

    // 右绳弯曲
    final rightPath = Path();
    rightPath.moveTo(rightX, topY);
    rightPath.quadraticBezierTo(
      rightX + offset,
      size.height / 2,
      rightX,
      bottomY,
    );
    canvas.drawPath(rightPath, paint);
  }

  @override
  bool shouldRepaint(covariant SwingRopePainter oldDelegate) =>
      oldDelegate.offset != offset;
}

class WoodenBoardPainter extends CustomPainter {
  final double strokeWidth;
  final ui.Image? woodImage;

  WoodenBoardPainter({this.strokeWidth = 3, this.woodImage});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = 12.0;
    final curveWidth = size.width * 2 / 3;
    final leftFlat = (size.width - curveWidth) / 2;

    // ✅ 构造路径
    final path = Path();
    path.moveTo(radius, size.height);
    path.lineTo(size.width - radius, size.height);
    path.arcToPoint(
      Offset(size.width, size.height - radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(size.width, 40 + radius);
    path.arcToPoint(
      Offset(size.width - radius, 40),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    path.lineTo(size.width - leftFlat, 40);
    path.quadraticBezierTo(size.width / 2, -30, leftFlat, 40);
    path.lineTo(radius, 40);
    path.arcToPoint(
      Offset(0, 40 + radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(0, size.height - radius);
    path.arcToPoint(
      Offset(radius, size.height),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.close();

    // ✅ 添加阴影（背景阴影偏移）
    canvas.drawShadow(path, Colors.black45, 10.0, true);

    // ✅ 背景木纹图
    if (woodImage != null) {
      canvas.save();
      canvas.clipPath(path);
      canvas.drawImageRect(
        woodImage!,
        Rect.fromLTWH(
          0,
          0,
          woodImage!.width.toDouble(),
          woodImage!.height.toDouble(),
        ),
        Offset.zero & size,
        Paint(),
      );
      canvas.restore();
    }

    // ✅ 凹槽效果（浅内描边）
    final innerPaint =
        Paint()
          ..color = Colors.brown.withOpacity(0.8)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;
    canvas.drawPath(path, innerPaint);

    // ✅ 主边框
    final borderPaint =
        Paint()
          ..color = Colors.brown.shade700
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
