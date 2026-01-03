import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/plant_model.dart';
import 'package:logistics_app/utils/color.dart';
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
                // 植物基本信息卡片
                Container(
                  margin: EdgeInsets.all(12.px),
                  padding: EdgeInsets.all(16.px),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.px),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 植物名称
                      Text(
                        plantData?.name ?? S.of(context).science_plant_unknown,
                        style: TextStyle(
                          fontSize: 16.px,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),

                      SizedBox(height: 4.px),

                      // 科属信息
                      if (plantData?.peacockType != null &&
                          plantData!.peacockType!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.category,
                          label: S.of(context).science_plant_peacock_type,
                          value: plantData!.peacockType!,
                          color: Colors.blue.shade600,
                        ),

                      // 别名信息
                      if (plantData?.otherName != null &&
                          plantData!.otherName!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.label,
                          label: S.of(context).science_plant_other_name,
                          value: plantData!.otherName!,
                          color: Colors.orange.shade600,
                        ),

                      // 编码信息
                      if (plantData?.code != null &&
                          plantData!.code!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.qr_code,
                          label: S.of(context).science_plant_code,
                          value: plantData!.code!,
                          color: Colors.purple.shade600,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 4.px),

                // 形态特征
                _buildInfoCard(
                  context,
                  S.of(context).science_plant_feature,
                  [
                    Text(
                      plantData?.feature ?? S.of(context).no_description,
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                  0.2,
                  animationController,
                  Color.fromARGB(255, 232, 245, 233),
                  true,
                  Color.fromARGB(255, 46, 125, 50),
                ),
                SizedBox(height: 10.px),

                // 生长习性
                _buildInfoCard(
                  context,
                  S.of(context).science_plant_habit,
                  [
                    Text(
                      plantData?.habit ?? S.of(context).no_description,
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                  0.4,
                  animationController,
                  Color.fromARGB(255, 227, 242, 253),
                  false,
                  Color.fromARGB(255, 21, 101, 192),
                ),
                SizedBox(height: 10.px),

                // 分布区域
                _buildInfoCard(
                  context,
                  S.of(context).science_plant_origin,
                  [
                    Text(
                      plantData?.origin ?? S.of(context).no_description,
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                  0.6,
                  animationController,
                  Color.fromARGB(255, 255, 243, 224),
                  true,
                  Color.fromARGB(255, 230, 81, 0),
                ),
                SizedBox(height: 10.px),

                // 植物简介
                _buildInfoCard(
                  context,
                  S.of(context).science_plant_introduce,
                  [
                    Text(
                      plantData?.introduce ?? S.of(context).no_description,
                      style: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                  0.8,
                  animationController,
                  Color.fromARGB(255, 252, 228, 236),
                  false,
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

  // 构建信息行
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.px),
      child: Row(
        children: [
          Icon(icon, size: 16.px, color: color),
          SizedBox(width: 8.px),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12.px,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.px,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                  padding: EdgeInsets.all(12.px),
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
                      Divider(height: 4.px),
                      SizedBox(height: 4.px),
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
