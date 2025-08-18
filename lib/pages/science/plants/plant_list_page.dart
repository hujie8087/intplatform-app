import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/plant_model.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/pages/science/plants/plant_detail_page.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/hj_bottom_sheet.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:http/http.dart' as http;

// 识别结果
class IdentifyResult {
  int? logId;
  List<Result>? result;

  IdentifyResult({this.logId, this.result});

  IdentifyResult.fromJson(Map<String, dynamic> json) {
    logId = json['log_id'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['log_id'] = this.logId;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  double? score;
  String? name;

  Result({this.score, this.name});

  Result.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['name'] = this.name;
    return data;
  }
}

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
  // 选择的图片
  List<AssetEntity> selectedAssets = [];
  int _page = 1;
  int _pageSize = 10;
  List<PlantModel> _list = [];
  int _total = 0;
  // 语言
  String _language = '0';
  String _accessToken = '';
  AssetEntity? _image;
  List<Result>? _identifyResult;
  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  double _lastProgress = 0;

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
    getAccessToken();
  }

  // 获取语言
  Future<void> getLanguage() async {
    var result = await SpUtils.getString('locale');
    var plantAccessToken = await SpUtils.getString('plantAccessToken');
    setState(() {
      _language = result == 'id' ? '1' : '0';
      _accessToken = plantAccessToken ?? '';
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
        "type": '1',
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
  void dispose() {
    animationController?.dispose();
    _searchController.dispose();
    _refreshController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // 拍照或选择图片
  Future<void> _pickImage() async {
    List<AssetEntity>? pickedFile = await HJBottomSheet.wxPicker(
      context,
      selectedAssets,
      1,
    );
    if (pickedFile != null && pickedFile.isNotEmpty) {
      final imageFile = await pickedFile[0].file;
      if (imageFile != null) {
        setState(() {
          _image = pickedFile[0];
          _isLoading = true;
          identifyPlant(imageFile.readAsBytesSync(), _accessToken).then((
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

  Future<List<Result>?> identifyPlant(
    Uint8List imageBytes,
    String accessToken,
  ) async {
    final base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse(
        'https://aip.baidubce.com/rest/2.0/image-classify/v1/plant?access_token=$accessToken',
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

  // 获取百度AI access_token
  Future getAccessToken() async {
    var accessToken = await SpUtils.getString('access_token');
    if (accessToken != null) {
      setState(() {
        _accessToken = accessToken;
        print('access_token2: ${accessToken}');
      });
    } else {
      final response = await http.post(
        Uri.parse('https://aip.baidubce.com/oauth/2.0/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'client_credentials',
          'client_id': 'tTzUnbWPljCNvncZx3sLOhqi',
          'client_secret': 'vJZSD1t5H9omgojE1ruQoYiaoQWQSpwy',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('access_token1: ${data['access_token']}');
        setState(() {
          SpUtils.saveString('access_token', data['access_token']);
          _accessToken = data['access_token'];
        });
      } else {
        print('获取 access_token 失败: ${response.body}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('植物科普', style: TextStyle(fontSize: 16.px)),
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
}

class ScanOverlayPainter extends CustomPainter {
  final double progress;
  final double? lastProgress; // 新增：传入上一次的值（由外部State记录）

  ScanOverlayPainter({required this.progress, this.lastProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final scanY = size.height * progress;
    const lineHeight = 2.0;
    const tailHeight = 300.0;

    // 背景遮罩
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.1);
    canvas.drawRect(Offset.zero & size, overlayPaint);

    // ✅ 判断方向：向下 or 向上
    final movingDown = !(lastProgress == null || progress >= lastProgress!);

    // ✅ 尾影绘制范围
    Rect tailRect;
    if (movingDown) {
      // 向下扫：尾影在下方
      final tailBottom = (scanY + tailHeight).clamp(
        0.0,
        size.height.toDouble(),
      );
      tailRect = Rect.fromLTWH(0, scanY, size.width, tailBottom - scanY);
    } else {
      // 向上扫：尾影在上方
      final tailTop = (scanY - tailHeight).clamp(0.0, size.height.toDouble());
      tailRect = Rect.fromLTWH(0, tailTop, size.width, scanY - tailTop);
    }

    final tailPaint =
        Paint()
          ..shader = LinearGradient(
            begin: movingDown ? Alignment.topCenter : Alignment.bottomCenter,
            end: movingDown ? Alignment.bottomCenter : Alignment.topCenter,
            colors: [
              Colors.greenAccent.withOpacity(0.4),
              Colors.greenAccent.withOpacity(0.2),
              Colors.greenAccent.withOpacity(0.05),
              Colors.transparent,
            ],
          ).createShader(tailRect)
          ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, 10);
    ;

    canvas.drawRect(tailRect, tailPaint);

    // ✅ 主扫描线
    final linePaint =
        Paint()
          ..color = Colors.greenAccent
          ..strokeWidth = lineHeight;
    canvas.drawLine(Offset(0, scanY), Offset(size.width, scanY), linePaint);
  }

  @override
  bool shouldRepaint(covariant ScanOverlayPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class PlantListView extends StatelessWidget {
  final List<PlantModel> plants;
  final AnimationController? animationController;

  PlantListView({required this.plants, this.animationController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(), // 禁用内部滚动
      shrinkWrap: true,
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
              index: index,
              callBack:
                  () => {
                    // 跳转到详情页
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PlantDetailPage(
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
    this.index,
    this.animationController,
    this.callBack,
  });
  final PlantModel plant;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final VoidCallback? callBack;
  final int? index;
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
                  elevation: 4,
                  child: InkWell(
                    onTap: callBack,
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          if (index != null && index! % 2 == 0)
                            Image.network(
                              plant.picture != ''
                                  ? APIs.imagePrefix + plant.picture!
                                  : '',
                              width: 100.px,
                              height: 100.px,
                              fit: BoxFit.cover,
                            ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.px,
                                vertical: 4.px,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plant.name ?? '',
                                    style: TextStyle(fontSize: 14.px),
                                  ),
                                  HtmlLineLimit(
                                    htmlContent: plant.introduce ?? '',
                                    maxLines: 3,
                                    fontSize: 10.px,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index != null && index! % 2 == 1)
                            Image.network(
                              plant.picture != ''
                                  ? APIs.imagePrefix + plant.picture!
                                  : '',
                              width: 100.px,
                              height: 100.px,
                              fit: BoxFit.cover,
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
