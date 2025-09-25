import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/book_card_widget.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/book_model.dart';
import 'package:logistics_app/pages/library/library_detail_page.dart';
import 'package:logistics_app/route/route_annotation.dart';
import 'package:logistics_app/route/route_utils.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@AppRoute(path: 'library_list_page', name: '图书馆列表页')
class LibraryListPage extends StatefulWidget {
  const LibraryListPage({super.key});
  @override
  _LibraryListPageState createState() => _LibraryListPageState();
}

class _LibraryListPageState extends State<LibraryListPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  int _page = 1;
  List<BookModel> _list = [];
  int _total = 0;

  late RefreshController _refreshController;

  // 搜索相关变量
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';
  String _selectedLocation = '';
  bool _isSearching = false;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _refreshController = RefreshController();
    super.initState();
    getBookList(true);
  }

  Future<void> getBookList(bool isRefresh) async {
    if (isRefresh) {
      _page = 1;
      _list = [];
    }
    try {
      // 构建搜索参数
      Map<String, dynamic> params = {'pageNum': _page, 'pageSize': 10};

      // 添加搜索关键词
      if (_searchKeyword.isNotEmpty) {
        params['bookName'] = _searchKeyword;
      }

      // 添加地点筛选
      if (_selectedLocation.isNotEmpty) {
        params['rcode'] = _selectedLocation;
      }

      DataUtils.getPageList(
        '/other/books/list',
        params,
        success: (data) {
          if (data != null) {
            var bookList = data['rows'] as List;
            List<BookModel> rows =
                bookList.map((i) => BookModel.fromJson(i)).toList();
            if (isRefresh) {
              _list = rows;
            } else {
              _list = [..._list, ...rows];
            }
            _total = data['total'] ?? 0;
            _page++;
          }
          setState(() {
            if (_list.length >= _total) {
              _refreshController.loadNoData();
            } else {
              _refreshController.loadComplete();
            }
          });
        },
      );
    } catch (e) {
      print('Error fetching news: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // 执行搜索
  void _performSearch() {
    _searchKeyword = _searchController.text.trim();
    setState(() {
      _isSearching = true;
    });
    getBookList(true).then((_) {
      setState(() {
        _isSearching = false;
      });
      _refreshController.refreshCompleted();
    });
  }

  // 清除搜索
  void _clearSearch() {
    _searchController.clear();
    _searchKeyword = '';
    _selectedLocation = '';
    setState(() {});
    getBookList(true).then((_) {
      _refreshController.refreshCompleted();
    });
  }

  // 选择地点
  void _selectLocation(String locationCode) {
    setState(() {
      _selectedLocation = locationCode;
    });
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(S.of(context).library, style: TextStyle(fontSize: 16.px)),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          // 清除搜索按钮
          if (_searchKeyword.isNotEmpty || _selectedLocation.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: primaryColor),
              onPressed: _clearSearch,
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 搜索区域
            _buildSearchSection(),

            // 图书列表
            Expanded(
              child: SmartRefreshWidget(
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: () {
                  getBookList(true).then((value) {
                    _refreshController.refreshCompleted();
                  });
                },
                onLoading: () {
                  getBookList(false);
                },
                controller: _refreshController,
                child: Padding(
                  padding: EdgeInsets.all(10.px),
                  child:
                      _isSearching
                          ? Center(child: CircularProgressIndicator())
                          : libraryListView(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建搜索区域
  Widget _buildSearchSection() {
    // 地点选项
    final List<Map<String, String>> _locationOptions = [
      {'code': '', 'name': S.of(context).library_location_all},
      {'code': '0', 'name': S.of(context).library_location_0},
      {'code': '1', 'name': S.of(context).library_location_1},
      {'code': '2', 'name': S.of(context).library_location_2},
      {'code': '3', 'name': S.of(context).library_location_3},
    ];
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.px),
      child: Column(
        children: [
          // 搜索框
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38.px,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8.px),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: S.of(context).library_search,
                      hintStyle: TextStyle(
                        fontSize: 12.px,
                        color: Colors.grey.shade500,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade500,
                        size: 18.px,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.px,
                        vertical: 8.px,
                      ),
                    ),
                    onSubmitted: (value) => _performSearch(),
                  ),
                ),
              ),
              SizedBox(width: 8.px),
              // 搜索按钮
              Container(
                height: 38.px,
                width: 38.px,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8.px),
                ),
                child: IconButton(
                  icon: Icon(Icons.search, color: Colors.white, size: 18.px),
                  onPressed: _performSearch,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.px),

          // 地点筛选
          Row(
            children: [
              Text(
                S.of(context).library_location,
                style: TextStyle(
                  fontSize: 12.px,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(width: 8.px),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        _locationOptions.map((location) {
                          bool isSelected =
                              _selectedLocation == location['code'];
                          return Padding(
                            padding: EdgeInsets.only(right: 6.px),
                            child: GestureDetector(
                              onTap: () => _selectLocation(location['code']!),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.px,
                                  vertical: 4.px,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? primaryColor
                                          : backgroundColor,
                                  borderRadius: BorderRadius.circular(4.px),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? primaryColor
                                            : Colors.grey.shade300,
                                  ),
                                ),
                                child: Text(
                                  location['name']!,
                                  style: TextStyle(
                                    fontSize: 12.px,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget libraryListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _list.length,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        final int count = _list.length;
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
        return _list.isNotEmpty
            ? AnimatedBuilder(
              animation: animationController!,
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                      0.0,
                      50.px * (1.0 - animation.value),
                      0.0,
                    ),
                    child: BookCardWidget(
                      bookData: _list[index],
                      onTap: () {
                        // 跳转到图书详情页
                        RouteUtils.push(
                          context,
                          LibraryDetailPage(
                            noticeId: _list[index].id.toString(),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            )
            : EmptyView();
      },
    );
  }
}
