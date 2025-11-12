import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/plant_model.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/pages/science/animals/animal_detail_page.dart';
import 'package:logistics_app/pages/science/plants/plant_list_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:http/http.dart' as http;

class AnimalListPage extends StatefulWidget {
  const AnimalListPage({Key? key}) : super(key: key);

  @override
  State<AnimalListPage> createState() => _AnimalListPageState();
}

class _AnimalListPageState extends State<AnimalListPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late RefreshController _refreshController;
  AnimationController? animationController;
  int _page = 1;
  int _pageSize = 10;
  List<PlantModel> _list = [];
  int _total = 0;
  List<AssetEntity>? selectedAssets = [];
  AssetEntity? _image;
  bool _isLoading = false;
  String _accessToken = '';
  List<Result>? _identifyResult;
  late AnimationController _controller;
  late Animation<double> _animation;
  double _lastProgress = 0;
  // 语言
  String _language = '0';

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _refreshController = RefreshController();
    super.initState();
    getLanguage();
  }

  // 拍照或选择图片
  Future<void> _pickImage() async {
    List<AssetEntity>? pickedFile = await HJBottomSheet.wxPicker(
      context,
      selectedAssets,
      1,
      RequestType.image,
    );
    if (pickedFile != null && pickedFile.isNotEmpty) {
      final imageFile = await pickedFile[0].file;
      if (imageFile != null) {
        setState(() {
          _image = pickedFile[0];
          _isLoading = true;
          identifyAnimal(imageFile.readAsBytesSync(), _accessToken).then((
            value,
          ) {
            print('value:${value}');
            setState(() {
              _identifyResult = value;
              _isLoading = false;
            });
          });
        });
      }
    }
  }

  Future<List<Result>?> identifyAnimal(
    Uint8List imageBytes,
    String accessToken,
  ) async {
    final base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse(
        'https://aip.baidubce.com/rest/2.0/image-classify/v1/animal?access_token=$accessToken',
      ),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'image': base64Image},
    );

    print('response:${response.statusCode}');
    if (response.statusCode == 200) {
      print('response:${response.body}');
      var result = IdentifyResult.fromJson(json.decode(response.body));
      return result.result;
    } else {
      print('识别失败: ${response.body}');
      return null;
    }
  }

  // 获取语言
  Future<void> getLanguage() async {
    var result = await SpUtils.getString('locale');
    var animalAccessToken = await SpUtils.getString('animalAccessToken');
    setState(() {
      _language = result == 'id' ? '1' : '0';
      _accessToken = animalAccessToken ?? '';
      getPlantList(true);
    });
  }

  Future<void> getPlantList(bool isRefresh) async {
    if (isRefresh) {
      _page = 1;
      _list.clear();
    }
    print('_language${_language}');
    DataUtils.getPageList(
      '/other/fauna/list',
      {
        'pageNum': _page,
        'pageSize': _pageSize,
        "status": '0',
        "type": '0',
        "language": _language,
      },
      success: (data) {
        var noticeList = data['rows'] as List;
        List<PlantModel> rows =
            noticeList.map((i) => PlantModel.fromJson(i)).toList();
        if (isRefresh) {
          _list = rows;
        } else {
          _list = [..._list, ...rows];
        }
        _total = data['total'] ?? 0;
        _page++;
        setState(() {
          if (_list.length >= _total) {
            _refreshController.loadNoData();
          } else {
            _refreshController.loadComplete();
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('动物科普', style: TextStyle(fontSize: 16.px)),
        actions: [
          if (_accessToken != '')
            IconButton(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
            ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SmartRefreshWidget(
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
            if (_image != null)
              Positioned(
                top: 10.px,
                left: 10.px,
                bottom: 10.px,
                right: 10.px,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: AssetEntityImage(
                          _image!,
                          isOriginal: true,
                          fit: BoxFit.cover,
                        ),
                      ),
                      _isLoading
                          ?
                          // 加载中
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  final current = _animation.value;
                                  final painter = ScanOverlayPainter(
                                    progress: current,
                                    lastProgress: _lastProgress,
                                  );
                                  _lastProgress = current; // 更新为下一帧使用
                                  return CustomPaint(
                                    size: Size.infinite,
                                    painter: painter,
                                  );
                                },
                              ),
                            ),
                          )
                          : Positioned(
                            top: 10.px,
                            left: 10.px,
                            width: 200.px,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.px,
                                vertical: 5.px,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: primaryColor,
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '识别结果',
                                    style: TextStyle(color: secondaryColor),
                                  ),
                                  // 遍历识别结果
                                  SizedBox(height: 10.px),
                                  if (_identifyResult != null)
                                    for (var item in _identifyResult!)
                                      Container(
                                        margin: EdgeInsets.only(bottom: 5.px),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.name ?? '',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.px,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: 10.px),
                                                // 进度条
                                                Container(
                                                  width: 60.px,
                                                  height: 6.px,
                                                  color: primaryColor,
                                                  child:
                                                      LinearProgressIndicator(
                                                        value: item.score,
                                                        color: secondaryColor,
                                                      ),
                                                ),
                                                // 百分比
                                                Container(
                                                  width: 45.px,
                                                  child: Text(
                                                    '${(item.score! * 100).toStringAsFixed(2)}%',
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10.px,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          ),

                      // 弹窗关闭
                      Positioned(
                        top: 10.px,
                        right: 10.px,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _image = null;
                              _identifyResult = null;
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    animationController?.dispose();
    _controller.dispose();
    super.dispose();
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AnimalDetailPage(
                              fId: plants[index].fId.toString(),
                            ),
                      ),
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
                          Image.network(
                            plant.picture != ''
                                ? APIs.imagePrefix + plant.picture!
                                : '',
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
                                  style: TextStyle(fontSize: 14.px),
                                ),
                                HtmlLineLimit(
                                  htmlContent: plant.habit ?? '',
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
