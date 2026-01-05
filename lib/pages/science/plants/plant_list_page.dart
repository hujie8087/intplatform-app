import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/plant_model.dart';
import 'package:logistics_app/pages/science/plants/plant_detail_page.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/utils/sp_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PlantListPage extends StatefulWidget {
  const PlantListPage({Key? key}) : super(key: key);

  @override
  State<PlantListPage> createState() => _PlantListPageState();
}

class _PlantListPageState extends State<PlantListPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late RefreshController _refreshController;
  List<PlantTreeModel> _list = [];
  int _selectedIndex = 0;
  bool _isLoading = false;

  final ScrollController _scrollController = ScrollController();
  bool _isTabClicked = false;
  List<double> _groupOffsets = [];
  String _language = '0';

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
    getPlantTreeList();
    _scrollController.addListener(_onScroll);
  }

  Future<void> getPlantTreeList() async {
    var result = await SpUtils.getString('locale');
    setState(() {
      _isLoading = true;
    });
    if (result == 'id') {
      _language = '1';
    } else {
      _language = '0';
    }
    DataUtils.getAnimalPlantTree(
      {'type': '1', 'language': _language},
      success: (data) {
        var plantList = data['data'] as List;
        List<PlantTreeModel> rows =
            plantList.map((i) => PlantTreeModel.fromJson(i)).toList();
        setState(() {
          _list = rows;
          if (_list.isNotEmpty) {
            _selectedIndex = 0;
          }
          _isLoading = false;
        });
      },
    );
  }

  void _onScroll() {
    if (_isTabClicked) return;
    if (_groupOffsets.isEmpty) return;

    double offset = _scrollController.offset;

    // Find the category corresponding to the current offset
    for (int i = 0; i < _groupOffsets.length; i++) {
      double start = _groupOffsets[i];
      double end =
          (i < _groupOffsets.length - 1)
              ? _groupOffsets[i + 1]
              : double.infinity;

      // Add a small buffer (e.g., 20) to switch selection slightly earlier
      if (offset >= start - 20 && offset < end - 20) {
        if (_selectedIndex != i) {
          setState(() {
            _selectedIndex = i;
          });
        }
        break;
      }
    }
  }

  void _scrollToIndex(int index, double contentWidth) {
    if (index < 0 || index >= _list.length) return;

    _calculateOffsets(contentWidth);
    if (_groupOffsets.isEmpty) return;

    _isTabClicked = true;
    setState(() {
      _selectedIndex = index;
    });

    // Ensure we don't scroll past the max extent
    double targetOffset = _groupOffsets[index];
    if (targetOffset > _scrollController.position.maxScrollExtent) {
      targetOffset = _scrollController.position.maxScrollExtent;
    }

    _scrollController
        .animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
        .then((_) {
          _isTabClicked = false;
        });
  }

  // Calculate the vertical offset position for each category
  void _calculateOffsets(double contentWidth) {
    _groupOffsets.clear();
    double currentOffset = 0;

    // Grid calculations
    double paddingH = 24.px; // 12.px left + 12.px right
    double crossSpacing = 12.px;
    double mainSpacing = 12.px;

    double availableWidth = contentWidth - paddingH;
    if (availableWidth <= 0) availableWidth = 100; // Fallback

    double itemWidth = (availableWidth - crossSpacing) / 2;
    double itemHeight = itemWidth / 0.8; // childAspectRatio: 0.8

    for (var category in _list) {
      _groupOffsets.add(currentOffset);

      // Add Header Height (40.px)
      currentOffset += 40.px;

      // Add Grid Items Height
      var children = category.children ?? [];
      int count = children.length;
      if (count > 0) {
        int rows = (count / 2).ceil();
        currentOffset += rows * itemHeight;
        // Add spacing between rows
        if (rows > 0) {
          currentOffset += (rows - 1) * mainSpacing;
        }
        // Add bottom padding for the section
        currentOffset += mainSpacing;
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          S.of(context).science_plants,
          style: TextStyle(fontSize: 16.px, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
              child: Container(
                height: 36.px,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(4.px),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10.px),
                    Icon(
                      Icons.search,
                      size: 20.px,
                      color: const Color(0xFF999999),
                    ),
                    SizedBox(width: 8.px),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: S.of(context).science_plants_search,
                          hintStyle: TextStyle(
                            fontSize: 14.px,
                            color: const Color(0xFF999999),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(fontSize: 14.px, color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        S.of(context).search,
                        style: TextStyle(
                          fontSize: 14.px,
                          color: const Color(0xFF1890FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child:
                  _list.isEmpty
                      ? _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : EmptyView()
                      : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Sidebar
                          Container(
                            width: 100.px,
                            color: const Color(0xFFF7F8FA),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return ListView.builder(
                                  itemCount: _list.length,
                                  itemBuilder: (context, index) {
                                    return _buildSideMenuItem(index, context);
                                  },
                                );
                              },
                            ),
                          ),
                          // Right Content
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Pre-calculate offsets if possible to allow initial scroll sync if needed
                                if (_groupOffsets.isEmpty && _list.isNotEmpty) {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    _calculateOffsets(constraints.maxWidth);
                                  });
                                }
                                return Container(
                                  color: Colors.white,
                                  child: CustomScrollView(
                                    controller: _scrollController,
                                    slivers: _buildSlivers(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideMenuItem(int index, BuildContext context) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        double contentWidth = MediaQuery.of(context).size.width - 100.px;
        _scrollToIndex(index, contentWidth);
      },
      child: Container(
        height: 50.px,
        color: isSelected ? Colors.white : const Color(0xFFF7F8FA),
        child: Stack(
          children: [
            Center(
              child: Text(
                _list[index].name ?? '',
                style: TextStyle(
                  fontSize: 14.px,
                  color: isSelected ? Colors.black : const Color(0xFF666666),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                left: 0,
                top: 15.px,
                bottom: 15.px,
                child: Container(
                  width: 4.px,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE02020), // Red indicator
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(2.px),
                      bottomRight: Radius.circular(2.px),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSlivers() {
    List<Widget> slivers = [];

    for (int i = 0; i < _list.length; i++) {
      var category = _list[i];
      // Category Header
      slivers.add(
        SliverToBoxAdapter(
          child: Container(
            height: 40.px,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 12.px),
            color: Colors.white,
            child: Text(
              category.name ?? '',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.px),
            ),
          ),
        ),
      );

      // Plants Grid
      var children = category.children ?? [];
      if (children.isNotEmpty) {
        slivers.add(
          SliverPadding(
            padding: EdgeInsets.only(left: 12.px, right: 12.px, bottom: 12.px),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.px,
                crossAxisSpacing: 12.px,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                var item = children[index];
                return InkWell(
                  onTap: () {
                    print(item.fId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                PlantDetailPage(fId: item.fId.toString()),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.px),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.px),
                            child: Image.network(
                              item.picture != null
                                  ? APIs.imagePrefix + item.picture!
                                  : '',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 8.px),
                        Text(
                          item.name ?? '',
                          style: TextStyle(
                            fontSize: 14.px,
                            color: const Color(0xFF333333),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: children.length),
            ),
          ),
        );
      } else {
        // Placeholder for empty category or spacing
        slivers.add(SliverToBoxAdapter(child: SizedBox(height: 12.px)));
      }
    }
    // Add bottom padding
    slivers.add(SliverToBoxAdapter(child: SizedBox(height: 100.px)));
    return slivers;
  }
}
