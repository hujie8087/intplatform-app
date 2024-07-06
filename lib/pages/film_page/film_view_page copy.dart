import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:video_player/video_player.dart';

class FilmViewPage extends StatefulWidget {
  const FilmViewPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _FilmViewPageState();
  }
}

class Danmaku {
  final String text;
  final Duration startTime;

  Danmaku(this.text, this.startTime);
}

class _FilmViewPageState extends State<FilmViewPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  int? bufferDelay;
  // List<String> _danmakuList = [
  //   "Hello!",
  //   "This is a danmaku!",
  //   "Flutter is awesome!"
  // ];
  final List<Danmaku> _danmakuList = [
    Danmaku("Hello, World!", Duration(seconds: 2)),
    Danmaku("Flutter is awesome!", Duration(seconds: 5)),
    Danmaku("Welcome to the video!", Duration(seconds: 8)),
    Danmaku("Enjoy the video!", Duration(seconds: 10)),
    Danmaku("This is a sample text", Duration(seconds: 12)),
  ];
  final StreamController<Danmaku?> _danmakuStreamController =
      StreamController<Danmaku?>();

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    _danmakuStreamController.close();
    super.dispose();
  }

  List<String> srcs = [
    "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];

  Future<void> initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(srcs[currPlayIndex]));
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _createChewieController();
    _videoPlayerController.addListener(() {
      final currentPosition = _videoPlayerController.value.position;
      for (var danmaku in _danmakuList) {
        if (currentPosition.inMilliseconds >=
                danmaku.startTime.inMilliseconds &&
            currentPosition.inMilliseconds <
                danmaku.startTime.inMilliseconds + 500) {
          _danmakuStreamController.add(danmaku);
        }
      }
    });
    setState(() {});
  }

  void _createChewieController() {
    // final subtitles = [
    //     Subtitle(
    //       index: 0,
    //       start: Duration.zero,
    //       end: const Duration(seconds: 10),
    //       text: 'Hello from subtitles',
    //     ),
    //     Subtitle(
    //       index: 0,
    //       start: const Duration(seconds: 10),
    //       end: const Duration(seconds: 20),
    //       text: 'Whats up? :)',
    //     ),
    //   ];
    final subtitles = [
      Subtitle(
        index: 0,
        start: Duration.zero,
        end: const Duration(seconds: 10),
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Hello',
              style: TextStyle(color: Colors.red, fontSize: 22),
            ),
            TextSpan(
              text: ' from ',
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
            TextSpan(
              text: 'subtitles',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            )
          ],
        ),
      ),
      Subtitle(
        index: 0,
        start: const Duration(seconds: 10),
        end: const Duration(seconds: 20),
        // text: 'Whats up? :)',
        text: const TextSpan(
          text: 'Whats up? :)',
          style: TextStyle(
              color: Colors.amber, fontSize: 22, fontStyle: FontStyle.italic),
        ),
      ),
    ];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: 16 / 9,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,

      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: toggleVideo,
            iconData: Icons.live_tv_sharp,
            title: 'Toggle Video Src',
          ),
        ];
      },
      subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),

      hideControlsTimer: const Duration(seconds: 1),

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await _videoPlayerController.pause();
    currPlayIndex += 1;
    if (currPlayIndex >= srcs.length) {
      currPlayIndex = 0;
    }
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          // 设置透明背景
          backgroundColor: filmBackgroundColor,
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 220,
                  child: _chewieController != null &&
                          _chewieController!
                              .videoPlayerController.value.isInitialized
                      ? Stack(children: [
                          Chewie(
                            controller: _chewieController!,
                          ),
                          StreamBuilder<Danmaku?>(
                            stream: _danmakuStreamController.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                return DanmakuWidget(danmaku: snapshot.data!);
                              }
                              return Container();
                            },
                          ),
                          Positioned(
                            top: 5,
                            left: 5,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ])
                      : Center(
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: primaryColor,
                              ),
                              SizedBox(height: 20),
                              Text(
                                '加载中',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '流浪地球',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '2021/中国/科幻/冒险',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      // 横线
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        height: 1,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      GridWithAutoHeight(
                          currPlayIndex: currPlayIndex,
                          callBack: (index) => {
                                print(index),
                                currPlayIndex = index,
                                initializePlayer()
                              }),
                      // 横线
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        height: 1,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      Row(
                        children: [
                          // 一个有边框模块
                          Container(
                            width: 5,
                            height: 20,
                            color: secondaryColor,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '简介',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '简介：《流浪地球》是由郭帆执导，屈楚萧、吴京、李光洁、赵今麦、吴孟达、陈若轩、李九霄、刘佩琦、杨祐宁、张翰 、王俊凯、韩童生 、刘烨、王千源、王耀庆、王劲松、王晓晨',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                )),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: Row(
                    children: [
                      // 一个输入框
                      Expanded(
                        child: Container(
                          height: 40,
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.edit,
                                size: 20,
                              ),
                              hintText: '参与一起讨论',
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide.none),
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                            onChanged: (value) {
                              bufferDelay = int.tryParse(value);
                            },
                          ),
                        ),
                      ),
                      // 一个带图标的收藏按钮，上面图标下面文字
                      IconButton(
                        icon: Icon(Icons.star_border),
                        onPressed: () {},
                        tooltip: '收藏',
                        // 文字颜色
                        color: Colors.white,
                      ),
                      // 一个带图标的下载按钮，上面图标下面文字
                      IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () {},
                        tooltip: '下载',
                        // 文字颜色
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class GridWithAutoHeight extends StatelessWidget {
  const GridWithAutoHeight({Key? key, this.currPlayIndex, this.callBack})
      : super(key: key);

  final int? currPlayIndex;
  final callBack;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (9 * 5)) / 10;
        return Wrap(
          spacing: 5.0,
          runSpacing: 5.0,
          children: List.generate(3, (index) {
            return InkWell(
              onTap: () {
                callBack(index);
              },
              child: Ink(
                child: Container(
                  width: itemWidth,
                  height: itemWidth,
                  decoration: BoxDecoration(
                    color: currPlayIndex == index
                        ? secondaryColor
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// 弹幕组件
class DanmakuWidget extends StatefulWidget {
  final Danmaku danmaku;

  DanmakuWidget({required this.danmaku});

  @override
  _DanmakuWidgetState createState() => _DanmakuWidgetState();
}

class _DanmakuWidgetState extends State<DanmakuWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5), // 5 seconds for the animation duration
      vsync: this,
    )..forward();

    _animation = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Start just off the right side
      end: Offset(-1.0, 0.0), // End just off the left side
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        margin: EdgeInsets.only(top: 50.0),
        child: Text(
          widget.danmaku.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            backgroundColor: Colors.black54,
          ),
        ),
      ),
    );
  }
}
