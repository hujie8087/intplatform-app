import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barrage/flutter_barrage.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:video_player/video_player.dart';

class FilmViewPage extends StatefulWidget {
  FilmViewPage({Key? key}) : super(key: key);

  @override
  _FilmViewPageState createState() => _FilmViewPageState();
}

class _FilmViewPageState extends State<FilmViewPage>
    with RouteAware, WidgetsBindingObserver {
  late ValueNotifier<BarrageValue> timelineNotifier;
  late VideoPlayerController videoPlayerController;
  late BarrageWallController barrageWallController;
  ChewieController? chewieController;
  late TextEditingController textEditingController;
  int? bufferDelay;
  // late FocusNode focus;
  int currPlayIndex = 0;
  bool barrageWallEnabled = true;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  List<String> srcs = [
    "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];

  Future<void> initializePlayer() async {
    textEditingController = TextEditingController();
    timelineNotifier = ValueNotifier(BarrageValue());
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(srcs[currPlayIndex]))
          ..addListener(() => timelineNotifier.value = timelineNotifier.value
              .copyWith(
                  timeline: videoPlayerController.value.position.inMilliseconds,
                  isPlaying: videoPlayerController.value.isPlaying));
    barrageWallController =
        BarrageWallController(timelineNotifier: timelineNotifier);
    await Future.wait([
      videoPlayerController.initialize(),
    ]);
    _createChewieController(bullets);
    setState(() {});
  }

  // 重置弹幕
  void resetBarrageWall() {
    barrageWallController.disable();
    barrageWallController.clear();
    barrageWallController.enable();
  }

  List<Bullet> bullets = <Bullet>[
    Bullet(
        child: Text(
          '我是第一条弹幕',
          style: TextStyle(color: Colors.red),
        ),
        showTime: 1000),
    Bullet(
        child: Text(
          '我是第二条弹幕',
          style: TextStyle(color: Colors.green),
        ),
        showTime: 2000),
    Bullet(
        child: Text(
          '我是第三条弹幕',
          style: TextStyle(color: Colors.blue),
        ),
        showTime: 4000),
    Bullet(
        child: Text(
          '我是第四条弹幕',
          style: TextStyle(color: Colors.yellow),
        ),
        showTime: 8000),
    Bullet(
        child: Text(
          '我是第五条弹幕',
          style: TextStyle(color: Colors.deepOrange),
        ),
        showTime: 12000),
  ];

  void _createChewieController(bullets) {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      hideControlsTimer: const Duration(seconds: 1),
      overlay: LayoutBuilder(builder: (context, constraints) {
        print(constraints.maxHeight * 0.8);
        return BarrageWall(
          width: constraints.maxWidth,
          height: constraints.maxHeight * 0.8,
          debug: false,
          // do not send bullets to the safe area
          safeBottomHeight: 0,
          // speed: 8,
          massiveMode: false,
          speedCorrectionInMilliseconds: 5000,
          controller: barrageWallController,
          timelineNotifier: timelineNotifier,
          bullets: bullets,
          child: new Container(),
        );
      }),
    );
    chewieController?.addListener(() {
      if (chewieController!.isFullScreen) {
        barrageWallController.clear();
        print("Entered Fullscreen");
      } else {
        barrageWallController.clear();
        print("Exited Fullscreen");
      }
    });
  }

  Future<void> switchVideo(int index) async {
    // 更新当前播放索引
    currPlayIndex = index;
    barrageWallController.clear();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(srcs[index]))
          ..addListener(() => timelineNotifier.value = timelineNotifier.value
              .copyWith(
                  timeline: videoPlayerController.value.position.inMilliseconds,
                  isPlaying: videoPlayerController.value.isPlaying));
    await Future.wait([
      videoPlayerController.initialize(),
    ]);
    _createChewieController(bullets);
    setState(() {});
  }

  @override
  void dispose() {
    timelineNotifier.dispose();
    // barrageWallController?.dispose();
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: filmBackgroundColor,
      appBar: AppBar(
        title: Text(
          '流浪地球',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        foregroundColor: Colors.white,
        backgroundColor: filmBackgroundColor,
      ),
      body: SafeArea(
        top: true,
        child: Column(children: <Widget>[
          Container(
            height: 220,
            child: chewieController != null &&
                    chewieController!.videoPlayerController.value.isInitialized
                ? Stack(children: [
                    Chewie(
                      controller: chewieController!,
                    ),
                  ])
                : Center(
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
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
                    callBack: (index) => switchVideo(index)),
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
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16, opticalSize: 10),
                        Expanded(
                            child: TextField(
                          controller: textEditingController,
                          onSubmitted: (text) {
                            barrageWallController.send([
                              new Bullet(
                                  child: Container(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                            ]);
                            textEditingController.clear();
                          },
                          decoration: InputDecoration(
                            hintText: '发个友善的弹幕见证当下',
                            hintStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                borderSide: BorderSide.none),
                          ),
                        ))
                      ],
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
        ]),
      ),
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
