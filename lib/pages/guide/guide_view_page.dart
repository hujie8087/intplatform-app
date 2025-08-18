import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/guide_view_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:photo_view/photo_view.dart';

class GuideViewPage extends StatefulWidget {
  const GuideViewPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _GuideViewPageState createState() => _GuideViewPageState();
}

class _GuideViewPageState extends State<GuideViewPage> {
  GuideViewModel? guideDetail;

  void _fetchData() async {
    DataUtils.getDetailById(
      APIs.guideUrl + '/' + widget.id.toString(),
      success: (data) {
        setState(() {
          guideDetail = GuideViewModel.fromJson(data['data']);
          print(guideDetail?.content);
        });
      },
    );
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          guideDetail?.title ?? '',
          style: TextStyle(fontSize: 16.px),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/guide_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.px),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guideDetail?.title ?? '',
                      style: TextStyle(
                          fontSize: 18.px, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.px,
                    ),
                    Text(guideDetail?.createTime ?? '',
                        style: TextStyle(
                          fontSize: 12.px,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ),
              // 修改 Expanded 为 Flexible
              Flexible(
                child: SingleChildScrollView(
                    controller: ScrollController(
                      keepScrollOffset: true,
                      initialScrollOffset: 0,
                    ),
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    child: Html(
                      data: guideDetail?.content ?? '',
                      style: {
                        'body': Style(
                          fontSize: FontSize(12.px),
                          padding: HtmlPaddings.zero,
                        ),
                      },
                      shrinkWrap: false, // **确保 Html 可以滚动**
                      extensions: [
                        TagExtension(
                          tagsToExtend: {"img"},
                          builder: (context) {
                            final attributes = context.attributes;
                            final imageUrl = attributes["src"] ?? "";
                            print(imageUrl);
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context.buildContext!,
                                    MaterialPageRoute(
                                      builder: (context) => ImagePreviewScreen(
                                          imageUrl: imageUrl),
                                    ),
                                  );
                                },
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error,
                                          color: Colors.red),
                                ));
                          },
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
        ),
      ),
    );
  }
}
