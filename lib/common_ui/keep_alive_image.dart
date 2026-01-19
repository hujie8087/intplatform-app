import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class KeepAliveImage extends StatefulWidget {
  final String imageUrl;
  final String cacheKey;

  const KeepAliveImage({
    Key? key,
    required this.imageUrl,
    required this.cacheKey,
  }) : super(key: key);

  @override
  State<KeepAliveImage> createState() => _KeepAliveImageState();
}

class _KeepAliveImageState extends State<KeepAliveImage>
    with AutomaticKeepAliveClientMixin {
  // 核心：重写 wantKeepAlive 返回 true
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用 super.build
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      cacheKey: widget.cacheKey,
      fadeInDuration: Duration.zero, // 保持你原有的设置
      fadeOutDuration: Duration.zero,
      // 优化：指定内存缓存大小，防止大图占满内存导致强制回收
      // memCacheWidth: 1000,
      imageBuilder:
          (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
      placeholder:
          (context, url) => Container(
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          ),
      errorWidget:
          (context, url, error) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.error, color: Colors.grey),
          ),
    );
  }
}
