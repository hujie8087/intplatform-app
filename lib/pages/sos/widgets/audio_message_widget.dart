import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logistics_app/common_ui/progress_hud.dart.dart';

class AudioMessageWidget extends StatefulWidget {
  final String audioUrl; // 可以是本地文件路径或http链接
  final bool isOwnMessage;

  const AudioMessageWidget({
    Key? key,
    required this.audioUrl,
    required this.isOwnMessage,
  }) : super(key: key);

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    // 监听播放进度
    _audioPlayer.positionStream.listen((pos) {
      setState(() {
        _position = pos;
      });
    });
    _audioPlayer.durationStream.listen((dur) {
      setState(() {
        _duration = dur ?? Duration.zero;
      });
    });

    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
      // 自动停止时归零
      if (state.processingState == ProcessingState.completed) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _handlePlayPause() async {
    print('音频播放: ${widget.audioUrl}');
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      try {
        // 只在初次播放/切换音频时setAudioSource
        if (_audioPlayer.audioSource == null ||
            (_audioPlayer.audioSource is ProgressiveAudioSource &&
                (_audioPlayer.audioSource as ProgressiveAudioSource).uri
                        .toString() !=
                    widget.audioUrl)) {
          await _audioPlayer.setUrl(widget.audioUrl);
        }
        await _audioPlayer.play();
      } catch (e) {
        print('音频播放失败: $e');
        ProgressHUD.showError('音频播放失败: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 可加气泡样式
    return GestureDetector(
      onTap: _handlePlayPause,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin:
            widget.isOwnMessage
                ? EdgeInsets.only(left: 32)
                : EdgeInsets.only(right: 32),
        decoration: BoxDecoration(
          color: widget.isOwnMessage ? Colors.cyan[50] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isPlaying ? Icons.pause_circle : Icons.play_circle,
              color: Colors.blue,
            ),
            SizedBox(width: 8),
            _duration.inMilliseconds > 0
                ? Text(
                  "${_position.inSeconds}/${_duration.inSeconds}''",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                )
                : const SizedBox.shrink(),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_voice, size: 18, color: Colors.blueGrey[200]),
          ],
        ),
      ),
    );
  }
}
