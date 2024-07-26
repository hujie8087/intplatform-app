import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget(
      {super.key,
      required this.initialIndex,
      required this.items,
      this.isBarVisible});
  // 初始图片位置
  final int initialIndex;
  // 图片列表
  final List<AssetEntity> items;
  // 是否显示bar
  final bool? isBarVisible;

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  Widget _buildImageView() {
    return ExtendedImageGesturePageView.builder(
        controller: ExtendedPageController(
          initialPage: widget.initialIndex,
        ),
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          final AssetEntity item = widget.items[index];
          return ExtendedImage(
              image: AssetEntityImageProvider(item, isOriginal: true),
              fit: BoxFit.contain,
              mode: ExtendedImageMode.gesture,
              initGestureConfigHandler: (ExtendedImageState state) {
                return GestureConfig(
                  minScale: 0.9,
                  maxScale: 3.0,
                  animationMinScale: 0.7,
                  animationMaxScale: 3.5,
                  speed: 1.0,
                  inertialSpeed: 100.0,
                  initialScale: 1.0,
                  inPageView: true,
                  initialAlignment: InitialAlignment.center,
                );
              });
        });
  }

  // 主视图
  Widget _mainView() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, //不允许穿透
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        body: _buildImageView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }
}
