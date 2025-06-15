import 'package:flutter/material.dart';
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
    int? maxAssets,
  }) async {
    print('maxAssets: $maxAssets');
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        requestType: RequestType.image,
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
}
