import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/plant_model.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/route/routes.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:image/image.dart' as img;

class PlantListPage extends StatefulWidget {
  const PlantListPage({Key? key}) : super(key: key);

  @override
  State<PlantListPage> createState() => _PlantListPageState();
}

class _PlantListPageState extends State<PlantListPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late RefreshController _refreshController;
  AnimationController? animationController;
  int _page = 1;
  int _pageSize = 10;
  List<PlantModel> _list = [];
  int _total = 0;
  File? _image;
  bool _loading = false;
  late Interpreter _interpreter;
  List<String> _labels = [];
  String _result = '';
  Uint8List? _imageBytes;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _refreshController = RefreshController();
    super.initState();
    _loadPlants();
    _loadModel();
  }

  Future<void> _loadModel() async {
    setState(() => _loading = true);

    try {
      print('开始加载模型...');
      // 加载模型
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      print('模型加载成功，输入数量: ${_interpreter.getInputTensors().length}');
      print('输入张量形状: ${_interpreter.getInputTensor(0).shape}');
      print('输出张量形状: ${_interpreter.getOutputTensor(0).shape}');

      // 加载标签
      String labelContent = await rootBundle.loadString('assets/labels.txt');
      _labels = labelContent.split('\n');
      print('标签加载成功，数量: ${_labels.length}');

      setState(() => _loading = false);
    } catch (e, stackTrace) {
      print('加载模型失败: $e');
      print('错误堆栈: $stackTrace');
      setState(() {
        _loading = false;
        _result = '加载模型失败: $e';
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    // 选择照片或拍照
    final result = await HJBottomSheet.wxPicker(context, [], 1);
    if (result != null && result.isNotEmpty) {
      final asset = result[0];
      final file = await asset.file;
      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() => _imageBytes = bytes);
        _recognizePlant(bytes);
      }
    }
  }

  Future<void> _recognizePlant(Uint8List imageBytes) async {
    setState(() {
      _loading = true;
      _result = '识别中...';
    });

    print('_result::${_result}');
    try {
      // 1. 预处理图像
      final inputImage = img.decodeImage(imageBytes)!;
      final processedImage = _preprocessImage(inputImage);

      // 2. 运行推理
      final output = List.filled(
        1 * _labels.length,
        0,
      ).reshape([1, _labels.length]);
      _interpreter.run(processedImage, output);

      // 3. 解析结果
      final prediction = output[0];
      final maxIndex = prediction.indexOf(
        prediction.reduce((a, b) => a > b ? a : b),
      );
      final confidence = prediction[maxIndex];

      setState(() {
        _result =
            '识别结果: ${_labels[maxIndex]}\n置信度: ${(confidence * 100).toStringAsFixed(2)}%';
      });
    } catch (e) {
      print('识别失败: $e');
      setState(() => _result = '识别失败: $e');
    } finally {
      print('_result::${_result}');
      setState(() => _loading = false);
    }
  }

  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    // 调整大小到模型需要的尺寸
    final resized = img.copyResize(image, width: 224, height: 224);

    // 归一化像素值到模型需要的范围
    var input = List.generate(
      1,
      (_) => List.generate(
        224,
        (_) => List.generate(224, (_) => List.filled(3, 0.0)),
      ),
    );

    for (var y = 0; y < resized.height; y++) {
      for (var x = 0; x < resized.width; x++) {
        final pixel = resized.getPixel(x, y);
        input[0][y][x][0] = (pixel.r / 127.5) - 1.0;
        input[0][y][x][1] = (pixel.g / 127.5) - 1.0;
        input[0][y][x][2] = (pixel.b / 127.5) - 1.0;
      }
    }

    return input;
  }

  Future<void> getPlantList(bool isRefresh) async {
    if (isRefresh) {
      _page = 1;
      _list.clear();
    }
    _loadPlants();
    // DataUtils.getPageList(
    //   '/system/fauna/list',
    //   {
    //     'pageNum': _page,
    //     'pageSize': _pageSize,
    //     'noticeType': 1,
    //     "status": '0',
    //     "approvalStatus": 4,
    //   },
    //   success: (data) {
    //     var noticeList = data['rows'] as List;
    //     List<PlantModel> rows =
    //         noticeList.map((i) => PlantModel.fromJson(i)).toList();
    //     if (isRefresh) {
    //       _list = rows;
    //     } else {
    //       _list = [..._list, ...rows];
    //     }
    //     _total = data['total'] ?? 0;
    //     _page++;
    //     setState(() {
    //       if (_list.length >= _total) {
    //         _refreshController.loadNoData();
    //       } else {
    //         _refreshController.loadComplete();
    //       }
    //     });
    //   },
    // );
  }

  void _loadPlants() {
    // TODO: 从API加载植物数据
    _list = [
      PlantModel(
        name: '向日葵',
        introduce:
            '向日葵是菊科向日葵属的一年生草本植物向日葵是菊科向日葵属的一年生草本植物向日葵是菊科向日葵属的一年生草本植物向日葵是菊科向日葵属的一年生草本植物向日葵是菊科向日葵属的一年生草本植物',
        picture: 'assets/images/sunflowers.jpg',
      ),
      PlantModel(
        name: '玫瑰',
        introduce: '玫瑰是蔷薇科蔷薇属的植物',
        picture: 'assets/images/roses.jpg',
      ),
      // 添加更多植物数据
    ];
  }

  void _filterPlants(String query) {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('植物科普', style: TextStyle(fontSize: 16.px)),
        actions: [
          IconButton(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.camera_alt),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: SafeArea(
        child: SmartRefreshWidget(
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: () {
            getPlantList(true).then((value) {
              _refreshController.refreshCompleted();
            });
          },
          onLoading: () {
            getPlantList(false).then((value) {
              _refreshController.loadComplete();
            });
          },
          controller: _refreshController,
          child: Padding(
            padding: EdgeInsets.all(10.px),
            child: PlantListView(
              plants: _list,
              animationController: animationController,
            ),
          ),
        ),
      ),
    );
  }
}

class PlantListView extends StatelessWidget {
  final List<PlantModel> plants;
  final AnimationController? animationController;

  PlantListView({required this.plants, this.animationController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(), // 禁用内部滚动
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.8,
      ),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final int count = plants.length;
        final Animation<double> animation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animationController!,
            curve: Interval(
              (1 / count) * index,
              1.0,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        );
        animationController?.forward();
        return plants.isNotEmpty
            ? PlantItemView(
              plant: plants[index],
              animation: animation,
              callBack:
                  () => {
                    // 跳转到详情页
                    RouteUtils.pushNamed(
                      context,
                      RoutePath.PlantDetailPage,
                      arguments: {'fId': '0'},
                    ),
                  },
              animationController: animationController,
            )
            : EmptyView();
      },
    );
  }
}

class PlantItemView extends StatelessWidget {
  PlantItemView({
    required this.plant,
    this.animation,
    this.animationController,
    this.callBack,
  });
  final PlantModel plant;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final VoidCallback? callBack;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0,
              50.px * (1.0 - animation!.value),
              0.0,
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: 10.px),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.px),
                  ),
                  // 超出隐藏
                  clipBehavior: Clip.hardEdge,
                  shadowColor: Colors.grey,
                  elevation: 2,
                  child: InkWell(
                    onTap: callBack,
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            plant.picture ?? '',
                            width: double.infinity,
                            height: 130.px,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.px,
                              vertical: 4.px,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  plant.name ?? '',
                                  style: TextStyle(fontSize: 12.px),
                                ),
                                HtmlLineLimit(
                                  htmlContent: plant.introduce ?? '',
                                  fontSize: 10.px,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
