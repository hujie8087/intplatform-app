import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class CustomMaterialControls extends StatefulWidget {
  const CustomMaterialControls(
      {Key? key,
      required this.showBarrageWall,
      this.resetBarrageWall,
      this.setBarrageWallUpdateChannel})
      : super(key: key);
  final Function showBarrageWall;
  final resetBarrageWall;
  final setBarrageWallUpdateChannel;
  @override
  _CustomMaterialControlsState createState() => _CustomMaterialControlsState();
}

class _CustomMaterialControlsState extends State<CustomMaterialControls> {
  bool _isEnabled = true;
  bool _isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // 返回按钮
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // 判断controller是不是全屏
                  final controller = ChewieController.of(context);
                  if (controller.isFullScreen) {
                    widget.resetBarrageWall();
                    print("controller.isFullScreen${controller.isFullScreen}");
                  }
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // 播放按钮和暂停按钮合并成一个图标
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final controller = ChewieController.of(context);
                    if (controller.isPlaying) {
                      controller.pause();
                      setState(() {
                        _isPlaying = false;
                      });
                    } else {
                      controller.play();
                      setState(() {
                        _isPlaying = true;
                      });
                    }
                  },
                ),
                // 视频进度带数字显示
                Expanded(
                  child: VideoProgressIndicator(
                    ChewieController.of(context).videoPlayerController!,
                    allowScrubbing: true,
                    padding: EdgeInsets.only(right: 5),
                    colors: VideoProgressColors(
                      playedColor: Colors.red,
                      bufferedColor: Colors.white,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                // 全屏按钮
                IconButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                  ),
                  icon: Icon(Icons.fullscreen, color: Colors.white),
                  onPressed: () {
                    final controller = ChewieController.of(context);
                    if (controller != null) {
                      controller.enterFullScreen();
                      widget.resetBarrageWall();
                    }
                  },
                ),
                // 弹幕显示按钮
                IconButton(
                  icon: Icon(
                      _isEnabled
                          ? Icons.closed_caption
                          : Icons.closed_caption_disabled,
                      color: Colors.white),
                  onPressed: () {
                    final controller = ChewieController.of(context);
                    if (controller != null) {
                      // controller.toggleSubtitle();
                      widget.showBarrageWall();
                      setState(() {
                        _isEnabled = _isEnabled ? false : true;
                      });
                    }
                  },
                ),
                // 弹幕更新按钮
                // IconButton(
                //   icon: Icon(Icons.update, color: Colors.white),
                //   onPressed: () {
                //     widget.setBarrageWallUpdateChannel();
                //   },
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
