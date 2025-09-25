import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logistics_app/http/apis.dart';
import 'package:logistics_app/http/data/data_utils.dart';
import 'package:video_player/video_player.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';
import 'package:logistics_app/http/model/notice_list_model.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:logistics_app/route/route_annotation.dart';

@AppRoute(path: 'promo_detail_page', name: '宣传片详情页')
class PromoDetailPage extends StatefulWidget {
  const PromoDetailPage({Key? key, required this.noticeId}) : super(key: key);
  final String noticeId;

  @override
  _PromoDetailPageState createState() => _PromoDetailPageState();
}

class _PromoDetailPageState extends State<PromoDetailPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  NoticeModel? _promo;
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  Future<void> getNoticeDetail() async {
    DataUtils.getDetailById(
      '/system/notice/' + widget.noticeId,
      success: (data) {
        _promo = NoticeModel.fromJson(data['data']);
        setState(() {
          if (_promo?.video != null) {
            _initializePlayer();
          }
        });
      },
      fail: (error, message) {
        ProgressHUD.showError(message);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getNoticeDetail();

    // 监听滚动以显示/隐藏AppBar标题
    _scrollController.addListener(() {
      if (_scrollController.offset >= 200 && !_showTitle) {
        setState(() => _showTitle = true);
      } else if (_scrollController.offset < 200 && _showTitle) {
        setState(() => _showTitle = false);
      }
    });
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(APIs.imageOnlinePrefix + (_promo?.video ?? '')),
      );

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        placeholder: Center(
          child: Image.network(
            APIs.imageOnlinePrefix + (_promo?.img ?? ''),
            fit: BoxFit.cover,
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 30.px),
                SizedBox(height: 8.px),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing video player: $e');
      ProgressHUD.showError('视频加载失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _promo?.noticeTitle ?? '',
          style: TextStyle(fontSize: 16.px, color: Colors.black),
        ),
      ),
      body:
          _promo == null
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.px),
                      // 标题
                      child: Column(
                        children: [
                          Text(
                            _promo?.noticeTitle ?? '',
                            style: TextStyle(
                              fontSize: 18.px,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 16.px),
                          // 信息栏
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.px,
                              horizontal: 12.px,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8.px),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16.px,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 4.px),
                                Text(
                                  _promo?.createTime ?? '',
                                  style: TextStyle(
                                    fontSize: 12.px,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(width: 16.px),
                                Icon(
                                  Icons.remove_red_eye,
                                  size: 16.px,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 4.px),
                                Text(
                                  '${_promo?.papeView ?? 0}',
                                  style: TextStyle(
                                    fontSize: 12.px,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.px),
                    // 视频播放器
                    Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            color: Colors.black,
                            child:
                                _isInitialized
                                    ? Chewie(controller: _chewieController!)
                                    : Center(
                                      child: CircularProgressIndicator(),
                                    ),
                          ),
                        ),
                        if (!_isInitialized)
                          Positioned.fill(
                            child: Image.network(
                              APIs.imageOnlinePrefix + (_promo?.img ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),

                    // 内容区域
                    SizedBox(height: 20.px),

                    // 描述内容
                    if (_promo?.noticeContent != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.px),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(16.px),
                        child: Html(
                          data: _promo?.noticeContent ?? '',
                          style: {
                            "body": Style(
                              fontSize: FontSize(14.px),
                              lineHeight: LineHeight(1.6),
                            ),
                          },
                        ),
                      ),
                  ],
                ),
              ),
    );
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _videoPlayerController.dispose();
      _chewieController?.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }
}
