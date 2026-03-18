import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/guide_view_model.dart';
import 'package:logistics_app/pages/guide/guide_view_page.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class FacilityDetailPage extends StatefulWidget {
  final int id;
  const FacilityDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _FacilityDetailPageState createState() => _FacilityDetailPageState();
}

class _FacilityDetailPageState extends State<FacilityDetailPage> {
  GuideViewModel? guideDetail;
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    DataUtils.getDetailById(
      APIs.guideUrl + '/' + widget.id.toString(),
      success: (data) {
        setState(() {
          guideDetail = GuideViewModel.fromJson(data['data']);
          if (guideDetail?.img != null && guideDetail!.img!.isNotEmpty) {
            images = guideDetail!.img!.split(',');
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          guideDetail?.title ?? '',
          style: TextStyle(fontSize: 16.px),
        ),
        backgroundColor: Colors.transparent,
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
        child: SafeArea(
          child:
              guideDetail == null
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16.px),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Images Swiper
                              if (images.isNotEmpty)
                                Container(
                                  height: 250.px,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.px),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.px),
                                    child: Swiper(
                                      itemCount: images.length,
                                      autoplay: images.length > 1,
                                      pagination: SwiperPagination(
                                        builder: DotSwiperPaginationBuilder(
                                          activeColor: Colors.white,
                                          color: Colors.white.withOpacity(0.5),
                                          size: 8.px,
                                          activeSize: 10.px,
                                        ),
                                      ),
                                      itemBuilder: (context, index) {
                                        return CachedNetworkImage(
                                          imageUrl:
                                              APIs.imagePrefix + images[index],
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  Icon(Icons.error),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              if (images.isNotEmpty) SizedBox(height: 20.px),

                              // Title
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
                                    guideDetail?.title ?? '',
                                    style: TextStyle(
                                      fontSize: 16.px,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.px),

                              // Location
                              if (guideDetail?.file != null &&
                                  guideDetail!.file!.isNotEmpty)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 18.px,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 4.px),
                                    Expanded(
                                      child: Text(
                                        guideDetail!.file!,
                                        style: TextStyle(
                                          fontSize: 12.px,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(height: 12.px),

                              // Content
                              Html(
                                data: guideDetail?.content ?? '',
                                style: {
                                  'body': Style(
                                    fontSize: FontSize(12.px),
                                    color: Colors.black87,
                                    lineHeight: LineHeight(1.6),
                                    padding: HtmlPaddings.zero,
                                  ),
                                  'img': Style(
                                    width: Width(100, Unit.percent),
                                    height: Height.auto(),
                                  ),
                                },
                                extensions: [
                                  TagExtension(
                                    tagsToExtend: {"img"},
                                    builder: (context) {
                                      final attributes = context.attributes;
                                      final imageUrl = attributes["src"] ?? "";
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context.buildContext!,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      ImagePreviewScreen(
                                                        imageUrl: imageUrl,
                                                      ),
                                            ),
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  const Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
