// 微信底部弹出框
import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/divider_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/utils/picker.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class HJBottomSheet {
  // 选择拍摄、相机资源
  static Future wxPicker(
    BuildContext context,
    List<AssetEntity>? selectedAssets,
    int? maxAssets,
  ) {
    return Picker.showModalSheet(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            Text(S.of(context).takePhoto, style: TextStyle(fontSize: 14.px)),
            onTap: () {
              final result = Picker.assetsCamera(context: context);
              result.then((value) {
                if (value != null) {
                  selectedAssets!.add(value);
                }
                Navigator.pop(context, selectedAssets);
              });
            },
          ),
          DividerWidget(),
          _buildButton(
            Text(S.of(context).photoAlbum, style: TextStyle(fontSize: 14.px)),
            onTap: () {
              final result = Picker.assets(
                context: context,
                maxAssets: maxAssets ?? 6,
              );
              result.then((value) {
                Navigator.pop(context, value);
              });
            },
          ),
          DividerWidget(height: 5.px),
          _buildButton(
            Text(S.of(context).cancel, style: TextStyle(fontSize: 14.px)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  static InkWell _buildButton(Widget child, {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 36.px,
        child: child,
      ),
    );
  }
}
