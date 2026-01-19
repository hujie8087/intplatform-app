import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:logistics_app/common_ui/empty_view.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/data/tool_utils.dart';
import 'package:logistics_app/http/model/base_list_model.dart';
import 'package:logistics_app/http/model/dict_model.dart';
import 'package:logistics_app/http/model/guide_view_model.dart';
import 'package:logistics_app/http/model/rows_model.dart';
import 'package:logistics_app/pages/guide/facility_detail_page.dart';
import 'package:logistics_app/pages/lost_found_page/lost_found_list_page.dart';
import 'package:logistics_app/route/route_utils.dart';

import 'package:logistics_app/utils/screen_adapter_helper.dart';

class FacilityListPage extends StatefulWidget {
  const FacilityListPage({Key? key}) : super(key: key);
  @override
  _FacilityListPage createState() => _FacilityListPage();
}

class _FacilityListPage extends State<FacilityListPage> {
  List<GuideViewModel> guideList = [];
  List<GuideViewModel> guideCheckedList = [];
  List<DictModel> facilityTypeOptions = [];
  String? _selectedTypeCode; // Currently selected category code

  @override
  void initState() {
    super.initState();
    _fetchFacilityTypes();
  }

  // 1. Fetch Facility Types (Tabs)
  Future<void> _fetchFacilityTypes() async {
    DataUtils.getDictDataList(
      'facility_type_options',
      success: (data) {
        final list =
            BaseListModel<DictModel>.fromJson(
              data,
              (json) => DictModel.fromJson(json),
            ).data ??
            [];
        setState(() {
          facilityTypeOptions = list;
          // Default select the first one if available, or fetch all (null)
          if (facilityTypeOptions.isNotEmpty) {
            _selectedTypeCode = facilityTypeOptions.first.dictValue;
          }
          getGuideList();
        });
      },
    );
  }

  // 2. Fetch Facility List
  void getGuideList() async {
    Map<String, dynamic> params = {"status": 0, "pageNum": 1, "pageSize": 100};
    ToolUtils.getGuideList(
      params,
      success: (data) {
        setState(() {
          guideList =
              RowsModel.fromJson(
                data,
                (json) => GuideViewModel.fromJson(json),
              ).rows ??
              [];
          guideCheckedList =
              guideList
                  .where(
                    (element) => element.typeId.toString() == _selectedTypeCode,
                  )
                  .toList();
        });
      },
    );
  }

  void _onTabSelected(String? code) {
    if (_selectedTypeCode == code) return;
    setState(() {
      _selectedTypeCode = code;
      guideCheckedList =
          guideList
              .where(
                (element) => element.typeId.toString() == _selectedTypeCode,
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(S.of(context).facility, style: TextStyle(fontSize: 16.px)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.px),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Color(0xFF00BFFF).withOpacity(0.29),
              Color(0xFF00BFFF).withOpacity(0),
            ],
          ),
        ),
        // 4. 注意：因为内容延伸到了顶部，你需要用 SafeArea 防止内容被刘海屏遮挡
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 8.px),
                child: _buildTabs(),
              ),
              Expanded(
                child:
                    guideCheckedList.isNotEmpty
                        ? ListView.builder(
                          padding: EdgeInsets.all(16.px),
                          itemCount: guideCheckedList.length,
                          itemBuilder: (context, index) {
                            return GuideViewDataView(
                              listData: guideCheckedList[index],
                              callBack: () {
                                RouteUtils.push(
                                  context,
                                  FacilityDetailPage(
                                    id: guideCheckedList[index].id!,
                                  ),
                                );
                              },
                            );
                          },
                        )
                        : EmptyView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    if (facilityTypeOptions.isEmpty) return SizedBox.shrink();

    return Container(
      height: 30.px,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: facilityTypeOptions.length,
        itemBuilder: (context, index) {
          final item = facilityTypeOptions[index];
          final isSelected = _selectedTypeCode == item.dictValue;
          return GestureDetector(
            onTap: () => _onTabSelected(item.dictValue),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic, // More vivid curve
              padding: EdgeInsets.symmetric(
                horizontal: 10.px, // Animate padding too
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF1E88E5) : Colors.transparent,
                borderRadius: BorderRadius.circular(20.px),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Color(0xFF1E88E5).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ]
                        : [],
              ),
              child: AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 14.px, // Subtle scale
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                child: Text(item.dictLabel ?? ''),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GuideViewDataView extends StatelessWidget {
  const GuideViewDataView({Key? key, required this.listData, this.callBack})
    : super(key: key);

  final GuideViewModel listData;
  final VoidCallback? callBack;
  String fixHtmlImageUrls(String html) {
    final imgRegex = RegExp(r'src="([^"]+)"');
    return html.replaceAllMapped(imgRegex, (match) {
      final rawUrl = match.group(1)!;
      final fixedUrl = Uri.encodeFull(rawUrl);
      return 'src="$fixedUrl"';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Parse images
    List<String> images = [];
    if (listData.img != null && listData.img!.isNotEmpty) {
      images = listData.img!.split(',');
      print(images);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.px),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.px),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: callBack,
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.px),
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: 16.px),
              padding: EdgeInsets.only(left: 16.px, right: 16.px, top: 10.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        bottom: 0,
                        left: -5.0,
                        right: -5.0,

                        child: Container(
                          height: 12.px,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF1A7AFF).withOpacity(0),
                                Color(0xFF1A7AFF).withOpacity(0.5),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        listData.title ?? '',
                        style: TextStyle(
                          fontSize: 16.px,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.px),

                  // Content
                  HtmlLineLimit(
                    htmlContent: listData.content ?? '',
                    maxLines: 2,
                    color: Colors.black87,
                  ),
                  SizedBox(height: 6.px),

                  // Images Swiper
                  if (images.isNotEmpty)
                    Container(
                      height: 180.px,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.px),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                          width: 1.px,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.px),
                        child: Swiper(
                          itemCount: images.length,
                          autoplay: images.length > 1,
                          pagination: SwiperPagination(
                            builder: DotSwiperPaginationBuilder(
                              activeColor: Colors.white,
                              color: Colors.white.withOpacity(0.5),
                              size: 6.px,
                              activeSize: 8.px,
                            ),
                          ),
                          itemBuilder: (context, index) {
                            return Image.network(
                              APIs.imagePrefix + images[index],
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (ctx, err, stack) => Container(
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    ),
                                  ),
                            );
                          },
                        ),
                      ),
                    ),

                  if (images.isNotEmpty) SizedBox(height: 12.px),

                  // Location
                  if (listData.file != null && listData.file!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16.px,
                          color: Colors.black,
                        ),
                        SizedBox(width: 4.px),
                        Expanded(
                          child: Text(
                            listData.file!,
                            style: TextStyle(
                              fontSize: 12.px,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
