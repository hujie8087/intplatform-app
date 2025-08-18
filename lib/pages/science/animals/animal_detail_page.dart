import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/plant_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class AnimalDetailPage extends StatefulWidget {
  final String fId;

  const AnimalDetailPage({Key? key, required this.fId}) : super(key: key);

  @override
  _AnimalDetailPageState createState() => _AnimalDetailPageState();
}

class _AnimalDetailPageState extends State<AnimalDetailPage>
    with TickerProviderStateMixin {
  PlantModel? plantData;
  List<String> picture = [];
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    super.initState();
    // 获取植物数据
    getPlantData();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Padding(
                  padding: EdgeInsets.only(
                    left: 12.px,
                    right: 12.px,
                    top: 12.px,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 植物名称
                      Text(
                        plantData?.name ?? '',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 4.px),
                      Text(
                        plantData?.peacockType ?? '',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.px),
                // 形态特征
                _buildInfoCard(
                  context,
                  '产地',
                  [
                    Text(
                      plantData?.origin ?? '暂无描述',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  0.2,
                  animationController,
                  Color.fromARGB(255, 232, 245, 233),
                  true,
                  // 2E7D32
                  Color.fromARGB(255, 46, 125, 50),
                ),
                SizedBox(height: 10.px),

                // 生长习性
                _buildInfoCard(
                  context,
                  '习性',
                  [
                    Text(
                      plantData?.habit ?? '暂无描述',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  0.4,
                  animationController,
                  // E3F2FD
                  Color.fromARGB(255, 227, 242, 253),
                  false,
                  // 1565C0
                  Color.fromARGB(255, 21, 101, 192),
                ),
                SizedBox(height: 10.px),

                // 应用价值
                _buildInfoCard(
                  context,
                  '食物',
                  [
                    Text(
                      plantData?.food ?? '暂无描述',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  0.6,
                  animationController,
                  // FFF3E0
                  Color.fromARGB(255, 255, 243, 224),
                  true,
                  // E65100
                  Color.fromARGB(255, 230, 81, 0),
                ),
                SizedBox(height: 10.px),

                // 应用价值
                _buildInfoCard(
                  context,
                  '繁殖',
                  [
                    Text(
                      plantData?.reproduce ?? '暂无描述',
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  0.8,
                  animationController,
                  // FCE4EC
                  Color.fromARGB(255, 252, 228, 236),
                  false,
                  // AD1457
                  Color.fromARGB(255, 173, 20, 87),
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

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    List<Widget> children,
    double index,
    AnimationController? animationController,
    Color? color,
    bool? isRight,
    Color? titleColor,
  ) {
    // 启动动画
    animationController?.forward();

    final Animation<double> animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Interval(
          index * 0.15,
          (index * 0.15) + 0.3,
          curve: Curves.easeInOut,
        ),
      ),
    );
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              80.px * (1.0 - animation.value),
              0.0,
            ),
            child: Container(
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.only(
                  left: isRight == true ? 15.px : 0,
                  right: isRight == true ? 0 : 15.px,
                ),
                decoration: BoxDecoration(
                  color: color ?? Colors.white,
                  borderRadius:
                      isRight == true
                          ? BorderRadius.only(
                            topLeft: Radius.circular(10.px),
                            bottomLeft: Radius.circular(10.px),
                          )
                          : BorderRadius.only(
                            topRight: Radius.circular(10.px),
                            bottomRight: Radius.circular(10.px),
                          ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.px),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.px,
                          fontWeight: FontWeight.bold,
                          color: titleColor ?? primaryColor,
                        ),
                      ),
                      // 分割线
                      Divider(height: 10.px),
                      SizedBox(height: 6.px),
                      ...children,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
