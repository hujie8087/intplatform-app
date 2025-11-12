import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:logistics_app/common_ui/image_preview_page.dart';
import 'package:video_player/video_player.dart';

// Image Message Widget
class ImageMessageWidget extends StatefulWidget {
  final String imageUrl;
  final bool isOwnMessage;

  const ImageMessageWidget({
    Key? key,
    required this.imageUrl,
    required this.isOwnMessage,
  }) : super(key: key);

  @override
  State<ImageMessageWidget> createState() => _ImageMessageWidgetState();
}

class _ImageMessageWidgetState extends State<ImageMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _previewImage(widget.imageUrl),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            placeholder:
                (context, url) => Container(
                  width: 200,
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
            errorWidget:
                (context, url, error) => Container(
                  width: 200,
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, color: Colors.red),
                ),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  // 预览图片
  void _previewImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePreviewPage(imageUrl: imageUrl),
      ),
    );
  }
}

// Video Message Widget
class VideoMessageWidget extends StatefulWidget {
  final String videoUrl;
  final bool isOwnMessage;

  const VideoMessageWidget({
    Key? key,
    required this.videoUrl,
    required this.isOwnMessage,
  }) : super(key: key);

  @override
  State<VideoMessageWidget> createState() => _VideoMessageWidgetState();
}

class _VideoMessageWidgetState extends State<VideoMessageWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return GestureDetector(
        onTap: () => _previewVideo(widget.videoUrl),
        child: Container(
          width: 200,
          height: 150,
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _previewVideo(widget.videoUrl),
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(_controller),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                  setState(() {}); // Update UI
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 预览视频
  void _previewVideo(String videoUrl) {
    // Get.to(VideoPreviewPlayer(videoUrl: videoUrl));
  }
}
