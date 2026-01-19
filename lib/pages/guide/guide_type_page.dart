import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/guide_type_view_model.dart';
import 'package:logistics_app/pages/guide/components/iframe_view_widget.dart';
import 'package:logistics_app/pages/news/monthly_page/monthly_detail_page.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class FileModel {
  String? fileName;
  String? fileUrl;
  FileModel({this.fileName, this.fileUrl});
}

class GuideTypePage extends StatefulWidget {
  const GuideTypePage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _GuideTypePageState createState() => _GuideTypePageState();
}

class _GuideTypePageState extends State<GuideTypePage> {
  GuideTypeViewModel? guideTypeDetail;
  List<FileModel> fileList = [];
  bool _isLoading = true;

  Future<void> openWordFile(String fileUrl) async {
    try {
      // 提取文件名
      String fileName = path.basename(
        fileUrl,
      ); // 获取 "IT每日一题2024.1.16-2025.2.15.docx"

      // 获取本地存储目录
      Directory tempDir = await getTemporaryDirectory();
      Uri filePath = Uri.parse('${tempDir.path}/$fileName'); // 拼接完整路径

      // 检查文件是否已经存在
      File file = File(filePath.path);
      if (!await file.exists()) {
        print("📥 文件不存在，开始下载...");
        Dio dio = Dio();
        await dio.download(
          fileUrl,
          filePath,
          options: Options(receiveTimeout: const Duration(seconds: 30)), // 设置超时
        );
        print("✅ 文件下载完成: $filePath");
      } else {
        print("📂 文件已存在: $filePath");
      }

      // 打开文件
      final result = await launchUrl(filePath);
      print("📖 打开文件结果: ${result.toString()}");
    } catch (e) {
      print("❌ 打开文件失败: $e");
    }
  }

  void _fetchData() async {
    DataUtils.getDetailById(
      APIs.guideTypeUrl + '/' + widget.id.toString(),
      success: (data) {
        guideTypeDetail = GuideTypeViewModel.fromJson(data['data']);
        setState(() {
          _isLoading = false;
          if (guideTypeDetail?.file != null) {
            fileList =
                guideTypeDetail?.file
                    ?.split(',')
                    .map(
                      (e) => FileModel(fileName: path.basename(e), fileUrl: e),
                    )
                    .toList() ??
                [];
          }
        });
      },
      fail: (code, msg) {
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  // 构建附件列表项
  Widget _buildFileItem(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.px),
      child: InkWell(
        onTap: () {
          if (fileList[index].fileUrl?.endsWith('.pdf') ?? false) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => MonthlyDetailPage(
                      pdfUrl:
                          fileList[index].fileUrl != null
                              ? APIs.imagePrefix + fileList[index].fileUrl!
                              : '',
                      title: fileList[index].fileName ?? '',
                    ),
              ),
            );
          } else {
            openWordFile(APIs.imagePrefix + fileList[index].fileUrl!);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 8.px),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6.px),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(
                fileList[index].fileUrl?.endsWith('.pdf') ?? false
                    ? Icons.picture_as_pdf
                    : Icons.description,
                color:
                    fileList[index].fileUrl?.endsWith('.pdf') ?? false
                        ? Colors.red
                        : Colors.blue,
                size: 20.px,
              ),
              SizedBox(width: 8.px),
              Expanded(
                child: Text(
                  fileList[index].fileName ?? '',
                  style: TextStyle(fontSize: 14.px),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.px,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          guideTypeDetail?.title ?? '',
          style: TextStyle(fontSize: 16.px),
        ),
      ),
      body: SafeArea(
        child:
            guideTypeDetail?.url != null
                ? IframeViewWidget(url: guideTypeDetail?.url ?? '')
                : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/guide_bg.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child:
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 标题和创建时间区域
                                Container(
                                  padding: EdgeInsets.all(16.px),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        guideTypeDetail?.title ?? '',
                                        style: TextStyle(
                                          fontSize: 18.px,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10.px),
                                      Text(
                                        guideTypeDetail?.createTime ?? '',
                                        style: TextStyle(
                                          fontSize: 12.px,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 内容区域
                                Container(
                                  padding: EdgeInsets.all(16.px),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // HTML内容
                                      if (guideTypeDetail?.content != null)
                                        Container(
                                          width: double.infinity,
                                          child: Html(
                                            data:
                                                guideTypeDetail
                                                            ?.approvalStatus ==
                                                        4
                                                    ? guideTypeDetail?.content
                                                    : S
                                                        .of(context)
                                                        .contentUpdating,
                                            style: {
                                              'body': Style(
                                                fontSize: FontSize(14.px),
                                                padding: HtmlPaddings.zero,
                                                margin: Margins.zero,
                                              ),
                                              'p': Style(
                                                margin: Margins.only(
                                                  bottom: 8.px,
                                                ),
                                              ),
                                            },
                                            shrinkWrap: true,
                                            extensions: [
                                              TagExtension(
                                                tagsToExtend: {"img"},
                                                builder: (context) {
                                                  final attributes =
                                                      context.attributes;
                                                  final imageUrl =
                                                      attributes["src"] ?? "";
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context.buildContext!,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  ImagePreviewScreen(
                                                                    imageUrl:
                                                                        imageUrl,
                                                                  ),
                                                        ),
                                                      );
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl: imageUrl,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (
                                                            context,
                                                            url,
                                                          ) => Container(
                                                            height: 200.px,
                                                            child: const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                          ),
                                                      errorWidget:
                                                          (
                                                            context,
                                                            url,
                                                            error,
                                                          ) => Container(
                                                            height: 200.px,
                                                            child: const Center(
                                                              child: Icon(
                                                                Icons.error,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),

                                      SizedBox(height: 20.px),

                                      // 附件区域
                                      if (guideTypeDetail?.approvalStatus ==
                                              4 &&
                                          (guideTypeDetail?.file != null ||
                                              guideTypeDetail?.file != ''))
                                        Container(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                S.of(context).attachment,
                                                style: TextStyle(
                                                  fontSize: 16.px,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 12.px),
                                              Container(
                                                constraints: BoxConstraints(
                                                  maxHeight:
                                                      fileList.length > 6
                                                          ? 200.px
                                                          : double.infinity,
                                                ),
                                                child:
                                                    fileList.length > 6
                                                        ? ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              fileList.length,
                                                          itemBuilder: (
                                                            context,
                                                            index,
                                                          ) {
                                                            return _buildFileItem(
                                                              index,
                                                            );
                                                          },
                                                        )
                                                        : Column(
                                                          children:
                                                              fileList
                                                                  .asMap()
                                                                  .entries
                                                                  .map(
                                                                    (
                                                                      entry,
                                                                    ) => _buildFileItem(
                                                                      entry.key,
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      SizedBox(height: 20.px),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
