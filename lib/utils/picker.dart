import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class Picker {
  // 底部弹出视图
  static Future<dynamic> showModalSheet(BuildContext context, {Widget? child}) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: child,
        );
      },
    );
  }

  // 相册
  static Future<List<AssetEntity>?> assets({
    required BuildContext context,
    List<AssetEntity>? selectedAssets,
    RequestType? requestType,
    int? maxAssets,
  }) async {
    print('maxAssets: $maxAssets');
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        requestType: requestType ?? RequestType.image,
        textDelegate: AssetPickerTextDelegate(),
        maxAssets: maxAssets ?? 6,
        selectedAssets: selectedAssets,
      ),
    );
    return result;
  }

  // 拍摄
  static Future<AssetEntity?> assetsCamera({
    required BuildContext context,
    int maxAssets = 6,
  }) async {
    final AssetEntity? result = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: const CameraPickerConfig(),
    );
    return result;
  }

  // 添加时间水印方法
  static Future<File?> assetsCameraWithWatermark({
    required BuildContext context,
  }) async {
    // 1. 调用插件拍照
    final AssetEntity? result = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: const CameraPickerConfig(),
    );

    if (result == null) return null;

    // 2. 获取原始文件
    File? originFile = await result.originFile;
    if (originFile == null) return null;

    // 3. 读取并处理图片
    final bytes = await originFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image != null) {
      // 修正图片方向 (防止水印在旋转的照片上位置错乱)
      image = img.bakeOrientation(image);

      // 图片尺寸压缩：限制最大分辨率，大幅降低手机内存和性能消耗
      const int maxSize = 1280;
      if (image.width > maxSize || image.height > maxSize) {
        if (image.width > image.height) {
          image = img.copyResize(image, width: maxSize);
        } else {
          image = img.copyResize(image, height: maxSize);
        }
      }

      // 获取当前时间
      String timestamp = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());

      // 4. 绘制时间水印 (根据图片宽度动态调整字体大小和位置)
      // 注意：这里的 x, y 是像素坐标
      img.drawString(
        image,
        timestamp,
        font: img.arial48,
        x: image.width - 450,
        y: image.height - 80,
        color: img.ColorRgba8(255, 255, 255, 200), // 白色半透明
      );

      // 5. 将处理后的图存入临时目录
      final tempDir = await getTemporaryDirectory();
      final watermarkedFile = File(
        '${tempDir.path}/wm_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      return await watermarkedFile.writeAsBytes(
        img.encodeJpg(image, quality: 60),
      );
    }

    return originFile;
  }
}
