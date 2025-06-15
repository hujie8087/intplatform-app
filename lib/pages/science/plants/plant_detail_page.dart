import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:logistics_app/http/model/plant_model.dart';

class PlantDetailPage extends StatefulWidget {
  final String fId;

  const PlantDetailPage({Key? key, required this.fId}) : super(key: key);

  @override
  _PlantDetailPageState createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  PlantModel? plantData;
  List<String> picture = [];

  @override
  void initState() {
    super.initState();
    // 获取植物数据
    getPlantData();
  }

  void getPlantData() {
    // 获取植物数据
    // PlantModel plantData = PlantModel(fId: int.parse(widget.fId));
    setState(() {
      plantData = PlantModel(
        name: '向日葵',
        introduce:
            '向日葵是菊科向日葵属的一年生草本植物向日葵是菊科向日葵属的一年生草本植物向日葵是菊科向日葵属的一年生草本植物向日葵是菊科向日葵属的一年生草本植物向日葵是菊科向日葵属的一年生草本植物',
        picture:
            'assets/images/sunflowers.jpg,assets/images/sunflowers.jpg,assets/images/sunflowers.jpg',
      );
      picture = plantData?.picture?.split(',') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plantData?.name ?? '植物详情'), elevation: 0),
      body: SingleChildScrollView(
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
                        image: AssetImage(picture[index]),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 植物名称
                  Text(
                    plantData?.name ?? '',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plantData?.introduce ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 基本信息卡片
                  _buildInfoCard(context, '基本信息', [
                    _buildInfoRow('科属', plantData?.introduce ?? '未知'),
                    _buildInfoRow('分布地点', plantData?.location ?? '未知'),
                    _buildInfoRow('生长环境', plantData?.introduce ?? '未知'),
                    _buildInfoRow('保护等级', plantData?.introduce ?? '未列入'),
                  ]),
                  const SizedBox(height: 16),

                  // 形态特征
                  _buildInfoCard(context, '形态特征', [
                    Text(plantData?.introduce ?? '暂无描述'),
                  ]),
                  const SizedBox(height: 16),

                  // 生长习性
                  _buildInfoCard(context, '生长习性', [
                    Text(plantData?.introduce ?? '暂无描述'),
                  ]),
                  const SizedBox(height: 16),

                  // 应用价值
                  _buildInfoCard(context, '应用价值', [
                    Text(plantData?.introduce ?? '暂无描述'),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
