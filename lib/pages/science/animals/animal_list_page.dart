import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/plant_model.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _refreshController = RefreshController();
    super.initState();
    getPlantList(true);
  }

  Future<void> getPlantList(bool isRefresh) async {
    if (isRefresh) {
      _page = 1;
      _list.clear();
    }
    DataUtils.getPageList(
      '/system/fauna/list',
      {'pageNum': _page, 'pageSize': _pageSize, "status": '0', "type": '0'},
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

  void _filterPlants(String query) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('动物科普', style: TextStyle(fontSize: 16.px)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt)),
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

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    animationController?.dispose();
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
